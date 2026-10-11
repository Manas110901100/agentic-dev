-- 005: rows in requests can never be deleted (principle 3)
-- Reusable: later tables (agents, approvals) can use the same function.

CREATE FUNCTION block_delete() RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION '% rows can never be deleted: % is not allowed', TG_TABLE_NAME, TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER requests_no_delete
    BEFORE DELETE ON requests
    FOR EACH ROW
    EXECUTE FUNCTION block_delete();

CREATE TRIGGER requests_no_truncate
    BEFORE TRUNCATE ON requests
    FOR EACH STATEMENT
    EXECUTE FUNCTION block_delete();
