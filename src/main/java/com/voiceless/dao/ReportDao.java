package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.ReportModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * ReportDao manages all database operations for incident reports.
 * It handles the creation, retrieval, and status updates of wildlife incidents.
 */
public class ReportDao {
    
    /**
     * Maps a database result set row to a ReportModel object.
     * @param rs ResultSet from database
     * @return populated ReportModel
     * @throws Exception if mapping fails
     */
    private ReportModel mapRow(ResultSet rs) throws Exception {
        ReportModel report = new ReportModel();
        report.setId(rs.getInt("id"));
        report.setUserId(rs.getInt("user_id"));
        report.setAnimalType(rs.getString("animal_type"));
        report.setCategory(rs.getString("category"));
        report.setLocationDesc(rs.getString("location_desc"));
        report.setDescription(rs.getString("description"));
        report.setStatus(rs.getString("status"));
        report.setLatitude(rs.getDouble("latitude"));
        report.setLongitude(rs.getDouble("longitude"));
        report.setReportDate(rs.getTimestamp("report_date"));
        report.setAssignedStaffId(rs.getInt("assigned_staff_id"));
        report.setPhotoPath(rs.getString("photo_path"));
        return report;
    }

    /**
     * Retrieves all reports from the database, newest first.
     * @return List of ReportModel objects
     */
    public List<ReportModel> getAllReports() {
        List<ReportModel> reportsList = new ArrayList<>();
        String query = "SELECT r.*, u.name AS reporter_name FROM reports r LEFT JOIN users u ON r.user_id = u.id ORDER BY r.report_date DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ReportModel report = mapRow(rs);
                report.setReporterName(rs.getString("reporter_name"));
                reportsList.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reportsList;
    }

    /**
     * Fetches all reports filed by a specific user.
     * @param userId The ID of the reporting user
     * @return List of user-specific reports
     */
    public List<ReportModel> getReportsByUserId(int userId) {
        List<ReportModel> reportsList = new ArrayList<>();
        String query = "SELECT * FROM reports WHERE user_id = ? ORDER BY report_date DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reportsList.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reportsList;
    }

    /**
     * Updates the lifecycle status of a report.
     * @param reportId The ID of the report to update
     * @param status The new status (PENDING, ASSIGNED, RESOLVED, etc.)
     * @return true if update succeeded
     */
    public boolean updateReportStatus(int reportId, String status) {
        String sql = "UPDATE reports SET status = ? WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Manually assigns a staff member to an incident.
     * @param reportId The incident ID
     * @param staffId The staff member's user ID
     * @return true if assignment succeeded
     */
    public boolean assignStaffToReport(int reportId, int staffId) {
        String sql = "UPDATE reports SET assigned_staff_id = ?, status = 'ASSIGNED' WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Allows a staff member to request assignment to a PENDING incident.
     * @param reportId The incident ID
     * @param staffId The staff member's user ID
     * @return true if request was successfully logged
     */
    public boolean requestStaffAssignment(int reportId, int staffId) {
        String sql = "UPDATE reports SET assigned_staff_id = ?, status = 'REQUESTED' WHERE id = ? AND status = 'PENDING'";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin tool to force-assign a staff member regardless of current state.
     * @param reportId The incident ID
     * @param staffId The staff member's user ID
     * @return true if forced assignment succeeded
     */
    public boolean forceAssignStaff(int reportId, int staffId) {
        String sql = "UPDATE reports SET assigned_staff_id = ?, status = 'FORCE_ASSIGNED' WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Staff action to accept a forced assignment.
     */
    public boolean acceptForceAssignment(int reportId, int staffId) {
        String sql = "UPDATE reports SET status = 'ASSIGNED' WHERE id = ? AND assigned_staff_id = ? AND status = 'FORCE_ASSIGNED'";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            stmt.setInt(2, staffId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Staff action to deny/reject a forced assignment.
     */
    public boolean denyForceAssignment(int reportId, int staffId) {
        String sql = "UPDATE reports SET assigned_staff_id = NULL, status = 'PENDING' WHERE id = ? AND assigned_staff_id = ? AND status = 'FORCE_ASSIGNED'";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            stmt.setInt(2, staffId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Returns a list of reports filtered by status.
     */
    public List<ReportModel> getReportsByStatus(String status) {
        List<ReportModel> reportsList = new ArrayList<>();
        String query = "SELECT r.*, u.name AS reporter_name FROM reports r LEFT JOIN users u ON r.user_id = u.id WHERE r.status = ? ORDER BY r.report_date DESC";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportModel report = mapRow(rs);
                report.setReporterName(rs.getString("reporter_name"));
                reportsList.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reportsList;
    }

    /**
     * Fetches all reports currently assigned to a specific staff member.
     */
    public List<ReportModel> getReportsByStaffId(int staffId) {
        List<ReportModel> reportsList = new ArrayList<>();
        String query = "SELECT r.*, u.name AS reporter_name FROM reports r LEFT JOIN users u ON r.user_id = u.id WHERE r.assigned_staff_id = ? ORDER BY r.report_date DESC";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportModel report = mapRow(rs);
                report.setReporterName(rs.getString("reporter_name"));
                reportsList.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reportsList;
    }

    /**
     * Resets a report to PENDING and clears the staff assignment.
     */
    public boolean clearStaffAssignment(int reportId) {
        String sql = "UPDATE reports SET assigned_staff_id = NULL, status = 'PENDING' WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetches a single incident report by its primary ID.
     */
    public ReportModel getReportById(int reportId) {
        String query = "SELECT r.*, u.name AS reporter_name FROM reports r LEFT JOIN users u ON r.user_id = u.id WHERE r.id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, reportId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ReportModel report = mapRow(rs);
                report.setReporterName(rs.getString("reporter_name"));
                return report;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Permanently deletes a report from the database.
     */
    public boolean deleteReport(int reportId) {
        String sql = "DELETE FROM reports WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Advanced search functionality for filtering reports by keyword, category, and status.
     */
    public List<ReportModel> searchReports(String keyword, String category, String status) {
        List<ReportModel> reportsList = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT r.*, u.name AS reporter_name FROM reports r LEFT JOIN users u ON r.user_id = u.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.append(" AND (r.animal_type LIKE ? OR r.description LIKE ? OR r.location_desc LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (category != null && !category.trim().isEmpty() && !"all".equalsIgnoreCase(category)) {
            query.append(" AND r.category = ?");
            params.add(category.trim());
        }
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            query.append(" AND r.status = ?");
            params.add(status.trim());
        }
        query.append(" ORDER BY r.report_date DESC");

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportModel report = mapRow(rs);
                report.setReporterName(rs.getString("reporter_name"));
                reportsList.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reportsList;
    }

    /**
     * Returns the count of reports with a specific status (for dashboard stats).
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns the total count of reports in the system.
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM reports";
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