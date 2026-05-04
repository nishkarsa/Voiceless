package com.voiceless.controllers;

import com.voiceless.dao.StaffApplicationDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/apply-role")
public class UserApplyRoleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String requestedRole = request.getParameter("requestedRole");

        StaffApplicationDao appDao = new StaffApplicationDao();
        boolean submitted = appDao.submitApplication(userId, requestedRole);

        if (submitted) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard?applied=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard?applied=duplicate");
        }
    }
}
