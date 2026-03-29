#!/bin/bash

# Script d'arrêt pour Iran War News
echo "======================================"
echo "  🛑 Iran War News - Arrêt"
echo "======================================"

echo "🔄 Arrêt des conteneurs..."
docker-compose down

echo "🗑️  Suppression des volumes (optionnel) ?"
read -p "Supprimer les données de la base ? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Suppression des volumes..."
    docker-compose down -v
    echo "✅ Volumes supprimés"
else
    echo "💾 Volumes conservés"
fi

echo "🧹 Nettoyage des images non utilisées..."
docker image prune -f

echo "✅ Arrêt terminé"