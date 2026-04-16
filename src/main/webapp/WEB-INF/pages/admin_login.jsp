<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Admin Terminal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper-dark">
        <div class="auth-card-dark">
            <h2 class="title title-dark">Admin Terminal</h2>
            <p class="subtitle" style="color:#94a3b8;">Secured node access required.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Unauthorized node access.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                <div class="form-group">
                    <label class="dark-label">Admin ID</label>
                    <input type="text" name="adminId" class="form-control form-control-dark" placeholder="ID_0000_X" required>
                </div>
                <div class="form-group">
                    <label class="dark-label">Access Token</label>
                    <input type="password" name="token" class="form-control form-control-dark" placeholder="••••••••••••" required>
                </div>
                <button type="submit" class="btn btn-primary" style="background-color: #475569;">Authorize Access &rarr;</button>
            </form>

            <div class="portal-links portal-links-dark">
                <a href="${pageContext.request.contextPath}/login">&larr; Return to Public Portal</a>
            </div>
        </div>
    </div>
</body>
</html>