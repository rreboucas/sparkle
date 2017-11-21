({
    
    doInit : function(component, event, helper) {
        
        console.log("OfferTemplateAuraIfController.doinit: entered");
        
        var params = event.getParams();
        
        
        
        component.set("v.recordId", params.candidateID);
        component.set("v.enteredSalary", params.enteredSalary);
        component.set("v.enteredBonus", params.enteredBonus);
        component.set("v.selectedTemplateId", params.selectedTemplateId);
        component.set("v.offerId", params.offerId);
        component.set("v.email", params.email);
        
        if (params.offerText) {
            component.set("v.templateVal", params.offerText);
            console.log("text back = " + component.get("v.templateVal"));
        }
        
        if (params.offerSubject) {
            component.set("v.templateSubjectVal", params.offerSubject);
            console.log("subject back = " + component.get("v.templateSubjectVal"));
        }

        console.log("candidateID = " + component.get("v.recordId"));
        console.log("enteredSalary = " + component.get("v.enteredSalary"));
        console.log("enteredBonus = " + component.get("v.enteredBonus"));
        console.log("selectedTemplateId = " + component.get("v.selectedTemplateId"));   
        console.log("OfferId = " + component.get("v.offerId"));
        console.log("Email = " + component.get("v.email"));  
        
		// Only call the Apex Server controller if we have the candidateId, templateId and offerId provided by the Lightning Event
		if (component.get("v.recordId") && component.get("v.selectedTemplateId") && component.get("v.offerId"))
        {
            helper.getTemplate(component);
        }
        
        

        console.log("OfferTemplateController.doinit: exit");
        
    },
    
    goBack : function(component, event, helper) {
        
        console.log("OfferTemplateControllerAuraIf.goBack: entered");

        // Fire Component (Bubbling) event to ask the OfferLetterSPA LC (Parent) to go back to previous child LC:
        
        var cmpEvent = component.getEvent("bubblingEvent");
        console.log('cmpEvent: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : 'OfferTemplate_Back' });

        cmpEvent.fire();
        
        
        console.log("OfferTemplateController.goBack: exit");
    },
    
    goNext : function(component, event, helper) {
        
        console.log("OfferTemplateController.goNext: entered");
        
        // Grab changes made by User on the Editor and store it on the LC attribute

        var changedText = component.find("txtArea").get("v.value");
        console.log('changedText: ' + changedText);
        component.set("v.templateVal", changedText);
        
        var changedSubject = component.find("txtSubject").get("v.value");
        console.log('changedSubject: ' + changedSubject);
        component.set("v.templateSubjectVal", changedSubject);
        
        // Fire Component (Bubbling) event to ask the OfferLetterSPA LC (Parent) to go to the next child LC:
        
        var cmpEvent = component.getEvent("bubblingEvent");
        console.log('cmpEvent: ' + cmpEvent);
        
        cmpEvent.setParams({"ComponentAction" : 'OfferTemplate_Next' });

        // Fire Component (Bubbling) event to ask the OfferLetterSPA LC (Parent) to hide this child LC and unhide the next child LC:
        cmpEvent.fire();
        
        //Pass the values grabbed from this LC Form + Candidate ID to the next child LC via Lightning Events:
        var appEvent = $A.get("e.c:CandidateDetailEvent");
        appEvent.setParams({ "candidateID" : component.get("v.recordId"),
                            "enteredSalary" : component.get("v.enteredSalary"),
                            "enteredBonus" : component.get("v.enteredBonus"),
                            "selectedTemplateId" : component.get("v.selectedTemplateId"),
                            "offerId": component.get("v.offerId"),
                            "offerText": component.get("v.templateVal"),
                            "offerSubject": component.get("v.templateSubjectVal"),
                            "email": component.get("v.email"),
                            "LCWhoFired": 'OfferTemplate.cmp'
                           });
        
        appEvent.fire();
        
        
        
        
        console.log("OfferTemplateController.goNext: exit");
    },
    
    testContent : function(cmp, event, helper) {
        
        console.log("OfferTemplateController.testContent: entered");
		var templateBody = cmp.get("v.templateVal");
        cmp.set("v.myVal", 'Hi');
        console.log("myVal: " + cmp.get("v.myVal"));

        
        console.log("OfferTemplateController.testContent: exit");
    }
})