package com.miniprojets6.plain.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public final class PlainAuthSupport {
    public static final String SESSION_USER_KEY = "AUTH_USER";

    private PlainAuthSupport() {
    }

    public static PlainAuthUser getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute(SESSION_USER_KEY);
        return user instanceof PlainAuthUser ? (PlainAuthUser) user : null;
    }

    public static boolean requireAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (getCurrentUser(request) != null) {
            return true;
        }

        String requestedUri = request.getRequestURI();
        String query = request.getQueryString();
        String fullPath = query == null || query.isBlank() ? requestedUri : requestedUri + "?" + query;
        String next = URLEncoder.encode(fullPath, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/noframework/login?next=" + next);
        return false;
    }

    public static String normalizeNext(String next) {
        if (next == null || next.isBlank()) {
            return "/noframework/admin/dashboard";
        }
        if (!next.startsWith("/")) {
            return "/noframework/admin/dashboard";
        }
        if (next.contains("://")) {
            return "/noframework/admin/dashboard";
        }
        return next;
    }
}
