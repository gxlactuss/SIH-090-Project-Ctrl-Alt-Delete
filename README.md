# 🛍️ Kaarigar — AI-Powered Artisan Publishing Platform (SIH-090)

**Problem Statement**: Smart Cataloging and Multimodal Market Linkage for Marginalized Indian Artisans  
**Repository**: Project Ctrl-Alt-Delete  

---

## 🏛️ Repository Architecture

This mono-repo powers the end-to-end publishing pipeline connecting rural Indian artisans to e-commerce marketplaces (ONDC, Amazon Karigar, Etsy) by speaking regional dialects and photographing handmade crafts on their phones.

```
SIH-090-Project-Ctrl-Alt-Delete/
├── app/                  # Mobile Client: Kaarigar (Flutter 3.47, Android)
│   ├── lib/
│   │   ├── main.dart, app.dart   # Entry point, Firebase init, theme per language, routes
│   │   ├── core/         # Config (build defines), theme, routing & deep links, constants, utils
│   │   │                 # (image quality gate, on-device framing, photo edits, money in paise)
│   │   ├── data/
│   │   │   ├── models/   # Listing, FactSheet, Suggestion, Sale, SellerProfile, CaptureItem
│   │   │   ├── local/    # sqflite database: capture queue + offline listing cache
│   │   │   ├── remote/   # ApiClient (HttpApi / MockApi / HybridApi), backend session (JWT),
│   │   │   │             # route table, snake/camel JSON mapping, error mapping, voice/ (Sarvam)
│   │   │   └── repositories/ # Auth (Firebase OTP), seller, listings (cache-first), sales, ONDC
│   │   ├── services/     # Camera, recorder, player, speech (TTS), dictation, upload queue,
│   │   │                 # background upload (WorkManager), notifications, connectivity, updates
│   │   ├── state/        # ChangeNotifier controllers (Provider) + providers.dart wiring
│   │   ├── features/     # Screens, one folder per flow (see "Mobile App" below)
│   │   ├── widgets/      # Shared, voice-first UI components
│   │   └── l10n/         # 11 languages (ARB + generated localizations)
│   ├── assets/           # Noto Sans fonts for 9 scripts, craft images, practice photos, mock data
│   ├── android/          # Android project (minSdk 24), release signing, R8 rules, launcher icons
│   ├── test/             # Unit, widget and API-contract tests (+ JSON fixtures)
│   ├── tool/             # Launcher icon generator, fresh emulator run script
│   ├── config/           # secrets.example.json (copy to secrets.json, never committed)
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

## 📱 Mobile App (`app/`)

Kaarigar is built for an artisan who may not read or type comfortably, on a cheap Android phone with a weak connection. Every screen can be read aloud, every important input can be spoken, and nothing is lost when the network drops.

### Design principles
- **Voice first**: every screen has a speak button and can read itself aloud; names, answers and edits can be spoken instead of typed.
- **Offline first**: captures are saved to a local database and uploaded by a queue whenever a network appears, including in the background with the app closed.
- **11 languages**: Hindi, English, Bengali, Gujarati, Kannada, Malayalam, Marathi, Odia, Punjabi, Tamil and Telugu, with bundled Noto Sans fonts so text never breaks mid-word on small screens.
- **Big targets, few words**: large buttons, icons with labels, one decision per screen, and spoken confirmation before anything destructive.
- **Seller stays in control**: nothing is published without an explicit read-back, price check and separate consent for the photo and the craft story, and consent can be withdrawn later.

### User flows
| # | Flow | What the seller does |
|---|---|---|
| 1 | **Onboarding** | Choose language → welcome → terms (spoken summary) → phone number + OTP (Firebase) → permissions → profile (name, village, craft) |
| 2 | **Home** | See what needs attention, start a new product, check uploads and sales |
| 3 | **Guided capture** | Take up to 3 photos with live framing help → automatic quality check (blur, light, product in frame) with retake advice → crop/rotate → record a voice note describing the product (or type it) → saved to the queue |
| 4 | **Upload queue** | Watch uploads progress; failed items explain why and retry automatically when a network returns |
| 5 | **Review & publish** | Answer one follow-up question by voice → listen to the generated title and description → accept or reject suggested additions → confirm price and stock → reorder photos → give photo and story consent → publish |
| 6 | **Listings / Products** | Drafts, live and sold sections; edit, update stock, share a preview link, unpublish and relist |
| 7 | **Sales** | Sale details, pack-by reminders, a spoken packing checklist, and weekly / monthly / total earnings |
| 8 | **Profile & settings** | Edit profile and craft story, change phone, link the ONDC selling account, voice speed and auto-read, notifications, privacy & consent centre, storage, sign out / delete account |
| 9 | **Help** | Spoken help topics, FAQ, about, call or WhatsApp support, terms and privacy |
| 10 | **System states** | Offline banner, server errors, permission recovery, forced update |

### Architecture
```
Screens (features/)  ──►  Controllers (state/, ChangeNotifier via Provider)
                                  │
                                  ▼
                         Repositories (data/repositories/)
                         ┌────────┴─────────┐
                         ▼                  ▼
              Local sqflite cache      ApiClient (data/remote/)
              + capture queue          ├─ HttpApi   → FastAPI backend (/api/v1)
                                       ├─ MockApi   → on-device simulation for demos
                                       └─ HybridApi → per-call switch between the two
