// Module-level variables
let map;
let marker;

// Function to update form fields with address data
function updateAddressFields(lat, lng) {
  fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&format=json`)
    .then(response => response.json())
    .then(data => {
      const address = data.address;
      
      // Update coordinates display
      document.getElementById('location-coordinates').textContent = 
        `${lat.toFixed(6)}, ${lng.toFixed(6)}`;

      if (!window.isReadonly) {
        // Update form fields if they exist
        const streetField = document.querySelector('input[name="user[street]"]');
        const cityField = document.querySelector('input[name="user[city]"]');
        const zipField = document.querySelector('input[name="user[zip]"]');

        if (streetField) {
          const street = [address.house_number, address.road].filter(Boolean).join(' ');
          streetField.value = street;
        }

        if (cityField) {
          cityField.value = address.city || address.town || address.village || '';
        }

        if (zipField) {
          zipField.value = address.postcode || '';
        }
      }
    })
    .catch(error => {
      console.error('Error fetching address:', error);
    });
}

// Function to handle marker movement
function onMarkerMove(e) {
  const position = e.target.getLatLng();
  updateAddressFields(position.lat, position.lng);
}

// Function to initialize map with saved coordinates
function initializeWithSavedCoordinates(lat, lng) {
  map.setView([lat, lng], 13);
  
  // Add marker
  marker = L.marker([lat, lng], { 
    draggable: !window.isReadonly 
  }).addTo(map);
  
  if (!window.isReadonly) {
    marker.on('dragend', onMarkerMove);
  }
  
  // Update coordinates display
  document.getElementById('location-coordinates').textContent = 
    `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
}

// Function to initialize map with user's current location
function initializeWithGeolocation() {
  if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(function(position) {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      
      // Update map view
      map.setView([lat, lng], 13);
      
      // Add draggable marker
      marker = L.marker([lat, lng], { 
        draggable: !window.isReadonly 
      }).addTo(map);
      
      if (!window.isReadonly) {
        marker.on('dragend', onMarkerMove);
      }
      
      // Initial address lookup
      updateAddressFields(lat, lng);
      
      // Add accuracy circle
      const circle = L.circle([lat, lng], {
        color: '#007bff',
        fillColor: '#007bff',
        fillOpacity: 0.1,
        radius: position.coords.accuracy
      }).addTo(map);
      
    }, function(error) {
      document.getElementById('location-coordinates').textContent = 
        'Unable to get location: ' + error.message;
    });
  } else {
    document.getElementById('location-coordinates').textContent = 
      'Geolocation is not supported by your browser';
  }
}

// Initialize map when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Initialize the map
  map = L.map('map').setView([0, 0], 2);
  
  // Add OpenStreetMap tiles
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  // Initialize map based on saved coordinates or geolocation
  if (window.savedLat && window.savedLng) {
    initializeWithSavedCoordinates(window.savedLat, window.savedLng);
  } else {
    initializeWithGeolocation();
  }

  if (!window.isReadonly) {
    // Allow clicking on map to set location
    map.on('click', function(e) {
      const lat = e.latlng.lat;
      const lng = e.latlng.lng;

      // Update or create marker
      if (marker) {
        marker.setLatLng([lat, lng]);
      } else {
        marker = L.marker([lat, lng], { draggable: true }).addTo(map);
        marker.on('dragend', onMarkerMove);
      }

      updateAddressFields(lat, lng);
    });
  }
}); 