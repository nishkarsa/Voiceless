/**
 * Voiceless Unified JavaScript Handler
 * Manages maps, theme switching, dashboard interactions, and AJAX communications.
 */

let leafletMainMap;
let googleModalMap;
let googleModalMarker;

// --- THEME SYSTEM ---
/**
 * Initializes the theme from localStorage on page load.
 */
function initTheme() {
    var saved = localStorage.getItem('voiceless-theme');
    if (saved) {
        document.documentElement.setAttribute('data-theme', saved);
    }
}
initTheme();

/**
 * Toggles between light and dark modes and persists the choice.
 */
function toggleTheme() {
    var current = document.documentElement.getAttribute('data-theme');
    var next = (current === 'light') ? 'dark' : 'light';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('voiceless-theme', next);
    var cb = document.getElementById('themeToggleCheckbox');
    if (cb) cb.checked = (next === 'light');
}

// --- TOAST NOTIFICATIONS ---
/**
 * Ensures a container exists for toast messages.
 */
function ensureToastContainer() {
    var c = document.getElementById('toastContainer');
    if (!c) {
        c = document.createElement('div');
        c.id = 'toastContainer';
        c.className = 'toast-container';
        document.body.appendChild(c);
    }
    return c;
}

/**
 * Displays a non-intrusive toast notification.
 * @param {string} message - Text to display
 * @param {string} type - 'success', 'error', or 'info'
 */
function showToast(message, type) {
    type = type || 'success';
    var container = ensureToastContainer();
    var toast = document.createElement('div');
    toast.className = 'toast toast-' + type;
    var icon = type === 'success' ? 'check-circle' : type === 'error' ? 'alert-circle' : 'info';
    toast.innerHTML = '<i data-lucide="' + icon + '"></i> ' + message;
    container.appendChild(toast);
    if (typeof lucide !== 'undefined') lucide.createIcons();
    setTimeout(function() {
        toast.classList.add('toast-out');
        setTimeout(function() { toast.remove(); }, 300);
    }, 3500);
}

// --- AJAX HELPER ---
/**
 * Global AJAX utility to perform POST actions with JSON response.
 * @param {string} url - Target endpoint
 * @param {object} params - Data to send
 * @param {function} callback - Success handler
 */
function performAction(url, params, callback) {
    var formData = new URLSearchParams();
    for (var key in params) {
        formData.append(key, params[key]);
    }
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData.toString()
    })
    .then(function(resp) { return resp.json(); })
    .then(function(data) {
        if (callback) callback(data);
    })
    .catch(function(err) {
        console.error('Action failed:', err);
        showToast('Action failed. Please try again.', 'error');
    });
}

// --- INIT MAP ON LOAD ---
/**
 * Main initialization on DOM content loaded.
 * Sets up theme and the primary Leaflet map.
 */
document.addEventListener("DOMContentLoaded", function() {
    
    var saved = localStorage.getItem('voiceless-theme');
    if (saved) document.documentElement.setAttribute('data-theme', saved);
    var cb = document.getElementById('themeToggleCheckbox');
    if (cb) cb.checked = (saved === 'light');

    const defaultLocation = [27.6781, 85.3803]; // Default: Kathmandu
    const mapElement = document.getElementById('map');
    
    if (mapElement) {
        // Initialize Leaflet Map
        leafletMainMap = L.map('map', {zoomControl: true}).setView(defaultLocation, 11);
        
        // Add Clean Map Layer
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(leafletMainMap);

        // Add Heatmap Layer if data exists
        if (typeof heatmapPoints !== 'undefined' && heatmapPoints.length > 0) {
            L.heatLayer(heatmapPoints, {
                radius: 25, blur: 15, maxZoom: 15,
                gradient: {0.4: '#1a5c3a', 0.65: '#e6a817', 1: '#d32f2f'} 
            }).addTo(leafletMainMap);
        }
        
        // Add Interactive Tooltip Overlay Markers
        // We use invisible circleMarkers to enable hover tooltips over heatmap areas
        if (typeof mapEvents !== 'undefined' && mapEvents.length > 0) {
            mapEvents.forEach(function(evt) {
                L.circleMarker([evt.lat, evt.lng], { radius: 20, opacity: 0, fillOpacity: 0 })
                 .addTo(leafletMainMap)
                 .bindTooltip("<div style='font-family:var(--font-main);text-align:center;'><b>" + evt.title + "</b><br><span style='font-size:0.8rem;color:#6b7c66;'>" + evt.category + " &middot; " + evt.status + "</span></div>", {direction: 'top', offset: [0, -10]});
            });
        }

        setTimeout(function() { leafletMainMap.invalidateSize(); }, 250);

        // Auto-locate user on map
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var userLat = position.coords.latitude;
                var userLng = position.coords.longitude;
                leafletMainMap.setView([userLat, userLng], 13);
                
                // Pulsing dot for user location
                L.marker([userLat, userLng], {
                    icon: L.divIcon({
                        html: '<div style="width:14px;height:14px;border-radius:50%;background:#2d6a4f;border:3px solid #fff;box-shadow:0 0 8px rgba(45,106,79,0.5);"></div>',
                        className: '',
                        iconSize: [14, 14]
                    })
                }).addTo(leafletMainMap).bindPopup('<strong>Your Location</strong>');
            }, function() {
                // Fallback handled by default location
            }, { enableHighAccuracy: true, timeout: 10000 });
        }
    }
});

