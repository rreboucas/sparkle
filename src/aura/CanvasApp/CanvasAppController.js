({
	doInit : function(component, event, helper) {
        
        console.log("CanvasAppController.doInit: entered");
        
        component.set("v.params", "{userName:'value1',firstName:'value2'}");

        console.log("CanvasAppController.doInit: exit");
        
    }
})