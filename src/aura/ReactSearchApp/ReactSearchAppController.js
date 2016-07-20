({
	toggle : function(component, event, helper) {
        console.log("ReactSearchController.toggle: entered");
        
		component.get('v.display') ? component.set('v.display', false): component.set('v.display', true);
		
        console.log("ReactSearchController.toggle: exit");
	}
})