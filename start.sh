#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

DB_NAME="mini_projet_s6"
DB_USER="postgres"
DB_PASSWORD="admin"

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker n'est pas installe ou introuvable dans le PATH."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "[ERROR] Docker Compose v2 est requis (commande: docker compose)."
  exit 1
fi

echo "[1/6] Build + demarrage des services Docker..."
docker compose up -d --build

DB_CID="$(docker compose ps -q db)"
if [[ -z "$DB_CID" ]]; then
  echo "[ERROR] Impossible de trouver le conteneur DB."
  exit 1
fi

echo "[2/6] Attente de PostgreSQL (healthcheck)..."
for _ in {1..60}; do
  DB_HEALTH="$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}unknown{{end}}' "$DB_CID")"
  if [[ "$DB_HEALTH" == "healthy" ]]; then
    break
  fi
  sleep 2
done

if [[ "$DB_HEALTH" != "healthy" ]]; then
  echo "[ERROR] PostgreSQL n'est pas devenu healthy a temps."
  docker compose logs --tail=80 db || true
  exit 1
fi

echo "[3/6] Alignement du mot de passe reseau PostgreSQL..."
docker compose exec -T db sh -lc "psql -U postgres -d postgres -v ON_ERROR_STOP=1 -c \"ALTER ROLE postgres WITH PASSWORD '$DB_PASSWORD';\"" >/dev/null

SCHEMA_EXISTS="$(docker compose exec -T db sh -lc "psql -U $DB_USER -d $DB_NAME -tAc \"SELECT to_regclass('public.articles') IS NOT NULL;\"")"

echo "[4/6] Initialisation base de donnees si necessaire..."
if [[ "$SCHEMA_EXISTS" != "t" ]]; then
  docker compose exec -T db sh -lc "psql -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/01-base.sql"
  docker compose exec -T db sh -lc "psql -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/02-init-data.sql"
else
  echo "Schema deja present, initialisation completee precedemment."
fi

echo "[5/6] Application des migrations SQL..."
shopt -s nullglob
for sql_file in "$ROOT_DIR"/bd/migration_*.sql; do
  echo " - $(basename "$sql_file")"
  docker compose exec -T db sh -lc "psql -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1" < "$sql_file"
done
shopt -u nullglob

echo "[6/6] Verification finale..."
APP_STATUS="$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8000 || true)"
if [[ "$APP_STATUS" != "200" ]]; then
  echo "[WARN] L'application ne repond pas en HTTP 200 (code: $APP_STATUS)."
  docker compose logs --tail=80 web || true
  exit 1
fi

echo ""
echo "Projet pret."
echo "- Application: http://localhost:8000"
echo "- Adminer: http://localhost:8081"
echo "- DB: $DB_NAME (user: $DB_USER)"
