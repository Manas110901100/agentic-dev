-- 002: audit_log table
-- Append-only history of changes to control tables.
-- Rows are written by triggers, never by hand. (Blocking UPDATE/DELETE comes in step 28.)

CREATE TABLE audit_log (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name  TEXT        NOT NULL,
    record_id   BIGINT      NOT NULL,
    action      TEXT        NOT NULL CHECK (action IN ('INSERT', 'UPDATE')),
    old_status  TEXT,
    new_status  TEXT,
    changed_by  TEXT        NOT NULL DEFAULT current_user,
    changed_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
