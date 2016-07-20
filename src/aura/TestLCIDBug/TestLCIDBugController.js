({
	doInit : function(cmp, event, helper) {
        
        var action = cmp.get("c.getServerData");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.lstRecords", response.getReturnValue());
                var list = cmp.get("v.lstRecords");
                console.log("list" + list);
            }
            else if (state === "INCOMPLETE") {
            }
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

        $A.enqueueAction(action);
        
	},
    
    fireApplicationEvent : function(component, event, helper) {
		var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        console.log('data Name = '+ Name);
        
    }
})