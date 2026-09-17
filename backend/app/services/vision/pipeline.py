"""
Image Station Pipeline for SIH-090
Role: Kaustubh Sinha (Vision and Voice)

Implements Stage 5 (Image Processing Station) and Stage 3 (Quality Gatekeeper).
Features:
- Quality assessment: Blur detection (Laplacian + Canny fallback), ROI lighting (Otsu)
- Color cast removal: Gray-World white balancing
- Background removal: IS-Net ONNX model via rembg
- Framing: Centered 80% coverage on pure white canvas with soft ground contact shadow
- Outputs: 1024x1024 master, 256x256 thumbnail, RGBA cutout
"""

import os
import time
import logging
from logging.handlers import RotatingFileHandler
from typing import Dict, Any, Optional
from pathlib import Path

# Set model cache directory inside workspace so models are accessible if not defined
WORKSPACE_MODELS_DIR = Path(__file__).resolve().parent / ".models"
if "U2NET_HOME" not in os.environ and WORKSPACE_MODELS_DIR.exists():
    os.environ["U2NET_HOME"] = str(WORKSPACE_MODELS_DIR)

# Safe logging directory setup
LOGS_DIR = Path(__file__).resolve().parent / "logs"
try:
    LOGS_DIR.mkdir(parents=True, exist_ok=True)
    LOG_FILE_PATH = LOGS_DIR / "pipeline.log"
except (PermissionError, OSError):
    LOG_FILE_PATH = None


def setup_logger(name: str = "ImageStation") -> logging.Logger:
    logger = logging.getLogger(name)
    if logger.handlers:
        return logger

    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)-8s | [%(item_id)s] %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )

    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    if LOG_FILE_PATH is not None:
        try:
            file_handler = RotatingFileHandler(
                LOG_FILE_PATH, maxBytes=5 * 1024 * 1024, backupCount=3, encoding="utf-8"
            )
            file_handler.setLevel(logging.INFO)
            file_handler.setFormatter(formatter)
            logger.addHandler(file_handler)
        except (PermissionError, OSError):
            pass

    return logger


class ItemIdAdapter(logging.LoggerAdapter):
    def process(self, msg, kwargs):
        item_id = kwargs.pop("item_id", self.extra.get("item_id", "system"))
        kwargs["extra"] = {"item_id": item_id}
        return msg, kwargs


logger = setup_logger()

import cv2
import numpy as np
from PIL import Image, ImageFilter
import rembg


