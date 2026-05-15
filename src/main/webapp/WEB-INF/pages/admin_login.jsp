<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Admin Terminal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
    
    <video autoplay loop muted playsinline preload="auto" class="video-background" id="bg-video">
    	    <source src="${pageContext.request.contextPath}/videos/wheat.mp4" type="video/mp4">
	    </video>
        
        <div class="video-overlay"></div>
    
        <div class="auth-card">
            <div class="brand-header">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo">
            </div>
            <h1 class="title">Admin Terminal</h1>
            <p class="subtitle">Secured access required.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger">Unauthorized access.</p>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                <div class="form-group">
                    <label>Admin ID</label>
                    <input type="text" name="adminId" class="form-control" placeholder="ADMIN" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="token" class="form-control" placeholder="Enter password" required>
                </div>
                <button type="submit" class="btn btn-primary">Authorize Access</button>
            </form>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; Return to Public Portal</a>
            </div>
            
            <img src="${pageContext.request.contextPath}/images/rhino_wildlife.png" alt="Rhino" class="auth-animal-photo">
        </div>
    </div>
</body>
</html>