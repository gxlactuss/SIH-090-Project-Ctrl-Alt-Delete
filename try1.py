import json
from jsonschema import Draft7Validator, RefResolver

with open("ondc_schema.json") as f:
    schema = json.load(f)

item_schema = schema["components"]["schemas"]["Item"]
resolver = RefResolver.from_schema(schema)  # resolves $refs against the full doc
validator = Draft7Validator(item_schema, resolver=resolver)

sample_item = {
    "id": "test-1",
    "descriptor": {
        "name": "Handwoven Jute Bag",
        "symbol": "https://yourcdn.com/images/jute-bag-icon.png",
        "short_desc": "Handwoven jute tote, natural dye",
        "long_desc": "A handwoven jute tote bag made by artisans in...",
        "images": ["https://yourcdn.com/images/jute-bag-1.jpg"]
    },
    "price": {
        "currency": "INR",
        "value": "500",
        "maximum_value": "600"
    },
    "category_id": "Fashion",
    "quantity": {"available": {"count": "10"}}
}

errors = list(validator.iter_errors(sample_item))
if errors:
    for e in errors:
        print("Invalid:", e.message)
else:
    print("Valid!")