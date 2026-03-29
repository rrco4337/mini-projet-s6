<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="mb-4">
  <label class="form-label" for="nom">
    <i class="bi bi-tag me-2"></i>Nom de la catégorie *
  </label>
  <form:input path="nom" id="nom" cssClass="form-control"
             placeholder="Ex: International, Politique, Économie..."
             maxlength="255" />
  <form:errors path="nom" cssClass="text-danger validation-feedback" />
  <small class="text-muted">
    <i class="bi bi-info-circle me-1"></i>Nom affiché publiquement sur le site
  </small>
</div>

<div class="mb-4">
  <label class="form-label" for="slug">
    <i class="bi bi-link-45deg me-2"></i>Slug (URL) *
  </label>
  <div class="input-group">
    <span class="input-group-text bg-light">/category/</span>
    <form:input path="slug" id="slug" cssClass="form-control"
               placeholder="international, politique, economie..."
               maxlength="255" />
  </div>
  <form:errors path="slug" cssClass="text-danger validation-feedback" />
  <div class="slug-preview" id="slugPreview" style="display: none;">
    <small class="text-muted">
      <i class="bi bi-globe me-1"></i>URL complète :
      <strong id="fullUrl">http://localhost:8080/category/</strong>
    </small>
  </div>
  <small class="text-muted">
    <i class="bi bi-lightbulb me-1"></i>Utilisé dans l'URL. Lettres minuscules, chiffres et tirets uniquement
  </small>
</div>

<div class="mb-4">
  <label class="form-label" for="description">
    <i class="bi bi-card-text me-2"></i>Description
  </label>
  <form:textarea path="description" id="description" cssClass="form-control"
                rows="4" maxlength="500"
                placeholder="Décrivez brièvement cette catégorie et les types d'articles qu'elle contient..." />
  <form:errors path="description" cssClass="text-danger validation-feedback" />
  <div class="d-flex justify-content-between mt-1">
    <small class="text-muted">
      <i class="bi bi-info-circle me-1"></i>Aide vos visiteurs à comprendre le contenu de cette catégorie
    </small>
    <small class="text-muted" id="descriptionCounter">0/500</small>
  </div>
</div>

<!-- Action Buttons -->
<div class="d-flex gap-3 mt-5">
  <button type="submit" class="btn btn-primary btn-lg">
    <i class="bi bi-check-lg me-2"></i>
    ${mode == 'edit' ? 'Mettre à jour' : 'Créer la catégorie'}
  </button>
  <a href="/categories" class="btn btn-outline-secondary btn-lg">
    <i class="bi bi-arrow-left me-2"></i>Retour à la liste
  </a>
</div>

<script>
// Character counter for description
const descriptionInput = document.getElementById('description');
const descriptionCounter = document.getElementById('descriptionCounter');

function updateDescriptionCounter() {
  const length = descriptionInput.value.length;
  descriptionCounter.textContent = `${length}/500`;

  if (length > 400) {
    descriptionCounter.classList.add('text-warning');
  } else {
    descriptionCounter.classList.remove('text-warning');
  }

  if (length > 480) {
    descriptionCounter.classList.remove('text-warning');
    descriptionCounter.classList.add('text-danger');
  } else {
    descriptionCounter.classList.remove('text-danger');
  }
}

descriptionInput.addEventListener('input', updateDescriptionCounter);
updateDescriptionCounter(); // Initialize
</script>