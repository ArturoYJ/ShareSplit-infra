# ShareSplit Infra

Infraestructura Docker para ShareSplit: PostgreSQL 16 + Backend Express.

## Estructura

```
infra/
├── docker-compose.yml        # Orquestación de servicios
├── .env.example              # Variables de entorno requeridas
└── migrations/               # Migraciones SQL (se aplican en orden)
    ├── 001_create_users.sql
    ├── 002_create_groups.sql
    ├── 003_create_expenses.sql
    ├── 004_create_expense_items.sql
    ├── 005_create_item_claims.sql
    └── 006_create_payments.sql
```

## Inicio rápido

```bash
# 1. Copiar y ajustar variables
cp .env.example .env

# 2. Levantar todo (PostgreSQL + Backend)
docker compose up -d --build

# 3. Solo la base de datos (si el backend corre fuera de Docker)
docker compose up -d postgres
```

## Servicios

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| `postgres` | 5432 | PostgreSQL 16 |
| `backend`  | 3001 | API Express |

> Las migraciones se aplican automáticamente al iniciar PostgreSQL
> por primera vez (montadas en `/docker-entrypoint-initdb.d`).

## Resetear la BD

```bash
docker compose down -v   # Borra volumen de datos
docker compose up -d --build
```