({
    doInit : function(component, event, helper) {
        
        console.log("FilesViewerController.doInit: entered");
            
        // Hide the modal popup LC using CSS
        //var toggleText = component.find("modal");
        //$A.util.addClass(toggleText,'toggle');
        
        var toggleText = component.find("modal");
        $A.util.addClass(toggleText,"slds-hide");
        
            helper.getListRecords(component);

        console.log("FilesViewerController.doInit: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("FilesViewerController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("FilesViewerController: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("FilesViewerController: ltng:SelectSobject - channel = " + params.channel);
                
                
        helper.getListRecords(component);
        

        console.log("FilesViewerController.handleApplicationEvent: exit");
        
    } ,
    
    openFileViewer : function(component, event, helper) {

        console.log("FilesViewerController.openFileViewer: entered");
        
        // Grab the record id from the DOM - File that was clicked
       
        var selectedItem = event.currentTarget;
        console.log("selectedItem: " + selectedItem);
        var SelectedRecordID = selectedItem.dataset.record;
        console.log('Selected File Record ID = '+ SelectedRecordID);
   
        var array = [];
        array[0] = SelectedRecordID;
        console.log('array = '+ array);

        // Fire standard lightning:openFiles event:
        var stdAppEvent = $A.get("e.lightning:openFiles");

        stdAppEvent.setParams({ "recordIds": array, "selectedRecordId": null });
        stdAppEvent.fire();

        console.log("FilesViewerController.openFileViewer: exit");

    }


    ,
    
    viewModal : function(component, event) {
    // Open Modal
        var toggleText = component.find("modal");
        $A.util.removeClass(toggleText,"slds-hide");
    },
    
    hideModal : function(component, event) {
    // Close Modal
        var toggleText = component.find("modal");
        $A.util.addClass(toggleText,"slds-hide");
    }
})