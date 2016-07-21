({
    doInit : function(component, event, helper) {
        
        console.log("GenericListMapController.doInit: entered");
        
        var geoField = component.get("v.geoLocationFieldApiName");
        if (geoField)
        {
            var latFieldV = geoField.replace("__c", "__Latitude__s");
            component.set("v.latitudeFieldName", latFieldV);
            
            var longFieldV = geoField.replace("__c", "__Longitude__s");
            component.set("v.longitudeFieldName", longFieldV);
        }
        

        console.log("GenericListMapController.doInit: exit");
        
    },
    
    jsLoaded: function(component, event, helper) {

        component.rerender();
        
        /*setTimeout(function() {
            var map = L.map('map', {zoomControl: true})
                        .setView([37.791594 , -122.397459], 15);
            L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
                {
                    attribution: 'Tiles © Esri'
                }).addTo(map);
            component.set("v.map", map);
        });*/
    },
    
    handleRecordListEvent : function(component, event, helper) {
        
        console.log("GenericListMapController.handleRecordListEvent: entered");
        
        var params = event.getParams();
        component.set("v.lstRecordIDs", params.recordIdsParameter);
                
        var idsReceived = component.get("v.lstRecordIDs");
        console.log("GenericListMapController.handleRecordListEvent idsReceived: " + idsReceived);
        
        helper.getListRecords(component); 
        helper.addMarkers(component);
        
        console.log("GenericListMapController.handleRecordListEvent: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("GenericListMapController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("GenericListMapController: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("GenericListMapController: ltng:SelectSobject - channel = " + params.channel);
                
        
        var recId = component.get("v.recordId");
                
        var map = component.get('v.map'); 
        
        var markers = component.get("v.markersList");
        if (markers && recId)
        {
            for (var i in markers)
            {
                var markerID = markers[i].options.title;
                if (markerID == recId){
                    markers[i].openPopup();
                }
            }
        }
        

        console.log("GenericListMapController.handleApplicationEvent: exit");
        
    }
})