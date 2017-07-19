({
	getListRecords : function(cmp) {
    console.log("OfferDetailsHelper.getListRecords: entered");
        
        var cId = cmp.get("v.candidateId");
        console.log("Candidate ID: " + cId);
        
    var action = cmp.get("c.getEmailTemplatesNames");
        
        action.setParams({ 
            candidateID : cId
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
        
        console.log("OfferDetailsHelper.getListRecords: exit");
    },
    
    createOfferAndNavigate : function(cmp) {
    	console.log("OfferDetailsHelper.createOffer: entered");
        
        var cId = cmp.get("v.candidateId");
        console.log("Candidate ID: " + cId);
        
        var salary = cmp.get("v.enteredSalary");
        console.log("Salary: " + salary);
        
        var bonus = cmp.get("v.enteredBonus");
        console.log("Bonus: " + bonus);
        
        var ofId = cmp.get("v.offerId");
        console.log("ofId: " + ofId);
        
    	var action = cmp.get("c.upsertOfferRecord");
        
        action.setParams({ 
            offerId : ofId,
            candidateID : cId,
            annualSalary : salary,
            annualBonus : bonus
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.offerId", response.getReturnValue());
                
                var offerIdVal = cmp.get("v.offerId");

                console.log("Offer ID Value: " + offerIdVal);    
        
        
               
                
                
                var lstRecs = cmp.get("v.lstRecords");
                
                //Pass the values grabbed from this LC Form + Candidate ID to the next child LC via Lightning Events:
                var appEvent = $A.get("e.c:CandidateDetailEvent");
                appEvent.setParams({ "candidateID" : cmp.get("v.candidateId"),
                                     "enteredSalary" : cmp.get("v.enteredSalary"),
                                     "enteredBonus" : cmp.get("v.enteredBonus"),
                                     "selectedTemplateId" : cmp.get("v.selectedTemplateId"),
                                    "offerId": offerIdVal,
                                    "email": lstRecs[0].candidateEmail,
                                    "LCWhoFired": 'OfferDetails.cmp'
                                   });
                
                
                
                
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

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
        
        console.log("OfferDetailsHelper.createOffer: exit");
    }
})