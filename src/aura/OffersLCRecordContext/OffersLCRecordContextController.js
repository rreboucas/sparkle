({
	doInit : function(component, event, helper) {
        
        console.log("OffersLController.doInit: entered");
        

        	helper.getOffers(component);
        

        console.log("OffersLController.doInit: exit");
        
	}
})