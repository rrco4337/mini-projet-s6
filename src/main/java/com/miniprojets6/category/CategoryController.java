package com.miniprojets6.category;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/categories")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("categories", categoryService.findAll());
        return "categories/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("categoryForm", new CategoryForm());
        model.addAttribute("mode", "create");
        return "categories/form";
    }

    @PostMapping
    public String create(@Valid @ModelAttribute("categoryForm") CategoryForm form,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("mode", "create");
            return "categories/form";
        }

        try {
            categoryService.create(form);
        } catch (IllegalArgumentException ex) {
            bindingResult.rejectValue("slug", "slug.duplicate", ex.getMessage());
            model.addAttribute("mode", "create");
            return "categories/form";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Categorie creee avec succes");
        return "redirect:/categories";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Category category = categoryService.findById(id);
            CategoryForm form = new CategoryForm();
            form.setNom(category.getNom());
            form.setSlug(category.getSlug());
            form.setDescription(category.getDescription());

            model.addAttribute("categoryId", id);
            model.addAttribute("categoryForm", form);
            model.addAttribute("mode", "edit");
            return "categories/form";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/categories";
        }
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Integer id,
                         @Valid @ModelAttribute("categoryForm") CategoryForm form,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("categoryId", id);
            model.addAttribute("mode", "edit");
            return "categories/form";
        }

        try {
            categoryService.update(id, form);
        } catch (IllegalArgumentException ex) {
            bindingResult.rejectValue("slug", "slug.duplicate", ex.getMessage());
            model.addAttribute("categoryId", id);
            model.addAttribute("mode", "edit");
            return "categories/form";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Categorie modifiee avec succes");
        return "redirect:/categories";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            categoryService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Categorie supprimee avec succes");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/categories";
    }
}
