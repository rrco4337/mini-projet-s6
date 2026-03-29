<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestion des articles - Iran War News</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <link rel="stylesheet" href="/css/style.css" />
  <style>
    .page-header {
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
      color: white;
      border-radius: 15px;
      margin-bottom: 2rem;
    }

    .stats-mini {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 12px;
      color: white;
      padding: 1.5rem;
      text-align: center;
      margin-bottom: 1rem;
      transition: transform 0.3s ease;
    }

    .stats-mini:hover {
      transform: translateY(-3px);
    }

    .article-card {
      border: none;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      transition: all 0.3s ease;
      margin-bottom: 1.5rem;
      overflow: hidden;
    }

    .article-card:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }

    .status-badge-publie { background: linear-gradient(45deg, #28a745, #20c997); }
    .status-badge-brouillon { background: linear-gradient(45deg, #ffc107, #fd7e14); }
    .status-badge-archive { background: linear-gradient(45deg, #6c757d, #495057); }

    .action-btn {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: none;
      transition: all 0.3s ease;
      margin: 0 2px;
    }

    .action-btn:hover {
      transform: scale(1.1);
    }

    .btn-view { background: linear-gradient(45deg, #17a2b8, #20c997); color: white; }
    .btn-edit { background: linear-gradient(45deg, #6f42c1, #e83e8c); color: white; }
    .btn-delete { background: linear-gradient(45deg, #dc3545, #fd7e14); color: white; }

    .search-box {
      background: white;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      border: none;
    }

    .filter-card {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 15px;
      border: none;
    }

    .article-meta {
      font-size: 0.85rem;
      color: #6c757d;
    }

    .views-counter {
      background: linear-gradient(45deg, #667eea, #764ba2);
      color: white;
      border-radius: 20px;
      padding: 0.25rem 0.75rem;
      font-size: 0.8rem;
    }

    @keyframes slideInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .animate-item {
      animation: slideInUp 0.6s ease-out forwards;
    }
  </style>
</head>
<body class="bg-light">

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin">
      <i class="bi bi-shield-check me-2"></i>BackOffice
    </a>
    <div class="navbar-nav ms-auto">
      <a class="nav-link" href="/" target="_blank">
        <i class="bi bi-box-arrow-up-right me-1"></i>Voir le site
      </a>
      <a class="nav-link" href="/logout">
        <i class="bi bi-box-arrow-right me-1"></i>Déconnexion
      </a>
    </div>
  </div>
</nav>

<div class="container py-4">
  <!-- Header -->
  <div class="page-header p-4">
    <div class="d-flex justify-content-between align-items-center">
      <div>
        <h1 class="h2 mb-2">
          <i class="bi bi-newspaper me-3"></i>Gestion des Articles
        </h1>
        <p class="mb-0 opacity-75">Créez, modifiez et gérez tous vos contenus éditoriaux</p>
      </div>
      <a class="btn btn-light btn-lg" href="/admin/articles/new">
        <i class="bi bi-plus-lg me-2"></i>Nouvel Article
      </a>
    </div>
  </div>

  <!-- Messages -->
  <c:if test="${not empty successMessage}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
      <i class="bi bi-check-circle me-2"></i>${successMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
      <i class="bi bi-exclamation-circle me-2"></i>${errorMessage}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="row">
    <!-- Sidebar with stats and filters -->
    <div class="col-lg-3 mb-4">
      <!-- Quick stats -->
      <div class="stats-mini">
        <div class="fs-3 fw-bold mb-1">${not empty articles ? articles.size() : 0}</div>
        <div class="small opacity-75">Articles Total</div>
      </div>

      <!-- Filters -->
      <div class="card filter-card">
        <div class="card-header bg-transparent border-0">
          <h6 class="card-title mb-0">
            <i class="bi bi-funnel me-2"></i>Filtres
          </h6>
        </div>
        <div class="card-body">
          <div class="mb-3">
            <input type="text" class="form-control search-box" id="searchInput"
                   placeholder="Rechercher un article..." />
          </div>

          <div class="mb-3">
            <label class="form-label small fw-bold">Statut</label>
            <select class="form-select" id="statusFilter">
              <option value="">Tous les statuts</option>
              <option value="publie">Publiés</option>
              <option value="brouillon">Brouillons</option>
              <option value="archive">Archivés</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label small fw-bold">Catégorie</label>
            <select class="form-select" id="categoryFilter">
              <option value="">Toutes les catégories</option>
              <!-- Categories dynamically populated -->
            </select>
          </div>

          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="featuredFilter">
            <label class="form-check-label small" for="featuredFilter">
              <i class="bi bi-star-fill text-warning me-1"></i>Seulement à la une
            </label>
          </div>
        </div>
      </div>

      <div class="mt-3">
        <a href="/admin" class="btn btn-outline-secondary w-100">
          <i class="bi bi-arrow-left me-1"></i>Retour au dashboard
        </a>
      </div>
    </div>

    <!-- Main content -->
    <div class="col-lg-9">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
          <h5 class="mb-1">Tous les Articles</h5>
          <p class="text-muted small mb-0" id="resultsCount">
            <span class="results-number">${not empty articles ? articles.size() : 0}</span> article(s) trouvé(s)
          </p>
        </div>
        <div class="btn-group" role="group">
          <input type="radio" class="btn-check" name="viewMode" id="cardView" autocomplete="off" checked>
          <label class="btn btn-outline-secondary btn-sm" for="cardView">
            <i class="bi bi-grid"></i> Cartes
          </label>
          <input type="radio" class="btn-check" name="viewMode" id="tableView" autocomplete="off">
          <label class="btn btn-outline-secondary btn-sm" for="tableView">
            <i class="bi bi-list"></i> Tableau
          </label>
        </div>
      </div>

      <!-- Articles Grid -->
      <div id="articlesGrid">
        <c:forEach items="${articles}" var="article" varStatus="status">
          <div class="article-card card animate-item"
               style="animation-delay: ${status.index * 0.1}s"
               data-title="${article.titre}"
               data-status="${article.statut}"
               data-category="${article.categorie != null ? article.categorie.nom : ''}"
               data-featured="${article.aLaUne}">
            <div class="card-body">
              <div class="row align-items-start">
                <div class="col-md-8">
                  <div class="d-flex align-items-start gap-3">
                    <div class="flex-shrink-0">
                      <div class="bg-primary bg-gradient rounded-circle d-flex align-items-center justify-content-center"
                           style="width: 50px; height: 50px;">
                        <i class="bi bi-newspaper text-white"></i>
                      </div>
                    </div>
                    <div class="flex-grow-1">
                      <h6 class="card-title mb-1">
                        <c:out value="${article.titre}" />
                        <c:if test="${article.aLaUne}">
                          <i class="bi bi-star-fill text-warning ms-2"></i>
                        </c:if>
                      </h6>
                      <p class="article-meta mb-2">
                        <i class="bi bi-link-45deg me-1"></i>
                        <small class="text-muted">/article/${article.slug}</small>
                      </p>
                      <div class="d-flex align-items-center gap-3 mb-2">
                        <c:if test="${article.categorie != null}">
                          <span class="badge bg-secondary">
                            <i class="bi bi-folder me-1"></i>
                            <c:out value="${article.categorie.nom}" />
                          </span>
                        </c:if>
                        <span class="views-counter">
                          <i class="bi bi-eye me-1"></i>${article.vues} vues
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-4 text-end">
                  <div class="mb-3">
                    <span class="badge status-badge-${article.statut} p-2">
                      <c:choose>
                        <c:when test="${article.statut == 'publie'}">
                          <i class="bi bi-check-circle me-1"></i>Publié
                        </c:when>
                        <c:when test="${article.statut == 'brouillon'}">
                          <i class="bi bi-pencil me-1"></i>Brouillon
                        </c:when>
                        <c:otherwise>
                          <i class="bi bi-archive me-1"></i>Archivé
                        </c:otherwise>
                      </c:choose>
                    </span>
                  </div>
                  <div class="d-flex justify-content-end">
                    <a class="action-btn btn-view" href="/article/${article.slug}" target="_blank"
                       title="Voir l'article" data-bs-toggle="tooltip">
                      <i class="bi bi-eye"></i>
                    </a>
                    <a class="action-btn btn-edit" href="/admin/articles/${article.id}/edit"
                       title="Modifier" data-bs-toggle="tooltip">
                      <i class="bi bi-pencil"></i>
                    </a>
                    <form action="/admin/articles/${article.id}/delete" method="post" class="d-inline">
                      <button type="submit" class="action-btn btn-delete"
                              title="Supprimer" data-bs-toggle="tooltip"
                              onclick="return confirm('Supprimer cet article ?');">
                        <i class="bi bi-trash"></i>
                      </button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>

        <c:if test="${empty articles}">
          <div class="text-center py-5">
            <div class="display-1 text-muted mb-4">
              <i class="bi bi-inbox"></i>
            </div>
            <h5 class="text-muted mb-3">Aucun article trouvé</h5>
            <p class="text-muted mb-4">Commencez par créer votre premier article !</p>
            <a href="/admin/articles/new" class="btn btn-primary btn-lg">
              <i class="bi bi-plus-lg me-2"></i>Créer un Article
            </a>
          </div>
        </c:if>
      </div>

      <!-- Table view (hidden by default) -->
      <div id="articlesTable" style="display: none;">
        <div class="card shadow-sm">
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover mb-0">
                <thead class="table-light">
                  <tr>
                    <th>Article</th>
                    <th>Catégorie</th>
                    <th>Statut</th>
                    <th>Vues</th>
                    <th class="text-end">Actions</th>
                  </tr>
                </thead>
                <tbody id="tableBody">
                  <!-- Table content populated by JavaScript -->
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Initialize tooltips
const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
});

// Search functionality
const searchInput = document.getElementById('searchInput');
const statusFilter = document.getElementById('statusFilter');
const categoryFilter = document.getElementById('categoryFilter');
const featuredFilter = document.getElementById('featuredFilter');
const resultsNumber = document.querySelector('.results-number');

function filterArticles() {
  const searchTerm = searchInput.value.toLowerCase();
  const selectedStatus = statusFilter.value;
  const selectedCategory = categoryFilter.value;
  const showFeaturedOnly = featuredFilter.checked;

  const articles = document.querySelectorAll('.article-card');
  let visibleCount = 0;

  articles.forEach(article => {
    const title = article.dataset.title.toLowerCase();
    const status = article.dataset.status;
    const category = article.dataset.category.toLowerCase();
    const featured = article.dataset.featured === 'true';

    const matchesSearch = title.includes(searchTerm);
    const matchesStatus = !selectedStatus || status === selectedStatus;
    const matchesCategory = !selectedCategory || category.includes(selectedCategory.toLowerCase());
    const matchesFeatured = !showFeaturedOnly || featured;

    if (matchesSearch && matchesStatus && matchesCategory && matchesFeatured) {
      article.style.display = 'block';
      visibleCount++;
    } else {
      article.style.display = 'none';
    }
  });

  resultsNumber.textContent = visibleCount;
}

searchInput.addEventListener('input', filterArticles);
statusFilter.addEventListener('change', filterArticles);
categoryFilter.addEventListener('change', filterArticles);
featuredFilter.addEventListener('change', filterArticles);

// View mode toggle
const cardView = document.getElementById('cardView');
const tableView = document.getElementById('tableView');
const articlesGrid = document.getElementById('articlesGrid');
const articlesTable = document.getElementById('articlesTable');

function populateTable() {
  const tableBody = document.getElementById('tableBody');
  const articles = document.querySelectorAll('.article-card');

  tableBody.innerHTML = '';

  articles.forEach(article => {
    if (article.style.display !== 'none') {
      const title = article.dataset.title;
      const status = article.dataset.status;
      const category = article.dataset.category || '-';

      // Extract data from card
      const viewsText = article.querySelector('.views-counter').textContent.trim();
      const viewHref = article.querySelector('.btn-view').href;
      const editHref = article.querySelector('.btn-edit').href;
      const deleteForm = article.querySelector('form').outerHTML;

      const row = `
        <tr>
          <td>
            <strong>${title}</strong>
            ${article.dataset.featured === 'true' ? '<i class="bi bi-star-fill text-warning ms-2"></i>' : ''}
          </td>
          <td>${category}</td>
          <td>
            <span class="badge status-badge-${status}">
              ${status === 'publie' ? 'Publié' : status === 'brouillon' ? 'Brouillon' : 'Archivé'}
            </span>
          </td>
          <td>${viewsText}</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-primary" href="${viewHref}" target="_blank">
              <i class="bi bi-eye"></i>
            </a>
            <a class="btn btn-sm btn-outline-secondary" href="${editHref}">
              <i class="bi bi-pencil"></i>
            </a>
            ${deleteForm.replace('action-btn btn-delete', 'btn btn-sm btn-outline-danger')}
          </td>
        </tr>
      `;
      tableBody.innerHTML += row;
    }
  });
}

cardView.addEventListener('change', function() {
  if (this.checked) {
    articlesGrid.style.display = 'block';
    articlesTable.style.display = 'none';
  }
});

tableView.addEventListener('change', function() {
  if (this.checked) {
    articlesGrid.style.display = 'none';
    articlesTable.style.display = 'block';
    populateTable();
  }
});

// Smooth animations
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.animate-item').forEach((el) => {
  observer.observe(el);
});
</script>
</body>
</html>
