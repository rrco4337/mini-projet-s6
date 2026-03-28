# mini-projet-s6

## Initialisation Spring Boot + PostgreSQL

Le projet contient maintenant une base backend Spring Boot connectee a PostgreSQL.

### Prerequis

- Java 21
- Maven 3.9+
- Docker (optionnel, recommande pour PostgreSQL)

### Demarrer PostgreSQL avec Docker

```bash
docker compose up -d
```

La base exposee localement:

- Host: `localhost`
- Port: `5433`
- Database: `mini_projet_s6`
- Username: `postgres`
- Password: `postgres`

### Lancer l'application

```bash
mvn spring-boot:run
```

Interface CRUD categorie (JSP, sans API):

- Liste: `http://localhost:8080/categories`
- Creation: `http://localhost:8080/categories/new`

Endpoint de test:

```bash
curl http://localhost:8080/api/health
```

Reponse attendue:

```json
{"status":"ok"}
```

### Configuration

Les variables d'environnement sont configurees dans `.env.example`:

- `DB_URL`
- `DB_USERNAME`
- `DB_PASSWORD`
- `SERVER_PORT`

Note: le fichier `bd/base.sql` est un script MySQL. Pour PostgreSQL, il faudra l'adapter avant import.

La page categories utilise la table PostgreSQL suivante:

```sql
CREATE TABLE IF NOT EXISTS categories (
	id          SERIAL       PRIMARY KEY,
	nom         VARCHAR(100) NOT NULL,
	slug        VARCHAR(110) NOT NULL UNIQUE,
	description TEXT,
	created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
	updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
```

Partie
Tâches détaillées
Sous-tâches précises
Livrables associés
🔹 Partie 1 : Frontend / UX / SEO
Création du site d’information
- Définir la structure du site (Accueil, Articles, etc.)- Rédiger ou intégrer les contenus sur la guerre en Iran- Organiser les pages
Pages web fonctionnelles


Développement FrontOffice
- HTML/CSS/JS- Affichage dynamique des contenus (articles, images)- Navigation (menu, liens)
Interface utilisateur complète


Structure HTML & SEO
- Utilisation correcte des balises h1 à h6- Hiérarchie claire des contenus- Titres de pages pertinents
Code HTML propre


Optimisation SEO
- Ajout des balises meta (description, keywords)- URL rewriting (routes propres)- Texte optimisé (mots-clés)
Pages optimisées SEO


Accessibilité & images
- Ajout attribut alt sur toutes les images- Vérification lisibilité
Site accessible


Tests & performance
- Test Lighthouse (mobile + desktop)- Optimisation vitesse (images, CSS)
Rapport Lighthouse


UI / Design
- Design cohérent (couleurs, typo)- Responsive (mobile/desktop)
Site responsive


Partie
Tâches détaillées
Sous-tâches précises
Livrables associés
🔹 Partie 2 : Backend / Base de données / DevOps
Conception base de données
- Identifier les entités (articles, utilisateurs, etc.)- Créer schéma relationnel- Normalisation
Modèle de BD


Implémentation BD
- Création tables- Relations (clé étrangère)- Insertion données test
Base fonctionnelle


Développement BackOffice
- CRUD (Créer, lire, modifier, supprimer contenu)- Interface admin
Backoffice complet


Authentification
- Système login- User/password par défaut- Sécurisation minimale
Accès admin


Liaison FO ↔ BO
- API ou requêtes BD- Récupération dynamique des données
Site dynamique


Dockerisation
- Création conteneurs (app + BD)- Fichier docker-compose- Test lancement
Projet dockerisé


Dépôt Git
- Création repo GitHub/GitLab- Organisation du code- README
Repo public


Documentation technique
- Captures FO et BO- Modélisation BD- Explication technique- Identifiants BO- Numéro étudiant
Document PDF ou Word


