({
    getListRecords : function(cmp) {
    console.log("InterviewListHelper.getListRecords: entered");
    var action = cmp.get("c.getListRecords");
        action.setParams({ 
            rowsLimit : cmp.get("v.limitRows"), 
            objectApiName : cmp.get("v.objectApiName"),
            filter1Field : cmp.get("v.filter1_fieldapiname"),
            filter1Value : cmp.get("v.filter1_fieldValue"),
            eventField : cmp.get("v.eventIDField"),
            column1 : cmp.get("v.column1_fieldapiname"),
            column2 : cmp.get("v.column2_fieldapiname"),
            column3 : cmp.get("v.column3_fieldapiname"),
            column4 : cmp.get("v.column4_fieldapiname"),
            sortField : cmp.get("v.sortFieldName"),
            sortDirection : cmp.get("v.sortDirection")
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
                
                var lstRecs = cmp.get("v.lstRecords");
                cmp.set("v.listSize", lstRecs.length);
                cmp.set("v.lastSortFieldName", cmp.get("v.sortFieldName"));
                cmp.set("v.lastSortDirection", cmp.get("v.sortDirection"));
                
                
                var lstRecs = cmp.get("v.lstRecords");
                console.log("InterviewListHelper: lstRecs" + lstRecs); 
                // Put all record ids in a comma-delimetted string to pass to other components like a map using an application event
                
                var recordIdsString;
                
              
                
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
        
        console.log("InterviewListHelper.getListRecords: exit");
    },

    getRunningUser : function(cmp) {
    console.log("InterviewListHelper.getRunningUser: entered");
    var action = cmp.get("c.getCurrentUser");

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.runningUser", response.getReturnValue());   
                
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
        
        console.log("InterviewListHelper.getRunningUser: exit");
    }
})