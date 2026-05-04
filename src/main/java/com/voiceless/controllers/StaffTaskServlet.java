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

@WebServlet("/staff/update-task")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Ensure only logged-in STAFF can perform this action
        if (session == null || !"STAFF".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        String reportIdStr = request.getParameter("reportId");

        try (Connection conn = DBConfig.getConnection()) {
            // Update the report status to 'RESOLVED' in the database
            String sql = "UPDATE reports SET status = 'RESOLVED' WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(reportIdStr));
            stmt.executeUpdate();

            // Redirect back to the dashboard with a success flag
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?update=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?error=sys");
        }
    }
}