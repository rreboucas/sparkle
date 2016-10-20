({
	doInit : function(component, event, helper) {
        
        console.log("DynamicSearchController.doInit: entered");
        

        	helper.getRecords(component);
        

        console.log("DynamicSearchController.doInit: exit");
        
	},
    
    searchKeyChange: function(component, event, helper) {
        console.log("DynamicSearchController.searchKeyChange: entered");

        var keyVar = component.find("searchArea").get("v.value");

        console.log("keyVar: " + keyVar);
        component.set("v.searchKey", keyVar);

        helper.getRecords(component);
        
        console.log("DynamicSearchController.searchKeyChange: entered");
    },
    
    navigateToRecord: function(component, event, helper) {
        console.log("DynamicSearchController.navigateToRecord entered");

        
        var selectedItem = event.currentTarget;
        var selectedRecId = selectedItem.dataset.record;
        console.log('selectedRecId = '+ selectedRecId);
        
        var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
	      "recordId": selectedRecId,
	      "isredirect": true,
	      "slideDevName": "related"
	    });
	    navEvt.fire();
        console.log("DynamicSearchController.navigateToRecord exit");
    }
})