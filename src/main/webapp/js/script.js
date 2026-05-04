let leafletMainMap;
let googleModalMap;
let googleModalMarker;

// --- INIT MAP ON LOAD ---
document.addEventListener("DOMContentLoaded", function() {
    
    const defaultLocation = [27.6781, 85.3803]; 
    const mapElement = document.getElementById('map');
    
    if (mapElement) {
        leafletMainMap = L.map('map', {zoomControl: true}).setView(defaultLocation, 11);
        
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(leafletMainMap);

        if (typeof heatmapPoints !== 'undefined' && heatmapPoints.length > 0) {
            L.heatLayer(heatmapPoints, {
                radius: 25, blur: 15, maxZoom: 15,
                gradient: {0.4: '#3d6b35', 0.65: '#d4a647', 1: '#a63d40'} 
            }).addTo(leafletMainMap);
        }

        setTimeout(function() { leafletMainMap.invalidateSize(); }, 250);

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                leafletMainMap.setView([position.coords.latitude, position.coords.longitude], 13);
            });
        }
    }
});

// --- THEMED REPORT MODAL ---
function openThemedModal(type) {
    var modal = document.getElementById('reportModal');
    var contentBox = document.getElementById('modalContentBox');
    var catInput = document.getElementById('categoryInput');
    var title = document.getElementById('modalDynamicTitle');
    var desc = document.getElementById('modalDynamicDesc');

    // Reset photo preview
    var preview = document.getElementById('reportPhotoPreview');
    if (preview) { preview.style.display = 'none'; preview.src = ''; }

    contentBox.className = 'modal-content'; 
    if (type === 'carcass') {
        contentBox.classList.add('theme-carcass');
        catInput.value = 'Carcass';
        title.innerText = 'Report Dead Carcass';
        desc.innerText = 'Please provide details respectfully. Field staff will be dispatched.';
    } else if (type === 'injured') {
        contentBox.classList.add('theme-injured');
        catInput.value = 'Injured';
        title.innerText = 'Report Injured Animal';
        desc.innerText = 'Urgent: Maintain a safe distance. Provide precise location.';
    } else if (type === 'wild') {
        contentBox.classList.add('theme-wild');
        catInput.value = 'Wild Sighting';
        title.innerText = 'Report Wild Animal';
        desc.innerText = 'Caution: Do not approach. This alert helps the community.';
    }

    modal.classList.remove('hidden');

    setTimeout(function() {
        var centerPos = { lat: 27.6781, lng: 85.3803 };
        if (leafletMainMap) {
            var c = leafletMainMap.getCenter();
            centerPos = { lat: c.lat, lng: c.lng };
        }

        if (!googleModalMap) {
            googleModalMap = new google.maps.Map(document.getElementById('pickerMap'), {
                center: centerPos, zoom: 16,
                disableDefaultUI: true, zoomControl: true, mapTypeId: 'satellite'
            });
            googleModalMarker = new google.maps.Marker({
                position: centerPos, map: googleModalMap, draggable: true,
                animation: google.maps.Animation.DROP
            });
            googleModalMarker.addListener('dragend', function() {
                var pos = googleModalMarker.getPosition();
                document.getElementById('locationInput').value = pos.lat().toFixed(5) + ", " + pos.lng().toFixed(5);
            });
            googleModalMap.addListener('click', function(e) {
                googleModalMarker.setPosition(e.latLng);
                document.getElementById('locationInput').value = e.latLng.lat().toFixed(5) + ", " + e.latLng.lng().toFixed(5);
            });
        } else {
            google.maps.event.trigger(googleModalMap, 'resize');
            googleModalMap.setCenter(centerPos);
            googleModalMarker.setPosition(centerPos);
        }
        var pos = googleModalMarker.getPosition();
        document.getElementById('locationInput').value = pos.lat().toFixed(5) + ", " + pos.lng().toFixed(5);
    }, 150);
}

function closeModal() {
    document.getElementById('reportModal').classList.add('hidden');
}

// --- INCIDENT DETAIL VIEW ---
var activeIncidentLat = null;
var activeIncidentLng = null;

function viewIncidentDetails(btn) {
    document.getElementById('detailViewTitle').innerText = btn.getAttribute('data-title') + ' Sighting';
    document.getElementById('detailViewCategory').innerText = btn.getAttribute('data-category');
    document.getElementById('detailViewLocation').innerText = btn.getAttribute('data-location');
    document.getElementById('detailViewDesc').innerText = btn.getAttribute('data-desc');
    
    var status = btn.getAttribute('data-status');
    var statusEl = document.getElementById('detailViewStatus');
    statusEl.innerText = status;
    statusEl.style.color = status === 'PENDING' ? '#7a6118' : status === 'ASSIGNED' ? '#1a5276' : '#1e6f30';

    activeIncidentLat = btn.getAttribute('data-lat');
    activeIncidentLng = btn.getAttribute('data-lng');

    document.getElementById('detailModal').classList.remove('hidden');
    if (typeof lucide !== 'undefined') lucide.createIcons();
}

function closeDetailModal() {
    document.getElementById('detailModal').classList.add('hidden');
}

function locateIncidentOnMap() {
    closeDetailModal();
    if (activeIncidentLat && activeIncidentLng && leafletMainMap) {
        // Switch to heatmap tab first
        var heatmapTab = document.getElementById('tab-heatmap');
        if (heatmapTab) {
            document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
            heatmapTab.classList.add('active');
            document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
            var navItems = document.querySelectorAll('.sidebar-nav .nav-item');
            if (navItems.length > 1) navItems[1].classList.add('active');
        }

        setTimeout(function() {
            leafletMainMap.invalidateSize();
            var target = [parseFloat(activeIncidentLat), parseFloat(activeIncidentLng)];
            leafletMainMap.flyTo(target, 15, { animate: true, duration: 1.5 });
            setTimeout(function() {
                L.popup()
                 .setLatLng(target)
                 .setContent("<div style='font-weight:700; color:#3d6b35;'>Incident Location</div>")
                 .openOn(leafletMainMap);
            }, 1500);
        }, 200);
    }
}

// --- SEARCH & FILTER (User Dashboard) ---
function filterReports() {
    var keyword = document.getElementById('searchInput').value.toLowerCase();
    var category = document.getElementById('filterCategory').value;
    var status = document.getElementById('filterStatus').value;
    document.querySelectorAll('#reportsGrid .report-card').forEach(function(card) {
        var show = true;
        if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
        if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
        if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
        card.style.display = show ? '' : 'none';
    });
}
