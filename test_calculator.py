import pytest

from calculator import add, multiply


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


def test_multiply_whole_numbers():
    assert multiply(3, 4) == 12


def test_multiply_by_zero():
    assert multiply(7, 0) == 0


def test_multiply_rejects_text():
    with pytest.raises(TypeError):
        multiply("3", 4)


def test_multiply_rejects_booleans():
    with pytest.raises(TypeError):
        multiply(True, 4)
