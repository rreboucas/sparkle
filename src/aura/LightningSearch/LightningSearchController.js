({
	doInit : function(component, event, helper) {
        
        console.log("LightningSearchController.doInit: entered");
        

        	helper.getContacts(component);
        

        console.log("LightningSearchController.doInit: exit");
        
	},
    
    searchKeyChange: function(component, event, helper) {
        console.log("LightningSearchController.searchKeyChange: entered");

        var keyVar = component.find("searchArea").get("v.value");

        console.log("keyVar: " + keyVar);
        component.set("v.searchKey", keyVar);

        helper.getContacts(component);
        
        console.log("LightningSearchController.searchKeyChange: entered");
    }
})