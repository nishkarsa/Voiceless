<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-layout">
        <div class="sidebar">
            <div class="sidebar-header">
                <h1 class="title" style="font-size:1.5rem;">Admin Console</h1>
            </div>
            <div class="sidebar-nav">
                <a href="#" class="nav-item active">Overview</a>
                <a href="#" class="nav-item">User Management</a>
                <a href="#" class="nav-item">Assign Tasks (Staff)</a>
            </div>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="nav-item" style="text-align:center;">🚪 Logout</a>
            </div>
        </div>

        <div class="main-content admin-content">
            <h2 class="title" style="margin-bottom:2rem;">Recent User Submissions</h2>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Animal Type</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Oct 24, 2023</td>
                        <td><strong>North American Elk</strong><br><span class="text-danger" style="font-size:0.75rem;">Carcass</span></td>
                        <td>Highway 101, MP 42</td>
                        <td><span class="badge badge-red">Pending</span></td>
                        <td>
                            <a href="#" style="color:#5b6e54; font-weight:bold; font-size:0.875rem; margin-right:1rem;">Verify</a>
                            <a href="#" style="color:#2563eb; font-weight:bold; font-size:0.875rem;">Assign Staff</a>
                        </td>
                    </tr>
                    <tr>
                        <td>Oct 24, 2023</td>
                        <td><strong>Red Fox</strong><br><span style="color:#ca8a04; font-size:0.75rem; font-weight:bold;">Sick / Injured</span></td>
                        <td>County Road B</td>
                        <td><span class="badge badge-green">Verified</span></td>
                        <td><a href="#" style="color:#64748b; font-size:0.875rem;">View Details</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>