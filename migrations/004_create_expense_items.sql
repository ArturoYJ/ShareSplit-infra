-- ============================================================
-- Migración 004: Ítems de Gasto (Expense Items)
-- Cada línea del ticket: nombre, precio unitario, cantidad.
-- El precio total del ítem = unit_price * quantity.
-- ============================================================

CREATE TABLE IF NOT EXISTS expense_items (
    id              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id      UUID            NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
    name            VARCHAR(200)    NOT NULL,           -- "Cerveza", "Pizza Pepperoni"
    unit_price      NUMERIC(12, 2)  NOT NULL CHECK (unit_price >= 0),
    quantity        NUMERIC(10, 2)  NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Columna calculada como VIEW para facilitar consultas
-- total_price = unit_price * quantity  (se computa en el SELECT, no se almacena)

CREATE INDEX IF NOT EXISTS idx_expense_items_expense ON expense_items(expense_id);
