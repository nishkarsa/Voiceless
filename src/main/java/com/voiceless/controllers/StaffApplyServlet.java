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
            if (isAjax(request)) {
                sendJson(response, false, "Not authenticated");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        String reportIdStr = request.getParameter("reportId");
        int reportId = Integer.parseInt(reportIdStr);
        int staffId = (Integer) session.getAttribute("userId");

        ReportDao reportDao = new ReportDao();
        boolean success = reportDao.requestStaffAssignment(reportId, staffId);

        if (isAjax(request)) {
            sendJson(response, success, success ? "REQUESTED" : "ALREADY_TAKEN");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?applied=" + (success ? "success" : "already"));
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
}
