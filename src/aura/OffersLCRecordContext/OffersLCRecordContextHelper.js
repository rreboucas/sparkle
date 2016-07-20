({
	getOffers : function(component, callback) {
        console.log("OffersHelper.getOffers: entered");
        var attributeValue = component.get("v.recordId");
        console.log("attributeValue: " + attributeValue);

            var action = component.get("c.getOffers");
            

            action.setParams({
                "positionID": attributeValue
            });
            // Setup the CallBack
            var self = this;
            action.setCallback(this, function(actionResult)
            {
                //Reset the value of the component list attribute with the records returned
                //debugger;
                var retvals = actionResult.getReturnValue();
                console.log("Returned Values: " + actionResult.getReturnValue()); 
                
                component.set("v.lstFlwRecords", actionResult.getReturnValue());                   
            });
            
            //Enqueue the action      
            $A.enqueueAction(action);
            
            console.log("OffersHelper.getOffers: exited");
		//}
	}
})