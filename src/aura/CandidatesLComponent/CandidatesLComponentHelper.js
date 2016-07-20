({
	getCandidates : function(component, callback) {
        console.log("CandidatesLComponentHelper.getCandidates: entered");

            var action = component.get("c.getCandidates");
            

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
            
            console.log("CandidatesLComponentHelper.getCandidates: exited");
		//}
	}
})