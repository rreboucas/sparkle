({
	getTwitterUserDetails : function(cmp) {
        
        $A.log("TwitterUserDetailsHelper.getTwitterUserDetails: entered");
        var recObject = cmp.get("v.record");
        
        var action = cmp.get("c.getTwitterUser");
        action.setParams({ 
            twitterName : recObject.twitterName,
            firstName  : recObject.firstName,
            lastName  : recObject.lastName,
            companyName  : recObject.companyName,
            email  : recObject.email
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.rec", response.getReturnValue());
				cmp.set("v.hasRecords", true);
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
                        $A.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    $A.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        $A.log("TwitterUserDetailsHelper.getTwitterUserDetails: exit");
	    }
})