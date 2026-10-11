-- 004: log request creation and status changes to audit_log

CREATE FUNCTION log_request_status() RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_status, new_status)
        VALUES ('requests', NEW.id, 'INSERT', NULL, NEW.status);
    ELSIF NEW.status IS DISTINCT FROM OLD.status THEN
        INSERT INTO audit_log (table_name, record_id, action, old_status, new_status)
        VALUES ('requests', NEW.id, 'UPDATE', OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER requests_audit
    AFTER INSERT OR UPDATE ON requests
    FOR EACH ROW
    EXECUTE FUNCTION log_request_status();