// --- THEMED REPORT MODAL ---
/**
 * Opens and styles the report modal based on the incident type.
 * @param {string} type - 'carcass', 'injured', or 'wild'
 */
function openThemedModal(type) {
    var modal = document.getElementById('reportModal');
    var contentBox = document.getElementById('modalContentBox');
    var catInput = document.getElementById('categoryInput');
    var title = document.getElementById('modalDynamicTitle');
    var desc = document.getElementById('modalDynamicDesc');

    // Reset photo preview
    var preview = document.getElementById('reportPhotoPreview');
    if (preview) { preview.style.display = 'none'; preview.src = ''; }

    // Apply color themes
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

    // Initialize Google Maps Location Picker
    setTimeout(function() {
        var centerPos = { lat: 27.6781, lng: 85.3803 };
        if (leafletMainMap) {
            var c = leafletMainMap.getCenter();
            centerPos = { lat: c.lat, lng: c.lng };
        }

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(pos) {
                centerPos = { lat: pos.coords.latitude, lng: pos.coords.longitude };
                initPickerMap(centerPos);
            }, function() {
                initPickerMap(centerPos);
            }, { enableHighAccuracy: true, timeout: 5000 });
        } else {
            initPickerMap(centerPos);
        }
    }, 150);
}

/**
 * Initializes the Google Maps picker inside the report modal.
 */
function initPickerMap(centerPos) {
    if (!googleModalMap) {
        googleModalMap = new google.maps.Map(document.getElementById('pickerMap'), {
            center: centerPos, zoom: 16,
            disableDefaultUI: true, zoomControl: true, mapTypeId: 'satellite'
        });
        googleModalMarker = new google.maps.Marker({
            position: centerPos, map: googleModalMap, draggable: true,
            animation: google.maps.Animation.DROP
        });
        // Sync marker position with hidden input
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
}

function closeModal() {
    document.getElementById('reportModal').classList.add('hidden');
}

// --- INCIDENT DETAIL VIEW ---
var activeIncidentLat = null;
var activeIncidentLng = null;

/**
 * Populates and shows the detailed view of a reported incident.
 */
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

/**
 * Auto-navigates the main map to the selected incident.
 */
function locateIncidentOnMap() {
    closeDetailModal();
    if (activeIncidentLat && activeIncidentLng && leafletMainMap) {
        // Find and switch to map tab
        var heatmapTab = document.getElementById('tab-heatmap');
        if (heatmapTab) {
            document.querySelectorAll('.tab-content').forEach(function(t) { t.classList.remove('active'); });
            heatmapTab.classList.add('active');
            document.querySelectorAll('.sidebar-nav .nav-item').forEach(function(n) { n.classList.remove('active'); });
            var navItems = document.querySelectorAll('.sidebar-nav .nav-item');
            if (navItems.length > 2) navItems[2].classList.add('active');
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

// --- SUPPORT MODAL ---
function openSupportModal() {
    var modal = document.getElementById('supportModal');
    if (modal) modal.classList.remove('hidden');
    if (typeof lucide !== 'undefined') lucide.createIcons();
}
function closeSupportModal() {
    var modal = document.getElementById('supportModal');
    if (modal) modal.classList.add('hidden');
}

/**
 * Handles support form submission via AJAX.
 */
function submitSupportForm(contextPath) {
    var form = document.getElementById('supportForm');
    var email = form.querySelector('[name="email"]').value;
    var subject = form.querySelector('[name="subject"]').value;
    var message = form.querySelector('[name="message"]').value;
    if (!subject.trim() || !message.trim()) {
        showToast('Please fill in subject and message.', 'error');
        return;
    }
    performAction(contextPath + '/support/send', { email: email, subject: subject, message: message }, function(data) {
        if (data.success) {
            showToast('Message sent to admin successfully!', 'success');
            closeSupportModal();
            form.reset();
        } else {
            showToast('Failed to send message. Try again.', 'error');
        }
    });
}

// --- SETTINGS MODAL ---
function openSettingsModal() {
    var modal = document.getElementById('settingsModal');
    if (modal) modal.classList.remove('hidden');
    var cb = document.getElementById('themeToggleCheckbox');
    if (cb) cb.checked = (document.documentElement.getAttribute('data-theme') === 'light');
    if (typeof lucide !== 'undefined') lucide.createIcons();
}
function closeSettingsModal() {
    var modal = document.getElementById('settingsModal');
    if (modal) modal.classList.add('hidden');
}

// --- SEARCH & FILTER (User Dashboard) ---
/**
 * Local DOM filtering for report cards based on search text and dropdowns.
 */
function filterReports() {
    var keyword = document.getElementById('searchInput').value.toLowerCase();
    var category = document.getElementById('filterCategory') ? document.getElementById('filterCategory').value : 'all';
    var status = document.getElementById('filterStatus') ? document.getElementById('filterStatus').value : 'all';
    document.querySelectorAll('#reportsGrid .report-card').forEach(function(card) {
        var show = true;
        if (keyword && (card.getAttribute('data-search') || '').toLowerCase().indexOf(keyword) === -1) show = false;
        if (category !== 'all' && card.getAttribute('data-category') !== category) show = false;
        if (status !== 'all' && card.getAttribute('data-status') !== status) show = false;
        card.style.display = show ? '' : 'none';
    });
}

// --- PHOTO PREVIEW ---
/**
 * Renders a local preview of the selected image before upload.
 */
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
