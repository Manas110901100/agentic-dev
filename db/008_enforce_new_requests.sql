-- 008: system-owned columns on new requests cannot be faked by the caller

ALTER TABLE requests ALTER COLUMN submitted_by SET DEFAULT session_user;

CREATE FUNCTION enforce_new_request() RETURNS trigger AS $$
BEGIN
    IF NEW.status <> 'submitted' THEN
        RAISE EXCEPTION 'new requests must start as submitted, got %', NEW.status;
    END IF;
    IF NEW.submitted_by <> session_user THEN
        RAISE EXCEPTION 'submitted_by must be the logged-in user (%), got %', session_user, NEW.submitted_by;
    END IF;
    IF NEW.created_at <> now() OR NEW.expires_at <> now() + interval '7 days' THEN
        RAISE EXCEPTION 'created_at and expires_at are set by the system';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER requests_enforce_new
    BEFORE INSERT ON requests
    FOR EACH ROW
    EXECUTE FUNCTION enforce_new_request();
    