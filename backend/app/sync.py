"""Sky Link — cross-device sync storage.

One row per sky: an opaque JSON snapshot the app owns entirely. The server
never parses it, only stores and returns it. Accounts are the SHA-256 of a
client-generated Sky Key (24-char random code) — the raw key is never
stored, so the database alone cannot be used to impersonate a sky, and the
existing bearer APP_TOKEN still guards every request.

SQLite via the stdlib: zero new dependencies, one file. On Railway attach a
volume and point SYNC_DB at it (e.g. /data/mental_sync.db); with no volume
the store still works but lives and dies with the container filesystem.
"""
import hashlib
import os
import sqlite3
from datetime import datetime, timezone

MAX_BLOB_BYTES = 1_000_000  # a full sky snapshot is ~100 KB; 1 MB is generous
MIN_KEY_CHARS = 16


def db_path() -> str:
    return os.environ.get("SYNC_DB", "") or "mental_sync.db"


def account_for(key: str) -> str:
    return hashlib.sha256(f"mental-sky:{key}".encode()).hexdigest()


def _connect() -> sqlite3.Connection:
    conn = sqlite3.connect(db_path())
    conn.execute(
        "CREATE TABLE IF NOT EXISTS skies ("
        " account TEXT PRIMARY KEY,"
        " data TEXT NOT NULL,"
        " updated_at TEXT NOT NULL,"
        " device TEXT NOT NULL DEFAULT '')")
    return conn


def push(key: str, data: str, device: str = "") -> str:
    """Store the snapshot; returns the server-side updated_at (UTC ISO)."""
    now = datetime.now(timezone.utc).isoformat()
    with _connect() as conn:
        conn.execute(
            "INSERT INTO skies (account, data, updated_at, device)"
            " VALUES (?, ?, ?, ?)"
            " ON CONFLICT(account) DO UPDATE SET"
            " data=excluded.data, updated_at=excluded.updated_at,"
            " device=excluded.device",
            (account_for(key), data, now, device[:64]))
    return now


def pull(key: str) -> dict | None:
    """The stored snapshot, or None when this sky has never pushed."""
    with _connect() as conn:
        row = conn.execute(
            "SELECT data, updated_at, device FROM skies WHERE account=?",
            (account_for(key),)).fetchone()
    if row is None:
        return None
    return {"data": row[0], "updated_at": row[1], "device": row[2]}
