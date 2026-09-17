"""
Image Station Pipeline for SIH26090
Role: Kaustubh Sinha (Vision and Voice)

Performs:
1. Quality Check (Blur via Laplacian variance, Brightness/Exposure analysis)
2. Color Cast Correction (Single bulb / warm light compensation)
3. Background Removal (rembg with isnet-general-use on CPU)
4. Realistic Ground / Contact Soft Shadow
5. Bounding Box Auto-crop & 1:1 Square White Studio Composite (Marketplace Spec)
6. Thumbnail Generation (256x256)
"""

import os
import time
import logging
from logging.handlers import RotatingFileHandler
from typing import Dict, Any, Tuple, Optional
from pathlib import Path

# Set model cache directory inside workspace so models are accessible
WORKSPACE_MODELS_DIR = Path(__file__).resolve().parent / ".models"
WORKSPACE_MODELS_DIR.mkdir(parents=True, exist_ok=True)
os.environ["U2NET_HOME"] = str(WORKSPACE_MODELS_DIR)

# Configure logging directory and rotating file handler
LOGS_DIR = Path(__file__).resolve().parent / "logs"
LOGS_DIR.mkdir(parents=True, exist_ok=True)
LOG_FILE_PATH = LOGS_DIR / "pipeline.log"


class ItemLogFormatter(logging.Formatter):
    """
    Ensures %(item_id)s is present in every log record.
    Defaults to '-' when not provided in extra={'item_id': ...}.
    """
    def format(self, record):
        if not hasattr(record, "item_id"):
            record.item_id = "-"
        return super().format(record)


def setup_logger(log_level=logging.INFO) -> logging.Logger:
    log = logging.getLogger("image_station")
    log.setLevel(log_level)
    if not log.handlers:
        formatter = ItemLogFormatter(
            fmt="%(asctime)s | %(levelname)-8s | [%(item_id)s] %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S"
        )
        # 1. Rotating File Handler (5 MB max, 3 backups)
        file_handler = RotatingFileHandler(
            LOG_FILE_PATH,
            maxBytes=5 * 1024 * 1024,
            backupCount=3,
            encoding="utf-8"
        )
        file_handler.setLevel(log_level)
        file_handler.setFormatter(formatter)
        log.addHandler(file_handler)

        # 2. Console Stream Handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(log_level)
        console_handler.setFormatter(formatter)
        log.addHandler(console_handler)
    return log


logger = setup_logger()

import cv2
import numpy as np
from PIL import Image, ImageFilter, ImageOps
import rembg


