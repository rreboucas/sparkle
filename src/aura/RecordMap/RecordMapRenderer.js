({
    rerender: function (component, helper) {

        var nodes = this.superRerender();

        // If Leaflet library is not yet loaded, we can't draw the map: return
        if (!window.L) return nodes;

        var map = component.get("v.map");
        
        // Draw the map if it hasn't been drawn yet
        if (!map) {
            var mapElement = component.find("map").getElement();
            map = window.L.map(mapElement, {zoomControl: true});
            component.set("v.map", map);
        }
        
        return nodes;

    }
})