<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Connexion - Iran War News</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
  <link rel="stylesheet" href="/css/style.css" />
  <style>
    body {
      min-height: 100vh;
      display: flex;
      align-items: center;
      background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    }
    .login-card {
      max-width: 400px;
      margin: 0 auto;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="login-card">
    <div class="text-center mb-4">
      <h1 class="h3 text-white">
        <i class="bi bi-newspaper me-2"></i>Iran War News
      </h1>
      <p class="text-white-50">Connexion au backoffice</p>
    </div>

    <div class="card shadow">
      <div class="card-body p-4">
        <c:if test="${not empty errorMessage}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-circle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <c:if test="${not empty successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <form action="/login" method="post">
          <div class="mb-3">
            <label for="username" class="form-label">Nom d'utilisateur</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-person"></i></span>
              <input type="text" class="form-control" id="username" name="username"
                     placeholder="admin" required autofocus />
            </div>
          </div>

          <div class="mb-4">
            <label for="password" class="form-label">Mot de passe</label>
            <div class="input-group">
              <span class="input-group-text"><i class="bi bi-lock"></i></span>
              <input type="password" class="form-control" id="password" name="password"
                     placeholder="••••••••" required />
            </div>
          </div>

          <button type="submit" class="btn btn-primary w-100">
            <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
          </button>
        </form>
      </div>
    </div>

    <div class="text-center mt-4">
      <a href="/" class="text-white-50 text-decoration-none">
        <i class="bi bi-arrow-left me-1"></i>Retour au site
      </a>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
