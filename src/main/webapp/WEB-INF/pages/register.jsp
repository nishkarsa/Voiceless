<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Voiceless - Register</title>
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
                    <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo"
                        class="brand-logo">
                </div>
                <h1 class="title">Join Voiceless</h1>
                <p class="subtitle">Become a digital guardian for wildlife.</p>

                <% String error=request.getParameter("error"); if ("duplicate".equals(error)) { %>
                    <p class="text-danger">That email is already registered. Please log in.</p>
                    <% } else if ("sys".equals(error)) { %>
                        <p class="text-danger">A system error occurred. Please try again later.</p>
                        <% } %>

                            <form action="${pageContext.request.contextPath}/register" method="POST"
                                enctype="multipart/form-data">

                                <div class="form-group" style="text-align: center;">
                                    <label style="text-align: center;">Profile Photo</label>
                                    <div class="profile-upload-circle" id="profileUploadCircle">
                                        <i data-lucide="camera" id="profileCameraIcon"></i>
                                        <input type="file" name="profileImage" accept="image/*"
                                            onchange="previewProfile(this)">
                                        <img id="profilePreview" alt="Preview" style="display:none;">
                                    </div>
                                    <p style="font-size: 0.78rem; color: var(--color-text-muted);">Click to upload your
                                        photo</p>
                                </div>

                                <div class="form-group">
                                    <label>Full Name</label>
                                    <input type="text" name="name" class="form-control" placeholder="Your full name"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label>Email</label>
                                    <input type="email" name="email" class="form-control" placeholder="name@example.com"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label>Password</label>
                                    <input type="password" name="password" class="form-control"
                                        placeholder="Create a strong password" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Create Account</button>
                            </form>

                            <div class="portal-links">
                                <a href="${pageContext.request.contextPath}/login">&larr; Back to Login</a>
                            </div>

                            <img src="${pageContext.request.contextPath}/images/elephant_herd.png" alt="Elephants"
                                class="auth-animal-photo">

                            <a href="${pageContext.request.contextPath}/" class="home-link">&larr; Back to Home</a>
            </div>
        </div>

        <script src="https://unpkg.com/lucide@latest"></script>
        <script>
            lucide.createIcons();
            function previewProfile(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var preview = document.getElementById('profilePreview');
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                        document.getElementById('profileCameraIcon').style.display = 'none';
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </body>

    </html>

    </html>