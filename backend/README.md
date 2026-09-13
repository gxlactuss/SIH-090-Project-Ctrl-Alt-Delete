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

## Health Check

Check the service status:

```bash
curl http://127.0.0.1:8000/health
```

Expected JSON response:

```json
{
  "status": "ok",
  "service": "Listing Factory API",
  "version": "0.1.0"
}
```

---

## Database Migrations (Alembic)

Alembic is configured to detect models inheriting from `app.db.base.Base`.

To generate a new migration after adding SQLAlchemy models:

```bash
alembic revision --autogenerate -m "Add new models"
```

To apply migrations:

```bash
alembic upgrade head
```

---

## Running Tests

Run the test suite with pytest:

```bash
pytest
```

Tests run independently without requiring a running PostgreSQL instance.
