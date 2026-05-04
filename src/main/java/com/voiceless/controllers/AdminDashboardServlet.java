package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import com.voiceless.dao.UserDao;
import com.voiceless.dao.StaffApplicationDao;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.model.ReportModel;
import com.voiceless.model.GenericUserModel;
import com.voiceless.model.StaffApplicationModel;
import com.voiceless.model.DeletionHistoryModel;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getSession().getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load all data for the admin console
        ReportDao reportDao = new ReportDao();
        UserDao userDao = new UserDao();
        StaffApplicationDao appDao = new StaffApplicationDao();
        DeletionHistoryDao historyDao = new DeletionHistoryDao();

        // Reports
        List<ReportModel> allReports = reportDao.getAllReports();
        request.setAttribute("allReports", allReports);
        request.setAttribute("totalReports", reportDao.countAll());
        request.setAttribute("pendingCount", reportDao.countByStatus("PENDING"));
        request.setAttribute("assignedCount", reportDao.countByStatus("ASSIGNED"));
        request.setAttribute("resolvedCount", reportDao.countByStatus("RESOLVED"));

        // Users
        List<GenericUserModel> allUsers = userDao.getAllUsers();
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("totalUsers", userDao.countAll());
        request.setAttribute("staffCount", userDao.countByRole("STAFF"));

        // Applications
        List<StaffApplicationModel> applications = appDao.getAllApplications();
        request.setAttribute("applications", applications);
        request.setAttribute("pendingApps", appDao.countPending());

        // Deletion History
        List<DeletionHistoryModel> history = historyDao.getAllHistory();
        request.setAttribute("deletionHistory", history);

        request.getRequestDispatcher("/WEB-INF/pages/admin_dashboard.jsp").forward(request, response);
    }
}