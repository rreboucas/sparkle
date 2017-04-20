({
    
    /*Use this for passing in the parameters for fields in the email template
     * var action = cmp.get("c.getEmailTemplates");
        action.setParams({ 
            parameters to put into apex class
            ID : cmp.get("v.emailTemplateId"),
            firstName  : cmp.get("v.CandidateFirstName"),
            lastName  : cmp.get("v.CandidateLastName"),
            companyName  : cmp.get("v.ObjectCompanyNameAPIField"),
            Salary  : cmp.get("v.Salary")
            Bonus  : cmp.get("v.Bonus")
        });*/
    
    
    getListRecords : function(cmp) {
    console.log("OfferLetterSPAHelper.getListRecords: entered");
    var action = cmp.get("c.getEmailTemplatesNames");

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

                console.log("InterviewListHelper: lstRecs" + lstRecs); 
                // Put all record ids in a comma-delimetted string to pass to other components like a map using an application event

                
              
                
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
        
        console.log("OfferLetterSPAHelper.getListRecords: exit");
    }
})