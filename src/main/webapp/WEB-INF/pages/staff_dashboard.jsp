<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Dashboard</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-wrapper">
        
        <aside class="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless" class="brand-logo">
                <h1 class="title" style="font-size: 1rem;">Staff Dispatch</h1>
                <p style="font-size: 0.8rem; color: #a0b48e; margin-top: 2px;"><%= session.getAttribute("userName") %></p>
            </div>
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="switchStaffTab('overview', this)"><i data-lucide="clipboard-list"></i> All Incidents</a>
                <a href="#" class="nav-item" onclick="switchStaffTab('mapView', this)"><i data-lucide="map"></i> Heatmap</a>
            </nav>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i data-lucide="log-out"></i> Logout</a>
            </div>
        </aside>

        <main class="main-content">
            
            <% if("success".equals(request.getParameter("update"))) { %>
                <div class="alert alert-success"><i data-lucide="check-circle"></i> Task updated successfully!</div>
            <% } %>
            <% if("success".equals(request.getParameter("applied"))) { %>
                <div class="alert alert-success"><i data-lucide="check-circle"></i> You have been assigned to this incident!</div>
            <% } %>

            <!-- Stat Cards -->
            <div class="stat-cards">
                <div class="stat-card">
                    <div class="stat-icon bg-green"><i data-lucide="clipboard-list"></i></div>
                    <span class="stat-value">${totalReports != null ? totalReports : 0}</span>
                    <span class="stat-label">Total Incidents</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-amber"><i data-lucide="clock"></i></div>
                    <span class="stat-value">${pendingCount != null ? pendingCount : 0}</span>
                    <span class="stat-label">Pending</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-blue"><i data-lucide="user-check"></i></div>
                    <span class="stat-value">${assignedCount != null ? assignedCount : 0}</span>
                    <span class="stat-label">Assigned</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon bg-teal"><i data-lucide="check-circle"></i></div>
                    <span class="stat-value">${resolvedCount != null ? resolvedCount : 0}</span>
                    <span class="stat-label">Resolved</span>
                </div>
            </div>

            <!-- Overview Tab -->
            <div id="tab-overview" class="tab-content active">
                <div class="section-header">
                    <i data-lucide="clipboard-list"></i>
                    <h2>All Incidents</h2>
                </div>
                <p class="section-desc">View and apply to respond to incidents.</p>

                <div class="search-filter-bar">
                    <input type="text" id="staffSearchInput" placeholder="Search incidents..." onkeyup="filterStaffReports()">
                    <select id="staffFilterCategory" onchange="filterStaffReports()">
                        <option value="all">All Categories</option>
                        <option value="Carcass">Carcass</option>
                        <option value="Injured">Injured</option>
                        <option value="Wild Sighting">Wild Sighting</option>
                    </select>
                    <select id="staffFilterStatus" onchange="filterStaffReports()">
                        <option value="all">All Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="ASSIGNED">Assigned</option>
                        <option value="RESOLVED">Resolved</option>
                    </select>
                </div>

                <div class="incidents-container">
                    <div class="incidents-header"><i data-lucide="activity"></i> Reported Incidents</div>
                    <div class="incidents-grid" id="staffReportsGrid">
                        <c:forEach items="${allReports}" var="report">
                            <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}" data-category="${report.category}" data-status="${report.status}" data-search="${report.animalType} ${report.description} ${report.locationDesc}">
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
                                        <span class="badge badge-${report.status == 'PENDING' ? 'pending' : report.status == 'ASSIGNED' ? 'assigned' : 'resolved'}">${report.status}</span>
                                    </div>
                                    <c:if test="${report.locationDesc != null}">
                                        <div class="card-location"><i data-lucide="map-pin"></i> ${report.locationDesc}</div>
                                    </c:if>
                                    <c:if test="${report.photoPath != null}">
                                        <img src="${pageContext.request.contextPath}/${report.photoPath}" alt="Report photo" class="card-photo">
                                    </c:if>
                                    <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                        <c:if test="${report.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/staff/apply" method="POST" style="margin:0; flex:1;">
                                                <input type="hidden" name="reportId" value="${report.id}">
                                                <button type="submit" class="btn btn-primary btn-sm" style="width:100%; margin:0;"><i data-lucide="hand" style="width:14px;height:14px;"></i> Respond</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${report.status == 'ASSIGNED'}">
                                            <form action="${pageContext.request.contextPath}/staff/update-task" method="POST" style="margin:0; flex:1;">
                                                <input type="hidden" name="reportId" value="${report.id}">
                                                <button type="submit" class="btn btn-sm" style="width:100%; margin:0; background:#5a7a42; color:#fff; border:none; border-radius:10px; font-weight:700; cursor:pointer;"><i data-lucide="check" style="width:14px;height:14px;"></i> Resolve</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${report.status == 'RESOLVED'}">
                                            <span style="font-size: 0.8rem; color: #1e6f30; font-weight: 700; padding: 7px 0;">Completed</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty allReports}">
                            <div class="empty-state" style="grid-column: 1/-1;"><i data-lucide="inbox"></i><p>No incidents reported yet.</p></div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Heatmap Tab -->
            <div id="tab-mapView" class="tab-content">
                <div class="section-header"><i data-lucide="map"></i><h2>Incident Heatmap</h2></div>
                <p class="section-desc">Geographic overview of all incidents.</p>
                <div id="staffMap" class="map-container"></div>
            </div>

        </main>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    
    <script>
    var staffHeatmapPoints = [];
    var staffMap = null;
    <c:forEach items="${allReports}" var="report">
        <c:if test="${not empty report.latitude and not empty report.longitude}">
            staffHeatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
        </c:if>
    </c:forEach>

    function initStaffMap() {
        var mapEl = document.getElementById('staffMap');
        if (mapEl && !staffMap) {
            staffMap = L.map('staffMap', {zoomControl: true}).setView([27.6781, 85.3803], 11);
            L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
                attribution: '&copy; OpenStreetMap'
            }).addTo(staffMap);
            if (staffHeatmapPoints.length > 0) {
                L.heatLayer(staffHeatmapPoints, {
                    radius: 25, blur: 15, maxZoom: 15,
                    gradient: {0.4: '#3d6b35', 0.65: '#d4a647', 1: '#a63d40'}
                }).addTo(staffMap);
            }
        }
        if (staffMap) setTimeout(function() { staffMap.invalidateSize(); }, 150);
    }

    function switchStaffTab(tabName, el) {
        document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabName).classList.add('active');
        document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
        if (el) el.classList.add('active');
        if (typeof lucide !== 'undefined') lucide.createIcons();
        if (tabName === 'mapView') initStaffMap();
    }

    function filterStaffReports() {
        var keyword = document.getElementById('staffSearchInput').value.toLowerCase();
        var category = document.getElementById('staffFilterCategory').value;
        var status = document.getElementById('staffFilterStatus').value;
        document.querySelectorAll('#staffReportsGrid .report-card').forEach(function(card) {
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