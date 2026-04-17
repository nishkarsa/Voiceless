let leafletMainMap; // For the dashboard
let googleModalMap; // For the modal
let googleModalMarker;

// --- 1. INITIALIZE LEAFLET DASHBOARD ON LOAD ---
document.addEventListener("DOMContentLoaded", function() {
    
    // Default location: Bagmati Province area
    const defaultLocation = [27.6781, 85.3803]; 
    const mapElement = document.getElementById('map');
    
    if (mapElement) {
        leafletMainMap = L.map('map', {zoomControl: false}).setView(defaultLocation, 11);
        
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(leafletMainMap);

        // Add Leaflet Heatmap
        if (typeof heatmapPoints !== 'undefined' && heatmapPoints.length > 0) {
            L.heatLayer(heatmapPoints, {
                radius: 25,
                blur: 15,
                maxZoom: 15,
                gradient: {0.4: '#5b6e54', 0.65: '#d97706', 1: '#dc2626'} 
            }).addTo(leafletMainMap);
        }

        setTimeout(() => { leafletMainMap.invalidateSize(); }, 250);

        // Geolocation
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                leafletMainMap.setView([position.coords.latitude, position.coords.longitude], 13);
            });
        }
    }
});

// --- 2. INITIALIZE GOOGLE MAPS IN MODAL ---
function openThemedModal(type) {
    const modal = document.getElementById('reportModal');
    const contentBox = document.getElementById('modalContentBox');
    const catInput = document.getElementById('categoryInput');
    const title = document.getElementById('modalDynamicTitle');
    const desc = document.getElementById('modalDynamicDesc');

    // Theme logic
    contentBox.className = 'modal-content'; 
    if (type === 'carcass') {
        contentBox.classList.add('theme-carcass');
        catInput.value = 'Carcass';
        title.innerText = 'Report Dead Carcass';
        desc.innerText = 'Please provide details respectfully. Field staff will be dispatched.';
    } 
    else if (type === 'injured') {
        contentBox.classList.add('theme-injured');
        catInput.value = 'Injured';
        title.innerText = 'Report Injured Animal';
        desc.innerText = 'Urgent: Maintain a safe distance. Provide precise location details.';
    } 
    else if (type === 'wild') {
        contentBox.classList.add('theme-wild');
        catInput.value = 'Wild Sighting';
        title.innerText = 'Report Wild Animal';
        desc.innerText = 'Caution: Do not approach. Logging this sighting alerts the community.';
    }

    modal.classList.remove('hidden');

    // Load Google Map inside the modal after a tiny delay
    setTimeout(() => {
        // Grab the center coordinates from the Leaflet map to pass to Google Maps!
        let centerPos = { lat: 27.6781, lng: 85.3803 };
        if (leafletMainMap) {
            const leafletCenter = leafletMainMap.getCenter();
            centerPos = { lat: leafletCenter.lat, lng: leafletCenter.lng };
        }

        if (!googleModalMap) {
            // First time creating the Google Map
            googleModalMap = new google.maps.Map(document.getElementById('pickerMap'), {
                center: centerPos,
                zoom: 16,
                disableDefaultUI: true,
                zoomControl: true,
                mapTypeId: 'satellite' // Satellite view is usually best for precise wildlife pinning
            });

            googleModalMarker = new google.maps.Marker({
                position: centerPos,
                map: googleModalMap,
                draggable: true,
                animation: google.maps.Animation.DROP
            });

            // Update text input when dragging the Google pin
            googleModalMarker.addListener('dragend', () => {
                const pos = googleModalMarker.getPosition();
                document.getElementById('locationInput').value = pos.lat().toFixed(5) + ", " + pos.lng().toFixed(5);
            });

            // Move Google pin on click
            googleModalMap.addListener('click', (e) => {
                googleModalMarker.setPosition(e.latLng);
                document.getElementById('locationInput').value = e.latLng.lat().toFixed(5) + ", " + e.latLng.lng().toFixed(5);
            });
        } else {
            // Wake up existing Google Map
            google.maps.event.trigger(googleModalMap, 'resize');
            googleModalMap.setCenter(centerPos);
            googleModalMarker.setPosition(centerPos);
        }

        // Set initial coordinates
        const pos = googleModalMarker.getPosition();
        document.getElementById('locationInput').value = pos.lat().toFixed(5) + ", " + pos.lng().toFixed(5);
        
    }, 150);
}

function closeModal() {
    document.getElementById('reportModal').classList.add('hidden');
}