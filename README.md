# 🛍️ Kirtikar — Fact Sheet / Language Layer (SIH-090)

**Problem Statement**: Smart Cataloging and Multimodal Market Linkage for Marginalized Indian Artisans  
**Module**: Fact Sheet, Language Processing, Confidence & Price Advisor  
**Owner**: Shivam Singh

This module is the language and catalog-intelligence layer of Kirtikar. It takes an artisan's voice-note transcript, extracts only the facts that were actually stated, generates bilingual listing descriptions, checks whether required information is complete, and produces a deterministic price recommendation before ONDC publishing.

> **Core rule:** if the artisan did not state a value, the system does not invent it.

---

## 🏛️ Module Architecture

```text
factsheet/
├── factsheet_schema.py        # Shared Pydantic FactSheet contract
├── extract.py                 # Transcript → structured FactSheet
├── writer.py                  # FactSheet → English + Hindi descriptions
├── confidence.py              # Missing-field detection + suggestion approval
├── price_advisor.py           # Deterministic pricing engine
├── test_price_advisor.py      # Offline price-engine tests
├── gemini_utils.py            # Gemini retry/backoff wrapper
├── test_transcripts.py        # 15 extraction test transcripts
├── run_extraction_tests.py    # Extraction test runner
├── run_pipeline.py            # End-to-end language → ONDC demo
├── mapper.py                  # FactSheet → ONDC Item
├── ondc_schema.json           # ONDC schema validation
├── README.md                  # This document
└── .gitignore
```

---

## 🔄 Language & Catalog Pipeline

```text
Artisan Voice Transcript
          │
          ▼
   ┌───────────────┐
   │  Extraction   │  Gemini structured output
   └───────┬───────┘
           ▼
       FactSheet
           │
           ├───────────────┐
           ▼               ▼
      Description      Confidence
        Writer            Check
      EN + Hindi            │
           │                ▼
           │        Missing field?
           │          ┌─────┴─────┐
           │          │           │
           │         YES          NO
           │          │           │
           │          ▼           ▼
           │       Ask one      Continue
           │       question        │
           │                      ▼
           │                Price Advisor
           │                      │
           │                      ▼
           │               Suggested Price
           │                      │
           │              Artisan approval
           │                      │
           │                      ▼
           └──────────────► ONDC Mapper
                                  │
                                  ▼
                           ONDC Validation
```

The architecture places the Price Advisor after the Fact Sheet/Writer stage and before publishing, using a cost/hours floor plus a market reference band.

---

# 📋 FactSheet

`factsheet_schema.py` defines the shared data contract used by the language layer and ONDC mapper.

### Main fields

| Group | Fields |
|---|---|
| Identity | `item_id`, `product_name` |
| Description | `short_description`, `long_description`, `short_description_hi`, `long_description_hi` |
| Category | `category` |
| Attributes | `materials`, `dimensions`, `color` |
| Pricing | `cost_of_materials`, `hours_spent`, `price_final`, `price_mrp` |
| Stock | `stock_count`, `stock_max` |
| Seller policy | `returnable`, `return_window` |
| Pipeline state | `missing_fields`, `ready_to_publish` |

Required publication fields currently include:

```text
product_name
category
price_final
stock_count
```

Missing required values remain empty until obtained from the artisan.

---

# 🧠 Extraction

`extract.py` converts an already-transcribed English voice note into structured JSON using Gemini structured output.

### Extraction guarantees

- Only facts actually stated by the artisan are recorded.
- Missing fields remain `None`.
- No free-form guessing.
- Category normalization uses the project's standard internal categories.
- Structured Pydantic output keeps the response in the expected schema.

Example:

```text
"This is a clay pot, handmade. I used red clay from the local river.
It took me about three hours. I have five of these ready."
```

becomes approximately:

```json
{
  "product_name": "clay pot",
  "category": "pottery",
  "materials": "red clay from the local river",
  "hours_spent": 3,
  "stock_count": 5
}
```

Cost remains unknown because the artisan did not state it.

---

# ✍️ Description Writer

`writer.py` generates:

```text
English short description
English long description
Hindi short description
Hindi long description
```

The writer receives only the filled fact-sheet information.

It does **not** add unsupported claims such as:

```text
"premium"
"eco-friendly"
"sustainable"
"authentic"
"high quality"
```

unless such a claim is explicitly supported by the FactSheet.

---

# ✅ Confidence Check

`confidence.py` verifies the required fields before publishing.

