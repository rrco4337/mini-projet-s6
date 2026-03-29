package com.miniprojets6.article;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ArticleRepository extends JpaRepository<Article, Integer> {

    Optional<Article> findBySlug(String slug);

    Optional<Article> findBySlugAndStatut(String slug, ArticleStatut statut);

    List<Article> findByStatutOrderByDatePublicationDesc(ArticleStatut statut);

        @Query("""
                        SELECT a FROM Article a
                        LEFT JOIN a.categorie c
                        WHERE a.statut = :statut
                            AND (:categorySlug IS NULL OR c.slug = :categorySlug)
                            AND (:publicationDate IS NULL OR FUNCTION('DATE', a.datePublication) = :publicationDate)
                        ORDER BY a.datePublication DESC
                        """)
        List<Article> findPublishedByFilters(@Param("statut") ArticleStatut statut,
                                                                                 @Param("categorySlug") String categorySlug,
                                                                                 @Param("publicationDate") LocalDate publicationDate);

    @Query("SELECT a FROM Article a WHERE a.aLaUne = :aLaUne AND a.statut = :statut ORDER BY a.datePublication DESC")
    List<Article> findFeaturedArticles(@Param("aLaUne") Boolean aLaUne, @Param("statut") ArticleStatut statut);

    @Modifying
    @Query("UPDATE Article a SET a.vues = a.vues + 1 WHERE a.id = :id")
    void incrementVues(@Param("id") Integer id);
}
