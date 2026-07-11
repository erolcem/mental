"""Sky Link storage + endpoints — SQLite in a temp dir, no network."""
import pytest
from fastapi.testclient import TestClient

from app import sync
from app.config import settings
from app.main import app

client = TestClient(app)
KEY = "ABCD2345EFGH6789JKMN"


@pytest.fixture(autouse=True)
def tmp_db(tmp_path, monkeypatch):
    monkeypatch.setenv("SYNC_DB", str(tmp_path / "sync_test.db"))
    monkeypatch.setattr(settings, "app_token", "")


def test_pull_before_any_push_is_empty():
    r = client.post("/sync/pull", json={"key": KEY})
    assert r.status_code == 200
    assert r.json()["data"] is None


def test_push_pull_roundtrip_and_overwrite():
    r = client.post("/sync/push",
                    json={"key": KEY, "data": '{"v":1}', "device": "iPhone"})
    assert r.status_code == 200
    first = r.json()["updated_at"]
    got = client.post("/sync/pull", json={"key": KEY}).json()
    assert got["data"] == '{"v":1}'
    assert got["updated_at"] == first
    assert got["device"] == "iPhone"
    # Second push overwrites (last-writer blob store).
    client.post("/sync/push", json={"key": KEY, "data": '{"v":2}', "device": "mac"})
    got = client.post("/sync/pull", json={"key": KEY}).json()
    assert got["data"] == '{"v":2}'
    assert got["device"] == "mac"


def test_keys_isolate_and_are_hashed():
    client.post("/sync/push", json={"key": KEY, "data": '{"mine":1}'})
    other = client.post("/sync/pull",
                        json={"key": "ZZZZ9999YYYY8888XXXX"}).json()
    assert other["data"] is None
    # The raw key never lands in the database.
    import sqlite3
    rows = sqlite3.connect(sync.db_path()).execute(
        "SELECT account, data FROM skies").fetchall()
    assert rows and all(KEY not in acc for acc, _ in rows)
    assert rows[0][0] == sync.account_for(KEY)


def test_limits_and_token(monkeypatch):
    assert client.post("/sync/pull", json={"key": "short"}).status_code == 422
    big = "x" * (sync.MAX_BLOB_BYTES + 1)
    assert client.post("/sync/push",
                       json={"key": KEY, "data": big}).status_code == 422
    monkeypatch.setattr(settings, "app_token", "tok")
    assert client.post("/sync/pull", json={"key": KEY}).status_code == 401
    ok = client.post("/sync/pull", json={"key": KEY},
                     headers={"Authorization": "Bearer tok"})
    assert ok.status_code == 200
