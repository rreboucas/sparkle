({
    doInit : function(component, event) {
        var action = component.get("c.findAll");
        
        // Rodrigo's code change : start
            
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                component.set("v.candidates", response.getReturnValue());
                
                
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
                
                var appEvent = $A.get("e.c:CandidatesLoaded");
                console.log('appEvent: ' + appEvent);
				//var appEvent = $A.get("e.c:CandidatesLoaded");
                var returnedRecords = component.get("v.candidates");
                
                appEvent.setParams({ "candidates": returnedRecords });
        		appEvent.fire();
                
            	//appEvent.setParams({"candidates": reurnedRecords});
            	//appEvent.fire();
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
    },
    
    /*Handler for the application event*/
     handleApplicationEvent : function(component, event, helper) {
        
        console.log("CandidateListControllerApp.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.candidateID);
    	        
    	//get map location
        var action = component.get("c.findCandidateByID");
         action.setParams({ 
            candidateID  : component.get("v.recordId")
        });

        
            
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
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
        
        
        
        
    	

        $A.log("CandidateListControllerApp.handleApplicationEvent: exit");
        
	}
})