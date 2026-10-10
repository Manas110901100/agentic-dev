def add(a, b):
    for value in (a, b):
        if isinstance(value, bool) or not isinstance(value, (int, float)):
            raise TypeError("Both inputs must be numbers")
    return a + b