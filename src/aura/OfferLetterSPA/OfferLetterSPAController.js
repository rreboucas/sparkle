({
	doInit : function(component, event, helper) {
        
        console.log("OfferLetterSPAController.doInit: entered");

        // Hide both template , preview and confirm child Components on init:
        var toggleText = component.find("templateDiv");
        $A.util.addClass(toggleText,'toggle');

		toggleText = component.find("previewDiv");
        $A.util.addClass(toggleText,'toggle');         
        
        toggleText = component.find("confirmDiv");
        $A.util.addClass(toggleText,'toggle'); 
        
        console.log("OfferLetterSPAController.doInit: exit");
      },
    
    doneRendering : function(component, event, helper) {
        console.log("OfferLetterSPAController.doneRendering: entered");
        
        
        

        
		console.log("OfferLetterSPAController.doneRendering: exit")


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
                
                var offerDetailsLC = component.find("detailsDiv");
        		$A.util.addClass(offerDetailsLC,'toggle');
        		
        		// Unhide OfferTemplate child LC
                
                var offerTemplateLC = component.find("templateDiv");
        		$A.util.removeClass(offerTemplateLC,'toggle');
        		
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
                var detailsLC = component.find("detailsDiv");
        		$A.util.removeClass(detailsLC,'toggle');
                
                var templateLC = component.find("templateDiv");
        		$A.util.addClass(templateLC,'toggle');

                var toggleIndicatorCurrent = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-incomplete');
                
                var toggleIndicatorPrevious = component.find("detailsIndicator");
                $A.util.removeClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-complete');
        		$A.util.addClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-current');
                
                break;
                
           case "OfferTemplate_Next":
                var previewLC = component.find("previewDiv");
        		$A.util.removeClass(previewLC,'toggle');
                
                var templateLC = component.find("templateDiv");
        		$A.util.addClass(templateLC,'toggle');
                
                
                var toggleIndicatorCurrent = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
                
                var toggleIndicatorNext = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-incomplete');
        		$A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');

                break;
                
          case "OfferPreview_Back":
                var templateLC = component.find("templateDiv");
        		$A.util.removeClass(templateLC,'toggle');
                
                var previewLC = component.find("previewDiv");
        		$A.util.addClass(previewLC,'toggle');
                
                var toggleIndicatorCurrent = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-incomplete');
                
                var toggleIndicatorPrevious = component.find("templateIndicator");
                $A.util.removeClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-complete');
        		$A.util.addClass(toggleIndicatorPrevious,'slds-tabs--path__item slds-is-current');

                break;
                
         case "OfferPreview_Next":
                var confirmLC = component.find("confirmDiv");
        		$A.util.removeClass(confirmLC,'toggle');
                
                var previewLC = component.find("previewDiv");
        		$A.util.addClass(previewLC,'toggle');
                
                
                var toggleIndicatorCurrent = component.find("previewIndicator");
                $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        		$A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
                
                var toggleIndicatorNext = component.find("confirmIndicator");
                $A.util.removeClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-incomplete');
        		$A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');

                break;
        }
        
        
               
        
        //
        console.log("OfferLetterSPAController.handleBubbling: exit");
      }    
 

   

})