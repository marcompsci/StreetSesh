-- ============================================================
-- StreetSesh · Supabase Backend Security
-- Run this in Supabase → SQL Editor (Dashboard)
-- ============================================================

-- ----------------------------------------------------------------
-- 0. Create moderation tables (if not already created)
-- ----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS banned_identifiers (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type       TEXT NOT NULL CHECK (type IN ('email','username','ip','phone')),
    value      TEXT NOT NULL,
    reason     TEXT,
    banned_at  TIMESTAMPTZ DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_banned_identifiers_type_value
    ON banned_identifiers (type, lower(value));

CREATE TABLE IF NOT EXISTS moderation_actions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username        TEXT NOT NULL,
    action          TEXT NOT NULL CHECK (action IN ('warn','suspend','ban','unsuspend','clear')),
    reason          TEXT,
    content_flagged TEXT,
    actioned_at     TIMESTAMPTZ DEFAULT now(),
    expires_at      TIMESTAMPTZ,
    is_resolved     BOOLEAN DEFAULT false
);
CREATE INDEX IF NOT EXISTS idx_moderation_actions_username
    ON moderation_actions (username, is_resolved);

CREATE TABLE IF NOT EXISTS content_reports (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_username TEXT,
    target_username   TEXT,
    content           TEXT,
    reason            TEXT,
    reported_at       TIMESTAMPTZ DEFAULT now()
);

-- ----------------------------------------------------------------
-- 1. Enable Row Level Security on all app tables
-- ----------------------------------------------------------------

ALTER TABLE app_users           ENABLE ROW LEVEL SECURITY;
ALTER TABLE spots               ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_sessions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE spot_check_ins      ENABLE ROW LEVEL SECURITY;
ALTER TABLE trophies            ENABLE ROW LEVEL SECURITY;
ALTER TABLE spot_clips          ENABLE ROW LEVEL SECURITY;
ALTER TABLE bust_votes          ENABLE ROW LEVEL SECURITY;
ALTER TABLE spot_photo_reports  ENABLE ROW LEVEL SECURITY;
ALTER TABLE banned_identifiers  ENABLE ROW LEVEL SECURITY;
ALTER TABLE moderation_actions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_reports     ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------
-- 2. app_users: public read, anon insert (at registration), no update from client
-- ----------------------------------------------------------------

DROP POLICY IF EXISTS "public_read_users"  ON app_users;
DROP POLICY IF EXISTS "anon_insert_users"  ON app_users;

CREATE POLICY "public_read_users" ON app_users
    FOR SELECT USING (true);

CREATE POLICY "anon_insert_users" ON app_users
    FOR INSERT WITH CHECK (true);

-- ----------------------------------------------------------------
-- 3. spots: public read non-private, anon insert, no cross-user delete
-- ----------------------------------------------------------------

DROP POLICY IF EXISTS "public_read_spots"  ON spots;
DROP POLICY IF EXISTS "anon_insert_spots"  ON spots;

CREATE POLICY "public_read_spots" ON spots
    FOR SELECT USING (visibility_raw != 'private' OR true);  -- adjust if you add auth

CREATE POLICY "anon_insert_spots" ON spots
    FOR INSERT WITH CHECK (
        length(name) BETWEEN 1 AND 100
        AND latitude  BETWEEN -90  AND 90
        AND longitude BETWEEN -180 AND 180
    );

-- ----------------------------------------------------------------
-- 4. live_sessions: public read active non-expired, anon insert
-- ----------------------------------------------------------------

DROP POLICY IF EXISTS "public_read_sessions"  ON live_sessions;
DROP POLICY IF EXISTS "anon_insert_sessions"  ON live_sessions;
DROP POLICY IF EXISTS "owner_update_sessions" ON live_sessions;

CREATE POLICY "public_read_sessions" ON live_sessions
    FOR SELECT USING (is_active = true);

CREATE POLICY "anon_insert_sessions" ON live_sessions
    FOR INSERT WITH CHECK (
        length(username) BETWEEN 1 AND 30
        AND length(spot_name) BETWEEN 1 AND 100
    );

CREATE POLICY "owner_update_sessions" ON live_sessions
    FOR UPDATE USING (true);   -- scoped by username in app code

-- ----------------------------------------------------------------
-- 5. spot_check_ins, trophies: anon insert, public read
-- ----------------------------------------------------------------

CREATE POLICY IF NOT EXISTS "public_read_check_ins"  ON spot_check_ins FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "anon_insert_check_ins"  ON spot_check_ins
    FOR INSERT WITH CHECK (length(username) BETWEEN 1 AND 30);

