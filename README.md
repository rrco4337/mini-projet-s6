# Mini Projet S6 - Lancement Docker

Cette configuration lance tout le projet de rewriting en conteneurs:

- Application PHP + Apache (URL rewriting)
- Base PostgreSQL avec initialisation automatique
- Adminer pour administrer la base

## Prerequis

- Docker Desktop installe et demarre
- Docker Compose v2

## Lancement

Depuis la racine du projet:

```bash
docker compose up --build -d
```

Ou en mode 100% automatique (recommande):

```bash
./start.sh
```

Ce script lance Docker Compose, attend PostgreSQL, initialise la base si besoin,
applique les migrations SQL et verifie que l'application repond.

## URLs

- Application: http://localhost:8000
- Adminer: http://localhost:8081

Connexion Adminer:

- System: PostgreSQL
- Server: db
- Username: postgres
- Password: admin
- Database: mini_projet_s6

## Arret

```bash
docker compose down
```

## Reinitialiser la base (schema + donnees)

```bash
docker compose down -v
docker compose up --build -d
```

Ou en une seule commande:

```bash
./reset.sh
```

Version non interactive:

```bash
./reset.sh --yes
```

## Mode local sans Docker (optionnel)

```bash
php -S localhost:8000 -t rewriting/rewriting rewriting/rewriting/index.php
```