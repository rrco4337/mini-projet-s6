<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div>
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="nom">Nom</label>
  <form:input path="nom" id="nom" cssClass="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
  <form:errors path="nom" cssClass="mt-1 block text-xs font-medium text-rose-700" />
</div>

<div>
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="slug">Slug</label>
  <form:input path="slug" id="slug" cssClass="h-11 w-full rounded-xl border border-slate-200 bg-slate-50 px-4 text-sm outline-none transition focus:border-blue-300 focus:bg-white" />
  <p class="mt-1 text-xs text-slate-500">Exemple: diplomatie</p>
  <form:errors path="slug" cssClass="mt-1 block text-xs font-medium text-rose-700" />
</div>

<div>
  <label class="mb-2 block text-sm font-semibold text-slate-700" for="description">Description</label>
  <form:textarea path="description" id="description" cssClass="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white" rows="4" />
  <form:errors path="description" cssClass="mt-1 block text-xs font-medium text-rose-700" />
</div>

<div class="flex flex-wrap gap-3 pt-2">
  <button type="submit" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Enregistrer</button>
  <a href="/categories" class="rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Annuler</a>
</div>
