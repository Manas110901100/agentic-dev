import pytest

from calculator import add, divide, multiply, power, subtract


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


def test_divide_whole_numbers():
    assert divide(10, 2) == 5


def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)


def test_divide_rejects_text():
    with pytest.raises(TypeError):
        divide("10", 2)


def test_divide_rejects_booleans():
    with pytest.raises(TypeError):
        divide(True, 2)


def test_subtract_whole_numbers():
    assert subtract(10, 4) == 6


def test_subtract_rejects_text():
    with pytest.raises(TypeError):
        subtract("10", 4)


def test_subtract_rejects_booleans():
    with pytest.raises(TypeError):
        subtract(True, 4)


def test_power_whole_numbers():
    assert power(2, 3) == 8


def test_power_zero_exponent():
    assert power(5, 0) == 1


def test_power_rejects_text():
    with pytest.raises(TypeError):
        power("2", 3)


def test_power_rejects_booleans():
    with pytest.raises(TypeError):
        power(True, 3)
