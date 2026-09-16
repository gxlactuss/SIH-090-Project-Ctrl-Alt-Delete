# Listing Factory Backend

The **Listing Factory** is a single FastAPI service powering the seller-side publishing portal for marginalized artisans.

> **Architecture Context**: This system is **not** an e-commerce marketplace; orders and payments are handled externally via ONDC. This backend service manages the middle-tier publishing lifecycle pipeline (local queue sync, image/speech station integration, listing/fact-sheet generation, price advisory, confidence evaluation, artisan review/approval, and ONDC publishing).

---

## Prerequisites

- Python 3.10+ (or [uv](https://docs.astral.sh/uv/))
- PostgreSQL (for running migrations and persistence in development/production)

---

## Getting Started

### 1. Environment Setup

Create and activate a virtual environment:

```bash
cd backend

# Using standard venv:
python3 -m venv .venv
source .venv/bin/activate

# Or using uv:
uv venv
source .venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
# Or with uv:
uv pip install -r requirements.txt
```

### 3. Environment Configuration

Copy the example environment file:

```bash
cp .env.example .env
```

Review and adjust variables in `.env` as needed for your local environment (e.g. database connection string, secrets, CORS origins).

---

## Running the Application

Start the local development server with Uvicorn:

```bash
uvicorn app.main:app --reload
```

The service will run at `http://127.0.0.1:8000`.

### Interactive API Documentation

- **Swagger UI**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **ReDoc**: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)
- **OpenAPI JSON**: [http://127.0.0.1:8000/openapi.json](http://127.0.0.1:8000/openapi.json)

---

## API Endpoints (v1 Contract)

All business endpoints live under `/api/v1` and currently return deterministic contract stubs.

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/health` | Service health check |
| `GET` | `/api/v1/seller` | Fetch seller profile |
| `POST` | `/api/v1/listings` | Create / queue a new listing item |
| `GET` | `/api/v1/listings` | List seller listings |
| `GET` | `/api/v1/listings/{listing_id}` | Get specific listing details |
| `POST` | `/api/v1/listings/{listing_id}/media` | Multipart upload for media (`image` / `audio`) |
| `GET` | `/api/v1/listings/{listing_id}/status` | Get listing processing state in pipeline |
| `GET` | `/api/v1/listings/{listing_id}/attention` | Fetch attention/intervention details |
| `GET` | `/api/v1/listings/{listing_id}/readback` | Fetch generated details for read-back review |
| `POST` | `/api/v1/listings/{listing_id}/approval` | Submit artisan review approval/correction |
| `GET` | `/api/v1/listings/{listing_id}/suggestions` | Fetch suggested additions |
| `POST` | `/api/v1/listings/{listing_id}/suggestions/{suggestion_id}/approval` | Approve or reject an individual suggestion |
| `POST` | `/api/v1/listings/{listing_id}/consent` | Record consent for publishing artisan photo & story |
| `POST` | `/api/v1/listings/{listing_id}/publish` | Trigger listing publication |
| `GET` | `/api/v1/listings/{listing_id}/preview` | Fetch read-only listing preview |

### Key Contract Enums

- **`ListingState`**: `queued`, `processing`, `needs_attention`, `ready`, `published`
- **`MediaType`**: `image`, `audio`

---

## Persistent Domain Models

The persistence layer defines six core SQLAlchemy 2.x domain tables registered with `Base.metadata`:

1. **`sellers`**: Artisan profiles (`id`, `name`, `language`, `cluster`, `ondc_seller_id`, timestamps).
2. **`listings`**: Core publishing items (`id`, `seller_id`, `client_item_id`, `state`, timestamps) with unique `(seller_id, client_item_id)`.
3. **`media`**: Metadata for uploaded photos and voice notes (`id`, `listing_id`, `media_type`, `storage_path`, timestamps).
4. **`listing_consents`**: Seller consent decisions (`photo_consent`, `story_consent`, timestamps) with unique `listing_id`.
5. **`suggestions`**: AI/system proposed additions (`field`, `value`, `reason`, `approved`, timestamps).
6. **`listing_approvals`**: Seller approval records after read-back review (`approved`, `approved_at`, timestamps) with unique `listing_id`.

> **Note**: As per architectural decoupling, the `/api/v1` API endpoints currently remain deterministic contract stubs and are intentionally not yet connected to persistence.

---

## Database Migrations (Alembic)

Database schema migrations are managed via Alembic in `backend/alembic/versions/`. Domain models are registered via `app.models` onto `Base.metadata`.

### Running Migrations

To apply migrations against a live database:

```bash
alembic upgrade head
```

To generate static SQL for offline review or execution (without connecting to PostgreSQL):

```bash
alembic upgrade head --sql
```

To downgrade schema changes:

```bash
alembic downgrade base
```

---

## Running Tests

Run the test suite with pytest:

```bash
pytest
```

Tests run independently without requiring a running PostgreSQL instance.
