package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.StaffApplicationModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StaffApplicationDao {

    // Submit a new application
    public boolean submitApplication(int userId, String requestedRole) {
        // Check if user already has a pending application
        String checkSql = "SELECT id FROM staff_applications WHERE user_id = ? AND status = 'PENDING'";
        String insertSql = "INSERT INTO staff_applications (user_id, requested_role) VALUES (?, ?)";

        try (Connection conn = DBConfig.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                return false; // Already has a pending application
            }

            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, userId);
            insertStmt.setString(2, requestedRole);
            return insertStmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all applications (for admin review), joined with user info
    public List<StaffApplicationModel> getAllApplications() {
        List<StaffApplicationModel> apps = new ArrayList<>();
        String sql = "SELECT sa.*, u.name AS user_name, u.email AS user_email FROM staff_applications sa JOIN users u ON sa.user_id = u.id ORDER BY sa.applied_at DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                StaffApplicationModel app = new StaffApplicationModel();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setUserName(rs.getString("user_name"));
                app.setUserEmail(rs.getString("user_email"));
                app.setRequestedRole(rs.getString("requested_role"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                apps.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return apps;
    }

    // Update application status (APPROVED / REJECTED)
    public boolean updateApplicationStatus(int appId, String status) {
        String sql = "UPDATE staff_applications SET status = ? WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, appId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get application by ID
    public StaffApplicationModel getApplicationById(int appId) {
        String sql = "SELECT sa.*, u.name AS user_name, u.email AS user_email FROM staff_applications sa JOIN users u ON sa.user_id = u.id WHERE sa.id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                StaffApplicationModel app = new StaffApplicationModel();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setUserName(rs.getString("user_name"));
                app.setUserEmail(rs.getString("user_email"));
                app.setRequestedRole(rs.getString("requested_role"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                return app;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Count pending applications
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM staff_applications WHERE status = 'PENDING'";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
