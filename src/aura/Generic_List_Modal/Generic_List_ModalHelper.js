({
	toggleClass: function(component,componentId,className) {
        console.log("helper.toggleClass entered");
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
        console.log("helper.toggleClass exit");
	},

	toggleClassInverse: function(component,componentId,className) {
        console.log("helper.toggleClassInverse entered");
		var modal = component.find(componentId);
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
        console.log("helper.toggleClassInverse exit");
	},
    
    getRecord: function(component) {
    console.log("GenericListModal_helper.getRecord entered");
	var action = component.get("c.getListRecords");
        
        action.setParams({ 
            recordId : component.get("v.recordId"),
            objectApiName : component.get("v.objectApiName"),
            column1 : component.get("v.Modal_column1_fieldapiname"),
            column2 : component.get("v.Modal_column2_fieldapiname"),
            column3 : component.get("v.Modal_column3_fieldapiname"),
            column4 : component.get("v.Modal_column4_fieldapiname")
        });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lstRecords", response.getReturnValue());
				component.set("v.hasRecords", true);
                var lstHasRecords = component.get("v.hasRecords");
                console.log("GenericListModal_helper - records returned - lstHasRecords: " + lstHasRecords);
                this.toggleClass(component,'backdrop','slds-backdrop--');
                this.toggleClass(component,'modaldialog','slds-fade-in-');
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
        console.log("helper.getRecord exit");
	    }
})