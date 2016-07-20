({
	doInit : function(component, event, helper) {
        
        console.log("UiButtonStyleController.doInit: entered");

        var cmpTarget = component.find('changeIt');
        $A.util.toggleClass(component, '.uiButton--default .label');
        $A.util.toggleClass(component, '.uiButton');        
        //$A.util.removeClass(cmpTarget, '.uiButton--default');   
		//$A.util.removeClass(cmpTarget, '.uiButton--default .label');
        //$A.util.addClass(cmpTarget, 'uiButton--default:disabled');
        //'uiButton--default:disabled'
        console.log("UiButtonStyleController.doInit: exit");
        
	}
})