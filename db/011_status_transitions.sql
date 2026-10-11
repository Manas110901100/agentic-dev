-- 011: legal status transitions on requests (principles 1, 2, 7).
-- Only moves listed in allowed_transitions are accepted, for every role.
-- pending_approval -> approved/rejected is added in 012, together with
-- the rule that a human approval row must exist.

CREATE ROLE executor LOGIN;

CREATE TABLE allowed_transitions (
    from_status TEXT NOT NULL,
    to_status   TEXT NOT NULL,
    PRIMARY KEY (from_status, to_status)
);

INSERT INTO allowed_transitions (from_status, to_status) VALUES
    ('submitted',        'validating'),
    ('validating',       'pending_approval'),
    ('approved',         'executing'),
    ('executing',        'completed'),
    ('executing',        'failed'),
    ('executing',        'rolled_back'),
    ('submitted',        'expired'),
    ('validating',       'expired'),
    ('pending_approval', 'expired');

CREATE FUNCTION check_status_transition() RETURNS trigger AS $$
BEGIN
    IF NEW.status IS DISTINCT FROM OLD.status
       AND NOT EXISTS (SELECT 1 FROM allowed_transitions
                       WHERE from_status = OLD.status
                         AND to_status = NEW.status) THEN
        RAISE EXCEPTION 'illegal status change for request %: % -> %',
            OLD.id, OLD.status, NEW.status;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER requests_legal_transition
    BEFORE UPDATE ON requests
    FOR EACH ROW
    EXECUTE FUNCTION check_status_transition();

-- Permissions: only migrations (postgres) change the rules.
-- The executor can read requests and the rules, and change only status.
REVOKE ALL ON allowed_transitions FROM PUBLIC;
GRANT SELECT ON allowed_transitions TO executor;
GRANT SELECT ON requests TO executor;
GRANT UPDATE (status) ON requests TO executor;
