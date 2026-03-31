#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker n'est pas installe ou introuvable dans le PATH."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "[ERROR] Docker Compose v2 est requis (commande: docker compose)."
  exit 1
fi

if [[ "${1:-}" != "--yes" ]]; then
  echo "Cette operation va supprimer les volumes Docker du projet (base de donnees comprise)."
  read -r -p "Continuer ? (oui/non): " answer
  case "$answer" in
    oui|o|yes|y|OUI|Oui)
      ;;
    *)
      echo "Operation annulee."
      exit 0
      ;;
  esac
fi

echo "[1/2] Suppression des conteneurs + volumes du projet..."
docker compose down -v --remove-orphans

echo "[2/2] Reinitialisation complete via start.sh..."
"$ROOT_DIR/start.sh"
