({
	doInit : function(component, event, helper) {
        
        console.log("OfferDetailsController.doInit: entered");

        var cId = component.get("v.candidateId");
        console.log("Candidate ID: " + cId);
        // Call client side helper action to populate the picklist with All available Email Template records
        helper.getListRecords(component);
        
        console.log("OfferDetailsController.doInit: exit");
      },

    
    
    HandleNextClick : function(component, event, helper) {
        
        console.log("OfferDetailsController.CreateOffer: entered");
        
        
        // Get the values from the form
		var n1 = component.find("salary").get("v.value");
        console.log("Salary entered:" + n1);
        
		var n2 = component.find("bonus").get("v.value");
        console.log("Bonus entered:" + n2);
        
        var t1 = component.find("templateSelect").get("v.value");
        console.log("Template Id selected:" + t1);
        
        // Store values on this LC Attributes:
      
     	component.set("v.enteredSalary", n1);
        component.set("v.enteredBonus", n2);
        component.set("v.selectedTemplateId", t1);
        
        
        
        
        
        helper.createOfferAndNavigate(component);
        
        
        
        
        console.log("OfferDetailsController.CreateOffer: exit");
    },
})