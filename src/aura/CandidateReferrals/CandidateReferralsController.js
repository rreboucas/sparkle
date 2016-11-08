({
    doInit : function(component, event, helper) {
        
        console.log("CandidateReferralsController.doInit: entered");
        
        // Hide the modal popup LC using CSS
        //var modal = component.find('modal');
        //$A.util.toggleClass(modal,'slds-hide');
        //
        var valuesProvided = component.get("v.Modal_column1_fieldapiname");
        console.log("CandidateReferrals_Controller: valuesProvided: " + valuesProvided);
        
        var hsrecords = component.get("v.hasRecords");
        console.log("CandidateReferrals_Controller: hsrecords: " + hsrecords);
        
        
        helper.getReferrals(component);

        console.log("CandidateReferralsController.doInit: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("CandidateReferralsController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("CandidateReferralsController: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("CandidateReferralsController: ltng:SelectSobject - channel = " + params.channel);
                
                
        helper.getReferrals(component);
        

        console.log("CandidateReferralsController.handleApplicationEvent: exit");
        
    },
    
    OpenModal:function(component,event,helper) {
        
        console.log("CandidateReferralsController.OpenModal: entered");
       
        // Open Modal
        var toggleText = component.find("modal");
        $A.util.removeClass(toggleText,'toggle');

        
        
        
        
        
        console.log("CandidateReferralsController.OpenModal: exit");
    },
    
    CloseModal:function(component,event,helper) {
        
        console.log("CandidateReferralsController.CloseModal: entered");
       
        // Close Modal
        var toggleText = component.find("modal");
        $A.util.addClass(toggleText,'toggle');

        
        
        
        
        
        console.log("CandidateReferralsController.CloseModal: exit");
    },
    
    toggleModal : function(component, event) {
    var modal = component.find('modal');
        $A.util.toggleClass(modal,'slds-hide');
    },
    
    displayRecordsModal: function(component, event, helper) {
        console.log("CandidateReferralsController.displayRecordsModal entered");
        console.log($A.get("e.c:displayrecdetails"));
        //var userkey = component.get('v.salesUser.userId');
        //console.log(userkey);
        var userevent = $A.get("e.c:displayrecdetails");
        
        //var recId = component.get("v.recordId");
        //console.log("recId: " + recId);
        //
        
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        console.log('data Name = '+ Name);
        
        userevent.setParams({ "recordId":  Name});
        console.log("CandidateReferralsController before firing the event");
        userevent.fire();
        console.log("CandidateReferralsController.displayRecordsModal exit");
    }
})