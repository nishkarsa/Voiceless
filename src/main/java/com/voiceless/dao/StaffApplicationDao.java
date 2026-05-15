package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.StaffApplicationModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * StaffApplicationDao manages the workflow for users applying for staff roles.
 * It handles application submission, retrieval for admin review, and status updates.
 */
public class StaffApplicationDao {

    /**
     * Submits a new application for a staff role.
     * Checks for existing pending applications to prevent duplicates.
     * @param userId The ID of the applying user
     * @param requestedRole The role they are applying for (STAFF/HELPER)
     * @return true if submission succeeded, false if duplicate or error
     */
    public boolean submitApplication(int userId, String requestedRole) {
        // Check if user already has a pending application to prevent spam
        String checkSql = "SELECT id FROM staff_applications WHERE user_id = ? AND status = 'PENDING'";
        String insertSql = "INSERT INTO staff_applications (user_id, requested_role) VALUES (?, ?)";

        try (Connection conn = DBConfig.getConnection()) {
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                return false; // Already has a pending application
            }

            // Perform the insertion
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, userId);
            insertStmt.setString(2, requestedRole);
            return insertStmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves all applications joined with user data for admin review.
     * @return List of all staff applications
     */
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

    /**
     * Updates an application status (e.g., APPROVED, REJECTED).
     */
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

    /**
     * Fetches a single application by its primary ID.
     */
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

    /**
     * Returns the total count of PENDING applications for admin alerts.
     */
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
