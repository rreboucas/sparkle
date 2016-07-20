({
	handleApplicationEvent : function(component, event, helper) {
        
        console.log("CandidateRecordMarkerController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.candidateID);
    	
        var recId = component.get("v.recordId");  
        console.log("CandidateRecordMarkerController.recId: " + recId);
    	//get map location
    	
        var action = component.get("c.findCandidateByID");
         action.setParams({ 
            candidateID  : recId
        });

        
            
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("CandidateRecordMarkerController.state: " + state);
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                console.log('response.getReturnValue(): ' + response.getReturnValue());
                component.set("v.candidates", response.getReturnValue());
                
                var appEvent = $A.get("e.c:CandidatesLoaded");
                console.log('appEvent: ' + appEvent);
                var returnedRecords = component.get("v.candidates");
                
                appEvent.setParams({ "candidates": returnedRecords });
        		appEvent.fire();

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

                
        $A.enqueueAction(action);
        
        
        
        
    	

        $A.log("CandidateRecordMarkerController.handleApplicationEvent: exit");
        
	}
})