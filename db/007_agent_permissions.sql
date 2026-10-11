-- 007: agents may submit and read requests; audit logging keeps working for them

GRANT SELECT, INSERT ON requests TO agent;
GRANT SELECT ON audit_log TO agent;

CREATE OR REPLACE FUNCTION log_request_status() RETURNS trigger
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_status, new_status, changed_by)
        VALUES ('requests', NEW.id, 'INSERT', NULL, NEW.status, session_user);
    ELSIF NEW.status IS DISTINCT FROM OLD.status THEN
        INSERT INTO audit_log (table_name, record_id, action, old_status, new_status, changed_by)
        VALUES ('requests', NEW.id, 'UPDATE', OLD.status, NEW.status, session_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
