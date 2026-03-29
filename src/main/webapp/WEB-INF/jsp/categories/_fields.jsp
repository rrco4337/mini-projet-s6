<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="mb-4">
  <label class="form-label fw-bold" for="nom">
    <i class="bi bi-tag me-2 text-primary"></i>Nom de la catégorie *
  </label>
  <form:input path="nom" id="nom" cssClass="form-control form-control-lg"
             placeholder="Ex: International, Politique, Économie..."
             style="border: 2px solid #e9ecef; border-radius: 10px;" />
  <form:errors path="nom" cssClass="text-danger small mt-1 d-block" />
  <small class="text-muted">
    <i class="bi bi-info-circle me-1"></i>Nom affiché publiquement sur le site
  </small>
</div>

<div class="mb-4">
  <label class="form-label fw-bold" for="slug">
    <i class="bi bi-link-45deg me-2 text-primary"></i>Slug (URL) *
  </label>
  <div class="input-group">
    <span class="input-group-text bg-light fw-bold">/category/</span>
    <form:input path="slug" id="slug" cssClass="form-control"
               placeholder="international, politique, economie..."
               style="border: 2px solid #e9ecef;" />
  </div>
  <form:errors path="slug" cssClass="text-danger small mt-1 d-block" />
  <small class="text-muted">
    <i class="bi bi-lightbulb me-1"></i>Lettres minuscules, chiffres et tirets uniquement
  </small>
</div>

<div class="mb-4">
  <label class="form-label fw-bold" for="description">
    <i class="bi bi-card-text me-2 text-primary"></i>Description
  </label>
  <form:textarea path="description" id="description" cssClass="form-control"
                rows="4" maxlength="500"
                placeholder="Décrivez brièvement cette catégorie..."
                style="border: 2px solid #e9ecef; border-radius: 10px;" />
  <form:errors path="description" cssClass="text-danger small mt-1 d-block" />
  <small class="text-muted">
    <i class="bi bi-info-circle me-1"></i>Aide vos visiteurs à comprendre le contenu
  </small>
</div>

<!-- Action Buttons -->
<div class="d-flex gap-3 mt-4">
  <button type="submit" class="btn btn-primary btn-lg px-4 fw-bold"
          style="border-radius: 10px;">
    <i class="bi bi-check-lg me-2"></i>Enregistrer
  </button>
  <a href="/categories" class="btn btn-outline-secondary btn-lg px-4 fw-bold"
     style="border-radius: 10px; border: 2px solid #e9ecef;">
    <i class="bi bi-arrow-left me-2"></i>Annuler
  </a>
</div>
