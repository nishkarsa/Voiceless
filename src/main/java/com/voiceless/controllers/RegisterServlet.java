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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConfig.getConnection()) {
            
            // 1. Check if the email already exists in the database
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // The email was found. Redirect back with a specific 'duplicate' error flag.
                response.sendRedirect(request.getContextPath() + "/register?error=duplicate");
                return; // Stop execution here so it doesn't try to insert
            }

            // 2. If we reach here, the email is unique. Proceed with insertion.
            String insertSql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'USER')";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);
            insertStmt.executeUpdate();
            
            // Redirect to login page on success
            response.sendRedirect(request.getContextPath() + "/login?register=success");

        } catch (Exception e) {
            e.printStackTrace();
            // Catch any other generic database errors (like lost connection)
            response.sendRedirect(request.getContextPath() + "/register?error=sys");
        }
    }
}