package com.voiceless.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/login")
public class StaffLoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/staff_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String staffEmail = request.getParameter("staffEmail");
        String staffPassword = request.getParameter("staffPassword");
        HttpSession session = request.getSession();
        
        // Hardcoded Staff Credentials
        if ("staff@voiceless.org".equals(staffEmail) && "staff123".equals(staffPassword)) {
            session.setAttribute("userRole", "STAFF");
            session.setAttribute("userName", "Field Staff Alpha");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard"); 
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/login?error=true");
        }
    }
}