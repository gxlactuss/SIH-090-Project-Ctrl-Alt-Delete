Fact Sheet / Language Layer

Language layer for the Kirtikar — AI-Powered Artisan Publishing Platform (SIH-090).

This module turns an artisan's voice-note transcript into a strict, fact-grounded product listing and provides a deterministic price recommendation.

What this module does

Extraction — transcript → structured FactSheet

Description writing — FactSheet → English + Hindi descriptions

Confidence check — detects missing required fields and asks one question at a time

Suggested additions — optional details, applied only after explicit approval

Price Advisor — source-backed cost floor + observed market reference

Core rule: if the artisan did not state a value, the system does not invent it.

Price Advisor — revised methodology

The earlier prototype used:

Labour = hours × ₹50/hour
Price floor = (materials + labour) × 1.30

Those two constants were demo assumptions, not authoritative Indian artisan pricing rules.

The revised engine removes the blanket 30% margin and makes the labour benchmark explicitly configurable.

1. Cost floor

Labour Cost = Hours Spent × Hourly Rate

Cost Floor = Material Cost + Labour Cost

The demo default is ₹90/hour.

This is a deliberately documented proxy, not a claim that every Indian artisan should earn ₹90/hour. It is derived from a Maharashtra Government skilled-wage notification for silver article/ornament manufacturing dated 30 August 2024. The notification sets a Zone-I skilled basic monthly wage of ₹16,570 and states that the hourly rate for part-time work is derived from the daily rate with a 15% increase. That produces approximately ₹91.61/hour, rounded to ₹90 for the demo. urlMaharashtra Government wage notificationhttps://mahakamgar.maharashtra.gov.in/Upload/PDF/Employment%20in%20any%20manufactory%20of%20silver%20article%20or%20ornament.pdf

For production, the correct implementation is to make the rate depend on the seller's state, craft and skill level, because artisan work is not governed by one universal national hourly rate. Government sources also show that some traditional sectors such as Khadi use piece-rate systems instead of ordinary time-rate wages. urlPIB — Wages of Khadi Artisanshttps://www.pib.gov.in/PressReleaseIframePage.aspx?PRID=1983542&lang=2&reg=48

2. No arbitrary 30% margin

The engine no longer adds:

+ 30%

to every product.

There is no single authoritative national "30% artisan margin" that applies across pottery, textiles, baskets, jewellery and woodcraft.

Instead, the engine builds the cost floor from actual inputs and uses observed market prices to position the recommendation.

3. Market reference corpus

The revised engine stores observed product prices rather than hand-entered low/median/high guesses.

The main source is IndiaHandmade, a Government of India / Ministry of Textiles digital marketplace connecting buyers with verified artisans, weavers, societies and producer companies. citeturn170036search6turn170036search10

For each supported category, the engine calculates:

Market Low    = 25th percentile (P25)
Market Median = 50th percentile (P50)
Market High   = 75th percentile (P75)

This is an observed reference band, not a claim about every product in India.

Current source-backed observations are:

Category

Observed sample count

Derived P25

Median

Derived P75

Pottery

5

₹450

₹1200

₹1700

Basket

6

₹2111.75

₹2475

₹3250

Kurta

9

₹499

₹799

₹1500

These observations come from current IndiaHandmade product/category pages. For example, current pottery listings include ₹150, ₹450, ₹1,200, ₹1,700 and ₹1,950; the bamboo-basket category page contains multiple products from ₹250 through ₹3,500; and IndiaHandmade's kurta catalogue includes examples such as ₹499, ₹720, ₹799, ₹1,500, ₹1,799 and ₹2,500. citeturn170036search8turn170036search3turn170036search0turn170036search1turn170036search5turn182177search2turn182177search5

4. Recommendation logic

If both cost floor and market band exist:

Cost Floor < P25
    → Suggested Price = P25

P25 ≤ Cost Floor ≤ P75
    → Suggested Price = Cost Floor

Cost Floor > P75
    → Suggested Price = Cost Floor
    → Flag market mismatch

The engine therefore never recommends a price below the calculated cost floor.

Example

Suppose:

Material cost = ₹200
Hours          = 4
Hourly rate    = ₹90

Then:

Labour = 4 × ₹90
       = ₹360

Cost Floor
= ₹200 + ₹360
= ₹560

For pottery, the current observed P25 is ₹450 and P75 is ₹1,700.

Because:

₹450 ≤ ₹560 ≤ ₹1,700

the recommended price remains:

₹560

This is different from the old prototype, which added a blanket 30% margin.

Example: very low floor

Pottery
Hours = 3
Material cost = not stated
Hourly rate = ₹90

Cost Floor = 3 × ₹90 = ₹270
Observed P25 = ₹450

Suggested = ₹450

Example: cost above observed market band

Material cost = ₹2,000
Hours = 5

Cost Floor = ₹2,000 + (5 × ₹90)
           = ₹2,450

Pottery P75 is ₹1,700, so the engine returns ₹2,450 and flags the fact that the cost floor is above the observed reference band.

It does not force the seller below cost.

Important limitations

The market reference is not yet a statistically representative national market index.

Product price depends heavily on:

size and dimensions

material and quality

design complexity

craftsmanship

brand/reputation

geography

discounts

whether the listing is retail or wholesale

shipping/tax treatment

For example, a small terracotta item and a large decorative terracotta piece should not be treated as economically identical merely because both are "pottery".

The next improvement is therefore to expand the corpus with more comparable products and eventually include dimensions/material/subcategory filters.

The engine intentionally returns no market band when there are too few observations.

Files

File

Purpose

factsheet_schema.py

Shared Pydantic FactSheet model

extract.py

Gemini structured extraction

writer.py

English/Hindi description generation

confidence.py

Missing-field and approval logic

price_advisor.py

Deterministic source-backed price engine

test_price_advisor.py

Offline price-engine tests

gemini_utils.py

Gemini retry/backoff

test_transcripts.py

Extraction test cases

run_extraction_tests.py

Extraction test runner

run_pipeline.py

End-to-end pipeline

mapper.py

FactSheet → ONDC item

ondc_schema.json

ONDC validation schema

Running the price tests

python -m pytest test_price_advisor.py -q

Expected:

14 passed

Running the full pipeline

python run_pipeline.py

The demo pipeline should reach:

STEP 4: Price advisor

and then:

Valid ONDC item produced!

The current run_pipeline.py still auto-accepts the recommended price for demonstration purposes. In production, the artisan should hear the recommendation and explicitly approve or correct it before price_final is written.

Design principles

Deterministic

No LLM call is needed for pricing.

Traceable

Every output number comes from:

the artisan's stated cost/hours, or

a stored reference observation.

Seller-controlled

price_advisor.py does not mutate price_final.

Conservative with unknowns

Insufficient market observations do not produce a fake market band.

Extensible

The reference corpus can be replaced by a database or CSV without changing the price calculation interface