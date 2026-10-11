-- 010: approvals table. Only active humans approve (principle 2).
-- Decisions are permanent: no UPDATE, DELETE or TRUNCATE (principles 3 and 4).

-- Generic append-only guard, reusable by any table whose rows must never change.
CREATE FUNCTION block_changes() RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION '% is append-only: % is not allowed', TG_TABLE_NAME, TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE approvals (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_id BIGINT NOT NULL UNIQUE REFERENCES requests (id),
    decision   TEXT NOT NULL CHECK (decision IN ('approved', 'rejected')),
    decided_by BIGINT NOT NULL REFERENCES humans (id),
    reason     TEXT,
    decided_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT approvals_reject_needs_reason
        CHECK (decision = 'approved'
               OR (reason IS NOT NULL AND length(trim(reason)) > 0))
);

-- The approver must be an active human, not a disabled one.
CREATE FUNCTION approvals_check_human() RETURNS trigger AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM humans
                   WHERE id = NEW.decided_by AND status = 'active') THEN
        RAISE EXCEPTION 'decided_by % is not an active human', NEW.decided_by;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER approvals_active_human
    BEFORE INSERT ON approvals
    FOR EACH ROW
    EXECUTE FUNCTION approvals_check_human();

CREATE TRIGGER approvals_no_update_delete
    BEFORE UPDATE OR DELETE ON approvals
    FOR EACH ROW
    EXECUTE FUNCTION block_changes();

CREATE TRIGGER approvals_no_truncate
    BEFORE TRUNCATE ON approvals
    FOR EACH STATEMENT
    EXECUTE FUNCTION block_changes();

-- Permissions: agents get nothing. The UI can read, and can insert
-- only these four columns (it can't fake id or decided_at).
REVOKE ALL ON approvals FROM PUBLIC;
GRANT SELECT ON approvals TO approval_ui;
GRANT INSERT (request_id, decision, decided_by, reason) ON approvals TO approval_ui;
