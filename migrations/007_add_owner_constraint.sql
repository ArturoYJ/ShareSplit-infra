-- ============================================================
-- Migración 007: Garantizar un solo owner por grupo
-- Agrega índice único parcial sobre group_members para que
-- la base de datos rechace insertar un segundo owner en el
-- mismo grupo, sin afectar miembros con rol 'member'.
-- ============================================================

CREATE UNIQUE INDEX IF NOT EXISTS idx_group_members_single_owner
  ON group_members (group_id)
  WHERE role = 'owner';

-- Comentario: Este índice es un guardián a nivel DB.
-- La lógica de negocio en groups.js ya evita duplicados de owner,
-- pero este constraint lo hace inviolable ante cualquier error futuro.