class ImageStation:
    def __init__(self, model_name: str = "isnet-general-use"):
        """
        Initializes the ImageStation with rembg session.
        Uses 'isnet-general-use' as specified in PRD §4.4.
        """
        self.model_name = model_name
        self.session = None  # Lazy load session on first use

    def _get_session(self):
        if self.session is None:
            self.session = rembg.new_session(self.model_name)
        return self.session

    @staticmethod
    def _compute_roi_brightness(gray: np.ndarray) -> float:
        """
        Computes brightness on the foreground subject only, using Otsu's
        thresholding to separate foreground from background.  Falls back to
        whole-frame mean if Otsu yields an empty or near-empty mask.
        """
        # Otsu gives a binary mask where foreground pixels are white
        _, mask = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

        # Pick the side (fg or bg) that is the minority — typically the subject
        fg_count = int(np.count_nonzero(mask))
        bg_count = mask.size - fg_count
        if fg_count == 0 or bg_count == 0:
            return float(np.mean(gray))

        # If the foreground (white in mask) is the majority, invert — the
        # subject is usually the smaller region.
        if fg_count > bg_count:
            mask = cv2.bitwise_not(mask)

        roi_pixels = gray[mask > 0]
        if len(roi_pixels) == 0:
            return float(np.mean(gray))
        return float(np.mean(roi_pixels))

    @staticmethod
    def _compute_edge_density(gray: np.ndarray) -> float:
        """
        Returns the fraction of pixels that are Canny edges (0.0–1.0).
        Used as a secondary blur check for fine-textured objects whose
        Laplacian variance is misleadingly low.
        """
        edges = cv2.Canny(gray, 50, 150)
        return float(np.count_nonzero(edges)) / edges.size

    @staticmethod
    def assess_quality(
        image_path: str,
        blur_threshold: float = 30.0,
        dark_threshold: float = 55.0,
        bright_threshold: float = 185.0,
        borderline_blur_ceiling: float = 40.0,
        edge_density_threshold: float = 0.005,
    ) -> Dict[str, Any]:
        """
        Evaluates whether an image is too dark, overexposed, or too blurry.
        Corresponds to the on-phone quality check filter (PRD §4.1 / §4.4).

        Brightness is measured on the detected foreground ROI (Otsu mask) so
        that dark-background compositions are not penalised.

        When the Laplacian blur score falls in the borderline zone (below
        ``borderline_blur_ceiling``), a secondary Canny edge-density check
        runs to rescue fine-textured objects that fool Laplacian alone.
        """
        img_bgr = cv2.imread(image_path)
        if img_bgr is None:
            raise ValueError(f"Could not load image at {image_path}")

        gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)

        # --- 1. Blur: Laplacian variance + Canny edge-density fallback ---
        laplacian_var = float(cv2.Laplacian(gray, cv2.CV_64F).var())
        edge_density = ImageStation._compute_edge_density(gray)

        if laplacian_var >= borderline_blur_ceiling:
            # Clearly sharp — no secondary check needed
            is_blurry = False
        elif laplacian_var >= blur_threshold:
            # In the borderline zone (blur_threshold ≤ score < ceiling):
            # use edge density as tiebreaker
            is_blurry = edge_density < edge_density_threshold
        else:
            # Below blur_threshold: check if high edge density rescues it
            # (fine-textured but sharp objects can score very low on Laplacian)
            is_blurry = edge_density < edge_density_threshold

        # --- 2. Brightness ---
        # Dark check: use ROI (foreground-only via Otsu) so dark backgrounds
        # don't penalise a well-lit subject (fixes real_pottery_good_2).
        # Overexposure check: use whole-frame brightness — when the entire
        # frame is blown out the Otsu ROI can't reliably isolate the problem.
        whole_frame_brightness = float(np.mean(gray))
        roi_brightness = ImageStation._compute_roi_brightness(gray)
        is_too_dark = roi_brightness < dark_threshold
        is_too_bright = whole_frame_brightness > bright_threshold

        # --- 3. Overall pass/fail ---
        passed = (not is_blurry) and (not is_too_dark) and (not is_too_bright)

        warnings = []
        if is_blurry:
            warnings.append(
                f"Image may be blurry (Laplacian: {laplacian_var:.1f}, "
                f"edge density: {edge_density:.4f})"
            )
        if is_too_dark:
            warnings.append(
                f"Image is too dark (ROI brightness: {roi_brightness:.1f} "
                f"< {dark_threshold}, whole-frame: {whole_frame_brightness:.1f})"
            )
        if is_too_bright:
            warnings.append(
                f"Image is overexposed (whole-frame: {whole_frame_brightness:.1f} "
                f"> {bright_threshold})"
            )

        return {
            "passed": passed,
            "blur_score": laplacian_var,
            "edge_density": edge_density,
            "brightness_score": whole_frame_brightness,
            "roi_brightness_score": roi_brightness,
            "is_blurry": is_blurry,
            "is_too_dark": is_too_dark,
            "is_too_bright": is_too_bright,
            "warnings": warnings,
        }

    @staticmethod
    def correct_color_cast(pil_image: Image.Image) -> Image.Image:
        """
        Corrects color cast from single incandescent/warm bulb lighting
        using Gray-World white balancing algorithm.
        """
        img_np = np.array(pil_image)
        has_alpha = (img_np.ndim == 3 and img_np.shape[2] == 4)

        if has_alpha:
            rgb = img_np[:, :, :3]
            alpha = img_np[:, :, 3]
        else:
            rgb = img_np

        # Compute channel means
        r_mean = np.mean(rgb[:, :, 0])
        g_mean = np.mean(rgb[:, :, 1])
        b_mean = np.mean(rgb[:, :, 2])
        gray_mean = (r_mean + g_mean + b_mean) / 3.0

        if r_mean == 0 or g_mean == 0 or b_mean == 0:
            return pil_image

        # Scale channels to normalize to gray mean with smooth saturation clipping
        scale_r = gray_mean / r_mean
        scale_g = gray_mean / g_mean
        scale_b = gray_mean / b_mean

        # Mild dampening to avoid over-correcting natural warm craft materials (e.g. terracotta)
        dampen = 0.7
        scale_r = 1.0 + dampen * (scale_r - 1.0)
        scale_g = 1.0 + dampen * (scale_g - 1.0)
        scale_b = 1.0 + dampen * (scale_b - 1.0)

        balanced_rgb = np.zeros_like(rgb, dtype=np.float32)
        balanced_rgb[:, :, 0] = np.clip(rgb[:, :, 0] * scale_r, 0, 255)
        balanced_rgb[:, :, 1] = np.clip(rgb[:, :, 1] * scale_g, 0, 255)
        balanced_rgb[:, :, 2] = np.clip(rgb[:, :, 2] * scale_b, 0, 255)

        balanced_np = balanced_rgb.astype(np.uint8)

        if has_alpha:
            balanced_np = np.dstack((balanced_np, alpha))

        return Image.fromarray(balanced_np)

    def remove_background(self, pil_image: Image.Image) -> Image.Image:
        """
        Cuts out the object from its background using rembg (isnet-general-use).
        Returns RGBA image.
        """
        session = self._get_session()
        cutout = rembg.remove(pil_image, session=session)
        return cutout

    @staticmethod
    def create_soft_shadow(cutout: Image.Image, 
                           shadow_blur: int = 20, 
                           shadow_opacity: float = 0.30, 
                           offset_y: int = 10) -> Image.Image:
        """
        Creates a realistic ground/contact soft shadow from the cutout's alpha channel.
        """
        if cutout.mode != "RGBA":
            cutout = cutout.convert("RGBA")

        # Extract alpha channel
        alpha = cutout.split()[3]

        # Generate shadow mask: black image with the cutout's alpha modulated by shadow_opacity
        shadow_mask = alpha.point(lambda p: int(p * shadow_opacity))
        shadow = Image.new("RGBA", cutout.size, (0, 0, 0, 0))
        shadow_layer = Image.new("RGBA", cutout.size, (25, 25, 25, 255))
        shadow.paste(shadow_layer, (0, 0), mask=shadow_mask)

        # Apply Gaussian blur for soft shadow dissipation
        shadow = shadow.filter(ImageFilter.GaussianBlur(shadow_blur))

        # Shift shadow slightly downward to simulate overhead/slight angle lighting
        shifted_shadow = Image.new("RGBA", cutout.size, (0, 0, 0, 0))
        shifted_shadow.paste(shadow, (0, offset_y))

        return shifted_shadow

    @staticmethod
    def composite_to_marketplace_spec(
        cutout: Image.Image,
        shadow: Optional[Image.Image] = None,
        target_size: int = 1024,
        padding_ratio: float = 0.10,
        alpha_threshold: int = 25,
        shadow_blur: int = 16,
        shadow_opacity: float = 0.28,
        shadow_offset_y: int = 10,
    ) -> Image.Image:
        """
        Centers and crops product into a 1:1 square canvas on pure white background (#FFFFFF)
        with standard marketplace padding (default padding_ratio=0.10, yielding 80% product coverage).

        - Uses alpha_threshold (default 25) to eliminate faint transparent fringe from rembg cutouts.
        - Computes product's true center and dimensions FIRST, placing it exactly in the canvas center.
        - Adds soft contact shadow separately as an aesthetic layer without distorting the centering math.
        """
        if cutout.mode != "RGBA":
            cutout = cutout.convert("RGBA")

        # 1. Get bounding box of the non-transparent product cutout (filtering faint alpha fringe)
        alpha = cutout.split()[3]
        alpha_thresh = alpha.point(lambda p: 255 if p > alpha_threshold else 0)
        bbox = alpha_thresh.getbbox()
        if not bbox:
            bbox = alpha.getbbox() or (0, 0, cutout.width, cutout.height)

        # 2. Crop cutout to the product bbox
        obj_width = bbox[2] - bbox[0]
        obj_height = bbox[3] - bbox[1]
        cropped_cutout = cutout.crop(bbox)

        # 3. Calculate scale to fit inside target square with proportional padding
        max_dim = max(obj_width, obj_height)
        usable_canvas_size = int(target_size * (1.0 - 2 * padding_ratio))
        scale = usable_canvas_size / max_dim

        new_width = int(obj_width * scale)
        new_height = int(obj_height * scale)
        resized_cutout = cropped_cutout.resize((new_width, new_height), Image.Resampling.LANCZOS)

        # 4. Compute exact product centering placement (independent of shadow)
        pos_x = (target_size - new_width) // 2
        pos_y = (target_size - new_height) // 2

        # 5. Create white background canvas
        canvas = Image.new("RGBA", (target_size, target_size), (255, 255, 255, 255))

        # 6. Generate and composite soft shadow underneath product
        product_alpha = resized_cutout.split()[3]
        shadow_mask = product_alpha.point(lambda p: int(p * shadow_opacity))
        shadow_layer = Image.new("RGBA", (new_width, new_height), (30, 30, 30, 255))

        shadow_canvas = Image.new("RGBA", (target_size, target_size), (0, 0, 0, 0))
        shadow_y = min(pos_y + shadow_offset_y, target_size - new_height)
        shadow_canvas.paste(shadow_layer, (pos_x, shadow_y), mask=shadow_mask)
        shadow_canvas = shadow_canvas.filter(ImageFilter.GaussianBlur(shadow_blur))

        canvas.paste(shadow_canvas, (0, 0), mask=shadow_canvas)

        # 7. Paste product cutout at exact centered position
        canvas.paste(resized_cutout, (pos_x, pos_y), mask=resized_cutout)

        # Convert back to RGB for final marketplace output
        return canvas.convert("RGB")

    def process_image(
        self,
        input_path: str,
        output_dir: str,
        item_id: Optional[str] = None,
        target_size: int = 1024,
        thumbnail_size: int = 256,
        padding_ratio: float = 0.10,
        alpha_threshold: int = 25,
    ) -> Dict[str, Any]:
        """
        Full end-to-end Image Station pipeline:
        1. Assess quality (blur & lighting)
        2. Load & Correct color cast
        3. Remove background
        4. Decoupled soft shadow & studio composite onto square white canvas
        5. Generate thumbnail (256x256)
        """
        start_time = time.time()
        input_path_obj = Path(input_path)
        if not input_path_obj.exists():
            raise FileNotFoundError(f"Input file not found: {input_path}")

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
                f"ROI_brightness={quality_report['roi_brightness_score']:.1f}, "
                f"whole_brightness={quality_report['brightness_score']:.1f})",
                extra={"item_id": item_prefix}
            )
        else:
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

        # Step 4 & 5: Studio composite onto pure white with soft shadow
        final_image = self.composite_to_marketplace_spec(
            cutout=cutout,
            target_size=target_size,
            padding_ratio=padding_ratio,
            alpha_threshold=alpha_threshold,
        )

        # Step 6: Thumbnail
        thumbnail = final_image.copy()
        thumbnail.thumbnail((thumbnail_size, thumbnail_size), Image.Resampling.LANCZOS)

        # Save files
        clean_image_filename = f"{item_prefix}_clean.jpg"
        clean_image_path = out_dir_obj / clean_image_filename
        final_image.save(clean_image_path, "JPEG", quality=92, optimize=True)

        thumbnail_filename = f"{item_prefix}_thumb.jpg"
        thumbnail_path = out_dir_obj / thumbnail_filename
        thumbnail.save(thumbnail_path, "JPEG", quality=85, optimize=True)

        raw_cutout_filename = f"{item_prefix}_cutout.png"
        raw_cutout_path = out_dir_obj / raw_cutout_filename
        cutout.save(raw_cutout_path, "PNG")

        elapsed = time.time() - start_time
        logger.info(
            f"Successfully processed in {elapsed:.2f}s -> clean: {clean_image_filename}, thumb: {thumbnail_filename}",
            extra={"item_id": item_prefix}
        )

        return {
            "item_id": item_prefix,
            "elapsed_seconds": round(elapsed, 2),
            "quality": quality_report,
            "outputs": {
                "clean_image": str(clean_image_path),
                "thumbnail": str(thumbnail_path),
                "cutout_alpha": str(raw_cutout_path),
            }
        }


    def process_batch(
        self,
        input_paths: list,
        output_dir: str,
        item_ids: Optional[list] = None,
        target_size: int = 1024,
        thumbnail_size: int = 256,
        padding_ratio: float = 0.10,
        alpha_threshold: int = 25,
    ) -> Dict[str, Any]:
        """
        Processes multiple images sequentially through the Image Station pipeline.

        - Reuses process_image() in a loop without duplicating pipeline logic.
        - Auto-generates sequential IDs (item_001, item_002, ...) if item_ids is not provided.
        - Fault-tolerant: if any image errors (e.g. corrupt or unreadable file), the exception
          is caught and recorded in that item's result, allowing remaining images to continue.
        - Returns a structured dictionary containing per-item results and a batch summary.
        """
        batch_start_time = time.time()
        out_dir_obj = Path(output_dir)
        out_dir_obj.mkdir(parents=True, exist_ok=True)

        logger.info(f"Starting batch processing of {len(input_paths)} images -> output: {output_dir}", extra={"item_id": "BATCH"})

        items_results = []
        total_passed = 0
        total_failed_quality = 0
        total_errors = 0

        for idx, input_path in enumerate(input_paths):
            if item_ids and idx < len(item_ids) and item_ids[idx]:
                current_id = item_ids[idx]
            else:
                current_id = f"item_{idx + 1:03d}"

            try:
                res = self.process_image(
                    input_path=str(input_path),
                    output_dir=output_dir,
                    item_id=current_id,
                    target_size=target_size,
                    thumbnail_size=thumbnail_size,
                    padding_ratio=padding_ratio,
                    alpha_threshold=alpha_threshold,
                )
                if res.get("quality", {}).get("passed", False):
                    total_passed += 1
                else:
                    total_failed_quality += 1
                items_results.append(res)
            except Exception as e:
                total_errors += 1
                error_msg = f"{type(e).__name__}: {str(e)}"
                logger.error(
                    f"Failed to process {input_path}: {error_msg}",
                    exc_info=True,
                    extra={"item_id": current_id}
                )
                items_results.append({
                    "item_id": current_id,
                    "input_path": str(input_path),
                    "error": error_msg,
                    "success": False,
                    "quality": None,
                    "outputs": None,
                })

        total_elapsed = round(time.time() - batch_start_time, 2)
        logger.info(
            f"Batch completed: {len(input_paths)} total, {total_passed} passed quality, "
            f"{total_failed_quality} failed quality, {total_errors} errors in {total_elapsed}s "
            f"(avg {round(total_elapsed / len(input_paths), 2) if input_paths else 0}s/img)",
            extra={"item_id": "BATCH"}
        )

        return {
            "summary": {
                "total_processed": len(input_paths),
                "total_passed_quality": total_passed,
                "total_failed_quality": total_failed_quality,
                "total_errors": total_errors,
                "total_elapsed_seconds": total_elapsed,
                "average_seconds_per_image": round(total_elapsed / len(input_paths), 2) if input_paths else 0.0,
            },
            "items": items_results,
        }


