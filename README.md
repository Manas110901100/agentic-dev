# agentic-dev

**AI agents that can't approve their own code, enforced by the database, not by trust.**

A learning project: building a system where AI agents write and fix software, while one human
approves every important change and every action is recorded.

## Status

| Stage | Status |
|---|---|
| 0. Foundation: Git, tests, CI, pull requests | Done |
| 1.1 Control database: requests, approvals, audit log | Done |
| 1.2 Agent rules (`AGENTS.md`) and docstrings enforced by a test | Done |
| 1.3 Approval backend and web UI | Next |
| 1.4–1.6 MCP server, first coder agent, find-and-fix test | Planned |

No agent runs yet. The rules below are built and tested by hand first.

## How the rules are enforced

| Rule | Enforced by |
|---|---|
| Agents can submit requests but never change their status | Database roles (`agent` group has no UPDATE) |
| Only an active human can approve | Foreign key to `humans` + trigger |
| One decision per request, never changed | UNIQUE + append-only trigger |
| Status moves only along allowed paths, even for the superuser | `allowed_transitions` table + trigger |
| The audit log can't be edited or deleted | Append-only triggers |
| No change merges with failing checks | CI: `ruff format --check`, `ruff check`, `pytest` |

## Principles

1. Agents propose, the system executes.
2. Humans approve what matters.
3. Nothing is ever deleted.
4. Everything is traceable.
5. Tests first, CI as a hard gate.
6. Small, single-purpose changes.
7. Rules are enforced by the system, not by trust.

## Layout

- `calculator.py`, `test_calculator.py`: the pilot code the agents will work on
- `db/`: numbered PostgreSQL migrations for the control database
- `AGENTS.md`: rules every agent follows (`CLAUDE.md` points to it)

## Run it

Python 3.12 and PostgreSQL 18.

```
python -m pip install -r requirements.txt
python -m pytest
```

Migrations run in number order, for example:

```
psql -U postgres -d agentic_control -f db/001_create_requests.sql
```

## License

MIT
