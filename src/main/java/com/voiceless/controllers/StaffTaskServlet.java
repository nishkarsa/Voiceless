package com.voiceless.controllers;

import com.voiceless.dao.ReportDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * StaffTaskServlet handles task-related actions initiated by field staff.
 * It manages task completion and acceptance/denial of forced assignments.
 */
@WebServlet("/staff/update-task")
public class StaffTaskServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. Security Check: Only logged-in STAFF can perform task updates
        if (session == null || !"STAFF".equals(session.getAttribute("userRole"))) {
            if (isAjax(request)) {
                sendJson(response, false, "Not authenticated");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/staff/login");
            return;
        }

        // 2. Extract Parameters
        String action = request.getParameter("action");
        int reportId = Integer.parseInt(request.getParameter("reportId"));
        int staffId = (Integer) session.getAttribute("userId");
        ReportDao reportDao = new ReportDao();
        boolean success = false;
        String newStatus = "";

        if (action == null) action = "complete"; // Default to complete for simple submissions

        // 3. Process task state transitions
        switch (action) {
            case "complete":
                // Staff member has finished the removal/treatment
                // Transition: ASSIGNED -> COMPLETED (Awaiting admin verification)
                success = reportDao.updateReportStatus(reportId, "COMPLETED");
                newStatus = "COMPLETED";
                break;
            case "acceptAssignment":
                // Staff accepts a task that was force-assigned by the admin
                // Transition: FORCE_ASSIGNED -> ASSIGNED
                success = reportDao.acceptForceAssignment(reportId, staffId);
                newStatus = "ASSIGNED";
                break;
            case "denyAssignment":
                // Staff rejects a force-assignment; incident goes back to open pool
                // Transition: FORCE_ASSIGNED -> PENDING
                success = reportDao.denyForceAssignment(reportId, staffId);
                newStatus = "PENDING";
                break;
            default:
                break;
        }

        // 4. Return Response
        if (isAjax(request)) {
            sendJson(response, success, newStatus);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?update=success");
        }
    }

    /**
     * Detects AJAX request by checking the X-Requested-With header.
     */
    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    /**
     * Standardized JSON output for frontend handlers.
     */
    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
}