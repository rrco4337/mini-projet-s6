<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="bg-dark text-white py-4 mt-5">
  <div class="container">
    <div class="row">
      <div class="col-md-4 mb-3 mb-md-0">
        <h5><i class="bi bi-newspaper me-2"></i>Iran War News</h5>
        <p class="text-muted small">Informations et analyses sur le conflit en Iran.</p>
      </div>
      <div class="col-md-4 mb-3 mb-md-0">
        <h6>Categories</h6>
        <ul class="list-unstyled small">
          <c:forEach items="${navCategories}" var="cat" end="4">
            <li><a href="/categorie/${cat.slug}" class="text-muted text-decoration-none"><c:out value="${cat.nom}" /></a></li>
          </c:forEach>
        </ul>
      </div>
      <div class="col-md-4">
        <h6>Navigation</h6>
        <ul class="list-unstyled small">
          <li><a href="/" class="text-muted text-decoration-none">Accueil</a></li>
          <li><a href="/admin" class="text-muted text-decoration-none">Administration</a></li>
        </ul>
      </div>
    </div>
    <hr class="my-3" />
    <p class="text-center text-muted mb-0 small">&copy; 2026 Iran War News. Tous droits reserves.</p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<button class="scroll-top" id="scrollTop" title="Retour en haut">
  <i class="bi bi-arrow-up"></i>
</button>

<script>
  // Scroll to top button
  const scrollTopBtn = document.getElementById('scrollTop');

  window.addEventListener('scroll', () => {
    if (window.scrollY > 300) {
      scrollTopBtn.classList.add('visible');
    } else {
      scrollTopBtn.classList.remove('visible');
    }
  });

  scrollTopBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  // Animate elements on scroll
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-slideUp');
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);

  document.querySelectorAll('.card, article').forEach(el => {
    observer.observe(el);
  });
</script>
</body>
</html>
