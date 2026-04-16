<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voiceless - Sanctuary Map</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body>
    <div class="dashboard-layout">
        <div class="sidebar">
            <div class="sidebar-header">
                <h1 class="title" style="font-size:1.5rem;">🌲 Voiceless</h1>
                <p style="font-size:0.75rem; color:#64748b;">Welcome, <%= session.getAttribute("userName") %></p>
            </div>
            <div class="sidebar-nav">
                <a href="#" class="nav-item active">🗺️ Map View</a>
                <a href="#" class="nav-item">📄 My Reports</a>
            </div>
            <div class="sidebar-footer">
                <button onclick="document.getElementById('reportModal').classList.remove('hidden')" class="btn btn-primary" style="margin-bottom:1rem;">+ Report Sighting</button>
                <a href="${pageContext.request.contextPath}/login" class="nav-item" style="text-align:center;">🚪 Logout</a>
            </div>
        </div>

        <div class="main-content">
            <div id="map"></div>
            
            <div class="overlay-panel">
                <div class="panel-header">Recent Community Reports</div>
                <div class="panel-body">
                    <div class="report-card">
                        <div>🐾</div>
                        <div>
                            <div style="font-weight:bold; font-size:0.875rem;">Deer Sighting</div>
                            <div style="font-size:0.75rem; color:#64748b;">Hwy 101 • 2 mins ago</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="reportModal" class="modal-backdrop hidden">
        <div class="modal-content">
            <h2 class="title" style="margin-bottom:1.5rem;">Identify the species</h2>
            <form action="${pageContext.request.contextPath}/report/submit" method="POST">
                <div class="form-group">
                    <label>Animal Type</label>
                    <select name="species" class="form-control">
                        <option value="Small Mammal">Small Mammal</option>
                        <option value="Large Mammal">Large Mammal</option>
                        <option value="Avian">Avian Species</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Incident Description</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Describe the scene..." required></textarea>
                </div>
                <div class="form-group">
                    <label>Location</label>
                    <input type="text" name="location" class="form-control" value="Current GPS Coordinates" readonly>
                </div>
                <div style="display:flex; gap:1rem; margin-top:2rem;">
                    <button type="button" onclick="document.getElementById('reportModal').classList.add('hidden')" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit Report</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        var map = L.map('map', {zoomControl: false}).setView([34.0522, -118.2437], 13);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png').addTo(map);
    </script>
</body>
</html>