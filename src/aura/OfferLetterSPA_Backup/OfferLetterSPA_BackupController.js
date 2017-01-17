({
	doInit : function(component, event, helper) {
        
        console.log("OfferLetterSPAController.doInit: entered");
        // Hide both user details and User Search Components:
        //var toggleText = component.find("userdetails");
        //$A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("searchusers");
        $A.util.addClass(toggleText,'toggle');
        
        
        // Call client side helper action to populate the list with records
        helper.getListRecords(component);
        
        console.log("OfferLetterSPAController.doInit: exit");
      },

    
    
    CreateLetter : function(component, event, helper) {
        
        console.log("OfferLetterSPAController.CreateLetter: entered");
		
        // Get the values from the form
		var n1 = component.find("salary").get("v.value");
        console.log("Salary entered:" + n1);
        
		var n2 = component.find("bonus").get("v.value");
        console.log("Bonus entered:" + n2);
        
        var t1 = component.find("templateSelect").get("v.value");
        console.log("Template Id selected:" + t1);
        
        // Store values on LC Attributes:
      
     	cmp.set("v.enteredSalary", n1);
        cmp.set("v.enteredBonus", n2);
        cmp.set("v.selectedTemplateId", t1);
        
        //pass these values to Apex controllers
        
        console.log("OfferLetterSPAController.CreateLetter: exit");
    },
 

   
//	doInit : function(component, event, helper) {
//        var action = component.get("c.getEmailTemplates"); // name on the apex class
//        action.setCallback(this, function(a) {
//            component.set("v.emailTemplates", a.getReturnValue());
//        });
//        $A.enqueueAction(action);
//    }
})