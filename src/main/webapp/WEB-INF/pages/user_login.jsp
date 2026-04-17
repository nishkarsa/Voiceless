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
        
        <video autoplay loop muted playsinline preload="auto" class="video-background" id="bg-video">
    	<source src="${pageContext.request.contextPath}/videos/animal_video.mp4" type="video/mp4">
		</video>
        
        <div class="video-overlay"></div>

        <div class="auth-card">
            
            <div class="brand-header">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo">
            </div>
            <p class="subtitle">Enter your sanctuary to report sightings.</p>
            
            <% if("true".equals(request.getParameter("error"))) { %>
                <p class="text-danger" style="margin-top: -16px; margin-bottom: 20px;">Invalid email or password.</p>
            <% } else if("sys".equals(request.getParameter("error"))) { %>
                <p class="text-danger" style="margin-top: -16px; margin-bottom: 20px;">System error. Please try again later.</p>
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
            
            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Create New Account</a>

            <div class="portal-links">
                <a href="${pageContext.request.contextPath}/staff/login" style="color: #e5e7eb;">Staff Portal</a> 
                <span class="portal-divider" style="color: #9ca3af;">•</span> 
                <a href="${pageContext.request.contextPath}/admin/login" style="color: #e5e7eb;">Admin Terminal</a>
            </div>
            
        </div>
    </div>
    
</body>
</html>