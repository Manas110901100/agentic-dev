-- 009: humans table. Only humans can approve (principle 2).
-- Rows are never deleted (principle 3): to remove access, set status = 'disabled'.

CREATE TABLE humans (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name       TEXT NOT NULL UNIQUE,
    role       TEXT NOT NULL CHECK (role IN ('approver', 'admin')),
    status     TEXT NOT NULL DEFAULT 'active'
               CHECK (status IN ('active', 'disabled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER humans_no_delete
    BEFORE DELETE ON humans
    FOR EACH ROW
    EXECUTE FUNCTION block_delete();

CREATE TRIGGER humans_no_truncate
    BEFORE TRUNCATE ON humans
    FOR EACH STATEMENT
    EXECUTE FUNCTION block_delete();

    
-- Permissions: agents get nothing; the approval UI can only read.
REVOKE ALL ON humans FROM PUBLIC;
GRANT SELECT ON humans TO approval_ui;
