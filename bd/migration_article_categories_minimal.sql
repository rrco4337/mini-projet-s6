-- Minimal migration production: article multi-categories
-- Scope: CREATE + INSERT only (no DROP, no full schema replay)
-- Safe to run multiple times.

BEGIN;

CREATE TABLE IF NOT EXISTS article_categories (
  article_id  INTEGER NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY (article_id, category_id)
);

-- Backfill from legacy single-category column
INSERT INTO article_categories (article_id, category_id)
SELECT a.id, a.categorie_id
FROM articles a
WHERE a.categorie_id IS NOT NULL
ON CONFLICT (article_id, category_id) DO NOTHING;

COMMIT;
