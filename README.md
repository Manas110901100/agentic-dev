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
| 1.3 Approval backend and web UI | In progress: `GET /requests` reads the database (read-only) |
| 1.4–1.6 MCP server, first coder agent, find-and-fix test | Planned |

No agent runs yet. The rules below are built and tested by hand first.

## How the rules are enforced

| Rule | Enforced by |
|---|---|
| Agents can submit requests but never change their status | Database roles (`agent` group has no UPDATE) |
| The approval UI can read requests but not change them | Database role `approval_ui` (SELECT only on `requests`) |
| Only an active human can approve | Foreign key to `humans` + trigger |
| One decision per request, never changed | UNIQUE + append-only trigger |
| Status moves only along allowed paths, even for the superuser | `allowed_transitions` table + trigger |
| The audit log can't be edited or deleted | Append-only triggers |
| No change merges with failing checks | CI (`ruff format --check`, `ruff check`, `pytest`) as a required check on `main` (tested: a red PR can't be merged) |
| Nobody pushes straight to `main`, including the owner | GitHub ruleset: pull request required, no force push or deletion (tested) |

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
- `app.py`, `test_app.py`: the approval backend (FastAPI) and its tests
- `db/`: numbered PostgreSQL migrations for the control database
- `AGENTS.md`: rules every agent follows (`CLAUDE.md` points to it)

## Run it

Python 3.12 and PostgreSQL 18.

```
python -m pip install -r requirements.txt
python -m pytest
```

The tests need no database: the app's database access is replaced by a fake.

Migrations run in number order, for example:

```
psql -U postgres -d agentic_control -f db/001_create_requests.sql
```

### Database access for the app

The app logs in as `approval_ui`, which can only read. Connection settings come from
PostgreSQL's own client library (libpq), never from the code:

1. A password file with one line for `approval_ui` only (never the superuser), outside the repo:
   `%APPDATA%\postgresql\pgpass.conf` on Windows, `~/.pgpass` (mode 600) on Linux/macOS:

```
   localhost:5432:agentic_control:approval_ui:<password>
```

2. Connection settings as environment variables, for example in a conda environment:

```
   conda env config vars set PGHOST=localhost PGPORT=5432 PGUSER=approval_ui PGDATABASE=agentic_control
```

3. Check, without a password prompt:

```
   psql -w -c "SELECT current_user, current_database();"
```

## License

MIT
