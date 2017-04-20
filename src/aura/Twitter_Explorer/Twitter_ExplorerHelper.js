({
	checkTwitterId : function(cmp) {
        
        console.log("Twitter_ExplorerHelper.checkTwitterId: entered");
        
        var recId = cmp.get("v.recordId");
        console.log("recId: " + recId);
        
        var action = cmp.get("c.getRecordDetails");
        action.setParams({ 
            recordID : cmp.get("v.recordId"),
            objectApiName  : cmp.get("v.objectApiName"),
            twitterIDFieldApiName  : cmp.get("v.TwitterIDFieldApiName"),
            firstName  : cmp.get("v.ObjectFirstNameAPIField"),
            lastName  : cmp.get("v.ObjectLastNameAPIField"),
            companyName  : cmp.get("v.ObjectCompanyNameAPIField"),
            email  : cmp.get("v.ObjectEmailAPIField")
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
                //cmp.set("v.hasId", response.getReturnValue());

                var record = cmp.get("v.rec");
        		console.log("record: " + record);

        		if (record.hasTwitterMemberID)
        		{
                    console.log("record has TwitterMember ID");
                    // fire the Twitter Component Event with the returned record

                    var appEvent = $A.get("e.c:TwitterRecordEvent");
                    // Optional: set some data for the event (also known as event shape)
                    appEvent.setParams({"recordDetails" : record });
                    appEvent.fire();

        			//show the user details component
        			var toggleText = cmp.find("userdetails");
					$A.util.removeClass(toggleText,'toggle');

        		}
        		else
        		{
                    console.log("record doesnt have TwitterMember ID");
        			//show the user search component
        			var toggleText = cmp.find("searchusers");
					$A.util.removeClass(toggleText,'toggle');
        		}

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
        console.log("Twitter_ExplorerHelper.checkTwitterId: exit");
	    }
})