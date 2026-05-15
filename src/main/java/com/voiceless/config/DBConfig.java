package com.voiceless.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConfig handles database connectivity and initial schema migrations.
 * It centralizes database configuration and ensures required tables/columns 
 * exist across different environments.
 */
public class DBConfig 
{
    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/voiceless_db";
    private static final String USERNAME = "root"; 
    private static final String PASSWORD = "";     

    /**
     * Establishes a connection to the MySQL database and performs self-healing migrations.
     * @return Connection object to the database
     * @throws SQLException if a database access error occurs
     * @throws ClassNotFoundException if the JDBC driver is not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException 
    {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        
        // Auto-apply essential DB migrations if missing (Self-healing schema)
        
        // 1. Create staff_applications table if it doesn't exist
        try (java.sql.Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS staff_applications (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "requested_role VARCHAR(20) NOT NULL, " +
                "status VARCHAR(20) DEFAULT 'PENDING', " +
                "applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (user_id) REFERENCES users(id))");
        } catch (SQLException e) { /* Ignored if structure matches */ }
        
        // 2. Add assigned_staff_id to reports for task management
        try (java.sql.Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("ALTER TABLE reports ADD COLUMN assigned_staff_id INT DEFAULT NULL");
        } catch (SQLException e) { /* Ignored if column already exists */ }
        
        // 3. Ensure status column is VARCHAR to support modern task workflow statuses
        try (java.sql.Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("ALTER TABLE reports MODIFY COLUMN status VARCHAR(30) DEFAULT 'PENDING'");
        } catch (SQLException e) { /* Ignored */ }
        
        return conn;
    }
}


