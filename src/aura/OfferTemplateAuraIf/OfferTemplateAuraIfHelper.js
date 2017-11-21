({
	getTemplate : function(cmp) {
        
        console.log("OfferTemplateHelper.getTemplate: entered");
        
        
        var action = cmp.get("c.getEmailTemplatebyId");
        action.setParams({ 
            templateId : cmp.get("v.selectedTemplateId"),
            candidateID : cmp.get("v.recordId"),
            offerID : cmp.get("v.offerId")
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
                console.log("lstReturned: " + lstReturned);
                
                var templateSubject = lstReturned[0].emailTemplateSubject
                cmp.set("v.templateSubjectVal", templateSubject);	
                console.log("Subject: " + cmp.get("v.templateSubjectVal"));
                
                var templateBody = lstReturned[0].emailTemplateBody
                cmp.set("v.templateVal", templateBody);	
                console.log("Body: " + cmp.get("v.templateVal"));
                
                
                
                

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
        
        
        console.log("OfferTemplateHelper.getTemplate: exit");
	    },


})