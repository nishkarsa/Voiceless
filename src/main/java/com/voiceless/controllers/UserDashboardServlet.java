package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import com.voiceless.dao.UserDao;
import com.voiceless.model.ReportModel;
import com.voiceless.model.GenericUserModel;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/dashboard")
public class UserDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        ReportDao reportDao = new ReportDao();

        // Load user's personal reports only (for "My Reports" section)
        List<ReportModel> myReports = reportDao.getReportsByUserId(userId);
        request.setAttribute("myReports", myReports);

        // Load ALL reports for the heatmap data only (community overview)
        List<ReportModel> allReports = reportDao.getAllReports();
        request.setAttribute("allReportsForMap", allReports);

        // Counts for personal stats
        int myTotal = myReports.size();
        int myPending = 0, myAssigned = 0, myResolved = 0;
        for (ReportModel r : myReports) {
            if ("PENDING".equals(r.getStatus())) myPending++;
            else if ("ASSIGNED".equals(r.getStatus())) myAssigned++;
            else if ("RESOLVED".equals(r.getStatus())) myResolved++;
        }
        request.setAttribute("myTotal", myTotal);
        request.setAttribute("myPending", myPending);
        request.setAttribute("myAssigned", myAssigned);
        request.setAttribute("myResolved", myResolved);

        // Community totals for heatmap header
        request.setAttribute("totalReports", reportDao.countAll());

        // Load user profile image
        UserDao userDao = new UserDao();
        GenericUserModel user = userDao.getUserById(userId);
        if (user != null && user.getProfileImage() != null) {
            session.setAttribute("userProfileImage", user.getProfileImage());
        }

        request.getRequestDispatcher("/WEB-INF/pages/user_dashboard.jsp").forward(request, response);
    }
}
