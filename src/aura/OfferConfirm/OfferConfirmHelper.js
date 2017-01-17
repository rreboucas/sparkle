({
	sendOfferbyEmail : function(cmp) {
    console.log("OfferConfirmHelper.sendOfferbyEmail: entered");
        
        var cBody = cmp.get("v.templateVal");
        console.log("cBody: " + cBody);
        
        var cSubject = cmp.get("v.templateSubjectVal");
        console.log("cSubject: " + cSubject);
        
        var cEmail = cmp.get("v.email");
        console.log("cEmail: " + cEmail);
        
        var offId = cmp.get("v.offerId");
        console.log("offId: " + offId);
        
    var action = cmp.get("c.sendEmail");
        
        action.setParams({ 
            body : cBody,
            subject : cSubject,
            email : cEmail,
            offerId : offId
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.sendResult", response.getReturnValue());
                
                var strResult = cmp.get("v.sendResult");

                console.log("Send Results: " + strResult); 
                
                
                // Dynamically create Icon in the LC Body based on the results:

				if (strResult.SendSuccessful == true)
                {
                   $A.createComponent(
                "lightning:icon",
                {
                    "aura:id": "findableAuraId",
                    "iconName": "action:approval",
                    "size": "large"
                },
                function(newIcon, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(newIcon);
                        cmp.set("v.body", body);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
              ); 
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
        
        console.log("OfferConfirmHelper.sendOfferbyEmail: exit");
    }
})