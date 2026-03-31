# Mini Projet S6

Application web MVC avec gestion d'articles, catégories et médias.

## 🚀 Installation Rapide

### Prérequis
- Docker & Docker Compose
- Bash (Linux/macOS) ou Command Prompt (Windows)

### Démarrage

**Linux/macOS :**
```bash
./start.sh
```

**Windows :**
```cmd
start.bat
```

## 📍 Accès à l'application

- **Frontend :** http://localhost:8000/
- **Backoffice (Admin) :** http://localhost:8000/login

## 📁 Structure du Projet

```
.
├── docker/                 # Configuration Docker
│   └── php/
├── bd/                     # Base de données
│   ├── init-data.sql
│   └── migration_article_medias.sql
├── rewriting/              # Code source principal
│   ├── controllers/        # Contrôleurs (Admin, Article, Auth, etc.)
│   ├── models/             # Modèles (Article, Category, Media, User)
│   ├── views/              # Templates Vue
│   ├── core/               # Noyau (Router, Controller, Database, Auth)
│   ├── services/           # Services métier
│   ├── static/             # CSS et assets
│   └── uploads/            # Fichiers uploadés
└── docker-compose.yml      # Configuration des services
```

## 🛠️ Configuration

### Variables d'environnement
Copier `bd/env.example` et adapter les paramètres si nécessaire.

### Base de données
- **Système :** PostgreSQL
- **Initialisation automatique :** `init-data.sql`
- **Migrations :** `migration_article_medias.sql`

## 📦 Services

- **PHP 8+** - Serveur applicatif
- **PostgreSQL** - Base de données
- **Port 8000** - Accès web

## ⚙️ Outils Supplémentaires

- `optimize-images.sh` - Optimisation des images
- `reset.sh` / `reset.bat` - Réinitialisation du projet

## 📝 Architecture

- **Modèle MVC** - Séparation Model/View/Controller
- **Authentification** - Système de login/logout
- **Gestion des médias** - Upload et association aux articles
- **Admin panel** - Interface d'administration complète
