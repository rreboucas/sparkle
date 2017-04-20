({
	
    CreateLetter : function(component, event, helper) {
		// Get the values from the form
		var n1 = component.find("salary").get("v.value");
		var n2 = component.find("bonus").get("v.value");
    },
 
//	doInit : function(component, event, helper) {
//        var action = component.get("c.getEmailTemplates"); // name on the apex class
//        action.setCallback(this, function(a) {
//            component.set("v.emailTemplates", a.getReturnValue());
//        });
//        $A.enqueueAction(action);
//    }
})