```
- **Authentication**: Firebase phone OTP on the device; the Firebase ID token is exchanged at `POST /api/v1/auth/firebase` for the backend's JWT, which is stored, refreshed and retried once on `401`.
- **Uploads**: `POST /listings` with the phone's capture id as `client_item_id`, then one `POST /listings/{id}/media` per photo and voice note, with progress. The phone keeps using its own capture id and maps it to the server's listing id.
- **Moving to the real backend one call at a time**: `API_REAL_CALLS` chooses which calls go to the server. By default these are profile, upload and reading listings; the rest stay simulated until the backend supports them.
- **Status updates**: listings still being processed are refreshed on a backoff while the app is open, on resume, and on pull-to-refresh.
- **Voice**: Sarvam AI for speech-to-text (`saaras:v3`), text-to-speech (`bulbul:v3`) and translation (`mayura:v1`), with generated speech cached on the phone; falls back to the device's own TTS and speech recognition when no key is set.
- **On-device vision**: Google ML Kit object detection for framing guidance, plus a local blur/exposure quality gate before anything is uploaded.
- **ONDC**: the seller links a selling account (email + seller ID). Linking is simulated until ONDC network approval; real linking will run through the backend.
- **Errors**: every failure is mapped to one reason (offline, server, not allowed, not found, conflict, invalid) and shown as a spoken, translated message.

### Quick Start (Mobile App)
```bash
cd app
flutter pub get

# Optional keys and server settings (never committed)
cp config/secrets.example.json config/secrets.json

# Run on a device or emulator (fully simulated backend if API_BASE_URL is empty)
flutter run --dart-define-from-file=config/secrets.json

# Tests and static analysis
flutter test
flutter analyze
```

| Setting (`config/secrets.json`) | Purpose |
|---|---|
| `API_BASE_URL` | Backend base including `/api/v1`, e.g. `http://10.0.2.2:8000/api/v1` for an emulator. Empty = simulated backend |
| `API_REAL_CALLS` | Empty = calls the backend supports today; `all`; `none`; or a comma list such as `listings,uploadCapture` |
| `SARVAM_API_KEY` | Cloud voice; without it the device's own speech engines are used |
| `SUPPORT_PHONE` | Number shown on the support screen |
| `ONDC_DEMO_LINKING` | Simulated ONDC linking (default on until ONDC approval) |

Debug-only flags: `--dart-define=fresh=true` (start from a clean install), `failUploads=true` (show the retry path), `logHttp=false` (quieter logs). `tool/fresh_run.sh` boots the emulator, clears app data and starts from the first screen.

A release APK needs `android/key.properties` (upload keystore, never committed) and the signing SHA-1/SHA-256 registered in Firebase for phone login:
```bash
flutter build apk --release --split-per-abi --dart-define-from-file=config/secrets.json
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
| **Mobile App (`app/`)** | Mohit | ✅ Functional | 10 flows / 55+ screens and steps, 11 languages, voice-first UI, offline queue + background upload, Firebase OTP, backend-ready API layer (370 tests) |
| **Backend Core (`backend/`)** | Ayush | ✅ Functional | FastAPI, Alembic migrations, in-memory SQLite test harness |
| **Vision Station (`backend/app/services/vision/`)** | Kaustubh | ✅ Integrated | 80% studio white framing, IS-Net ONNX, Laplacian/ROI quality gate |
| **Voice Station** | Kaustubh | 📋 Scaffolding | Sarvam AI Indic STT, faster-whisper CPU fallback |
| **Publishing Adapter** | Team | ✅ Functional | ONDC protocol payload generator & validator |
