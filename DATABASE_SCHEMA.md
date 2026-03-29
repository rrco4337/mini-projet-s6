# Schéma de Base de Données - Iran War News

## 🗃️ Vue d'ensemble

Base de données PostgreSQL 16 avec encodage UTF-8 pour le système de gestion de contenu Iran War News.

## 📊 Diagramme de relations

```
                    ┌─────────────────────────────┐
                    │         categories          │
                    │─────────────────────────────│
                    │ id (SERIAL PK)              │
                    │ nom (VARCHAR 100) NOT NULL  │
                    │ slug (VARCHAR 110) UNIQUE   │
                    │ description (TEXT)          │
                    │ created_at (TIMESTAMPTZ)    │
                    │ updated_at (TIMESTAMPTZ)    │
                    └─────────────┬───────────────┘
                                  │ 1
                                  │
                                  │ N
                    ┌─────────────▼───────────────────────────┐
                    │              articles               │
                    │─────────────────────────────────────────│
                    │ id (SERIAL PK)                      │
                    │ titre (VARCHAR 255) NOT NULL        │
                    │ slug (VARCHAR 270) UNIQUE           │
                    │ sous_titre (VARCHAR 255)            │
                    │ chapeau (TEXT)                      │
                    │ contenu (TEXT) NOT NULL             │
                    │ meta_title (VARCHAR 70)             │
                    │ meta_description (VARCHAR 165)      │
                    │ meta_keywords (VARCHAR 255)         │
                    │ image_une (INTEGER FK → medias)     │
                    │ categorie_id (INTEGER FK)           │◄─┘
                    │ auteur_id (INTEGER FK)              │◄─┐
                    │ statut (article_statut)             │  │
                    │ a_la_une (BOOLEAN)                  │  │
                    │ vues (INTEGER DEFAULT 0)            │  │
                    │ date_publication (TIMESTAMPTZ)      │  │
                    │ created_at (TIMESTAMPTZ)            │  │
                    │ updated_at (TIMESTAMPTZ)            │  │
                    └─────────────────────────────────────────┘  │
                                                                  │ N
                                                                  │
                                                                  │
                                                                  │ 1
                    ┌─────────────────────────────┐               │
                    │           users             │───────────────┘
                    │─────────────────────────────│
                    │ id (SERIAL PK)              │
                    │ username (VARCHAR 60) UNIQUE│
                    │ email (VARCHAR 150) UNIQUE  │
                    │ password_hash (VARCHAR 255) │
                    │ role (user_role)            │
                    │ actif (BOOLEAN DEFAULT TRUE)│
                    │ created_at (TIMESTAMPTZ)    │
                    │ updated_at (TIMESTAMPTZ)    │
                    └─────────────┬───────────────┘
                                  │ 1
                                  │
                                  │ N
                    ┌─────────────▼───────────────┐
                    │           medias            │
                    │─────────────────────────────│
                    │ id (SERIAL PK)              │
                    │ fichier (VARCHAR 255)       │
                    │ alt (VARCHAR 200) NOT NULL  │
                    │ titre (VARCHAR 200)         │
                    │ description (TEXT)          │
                    │ mime_type (VARCHAR 60)      │
                    │ taille (INTEGER)            │
                    │ uploaded_by (INTEGER FK)    │◄─┘
                    │ created_at (TIMESTAMPTZ)    │
                    └─────────────────────────────┘
```

## 🏗️ Structure détaillée des tables

### Table `categories`
**Rôle :** Classification des articles par thématique

| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | SERIAL | PRIMARY KEY | Identifiant unique auto-incrémenté |
| `nom` | VARCHAR(100) | NOT NULL | Nom affiché de la catégorie |
| `slug` | VARCHAR(110) | NOT NULL, UNIQUE | URL-friendly (ex: "politique") |
| `description` | TEXT | - | Description détaillée |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Date de création |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Dernière modification |

**Index :**
- `PRIMARY KEY` sur `id`
- `UNIQUE` sur `slug`

**Données initiales :**
```sql
INSERT INTO categories (nom, slug, description) VALUES
  ('Politique', 'politique', 'Actualités politiques liées au conflit en Iran'),
  ('Militaire', 'militaire', 'Opérations, stratégies et forces en présence'),
  ('Humanitaire', 'humanitaire', 'Impact sur les populations civiles'),
  ('Diplomatie', 'diplomatie', 'Négociations et relations internationales'),
  ('Économie', 'economie', 'Conséquences économiques du conflit'),
  ('Médias', 'medias', 'Couverture presse et désinformation');
```

### Table `articles`
**Rôle :** Contenu éditorial principal du site

| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | SERIAL | PRIMARY KEY | Identifiant unique |
| `titre` | VARCHAR(255) | NOT NULL | Titre principal H1 |
| `slug` | VARCHAR(270) | NOT NULL, UNIQUE | URL rewriting |
| `sous_titre` | VARCHAR(255) | - | Sous-titre H2 optionnel |
| `chapeau` | TEXT | - | Introduction/résumé |
| `contenu` | TEXT | NOT NULL | Corps HTML de l'article |
| `meta_title` | VARCHAR(70) | - | SEO: titre (≤60 recommandé) |
| `meta_description` | VARCHAR(165) | - | SEO: description (≤155 recommandé) |
| `meta_keywords` | VARCHAR(255) | - | SEO: mots-clés séparés par virgules |
| `image_une` | INTEGER | FK medias(id) | Image principale |
| `categorie_id` | INTEGER | FK categories(id) | Catégorie parente |
| `auteur_id` | INTEGER | FK users(id) | Rédacteur |
| `statut` | article_statut | NOT NULL, DEFAULT 'brouillon' | État de publication |
| `a_la_une` | BOOLEAN | NOT NULL, DEFAULT FALSE | Mise en avant accueil |
| `vues` | INTEGER | NOT NULL, DEFAULT 0, CHECK ≥ 0 | Compteur de vues |
| `date_publication` | TIMESTAMPTZ | - | Date de mise en ligne |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Création |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Modification |

