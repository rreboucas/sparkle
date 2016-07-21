({
    doInit : function(component, event, helper) {
        
        console.log("RecordTimelineController.doInit: entered");

            helper.getListRecords(component);

        console.log("RecordTimelineController.doInit: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("RecordTimelineController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("RecordTimelineController: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("RecordTimelineController: ltng:SelectSobject - channel = " + params.channel);
                
        helper.getListRecords(component);
        

        console.log("RecordTimelineController.handleApplicationEvent: exit");
        
    }
})