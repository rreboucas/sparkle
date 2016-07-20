({
	getListRecords : function(cmp) {
    console.log("GenericListMapHelper.getListRecords: entered");
	var action = cmp.get("c.getListRecords");
        action.setParams({ 
            recordIds : cmp.get("v.lstRecordIDs"), 
            objectApiName : cmp.get("v.objectApiName"),
            NameField : cmp.get("v.nameFieldApiName"),
            latField : cmp.get("v.latitudeFieldName"),
            longField : cmp.get("v.longitudeFieldName"),
            CityField : cmp.get("v.cityFieldApiName"),
            StateField : cmp.get("v.stateFieldApiName")
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.lstRecords", response.getReturnValue());
				
                /*
                
                var lstRecs = cmp.get("v.lstRecords");
                
                console.log("GenericListMapHelper.getListRecords: lstRecs" + lstRecs); 
 				
                var markers = cmp.get('v.markers');
				 if (markers) {
                        markers.clearLayers();
                    }
                
                var latd;
                var longtd;
                var map = cmp.get('v.map');
                console.log("GenericListMapHelper.getListRecords: map" + map); 
                var markerArray = []; 
                if (map && lstRecs && lstRecs.length> 0)
                {
                    console.log("map && lstRecs && lstRecs.length> 0 is true"); 
                    for (var i=0; i<lstRecs.length; i++) 
                    {
                    var rec = lstRecs[i];
                    console.log('GenericListMapHelper - rec: ' + rec);
    
                    var latValue = rec['LatValue'];
                    var longValue = rec['LongValue'];
                    
                    var latLng = [latValue , longValue ];
                    console.log('GenericListMapHelper - latLng: ' + latLng);
                    latd = parseFloat(latValue) - 0.0100;
                    console.log('GenericListMapHelper - latd: ' + latd);
                    longtd = parseFloat(longValue) + 0.0189;
                    console.log('GenericListMapHelper - longtd: ' + longtd);
                    
                    var nameValue = rec['Name'];
                    var cityValue = rec['City'];
                    var stateValue = rec['State'];
                    var recIdValue = rec['recordID'];
                    
                    if (latLng && recIdValue && map)
                    {
                        var marker = window.L.marker(latLng,{title:recIdValue}).addTo(map).bindPopup("<b>"+ nameValue + "</b><br />" + cityValue + ", " + stateValue).openPopup();
                        markers.addLayer(marker);
                        markerArray.push(marker); 
                        if (i==0) map.panTo(latLng);
                    }  
                    
                    }
                    //map.panTo([latd, longtd]);
                    
                    cmp.set("v.markersList", markerArray);
                }
            */    
            }
            //else if (cmp.isValid() && state === "INCOMPLETE") {
            else if (state === "INCOMPLETE") {
                // do something
            }
            //else if (cmp.isValid() && state === "ERROR") {
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
        console.log("GenericListMapController.getListRecords: exit");
    },
    
    addMarkers: function(component) {
        console.log("GenericListMapHelper.addMarkers: entered");
        var map = component.get('v.map');
        var markers = component.get('v.markers');
        var records = component.get('v.lstRecords');
        var markerArray = []; 
        // Remove existing markers
        if (markers) {
        	markers.clearLayers();
        }
        
        // Add Markers
		if (map && records && records.length> 0) {
            
            for (var i=0; i<records.length; i++) {
                
                var rec = records[i];
                var latValue = rec['LatValue'];
                var longValue = rec['LongValue'];
                var nameValue = rec['Name'];
                var cityValue = rec['City'];
                var stateValue = rec['State'];
                var recIdValue = rec['recordID'];
                if (latValue && longValue) {
	                var latLng = [latValue, longValue];
    	            var marker = window.L.marker(latLng,{title:recIdValue}).addTo(map).bindPopup("<b>"+ nameValue + "</b><br />" + cityValue + ", " + stateValue).openPopup();
                    markers.addLayer(marker);
                    markerArray.push(marker); 
					if (i==0) map.panTo(latLng);    
                }
            }
            component.set("v.markersList", markerArray);
            map.addLayer(markers);
        }
        console.log("GenericListMapHelper.addMarkers: entered");
    }
    
    
})