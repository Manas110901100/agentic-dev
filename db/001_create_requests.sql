-- Every change an agent wants is one row here. Agents never act directly.
CREATE TABLE requests (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_type  TEXT NOT NULL CHECK (request_type IN (
                      'code_change', 'deploy', 'agent_create',
                      'agent_update', 'agent_retire', 'config_change')),
    title         TEXT NOT NULL,
    description   TEXT NOT NULL,
    risk_level    TEXT NOT NULL CHECK (risk_level IN ('low', 'medium', 'high')),
    status        TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN (
                      'submitted', 'validating', 'pending_approval',
                      'approved', 'rejected', 'executing',
                      'completed', 'failed', 'rolled_back', 'expired')),
    submitted_by  TEXT NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at    TIMESTAMPTZ NOT NULL DEFAULT now() + INTERVAL '7 days'
);
