package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.ReportModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReportDao {
    
    // Helper to build a ReportModel from a ResultSet row
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

    // Get all reports, newest first
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

    // Get reports filed by a specific user
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

    // Update report status (PENDING, ASSIGNED, RESOLVED)
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

    // Assign a staff member to a report
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

    // Get a single report by ID
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

    // Delete a report from DB (used after archiving to history)
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

    // Search and filter reports
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

    // Count reports by status
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

    // Count total reports
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