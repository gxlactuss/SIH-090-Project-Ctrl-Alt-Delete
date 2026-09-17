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
│   │   ├── api/          # RESTful v1 endpoints (/listings, /media, /seller, /publish)
│   │   ├── core/         # Config, Security, Phone validation, Firebase Auth
│   │   ├── db/           # SQLAlchemy session & Base
│   │   ├── models/       # Domain models (sellers, listings, media, suggestions, consents)
│   │   ├── schemas/      # Pydantic schemas & state enums
│   │   └── services/
│   │       ├── pipeline/ # 5-Stage Deterministic Cataloging Pipeline
│   │       │   ├── stages/
│   │       │   │   ├── image.py       # [LIVE] ImageStation: Quality check, Cutout, Studio Framing
│   │       │   │   ├── speech.py      # SpeechStation: Indic transcription
│   │       │   │   ├── fact_sheet.py  # Gemini LLM Copywriting & Attribute extraction
│   │       │   │   ├── price.py       # Fair market pricing engine
│   │       │   │   └── confidence.py  # Confidence score evaluator
│   │       │   └── runner.py          # Sequential orchestrator with isolated retries
│   │       ├── vision/   # Image Processing Subsystem
│   │       │   ├── pipeline.py        # ImageStation core engine
│   │       │   └── .models/           # IS-Net ONNX model weights (~174MB)
│   │       └── publishing/            # ONDC publishing adapter
│   ├── alembic/          # Database migrations
│   ├── tests/            # Automated test suite (27/27 passing)
│   ├── requirements.txt  # Python backend & vision dependencies
│   ├── README.md         # Backend setup and API documentation
│   └── BACKEND_STUDY_GUIDE.md # Exhaustive technical architecture study guide
```

---

## 🚀 Quick Start (Backend)

```bash
cd backend

# 1. Setup Python Virtual Environment
python3 -m venv venv
source venv/bin/activate

# 2. Install Dependencies
pip install -r requirements.txt

# 3. Run Automated Tests
pytest tests/test_pipeline.py -v

# 4. Start Development Server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Interactive API documentation will be available at:
- **Swagger UI**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **ReDoc**: [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

## 🎨 Subsystem Status

| Subsystem | Lead | Status | Highlights |
|---|---|:---:|---|
| **Mobile App (`app/`)** | Mohit | 🔨 In Progress | Flutter client, audio capture, camera, offline queue |
| **Backend Core (`backend/`)** | Ayush | ✅ Functional | FastAPI, Alembic migrations, in-memory SQLite test harness |
| **Vision Station (`backend/app/services/vision/`)** | Kaustubh | ✅ Integrated | 80% studio white framing, IS-Net ONNX, Laplacian/ROI quality gate |
| **Voice Station** | Kaustubh | 📋 Scaffolding | Sarvam AI Indic STT, faster-whisper CPU fallback |
| **Publishing Adapter** | Team | ✅ Functional | ONDC protocol payload generator & validator |
