<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper" style="background: #edeae3;">
        <div class="auth-card" style="border-top: 5px solid #d4a647;">
            <div class="brand-header">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo">
            </div>
            <h1 class="title">Field Staff Portal</h1>
            <p class="subtitle">Access dispatch tasks and incident management.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Unauthorized staff credentials.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/staff/login" method="POST">
                <div class="form-group">
                    <label>Staff Email</label>
                    <input type="email" name="staffEmail" class="form-control" placeholder="staff@voiceless.org" required>
                </div>
                <div class="form-group">
                    <label>Staff Password</label>
                    <input type="password" name="staffPassword" class="form-control" placeholder="Enter your password" required>
                </div>
                <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, #b8930e, #d4a647);">Authorize Dispatch</button>
            </form>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; Public User Login</a>
            </div>
        </div>
    </div>
</body>
</html>