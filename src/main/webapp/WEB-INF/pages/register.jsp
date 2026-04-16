<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card">
            <h1 class="title">Join Voiceless</h1>
            <p class="subtitle">Become a digital guardian for wildlife.</p>
            
            <% 
                String error = request.getParameter("error");
                if ("duplicate".equals(error)) { 
            %>
                <p class="text-danger">Registration failed: That email is already registered. Please log in.</p>
            <% 
                } else if ("sys".equals(error)) { 
            %>
                <p class="text-danger">A system error occurred. Please try again later.</p>
            <% 
                } 
            %>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary">Register</button>
            </form>
            
            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; Back to User Login</a>
            </div>
        </div>
    </div>
</body>
</html>