if __name__ == "__main__":
    import argparse
    import json

    parser = argparse.ArgumentParser(description="Image Station Processor (SIH26090)")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--input", "-i", type=str, help="Path to a single raw input image")
    group.add_argument("--input-dir", "-d", type=str, help="Directory containing images to process in batch")

    parser.add_argument("--output-dir", "-o", type=str, default="output", help="Directory to save outputs")
    parser.add_argument("--item-id", type=str, default=None, help="Identifier for the item (single-image mode)")
    parser.add_argument("--extensions", type=str, default="jpg,jpeg,png,webp", help="Comma-separated image extensions for --input-dir")
    args = parser.parse_args()

    station = ImageStation()

    if args.input_dir:
        exts = [e.strip().lower() for e in args.extensions.split(",")]
        in_dir = Path(args.input_dir)
        files = []
        for ext in exts:
            files.extend(sorted(in_dir.glob(f"*.{ext}")))
            files.extend(sorted(in_dir.glob(f"*.{ext.upper()}")))
        unique_files = sorted(list(dict.fromkeys(files)))
        
        result = station.process_batch(
            input_paths=unique_files,
            output_dir=args.output_dir,
        )
        logger.info("Pipeline batch execution completed successfully:\n%s", json.dumps(result["summary"], indent=2))
    else:
        result = station.process_image(args.input, args.output_dir, args.item_id)
        logger.info("Pipeline single-image execution completed successfully:\n%s", json.dumps(result, indent=2))
