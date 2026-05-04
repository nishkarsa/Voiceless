package com.voiceless.model;

import java.util.Date;

public class DeletionHistoryModel {
    private int id;
    private String entityType;   // "REPORT" or "USER"
    private int entityId;
    private String entityData;   // JSON snapshot of the deleted record
    private String deletedBy;
    private Date deletedAt;
    private String reason;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEntityType() { return entityType; }
    public void setEntityType(String entityType) { this.entityType = entityType; }

    public int getEntityId() { return entityId; }
    public void setEntityId(int entityId) { this.entityId = entityId; }

    public String getEntityData() { return entityData; }
    public void setEntityData(String entityData) { this.entityData = entityData; }

    public String getDeletedBy() { return deletedBy; }
    public void setDeletedBy(String deletedBy) { this.deletedBy = deletedBy; }

    public Date getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Date deletedAt) { this.deletedAt = deletedAt; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
