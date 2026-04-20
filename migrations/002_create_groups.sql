-- ============================================================
-- Migración 002: Grupos y Membresías
-- Un grupo tiene un código de invitación único para que los
-- usuarios puedan unirse sin necesitar un enlace directo.
-- ============================================================

CREATE TABLE IF NOT EXISTS groups (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(150) NOT NULL,
    invite_code     VARCHAR(8)  NOT NULL UNIQUE,  -- ej. "ABC12345"
    created_by      UUID        NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_groups_invite_code ON groups(invite_code);

CREATE TRIGGER groups_updated_at
    BEFORE UPDATE ON groups
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ── Membresías (relación N:M entre usuarios y grupos) ──────────────────────

CREATE TYPE group_role AS ENUM ('owner', 'member');

CREATE TABLE IF NOT EXISTS group_members (
    group_id    UUID        NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id     UUID        NOT NULL REFERENCES users(id)  ON DELETE CASCADE,
    role        group_role  NOT NULL DEFAULT 'member',
    joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_group_members_user  ON group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_group_members_group ON group_members(group_id);
