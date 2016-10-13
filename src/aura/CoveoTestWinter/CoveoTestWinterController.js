({
	doInit : function(component, event, helper) {
        
        console.log("CoveoTestWinter.doInit: entered");
        
        var theElement = component.find("button1").getElement();
        console.log("theElement: " + theElement);
        
        var theCoveoElement = component.find("CoveoInterfaceEditorToolbox").getElement();
        console.log("theCoveoElement: " + theCoveoElement);
        
        console.log("CoveoTestWinter.doInit: exit");

	}
})