```text
FactSheet
   ↓
find_missing_required()
   ↓
Missing fields?
   ├── Yes → ask ONE spoken question
   └── No  → ready_to_publish = True
```

The system deliberately asks one question at a time rather than guessing missing information.

### Suggested additions

Optional details are generated as suggestions only.

A suggestion is applied only after:

```text
approved = True
```

Skipping a suggestion leaves the FactSheet unchanged.

---

# 💰 Price Advisor

`price_advisor.py` is a **deterministic pricing engine**.

It does not call Gemini or any other LLM/API.

The pricing flow is:

```text
Material Cost + Labour Cost
              │
              ▼
          Cost Floor
              │
              ├───────────────┐
              │               │
              ▼               ▼
      Market Reference    Category Band
              │               │
              └───────┬───────┘
                      ▼
              Suggested Price
```

## 1. Labour Cost

```text
Labour Cost = Hours Spent × Hourly Rate
```

The current demo uses:

```text
Hourly Rate = ₹90/hour
```

This is a configurable benchmark proxy, not a universal Indian artisan wage. Production deployment should select a rate appropriate to the seller's state, craft and skill level.

---

## 2. Cost Floor

Unlike the earlier prototype, the current engine does **not** apply an arbitrary blanket 30% margin.

The current formula is:

```text
Cost Floor
= Material Cost + Labour Cost

= Material Cost + (Hours × Hourly Rate)
```

### Example

```text
Material Cost = ₹200
Hours         = 4
Hourly Rate   = ₹90/hour
```

Therefore:

```text
Labour Cost
= 4 × 90
= ₹360

Cost Floor
= 200 + 360
= ₹560
```

---

## 3. Market Reference

The current reference corpus uses observed IndiaHandmade product listings.

Instead of manually defining a "low / median / high" price, the engine calculates:

```text
Market Low    = P25
Market Median = P50
Market High   = P75
```

from the stored observations.

### Current observed categories

| Category | Sample size | P25 | Median | P75 |
|---|---:|---:|---:|---:|
| Pottery | 5 | ₹450 | ₹1200 | ₹1700 |
| Basket | 6 | ₹2111.75 | ₹2475 | ₹3250 |
| Kurta | 9 | ₹499 | ₹799 | ₹1500 |

> These are source-backed observations, not a claim that every product in a category should sell at those values. The current corpus is intentionally small and should be expanded with more comparable products before being treated as a broader market index.

---

## 4. Suggested Price Logic

### Cost below market P25

```text
Cost Floor < P25
→ Suggested Price = P25
```

Example:

```text
Pottery
Cost Floor = ₹270
P25         = ₹450

Suggested   = ₹450
```

### Cost inside the observed band

```text
P25 ≤ Cost Floor ≤ P75
→ Suggested Price = Cost Floor
```

Example:

```text
Cost Floor = ₹560
Pottery P25–P75 = ₹450–₹1700

Suggested = ₹560
```

### Cost above P75

```text
Cost Floor > P75
→ Suggested Price = Cost Floor
→ Market mismatch is flagged
```

The engine does not force the artisan below their calculated cost floor.

### Market-only case

When cost/hours are unavailable but sufficient market observations exist:

```text
Suggested Price = Market Median
Confidence = low
```

### Insufficient information

When neither cost information nor sufficient market observations exist:

```text
Suggested Price = None
Confidence = insufficient_data
```

No value is fabricated.

---

# 🔎 Price Engine Output

Example:

```json
{
  "floor": 270.0,
  "market_band": {
    "low": 450.0,
    "median": 1200.0,
    "high": 1700.0,
    "sample_size": 5,
    "source": "IndiaHandmade (Government of India, Ministry of Textiles)",
    "observed_on": "2026-09-21"
  },
  "suggested_price": 450.0,
  "confidence": "medium",
  "explanation": "Cost floor is below the observed P25 market reference..."
}
```

`price_advisor.py` returns the recommendation but does **not** modify:

```python
FactSheet.price_final
```

Production flow should read the recommendation back to the artisan and wait for approval/correction.

---

# 🔗 ONDC Integration

`mapper.py` converts the completed FactSheet into an ONDC Item.

```text
FactSheet
   ↓
ONDC Mapper
   ↓
Item JSON
   ↓
ONDC Schema Validation
```

The mapper expects, among other required values:

```text
price_final
stock_count
product_name
category
descriptions
images
```

The final demo pipeline successfully produces a valid ONDC item after the Price Advisor stage.

---

# 🧪 Testing

## Price Engine

Run the offline tests:

