-- ============================================================
-- Migración 005: Reclamos de Ítems (Item Claims)
-- Cada fila representa "este usuario consumió este ítem".
-- Si N usuarios reclaman el mismo ítem, cada uno paga
-- (unit_price * quantity) / N.
-- ============================================================

CREATE TABLE IF NOT EXISTS item_claims (
    item_id     UUID        NOT NULL REFERENCES expense_items(id) ON DELETE CASCADE,
    user_id     UUID        NOT NULL REFERENCES users(id)         ON DELETE CASCADE,
    claimed_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (item_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_item_claims_user ON item_claims(user_id);
CREATE INDEX IF NOT EXISTS idx_item_claims_item ON item_claims(item_id);
