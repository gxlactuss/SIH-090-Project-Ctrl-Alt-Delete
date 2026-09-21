"""
test_transcripts.py — 15 realistic artisan transcripts + expected fact sheets
Language layer test data (per project doc: "keep a file of fifteen realistic
transcripts and the fact sheet each one should produce, and run it after
every prompt change — that file is the evidence that nothing is invented.")

Each entry has:
  - transcript: what the artisan is imagined to have said (already
    translated to English, as if from Kaustubh's speech station)
  - expected: only the fields that SHOULD be filled, based on what's
    actually stated. Fields not listed here should stay None after
    extraction — that's the thing this test set is checking for.

NOTE: these are realistic but invented examples for testing. Swap in real
transcripts once available (e.g. from actual pilot artisans).
"""

TEST_CASES = [
    {
        "id": "T01_jute_bag_full",
        "transcript": (
            "This is a handwoven jute bag. I used natural dyes, took me about "
            "four hours to make. The jute cost me around two hundred rupees."
        ),
        "expected": {
            "product_name": "handwoven jute bag",
            "category": "textile",
            "materials": "jute, natural dye",
            "cost_of_materials": 200,
            "hours_spent": 4,
        },
    },
    {
        "id": "T02_clay_pot_no_cost",
        "transcript": (
            "This is a clay pot, handmade. I used red clay from the local river. "
            "It took me about three hours. I have five of these ready."
        ),
        "expected": {
            "product_name": "clay pot",
            "category": "pottery",  # clay -> pottery is now correctly inferred
            "materials": "red clay",
            "hours_spent": 3,
            "stock_count": 5,
            # cost_of_materials, color intentionally NOT required —
            # "red clay" is a material description, not necessarily a stated
            # color of the finished item. Reasonable models may go either way
            # on inferring color here; don't fail the test over it.
        },
    },
    {
        "id": "T03_silver_earrings_minimal",
        "transcript": "These are silver earrings I made. Two hundred fifty rupees each.",
        "expected": {
            "product_name": "silver earrings",
            "category": "jewellery",
            "materials": "silver",
            # cost_of_materials is ambiguous here (is 250 the price or the
            # material cost?) — this transcript is intentionally tricky;
            # extraction should NOT assume 250 is cost_of_materials unless
            # the phrasing is clear. Worth checking manually what the
            # model does with this one.
        },
    },
    {
        "id": "T04_wooden_bowl_dimensions",
        "transcript": (
            "A wooden bowl, carved from mango wood. It's about six inches wide. "
            "Took me a full day, maybe eight hours."
        ),
        "expected": {
            "product_name": "wooden bowl",
            "category": "woodwork",
            "materials": "mango wood",
            "dimensions": "six inches wide",
            "hours_spent": 8,
        },
    },
    {
        "id": "T05_scarf_color_stated",
        "transcript": "A blue cotton scarf, hand-dyed. I have three in stock right now.",
        "expected": {
            "product_name": "cotton scarf",
            "category": "textile",
            "materials": "cotton",
            "color": "blue",
            "stock_count": 3,
        },
    },
    {
        "id": "T06_bracelet_returnable_mentioned",
        "transcript": (
            "This is a beaded bracelet. If someone doesn't like it, they can "
            "return it, that's fine with me."
        ),
        "expected": {
            "product_name": "beaded bracelet",
            "category": "jewellery",
            "returnable": True,
        },
    },
    {
        "id": "T07_vague_no_details",
        "transcript": "This is something I made. It's nice.",
        "expected": {
            # Deliberately near-empty. Almost everything should stay None.
            # This tests that the model doesn't invent a product_name,
            # category, or any attribute from vague filler.
        },
    },
    {
        "id": "T08_basket_stock_and_price_mixed",
        "transcript": (
            "A bamboo basket, I usually sell these for four hundred rupees. "
            "I have two ready right now, and materials cost about one hundred."
        ),
        "expected": {
            "product_name": "bamboo basket",
            "category": "woodwork",
            "materials": "bamboo",
            "stock_count": 2,
            "cost_of_materials": 100,
            # NOTE: "sell these for 400" is the artisan's own price opinion,
            # not necessarily price_final (that's set by price_advisor).
            # Check manually how extraction handles this — it may or may
            # not be appropriate to capture as a signal.
        },
    },
    {
        "id": "T09_painting_no_stock_no_price",
        "transcript": "A small painting, acrylic on canvas, took about six hours.",
        "expected": {
            "product_name": "painting",
            "materials": "acrylic",  # loosened — just check the key material is mentioned
            "dimensions": "small",   # "A small painting" directly states size
            "hours_spent": 6,
        },
    },
    {
        "id": "T10_saree_long_description_source",
        "transcript": (
            "This is a handloom cotton saree, woven by my mother-in-law. "
            "She's been weaving for over twenty years. It took about two weeks "
            "to finish, working a few hours each day."
        ),
        "expected": {
            "product_name": "handloom cotton saree",
            "category": "textile",
            "materials": "cotton",
            # "two weeks working a few hours a day" is NOT a clean number of
            # hours — extraction should leave hours_spent None rather than
            # guess a total, since the artisan didn't state a clear figure.
        },
    },
    {
        "id": "T11_leather_wallet_non_returnable",
        "transcript": (
            "A leather wallet, genuine leather. I don't take returns on these "
            "since they're made to order."
        ),
        "expected": {
            "product_name": "leather wallet",
            "materials": "leather",
            "returnable": False,
        },
    },
    {
        "id": "T12_candles_multiple_stock",
        "transcript": "Handmade soy wax candles. I have twelve of these in stock.",
        "expected": {
            "product_name": "soy wax candles",
            "materials": "soy wax",
            "stock_count": 12,
        },
    },
    {
        "id": "T13_no_transcript_content",
        "transcript": "",
        "expected": {
            # Empty transcript — everything should stay None.
            # Tests that the pipeline doesn't crash or hallucinate on
            # empty/garbage input.
        },
    },
    {
        "id": "T14_pottery_set_dimensions_and_color",
        "transcript": (
            "A set of terracotta cups, orange-brown color, each about three "
            "inches tall. I made six of them."
        ),
        "expected": {
            "product_name": "terracotta cups",
            "category": "pottery",
            "materials": "terracotta",
            "color": "orange-brown",
            "dimensions": "three inches tall",
            "stock_count": 6,
        },
    },
    {
        "id": "T15_necklace_full_detail",
        "transcript": (
            "This is a beaded necklace made from glass beads and thread. "
            "Materials cost me about eighty rupees, and it took two hours to "
            "make. I have four ready, and yes, returns are fine within a week."
        ),
        "expected": {
            "product_name": "beaded necklace",
            "category": "jewellery",
            "materials": "glass beads",  # loosened — just check the key material is mentioned
            "cost_of_materials": 80,
            "hours_spent": 2,
            "stock_count": 4,
            "returnable": True,
            # NOTE: return_window is not in ExtractedFields (extraction doesn't
            # capture it) — that field gets set later, during the suggestion/
            # confirmation flow, not extraction. Removed from this test.
        },
    },
]