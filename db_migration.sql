-- =============================================
-- Voiceless Database Migration Script
-- Run this against your voiceless_db database
-- =============================================

-- 1. Add assigned_staff_id column to reports table
ALTER TABLE reports ADD COLUMN IF NOT EXISTS assigned_staff_id INT DEFAULT NULL;

-- 2. Add photo_path column to reports table
ALTER TABLE reports ADD COLUMN IF NOT EXISTS photo_path VARCHAR(255) DEFAULT NULL;

-- 3. Add profile_image column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_image VARCHAR(255) DEFAULT NULL;

-- 4. Create staff_applications table
CREATE TABLE IF NOT EXISTS staff_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    requested_role VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Create deletion_history table (queue-backed)
CREATE TABLE IF NOT EXISTS deletion_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type VARCHAR(20) NOT NULL,
    entity_id INT NOT NULL,
    entity_data TEXT NOT NULL,
    deleted_by VARCHAR(50) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(255)
);

-- 6. No schema change needed for new status values (REQUESTED, COMPLETED, FORCE_ASSIGNED).
--    The reports.status column is VARCHAR(20) which supports the full workflow:
--    PENDING -> REQUESTED -> ASSIGNED -> COMPLETED -> RESOLVED
--    PENDING -> FORCE_ASSIGNED -> ASSIGNED (staff accepts) or PENDING (staff denies)

-- 7. Create support_messages table
CREATE TABLE IF NOT EXISTS support_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_name VARCHAR(100),
    user_email VARCHAR(100),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
