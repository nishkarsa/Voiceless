<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Voiceless - Admin Console</title>
                <!-- Administrative View Dependencies -->
                <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
            </head>

            <body>
                <div class="dashboard-wrapper">

                    <!-- SIDEBAR: Management Navigation -->
                    <aside class="sidebar">
                        <div class="sidebar-brand">
                            <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless"
                                class="brand-logo">
                            <div class="sidebar-brand-text">
                                <h1>Voiceless</h1>
                                <span>Admin Console</span>
                            </div>
                        </div>

                        <nav class="sidebar-nav">
                            <a href="#" class="nav-item active" onclick="switchTab('reports', this)"><i
                                    data-lucide="file-text"></i> Reports</a>
                            <!-- Notifications for pending approvals -->
                            <a href="#" class="nav-item" onclick="switchTab('taskRequests', this)"><i
                                    data-lucide="git-pull-request"></i> Task Requests <c:if
                                    test="${requestedCount > 0}"><span class="badge badge-requested"
                                        style="font-size:0.6rem; padding:2px 6px; margin-left:4px;">${requestedCount}</span>
                                </c:if></a>
                            <a href="#" class="nav-item" onclick="switchTab('verifyCompletions', this)"><i
                                    data-lucide="check-square"></i> Verify <c:if test="${completedCount > 0}"><span
                                        class="badge badge-completed"
                                        style="font-size:0.6rem; padding:2px 6px; margin-left:4px;">${completedCount}</span>
                                </c:if></a>
                            <a href="#" class="nav-item" onclick="switchTab('users', this)"><i data-lucide="users"></i>
                                Users</a>
                            <a href="#" class="nav-item" onclick="switchTab('applications', this)"><i
                                    data-lucide="user-plus"></i> Applications <c:if test="${pendingApps > 0}"><span
                                        class="badge badge-pending"
                                        style="font-size:0.6rem; padding:2px 6px; margin-left:4px;">${pendingApps}</span>
                                </c:if></a>
                            <a href="#" class="nav-item" onclick="switchTab('supportMessages', this)"><i
                                    data-lucide="mail"></i> Support <c:if test="${supportCount > 0}"><span
                                        class="badge badge-blue"
                                        style="font-size:0.6rem; padding:2px 6px; margin-left:4px;">${supportCount}</span>
                                </c:if></a>
                            <a href="#" class="nav-item" onclick="switchTab('history', this)"><i
                                    data-lucide="archive"></i> History</a>
                        </nav>

                        <div class="sidebar-footer">
                            <a href="#" class="footer-nav-item" onclick="openSettingsModal()"><i
                                    data-lucide="settings"></i> Settings</a>
                            <a href="#" class="footer-nav-item" onclick="switchTab('supportMessages', null)"><i
                                    data-lucide="help-circle"></i> Support</a>
                            <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i
                                    data-lucide="log-out"></i> Logout</a>
                        </div>
                    </aside>

                    <div class="main-content-wrapper">
                        <!-- Global Admin Top Bar -->
                        <div class="top-bar">
                            <div class="top-bar-search">
                                <i data-lucide="search"></i>
                                <input type="text" id="adminSearchInput" placeholder="Search reports, animals..."
                                    onkeyup="filterAdminReports()">
                            </div>
                            <div class="top-bar-right">
                                <div class="top-bar-icon"><i data-lucide="bell"></i></div>
                                <div class="profile-section">
                                    <div class="top-bar-icon" style="border:none;"><i data-lucide="user"></i></div>
                                    <span class="profile-name">Admin</span>
                                </div>
                            </div>
                        </div>

                        <main class="main-content admin-content">

                            <!-- System-wide statistics -->
                            <div class="stat-cards">
                                <div class="stat-card">
                                    <div class="stat-icon bg-green"><i data-lucide="clipboard-list"></i></div>
                                    <span class="stat-label">Total Reports</span>
                                    <span class="stat-value">${totalReports != null ? totalReports : 0}</span>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon bg-amber"><i data-lucide="clock"></i></div>
                                    <span class="stat-label">Pending</span>
                                    <span class="stat-value">${pendingCount != null ? pendingCount : 0}</span>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon bg-purple"><i data-lucide="git-pull-request"></i></div>
                                    <span class="stat-label">Requests</span>
                                    <span class="stat-value">${requestedCount != null ? requestedCount : 0}</span>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon bg-blue"><i data-lucide="users"></i></div>
                                    <span class="stat-label">Total Users</span>
                                    <span class="stat-value">${totalUsers != null ? totalUsers : 0}</span>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon bg-teal"><i data-lucide="shield"></i></div>
                                    <span class="stat-label">Staff</span>
                                    <span class="stat-value">${staffCount != null ? staffCount : 0}</span>
                                </div>
                            </div>

                            <!-- ===== TAB 1: REPORTS (System Overview) ===== -->
                            <div id="tab-reports" class="tab-content active">
                                <div class="section-header"><i data-lucide="file-text"></i>
                                    <h2>Incident Reports</h2>
                                </div>

                                <!-- Integrated Admin Map -->
                                <div id="adminMap" class="map-container" style="margin: 12px 0;"></div>

                                <div class="search-filter-bar" style="margin-bottom: 14px;">
                                    <input type="text" id="adminSearchInline" placeholder="Search reports..."
                                        onkeyup="filterAdminReports()">
                                    <select id="adminFilterCategory" onchange="filterAdminReports()">
                                        <option value="all">All Categories</option>
                                        <option value="Carcass">Carcass</option>
                                        <option value="Injured">Injured</option>
                                        <option value="Wild Sighting">Wild Sighting</option>
                                    </select>
                                    <select id="adminFilterStatus" onchange="filterAdminReports()">
                                        <option value="all">All Status</option>
                                        <option value="PENDING">Pending</option>
                                        <option value="REQUESTED">Requested</option>
                                        <option value="ASSIGNED">Assigned</option>
                                        <option value="COMPLETED">Completed</option>
                                        <option value="RESOLVED">Resolved</option>
                                    </select>
                                </div>

                                <div class="incidents-grid" id="adminReportsGrid">
                                    <!-- Administrative Incident Control Cards -->
                                    <c:forEach items="${allReports}" var="report">
                                        <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}"
                                            data-category="${report.category}" data-status="${report.status}"
                                            data-search="${report.animalType} ${report.description} ${report.locationDesc} ${report.reporterName}">
                                            <div
                                                class="card-icon icon-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}">
                                                <c:choose>
                                                    <c:when test="${report.category == 'Carcass'}"><i
                                                            data-lucide="heart-off"></i></c:when>
                                                    <c:when test="${report.category == 'Injured'}"><i
                                                            data-lucide="alert-triangle"></i></c:when>
                                                    <c:otherwise><i data-lucide="eye"></i></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="card-body">
                                                <div class="card-title">${report.animalType}</div>
                                                <div class="card-meta">
                                                    <span
                                                        class="badge badge-${report.category == 'Carcass' ? 'user' : report.category == 'Injured' ? 'red' : 'pending'}">${report.category}</span>
                                                    <span
                                                        class="badge badge-${report.status == 'PENDING' ? 'pending' : report.status == 'REQUESTED' ? 'requested' : report.status == 'ASSIGNED' ? 'assigned' : report.status == 'COMPLETED' ? 'completed' : 'resolved'}">${report.status}</span>
                                                </div>
                                                <c:if test="${report.locationDesc != null}">
                                                    <div class="card-location"><i data-lucide="map-pin"></i>
                                                        ${report.locationDesc}</div>
                                                </c:if>
                                                <c:if test="${report.photoPath != null}">
                                                    <img src="${pageContext.request.contextPath}/${report.photoPath}"
                                                        alt="Report photo" class="card-photo">
                                                </c:if>

                                                <!-- Direct Status Override -->
                                                <form action="${pageContext.request.contextPath}/admin/report/action"
                                                    method="POST" class="card-actions" style="margin: 0 0 6px 0;">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="reportId" value="${report.id}">
                                                    <select name="status" class="status-select">
                                                        <option value="PENDING" ${report.status=='PENDING' ? 'selected'
                                                            : '' }>Pending</option>
                                                        <option value="REQUESTED" ${report.status=='REQUESTED'
                                                            ? 'selected' : '' }>Requested</option>
                                                        <option value="ASSIGNED" ${report.status=='ASSIGNED'
                                                            ? 'selected' : '' }>Assigned</option>
                                                        <option value="COMPLETED" ${report.status=='COMPLETED'
                                                            ? 'selected' : '' }>Completed</option>
                                                        <option value="RESOLVED" ${report.status=='RESOLVED'
                                                            ? 'selected' : '' }>Resolved</option>
                                                    </select>
                                                    <button type="submit" class="btn btn-primary btn-sm"
                                                        style="margin:0;"><i data-lucide="save"
                                                            style="width:13px;height:13px;"></i> Save</button>
                                                </form>

                                                <!-- Force Assign Staff -->
                                                <c:if test="${report.status == 'PENDING'}">
                                                    <div class="card-actions" style="margin:0 0 6px 0; gap:4px;">
                                                        <select id="forceStaff-${report.id}" class="status-select"
                                                            style="flex:1;">
                                                            <option value="">Select Staff</option>
                                                            <c:forEach items="${staffUsers}" var="s">
                                                                <option value="${s.id}">${s.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="button" class="btn btn-approve btn-sm"
                                                            style="margin:0;"
                                                            onclick="adminForceAssign('${pageContext.request.contextPath}',${report.id})"><i
                                                                data-lucide="user-plus"
                                                                style="width:13px;height:13px;"></i> Assign</button>
                                                    </div>
                                                </c:if>

                                                <!-- Archive/Delete -->
                                                <form action="${pageContext.request.contextPath}/admin/report/action"
                                                    method="POST" style="margin: 0;"
                                                    onsubmit="return confirm('Delete this report?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="reportId" value="${report.id}">
                                                    <input type="hidden" name="reason"
                                                        value="Misleading or unverifiable">
                                                    <button type="submit" class="btn btn-danger btn-sm"
                                                        style="width:100%; margin:0;"><i data-lucide="trash-2"
                                                            style="width:13px;height:13px;"></i> Delete</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ===== TAB 2: TASK REQUESTS (Staff Management) ===== -->
                            <div id="tab-taskRequests" class="tab-content">
                                <div class="section-header"><i data-lucide="git-pull-request"></i>
                                    <h2>Task Assignment Requests</h2>
                                </div>
                                <p class="section-desc">Staff have requested to be assigned to these incidents. Approve
                                    or reject.</p>
                                <div style="margin-top: 14px;">
                                    <c:forEach items="${taskRequests}" var="report">
                                        <div class="task-request-card">
                                            <div class="app-info">
                                                <div class="app-name">${report.animalType} — ${report.category}</div>
                                                <div class="app-meta">
                                                    <c:if test="${report.locationDesc != null}"><i data-lucide="map-pin"
                                                            style="width:12px;height:12px;display:inline;"></i>
                                                        ${report.locationDesc} &middot; </c:if>
                                                    Staff ID: #${report.assignedStaffId} &middot;
                                                    <span class="badge badge-requested">REQUESTED</span>
                                                </div>
                                            </div>
                                            <div class="card-actions" id="taskReq-actions-${report.id}">
                                                <button type="button" class="btn btn-approve btn-sm" style="margin:0;"
                                                    onclick="adminTaskAction('${pageContext.request.contextPath}',${report.id},'approve',this)"><i
                                                        data-lucide="check" style="width:13px;height:13px;"></i>
                                                    Approve</button>
                                                <button type="button" class="btn btn-reject btn-sm" style="margin:0;"
                                                    onclick="adminTaskAction('${pageContext.request.contextPath}',${report.id},'reject',this)"><i
                                                        data-lucide="x" style="width:13px;height:13px;"></i>
                                                    Reject</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ===== TAB 3: VERIFY COMPLETIONS (Quality Control) ===== -->
                            <div id="tab-verifyCompletions" class="tab-content">
                                <div class="section-header"><i data-lucide="check-square"></i>
                                    <h2>Verify Completion Reports</h2>
                                </div>
                                <p class="section-desc">Staff have submitted completion reports. Verify or send back.
                                </p>
                                <div style="margin-top: 14px;">
                                    <c:forEach items="${completionReports}" var="report">
                                        <div class="task-request-card"
                                            style="border-left-color: var(--color-info, #1976d2);">
                                            <div class="app-info">
                                                <div class="app-name">${report.animalType} — ${report.category}</div>
                                                <div class="app-meta">
                                                    <c:if test="${report.locationDesc != null}"><i data-lucide="map-pin"
                                                            style="width:12px;height:12px;display:inline;"></i>
                                                        ${report.locationDesc} &middot; </c:if>
                                                    Staff ID: #${report.assignedStaffId} &middot;
                                                    <span class="badge badge-completed">COMPLETED</span>
                                                </div>
                                            </div>
                                            <div class="card-actions" id="compReq-actions-${report.id}">
                                                <button type="button" class="btn btn-approve btn-sm" style="margin:0;"
                                                    onclick="adminTaskAction('${pageContext.request.contextPath}',${report.id},'verify',this)"><i
                                                        data-lucide="check-circle" style="width:13px;height:13px;"></i>
                                                    Verify</button>
                                                <button type="button" class="btn btn-reject btn-sm" style="margin:0;"
                                                    onclick="adminTaskAction('${pageContext.request.contextPath}',${report.id},'rejectCompletion',this)"><i
                                                        data-lucide="rotate-ccw" style="width:13px;height:13px;"></i>
                                                    Send Back</button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ===== TAB 4: USERS (Permission Management) ===== -->
                            <div id="tab-users" class="tab-content">
                                <div class="section-header"><i data-lucide="users"></i>
                                    <h2>User Management</h2>
                                </div>
                                <div style="margin-top: 14px;">
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${allUsers}" var="user">
                                                <tr>
                                                    <td style="font-family: monospace; color: var(--color-text-muted);">
                                                        #${user.id}</td>
                                                    <td>
                                                        <div style="display:flex; align-items:center; gap:8px;">
                                                            <c:if
                                                                test="${user.profileImage != null && !user.profileImage.isEmpty()}">
                                                                <img src="${pageContext.request.contextPath}/${user.profileImage}"
                                                                    onerror="this.style.display='none';"
                                                                    style="width:28px; height:28px; border-radius:50%; object-fit:cover;"
                                                                    alt="User Avatar">
                                                            </c:if>
                                                            <strong>${user.name}</strong>
                                                        </div>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td><span
                                                            class="badge badge-${user.role == 'STAFF' ? 'staff' : 'user'}">${user.role}</span>
                                                    </td>
                                                    <td>
                                                        <div class="card-actions" style="display:flex; gap:8px;">
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/user/action"
                                                                method="POST"
                                                                style="margin:0; display:flex; gap:4px; align-items:center;">
                                                                <input type="hidden" name="action" value="changeRole">
                                                                <input type="hidden" name="userId" value="${user.id}">
                                                                <select name="role" class="status-select">
                                                                    <option value="USER" ${user.role=='USER'
                                                                        ? 'selected' : '' }>User</option>
                                                                    <option value="STAFF" ${user.role=='STAFF'
                                                                        ? 'selected' : '' }>Staff</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-primary btn-sm"
                                                                    style="margin:0;">Save</button>
                                                            </form>
                                                            <form
                                                                action="${pageContext.request.contextPath}/admin/user/action"
                                                                method="POST" style="margin:0;"
                                                                onsubmit="return confirm('Delete this user?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="userId" value="${user.id}">
                                                                <input type="hidden" name="reason"
                                                                    value="Admin manual deletion">
                                                                <button type="submit" class="btn btn-danger btn-sm"
                                                                    style="margin:0;"><i data-lucide="trash-2"
                                                                        style="width:14px;height:14px;"></i></button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- ===== TAB 5: APPLICATIONS (Staff Intake) ===== -->
                            <div id="tab-applications" class="tab-content">
                                <div class="section-header"><i data-lucide="user-plus"></i>
                                    <h2>Staff / Helper Applications</h2>
                                </div>
                                <div style="margin-top: 14px;">
                                    <c:forEach items="${applications}" var="app">
                                        <div class="app-card">
                                            <div class="app-info">
                                                <div class="app-name">${app.userName}</div>
                                                <div class="app-meta">${app.userEmail} &middot; Role:
                                                    <strong>${app.requestedRole}</strong> &middot; <span
                                                        class="badge badge-${app.status == 'PENDING' ? 'pending' : app.status == 'APPROVED' ? 'green' : 'red'}">${app.status}</span>
                                                </div>
                                            </div>
                                            <c:if test="${app.status == 'PENDING'}">
                                                <div class="app-actions">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/application/action"
                                                        method="POST" style="margin:0;">
                                                        <input type="hidden" name="appId" value="${app.id}">
                                                        <input type="hidden" name="action" value="approve">
                                                        <button type="submit" class="btn btn-approve btn-sm"
                                                            style="margin:0;"><i data-lucide="check"
                                                                style="width:13px;height:13px;"></i> Approve</button>
                                                    </form>
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/application/action"
                                                        method="POST" style="margin:0;">
                                                        <input type="hidden" name="appId" value="${app.id}">
                                                        <input type="hidden" name="action" value="reject">
                                                        <button type="submit" class="btn btn-danger btn-sm"
                                                            style="margin:0;"><i data-lucide="x"
                                                                style="width:13px;height:13px;"></i> Reject</button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ===== TAB 6: HISTORY (Audit Log) ===== -->
                            <div id="tab-history" class="tab-content">
                                <div class="section-header"><i data-lucide="archive"></i>
                                    <h2>Deletion History</h2>
                                </div>
                                <div style="margin-top: 14px;">
                                    <c:forEach items="${deletionHistory}" var="item">
                                        <div class="history-card"
                                            style="display:flex; justify-content:space-between; align-items:center;">
                                            <div style="display:flex; gap:12px; width:100%;">
                                                <div class="history-icon"><i
                                                        data-lucide="${item.entityType == 'REPORT' ? 'file-x' : item.entityType == 'SUPPORT' ? 'mail-x' : 'user-x'}"></i>
                                                </div>
                                                <div class="history-body" style="flex:1;">
                                                    <div class="history-title">${item.entityType} #${item.entityId} —
                                                        Deleted</div>
                                                    <div class="history-meta">By: ${item.deletedBy} &middot;
                                                        <fmt:formatDate value="${item.deletedAt}"
                                                            pattern="MMM dd, HH:mm" />
                                                    </div>
                                                    <details style="margin-top: 6px;">
                                                        <summary
                                                            style="font-size: 0.78rem; color: var(--color-primary); cursor: pointer;">
                                                            View Archive</summary>
                                                        <pre
                                                            style="background: var(--color-bg-light); padding: 10px; font-size: 0.78rem;">${item.entityData}</pre>
                                                    </details>
                                                </div>
                                                <div style="display:flex; align-items:center;">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/restore/action"
                                                        method="POST" style="margin:0;"
                                                        onsubmit="return confirm('Restore this record?');">
                                                        <input type="hidden" name="historyId" value="${item.id}">
                                                        <button type="submit" class="btn btn-primary btn-sm"
                                                            style="margin:0;"><i data-lucide="rotate-ccw"
                                                                style="width:14px;height:14px;"></i> Restore</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ===== TAB 7: SUPPORT (Communication) ===== -->
                            <div id="tab-supportMessages" class="tab-content">
                                <div class="section-header"><i data-lucide="mail"></i>
                                    <h2>Support Messages</h2>
                                </div>
                                <div style="margin-top:14px;">
                                    <c:forEach items="${supportMessages}" var="msg">
                                        <div class="support-msg-card"
                                            style="display:flex; gap:12px; align-items:flex-start;">
                                            <div class="support-msg-icon"><i data-lucide="mail"></i></div>
                                            <div class="support-msg-body" style="flex:1;">
                                                <div class="support-msg-subject">${msg.subject}</div>
                                                <div class="support-msg-meta">${msg.userName} &middot; ${msg.userEmail}
                                                </div>
                                                <div class="support-msg-text">${msg.message}</div>
                                            </div>
                                            <div class="support-msg-actions">
                                                <form action="${pageContext.request.contextPath}/admin/support/action"
                                                    method="POST" style="margin:0;"
                                                    onsubmit="return confirm('Delete this support message?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="msgId" value="${msg.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm"
                                                        style="margin:0;"><i data-lucide="trash-2"
                                                            style="width:14px;height:14px;"></i></button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                        </main>
                    </div>
                </div>

                <!-- SETTINGS MODAL -->
                <div id="settingsModal" class="modal-backdrop hidden">
                    <div class="modal-content" style="max-width:420px;">
                        <h2 style="color:var(--color-text-dark);font-size:1.25rem;margin-bottom:6px;">Settings</h2>
                        <p style="color:var(--color-text-muted);font-size:0.88rem;margin-bottom:16px;">Customize your
                            console experience.</p>
                        <div class="settings-section">
                            <div class="settings-section-title">Appearance</div>
                            <div class="theme-toggle-row">
                                <span class="theme-toggle-label"><i data-lucide="sun"></i> Light Mode</span>
                                <label class="toggle-switch"><input type="checkbox" id="themeToggleCheckbox"
                                        onchange="toggleTheme()"><span class="toggle-slider"></span></label>
                            </div>
                        </div>
                        <div class="modal-actions" style="margin-top:20px;"><button type="button"
                                onclick="closeSettingsModal()" class="modal-submit-btn"
                                style="flex:none;width:100%;">Done</button></div>
                    </div>
                </div>

                <!-- Administrative Scripts -->
                <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
                <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
                <script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>

                <script>
                    // System Data for Map
                    var adminHeatmapPoints = [];
                    var adminMapEvents = [];
                    <c:forEach items="${allReports}" var="report">
                        <c:if test="${not empty report.latitude and not empty report.longitude}">
                            adminHeatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
                            adminMapEvents.push({
                                id: ${report.id}, lat: ${report.latitude}, lng: ${report.longitude},
                            title: "${report.animalType.replace('\"', '\\\"')}",
                            category: "${report.category}", status: "${report.status}"
            });
                        </c:if>
                    </c:forEach>

                    var adminMap = null;
                    /**
                     * Initializes the administrative overview map.
                     */
                    function initAdminMap() {
                        var mapEl = document.getElementById('adminMap');
                        if (mapEl && !adminMap) {
                            adminMap = L.map('adminMap', { zoomControl: true }).setView([27.6781, 85.3803], 11);
                            L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
                                attribution: '&copy; OpenStreetMap'
                            }).addTo(adminMap);
                            if (adminHeatmapPoints.length > 0) {
                                L.heatLayer(adminHeatmapPoints, {
                                    radius: 25, blur: 15, maxZoom: 15,
                                    gradient: { 0.4: '#1a5c3a', 0.65: '#e6a817', 1: '#d32f2f' }
                                }).addTo(adminMap);
                            }
                            if (adminMapEvents.length > 0) {
                                adminMapEvents.forEach(function (evt) {
                                    L.circleMarker([evt.lat, evt.lng], { radius: 20, opacity: 0, fillOpacity: 0 })
                                        .addTo(adminMap)
                                        .bindTooltip("<div style='font-family:var(--font-main);text-align:center;'><b>" + evt.title + "</b><br><span style='font-size:0.8rem;color:#6b7c66;'>" + evt.category + " &middot; " + evt.status + "</span></div>", { direction: 'top', offset: [0, -10] });
                                });
                            }
                        }
                        if (adminMap) setTimeout(function () { adminMap.invalidateSize(); }, 200);
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                        initAdminMap();
                    });

                    /**
                     * Tab navigation for the Admin Console.
                     */
                    function switchTab(tabName, el) {
                        document.querySelectorAll('.tab-content').forEach(function (t) { t.classList.remove('active'); });
                        document.getElementById('tab-' + tabName).classList.add('active');
                        document.querySelectorAll('.sidebar-nav .nav-item').forEach(function (n) { n.classList.remove('active'); });
                        if (el) el.classList.add('active');
                        if (typeof lucide !== 'undefined') lucide.createIcons();
                        if (tabName === 'reports') setTimeout(function () { initAdminMap(); }, 100);
                    }

                    /**
                     * Real-time filtering for incident grid.
                     */
                    function filterAdminReports() {
                        var keyword = (document.getElementById('adminSearchInput').value + ' ' + (document.getElementById('adminSearchInline') ? document.getElementById('adminSearchInline').value : '')).toLowerCase().trim();
                        var category = document.getElementById('adminFilterCategory').value;
                        var status = document.getElementById('adminFilterStatus').value;
                        document.querySelectorAll('#adminReportsGrid .report-card').forEach(function (card) {
                            var show = true;
                            if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
                            if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
                            if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
                            card.style.display = show ? '' : 'none';
                        });
                    }

                    /**
                     * Executes administrative task actions (Approve/Verify etc) via AJAX.
                     */
                    function adminTaskAction(ctx, reportId, action, btn) {
                        performAction(ctx + '/admin/task/action', { reportId: reportId, action: action }, function (data) {
                            if (data.success) {
                                var msgs = { approve: 'Assignment approved!', reject: 'Request rejected.', verify: 'Completion verified!', rejectCompletion: 'Sent back to staff.' };
                                showToast(msgs[action] || 'Done!', 'success');
                                var card = btn.closest('.task-request-card');
                                if (card) { card.style.opacity = '0.4'; card.style.pointerEvents = 'none'; }
                            } else { showToast('Action failed.', 'error'); }
                        });
                    }

                    /**
                     * Manually assigns a staff member to an incident.
                     */
                    function adminForceAssign(ctx, reportId) {
                        var sel = document.getElementById('forceStaff-' + reportId);
                        if (!sel || !sel.value) { showToast('Please select a staff member.', 'error'); return; }
                        performAction(ctx + '/admin/task/action', { reportId: reportId, action: 'forceAssign', staffId: sel.value }, function (data) {
                            if (data.success) { showToast('Staff force-assigned!', 'success'); setTimeout(function () { location.reload(); }, 800); }
                            else { showToast('Failed to assign.', 'error'); }
                        });
                    }
                </script>
                <script src="https://unpkg.com/lucide@latest"></script>
                <script>lucide.createIcons();</script>
            </body>

            </html>