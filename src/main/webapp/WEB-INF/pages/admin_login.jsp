<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Admin Terminal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-auth-wrapper { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: #1a2e1a; }
        .admin-auth-card { background: #243524; width: 100%; max-width: 420px; padding: 44px 38px; border-radius: 24px; box-shadow: 0 12px 40px rgba(0,0,0,0.25); border-top: 5px solid #a63d40; }
        .admin-auth-card .title { color: #e8edd8; }
        .admin-auth-card .subtitle { color: #a0b48e; }
        .admin-auth-card label { color: #a0b48e; }
        .admin-auth-card .form-control { background: #1a2e1a; border-color: #3d5a2a; color: #e8edd8; }
        .admin-auth-card .form-control:focus { border-color: #7ab648; box-shadow: 0 0 0 3px rgba(122,182,72,0.15); }
        .admin-auth-card .form-control::placeholder { color: #6b7f5a; }
        .admin-auth-card .portal-links a { color: #a0b48e; }
        .admin-auth-card .portal-links a:hover { color: #e8edd8; }
    </style>
</head>
<body>
    <div class="admin-auth-wrapper">
        <div class="admin-auth-card">
            <div class="brand-header">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo" style="border-color: rgba(255,255,255,0.15);">
            </div>
            <h1 class="title">Admin Terminal</h1>
            <p class="subtitle">Secured access required.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Unauthorized access.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                <div class="form-group">
                    <label>Admin ID</label>
                    <input type="text" name="adminId" class="form-control" placeholder="ID_0000_X" required>
                </div>
                <div class="form-group">
                    <label>Access Token</label>
                    <input type="password" name="token" class="form-control" placeholder="Enter token" required>
                </div>
                <button type="submit" class="btn" style="background: linear-gradient(135deg, #a63d40, #c0392b); color: #fff; margin-top: 10px;">Authorize Access</button>
            </form>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; Return to Public Portal</a>
            </div>
        </div>
    </div>
</body>
</html>