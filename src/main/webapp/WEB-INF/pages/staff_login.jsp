<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
    
    <video autoplay loop muted playsinline preload="auto" class="video-background" id="bg-video">
    	    <source src="${pageContext.request.contextPath}/videos/blue.mp4" type="video/mp4">
	    </video>
        
        <div class="video-overlay"></div>
    
        <div class="auth-card">
            <div class="brand-header">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo">
            </div>
            <h1 class="title">Staff Portal</h1>
            <p class="subtitle">Access tasks and incident management.</p>
            
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
                <button type="submit" class="btn btn-primary">Login</button>
            </form>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/login">&larr; User Login</a>
            </div>
            
            <img src="${pageContext.request.contextPath}/images/rescue_team.png" alt="Rescue Team" class="auth-animal-photo">
            
            <a href="${pageContext.request.contextPath}/" class="home-link">&larr; Back to Home</a>
        </div>
    </div>
</body>
</html>