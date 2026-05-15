package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.SupportMessageModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupportMessageDao {

    // Insert a new support message
    public boolean insertMessage(SupportMessageModel msg) {
        String sql = "INSERT INTO support_messages (user_id, user_name, user_email, subject, message) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, msg.getUserId());
            stmt.setString(2, msg.getUserName());
            stmt.setString(3, msg.getUserEmail());
            stmt.setString(4, msg.getSubject());
            stmt.setString(5, msg.getMessage());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all support messages (for admin view)
    public List<SupportMessageModel> getAllMessages() {
        List<SupportMessageModel> list = new ArrayList<>();
        String sql = "SELECT * FROM support_messages ORDER BY created_at DESC";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                SupportMessageModel msg = new SupportMessageModel();
                msg.setId(rs.getInt("id"));
                msg.setUserId(rs.getInt("user_id"));
                msg.setUserName(rs.getString("user_name"));
                msg.setUserEmail(rs.getString("user_email"));
                msg.setSubject(rs.getString("subject"));
                msg.setMessage(rs.getString("message"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count all messages
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM support_messages";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public SupportMessageModel getMessageById(int id) {
        String sql = "SELECT * FROM support_messages WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    SupportMessageModel msg = new SupportMessageModel();
                    msg.setId(rs.getInt("id"));
                    msg.setUserId(rs.getInt("user_id"));
                    msg.setUserName(rs.getString("user_name"));
                    msg.setUserEmail(rs.getString("user_email"));
                    msg.setSubject(rs.getString("subject"));
                    msg.setMessage(rs.getString("message"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    return msg;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteMessage(int id) {
        String sql = "DELETE FROM support_messages WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
