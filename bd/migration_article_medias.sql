-- ============================================================
-- MIGRATION: Ajouter support pour articles_medias (relation N-N)
-- ============================================================

-- Créer la table de liaison article_medias
CREATE TABLE IF NOT EXISTS article_medias (
  id          SERIAL       PRIMARY KEY,
  article_id  INTEGER      NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  media_id    INTEGER      NOT NULL REFERENCES medias(id) ON DELETE CASCADE,
  ordre       INTEGER      NOT NULL DEFAULT 0,
  description TEXT,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, media_id)
);

COMMENT ON TABLE article_medias IS 'Relation N-N entre articles et medias pour supporter plusieurs images par article';
COMMENT ON COLUMN article_medias.ordre IS 'Ordre d affichage des images';

-- Index pour les recherches
CREATE INDEX idx_article_medias_article ON article_medias(article_id);
CREATE INDEX idx_article_medias_media ON article_medias(media_id);
CREATE INDEX idx_article_medias_ordre ON article_medias(article_id, ordre);
