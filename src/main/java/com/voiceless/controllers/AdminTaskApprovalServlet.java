package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * AdminTaskApprovalServlet handles administrative actions on incident reports.
 * It manages the approval/rejection of staff requests and the final verification of tasks.
 */
@WebServlet("/admin/task/action")
public class AdminTaskApprovalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Security Check: Ensure admin is logged in
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            if (isAjax(request)) {
                sendJson(response, false, "Not authenticated");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // 2. Validate Action Parameter
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            if (isAjax(request)) { sendJson(response, false, "No action provided"); }
            else { response.sendRedirect(request.getContextPath() + "/admin/dashboard"); }
            return;
        }

        // 3. Process the requested action
        int reportId = Integer.parseInt(request.getParameter("reportId"));
        ReportDao reportDao = new ReportDao();
        boolean success = false;
        String newStatus = "";

        switch (action) {
            case "approve":
                // Admin approves a staff member's request to handle an incident
                // Transition: REQUESTED -> ASSIGNED
                success = reportDao.updateReportStatus(reportId, "ASSIGNED");
                newStatus = "ASSIGNED";
                break;
            case "reject":
                // Admin denies a staff request; incident returns to open pool
                // Transition: REQUESTED -> PENDING
                success = reportDao.clearStaffAssignment(reportId);
                newStatus = "PENDING";
                break;
            case "verify":
                // Admin confirms that the staff has completed the removal/treatment
                // Transition: COMPLETED -> RESOLVED
                success = reportDao.updateReportStatus(reportId, "RESOLVED");
                newStatus = "RESOLVED";
                break;
            case "rejectCompletion":
                // Admin finds the completion report unsatisfactory; sends back to staff
                // Transition: COMPLETED -> ASSIGNED
                success = reportDao.updateReportStatus(reportId, "ASSIGNED");
                newStatus = "ASSIGNED";
                break;
            case "forceAssign":
                // Admin manually assigns a specific staff member to an incident
                // Transition: Any -> FORCE_ASSIGNED
                String staffIdStr = request.getParameter("staffId");
                if (staffIdStr != null && !staffIdStr.isEmpty()) {
                    int staffId = Integer.parseInt(staffIdStr);
                    success = reportDao.forceAssignStaff(reportId, staffId);
                    newStatus = "FORCE_ASSIGNED";
                }
                break;
            default:
                break;
        }

        // 4. Return Response (supports both AJAX and Form-Redirect)
        if (isAjax(request)) {
            sendJson(response, success, newStatus);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    /**
     * Helper to detect if the request was made via AJAX (XMLHttpRequest).
     */
    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    /**
     * Utility to send standardized JSON response to the client.
     */
    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
}
