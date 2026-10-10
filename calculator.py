def _check_numbers(a, b):
    for value in (a, b):
        if isinstance(value, bool) or not isinstance(value, (int, float)):
            raise TypeError("Both inputs must be numbers")


def add(a, b):
    _check_numbers(a, b)
    return a + b


def subtract(a, b):
    _check_numbers(a, b)
    return a - b


def divide(a, b):
    _check_numbers(a, b)
    if b == 0:
        raise ValueError("The second input must be a non-zero number")
    return a / b


def multiply(a, b):
    _check_numbers(a, b)
    return a * b


def power(a, b):
    _check_numbers(a, b)
    return a**b
