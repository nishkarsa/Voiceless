<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Voiceless - Login In</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <div class="auth-wrapper">

            <video autoplay loop muted playsinline preload="auto" class="video-background" id="bg-video">
                <source src="${pageContext.request.contextPath}/videos/Green2.mp4" type="video/mp4">
            </video>

            <div class="video-overlay"></div>

            <div class="auth-card">

                <div class="brand-header">
                    <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo"
                        class="brand-logo">
                </div>
                <h1 class="title">Welcome Back</h1>
                <p class="subtitle">Sign in to report sightings and be the voice for voiceless.</p>

                <% if("true".equals(request.getParameter("error"))) { %>
                    <p class="text-danger">Invalid email or password.</p>
                    <% } else if("sys".equals(request.getParameter("error"))) { %>
                        <p class="text-danger">System error. Please try again later.</p>
                        <% } %>
                            <% if("success".equals(request.getParameter("register"))) { %>
                                <div class="alert alert-success" style="margin-bottom: 16px;"><i
                                        data-lucide="check-circle"></i> Account created! Please log in.</div>
                                <% } %>

                                    <form action="${pageContext.request.contextPath}/login" method="POST">
                                        <div class="form-group">
                                            <label>Email</label>
                                            <input type="email" name="email" class="form-control"
                                                placeholder="name@example.com" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Password</label>
                                            <input type="password" name="password" class="form-control"
                                                placeholder="Enter your password" required>
                                        </div>

                                        <button type="submit" class="btn btn-primary">Sign In</button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/register"
                                        class="btn btn-secondary">Create New Account</a>

                                    <div class="portal-links">
                                        <a href="${pageContext.request.contextPath}/staff/login">Staff Portal</a>
                                    </div>

                                    <img src="${pageContext.request.contextPath}/images/hero_tiger.png" alt="Tiger"
                                        class="auth-animal-photo">

                                    <a href="${pageContext.request.contextPath}/" class="home-link">&larr; Back to
                                        Home</a>

            </div>
        </div>

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>lucide.createIcons();</script>
    </body>

    </html>

    </html>