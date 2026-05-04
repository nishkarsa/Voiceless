<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Admin Console</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-wrapper">
        
        <aside class="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless" class="brand-logo">
                <h1 class="title" style="font-size: 1rem;">Admin Console</h1>
            </div>
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="switchTab('reports', this)"><i data-lucide="file-text"></i> Reports</a>
                <a href="#" class="nav-item" onclick="switchTab('users', this)"><i data-lucide="users"></i> Users</a>
                <a href="#" class="nav-item" onclick="switchTab('applications', this)"><i data-lucide="user-plus"></i> Applications <c:if test="${pendingApps > 0}"><span class="badge badge-red" style="font-size:0.6rem; padding:2px 6px; margin-left:4px;">${pendingApps}</span></c:if></a>
                <a href="#" class="nav-item" onclick="switchTab('history', this)"><i data-lucide="archive"></i> History</a>
            </nav>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i data-lucide="log-out"></i> Logout</a>
            </div>
        </aside>

        <main class="main-content admin-content">
            
            <div class="stat-cards">
                <div class="stat-card">
                    <div class="stat-icon bg-green"><i data-lucide="clipboard-list"></i></div>
                    <span class="stat-value">${totalReports != null ? totalReports : 0}</span>
                    <span class="stat-label">Total Reports</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-amber"><i data-lucide="clock"></i></div>
                    <span class="stat-value">${pendingCount != null ? pendingCount : 0}</span>
                    <span class="stat-label">Pending</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-blue"><i data-lucide="users"></i></div>
                    <span class="stat-value">${totalUsers != null ? totalUsers : 0}</span>
                    <span class="stat-label">Total Users</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-teal"><i data-lucide="shield"></i></div>
                    <span class="stat-value">${staffCount != null ? staffCount : 0}</span>
                    <span class="stat-label">Staff Members</span>
                </div>
            </div>

            <!-- ===== REPORTS TAB ===== -->
            <div id="tab-reports" class="tab-content active">
                <div class="section-header"><i data-lucide="file-text"></i><h2>Incident Reports</h2></div>
                
                <div id="adminMap" class="map-container" style="margin: 12px 0;"></div>

                <div class="search-filter-bar" style="margin-bottom: 14px;">
                    <input type="text" id="adminSearchInput" placeholder="Search reports..." onkeyup="filterAdminReports()">
                    <select id="adminFilterCategory" onchange="filterAdminReports()">
                        <option value="all">All Categories</option>
                        <option value="Carcass">Carcass</option>
                        <option value="Injured">Injured</option>
                        <option value="Wild Sighting">Wild Sighting</option>
                    </select>
                    <select id="adminFilterStatus" onchange="filterAdminReports()">
                        <option value="all">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="ASSIGNED">Assigned</option>
                        <option value="RESOLVED">Resolved</option>
                    </select>
                </div>

                <div class="incidents-grid" id="adminReportsGrid">
                    <c:forEach items="${allReports}" var="report">
                        <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}" data-category="${report.category}" data-status="${report.status}" data-search="${report.animalType} ${report.description} ${report.locationDesc} ${report.reporterName}">
                            <div class="card-icon icon-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}">
                                <c:choose>
                                    <c:when test="${report.category == 'Carcass'}"><i data-lucide="heart-off"></i></c:when>
                                    <c:when test="${report.category == 'Injured'}"><i data-lucide="alert-triangle"></i></c:when>
                                    <c:otherwise><i data-lucide="eye"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <div class="card-title">${report.animalType}</div>
                                <div class="card-meta">
                                    <span class="badge badge-${report.category == 'Carcass' ? 'user' : report.category == 'Injured' ? 'red' : 'pending'}">${report.category}</span>
                                    <c:if test="${report.reporterName != null}">
                                        <span style="font-size: 0.72rem; color: #6b7260;">by ${report.reporterName}</span>
                                    </c:if>
                                </div>
                                <c:if test="${report.locationDesc != null}">
                                    <div class="card-location"><i data-lucide="map-pin"></i> ${report.locationDesc}</div>
                                </c:if>
                                <c:if test="${report.photoPath != null}">
                                    <img src="${pageContext.request.contextPath}/${report.photoPath}" alt="Report photo" class="card-photo">
                                </c:if>
                                
                                <form action="${pageContext.request.contextPath}/admin/report/action" method="POST" style="margin: 0 0 6px 0;">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="reportId" value="${report.id}">
                                    <div style="display: flex; gap: 6px; align-items: center;">
                                        <select name="status" class="status-select">
                                            <option value="PENDING" ${report.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                            <option value="ASSIGNED" ${report.status == 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                                            <option value="RESOLVED" ${report.status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                                        </select>
                                        <button type="submit" class="btn btn-primary btn-sm" style="margin:0;"><i data-lucide="save" style="width:13px;height:13px;"></i> Save</button>
                                    </div>
                                </form>
                                
                                <form action="${pageContext.request.contextPath}/admin/report/action" method="POST" style="margin: 0;" onsubmit="return confirm('Delete this report? It will be saved in history.');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="reportId" value="${report.id}">
                                    <input type="hidden" name="reason" value="Misleading or unverifiable">
                                    <button type="submit" class="btn btn-danger btn-sm" style="width:100%; margin:0;"><i data-lucide="trash-2" style="width:13px;height:13px;"></i> Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty allReports}">
                        <div class="empty-state" style="grid-column:1/-1;"><i data-lucide="inbox"></i><p>No reports yet.</p></div>
                    </c:if>
                </div>
            </div>

            <!-- ===== USERS TAB ===== -->
            <div id="tab-users" class="tab-content">
                <div class="section-header"><i data-lucide="users"></i><h2>User Management</h2></div>
                <div style="margin-top: 14px;">
                <table class="data-table">
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${allUsers}" var="user">
                            <tr>
                                <td style="font-family: monospace; color: #6b7260;">#${user.id}</td>
                                <td>
                                    <div style="display:flex; align-items:center; gap:8px;">
                                        <c:if test="${user.profileImage != null}">
                                            <img src="${pageContext.request.contextPath}/${user.profileImage}" style="width:28px; height:28px; border-radius:50%; object-fit:cover;">
                                        </c:if>
                                        <strong>${user.name}</strong>
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td><span class="badge badge-${user.role == 'STAFF' ? 'staff' : 'user'}">${user.role}</span></td>
                                <td>
                                    <div style="display: flex; gap: 6px; flex-wrap: wrap; align-items: center;">
                                        <form action="${pageContext.request.contextPath}/admin/user/action" method="POST" style="margin:0; display:flex; gap:4px; align-items:center;">
                                            <input type="hidden" name="action" value="changeRole">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <select name="role" class="status-select" style="font-size:0.78rem;">
                                                <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>User</option>
                                                <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm" style="margin:0; padding:4px 10px; font-size:0.72rem;">Save</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/user/action" method="POST" style="margin:0;" onsubmit="return confirm('Delete this user?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <input type="hidden" name="reason" value="Inactive or misleading">
                                            <button type="submit" class="btn btn-danger btn-sm" style="margin:0; padding:4px 10px; font-size:0.72rem;"><i data-lucide="trash-2" style="width:12px;height:12px;"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                </div>
                <c:if test="${empty allUsers}">
                    <div class="empty-state"><i data-lucide="users"></i><p>No users found.</p></div>
                </c:if>
            </div>

            <!-- ===== APPLICATIONS TAB ===== -->
            <div id="tab-applications" class="tab-content">
                <div class="section-header"><i data-lucide="user-plus"></i><h2>Staff / Helper Applications</h2></div>
                <div style="margin-top: 14px;">
                <c:forEach items="${applications}" var="app">
                    <div class="app-card">
                        <div class="app-info">
                            <div class="app-name">${app.userName}</div>
                            <div class="app-meta">${app.userEmail} &middot; Applied for: <strong>${app.requestedRole}</strong> &middot; <span class="badge badge-${app.status == 'PENDING' ? 'pending' : app.status == 'APPROVED' ? 'green' : 'red'}">${app.status}</span></div>
                        </div>
                        <c:if test="${app.status == 'PENDING'}">
                            <div class="app-actions">
                                <form action="${pageContext.request.contextPath}/admin/application/action" method="POST" style="margin:0;">
                                    <input type="hidden" name="appId" value="${app.id}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-primary btn-sm" style="margin:0;"><i data-lucide="check" style="width:13px;height:13px;"></i> Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/application/action" method="POST" style="margin:0;">
                                    <input type="hidden" name="appId" value="${app.id}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-danger btn-sm" style="margin:0;"><i data-lucide="x" style="width:13px;height:13px;"></i> Reject</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
                </div>
                <c:if test="${empty applications}">
                    <div class="empty-state"><i data-lucide="user-plus"></i><p>No applications yet.</p></div>
                </c:if>
            </div>

            <!-- ===== HISTORY TAB ===== -->
            <div id="tab-history" class="tab-content">
                <div class="section-header"><i data-lucide="archive"></i><h2>Deletion History</h2></div>
                <div style="margin-top: 14px;">
                <c:forEach items="${deletionHistory}" var="item">
                    <div class="history-card">
                        <div class="history-icon">
                            <c:choose>
                                <c:when test="${item.entityType == 'REPORT'}"><i data-lucide="file-x"></i></c:when>
                                <c:otherwise><i data-lucide="user-x"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="history-body">
                            <div class="history-title">${item.entityType} #${item.entityId} — Deleted</div>
                            <div class="history-meta">
                                By: ${item.deletedBy} &middot; 
                                <fmt:formatDate value="${item.deletedAt}" pattern="MMM dd, yyyy HH:mm" />
                                <c:if test="${item.reason != null}"> &middot; Reason: ${item.reason}</c:if>
                            </div>
                            <details style="margin-top: 6px;">
                                <summary style="font-size: 0.78rem; color: #5a7a42; cursor: pointer; font-weight: 700;">View Archived Data</summary>
                                <pre style="background: #f4f1ea; padding: 10px; border-radius: 8px; font-size: 0.78rem; margin-top: 4px; white-space: pre-wrap; word-break: break-all;">${item.entityData}</pre>
                            </details>
                        </div>
                    </div>
                </c:forEach>
                </div>
                <c:if test="${empty deletionHistory}">
                    <div class="empty-state"><i data-lucide="archive"></i><p>No deletion history yet.</p></div>
                </c:if>
            </div>

        </main>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    
    <script>
    var adminHeatmapPoints = [];
    <c:forEach items="${allReports}" var="report">
        <c:if test="${not empty report.latitude and not empty report.longitude}">
            adminHeatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
        </c:if>
    </c:forEach>
    
    document.addEventListener("DOMContentLoaded", function() {
        var mapEl = document.getElementById('adminMap');
        if (mapEl) {
            var adminMap = L.map('adminMap', {zoomControl: true}).setView([27.6781, 85.3803], 11);
            L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
                attribution: '&copy; OpenStreetMap'
            }).addTo(adminMap);
            if (adminHeatmapPoints.length > 0) {
                L.heatLayer(adminHeatmapPoints, {
                    radius: 25, blur: 15, maxZoom: 15,
                    gradient: {0.4: '#3d6b35', 0.65: '#d4a647', 1: '#a63d40'}
                }).addTo(adminMap);
            }
            setTimeout(function() { adminMap.invalidateSize(); }, 300);
        }
    });

    function switchTab(tabName, el) {
        document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabName).classList.add('active');
        document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
        if (el) el.classList.add('active');
        if (typeof lucide !== 'undefined') lucide.createIcons();
    }

    function filterAdminReports() {
        var keyword = document.getElementById('adminSearchInput').value.toLowerCase();
        var category = document.getElementById('adminFilterCategory').value;
        var status = document.getElementById('adminFilterStatus').value;
        document.querySelectorAll('#adminReportsGrid .report-card').forEach(function(card) {
            var show = true;
            if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
            if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
            if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
            card.style.display = show ? '' : 'none';
        });
    }
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script>lucide.createIcons();</script>
</body>
</html>