**Index de performance :**
```sql
CREATE INDEX idx_articles_statut ON articles(statut);
CREATE INDEX idx_articles_categorie ON articles(categorie_id);
CREATE INDEX idx_articles_date ON articles(date_publication DESC NULLS LAST);
-- Index partiel pour le front-office
CREATE INDEX idx_articles_publies ON articles(date_publication DESC NULLS LAST)
  WHERE statut = 'publie';
```

**Cas d'usage URL rewriting :**
```
Article titre: "Tensions croissantes en Iran"
       slug:   "tensions-croissantes-iran"
       URL:    /article/tensions-croissantes-iran
```

### Table `users`
**Rôle :** Utilisateurs du back-office avec authentification

| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | SERIAL | PRIMARY KEY | Identifiant unique |
| `username` | VARCHAR(60) | NOT NULL, UNIQUE | Login utilisateur |
| `email` | VARCHAR(150) | NOT NULL, UNIQUE | Adresse email |
| `password_hash` | VARCHAR(255) | NOT NULL | Hash BCrypt |
| `role` | user_role | NOT NULL, DEFAULT 'editeur' | Niveau d'autorisation |
| `actif` | BOOLEAN | NOT NULL, DEFAULT TRUE | Compte activé |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Création compte |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Dernière modification |

**Sécurité :**
- Mots de passe stockés avec BCrypt (coût 12)
- Email unique pour récupération
- Flag `actif` pour désactivation sans suppression

### Table `medias`
**Rôle :** Gestion des fichiers uploadés (images, documents)

| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | SERIAL | PRIMARY KEY | Identifiant unique |
| `fichier` | VARCHAR(255) | NOT NULL | Chemin relatif du fichier |
| `alt` | VARCHAR(200) | NOT NULL | Texte alternatif (accessibility/SEO) |
| `titre` | VARCHAR(200) | - | Titre descriptif |
| `description` | TEXT | - | Description détaillée |
| `mime_type` | VARCHAR(60) | - | Type MIME (image/jpeg, etc.) |
| `taille` | INTEGER | CHECK ≥ 0 | Taille en octets |
| `uploaded_by` | INTEGER | FK users(id) | Utilisateur ayant uploadé |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() | Date d'upload |

## 🔧 Types ENUM personnalisés

### Type `user_role`
```sql
CREATE TYPE user_role AS ENUM ('admin', 'editeur', 'lecteur');
```
- **admin :** Accès complet (utilisateurs, contenus, paramètres)
- **editeur :** Gestion contenus (articles, catégories)
- **lecteur :** Lecture seule (tableau de bord)

### Type `article_statut`
```sql
CREATE TYPE article_statut AS ENUM ('brouillon', 'publie', 'archive');
```
- **brouillon :** Non visible public, en cours de rédaction
- **publie :** Visible sur le front-office
- **archive :** Masqué mais conservé

## ⚙️ Triggers et fonctions

### Fonction de mise à jour automatique
```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;
```

### Triggers sur les tables principales
```sql
CREATE TRIGGER trg_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_articles_updated_at
  BEFORE UPDATE ON articles
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
```

## 📈 Optimisations de performance

### Index stratégiques
1. **Front-office** : Index partiel sur `articles` filtrés par `statut='publie'`
2. **Navigation** : Index sur `articles(categorie_id)` pour tri par catégorie
3. **Chronologie** : Index descendant sur `date_publication` pour affichage chronologique

### Requêtes optimisées
```sql
-- Page d'accueil : articles à la une
SELECT * FROM articles
WHERE statut = 'publie' AND a_la_une = true
ORDER BY date_publication DESC LIMIT 3;

-- Liste articles d'une catégorie
SELECT a.*, c.nom as categorie_nom
FROM articles a
JOIN categories c ON a.categorie_id = c.id
WHERE a.statut = 'publie' AND c.slug = $1
ORDER BY a.date_publication DESC;
```

## 🔗 Relations et contraintes

### Relations principales
- **Article ↔ Catégorie** : Many-to-One (un article = une catégorie)
- **Article ↔ User** : Many-to-One (un article = un auteur)
- **Media ↔ User** : Many-to-One (un média = un uploader)
- **Article ↔ Media** : One-to-One optionnel (image à la une)

### Contraintes référentielles
- **ON DELETE SET NULL** : Suppression catégorie/auteur → article garde référence NULL
- **ON DELETE CASCADE** : Suppression article → suppression commentaires liés
- **UNIQUE** : Slugs uniques pour URL rewriting

## 🚀 Évolutions possibles

### Extensions futures
1. **Table `tags`** : Système de mots-clés avec relation Many-to-Many
2. **Table `commentaires`** : Système de commentaires modérés
3. **Table `logs_connexion`** : Audit des connexions admin
4. **Table `parametres_site`** : Configuration globale

### Optimisations avancées
- Partitioning par date sur `articles`
- Index gin/gist pour recherche full-text
- Vues matérialisées pour statistiques

---

**📊 Schéma créé pour ETU3367 - Mini-Projet S6 Mars 2026**