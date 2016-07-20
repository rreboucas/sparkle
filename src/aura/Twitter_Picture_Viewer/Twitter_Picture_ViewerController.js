({
	doInit : function(component, event, helper) {
        
        console.log("TwitterPictureController.doInit: entered");
        

        helper.getTwitterPicture(component);

        console.log("TwitterPictureController.doInit: exit");
        
	},
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("TwitterPictureController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.candidateID);
    	        
     	helper.getTwitterPicture(component);
        

        console.log("TwitterPictureController.handleApplicationEvent: exit");
        
	}
})