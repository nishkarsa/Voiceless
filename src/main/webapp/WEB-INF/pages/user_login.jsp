<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - User Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <h1 class="title">🌲 Voiceless</h1>
            <p class="subtitle">Enter your sanctuary to report sightings.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Invalid email or password.</p>
            <% } else if("sys".equals(request.getParameter("error"))) { %>
                <p class="text-danger">System error. Please try again later.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary">Sign In</button>
            </form>
            
            <div style="margin-top: 1rem;">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Create New Account</a>
            </div>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/staff/login">Staff Portal</a> • 
                <a href="${pageContext.request.contextPath}/admin/login">Admin Terminal</a>
            </div>
        </div>
    </div>
</body>
</html>