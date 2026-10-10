import pytest

from calculator import add


def test_add_whole_numbers():
    assert add(2, 3) == 5


def test_add_negative_numbers():
    assert add(10, -4) == 6


def test_add_decimals():
    assert add(0.1, 0.2) == pytest.approx(0.3)


def test_add_rejects_text():
    with pytest.raises(TypeError):
        add("1", "5")


def test_add_rejects_booleans():
    with pytest.raises(TypeError):
        add(True, 1)