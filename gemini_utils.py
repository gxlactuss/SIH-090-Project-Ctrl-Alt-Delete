"""
gemini_utils.py — Shared retry wrapper for Gemini API calls
Language layer (temporarily built by Shivam, on behalf of Ayush Shivdikar's role)

Google's free-tier models occasionally return 503 (high demand) or 429
(rate limited) errors that are transient — retrying after a short wait
usually succeeds. This wraps every Gemini call so a random blip doesn't
crash the pipeline mid-demo.
"""

import re
import time
from google import genai
from google.genai import errors as genai_errors

RETRYABLE_STATUS_CODES = {429, 503}
MAX_RETRIES = 3
BASE_DELAY_SECONDS = 2  # doubles each retry: 2s, 4s, 8s — used only when
                          # the API doesn't tell us how long to wait


def _extract_retry_delay(error) -> float | None:
    """
    Gemini's 429 errors often include the exact wait time needed
    (e.g. "Please retry in 20.46s" / a structured retryDelay field).
    Use that instead of guessing, when available.
    """
    try:
        message = str(error)
        match = re.search(r"retry in (\d+(?:\.\d+)?)s", message)
        if match:
            return float(match.group(1)) + 1  # +1s buffer
    except Exception:
        pass
    return None


def generate_content_with_retry(client: genai.Client, **kwargs):
    """
    Drop-in wrapper for client.models.generate_content(**kwargs) that
    retries on transient errors (429 rate limit, 503 high demand) with
    exponential backoff. When the API tells us the exact wait time
    (common for 429s), we honor that instead of guessing.
    Raises the original error if all retries fail.
    """
    last_error = None

    for attempt in range(1, MAX_RETRIES + 1):
        try:
            return client.models.generate_content(**kwargs)
        except genai_errors.APIError as e:
            status_code = getattr(e, "code", None) or getattr(e, "status_code", None)
            last_error = e

            if status_code not in RETRYABLE_STATUS_CODES:
                raise  # not a transient error — fail immediately

            if attempt < MAX_RETRIES:
                suggested_delay = _extract_retry_delay(e)
                delay = suggested_delay or (BASE_DELAY_SECONDS * (2 ** (attempt - 1)))
                print(f"  [Gemini busy ({status_code}), retrying in {delay:.1f}s... "
                      f"attempt {attempt}/{MAX_RETRIES}]")
                time.sleep(delay)

    # all retries exhausted
    raise last_error