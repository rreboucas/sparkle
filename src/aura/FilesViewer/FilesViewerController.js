({
	doInit : function(component, event, helper) {
        
        console.log("FilesViewerController.doInit: entered");
			
        // Hide the modal popup LC using CSS
		//var toggleText = component.find("modal");
		//$A.util.addClass(toggleText,'toggle');
        
        var toggleText = component.find("modal");
        $A.util.addClass(toggleText,"slds-hide");
        
            helper.getListRecords(component);

        console.log("FilesViewerController.doInit: exit");
        
	},
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("FilesViewerController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.candidateID);
    	        
     	helper.getListRecords(component);
        

        console.log("FilesViewerController.handleApplicationEvent: exit");
        
	},
    
    viewModal : function(component, event) {
	// Open Modal
		var toggleText = component.find("modal");
        $A.util.removeClass(toggleText,"slds-hide");
    },
    
    hideModal : function(component, event) {
	// Close Modal
		var toggleText = component.find("modal");
        $A.util.addClass(toggleText,"slds-hide");
    }
})