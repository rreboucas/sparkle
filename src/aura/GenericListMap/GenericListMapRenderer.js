({
    rerender: function (component, helper) {

        var nodes = this.superRerender();

        // If Leaflet library is not yet loaded, we can't draw the map: return
        if (!window.L) return nodes;

        var map = component.get("v.map");
        
        // Draw the map if it hasn't been drawn yet
        if (!map) {
            var mapElement = component.find("map").getElement();
            //map = window.L.map(mapElement, {zoomControl: true});
            map = window.L.map(mapElement, {zoomControl: true})
                        .setView([37.791594 , -122.397459], 15);
            window.L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                {
                    attribution: 'Tiles © Esri'
                }).addTo(map);
            component.set("v.map", map);
            var markers = new window.L.FeatureGroup();
            component.set("v.markers", markers);
            
            // If we had received accounts before Leaflet was loaded, add markers for these accounts
            helper.addMarkers(component);
        }
        
        return nodes;

    }
})