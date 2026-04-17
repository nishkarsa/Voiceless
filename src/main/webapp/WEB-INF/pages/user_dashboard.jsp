<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Dashboard</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-wrapper">
        
        <aside class="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/images/voiceless_logo.png" alt="Voiceless Logo" class="brand-logo">
                <h1 class="title">Welcome, <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Guardian" %> !</h1>
            </div>
            
            <nav class="sidebar-nav">
                <a href="#" class="nav-item active"><span>🗺️</span> Map View</a>
                <a href="#" class="nav-item"><span>📄</span> My Reports</a>
            </nav>
            
            <div class="sidebar-report-options">
                <div class="report-section-title">File a Report</div>
                <button onclick="openThemedModal('carcass')" class="btn-report btn-carcass">🤍 Dead Carcass</button>
                <button onclick="openThemedModal('injured')" class="btn-report btn-injured">🚨 Injured Animal</button>
                <button onclick="openThemedModal('wild')" class="btn-report btn-wild">⚠️ Wild Sighting</button>
            </div>
            
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/login" class="btn-logout">Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <div id="map"></div>
            
            <div class="map-overlay">
                <div class="overlay-header">Community Activity</div>
                <div class="overlay-body">
                    <c:forEach items="${recentReports}" var="report">
                        <div class="report-card">
                            <div style="font-size: 1.5rem;">
                                <c:choose>
                                    <c:when test="${report.category == 'Carcass'}">🤍</c:when>
                                    <c:when test="${report.category == 'Injured'}">🚨</c:when>
                                    <c:otherwise>⚠️</c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div style="font-weight: 700; color: #111827; font-size: 0.9rem;">${report.species}</div>
                                <div style="font-size: 0.75rem; color: #6b7280;">
                                    ${report.category} • ${report.status}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty recentReports}">
                        <p style="text-align:center; color:#6b7280; font-size:0.85rem;">No recent sightings reported.</p>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <div id="reportModal" class="modal-backdrop hidden">
        <div id="modalContentBox" class="modal-content theme-carcass">
            <h2 id="modalDynamicTitle" style="color: #111827; font-size: 1.5rem; margin-bottom: 8px;">Report Sighting</h2>
            <p id="modalDynamicDesc" style="color: #6b7280; font-size: 0.85rem; margin-bottom: 16px;">Provide details to assist our team.</p>
            
            <form action="${pageContext.request.contextPath}/report/submit" method="POST">
                <input type="hidden" name="category" id="categoryInput" value="Carcass">

                <div class="form-group" style="margin-bottom: 12px;">
                    <label style="display:block; font-size:0.75rem; font-weight:700; color:#4b5563; margin-bottom:6px;">Animal Species</label>
                    <select name="species" class="form-control" style="width:100%; padding:10px; border-radius:8px; border:1px solid #e5e7eb;">
                        <option value="Small Mammal">Small Mammal</option>
                        <option value="Large Mammal">Large Mammal</option>
                        <option value="Avian">Avian Species</option>
                    </select>
                </div>
                
                <div class="form-group" style="margin-bottom: 12px;">
                    <label style="display:block; font-size:0.75rem; font-weight:700; color:#4b5563; margin-bottom:6px;">Description</label>
                    <textarea name="description" class="form-control" rows="2" style="width:100%; padding:10px; border-radius:8px; border:1px solid #e5e7eb;" required></textarea>
                </div>
                
                <div class="form-group">
                    <label style="display:block; font-size:0.75rem; font-weight:700; color:#4b5563; margin-bottom:6px;">Tap to Pinpoint Exact Location</label>
                    
                    <div id="pickerMap" style="height: 180px; width: 100%; margin-bottom: 8px; border-radius: 8px; border: 1px solid #e5e7eb;"></div>
                    
                    <input type="text" name="location" id="locationInput" class="form-control" style="width:100%; padding:10px; border-radius:8px; border:1px solid #e5e7eb; background:#f9fafb;" readonly>
                </div>
                
                <div class="modal-actions" style="margin-top: 16px;">
                    <button type="button" onclick="closeModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="modal-submit-btn">Submit Report</button>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
	<script src="https://unpkg.com/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
    
	<script>
    	// Format the DB coordinates for Leaflet Heatmap
    	const heatmapPoints = [
        	<c:forEach items="${recentReports}" var="report">
            	<c:if test="${not empty report.latitude and not empty report.longitude}">
                	[${report.latitude}, ${report.longitude}, 1.0], 
            	</c:if>
        	</c:forEach>
    	];
	</script>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDSyuMt2Wpi5mn9eJw7caFUoKP-WBKekqI&callback=initMap" async defer></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    
</html>