({
	doInit : function(component, event, helper) {
        
        console.log("OfferLetterSPAController.doInit: entered");

        
        
        console.log("OfferLetterSPAController.doInit: exit");
      },
    
    
	handleBubbling : function(component, event) {
        
        console.log("OfferLetterSPAController.handleBubbling: entered");

        
        // Receive name of component to hide from Bubbling Event (fired by child LCs)
        console.log("Event Name " + event.getName());
        
        var params = event.getParams();
        var navigateAction = params.ComponentAction;
        console.log("navigateAction: " + navigateAction);
        
        // Based on the name of the component to hide received in the Bubble event use CSS to hide the current child LC and unhide the next child LC:
        
        switch (navigateAction) {
            case "OfferDetails_Next":
                console.log("Hide Offer Details");
                
                // Hide OfferDetails child LC
                
                component.set('v.detailsStep', false);
        		
        		// Unhide OfferTemplate child LC
                
                component.set('v.templateStep', true);
        		
        		// Mark Progress Bar OfferDetails LC indicator as Complete
                
                var toggleIndicatorCurrent = component.find("detailsIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
                
                // Mark Progress Bar OfferTemplate LC indicator as Current
                
                var toggleIndicatorNext = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-incomplete');
        		$A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');
                
                break;

            case "OfferTemplate_Back":
                component.set('v.detailsStep', true);
                
                component.set('v.templateStep', false);

                var toggleIndicatorCurrent = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-incomplete');
                
                var toggleIndicatorPrevious = component.find("detailsIndicator");
                $A.util.removeClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-complete');
        		$A.util.addClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-current');
                
                break;
                
           case "OfferTemplate_Next":
                component.set('v.previewStep', true);
                
                component.set('v.templateStep', false);
                
                
                var toggleIndicatorCurrent = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
                
                var toggleIndicatorNext = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-incomplete');
        		$A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');

                break;
                
          case "OfferPreview_Back":
                component.set('v.templateStep', true);
                
                component.set('v.previewStep', false);
                
                var toggleIndicatorCurrent = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-incomplete');
                
                var toggleIndicatorPrevious = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-complete');
        		$A.util.addClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-current');

                break;
                
         case "OfferPreview_Next":
                component.set('v.confirmStep', true);
                
                component.set('v.previewStep', false);
                
                
                var toggleIndicatorCurrent = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
                
                var toggleIndicatorNext = component.find("confirmIndicator");
                $A.util.removeClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-incomplete');
        		$A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');

                break;
        }
        
        
        // Set attributes sent by Child LC through bubble event :
        
        component.set('v.enteredSalary', params.enteredSalary);
        component.set('v.email', params.emai);
        component.set('v.offerId', params.offerId);
        component.set('v.enteredBonus', params.enteredBonus);
        component.set('v.selectedTemplateId', params.selectedTemplateId);
        component.set('v.templateVal', params.templateVal);
        component.set('v.templateSubjectVal', params.templateSubjectVal);
        
               
        
        //
        console.log("OfferLetterSPAController.handleBubbling: exit");
      }    
 

   

})