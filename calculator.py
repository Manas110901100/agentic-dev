def _check_numbers(a, b):
    """Reject inputs that are not int or float, including booleans.

    Raises TypeError. Every public function calls this before calculating.
    """
    for value in (a, b):
        if isinstance(value, bool) or not isinstance(value, (int, float)):
            raise TypeError("Both inputs must be numbers")


def add(a, b):
    """Return a + b. Raises TypeError if either input is not a number."""
    _check_numbers(a, b)
    return a + b


def subtract(a, b):
    """Return a - b. Raises TypeError if either input is not a number."""
    _check_numbers(a, b)
    return a - b


def divide(a, b):
    """Return a / b, always as a float.

    Raises TypeError if either input is not a number, ValueError if b is zero.
    """
    _check_numbers(a, b)
    if b == 0:
        raise ValueError("The second input must be a non-zero number")
    return a / b


def multiply(a, b):
    """Return a * b. Raises TypeError if either input is not a number."""
    _check_numbers(a, b)
    return a * b


def power(a, b):
    """Return a raised to the power b.

    Raises TypeError if either input is not a number.
    """
    _check_numbers(a, b)
    return a**b
