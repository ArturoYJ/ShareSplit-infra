-- ============================================================
-- Migración 003: Gastos (Expenses)
-- Cabecera del ticket: quién pagó, dónde, cuánto en total.
-- El estado va de 'draft' → 'open' (en reclamo) → 'settled'.
-- ============================================================

CREATE TYPE expense_status AS ENUM ('draft', 'open', 'settled');

CREATE TABLE IF NOT EXISTS expenses (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id        UUID            NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    title           VARCHAR(200)    NOT NULL,           -- "Cena en La Piazza"
    place           VARCHAR(200),                       -- Lugar / restaurante
    total_amount    NUMERIC(12, 2)  NOT NULL CHECK (total_amount > 0),
    paid_by         UUID            NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    status          expense_status  NOT NULL DEFAULT 'draft',
    expense_date    DATE            NOT NULL DEFAULT CURRENT_DATE,
    notes           TEXT,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expenses_group  ON expenses(group_id);
CREATE INDEX IF NOT EXISTS idx_expenses_status ON expenses(status);

CREATE TRIGGER expenses_updated_at
    BEFORE UPDATE ON expenses
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
