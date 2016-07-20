({
    jsLoaded: function(component, event, helper) {

        /*setTimeout(function() {
            var map = L.map('map', {zoomControl: true})
                        .setView([37.784173, -122.401557], 14);
            L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                {
                    attribution: 'Tiles © Esri'
                }).addTo(map);
            component.set("v.map", map);
        }); */
        
        component.rerender();

    },
    
    
    candidatesLoaded: function(component, event, helper) {

    // Add markers
    var map = component.get('v.map');
    var markers = component.get('v.markers');
    var candidates = event.getParam('candidates');
        console.log('CandidateMapController.candidatesLoaded - candidates: ' + candidates);
        
    // Remove existing markers
        if (markers) {
            markers.clearLayers();
        }
    if (map && candidates && candidates.length> 0) {
    
    for (var i=0; i<candidates.length; i++) {
        var candidate = candidates[i];
        console.log('CandidateMapController.candidatesLoaded - candidate: ' + candidate);
        var latLng = [candidate.testautonumdata__Geolocation__Latitude__s , candidate.testautonumdata__Geolocation__Longitude__s ];
		console.log('CandidateMapController.candidatesLoaded - latLng: ' + latLng);
        //L.marker(latLng, {candidate: candidate}).addTo(map);
        var latd = parseFloat(candidate.testautonumdata__Geolocation__Latitude__s) - 0.00;
        console.log('CandidateMapController.candidatesLoaded - latd: ' + latd);
        var longtd = parseFloat(candidate.testautonumdata__Geolocation__Longitude__s) - 0.00;
        console.log('CandidateMapController.candidatesLoaded - longtd: ' + longtd);
        

        map.panTo([latd, longtd]);
        L.marker(latLng, {candidate: candidate}).addTo(map);
        //map.setView([latd, longtd], 14);
        //
        var cmpEvent = component.getEvent("bubblingEvent");
        console.log('cmpEvent: ' + cmpEvent);
        // Optional: set some data for the event (also known as event shape)
        var city = candidate.testautonumdata__City__c;
        var state = candidate.testautonumdata__State__c;
        cmpEvent.setParams({"city" : city });
        console.log('city: ' + city);
        cmpEvent.setParams({"state" : state });
        console.log('state: ' + state);
        cmpEvent.fire();

        
    	}
    }
        
	},
    
    candidateSelected: function(component, event, helper) {
    
    // Center the map on the account selected in the list
    console.log('CandidateMapController.candidateSelected - candidate: ');
    var map = component.get('v.map');
    var candidate = event.getParam("candidate");
    map.panTo([candidate.testautonumdata__Geolocation__Latitude__s, candidate.testautonumdata__Geolocation__Longitude__s]);
	}
})