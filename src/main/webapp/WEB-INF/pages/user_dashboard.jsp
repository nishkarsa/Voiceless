<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Voiceless - My Dashboard</title>
            <!-- Dependencies: Leaflet for Maps, Theme Stylesheet -->
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3">
        </head>

        <body>
            <div class="dashboard-wrapper">

                <!-- SIDEBAR NAVIGATION -->
                <aside class="sidebar">
                    <div class="sidebar-brand">
                        <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless"
                            class="brand-logo">
                        <div class="sidebar-brand-text">
                            <h1>Voiceless</h1>
                            <span>Be the voice</span>
                        </div>
                    </div>

                    <nav class="sidebar-nav">
                        <a href="#" class="nav-item active" onclick="switchUserTab('myReports', this)"><i
                                data-lucide="layout-dashboard"></i> Dashboard</a>
                        <a href="#" class="nav-item" onclick="switchUserTab('allReports', this)"><i
                                data-lucide="file-text"></i> All Reports</a>
                        <a href="#" class="nav-item" onclick="switchUserTab('heatmap', this)"><i data-lucide="map"></i>
                            Map View</a>
                    </nav>

                    <!-- Incident Shortcut Options -->
                    <div class="sidebar-report-options">
                        <div class="report-section-title">File a Report</div>
                        <button onclick="openThemedModal('carcass')" class="btn-report btn-carcass"><i
                                data-lucide="heart-off"></i> Dead Carcass</button>
                        <button onclick="openThemedModal('injured')" class="btn-report btn-injured"><i
                                data-lucide="alert-triangle"></i> Injured Animal</button>
                        <button onclick="openThemedModal('wild')" class="btn-report btn-wild"><i data-lucide="eye"></i>
                            Wild Sighting</button>
                    </div>

                    <!-- Community Role Application Section -->
                    <div style="margin-top: 14px;">
                        <div class="report-section-title">Want to Help?</div>
                        <button onclick="document.getElementById('applyRoleModal').classList.remove('hidden')"
                            class="btn-report btn-apply">
                            <i data-lucide="hand-helping"></i> Apply for Staff
                        </button>
                    </div>

                    <div class="sidebar-footer">
                        <a href="#" class="footer-nav-item" onclick="openSettingsModal()"><i data-lucide="settings"></i>
                            Settings</a>
                        <a href="#" class="footer-nav-item" onclick="openSupportModal()"><i
                                data-lucide="help-circle"></i> Support</a>
                        <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i
                                data-lucide="log-out"></i> Logout</a>
                    </div>
                </aside>

                <!-- MAIN CONTENT AREA -->
                <div class="main-content-wrapper">
                    <!-- Global Top Bar (Search & Profile) -->
                    <div class="top-bar">
                        <div class="top-bar-search">
                            <i data-lucide="search"></i>
                            <input type="text" id="searchInput" placeholder="Search reports, animals, or locations..."
                                onkeyup="filterReports()">
                        </div>
                        <div class="top-bar-right">
                            <div class="top-bar-icon"><i data-lucide="bell"></i></div>
                            <div class="profile-section">
                                <% String profileImg=(String) session.getAttribute("userProfileImage"); %>
                                    <% if (profileImg !=null && !profileImg.isEmpty()) { %>
                                        <img src="${pageContext.request.contextPath}/<%= profileImg %>" alt="Profile"
                                            class="profile-avatar">
                                        <% } else { %>
                                            <div class="top-bar-icon" style="border:none;"><i data-lucide="user"></i>
                                            </div>
                                            <% } %>
                                                <span class="profile-name">
                                                    <%= session.getAttribute("userName") !=null ?
                                                        session.getAttribute("userName") : "Guardian" %>
                                                </span>
                            </div>
                        </div>
                    </div>

                    <main class="main-content">

                        <!-- Submission Feedback Banners -->
                        <% if("true".equals(request.getParameter("success"))) { %>
                            <div class="alert alert-success"><i data-lucide="check-circle"></i> Your report has been
                                submitted! Thank you for helping.</div>
                            <% } %>
                                <% if("success".equals(request.getParameter("applied"))) { %>
                                    <div class="alert alert-success"><i data-lucide="check-circle"></i> Your application
                                        has been submitted!</div>
                                    <% } %>
                                        <% if("duplicate".equals(request.getParameter("applied"))) { %>
                                            <div class="alert alert-warning"><i data-lucide="info"></i> You already have
                                                a pending application.</div>
                                            <% } %>

                                                <!-- ===== TAB 1: MY REPORTS (User Submissions) ===== -->
                                                <div id="tab-myReports" class="tab-content active">

                                                    <!-- Welcome / Hero Banner -->
                                                    <div class="hero-banner">
                                                        <div class="hero-banner-content">
                                                            <h2>Community Hero<br>Dashboard</h2>
                                                            <p>Every report helps save a life. Quick view to your active
                                                                missions and community alerts.</p>
                                                        </div>
                                                        <img src="${pageContext.request.contextPath}/images/hero_tiger.png"
                                                            alt="Wildlife" class="hero-banner-image">
                                                    </div>

                                                    <!-- Personal Statistics -->
                                                    <div class="stat-cards">
                                                        <div class="stat-card">
                                                            <div class="stat-icon bg-green"><i
                                                                    data-lucide="clipboard-list"></i></div>
                                                            <span class="stat-label">Active Reports</span>
                                                            <span class="stat-value">${myTotal != null ? myTotal :
                                                                0}</span>
                                                        </div>
                                                        <div class="stat-card">
                                                            <div class="stat-icon bg-amber"><i data-lucide="clock"></i>
                                                            </div>
                                                            <span class="stat-label">Pending</span>
                                                            <span class="stat-value">${myPending != null ? myPending :
                                                                0}</span>
                                                        </div>
                                                        <div class="stat-card">
                                                            <div class="stat-icon bg-blue"><i
                                                                    data-lucide="user-check"></i></div>
                                                            <span class="stat-label">Assigned</span>
                                                            <span class="stat-value">${myAssigned != null ? myAssigned :
                                                                0}</span>
                                                        </div>
                                                        <div class="stat-card">
                                                            <div class="stat-icon bg-teal"><i
                                                                    data-lucide="check-circle"></i></div>
                                                            <span class="stat-label">Resolved</span>
                                                            <span class="stat-value">${myResolved != null ? myResolved :
                                                                0}</span>
                                                        </div>
                                                    </div>

                                                    <!-- List Filter Controls -->
                                                    <div class="search-filter-bar">
                                                        <input type="text" placeholder="Filter your reports..."
                                                            onkeyup="filterReports()" id="searchInputInline">
                                                        <select id="filterCategory" onchange="filterReports()">
                                                            <option value="all">All Categories</option>
                                                            <option value="Carcass">Carcass</option>
                                                            <option value="Injured">Injured</option>
                                                            <option value="Wild Sighting">Wild Sighting</option>
                                                        </select>
                                                        <select id="filterStatus" onchange="filterReports()">
                                                            <option value="all">All Status</option>
                                                            <option value="PENDING">Pending</option>
                                                            <option value="ASSIGNED">Assigned</option>
                                                            <option value="RESOLVED">Resolved</option>
                                                        </select>
                                                    </div>

                                                    <div class="incidents-container">
                                                        <div class="incidents-header"><i data-lucide="activity"></i>
                                                            <span class="live-dot"
                                                                style="width:8px;height:8px;border-radius:50%;background:#d32f2f;display:inline-block;animation:pulse-dot 2s infinite;margin-right:4px;"></span>
                                                            Your Submissions</div>
                                                        <div class="incidents-grid" id="reportsGrid">
                                                            <!-- Dynamic Incident Cards -->
                                                            <c:forEach items="${myReports}" var="report">
                                                                <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}"
                                                                    data-category="${report.category}"
                                                                    data-status="${report.status}"
                                                                    data-search="${report.animalType} ${report.description} ${report.locationDesc}">
                                                                    <div
                                                                        class="card-icon icon-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${report.category == 'Carcass'}">
                                                                                <i data-lucide="heart-off"></i></c:when>
                                                                            <c:when
                                                                                test="${report.category == 'Injured'}">
                                                                                <i data-lucide="alert-triangle"></i>
                                                                            </c:when>
                                                                            <c:otherwise><i data-lucide="eye"></i>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="card-title">${report.animalType}
                                                                        </div>
                                                                        <div class="card-meta">
                                                                            <span
                                                                                class="badge badge-${report.category == 'Carcass' ? 'user' : report.category == 'Injured' ? 'red' : 'pending'}">${report.category}</span>
                                                                            <span
                                                                                class="badge badge-${report.status == 'PENDING' ? 'pending' : report.status == 'ASSIGNED' ? 'assigned' : 'resolved'}">${report.status}</span>
                                                                        </div>
                                                                        <c:if test="${report.photoPath != null}">
                                                                            <img src="${pageContext.request.contextPath}/${report.photoPath}"
                                                                                alt="Report photo" class="card-photo">
                                                                        </c:if>
                                                                        <button class="btn-details"
                                                                            data-title="${report.animalType}"
                                                                            data-category="${report.category}"
                                                                            data-status="${report.status}"
                                                                            data-location="${report.locationDesc}"
                                                                            data-desc="<c:out value='${report.description}' escapeXml='true'/>"
                                                                            data-lat="${report.latitude}"
                                                                            data-lng="${report.longitude}"
                                                                            onclick="viewIncidentDetails(this)">
                                                                            <i data-lucide="external-link"></i> View
                                                                            Details
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>

                                                            <!-- Empty State Handler -->
                                                            <c:if test="${empty myReports}">
                                                                <div class="empty-state" style="grid-column: 1/-1;">
                                                                    <i data-lucide="inbox"></i>
                                                                    <p>You haven't submitted any reports yet.</p>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- ===== TAB 2: ALL REPORTS (Community Feed) ===== -->
                                                <div id="tab-allReports" class="tab-content">
                                                    <div class="section-header"><i data-lucide="file-text"></i>
                                                        <h2>All Community Reports</h2>
                                                    </div>
                                                    <p class="section-desc">Browse all reports submitted by the
                                                        community. Total: ${totalReports} reports.</p>

                                                    <!-- Advanced Filters for Community Data -->
                                                    <div class="search-filter-bar" style="margin-top:12px;">
                                                        <input type="text" placeholder="Search all reports..."
                                                            id="allReportsSearch" onkeyup="filterAllUserReports()">
                                                        <select id="allReportsCategory"
                                                            onchange="filterAllUserReports()">
                                                            <option value="all">All Categories</option>
                                                            <option value="Carcass">Carcass</option>
                                                            <option value="Injured">Injured</option>
                                                            <option value="Wild Sighting">Wild Sighting</option>
                                                        </select>
                                                        <select id="allReportsStatus" onchange="filterAllUserReports()">
                                                            <option value="all">All Status</option>
                                                            <option value="PENDING">Pending</option>
                                                            <option value="REQUESTED">Requested</option>
                                                            <option value="ASSIGNED">Assigned</option>
                                                            <option value="COMPLETED">Completed</option>
                                                            <option value="RESOLVED">Resolved</option>
                                                        </select>
                                                    </div>

                                                    <div class="incidents-container" style="margin-top:12px;">
                                                        <div class="incidents-header"><i data-lucide="globe"></i>
                                                            Community Reports</div>
                                                        <div class="incidents-grid" id="allUserReportsGrid">
                                                            <c:forEach items="${allReports}" var="report">
                                                                <div class="report-card cat-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}"
                                                                    data-category="${report.category}"
                                                                    data-status="${report.status}"
                                                                    data-search="${report.animalType} ${report.description} ${report.locationDesc} ${report.reporterName}">
                                                                    <div
                                                                        class="card-icon icon-${report.category == 'Carcass' ? 'carcass' : report.category == 'Injured' ? 'injured' : 'wild'}">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${report.category == 'Carcass'}">
                                                                                <i data-lucide="heart-off"></i></c:when>
                                                                            <c:when
                                                                                test="${report.category == 'Injured'}">
                                                                                <i data-lucide="alert-triangle"></i>
                                                                            </c:when>
                                                                            <c:otherwise><i data-lucide="eye"></i>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="card-title">${report.animalType}
                                                                        </div>
                                                                        <div class="card-meta">
                                                                            <span
                                                                                class="badge badge-${report.category == 'Carcass' ? 'user' : report.category == 'Injured' ? 'red' : 'pending'}">${report.category}</span>
                                                                            <span
                                                                                class="badge badge-${report.status == 'PENDING' ? 'pending' : report.status == 'REQUESTED' ? 'requested' : report.status == 'ASSIGNED' ? 'assigned' : report.status == 'COMPLETED' ? 'completed' : 'resolved'}">${report.status}</span>
                                                                            <c:if test="${report.reporterName != null}">
                                                                                <span
                                                                                    style="font-size:0.72rem;color:var(--color-text-muted);">by
                                                                                    ${report.reporterName}</span>
                                                                            </c:if>
                                                                        </div>
                                                                        <c:if test="${report.locationDesc != null}">
                                                                            <div class="card-location"><i
                                                                                    data-lucide="map-pin"></i>
                                                                                ${report.locationDesc}</div>
                                                                        </c:if>
                                                                        <c:if test="${report.photoPath != null}">
                                                                            <img src="${pageContext.request.contextPath}/${report.photoPath}"
                                                                                alt="Report photo" class="card-photo">
                                                                        </c:if>
                                                                        <button class="btn-details"
                                                                            data-title="${report.animalType}"
                                                                            data-category="${report.category}"
                                                                            data-status="${report.status}"
                                                                            data-location="${report.locationDesc}"
                                                                            data-desc="<c:out value='${report.description}' escapeXml='true'/>"
                                                                            data-lat="${report.latitude}"
                                                                            data-lng="${report.longitude}"
                                                                            onclick="viewIncidentDetails(this)">
                                                                            <i data-lucide="external-link"></i> View
                                                                            Details
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- ===== TAB 3: HEATMAP (Visual Map Data) ===== -->
                                                <div id="tab-heatmap" class="tab-content full-page-map-container">
                                                    <!-- Target for Leaflet Map -->
                                                    <div id="map"></div>
                                                </div>

                    </main>
                </div>
            </div>

            <!-- MODAL: SUBMIT NEW INCIDENT (Themed per category) -->
            <div id="reportModal" class="modal-backdrop hidden">
                <div id="modalContentBox" class="modal-content theme-carcass">
                    <h2 id="modalDynamicTitle"
                        style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Report Sighting
                    </h2>
                    <p id="modalDynamicDesc"
                        style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 16px;">Provide details
                        to assist our team.</p>

                    <form action="${pageContext.request.contextPath}/report/submit" method="POST"
                        enctype="multipart/form-data">
                        <input type="hidden" name="category" id="categoryInput" value="Carcass">
                        <div class="form-group">
                            <label>Animal Species</label>
                            <select name="species" class="form-control">
                                <option value="Small Mammal">Small Mammal</option>
                                <option value="Large Mammal">Large Mammal</option>
                                <option value="Avian">Avian Species</option>
                                <option value="Reptile">Reptile</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" class="form-control" rows="2" style="resize: vertical;"
                                placeholder="Describe what you see..." required></textarea>
                        </div>
                        <div class="form-group">
                            <label>Upload Photo (optional)</label>
                            <div class="photo-upload-area" id="reportPhotoArea">
                                <i data-lucide="camera"></i>
                                <p>Click to upload a photo</p>
                                <input type="file" name="reportPhoto" accept="image/*"
                                    onchange="previewReportPhoto(this)">
                                <img id="reportPhotoPreview" class="photo-preview" alt="Preview">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Tap Map to Set Location</label>
                            <!-- Google Maps API Target for location picking -->
                            <div id="pickerMap"
                                style="height: 160px; width: 100%; margin-bottom: 6px; border-radius: var(--radius-md); overflow: hidden;">
                            </div>
                            <input type="text" name="location" id="locationInput" class="form-control"
                                style="background: var(--color-bg-light); font-size: 0.88rem;" readonly>
                        </div>
                        <div class="modal-actions">
                            <button type="button" onclick="closeModal()" class="btn-cancel">Cancel</button>
                            <button type="submit" class="modal-submit-btn">Submit Report</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- MODAL: INCIDENT DETAIL VIEW -->
            <div id="detailModal" class="modal-backdrop hidden">
                <div class="modal-content">
                    <h2 id="detailViewTitle"
                        style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 12px;">Incident Details
                    </h2>
                    <div
                        style="background: var(--color-bg-light); padding: 16px; border-radius: var(--radius-md); margin-bottom: 18px;">
                        <p style="margin-bottom: 8px;"><strong
                                style="color: var(--color-text-muted);">Category:</strong> <span
                                id="detailViewCategory"></span></p>
                        <p style="margin-bottom: 8px;"><strong style="color: var(--color-text-muted);">Status:</strong>
                            <span id="detailViewStatus" style="font-weight: 700;"></span></p>
                        <p style="margin-bottom: 8px;"><strong
                                style="color: var(--color-text-muted);">Location:</strong> <span
                                id="detailViewLocation"></span></p>
                        <hr style="border: none; border-top: 1px solid var(--color-border); margin: 10px 0;">
                        <p><strong style="color: var(--color-text-muted);">Description:</strong> <span
                                id="detailViewDesc" style="color: var(--color-text-dark);"></span></p>
                    </div>
                    <div class="modal-actions">
                        <button type="button" onclick="closeDetailModal()" class="btn-cancel">Close</button>
                        <button type="button" onclick="locateIncidentOnMap()" class="modal-submit-btn"><i
                                data-lucide="map-pin"
                                style="width:14px;height:14px;display:inline;vertical-align:middle;"></i> View on
                            Map</button>
                    </div>
                </div>
            </div>

            <!-- MODAL: APPLY FOR STAFF ROLE -->
            <div id="applyRoleModal" class="modal-backdrop hidden">
                <div class="modal-content">
                    <h2 style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Apply for a Role
                    </h2>
                    <p style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 18px;">Join our team
                        and help protect wildlife.</p>
                    <form action="${pageContext.request.contextPath}/user/apply-role" method="POST">
                        <div class="form-group">
                            <label>Choose a Role</label>
                            <select name="requestedRole" class="form-control">
                                <option value="STAFF">Field Staff</option>
                                <option value="HELPER">Community Helper</option>
                            </select>
                        </div>
                        <div class="modal-actions">
                            <button type="button"
                                onclick="document.getElementById('applyRoleModal').classList.add('hidden')"
                                class="btn-cancel">Cancel</button>
                            <button type="submit" class="modal-submit-btn">Submit Application</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- MODAL: CONTACT SUPPORT -->
            <div id="supportModal" class="modal-backdrop hidden">
                <div class="modal-content" style="max-width:660px;">
                    <h2 style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Contact Support
                    </h2>
                    <p style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 16px;">Have a concern?
                        Reach out to our admin team directly.</p>
                    <div class="support-modal-body">
                        <div class="support-video-col">
                            <video autoplay loop muted playsinline>
                                <source src="${pageContext.request.contextPath}/videos/side eye bear.mp4"
                                    type="video/mp4">
                            </video>
                        </div>
                        <div class="support-form-col">
                            <form id="supportForm"
                                onsubmit="event.preventDefault(); submitSupportForm('${pageContext.request.contextPath}');">
                                <div class="form-group">
                                    <label>Your Email</label>
                                    <input type="email" name="email" class="form-control" placeholder="your@email.com">
                                </div>
                                <div class="form-group">
                                    <label>Subject</label>
                                    <input type="text" name="subject" class="form-control"
                                        placeholder="What's this about?" required>
                                </div>
                                <div class="form-group">
                                    <label>Message</label>
                                    <textarea name="message" class="form-control" rows="3" style="resize:vertical;"
                                        placeholder="Describe your concern..." required></textarea>
                                </div>
                                <div class="modal-actions">
                                    <button type="button" onclick="closeSupportModal()"
                                        class="btn-cancel">Cancel</button>
                                    <button type="submit" class="modal-submit-btn">Send Message</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- MODAL: GLOBAL SETTINGS (Theme etc) -->
            <div id="settingsModal" class="modal-backdrop hidden">
                <div class="modal-content" style="max-width:420px;">
                    <h2 style="color: var(--color-text-dark); font-size: 1.25rem; margin-bottom: 6px;">Settings</h2>
                    <p style="color: var(--color-text-muted); font-size: 0.88rem; margin-bottom: 16px;">Customize your
                        dashboard experience.</p>
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
                        <button type="button" onclick="closeSettingsModal()" class="modal-submit-btn"
                            style="flex:none; width:100%;">Done</button>
                    </div>
                </div>
            </div>

            <!-- Footer Scripts: Map Data Injection & UI Handling -->
            <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
            <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>

            <script>
                // Global data arrays for script.js map initialization
                const heatmapPoints = [];
                const mapEvents = [];
                <c:forEach items="${allReportsForMap}" var="report">
                    <c:if test="${not empty report.latitude and not empty report.longitude}">
                        heatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
                        mapEvents.push({
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
                 * Handles tab switching logic for the User Dashboard.
                 */
                function switchUserTab(tabName, el) {
                    document.querySelectorAll('.tab-content').forEach(function (t) { t.classList.remove('active'); });
                    document.getElementById('tab-' + tabName).classList.add('active');
                    document.querySelectorAll('.sidebar-nav .nav-item').forEach(function (n) { n.classList.remove('active'); });
                    if (el) el.classList.add('active');
                    if (typeof lucide !== 'undefined') lucide.createIcons();
                    if (tabName === 'heatmap' && typeof leafletMainMap !== 'undefined' && leafletMainMap) {
                        setTimeout(function () { leafletMainMap.invalidateSize(); }, 150);
                    }
                }

                /**
                 * Filters the community reports grid.
                 */
                function filterAllUserReports() {
                    var keyword = (document.getElementById('allReportsSearch').value || '').toLowerCase().trim();
                    var category = document.getElementById('allReportsCategory').value;
                    var status = document.getElementById('allReportsStatus').value;
                    document.querySelectorAll('#allUserReportsGrid .report-card').forEach(function (card) {
                        var show = true;
                        if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
                        if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
                        if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
                        card.style.display = show ? '' : 'none';
                    });
                }
            </script>

            <!-- Final API and Resource Loading -->
            <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDSyuMt2Wpi5mn9eJw7caFUoKP-WBKekqI"></script>
            <script src="${pageContext.request.contextPath}/js/script.js?v=3"></script>
            <script src="https://unpkg.com/lucide@latest"></script>
            <script>lucide.createIcons();</script>

        </html>