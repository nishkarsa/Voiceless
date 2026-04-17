package com.voiceless.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Security check: Ensure only users with the 'STAFF' role can view this page
        if (session == null || !"STAFF".equals(session.getAttribute("userRole"))) {
            // If they are not logged in as staff, redirect them to the staff login page
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }
        
        // If authorized, forward them to the secure JSP page
        request.getRequestDispatcher("/WEB-INF/pages/staff_dashboard.jsp").forward(request, response);
    }
}