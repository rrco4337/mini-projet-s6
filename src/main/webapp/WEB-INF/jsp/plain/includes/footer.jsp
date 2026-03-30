<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miniprojets6.plain.front.PlainFrontCategory" %>
<%
  List<PlainFrontCategory> footerNavCategories = (List<PlainFrontCategory>) request.getAttribute("navCategories");
%>
<footer class="mt-16 border-t border-stone bg-white">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <div>
        <h3 class="font-serif text-2xl font-bold tracking-tight">Iran War News</h3>
        <p class="mt-3 text-sm leading-relaxed text-gray-600">Informations et analyses sur le conflit en Iran, dans une mise en perspective editoriale sobre et exigeante.</p>
      </div>

      <div>
        <h4 class="text-xs uppercase tracking-[0.2em] font-semibold text-gray-500">Categories</h4>
        <ul class="mt-3 space-y-2 text-sm">
          <% if (footerNavCategories != null && !footerNavCategories.isEmpty()) {
               for (int i = 0; i < footerNavCategories.size() && i < 6; i++) {
                 PlainFrontCategory cat = footerNavCategories.get(i);
          %>
          <li><a href="/noframework/home?categorySlugs=<%= cat.getSlug() %>" class="text-gray-700 hover:text-ink transition-colors"><%= cat.getNom() %></a></li>
          <%   }
             } %>
        </ul>
      </div>

      <div>
        <h4 class="text-xs uppercase tracking-[0.2em] font-semibold text-gray-500">Navigation</h4>
        <ul class="mt-3 space-y-2 text-sm">
          <li><a href="/noframework/home" class="text-gray-700 hover:text-ink transition-colors">Accueil</a></li>
          <li><a href="/noframework/admin/dashboard" class="text-gray-700 hover:text-ink transition-colors">Administration</a></li>
        </ul>
      </div>
    </div>

    <div class="mt-8 pt-4 border-t border-stone text-xs text-gray-500 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
      <p>&copy; 2026 Iran War News</p>
      <p>Tous droits reserves</p>
    </div>
  </div>
</footer>

<button id="scrollTop" title="Retour en haut" class="fixed bottom-6 right-6 hidden items-center justify-center w-11 h-11 rounded-full border border-stone bg-white shadow-editorial text-gray-600 hover:text-ink hover:-translate-y-0.5 transition-all">
  ↑
</button>

<script>
  const scrollTopBtn = document.getElementById('scrollTop');

  window.addEventListener('scroll', function () {
    if (window.scrollY > 300) {
      scrollTopBtn.classList.remove('hidden');
      scrollTopBtn.classList.add('flex');
    } else {
      scrollTopBtn.classList.add('hidden');
      scrollTopBtn.classList.remove('flex');
    }
  });

  scrollTopBtn.addEventListener('click', function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
</script>
</body>
</html>
