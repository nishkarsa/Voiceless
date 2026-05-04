<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - My Dashboard</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-wrapper">
        
        <aside class="sidebar">
            <div class="sidebar-profile">
                <% String profileImg = (String) session.getAttribute("userProfileImage"); %>
                <% if (profileImg != null && !profileImg.isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/<%= profileImg %>" alt="Profile" class="user-avatar">
                <% } else { %>
                    <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless" class="brand-logo">
                <% } %>
                <h1 class="title"><%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Guardian" %></h1>
            </div>
            
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active" onclick="switchUserTab('myReports', this)"><i data-lucide="file-text"></i> My Reports</a>
                <a href="#" class="nav-item" onclick="switchUserTab('heatmap', this)"><i data-lucide="map"></i> Community Heatmap</a>
            </nav>
            
            <div class="sidebar-report-options">
                <div class="report-section-title">File a Report</div>
                <button onclick="openThemedModal('carcass')" class="btn-report btn-carcass"><i data-lucide="heart-off"></i> Dead Carcass</button>
                <button onclick="openThemedModal('injured')" class="btn-report btn-injured"><i data-lucide="alert-triangle"></i> Injured Animal</button>
                <button onclick="openThemedModal('wild')" class="btn-report btn-wild"><i data-lucide="eye"></i> Wild Sighting</button>
            </div>

            <div style="margin-top: 14px;">
                <div class="report-section-title">Want to Help?</div>
                <button onclick="document.getElementById('applyRoleModal').classList.remove('hidden')" class="btn-report btn-apply">
                    <i data-lucide="hand-helping"></i> Apply for Staff / Helper
                </button>
            </div>
            
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="btn-logout"><i data-lucide="log-out"></i> Logout</a>
            </div>
        </aside>

        <main class="main-content">
            
            <% if("true".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success"><i data-lucide="check-circle"></i> Your report has been submitted! Thank you for helping.</div>
            <% } %>
            <% if("success".equals(request.getParameter("applied"))) { %>
                <div class="alert alert-success"><i data-lucide="check-circle"></i> Your application has been submitted!</div>
            <% } %>
            <% if("duplicate".equals(request.getParameter("applied"))) { %>
                <div class="alert alert-warning"><i data-lucide="info"></i> You already have a pending application.</div>
            <% } %>

            <!-- ===== MY REPORTS TAB ===== -->
            <div id="tab-myReports" class="tab-content active">
                <div class="section-header">
                    <i data-lucide="file-text"></i>
                    <h2>My Reports</h2>
                </div>
                <p class="section-desc">Reports you have personally submitted.</p>

                <!-- Personal Stats -->
                <div class="stat-cards">
                    <div class="stat-card">
                        <div class="stat-icon bg-green"><i data-lucide="clipboard-list"></i></div>
                        <span class="stat-value">${myTotal != null ? myTotal : 0}</span>
                        <span class="stat-label">My Reports</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-amber"><i data-lucide="clock"></i></div>
                        <span class="stat-value">${myPending != null ? myPending : 0}</span>
                        <span class="stat-label">Pending</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-blue"><i data-lucide="user-check"></i></div>
                        <span class="stat-value">${myAssigned != null ? myAssigned : 0}</span>
                        <span class="stat-label">Assigned</span>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon bg-teal"><i data-lucide="check-circle"></i></div>
                        <span class="stat-value">${myResolved != null ? myResolved : 0}</span>
                        <span class="stat-label">Resolved</span>
                    </div>
                </div>

                <!-- Search/Filter -->
                <div class="search-filter-bar">
                    <input type="text" id="searchInput" placeholder="Search your reports..." onkeyup="filterReports()">
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

                <!-- Reports Grid -->
                <div class="incidents-container">
                    <div class="incidents-header"><i data-lucide="inbox"></i> Your Submissions</div>
                    <div class="incidents-grid" id="reportsGrid">
                        <c:forEach items="${myReports}" var="report">
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
                                    <c:if test="${report.photoPath != null}">
                                        <img src="${pageContext.request.contextPath}/${report.photoPath}" alt="Report photo" class="card-photo">
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
                                        <i data-lucide="external-link"></i> View Details
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty myReports}">
                            <div class="empty-state" style="grid-column: 1/-1;">
                                <i data-lucide="inbox"></i>
                                <p>You haven't submitted any reports yet.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- ===== HEATMAP TAB ===== -->
            <div id="tab-heatmap" class="tab-content">
                <div class="section-header">
                    <i data-lucide="map"></i>
                    <h2>Community Heatmap</h2>
                </div>
                <p class="section-desc">Overview of all reported incidents across the community. Total: ${totalReports} reports.</p>
                <div id="map"></div>
            </div>

        </main>
    </div>

    <!-- REPORT MODAL -->
    <div id="reportModal" class="modal-backdrop hidden">
        <div id="modalContentBox" class="modal-content theme-carcass">
            <h2 id="modalDynamicTitle" style="color: #1a2e1a; font-size: 1.3rem; margin-bottom: 6px;">Report Sighting</h2>
            <p id="modalDynamicDesc" style="color: #6b7260; font-size: 0.88rem; margin-bottom: 16px;">Provide details to assist our team.</p>
            
            <form action="${pageContext.request.contextPath}/report/submit" method="POST" enctype="multipart/form-data">
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
                    <textarea name="description" class="form-control" rows="2" style="resize: vertical;" placeholder="Describe what you see..." required></textarea>
                </div>

                <div class="form-group">
                    <label>Upload Photo (optional)</label>
                    <div class="photo-upload-area" id="reportPhotoArea">
                        <i data-lucide="camera"></i>
                        <p>Click to upload a photo</p>
                        <input type="file" name="reportPhoto" accept="image/*" onchange="previewReportPhoto(this)">
                        <img id="reportPhotoPreview" class="photo-preview" alt="Preview">
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Tap Map to Set Location</label>
                    <div id="pickerMap" style="height: 160px; width: 100%; margin-bottom: 6px; border-radius: 12px; overflow: hidden;"></div>
                    <input type="text" name="location" id="locationInput" class="form-control" style="background:#f4f1ea; font-size: 0.88rem;" readonly>
                </div>
                
                <div class="modal-actions">
                    <button type="button" onclick="closeModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="modal-submit-btn">Submit Report</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- DETAIL MODAL -->
    <div id="detailModal" class="modal-backdrop hidden">
        <div class="modal-content" style="border-top: 5px solid #5a7a42;">
            <h2 id="detailViewTitle" style="color: #1a2e1a; font-size: 1.3rem; margin-bottom: 12px;">Incident Details</h2>
            <div style="background: #f4f1ea; padding: 16px; border-radius: 12px; margin-bottom: 18px;">
                <p style="margin-bottom: 8px;"><strong style="color: #4a5240;">Category:</strong> <span id="detailViewCategory"></span></p>
                <p style="margin-bottom: 8px;"><strong style="color: #4a5240;">Status:</strong> <span id="detailViewStatus" style="font-weight: 700;"></span></p>
                <p style="margin-bottom: 8px;"><strong style="color: #4a5240;">Location:</strong> <span id="detailViewLocation"></span></p>
                <hr style="border: none; border-top: 1px solid #e4dfd2; margin: 10px 0;">
                <p><strong style="color: #4a5240;">Description:</strong> <span id="detailViewDesc" style="color: #2e2b26;"></span></p>
            </div>
            <div class="modal-actions">
                <button type="button" onclick="closeDetailModal()" class="btn-cancel">Close</button>
                <button type="button" onclick="locateIncidentOnMap()" class="modal-submit-btn" style="background: #5a7a42; color: #fff;"><i data-lucide="map-pin" style="width:14px;height:14px;display:inline;vertical-align:middle;"></i> View on Map</button>
            </div>
        </div>
    </div>

    <!-- APPLY ROLE MODAL -->
    <div id="applyRoleModal" class="modal-backdrop hidden">
        <div class="modal-content" style="border-top: 5px solid #5a7a42;">
            <h2 style="color: #1a2e1a; font-size: 1.3rem; margin-bottom: 6px;">Apply for a Role</h2>
            <p style="color: #6b7260; font-size: 0.88rem; margin-bottom: 18px;">Join our team and help protect wildlife.</p>
            <form action="${pageContext.request.contextPath}/user/apply-role" method="POST">
                <div class="form-group">
                    <label>Choose a Role</label>
                    <select name="requestedRole" class="form-control">
                        <option value="STAFF">Field Staff</option>
                        <option value="HELPER">Community Helper</option>
                    </select>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="document.getElementById('applyRoleModal').classList.add('hidden')" class="btn-cancel">Cancel</button>
                    <button type="submit" class="modal-submit-btn" style="background: #5a7a42; color: #fff;">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    
    <script>
    // Heatmap points from ALL community reports
    const heatmapPoints = [];
    <c:forEach items="${allReportsForMap}" var="report">
        <c:if test="${not empty report.latitude and not empty report.longitude}">
            heatmapPoints.push([${report.latitude}, ${report.longitude}, 1.0]);
        </c:if>
    </c:forEach>

    // Photo preview
    function previewReportPhoto(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var preview = document.getElementById('reportPhotoPreview');
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Tab switching
    function switchUserTab(tabName, el) {
        document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabName).classList.add('active');
        document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
        if (el) el.classList.add('active');
        // Re-init icons in new tab
        if (typeof lucide !== 'undefined') lucide.createIcons();
        // Invalidate map size when switching to heatmap tab
        if (tabName === 'heatmap' && typeof leafletMainMap !== 'undefined' && leafletMainMap) {
            setTimeout(function() { leafletMainMap.invalidateSize(); }, 100);
        }
    }
    </script>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDSyuMt2Wpi5mn9eJw7caFUoKP-WBKekqI"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <script>lucide.createIcons();</script>
    
</html>