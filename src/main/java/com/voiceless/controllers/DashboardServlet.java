// src/main/java/com/voiceless/controllers/DashboardServlet.java
package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import com.voiceless.model.ReportModel;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Initialize DAO and fetch reports from voiceless_db
        ReportDao dao = new ReportDao();
        List<ReportModel> databaseReports = dao.getAllReports();
        
        // 2. Attach the reports to the request object so the JSP can see them
        request.setAttribute("recentReports", databaseReports);
        
        // 3. Send the user to the dashboard page
        request.getRequestDispatcher("/WEB-INF/pages/user_dashboard.jsp").forward(request, response);
    }
}