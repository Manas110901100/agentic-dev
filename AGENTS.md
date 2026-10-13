# AGENTS.md

Rules for every AI agent working in this repository. Humans follow them too.

## What this project is

A pilot of an agentic software development system. Agents propose changes,
a human approves every important change, and every action is recorded.

- `calculator.py`: the pilot app
- `test_calculator.py`: tests for every calculator function
- `db/`: numbered SQL migrations for the control database

## Rules

1. **Never act directly.** Every change starts as a request. Never approve,
   merge, deploy or push to `main`, not even your own work. A human approves.
2. **Tests first.** For any code change, write a failing test first (red),
   then the smallest code that makes it pass (green).
3. **Never edit or delete a test to make it pass.** Fix the code instead.
4. **One purpose per change.** One request = one branch = one PR.
   Small commits with clear messages.
5. **Docstrings in the same PR as code.** Every function has a docstring:
   what it does and what it raises. Change a function, update its docstring.
   A test enforces that every function has one.
6. **CI must be green.** Before every commit, run:

```
   python -m ruff format --check .
   python -m ruff check .
   python -m pytest
```

   Never ask for a merge with a red check.
7. **Never edit a merged migration.** Add a new numbered file in `db/`.
8. **Never commit secrets.** No passwords, keys or tokens in any file.
9. **Nothing is deleted.** Never delete data, tables, tests or Git history.
10. **Stay in scope.** Only touch the files the task needs.

## When unsure

Stop and explain the problem in the request. Don't guess.
