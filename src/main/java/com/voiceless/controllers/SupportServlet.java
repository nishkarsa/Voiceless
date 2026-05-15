package com.voiceless.controllers;

import com.voiceless.dao.SupportMessageDao;
import com.voiceless.model.SupportMessageModel;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/support/send")
public class SupportServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            if (isAjax(request)) {
                sendJson(response, false, "Not authenticated");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        String userEmail = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        SupportMessageModel msg = new SupportMessageModel();
        msg.setUserId(userId);
        msg.setUserName(userName != null ? userName : "Unknown");
        msg.setUserEmail(userEmail);
        msg.setSubject(subject);
        msg.setMessage(message);

        SupportMessageDao dao = new SupportMessageDao();
        boolean success = dao.insertMessage(msg);

        if (isAjax(request)) {
            sendJson(response, success, success ? "Message sent successfully" : "Failed to send message");
        } else {
            String role = (String) session.getAttribute("userRole");
            if ("STAFF".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/staff/dashboard?support=" + (success ? "sent" : "error"));
            } else {
                response.sendRedirect(request.getContextPath() + "/user/dashboard?support=" + (success ? "sent" : "error"));
            }
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
