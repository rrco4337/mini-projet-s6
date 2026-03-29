package com.miniprojets6.article;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ArticleRepository extends JpaRepository<Article, Integer> {

    Optional<Article> findBySlug(String slug);

    Optional<Article> findBySlugAndStatut(String slug, ArticleStatut statut);

    List<Article> findByStatutOrderByDatePublicationDesc(ArticleStatut statut);

    @Query("""
                    SELECT DISTINCT a FROM Article a
                    LEFT JOIN a.categories c
                    LEFT JOIN a.categorie legacyCategory
                    WHERE a.statut = :statut
                        AND (c.slug IN :categorySlugs OR legacyCategory.slug IN :categorySlugs)
                    ORDER BY a.datePublication DESC
                    """)
    List<Article> findPublishedByCategories(@Param("statut") ArticleStatut statut,
                                            @Param("categorySlugs") List<String> categorySlugs);

        @Query("""
                        SELECT a FROM Article a
                        WHERE a.statut = :statut
                            AND a.datePublication >= :startDate
                            AND a.datePublication < :endDate
                        ORDER BY a.datePublication DESC
                        """)
        List<Article> findPublishedByDateRange(@Param("statut") ArticleStatut statut,
                                                                                     @Param("startDate") OffsetDateTime startDate,
                                                                                     @Param("endDate") OffsetDateTime endDate);

    @Query("""
                    SELECT DISTINCT a FROM Article a
                    LEFT JOIN a.categories c
                    LEFT JOIN a.categorie legacyCategory
                    WHERE a.statut = :statut
                        AND (c.slug IN :categorySlugs OR legacyCategory.slug IN :categorySlugs)
                        AND a.datePublication >= :startDate
                        AND a.datePublication < :endDate
                    ORDER BY a.datePublication DESC
                    """)
    List<Article> findPublishedByCategoriesAndDateRange(@Param("statut") ArticleStatut statut,
                                                        @Param("categorySlugs") List<String> categorySlugs,
                                                        @Param("startDate") OffsetDateTime startDate,
                                                        @Param("endDate") OffsetDateTime endDate);

    @Query("SELECT a FROM Article a WHERE a.aLaUne = :aLaUne AND a.statut = :statut ORDER BY a.datePublication DESC")
    List<Article> findFeaturedArticles(@Param("aLaUne") Boolean aLaUne, @Param("statut") ArticleStatut statut);

    @Modifying
    @Query("UPDATE Article a SET a.vues = a.vues + 1 WHERE a.id = :id")
    void incrementVues(@Param("id") Integer id);
}
