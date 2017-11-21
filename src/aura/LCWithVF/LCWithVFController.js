({
    doInit : function(component) {
        
        // Add Event Listener for VF Post Massages:
        console.log("LCWithVFController.doInit: entered");
        var vfOrigin = "https://" + component.get("v.vfHost");
        window.addEventListener("message", function(event) {
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            }
            // Handle the message
            console.log("LCWithVFController.doInit - Received message from VF: " + event.data);
            var receivedRecId = event.data;
            // If it received a Record ID from the VF Page fire it as a standard Lightning Application Event so other LCs can receive it and refresh
            
            // Fire standard ltng:selectSobject event:
            var stdAppEvent = $A.get("e.ltng:selectSObject");
    
            stdAppEvent.setParams({ "recordId": receivedRecId, "channel": "LCWithVF.cmp" });
            stdAppEvent.fire();
                
                
                
            }, false);
        
        

        
    },
    
    
    handleApplicationEvent : function(component, event, helper) {
        console.log("LCWithVFController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        var lcWhosentRecId = params.channel;
        if(lcWhosentRecId === "Project Sparkle Interview List LC"){
            
        
            component.set("v.recordId", params.recordId);
            
            var recId = component.get("v.recordId");
            
            console.log("LCWithVFController.recId: " + recId);
            
            if (recId){
                var message = recId;
                var vfOrigin = "https://" + component.get("v.vfHost");
                var vfWindow = component.find("vfFrame").getElement().contentWindow;
                vfWindow.postMessage(message, vfOrigin);
                
                component.set("v.fetchingRecords", true);
            }
        
		}
        
		console.log("LCWithVFController.handleApplicationEvent: exit")


    },
    
    sendToVF : function(component, event, helper) {
        var message = component.get("v.message");
        var vfOrigin = "https://" + component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
    }
})