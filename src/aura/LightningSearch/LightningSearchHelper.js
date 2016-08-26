({
	getContacts : function(component, callback) {
        console.log("LightningSearchHelper.getContacts: entered");
			var attributeValue = component.get("v.searchKey");	
        	console.log("attributeValue: " + attributeValue);
        
            var action = component.get("c.findByName");
            action.setParams({
                "name": attributeValue
            });

            // Setup the CallBack
            var self = this;
            action.setCallback(this, function(actionResult)
            {
                //Reset the value of the component list attribute with the records returned
                //debugger;
                var retvals = actionResult.getReturnValue();
                console.log("Returned Values: " + actionResult.getReturnValue()); 
                
                component.set("v.lstContacts", actionResult.getReturnValue());                   
            });
            
            //Enqueue the action      
            $A.enqueueAction(action);
            
            console.log("LightningSearchHelper.getContacts: exited");
		//}
	}
})