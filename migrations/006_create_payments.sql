-- ============================================================
-- Migración 006: Pagos / Reembolsos (Payments)
-- Registra cuando un miembro le paga a otro para saldar deudas.
-- from_user_id  →  le paga a  →  to_user_id
-- ============================================================

CREATE TABLE IF NOT EXISTS payments (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id        UUID            NOT NULL REFERENCES groups(id)  ON DELETE CASCADE,
    from_user_id    UUID            NOT NULL REFERENCES users(id)   ON DELETE RESTRICT,
    to_user_id      UUID            NOT NULL REFERENCES users(id)   ON DELETE RESTRICT,
    amount          NUMERIC(12, 2)  NOT NULL CHECK (amount > 0),
    note            VARCHAR(255),
    paid_at         TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT no_self_payment CHECK (from_user_id <> to_user_id)
);

CREATE INDEX IF NOT EXISTS idx_payments_group     ON payments(group_id);
CREATE INDEX IF NOT EXISTS idx_payments_from_user ON payments(from_user_id);
CREATE INDEX IF NOT EXISTS idx_payments_to_user   ON payments(to_user_id);
