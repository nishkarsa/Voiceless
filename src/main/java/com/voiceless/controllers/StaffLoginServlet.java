package com.voiceless.controllers;

import com.voiceless.config.DBConfig;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/login")
public class StaffLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/staff_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String staffEmail = request.getParameter("staffEmail");
        String staffPassword = request.getParameter("staffPassword");
        HttpSession session = request.getSession();

        // Authenticate against the database - look for users with STAFF role
        try (Connection conn = DBConfig.getConnection()) {
            String sql = "SELECT id, name FROM users WHERE email = ? AND password = ? AND role = 'STAFF'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, staffEmail);
            stmt.setString(2, staffPassword);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userRole", "STAFF");
                session.setAttribute("userName", rs.getString("name"));
                response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/login?error=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/login?error=sys");
        }
    }
}