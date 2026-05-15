<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Staff Dashboard</title>
    <!-- Dependencies -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
</head>
<body>
    <div class="dashboard-wrapper">
        
        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="sidebar-brand">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless" class="brand-logo">
                <div class="sidebar-brand-text">
                    <h1>Voiceless</h1>
                    <span>Staff Dashboard</span>
                </div>
            </div>

            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="switchStaffTab('myTasks', this)"><i data-lucide="layout-dashboard"></i> Dashboard</a>
                <a href="#" class="nav-item" onclick="switchStaffTab('overview', this)"><i data-lucide="clipboard-list"></i> All Incidents</a>
                <a href="#" class="nav-item" onclick="switchStaffTab('mapView', this)"><i data-lucide="map"></i> Map View</a>
            </nav>

            <div class="sidebar-footer">
                <a href="#" class="footer-nav-item" onclick="openSettingsModal()"><i data-lucide="settings"></i> Settings</a>
                <a href="#" class="footer-nav-item" onclick="openSupportModal()"><i data-lucide="help-circle"></i> Support</a>
                <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i data-lucide="log-out"></i> Logout</a>
            </div>
        </aside>

        <!-- MAIN CONTENT AREA -->
        <div class="main-content-wrapper">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="top-bar-search">
                    <i data-lucide="search"></i>
                    <input type="text" id="staffSearchInput" placeholder="Search reports, animals, or locations..." onkeyup="filterStaffReports()">
                </div>
                <div class="top-bar-right">
                    <div class="top-bar-icon"><i data-lucide="bell"></i></div>
                    <div class="profile-section">
                        <% String staffProfileImg = (String) session.getAttribute("userProfileImage"); %>
                        <% if (staffProfileImg != null && !staffProfileImg.isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/<%= staffProfileImg %>" alt="Profile" class="profile-avatar">
                        <% } else { %>
                            <div class="top-bar-icon" style="border:none;"><i data-lucide="user"></i></div>
                        <% } %>
                        <span class="profile-name"><%= session.getAttribute("userName") %></span>
                    </div>
                </div>
            </div>

            <main class="main-content">
                
                <!-- Operation Feedback Banners -->
                <% if("success".equals(request.getParameter("update"))) { %>
                    <div class="alert alert-success"><i data-lucide="check-circle"></i> Completion report submitted! Awaiting admin verification.</div>
                <% } %>
                <% if("success".equals(request.getParameter("applied"))) { %>
                    <div class="alert alert-success"><i data-lucide="check-circle"></i> Assignment request sent! Awaiting admin approval.</div>
                <% } %>
                <% if("already".equals(request.getParameter("applied"))) { %>
                    <div class="alert alert-warning"><i data-lucide="info"></i> This incident is no longer available for assignment.</div>
                <% } %>

                <!-- Dashboard Statistics -->
                <div class="stat-cards">
                    <div class="stat-card">
                        <div class="stat-icon bg-green"><i data-lucide="clipboard-list"></i></div>
                        <span class="stat-label">Total Incidents</span>
                        <span class="stat-value">${totalReports != null ? totalReports : 0}</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-amber"><i data-lucide="clock"></i></div>
                        <span class="stat-label">Pending</span>
                        <span class="stat-value">${pendingCount != null ? pendingCount : 0}</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-blue"><i data-lucide="user-check"></i></div>
                        <span class="stat-label">Assigned</span>
                        <span class="stat-value">${assignedCount != null ? assignedCount : 0}</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-teal"><i data-lucide="check-circle"></i></div>
                        <span class="stat-label">Resolved</span>
                        <span class="stat-value">${resolvedCount != null ? resolvedCount : 0}</span>
                    </div>
                </div>

                <!-- ===== TAB 1: MY TASKS (Operational Work) ===== -->
                <div id="tab-myTasks" class="tab-content active">
                    <div class="section-header"><i data-lucide="briefcase"></i><h2>My Tasks</h2></div>
                    <p class="section-desc">Incidents assigned to you. Accept, deny, or submit completion.</p>

                    <div class="incidents-container" style="margin-top: 14px;">
                        <div class="incidents-header"><i data-lucide="briefcase"></i> Your Assignments</div>
                        <div class="incidents-grid">
                            <!-- User-specific task loop -->
                            <c:forEach items="${myTasks}" var="task">
                                <div class="report-card cat-${task.category == 'Carcass' ? 'carcass' : task.category == 'Injured' ? 'injured' : 'wild'}" id="task-card-${task.id}">
                                    <div class="card-icon icon-${task.category == 'Carcass' ? 'carcass' : task.category == 'Injured' ? 'injured' : 'wild'}">
                                        <c:choose>
                                            <c:when test="${task.category == 'Carcass'}"><i data-lucide="heart-off"></i></c:when>
                                            <c:when test="${task.category == 'Injured'}"><i data-lucide="alert-triangle"></i></c:when>
                                            <c:otherwise><i data-lucide="eye"></i></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="card-body">
                                        <div class="card-title">${task.animalType}</div>
                                        <div class="card-meta">
                                            <span class="badge badge-${task.category == 'Carcass' ? 'user' : task.category == 'Injured' ? 'red' : 'pending'}">${task.category}</span>
                                            <span class="badge badge-${task.status == 'REQUESTED' ? 'requested' : task.status == 'ASSIGNED' ? 'assigned' : task.status == 'COMPLETED' ? 'completed' : task.status == 'FORCE_ASSIGNED' ? 'force_assigned' : 'resolved'}" id="task-badge-${task.id}">${task.status}</span>
                                        </div>
                                        <c:if test="${task.locationDesc != null}">
                                            <div class="card-location"><i data-lucide="map-pin"></i> ${task.locationDesc}</div>
                                        </c:if>
                                        <c:if test="${task.photoPath != null}">
                                            <img src="${pageContext.request.contextPath}/${task.photoPath}" alt="Task photo" class="card-photo">
                                        </c:if>
                                        <!-- Inline Action Controls (handled via AJAX in script.js) -->
                                        <div class="card-actions" id="task-actions-${task.id}">
                                            <c:if test="${task.status == 'REQUESTED'}">
                                                <span style="font-size: 0.8rem; color: #6a1b9a; font-weight: 700; padding: 7px 0;">Awaiting Admin Approval</span>
                                            </c:if>
                                            <c:if test="${task.status == 'FORCE_ASSIGNED'}">
                                                <button type="button" class="btn btn-approve btn-sm" style="flex:1; margin:0;" onclick="staffTaskAction('${pageContext.request.contextPath}', ${task.id}, 'acceptAssignment')"><i data-lucide="check" style="width:14px;height:14px;"></i> Accept</button>
                                                <button type="button" class="btn btn-reject btn-sm" style="flex:1; margin:0;" onclick="staffTaskAction('${pageContext.request.contextPath}', ${task.id}, 'denyAssignment')"><i data-lucide="x" style="width:14px;height:14px;"></i> Deny</button>
                                            </c:if>
                                            <c:if test="${task.status == 'ASSIGNED'}">
                                                <button type="button" class="btn btn-approve btn-sm" style="width:100%; margin:0;" onclick="staffTaskAction('${pageContext.request.contextPath}', ${task.id}, 'complete')"><i data-lucide="check" style="width:14px;height:14px;"></i> Submit Completion</button>
                                            </c:if>
                                            <c:if test="${task.status == 'COMPLETED'}">
                                                <span style="font-size: 0.8rem; color: var(--color-info, #1976d2); font-weight: 700; padding: 7px 0;">Awaiting Verification</span>
                                            </c:if>
                                            <c:if test="${task.status == 'RESOLVED'}">
                                                <span style="font-size: 0.8rem; color: var(--color-primary); font-weight: 700; padding: 7px 0;">&#10003; Verified & Resolved</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- ===== TAB 2: ALL INCIDENTS (Open Market) ===== -->
                <div id="tab-overview" class="tab-content">
                    <div class="section-header"><i data-lucide="clipboard-list"></i><h2>All Incidents</h2></div>
                    <p class="section-desc">Request to respond to pending incidents.</p>

                    <!-- Filter Bar for open reports -->
                    <div class="search-filter-bar">
                        <input type="text" placeholder="Filter incidents..." onkeyup="filterStaffReports()" id="staffSearchInline">
                        <select id="staffFilterCategory" onchange="filterStaffReports()">
                            <option value="all">All Categories</option>
                            <option value="Carcass">Carcass</option>
                            <option value="Injured">Injured</option>
                            <option value="Wild Sighting">Wild Sighting</option>
                        </select>
                        <select id="staffFilterStatus" onchange="filterStaffReports()">
                            <option value="all">All Status</option>
                            <option value="PENDING">Pending</option>
                            <option value="REQUESTED">Requested</option>
                            <option value="ASSIGNED">Assigned</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="RESOLVED">Resolved</option>
                        </select>
                    </div>

                    <div class="incidents-container">
                        <div class="incidents-header"><i data-lucide="activity"></i> Reported Incidents</div>
                        <div class="incidents-grid" id="staffReportsGrid">
                            <c:forEach items="${allReports}" var="report">
                                <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}" data-category="${report.category}" data-status="${report.status}" data-search="${report.animalType} ${report.description} ${report.locationDesc}" id="staff-report-${report.id}">
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
                                            <span class="badge badge-${report.status == 'PENDING' ? 'pending' : report.status == 'REQUESTED' ? 'requested' : report.status == 'ASSIGNED' ? 'assigned' : report.status == 'COMPLETED' ? 'completed' : report.status == 'FORCE_ASSIGNED' ? 'force_assigned' : 'resolved'}" id="staff-badge-${report.id}">${report.status}</span>
                                            <c:if test="${report.reporterName != null}">
                                                <span style="font-size:0.72rem;color:var(--color-text-muted);">by ${report.reporterName}</span>
                                            </c:if>
                                        </div>
                                        <c:if test="${report.locationDesc != null}">
                                            <div class="card-location"><i data-lucide="map-pin"></i> ${report.locationDesc}</div>
                                        </c:if>
                                        <c:if test="${report.photoPath != null}">
                                            <img src="${pageContext.request.contextPath}/${report.photoPath}" alt="Report photo" class="card-photo">
                                        </c:if>
                                        <div class="card-actions" id="staff-actions-${report.id}">
                                            <c:if test="${report.status == 'PENDING'}">
                                                <button type="button" class="btn btn-primary btn-sm" style="width:100%; margin:0;" onclick="staffApplyAction('${pageContext.request.contextPath}', ${report.id})"><i data-lucide="hand" style="width:14px;height:14px;"></i> Request Assignment</button>
                                            </c:if>
                                            <c:if test="${report.status == 'REQUESTED'}">
                                                <span style="font-size: 0.8rem; color: #6a1b9a; font-weight: 700; padding: 7px 0;">Awaiting Approval</span>
                                            </c:if>
                                            <c:if test="${report.status == 'RESOLVED'}">
                                                <span style="font-size: 0.8rem; color: var(--color-primary); font-weight: 700; padding: 7px 0;">&#10003; Resolved</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- ===== TAB 3: HEATMAP (Visual Map) ===== -->
                <div id="tab-mapView" class="tab-content full-page-map-container">
                    <div id="staffMap" class="map-container"></div>
                </div>

            </main>
        </div>
    </div>

    <!-- MODAL: CONTACT SUPPORT -->
    <div id="supportModal" class="modal-backdrop hidden">
        <div class="modal-content" style="max-width:660px;">
            <h2 style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Contact Support</h2>
            <p style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 16px;">Have a concern? Reach out to our admin team directly.</p>
            <div class="support-modal-body">
                <div class="support-video-col">
                    <video autoplay loop muted playsinline>
                        <source src="${pageContext.request.contextPath}/videos/side eye bear.mp4" type="video/mp4">
                    </video>
                </div>
                <div class="support-form-col">
                    <form id="supportForm" onsubmit="event.preventDefault(); submitSupportForm('${pageContext.request.contextPath}');">
                        <div class="form-group">
                            <label>Your Email</label>
                            <input type="email" name="email" class="form-control" placeholder="your@email.com">
                        </div>
                        <div class="form-group">
                            <label>Subject</label>
                            <input type="text" name="subject" class="form-control" placeholder="What's this about?" required>
                        </div>
                        <div class="form-group">
                            <label>Message</label>
                            <textarea name="message" class="form-control" rows="3" style="resize:vertical;" placeholder="Describe your concern..." required></textarea>
                        </div>
                        <div class="modal-actions">
                            <button type="button" onclick="closeSupportModal()" class="btn-cancel">Cancel</button>
                            <button type="submit" class="modal-submit-btn">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL: SETTINGS (Theme management) -->
    <div id="settingsModal" class="modal-backdrop hidden">
        <div class="modal-content" style="max-width:420px;">
            <h2 style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Settings</h2>
            <p style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 16px;">Customize your dashboard experience.</p>
            <div class="settings-section">
                <div class="settings-section-title">Appearance</div>
                <div class="theme-toggle-row">
                    <span class="theme-toggle-label"><i data-lucide="sun"></i> Light Mode</span>
                    <label class="toggle-switch">
                        <input type="checkbox" id="themeToggleCheckbox" onchange="toggleTheme()">
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </div>
            <div class="modal-actions" style="margin-top:20px;">
                <button type="button" onclick="closeSettingsModal()" class="modal-submit-btn" style="flex:none; width:100%;">Done</button>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
    
    <script>
    // Staff-specific data arrays for mapping
    var staffHeatmapPoints = [];
    var staffMapEvents = [];
    var staffMap = null;
    <c:forEach items="${allReports}" var="report">
        <c:if test="${not empty report.latitude and not empty report.longitude}">
            staffHeatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
            staffMapEvents.push({
                id: ${report.id},
                lat: ${report.latitude},
                lng: ${report.longitude},
                title: "${report.animalType.replace('\"', '\\\"')}",
                category: "${report.category}",
                status: "${report.status}"
            });
        </c:if>
    </c:forEach>

    /**
     * Lazy-initializes the staff map when the tab is clicked.
     */
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
                    gradient: {0.4: '#1a5c3a', 0.65: '#e6a817', 1: '#d32f2f'}
                }).addTo(staffMap);
            }
            if (staffMapEvents.length > 0) {
                staffMapEvents.forEach(function(evt) {
                    L.circleMarker([evt.lat, evt.lng], { radius: 20, opacity: 0, fillOpacity: 0 })
                     .addTo(staffMap)
                     .bindTooltip("<div style='font-family:var(--font-main);text-align:center;'><b>" + evt.title + "</b><br><span style='font-size:0.8rem;color:#6b7c66;'>" + evt.category + " &middot; " + evt.status + "</span></div>", {direction: 'top', offset: [0, -10]});
                });
            }
            // Auto-locate
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(pos) {
                    staffMap.setView([pos.coords.latitude, pos.coords.longitude], 13);
                    L.marker([pos.coords.latitude, pos.coords.longitude], {
                        icon: L.divIcon({
                            html: '<div style="width:14px;height:14px;border-radius:50%;background:#2d6a4f;border:3px solid #fff;box-shadow:0 0 8px rgba(45,106,79,0.5);"></div>',
                            className: '', iconSize: [14, 14]
                        })
                    }).addTo(staffMap).bindPopup('<strong>Your Location</strong>');
                });
            }
        }
        if (staffMap) setTimeout(function() { staffMap.invalidateSize(); }, 200);
    }

    /**
     * Tab switching for Staff Dashboard.
     */
    function switchStaffTab(tabName, el) {
        document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabName).classList.add('active');
        document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
        if (el) el.classList.add('active');
        if (typeof lucide !== 'undefined') lucide.createIcons();
        if (tabName === 'mapView') setTimeout(function() { initStaffMap(); }, 100);
    }

    /**
     * Local filtering for staff incidents grid.
     */
    function filterStaffReports() {
        var keyword = ((document.getElementById('staffSearchInput').value || '') + ' ' + (document.getElementById('staffSearchInline') ? document.getElementById('staffSearchInline').value : '')).toLowerCase().trim();
        var category = document.getElementById('staffFilterCategory') ? document.getElementById('staffFilterCategory').value : 'all';
        var status = document.getElementById('staffFilterStatus') ? document.getElementById('staffFilterStatus').value : 'all';
        document.querySelectorAll('#staffReportsGrid .report-card').forEach(function(card) {
            var show = true;
            if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
            if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
            if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
            card.style.display = show ? '' : 'none';
        });
    }

    /**
     * Submits a request to handle a specific incident via AJAX.
     */
    function staffApplyAction(ctx, reportId) {
        performAction(ctx + '/staff/apply', { reportId: reportId }, function(data) {
            if (data.success) {
                showToast('Assignment request sent! Awaiting admin approval.', 'success');
                var actionsEl = document.getElementById('staff-actions-' + reportId);
                if (actionsEl) actionsEl.innerHTML = '<span style="font-size:0.8rem;color:#6a1b9a;font-weight:700;padding:7px 0;">Awaiting Approval</span>';
                var badgeEl = document.getElementById('staff-badge-' + reportId);
                if (badgeEl) { badgeEl.textContent = 'REQUESTED'; badgeEl.className = 'badge badge-requested'; }
            } else {
                showToast('This incident is no longer available.', 'error');
            }
        });
    }

    /**
     * Submits task updates (Accept/Deny/Complete) via AJAX.
     */
    function staffTaskAction(ctx, reportId, action) {
        performAction(ctx + '/staff/update-task', { reportId: reportId, action: action }, function(data) {
            if (data.success) {
                var msgs = { complete: 'Completion submitted! Awaiting verification.', acceptAssignment: 'Assignment accepted!', denyAssignment: 'Assignment denied.' };
                showToast(msgs[action] || 'Action completed!', 'success');
                var actionsEl = document.getElementById('task-actions-' + reportId);
                var badgeEl = document.getElementById('task-badge-' + reportId);
                if (action === 'complete') {
                    if (actionsEl) actionsEl.innerHTML = '<span style="font-size:0.8rem;color:var(--color-info,#1976d2);font-weight:700;padding:7px 0;">Awaiting Verification</span>';
                    if (badgeEl) { badgeEl.textContent = 'COMPLETED'; badgeEl.className = 'badge badge-completed'; }
                } else if (action === 'acceptAssignment') {
                    if (actionsEl) actionsEl.innerHTML = '<button type="button" class="btn btn-approve btn-sm" style="width:100%;margin:0;" onclick="staffTaskAction(\'' + ctx + '\',' + reportId + ',\'complete\')"><i data-lucide="check" style="width:14px;height:14px;"></i> Submit Completion</button>';
                    if (badgeEl) { badgeEl.textContent = 'ASSIGNED'; badgeEl.className = 'badge badge-assigned'; }
                    if (typeof lucide !== 'undefined') lucide.createIcons();
                } else if (action === 'denyAssignment') {
                    var card = document.getElementById('task-card-' + reportId);
                    if (card) { card.style.opacity = '0.4'; card.style.pointerEvents = 'none'; }
                    if (actionsEl) actionsEl.innerHTML = '<span style="font-size:0.8rem;color:var(--color-text-muted);font-weight:700;padding:7px 0;">Denied</span>';
                }
            } else {
                showToast('Action failed. Please try again.', 'error');
            }
        });
    }
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script>lucide.createIcons();</script>
</body>
</html>