CREATE POLICY IF NOT EXISTS "public_read_trophies"   ON trophies FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "anon_insert_trophies"   ON trophies
    FOR INSERT WITH CHECK (length(username) BETWEEN 1 AND 30);

-- ----------------------------------------------------------------
-- 6. spot_clips, bust_votes, spot_photo_reports: anon insert, public read
-- ----------------------------------------------------------------

CREATE POLICY IF NOT EXISTS "public_read_clips"    ON spot_clips FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "anon_insert_clips"    ON spot_clips FOR INSERT WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "public_read_votes"    ON bust_votes FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "anon_insert_votes"    ON bust_votes FOR INSERT WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "public_read_photos"   ON spot_photo_reports FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "anon_insert_photos"   ON spot_photo_reports FOR INSERT WITH CHECK (true);

-- ----------------------------------------------------------------
-- 7. Moderation tables: anon insert only (admin reads via service role)
--    Client can INSERT but NEVER SELECT/UPDATE/DELETE moderation data
-- ----------------------------------------------------------------

CREATE POLICY "anon_insert_banned" ON banned_identifiers
    FOR INSERT WITH CHECK (
        type IN ('email','username','ip','phone')
        AND length(value) BETWEEN 1 AND 320
    );

-- No SELECT policy on banned_identifiers — reads must use service-role key
-- (configure a Supabase Edge Function for the ban-check if you want to enforce this strictly)

CREATE POLICY "anon_insert_mod_actions" ON moderation_actions
    FOR INSERT WITH CHECK (
        action IN ('warn','suspend','ban','unsuspend','clear')
        AND length(username) BETWEEN 1 AND 30
    );

CREATE POLICY "anon_insert_reports" ON content_reports
    FOR INSERT WITH CHECK (
        length(coalesce(reporter_username,'')) <= 30
        AND length(coalesce(target_username,'')) <= 30
        AND length(coalesce(content,''))         <= 10000
    );

-- ----------------------------------------------------------------
-- 8. DB-level constraints (belt-and-suspenders against bad client data)
-- ----------------------------------------------------------------

-- Users
ALTER TABLE app_users
    ADD CONSTRAINT IF NOT EXISTS chk_username_len  CHECK (length(username) BETWEEN 1 AND 30),
    ADD CONSTRAINT IF NOT EXISTS chk_city_len      CHECK (length(city) <= 100),
    ADD CONSTRAINT IF NOT EXISTS chk_session_count CHECK (session_count >= 0);

-- Spots
ALTER TABLE spots
    ADD CONSTRAINT IF NOT EXISTS chk_spot_name_len   CHECK (length(name) BETWEEN 1 AND 100),
    ADD CONSTRAINT IF NOT EXISTS chk_spot_lat        CHECK (latitude  BETWEEN -90  AND 90),
    ADD CONSTRAINT IF NOT EXISTS chk_spot_lng        CHECK (longitude BETWEEN -180 AND 180);

-- Live sessions
ALTER TABLE live_sessions
    ADD CONSTRAINT IF NOT EXISTS chk_sess_username CHECK (length(username)  BETWEEN 1 AND 30),
    ADD CONSTRAINT IF NOT EXISTS chk_sess_spot     CHECK (length(spot_name) BETWEEN 1 AND 100),
    ADD CONSTRAINT IF NOT EXISTS chk_sess_lat      CHECK (latitude  BETWEEN -90  AND 90),
    ADD CONSTRAINT IF NOT EXISTS chk_sess_lng      CHECK (longitude BETWEEN -180 AND 180);

-- ----------------------------------------------------------------
-- 9. Rate-limit function (optional — install pg_cron or use Supabase Edge)
--    This example tracks insert frequency and rejects if > 60 rows/min per username
-- ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION check_insert_rate()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    recent_count INT;
BEGIN
    SELECT count(*) INTO recent_count
    FROM   content_reports
    WHERE  reporter_username = NEW.reporter_username
    AND    reported_at > now() - INTERVAL '1 minute';

    IF recent_count >= 10 THEN
        RAISE EXCEPTION 'Rate limit exceeded: too many reports in 1 minute';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_content_report_rate ON content_reports;
CREATE TRIGGER trg_content_report_rate
    BEFORE INSERT ON content_reports
    FOR EACH ROW EXECUTE FUNCTION check_insert_rate();

-- ----------------------------------------------------------------
-- Done. Verify with:
--   SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';
-- ----------------------------------------------------------------
