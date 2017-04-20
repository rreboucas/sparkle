({
    
    showOppmodal: function(component, event, helper) {
        
        // handle the application event and set the record id to the recordId attribute:
        console.log("showOppmodal entered");
        var params = event.getParams();
        component.set("v.recordId", params.recordId);
        
        var recId = component.get("v.recordId");
        console.log("GenericListModalController - recId: " + recId);
        helper.getRecord(component);
        console.log("GenericListModalController - finished getting records, so now unhide the modal");
        var listHasRecords = component.get("v.hasRecords");
        console.log("GenericListModalController - listHasRecords: " + listHasRecords);
		//helper.toggleClass(component,'backdrop','slds-backdrop--');
		//helper.toggleClass(component,'modaldialog','slds-fade-in-');
		
        event.stopPropagation();
        console.log("showOppmodal exited");
	},

	hideModal : function(component, event, helper) {
        console.log("hideModal entered");
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
        console.log("hideModal exited");
	}
})