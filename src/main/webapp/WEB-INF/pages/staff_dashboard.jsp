<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Dispatch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-layout">
        
        <div class="sidebar" style="border-right: 2px solid #ca8a04;">
            <div class="sidebar-header">
                <h1 class="title" style="font-size:1.5rem;">Dispatch</h1>
                <p style="font-size:0.75rem; color:#64748b;">Operator: <%= session.getAttribute("userName") %></p>
            </div>
            <div class="sidebar-nav">
                <a href="#" class="nav-item active">📋 Active Tasks</a>
                <a href="#" class="nav-item">✅ Completed Log</a>
            </div>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="nav-item" style="text-align:center;">🚪 Logout</a>
            </div>
        </div>

        <div class="main-content admin-content">
            
            <% if("success".equals(request.getParameter("update"))) { %>
                <div style="background: #dcfce7; color: #166534; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1.5rem; font-weight: bold; font-size: 0.875rem;">
                    Task successfully marked as removed!
                </div>
            <% } %>

            <h2 class="title" style="margin-bottom:0.5rem;">Your Assigned Removal Tasks</h2>
            <p class="subtitle">Safely remove and document the following verified reports.</p>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>Animal / Condition</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="font-family: monospace; color: #64748b;">#RPT-842</td>
                        <td><strong>North American Elk</strong><br><span class="text-danger" style="font-size:0.75rem; font-weight:bold;">Carcass</span></td>
                        <td>Highway 101, MP 42</td>
                        <td><span class="badge" style="background:#fef08a; color:#854d0e;">ASSIGNED</span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/staff/update-task" method="POST" style="margin: 0;">
                                <input type="hidden" name="reportId" value="842">
                                <button type="submit" class="btn btn-primary" style="padding:0.5rem 1rem; width:auto; font-size:0.8rem; background-color: #ca8a04;">Mark Removed</button>
                            </form>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="font-family: monospace; color: #64748b;">#RPT-845</td>
                        <td><strong>White-tailed Deer</strong><br><span class="text-danger" style="font-size:0.75rem; font-weight:bold;">Carcass</span></td>
                        <td>I-95 South Exit 12</td>
                        <td><span class="badge" style="background:#fef08a; color:#854d0e;">ASSIGNED</span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/staff/update-task" method="POST" style="margin: 0;">
                                <input type="hidden" name="reportId" value="845">
                                <button type="submit" class="btn btn-primary" style="padding:0.5rem 1rem; width:auto; font-size:0.8rem; background-color: #ca8a04;">Mark Removed</button>
                            </form>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>