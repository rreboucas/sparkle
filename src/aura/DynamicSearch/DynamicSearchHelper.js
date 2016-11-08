({
	getRecords : function(component, callback) {
        console.log("DynamicSearchHelper.getRecords: entered");
			var attributeValue = component.get("v.searchKey");
        	console.log("attributeValue: " + attributeValue);
        
            var action = component.get("c.findByKey");
            action.setParams({
            	"objectApiName" : component.get("v.objectApiName"),
            	"displayFieldName" : component.get("v.displayfieldapiname"),
                "key": attributeValue,
                "filter1Field" : component.get("v.filter1_fieldapiname"),
            	"filter1Value" : component.get("v.filter1_fieldValue")
            });

            // Setup the CallBack
            var self = this;
            action.setCallback(this, function(actionResult)
            {
                //Reset the value of the component list attribute with the records returned
                //debugger;
                var retvals = actionResult.getReturnValue();
                console.log("Returned Values: " + actionResult.getReturnValue()); 
                
                component.set("v.lstRecords", actionResult.getReturnValue());                   
            });
            
            //Enqueue the action      
            $A.enqueueAction(action);
            
            console.log("DynamicSearchHelper.getRecords: exited");
		//}
	}
})