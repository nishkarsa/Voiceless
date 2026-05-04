package com.voiceless.controllers;

import com.voiceless.dao.UserDao;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.model.GenericUserModel;
import com.voiceless.model.DeletionHistoryModel;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/user/action")
public class AdminUserActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        int userId = Integer.parseInt(userIdStr);
        UserDao userDao = new UserDao();

        if ("changeRole".equals(action)) {
            String newRole = request.getParameter("role");
            userDao.updateUserRole(userId, newRole);
        } else if ("delete".equals(action)) {
            // Archive to history queue before deleting
            GenericUserModel user = userDao.getUserById(userId);
            if (user != null) {
                DeletionHistoryDao historyDao = new DeletionHistoryDao();
                DeletionHistoryModel historyItem = new DeletionHistoryModel();
                historyItem.setEntityType("USER");
                historyItem.setEntityId(userId);
                String snapshot = "{\"name\":\"" + user.getName()
                    + "\",\"email\":\"" + user.getEmail()
                    + "\",\"role\":\"" + user.getRole()
                    + "\"}";
                historyItem.setEntityData(snapshot);
                historyItem.setDeletedBy((String) request.getSession().getAttribute("userName"));
                String reason = request.getParameter("reason");
                historyItem.setReason(reason != null ? reason : "Admin action");

                historyDao.enqueue(historyItem);
                userDao.deleteUser(userId);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
