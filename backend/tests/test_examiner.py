"""Examiner prompt/parse unit tests — no network."""
import pytest

from app.examiner import Verdict, build_user_turn, examine, parse_verdict


def test_build_user_turn_includes_context():
    turn = build_user_turn(
        stat="Intelligence", skill="Mathematics", goal="Fields Medal / Proof Mastery",
        node="Real Analysis I (Baby Rudin)", tier=5,
        prerequisites=["Calculus I-III (Stewart)", "Linear Algebra (Axler)"],
        summary="I worked through chapters 1-7...",
    )
    for fragment in ["Mathematics", "Real Analysis I (Baby Rudin)", "Tier: 5",
                     "Linear Algebra (Axler)", "chapters 1-7"]:
        assert fragment in turn


def test_build_user_turn_root_node():
    turn = build_user_turn(stat="s", skill="k", goal="g", node="n", tier=1,
                           prerequisites=[], summary="text")
    assert "none (root node)" in turn


def test_parse_plain_json():
    v = parse_verdict('{"verdict": "pass", "confidence": 0.9, "feedback": "Solid evidence."}')
    assert v == Verdict(passed=True, confidence=0.9, feedback="Solid evidence.")


def test_parse_code_fenced_json():
    v = parse_verdict('```json\n{"verdict": "fail", "confidence": 0.7, "feedback": "Too vague."}\n```')
    assert not v.passed
    assert v.feedback == "Too vague."


def test_parse_json_embedded_in_prose():
    v = parse_verdict('Here is my judgement: {"verdict": "fail", "confidence": 1.2, "feedback": "x"}')
    assert not v.passed
    assert v.confidence == 1.0  # clamped


def test_parse_bad_confidence_defaults():
    v = parse_verdict('{"verdict": "pass", "confidence": "high", "feedback": "ok"}')
    assert v.confidence == 0.5


def test_parse_rejects_garbage():
    with pytest.raises(ValueError):
        parse_verdict("The student did well, I think.")
    with pytest.raises(ValueError):
        parse_verdict('{"verdict": "maybe", "confidence": 0.5, "feedback": "?"}')


def test_examine_uses_injected_generate():
    def fake_generate(system, turns, **kw):
        assert "Examiner" in system
        assert turns[0]["role"] == "user"
        assert "NODE UNDER EXAMINATION" in turns[0]["text"]
        return '{"verdict": "pass", "confidence": 0.8, "feedback": "Named Rudin ch. 1-7."}'

    v = examine(stat="Intelligence", skill="Mathematics", goal="g",
                node="Real Analysis I", tier=5, prerequisites=[],
                summary="x" * 100, generate=fake_generate)
    assert v.passed and v.confidence == 0.8
