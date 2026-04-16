<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper" style="background-color: #e2e8f0;">
        <div class="auth-card" style="border-top: 4px solid #ca8a04;">
            <h1 class="title">Voiceless Field Staff</h1>
            <p class="subtitle">Access removal tasks and dispatch info.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Unauthorized Staff credentials.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/staff/login" method="POST">
                <div class="form-group">
                    <label>Staff Email</label>
                    <input type="email" name="staffEmail" class="form-control" placeholder="staff@voiceless.org" required>
                </div>
                <div class="form-group">
                    <label>Staff Password</label>
                    <input type="password" name="staffPassword" class="form-control" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary" style="background-color: #ca8a04;">Authorize Dispatch &rarr;</button>
            </form>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; Public User Login</a>
            </div>
        </div>
    </div>
</body>
</html>