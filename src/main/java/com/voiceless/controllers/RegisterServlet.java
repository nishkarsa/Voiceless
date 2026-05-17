package com.voiceless.controllers;

import com.voiceless.config.DBConfig;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/register")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Handle profile image upload
        String profileImagePath = null;
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String uploadDir = getServletContext().getRealPath("/uploads/profiles");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists())
                uploadFolder.mkdirs();

            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = originalName.substring(originalName.lastIndexOf("."));
            String safeFileName = UUID.randomUUID().toString() + extension;

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, Paths.get(uploadDir, safeFileName), StandardCopyOption.REPLACE_EXISTING);
            }
            profileImagePath = "uploads/profiles/" + safeFileName;
        }

        try (Connection conn = DBConfig.getConnection()) {

            // 1. Check if the email already exists in the database
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect(request.getContextPath() + "/register?error=duplicate");
                return;
            }

            // 2. Insert user with profile image
            String insertSql = "INSERT INTO users (name, email, password, role, profile_image) VALUES (?, ?, ?, 'USER', ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);
            insertStmt.setString(4, profileImagePath);
            insertStmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/login?register=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/register?error=sys");
        }
    }
}