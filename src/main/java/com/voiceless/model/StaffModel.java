package com.voiceless.model;

public class StaffModel extends UserModel {
    private String department;
    private boolean isAvailable; // To check if they are currently assigned a carcass removal task

    public StaffModel() {
        super();
        this.role = "STAFF";
    }

    public StaffModel(int id, String name, String email, String department, boolean isAvailable) {
        // Calls the parent constructor
        super(id, name, email, "STAFF");
        this.department = department;
        this.isAvailable = isAvailable;
    }

    // Getters and Setters specific to Staff
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }
}