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
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/report/submit")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 15 * 1024 * 1024
)
public class ReportServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String species = request.getParameter("species");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String location = request.getParameter("location");

        // Parse latitude and longitude
        double latitude = 0.0;
        double longitude = 0.0;
        if (location != null && location.contains(",")) {
            String[] parts = location.split(",");
            try {
                latitude = Double.parseDouble(parts[0].trim());
                longitude = Double.parseDouble(parts[1].trim());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Handle report photo upload
        String photoPath = null;
        Part filePart = request.getPart("reportPhoto");
        if (filePart != null && filePart.getSize() > 0) {
            String uploadDir = getServletContext().getRealPath("/uploads/reports");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) uploadFolder.mkdirs();

            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = originalName.substring(originalName.lastIndexOf("."));
            String safeFileName = UUID.randomUUID().toString() + extension;

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, Paths.get(uploadDir, safeFileName), StandardCopyOption.REPLACE_EXISTING);
            }
            photoPath = "uploads/reports/" + safeFileName;
        }

        try (Connection conn = DBConfig.getConnection()) {
            String sql = "INSERT INTO reports (user_id, animal_type, category, location_desc, description, latitude, longitude, status, photo_path) VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, species);
            stmt.setString(3, category);
            stmt.setString(4, location);
            stmt.setString(5, description);
            stmt.setDouble(6, latitude);
            stmt.setDouble(7, longitude);
            stmt.setString(8, photoPath);
            stmt.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/user/dashboard?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/dashboard?error=sys");
        }
    }
}