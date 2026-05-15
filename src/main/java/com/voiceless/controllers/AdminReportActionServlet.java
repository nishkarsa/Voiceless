package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.model.ReportModel;
import com.voiceless.model.DeletionHistoryModel;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/report/action")
public class AdminReportActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            if (isAjax(request)) {
                sendJson(response, false, "Not authenticated");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        String reportIdStr = request.getParameter("reportId");
        int reportId = Integer.parseInt(reportIdStr);
        ReportDao reportDao = new ReportDao();
        boolean success = false;
        String resultMsg = "";

        if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("status");
            success = reportDao.updateReportStatus(reportId, newStatus);
            resultMsg = newStatus;
        } else if ("delete".equals(action)) {
            // Archive to history queue before deleting
            ReportModel report = reportDao.getReportById(reportId);
            if (report != null) {
                DeletionHistoryDao historyDao = new DeletionHistoryDao();
                DeletionHistoryModel historyItem = new DeletionHistoryModel();
                historyItem.setEntityType("REPORT");
                historyItem.setEntityId(reportId);
                // Build a simple JSON snapshot of the report
                String snapshot = "{\"animalType\":\"" + report.getAnimalType() 
                    + "\",\"category\":\"" + report.getCategory()
                    + "\",\"status\":\"" + report.getStatus()
                    + "\",\"location\":\"" + report.getLocationDesc()
                    + "\",\"description\":\"" + (report.getDescription() != null ? report.getDescription().replace("\"", "'") : "")
                    + "\",\"reporter\":\"" + (report.getReporterName() != null ? report.getReporterName() : "Unknown")
                    + "\"}";
                historyItem.setEntityData(snapshot);
                historyItem.setDeletedBy((String) request.getSession().getAttribute("userName"));
                String reason = request.getParameter("reason");
                historyItem.setReason(reason != null ? reason : "Admin action");

                historyDao.enqueue(historyItem);
                success = reportDao.deleteReport(reportId);
                resultMsg = "DELETED";
            }
        }

        if (isAjax(request)) {
            sendJson(response, success, resultMsg);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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
