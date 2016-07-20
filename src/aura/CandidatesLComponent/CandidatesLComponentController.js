({
	doInit : function(component, event, helper) {
        
        console.log("CandidatesLController.doInit: entered");
        

        	helper.getCandidates(component);
        	// add this to the server
        
        	//window.setImmediate();
        console.log("CandidatesLController.doInit: exit");
        
	}
})