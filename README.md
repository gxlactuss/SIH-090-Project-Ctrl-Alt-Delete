# 🛍️ Kaarigar — AI-Powered Artisan Publishing Platform (SIH-090)

**Problem Statement**: Smart Cataloging and Multimodal Market Linkage for Marginalized Indian Artisans  
**Repository**: Project Ctrl-Alt-Delete  

---

## 🏛️ Repository Architecture

This mono-repo powers the end-to-end publishing pipeline connecting rural Indian artisans to e-commerce marketplaces (ONDC, Amazon Karigar, Etsy) by speaking regional dialects and photographing handmade crafts on their phones.

```
SIH-090-Project-Ctrl-Alt-Delete/
├── app/                  # Mobile Client (Flutter 3.x)
│   ├── lib/              # UI, Local DB (sqflite), Speech-to-Text, Audio recording, Camera
│   └── pubspec.yaml      # Mobile dependencies
│
├── backend/              # Publishing Factory Backend (FastAPI + PostgreSQL + SQLAlchemy)
│   ├── app/
│   │   ├── api/          # RESTful v1 endpoints (/listings, /media, /seller, /publish, /voice)
│   │   ├── core/         # Config, Security, Phone validation, Firebase Auth
│   │   ├── db/           # SQLAlchemy session & Base
│   │   ├── models/       # Domain models (sellers, listings, media, suggestions, consents)
│   │   ├── schemas/      # Pydantic schemas & state enums
│   │   └── services/
│   │       ├── pipeline/ # 5-Stage Deterministic Cataloging Pipeline
│   │       │   ├── stages/
│   │       │   │   ├── image.py       # [LIVE] ImageStation: Quality check, Cutout, Studio Framing
│   │       │   │   ├── speech.py      # [LIVE] SpeechStage: Sarvam AI Indic STT translation
│   │       │   │   ├── fact_sheet.py  # [LIVE] FactSheetStage: Gemini Flash structured extraction
│   │       │   │   ├── price.py       # [LIVE] PriceStage: Fair market pricing engine
│   │       │   │   └── confidence.py  # Confidence score evaluator
│   │       │   └── runner.py          # Sequential orchestrator with isolated retries
│   │       ├── vision/   # Image Processing Subsystem (IS-Net ONNX)
│   │       ├── voice/    # Voice Station Subsystem (Sarvam AI saaras:v3)
│   │       ├── llm/      # LLM Extraction Subsystem (Gemini 3.5 Flash)
│   │       └── publishing/ # Multi-Channel Adapters (ONDC, Meta WhatsApp, Google Merchant)
│   ├── alembic/          # Database migrations
│   ├── tests/            # Automated test suite (160/160 passing - 100%)
│   ├── test_voice_cli.py # Interactive CLI tool for voice testing & JSON generation
│   ├── requirements.txt  # Python backend, vision & AI dependencies
│   ├── README.md         # Backend setup and API documentation
│   └── BACKEND_STUDY_GUIDE.md # Exhaustive technical architecture study guide
```

---

## 🚀 Quick Start (Backend)

```bash
cd backend

# 1. Setup Python Virtual Environment
python3 -m venv .venv
source .venv/bin/activate

# 2. Install Dependencies
pip install -r requirements.txt

# 3. Run Automated Tests (100% Offline with Synthetic Fallbacks)
pytest -v

# 4. Start Development Server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Interactive API documentation will be available at:
- **Swagger UI**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc**: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## 🎙️ Testing the Voice-to-Catalog Pipeline

You can test the complete multimodal cataloging pipeline directly using the CLI tool:

```bash
cd backend

# Test with an audio file and export structured catalog JSON:
python3 test_voice_cli.py --file /path/to/voice_note.wav --output listing.json

# Or speak live into your microphone (counts down 10 seconds):
python3 test_voice_cli.py --record --seconds 10
```

---

## 🎨 Subsystem Status

| Subsystem | Lead | Status | Highlights |
|---|---|:---:|---|
| **Mobile App (`app/`)** | Mohit | 🔨 In Progress | Flutter client, audio capture, camera, offline queue |
| **Backend Core (`backend/`)** | Ayush | ✅ Functional | FastAPI, Alembic migrations, PostgreSQL domain models |
| **Vision Station (`backend/app/services/vision/`)** | Kaustubh | ✅ Integrated | 80% studio white framing, IS-Net ONNX, Laplacian/ROI quality gate |
| **Voice Station (`backend/app/services/voice/`)** | Kaustubh | ✅ Integrated | Sarvam AI (`saaras:v3`) Indic STT translation (Hindi, Marathi, Bengali, etc.) |
| **LLM Fact Sheet Extraction (`backend/app/services/llm/`)** | Kaustubh | ✅ Integrated | Gemini Flash (`gemini-3.5-flash`) strict Pydantic JSON schema |
| **Price Advisor (`backend/app/services/pipeline/stages/price.py`)** | Kaustubh | ✅ Integrated | Stated price adoption & fair market benchmark recommendations |
| **Multi-Channel Syndication (`backend/app/services/publishing/`)** | Team | ✅ Integrated | ONDC (Beckn), Meta (WhatsApp Business Catalog), Google Merchant Center |
