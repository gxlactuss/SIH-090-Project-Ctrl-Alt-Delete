"""Tests for Alembic migration integrity, metadata discovery, and SQL generation."""
from pathlib import Path
from alembic.config import Config
from alembic.script import ScriptDirectory
from alembic import command


def test_migration_file_exists_and_discoverable():
    """Verify Alembic detects the 0001_domain_tables migration revision."""
    backend_dir = Path(__file__).resolve().parent.parent
    ini_path = backend_dir / "alembic.ini"
    config = Config(str(ini_path))
    config.set_main_option("script_location", str(backend_dir / "alembic"))

    script = ScriptDirectory.from_config(config)
    head_revision = script.get_current_head()

    assert head_revision == "0001_domain_tables"

    rev_script = script.get_revision(head_revision)
    assert rev_script is not None
    assert rev_script.module is not None
    assert hasattr(rev_script.module, "upgrade")
    assert hasattr(rev_script.module, "downgrade")
    assert callable(rev_script.module.upgrade)
    assert callable(rev_script.module.downgrade)


def test_migration_sql_generation_offline(capsys):
    """Verify that Alembic can render the offline SQL for the entire migration chain."""
    backend_dir = Path(__file__).resolve().parent.parent
    ini_path = backend_dir / "alembic.ini"
    config = Config(str(ini_path))
    config.set_main_option("script_location", str(backend_dir / "alembic"))

    # Run upgrade in offline mode
    command.upgrade(config, "head", sql=True)
    captured = capsys.readouterr()
    sql_output = captured.out

    # Verify all expected tables and enums are rendered in PostgreSQL SQL
    assert "CREATE TABLE sellers" in sql_output
    assert "CREATE TABLE listings" in sql_output
    assert "CREATE TABLE media" in sql_output
    assert "CREATE TABLE listing_consents" in sql_output
    assert "CREATE TABLE suggestions" in sql_output
    assert "CREATE TABLE listing_approvals" in sql_output
    assert "CREATE TYPE listing_state" in sql_output
    assert "CREATE TYPE media_type" in sql_output
    assert "uq_sellers_ondc_seller_id" in sql_output
    assert "uq_listings_seller_client_item" in sql_output
    assert "uq_listing_consents_listing_id" in sql_output
    assert "uq_listing_approvals_listing_id" in sql_output
    assert "0001_domain_tables" in sql_output
