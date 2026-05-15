package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import com.voiceless.dao.UserDao;
import com.voiceless.dao.StaffApplicationDao;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.dao.SupportMessageDao;
import com.voiceless.model.ReportModel;
import com.voiceless.model.GenericUserModel;
import com.voiceless.model.StaffApplicationModel;
import com.voiceless.model.DeletionHistoryModel;
import com.voiceless.model.SupportMessageModel;
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
        SupportMessageDao supportDao = new SupportMessageDao();

        // Reports
        List<ReportModel> allReports = reportDao.getAllReports();
        request.setAttribute("allReports", allReports);
        request.setAttribute("totalReports", reportDao.countAll());
        request.setAttribute("pendingCount", reportDao.countByStatus("PENDING"));
        request.setAttribute("assignedCount", reportDao.countByStatus("ASSIGNED"));
        request.setAttribute("resolvedCount", reportDao.countByStatus("RESOLVED"));

        // Task requests (REQUESTED status — awaiting admin approval)
        List<ReportModel> taskRequests = reportDao.getReportsByStatus("REQUESTED");
        request.setAttribute("taskRequests", taskRequests);
        request.setAttribute("requestedCount", taskRequests.size());

        // Completion reports (COMPLETED status — awaiting admin verification)
        List<ReportModel> completionReports = reportDao.getReportsByStatus("COMPLETED");
        request.setAttribute("completionReports", completionReports);
        request.setAttribute("completedCount", completionReports.size());

        // Users
        List<GenericUserModel> allUsers = userDao.getAllUsers();
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("totalUsers", userDao.countAll());
        request.setAttribute("staffCount", userDao.countByRole("STAFF"));

        // Staff list for force-assign dropdown
        List<GenericUserModel> staffUsers = userDao.getStaffUsers();
        request.setAttribute("staffUsers", staffUsers);

        // Applications
        List<StaffApplicationModel> applications = appDao.getAllApplications();
        request.setAttribute("applications", applications);
        request.setAttribute("pendingApps", appDao.countPending());

        // Deletion History
        List<DeletionHistoryModel> history = historyDao.getAllHistory();
        request.setAttribute("deletionHistory", history);

        // Support Messages
        List<SupportMessageModel> supportMessages = supportDao.getAllMessages();
        request.setAttribute("supportMessages", supportMessages);
        request.setAttribute("supportCount", supportMessages.size());

        request.getRequestDispatcher("/WEB-INF/pages/admin_dashboard.jsp").forward(request, response);
    }
}