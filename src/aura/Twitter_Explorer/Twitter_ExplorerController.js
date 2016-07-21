({
    doInit : function(component, event, helper) {
        
        console.log("TwitterExplorerController.doInit: entered");
        
        // Hide both user details and User Search Components:

        //var toggleText = component.find("userdetails");
        //$A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("searchusers");
        $A.util.addClass(toggleText,'toggle');

        
        helper.checkTwitterId(component);
        

        console.log("TwitterExplorerController.doInit: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("TwitterExplorerController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("Twitter Explorer: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("Twitter Explorer: ltng:SelectSobject - channel = " + params.channel);

        var toggleText = component.find("userdetails");
        $A.util.addClass(toggleText,'toggle');
        var toggleText = component.find("searchusers");
        $A.util.addClass(toggleText,'toggle');

        
        helper.checkTwitterId(component);
        

        console.log("TwitterExplorerController.handleApplicationEvent: exit");
        
    }
})