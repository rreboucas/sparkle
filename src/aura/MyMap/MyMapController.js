({
jsLoaded: function(component, event, helper) {
    setTimeout(function() {
        var map = L.map('map', {zoomControl: false}).setView([37.784173, -122.401557], 14);
        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'Tiles © Esri'
            }).addTo(map);

        // Add marker
        L.marker([37.784173, -122.401557]).addTo(map)
            .bindPopup('Home of Dreamforce');
        });
}
})