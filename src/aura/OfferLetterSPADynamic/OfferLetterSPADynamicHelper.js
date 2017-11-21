({
	createChildLC : function(cmp) {
		console.log("OfferLetterSPADynamicController.createChildLC: entered");
        
        var childLCName = cmp.get('v.childLCName');
        console.log("##### childLCName: " + childLCName);
        var attributes = cmp.get('v.attributes');
        console.log("#### attributes: " + attributes);
        
        $A.createComponent(
                childLCName,
                attributes,
                function(childLCName, status, errorMessage){
                    //Add the new button to the body array
                    if (status === "SUCCESS") {
                        var body = cmp.get("v.body");
                        body.push(childLCName);
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
	},
    
    destroyChildLC : function(cmp) {
        console.log("OfferLetterSPADynamicController.destroyChildLC: entered");
        
        //var childLCDestroyId = cmp.get('v.childLCToDestroyId');
        //console.log("##### childLCDestroyId: " + childLCDestroyId);
        
		cmp.set("v.body",[]);
        
	}
})