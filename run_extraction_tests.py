"""
run_extraction_tests.py — Runs extraction against all 15 test transcripts
and checks the output against expected values.

Per the project doc's rule: run this after every prompt change to
`extract.py`. This is the evidence that extraction isn't inventing values.

NOTE: this DOES call the Gemini API (one call per test case = 15 calls).
Don't run this while your daily quota is exhausted — wait for reset,
or run just a few cases at a time using the --limit option described below.
"""

import sys
import time
from extract import extract_fact_sheet
from test_transcripts import TEST_CASES

SECONDS_BETWEEN_CASES = 13  # keeps us under the 5-requests-per-minute free tier limit


def check_case(case: dict) -> dict:
    """
    Runs extraction on one test case and checks:
      1. Every expected field matches (or is a reasonable match)
      2. No unexpected field got filled in that wasn't in 'expected'
         (this catches hallucination/invention)
    """
    sheet = extract_fact_sheet(case["transcript"])
    sheet_dict = sheet.model_dump()

    expected = case["expected"]
    mismatches = []
    unexpected_fills = []

    # Check expected fields are present and roughly correct
    for field, expected_value in expected.items():
        actual_value = sheet_dict.get(field)
        if actual_value is None:
            mismatches.append(f"  expected {field}={expected_value!r}, got None (missed)")
        elif isinstance(expected_value, str) and isinstance(actual_value, str):
            # loose case-insensitive substring check for text fields
            if expected_value.lower() not in actual_value.lower() and \
               actual_value.lower() not in expected_value.lower():
                mismatches.append(f"  expected {field}~={expected_value!r}, got {actual_value!r}")
        elif actual_value != expected_value:
            mismatches.append(f"  expected {field}={expected_value!r}, got {actual_value!r}")

    # Check nothing got filled that wasn't expected (possible hallucination)
    extractable_fields = [
        "product_name", "category", "materials", "dimensions", "color",
        "cost_of_materials", "hours_spent", "stock_count", "returnable",
    ]
    for field in extractable_fields:
        if field not in expected and sheet_dict.get(field) is not None:
            unexpected_fills.append(f"  {field}={sheet_dict[field]!r} was filled but not expected — check if this is invented or just a reasonable catch")

    return {
        "id": case["id"],
        "passed": len(mismatches) == 0,
        "mismatches": mismatches,
        "unexpected_fills": unexpected_fills,
        "raw_output": sheet_dict,
    }


def run_all(limit: int | None = None):
    cases = TEST_CASES[:limit] if limit else TEST_CASES
    results = []

    for i, case in enumerate(cases, 1):
        print(f"[{i}/{len(cases)}] Running {case['id']}...")
        try:
            result = check_case(case)
            results.append(result)
        except Exception as e:
            print(f"  ERROR: {e}")
            results.append({"id": case["id"], "passed": False, "error": str(e)})

        if i < len(cases):
            print(f"  (waiting {SECONDS_BETWEEN_CASES}s to stay under rate limit...)")
            time.sleep(SECONDS_BETWEEN_CASES)

    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    passed = sum(1 for r in results if r.get("passed"))
    print(f"{passed}/{len(results)} passed cleanly\n")

    for r in results:
        status = "PASS" if r.get("passed") else "CHECK"
        print(f"[{status}] {r['id']}")
        for m in r.get("mismatches", []):
            print(m)
        for u in r.get("unexpected_fills", []):
            print(u)
        if "error" in r:
            print(f"  ERROR: {r['error']}")

    return results


if __name__ == "__main__":
    # Usage: python run_extraction_tests.py         -> runs all 15
    #        python run_extraction_tests.py 3        -> runs only first 3 (saves quota)
    limit = int(sys.argv[1]) if len(sys.argv) > 1 else None
    run_all(limit=limit)