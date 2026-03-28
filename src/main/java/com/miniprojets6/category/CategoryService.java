package com.miniprojets6.category;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Transactional(readOnly = true)
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Category findById(Integer id) {
        return categoryRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Categorie introuvable"));
    }

    public Category create(CategoryForm form) {
        if (categoryRepository.existsBySlug(form.getSlug())) {
            throw new IllegalArgumentException("Ce slug existe deja");
        }

        Category category = new Category();
        category.setNom(form.getNom().trim());
        category.setSlug(form.getSlug().trim().toLowerCase());
        category.setDescription(form.getDescription());
        return categoryRepository.save(category);
    }

    public Category update(Integer id, CategoryForm form) {
        Category category = findById(id);

        String nextSlug = form.getSlug().trim().toLowerCase();
        if (categoryRepository.existsBySlugAndIdNot(nextSlug, id)) {
            throw new IllegalArgumentException("Ce slug existe deja");
        }

        category.setNom(form.getNom().trim());
        category.setSlug(nextSlug);
        category.setDescription(form.getDescription());
        return categoryRepository.save(category);
    }

    public void delete(Integer id) {
        Category category = findById(id);
        categoryRepository.delete(category);
    }
}
