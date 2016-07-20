({
	doInit : function(component, event, helper) {
        
        console.log("LinkedinPictureController.doInit: entered");
        

        helper.getLinkedinPicture(component);

        console.log("LinkedinPictureController.doInit: exit");
        
	},
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("LinkedinPictureController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.candidateID);
    	        
     	helper.getLinkedinPicture(component);
        

        console.log("LinkedinPictureController.handleApplicationEvent: exit");
        
	}
})