package com.voiceless.controllers;

import com.voiceless.config.DBConfig;
import com.voiceless.dao.DeletionHistoryDao;
import com.voiceless.model.DeletionHistoryModel;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/restore/action")
public class AdminRestoreActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("adminLoggedIn") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String historyIdStr = request.getParameter("historyId");
        int historyId = Integer.parseInt(historyIdStr);
        
        DeletionHistoryDao historyDao = new DeletionHistoryDao();
        // Since history items are in a list, we might need a way to get one by ID from DB
        DeletionHistoryModel itemToRestore = null;
        for (DeletionHistoryModel item : historyDao.getAllHistory()) {
            if (item.getId() == historyId) {
                itemToRestore = item;
                break;
            }
        }

        if (itemToRestore != null) {
            String data = itemToRestore.getEntityData();
            String type = itemToRestore.getEntityType();

            try (Connection conn = DBConfig.getConnection()) {
                if ("USER".equals(type)) {
                    // Extract data from simple JSON representation
                    String name = extractJsonValue(data, "name");
                    String email = extractJsonValue(data, "email");
                    String role = extractJsonValue(data, "role");
                    
                    String sql = "INSERT INTO users (id, name, email, role, password) VALUES (?, ?, ?, ?, 'restored_password')";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, itemToRestore.getEntityId());
                        stmt.setString(2, name);
                        stmt.setString(3, email);
                        stmt.setString(4, role);
                        stmt.executeUpdate();
                    } catch (Exception e) {
                        e.printStackTrace();
                        // Fallback if ID exists or error
                        String sql2 = "INSERT INTO users (name, email, role, password) VALUES (?, ?, ?, 'restored_password')";
                        try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                            stmt2.setString(1, name);
                            stmt2.setString(2, email);
                            stmt2.setString(3, role);
                            stmt2.executeUpdate();
                        }
                    }
                } else if ("SUPPORT".equals(type)) {
                    String userId = extractJsonValue(data, "user_id");
                    String userName = extractJsonValue(data, "user_name");
                    String userEmail = extractJsonValue(data, "user_email");
                    String subject = extractJsonValue(data, "subject");
                    String message = extractJsonValue(data, "message");

                    String sql = "INSERT INTO support_messages (id, user_id, user_name, user_email, subject, message) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, itemToRestore.getEntityId());
                        stmt.setInt(2, userId != null && !userId.isEmpty() && !userId.equals("null") ? Integer.parseInt(userId) : 0);
                        stmt.setString(3, userName);
                        stmt.setString(4, userEmail);
                        stmt.setString(5, subject);
                        stmt.setString(6, message);
                        stmt.executeUpdate();
                    } catch (Exception e) {
                        e.printStackTrace();
                        String sql2 = "INSERT INTO support_messages (user_id, user_name, user_email, subject, message) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                            stmt2.setInt(1, userId != null && !userId.isEmpty() && !userId.equals("null") ? Integer.parseInt(userId) : 0);
                            stmt2.setString(2, userName);
                            stmt2.setString(3, userEmail);
                            stmt2.setString(4, subject);
                            stmt2.setString(5, message);
                            stmt2.executeUpdate();
                        }
                    }
                } else if ("REPORT".equals(type)) {
                    String animalType = extractJsonValue(data, "animalType");
                    String category = extractJsonValue(data, "category");
                    String status = extractJsonValue(data, "status");
                    String location = extractJsonValue(data, "location");
                    String description = extractJsonValue(data, "description");
                    String reporter = extractJsonValue(data, "reporter");
                    
                    String sql = "INSERT INTO reports (id, animal_type, category, status, location_desc, description) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, itemToRestore.getEntityId());
                        stmt.setString(2, animalType);
                        stmt.setString(3, category);
                        stmt.setString(4, status);
                        stmt.setString(5, location);
                        stmt.setString(6, description);
                        stmt.executeUpdate();
                    } catch (Exception e) {
                        e.printStackTrace();
                        String sql2 = "INSERT INTO reports (animal_type, category, status, location_desc, description) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                            stmt2.setString(1, animalType);
                            stmt2.setString(2, category);
                            stmt2.setString(3, status);
                            stmt2.setString(4, location);
                            stmt2.setString(5, description);
                            stmt2.executeUpdate();
                        }
                    }
                }

                // Delete from history
                String delSql = "DELETE FROM deletion_history WHERE id = ?";
                try (PreparedStatement delStmt = conn.prepareStatement(delSql)) {
                    delStmt.setInt(1, historyId);
                    delStmt.executeUpdate();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\":\"";
        int start = json.indexOf(searchKey);
        if (start == -1) return "";
        start += searchKey.length();
        int end = json.indexOf("\"", start);
        if (end == -1) return "";
        return json.substring(start, end).replace("\\\"", "\"");
    }
}
