package com.voiceless.dao;

import com.voiceless.config.DBConfig;
import com.voiceless.model.DeletionHistoryModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class DeletionHistoryDao {

    // In-memory queue for FIFO processing of recent deletions
    private static final Queue<DeletionHistoryModel> deletionQueue = new LinkedList<>();

    // Enqueue a deletion: adds to in-memory queue AND persists to DB
    public void enqueue(DeletionHistoryModel item) {
        // Add to in-memory queue
        deletionQueue.add(item);

        // Persist to database
        String sql = "INSERT INTO deletion_history (entity_type, entity_id, entity_data, deleted_by, reason) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getEntityType());
            stmt.setInt(2, item.getEntityId());
            stmt.setString(3, item.getEntityData());
            stmt.setString(4, item.getDeletedBy());
            stmt.setString(5, item.getReason());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Dequeue the oldest deletion from in-memory queue
    public DeletionHistoryModel dequeue() {
        return deletionQueue.poll();
    }

    // Peek at the next item without removing
    public DeletionHistoryModel peek() {
        return deletionQueue.peek();
    }

    // Check if in-memory queue is empty
    public boolean isQueueEmpty() {
        return deletionQueue.isEmpty();
    }

    // Get queue size
    public int queueSize() {
        return deletionQueue.size();
    }

    // Get all deletion history from DB (for admin history tab)
    public List<DeletionHistoryModel> getAllHistory() {
        List<DeletionHistoryModel> historyList = new LinkedList<>();
        String sql = "SELECT * FROM deletion_history ORDER BY deleted_at DESC";

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DeletionHistoryModel item = new DeletionHistoryModel();
                item.setId(rs.getInt("id"));
                item.setEntityType(rs.getString("entity_type"));
                item.setEntityId(rs.getInt("entity_id"));
                item.setEntityData(rs.getString("entity_data"));
                item.setDeletedBy(rs.getString("deleted_by"));
                item.setDeletedAt(rs.getTimestamp("deleted_at"));
                item.setReason(rs.getString("reason"));
                historyList.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historyList;
    }

    // Load DB history into queue (call on app startup if needed)
    public void loadQueueFromDb() {
        deletionQueue.clear();
        List<DeletionHistoryModel> all = getAllHistory();
        deletionQueue.addAll(all);
    }
}
