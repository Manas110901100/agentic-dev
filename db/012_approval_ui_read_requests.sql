-- 012: Let the approval UI read requests (Phase 3, PR B).
-- The page needs to list requests. Read only: approval_ui still cannot
-- INSERT, UPDATE or DELETE requests (no grant for those).
-- Note: requests.description is text written by agents (untrusted);
-- the page must show it as plain text, never as HTML.

GRANT SELECT ON requests TO approval_ui;
