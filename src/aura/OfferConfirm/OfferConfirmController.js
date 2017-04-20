({
	handleApplicationEvent : function(component, event, helper) {
        
        console.log("OfferConfirmController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        
        console.log("LC that Fired event:  " + params.LCWhoFired);
        
        if (params.LCWhoFired == 'OfferPreview.cmp')
        {
            
        
            component.set("v.templateVal", params.offerText);
            component.set("v.templateSubjectVal", params.offerSubject);
            component.set("v.email", params.email);
            component.set("v.offerId", params.offerId);
    
            console.log("text = " + component.get("v.templateVal"));
            console.log("subject = " + component.get("v.templateSubjectVal"));
            console.log("email = " + component.get("v.email"));
            console.log("offerId = " + component.get("v.offerId"));
    
            helper.sendOfferbyEmail(component);
		}
        console.log("OfferConfirmController.handleApplicationEvent: exit");
        
    },
    
    navigateToRecord: function(component, event, helper) {
        console.log("OfferConfirmController.navigateToRecord entered");

        
        var offId = component.get("v.offerId");
        console.log('offerId = '+ offId);
        
        var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
	      "recordId": offId,
	      "isredirect": true,
	      "slideDevName": "related"
	    });
	    navEvt.fire();
        console.log("OfferConfirmController.navigateToRecord exit");
    }
})