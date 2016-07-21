({
	OpenInstructionsPage:function(component,event,helper) {
        
        $A.log("ProjectSparkleLCsInfoController.OpenInstructionsPage: entered");


        // Navigvate to VF Page:
        
        var instURL = component.get("v.instructionsPageURL");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": instURL
        });
        urlEvent.fire();
        
        
        $A.log("ProjectSparkleLCsInfoController.OpenInstructionsPage: exit");
	}
})