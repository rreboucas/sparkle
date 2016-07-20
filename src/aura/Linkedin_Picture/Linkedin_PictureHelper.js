({
	getLinkedinPicture : function(cmp) {
        
        console.log("Linkedin_PictureHelper.getLinkedinPicture: entered");
        
        var recId = cmp.get("v.recordId");
        console.log("recId: " + recId);
        
        var action = cmp.get("c.getLinkedinPicture");
        action.setParams({ 
            recordID : cmp.get("v.recordId"),
            objectApiName  : cmp.get("v.objectApiName"),
            linkedinIDFieldApiName  : cmp.get("v.linkedinIDFieldApiName")
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            // This callback doesn’t reference cmp. If it did,
            // you should run an isValid() check
            //if (cmp.isValid() && state === "SUCCESS") {
            if (state === "SUCCESS") {
                cmp.set("v.pictureURL", response.getReturnValue());

                var strPictureURL = cmp.get("v.pictureURL");
        		console.log("pictureURL: " + strPictureURL);
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
        console.log("Linkedin_PictureHelper.getLinkedinPicture: exit");
	    }
})