class ImageStation:
    def __init__(self, model_name: str = "isnet-general-use"):
        self.model_name = model_name
        self.session = None

    def _get_session(self):
        if self.session is None:
            self.session = rembg.new_session(self.model_name)
        return self.session

    @staticmethod
    def _compute_roi_brightness(gray: np.ndarray) -> float:
        _, mask = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        white_pixel_count = cv2.countNonZero(mask)
        total_pixels = gray.size

        if white_pixel_count < 0.05 * total_pixels or white_pixel_count > 0.95 * total_pixels:
            return float(np.mean(gray))

        roi_mean = cv2.mean(gray, mask=mask)[0]
        return float(roi_mean)

    @staticmethod
    def assess_quality(image_input) -> Dict[str, Any]:
        if isinstance(image_input, (str, Path)):
            img_path = str(image_input)
            img_bgr = cv2.imread(img_path)
            if img_bgr is None:
                return {
                    "passed": False,
                    "blur_score": 0.0,
                    "edge_density": 0.0,
                    "brightness_score": 0.0,
                    "roi_brightness_score": 0.0,
                    "is_blurry": True,
                    "is_too_dark": True,
                    "is_too_bright": False,
                    "warnings": [f"Could not load image at {img_path}"]
                }
        elif isinstance(image_input, np.ndarray):
            img_bgr = image_input
        elif isinstance(image_input, Image.Image):
            img_rgb = np.array(image_input.convert("RGB"))
            img_bgr = cv2.cvtColor(img_rgb, cv2.COLOR_RGB2BGR)
        else:
            raise TypeError("image_input must be a file path, cv2 numpy array, or PIL Image.")

        gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)
        laplacian_var = float(cv2.Laplacian(gray, cv2.CV_64F).var())

        edges = cv2.Canny(gray, 50, 150)
        edge_density = float(np.count_nonzero(edges) / edges.size)

        brightness_score = float(np.mean(gray))
        roi_brightness_score = ImageStation._compute_roi_brightness(gray)

        is_blurry = laplacian_var < 30.0
        if not is_blurry and laplacian_var < 40.0:
            if edge_density < 0.005:
                is_blurry = True

        is_too_dark = roi_brightness_score < 55.0
        is_too_bright = roi_brightness_score > 185.0

        warnings = []
        if is_blurry:
            warnings.append(
                f"Image is too blurry (Laplacian variance: {laplacian_var:.1f}, "
                f"edge density: {edge_density:.4f}). Minimum variance required: 30.0."
            )
        if is_too_dark:
            warnings.append(
                f"Subject is too dark (ROI brightness: {roi_brightness_score:.1f}/255, "
                f"overall: {brightness_score:.1f}/255). Floor threshold: 55.0."
            )
        if is_too_bright:
            warnings.append(
                f"Subject is overexposed (ROI brightness: {roi_brightness_score:.1f}/255). "
                f"Ceiling threshold: 185.0."
            )

        passed = not (is_blurry or is_too_dark or is_too_bright)

        return {
            "passed": passed,
            "blur_score": round(laplacian_var, 2),
            "edge_density": round(edge_density, 4),
            "brightness_score": round(brightness_score, 2),
            "roi_brightness_score": round(roi_brightness_score, 2),
            "is_blurry": is_blurry,
            "is_too_dark": is_too_dark,
            "is_too_bright": is_too_bright,
            "warnings": warnings
        }

    @staticmethod
    def correct_color_cast(image: Image.Image) -> Image.Image:
        np_img = np.array(image.convert("RGB"), dtype=np.float32)
        mean_r = np.mean(np_img[:, :, 0])
        mean_g = np.mean(np_img[:, :, 1])
        mean_b = np.mean(np_img[:, :, 2])
        gray_mean = (mean_r + mean_g + mean_b) / 3.0

        if mean_r == 0 or mean_g == 0 or mean_b == 0:
            return image

        scale_r = gray_mean / mean_r
        scale_g = gray_mean / mean_g
        scale_b = gray_mean / mean_b

        np_img[:, :, 0] = np.clip(np_img[:, :, 0] * scale_r, 0, 255)
        np_img[:, :, 1] = np.clip(np_img[:, :, 1] * scale_g, 0, 255)
        np_img[:, :, 2] = np.clip(np_img[:, :, 2] * scale_b, 0, 255)

        return Image.fromarray(np_img.astype(np.uint8))

    def remove_background(self, image: Image.Image) -> Image.Image:
        session = self._get_session()
        cutout = rembg.remove(image, session=session)
        return cutout

    @staticmethod
    def composite_to_marketplace_spec(
        cutout: Image.Image,
        target_size: int = 1024,
        padding_ratio: float = 0.10,
        alpha_threshold: int = 25,
        shadow_blur: int = 16,
        shadow_opacity: float = 0.20,
        shadow_offset_y: int = 10,
    ) -> Image.Image:
        if cutout.mode != "RGBA":
            cutout = cutout.convert("RGBA")

        alpha = np.array(cutout.split()[-1])
        non_zero_coords = np.argwhere(alpha > alpha_threshold)

        if non_zero_coords.size == 0:
            return Image.new("RGB", (target_size, target_size), (255, 255, 255))

        y0, x0 = non_zero_coords.min(axis=0)
        y1, x1 = non_zero_coords.max(axis=0) + 1
        cropped_cutout = cutout.crop((x0, y0, x1, y1))

        content_w = x1 - x0
        content_h = y1 - y0
        max_allowed_dim = int(target_size * (1.0 - 2 * padding_ratio))

        scale = min(max_allowed_dim / content_w, max_allowed_dim / content_h)
        new_w = max(1, int(content_w * scale))
        new_h = max(1, int(content_h * scale))

        scaled_cutout = cropped_cutout.resize((new_w, new_h), resample=Image.Resampling.LANCZOS)

        pos_x = (target_size - new_w) // 2
        pos_y = (target_size - new_h) // 2

        scaled_alpha = scaled_cutout.split()[-1]
        shadow_alpha = scaled_alpha.point(lambda p: int(p * shadow_opacity) if p > 0 else 0)
        black_img = Image.new("RGBA", (new_w, new_h), (0, 0, 0, 0))
        black_img.putalpha(shadow_alpha)

        shadow_canvas = Image.new("RGBA", (target_size, target_size), (0, 0, 0, 0))
        shadow_x = pos_x
        shadow_y = min(target_size - new_h, pos_y + shadow_offset_y)
        shadow_canvas.paste(black_img, (shadow_x, shadow_y), black_img)
        shadow_blurred = shadow_canvas.filter(ImageFilter.GaussianBlur(radius=shadow_blur))

        canvas = Image.new("RGB", (target_size, target_size), (255, 255, 255))
        canvas.paste(shadow_blurred, (0, 0), shadow_blurred)
        canvas.paste(scaled_cutout, (pos_x, pos_y), scaled_cutout)

        return canvas

    def process_image(
        self,
        input_path: str,
        output_dir: str,
        item_id: Optional[str] = None
    ) -> Dict[str, Any]:
        start_time = time.perf_counter()
        input_path_obj = Path(input_path)
        item_prefix = item_id or input_path_obj.stem
        out_dir_obj = Path(output_dir)
        out_dir_obj.mkdir(parents=True, exist_ok=True)

        logger.info(f"Processing image: {input_path_obj.name} -> item_id: {item_prefix}", extra={"item_id": item_prefix})

        # Step 1: Quality assessment
        quality_report = self.assess_quality(str(input_path_obj))
        if not quality_report["passed"]:
            logger.warning(
                f"Quality gate rejected: {'; '.join(quality_report['warnings'])} "
                f"(blur_score={quality_report['blur_score']:.1f}, "
                f"ROI_brightness={quality_report['roi_brightness_score']:.1f})",
                extra={"item_id": item_prefix}
            )
            # EARLY RETURN: Save CPU time if photo failed quality
            return {
                "item_id": item_prefix,
                "elapsed_seconds": round(time.perf_counter() - start_time, 2),
                "quality": quality_report,
                "outputs": {},
            }

        logger.info(
            f"Quality gate passed (blur_score={quality_report['blur_score']:.1f}, "
            f"ROI_brightness={quality_report['roi_brightness_score']:.1f})",
            extra={"item_id": item_prefix}
        )

        # Step 2: Color cast correction
        raw_pil = Image.open(input_path_obj).convert("RGB")
        color_corrected = self.correct_color_cast(raw_pil)

        # Step 3: Background removal
        cutout = self.remove_background(color_corrected)

        # Step 4: Marketplace compositing
        clean_canvas = self.composite_to_marketplace_spec(cutout)

        # Step 5: Mobile thumbnail
        thumb = clean_canvas.resize((256, 256), resample=Image.Resampling.LANCZOS)

        # Step 6: Save assets
        clean_path = out_dir_obj / f"{item_prefix}_clean.jpg"
        thumb_path = out_dir_obj / f"{item_prefix}_thumb.jpg"
        cutout_path = out_dir_obj / f"{item_prefix}_cutout.png"

        clean_canvas.save(clean_path, "JPEG", quality=95, optimize=True)
        thumb.save(thumb_path, "JPEG", quality=85, optimize=True)
        cutout.save(cutout_path, "PNG", optimize=True)

        elapsed = time.perf_counter() - start_time
        logger.info(f"Done in {elapsed:.2f}s -> Saved: {clean_path.name}", extra={"item_id": item_prefix})

        return {
            "item_id": item_prefix,
            "elapsed_seconds": round(elapsed, 2),
            "quality": quality_report,
            "outputs": {
                "clean_image": str(clean_path),
                "thumbnail": str(thumb_path),
                "cutout_alpha": str(cutout_path),
            }
        }