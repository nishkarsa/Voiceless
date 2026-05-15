package com.voiceless.controllers;

import com.voiceless.dao.SupportMessageDao;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.model.SupportMessageModel;
import com.voiceless.model.DeletionHistoryModel;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/support/action")
public class AdminSupportActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        String msgIdStr = request.getParameter("msgId");
        int msgId = Integer.parseInt(msgIdStr);
        SupportMessageDao supportDao = new SupportMessageDao();

        if ("delete".equals(action)) {
            SupportMessageModel msg = supportDao.getMessageById(msgId);
            if (msg != null) {
                DeletionHistoryDao historyDao = new DeletionHistoryDao();
                DeletionHistoryModel historyItem = new DeletionHistoryModel();
                historyItem.setEntityType("SUPPORT");
                historyItem.setEntityId(msgId);
                
                // Keep it simple and format it as JSON-like string since that is the established pattern
                String snapshot = "{\"user_id\":\"" + msg.getUserId()
                    + "\",\"user_name\":\"" + msg.getUserName().replace("\"", "\\\"")
                    + "\",\"user_email\":\"" + msg.getUserEmail().replace("\"", "\\\"")
                    + "\",\"subject\":\"" + msg.getSubject().replace("\"", "\\\"")
                    + "\",\"message\":\"" + msg.getMessage().replace("\"", "\\\"").replace("\r\n", " ").replace("\n", " ")
                    + "\"}";
                historyItem.setEntityData(snapshot);
                historyItem.setDeletedBy((String) request.getSession().getAttribute("userName"));
                historyItem.setReason("Admin action");

                historyDao.enqueue(historyItem);
                supportDao.deleteMessage(msgId);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
