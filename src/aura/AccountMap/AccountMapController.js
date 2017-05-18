({
	fullScreen : function(component) {
        component.set("v.fullScreen", true);
	},

	closeDialog : function(component) {
        component.set("v.fullScreen", false);
	},

  	recordChangeHandler : function(component, event) {
        var id = event.getParam("recordId");
        component.set("v.recordId", id);
        var service = component.find("service");
        service.reloadRecord();
	}

})