```powershell
python -m pytest test_price_advisor.py -q
```

Current suite:

```text
14 tests
```

The tests cover:

- material + labour calculation
- hours-only calculation
- missing inputs
- negative-value validation
- case-insensitive category lookup
- market-band calculation
- unknown category
- below-P25 recommendation
- inside-band recommendation
- above-P75 handling
- market-only pricing
- price-engine immutability

---

## Extraction Tests

The project contains 15 realistic transcript cases.

Run:

```powershell
python run_extraction_tests.py
```

The test runner also checks for unexpected fields being filled, helping detect possible hallucinated values.

---

## End-to-End Test

Run:

```powershell
python run_pipeline.py
```

Expected flow:

```text
STEP 1: Extraction
STEP 2: Description writer
STEP 3: Confidence check
STEP 4: Price advisor
STEP 5: Convert to dict and map to ONDC item
```

A successful final stage prints:

```text
Valid ONDC item produced!
```

---

# ⚙️ Setup

Install dependencies:

```powershell
pip install pydantic google-genai pandas jsonschema pytest
```

Set your Gemini API key in PowerShell:

```powershell
$env:GEMINI_API_KEY = "your-key-here"
```

The Price Advisor itself does not require the Gemini API key.

---

# ▶️ Quick Start

```powershell
# 1. Clone the repository
git clone https://github.com/gxlactuss/SIH-090-Project-Ctrl-Alt-Delete.git

# 2. Switch to the factsheet branch
git switch factsheet-shivam

# 3. Enter the module
cd factsheet

# 4. Install dependencies
pip install pydantic google-genai pandas jsonschema pytest

# 5. Test the price engine
python -m pytest test_price_advisor.py -q

# 6. Run the price engine examples
python price_advisor.py

# 7. Run the complete demo
python run_pipeline.py
```

---

# 📊 Module Status

| Component | Status | Notes |
|---|:---:|---|
| FactSheet schema | ✅ | Shared Pydantic contract |
| Extraction | ✅ | Gemini structured output |
| Description Writer | ✅ | English + Hindi |
| Confidence Check | ✅ | One-question missing-field flow |
| Suggested Additions | ✅ | Explicit approval required |
| Price Advisor | ✅ | Deterministic, source-backed |
| Price Tests | ✅ | 14 offline tests |
| ONDC Mapper | ✅ | Produces validated Item |
| End-to-End Pipeline | ✅ | Extraction → ONDC validation |

---

# ⚠️ Known Limitations

- The current market corpus is small and should be expanded.
- Market references should eventually be filtered by more comparable attributes such as product type, size, material and design complexity.
- The ₹90/hour labour figure is a configurable benchmark proxy, not a universal artisan wage.
- Production should use craft/state/skill-specific labour-rate rules where possible.
- The demo pipeline auto-accepts the suggested price; production must require explicit artisan approval.
- `mapper.py` and `ondc_schema.json` are duplicated copies in this module and should remain synchronized with the publishing module.

---

# 👤 Ownership

**Shivam Singh — Language Layer**

Responsible for:

```text
FactSheet
Extraction
Description Writer
Confidence & Suggestions
Price Advisor
Pricing Reference Corpus
```

The module is designed so that every automated transformation remains traceable and the artisan retains control over the final published listing.


# ⚠️ Important: `mapper.py` and `ondc_schema.json` are duplicated across branches

`mapper.py` and `ondc_schema.json` in the `factsheet-shivam` branch are copies of the corresponding files maintained in the **ONDC module / ONDC branch**.

These files are intentionally duplicated so the factsheet pipeline can run without cross-folder or cross-branch imports.

### Synchronization rule

**Any change made to either `mapper.py` or `ondc_schema.json` must be manually applied to the corresponding file in BOTH locations:**

```text
ONDC branch / folder
        │
        ├── mapper.py
        └── ondc_schema.json
                │
                │  keep synchronized
                ▼
factsheet-shivam branch / folder
        │
        ├── mapper.py
        └── ondc_schema.json
```

For example:

```text
Change mapper.py in ONDC branch
        ↓
Copy the same change to factsheet-shivam/mapper.py

Change ondc_schema.json in ONDC branch
        ↓
Copy the same change to factsheet-shivam/ondc_schema.json
```

The same applies in the opposite direction: **if a change is made in the factsheet copy, update the ONDC copy as well.**

Before a demo, merge, or release, verify that the two copies match.

> **Do not treat these as independent files. They are two synchronized copies of the same ONDC mapping/schema implementation.**
