package com.voiceless.controllers;

import com.voiceless.config.DBConfig;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/report/submit")
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
        String description = request.getParameter("description");
        String location = request.getParameter("location"); 

        try (Connection conn = DBConfig.getConnection()) {
            String sql = "INSERT INTO reports (user_id, animal_type, location_desc, description, status) VALUES (?, ?, ?, ?, 'PENDING')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, species);
            stmt.setString(3, location);
            stmt.setString(4, description);
            stmt.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/user/dashboard?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/dashboard?error=sys");
        }
    }
}