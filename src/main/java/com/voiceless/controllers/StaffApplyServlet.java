package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/apply")
public class StaffApplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"STAFF".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        String reportIdStr = request.getParameter("reportId");
        int reportId = Integer.parseInt(reportIdStr);
        int staffId = (Integer) session.getAttribute("userId");

        ReportDao reportDao = new ReportDao();
        reportDao.assignStaffToReport(reportId, staffId);

        response.sendRedirect(request.getContextPath() + "/staff/dashboard?applied=success");
    }
}
