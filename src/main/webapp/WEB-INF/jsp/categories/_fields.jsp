<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="mb-3">
  <label class="form-label" for="nom">Nom</label>
  <form:input path="nom" id="nom" cssClass="form-control" />
  <form:errors path="nom" cssClass="text-danger small" />
</div>

<div class="mb-3">
  <label class="form-label" for="slug">Slug</label>
  <form:input path="slug" id="slug" cssClass="form-control" />
  <div class="form-text">Exemple: diplomatie</div>
  <form:errors path="slug" cssClass="text-danger small" />
</div>

<div class="mb-3">
  <label class="form-label" for="description">Description</label>
  <form:textarea path="description" id="description" cssClass="form-control" rows="4" />
  <form:errors path="description" cssClass="text-danger small" />
</div>

<div class="d-flex gap-2">
  <button type="submit" class="btn btn-primary">Enregistrer</button>
  <a href="/categories" class="btn btn-outline-secondary">Annuler</a>
</div>
