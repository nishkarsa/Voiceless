package com.voiceless.controllers;

import com.voiceless.dao.StaffApplicationDao;
import com.voiceless.dao.UserDao;
import com.voiceless.model.StaffApplicationModel;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/application/action")
public class AdminApplicationActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action"); // "approve" or "reject"
        String appIdStr = request.getParameter("appId");
        int appId = Integer.parseInt(appIdStr);

        StaffApplicationDao appDao = new StaffApplicationDao();

        if ("approve".equals(action)) {
            // Get the application to find the user and requested role
            StaffApplicationModel app = appDao.getApplicationById(appId);
            if (app != null) {
                // Update application status
                appDao.updateApplicationStatus(appId, "APPROVED");
                // Update user role to the requested role
                UserDao userDao = new UserDao();
                userDao.updateUserRole(app.getUserId(), app.getRequestedRole());
            }
        } else if ("reject".equals(action)) {
            appDao.updateApplicationStatus(appId, "REJECTED");
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
