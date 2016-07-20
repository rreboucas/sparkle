({
	getReferrals : function(cmp) {
        
        console.log("CandidateReferralsHelper.getReferrals: entered");
        
        var recId = cmp.get("v.recordId");
        console.log("recId: " + recId);
        
        var action = cmp.get("c.getListRecords");
        action.setParams({ 
            rowsLimit : cmp.get("v.limitRows"),
            recordId  : cmp.get("v.recordId"),
            objectApiName  : cmp.get("v.objectApiName"),
            ParentObjectFieldName  : cmp.get("v.ParentObjectRelationshipField"),
            filter1Field  : cmp.get("v.filter1_fieldapiname"),
            filter1Value  : cmp.get("v.filter1_fieldValue"),
            column1  : cmp.get("v.column1_fieldapiname"),
            RelFieldWithName  : cmp.get("v.RelFieldWithName"),
            column2  : cmp.get("v.column2_fieldapiname")
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

                var lstReturned = cmp.get("v.lstRecords");
                cmp.set("v.listSize", lstReturned.length);
        		console.log("lstReturned: " + lstReturned);
                

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
        
	    }
})