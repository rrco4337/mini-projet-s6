package com.miniprojets6.article;

import com.miniprojets6.category.CategoryService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/articles")
public class ArticleController {

    private final ArticleService articleService;
    private final CategoryService categoryService;

    public ArticleController(ArticleService articleService, CategoryService categoryService) {
        this.articleService = articleService;
        this.categoryService = categoryService;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("articles", articleService.findAll());
        return "admin/articles/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("articleForm", new ArticleForm());
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("statuts", ArticleStatut.values());
        model.addAttribute("mode", "create");
        return "admin/articles/form";
    }

    @PostMapping
    public String create(@Valid @ModelAttribute("articleForm") ArticleForm form,
                         @RequestParam(value = "images", required = false) MultipartFile[] images,
                         @RequestParam(value = "imageAlts", required = false) String imageAlts,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("categories", categoryService.findAll());
            model.addAttribute("statuts", ArticleStatut.values());
            model.addAttribute("mode", "create");
            return "admin/articles/form";
        }

        try {
            articleService.create(form, images, imageAlts);
        } catch (IllegalArgumentException ex) {
            if (ex.getMessage() != null && ex.getMessage().contains("slug")) {
                bindingResult.rejectValue("slug", "slug.duplicate", ex.getMessage());
            } else {
                bindingResult.reject("article.error", ex.getMessage());
            }
            model.addAttribute("categories", categoryService.findAll());
            model.addAttribute("statuts", ArticleStatut.values());
            model.addAttribute("mode", "create");
            return "admin/articles/form";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Article cree avec succes");
        return "redirect:/admin/articles";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Article article = articleService.findById(id);
            ArticleForm form = new ArticleForm();
            form.setTitre(article.getTitre());
            form.setSlug(article.getSlug());
            form.setSousTitre(article.getSousTitre());
            form.setChapeau(article.getChapeau());
            form.setContenu(article.getContenu());
            form.setMetaTitle(article.getMetaTitle());
            form.setMetaDescription(article.getMetaDescription());
            form.setMetaKeywords(article.getMetaKeywords());
            form.setStatut(article.getStatut());
            form.setALaUne(article.getALaUne());
            if (article.getCategories() != null && !article.getCategories().isEmpty()) {
                form.setCategorieIds(article.getCategories().stream()
                        .map(category -> category.getId())
                        .collect(Collectors.toList()));
            } else if (article.getCategorie() != null) {
                form.setCategorieId(article.getCategorie().getId());
            }

            model.addAttribute("articleId", id);
            model.addAttribute("articleForm", form);
            model.addAttribute("categories", categoryService.findAll());
            model.addAttribute("statuts", ArticleStatut.values());
            model.addAttribute("mode", "edit");
            return "admin/articles/form";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/admin/articles";
        }
    }

    @PostMapping("/{id}")
    public String update(@PathVariable Integer id,
                         @Valid @ModelAttribute("articleForm") ArticleForm form,
                         @RequestParam(value = "images", required = false) MultipartFile[] images,
                         @RequestParam(value = "imageAlts", required = false) String imageAlts,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("articleId", id);
            model.addAttribute("categories", categoryService.findAll());
            model.addAttribute("statuts", ArticleStatut.values());
            model.addAttribute("mode", "edit");
            return "admin/articles/form";
        }

        try {
            articleService.update(id, form, images, imageAlts);
        } catch (IllegalArgumentException ex) {
            if (ex.getMessage() != null && ex.getMessage().contains("slug")) {
                bindingResult.rejectValue("slug", "slug.duplicate", ex.getMessage());
            } else {
                bindingResult.reject("article.error", ex.getMessage());
            }
            model.addAttribute("articleId", id);
            model.addAttribute("categories", categoryService.findAll());
            model.addAttribute("statuts", ArticleStatut.values());
            model.addAttribute("mode", "edit");
            return "admin/articles/form";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Article modifie avec succes");
        return "redirect:/admin/articles";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            articleService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Article supprime avec succes");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/articles";
    }
}
