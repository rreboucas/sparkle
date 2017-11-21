({
    doInit : function(component, event, helper) {
        
        console.log("ListViewDataTableController.doInit: entered");
        
        
        
        // Call client side helper action to populate the list with records
        helper.getListRecords(component);


        console.log("ListViewDataTableController.doInit: exit");
        
    },
    
    onRender : function(component, event, helper) {
        console.log("ListViewController.onRender: entered");
        var lstRecs = component.get("v.lstRecords");
        var arr = [];
        arr = lstRecs;
        if (arr != null && !component.get("v.isDoneRendering")){

            var firstRow = component.find("Row0");

            console.log("firstRow: " + firstRow);
            $A.util.removeClass(firstRow, "slds-hint-parent");
            $A.util.addClass(firstRow, "slds-is-selected"); 
            component.set("v.isDoneRendering", true);
            
            
            // Fire standard ltng:selectSobject event:
            var stdAppEvent = $A.get("e.ltng:selectSObject");
    
            stdAppEvent.setParams({ "recordId": arr[0].eventField, "channel": "Project Sparkle Interview List LC" });
            stdAppEvent.fire();

        }
        
        

        
		console.log("ListViewController.onRender: exit")


    },
    
    handleBubblingSelection : function(component, event) {
        
        console.log("ListViewController.handleBubblingSelection: entered");
        
        // Receive name of component to hide from Bubbling Event (fired by child LCs)
        console.log("Event Name " + event.getName());
        
        var params = event.getParams();
        
        var selectedChildID = params.selectedChildAuraID;
        console.log("selectedChildID: " + selectedChildID);
        var selectedItem = component.find(""+ selectedChildID); 
        console.log("selectedItem: " + selectedItem);
        
        // Set lastSelectedRow attribute with the id of the current selection
        
        //CSS - Remove Selected class from first row        
        var firstRow = component.find("Row0");
        console.log("firstRow: " + firstRow);
        $A.util.removeClass(firstRow, "slds-is-selected");
        $A.util.addClass(firstRow, "slds-hint-parent"); 
        
        //CSS - Remove Selected class from any other rows that were selected before  
        var lastSelectedRow = component.get("v.lastSelectedRow");
		console.log("lastSelectedRow: " + lastSelectedRow);
        if (lastSelectedRow){
            $A.util.removeClass(lastSelectedRow, "slds-is-selected");
        	$A.util.addClass(lastSelectedRow, "slds-hint-parent");
        }
        
        //CSS - Add Selected class to the row that was clicked
               
        $A.util.removeClass(selectedItem, "slds-hint-parent");
        $A.util.addClass(selectedItem, "slds-is-selected"); 
        
        // Store the last Table Rown that was clicked
        component.set("v.lastSelectedRow", selectedItem);
        
        console.log("ListViewController.handleBubblingSelection: exit");
        
    },
    
    
    handleBubblingAction : function(component, event) {
        
        console.log("ListViewController.handleBubblingAction: entered");
        
        // Receive name of component to hide from Bubbling Event (fired by child LCs)
        console.log("Event Name " + event.getName());
        
        var params = event.getParams();
        
        
        var selectedChildAction = params.selectedChildAction;
        console.log("selectedChildAction: " + selectedChildAction);
        
        var selectedChildIndex = params.indexRow;
        console.log("selectedChildIndex: " + selectedChildIndex);
          
        
        switch (selectedChildAction) {
            case "Remove_Record":
                
                // Get the list of records that populates the list of child Components
                var listRecords = component.get("v.lstRecords");
                
                // Remove the index of the Child that asked to be removed from the list
                listRecords.splice(selectedChildIndex, 1);
                
                // Assign the new list whithout that child to the attribute that populates the list of child Components
                component.set("v.lstRecords", listRecords);
                
                break;

            
        }
        
        // Call event.StopPropagation() so that this Component Event stops bubbling up to other parents in the hierarchy if there were ones
        
        event.stopPropagation();
        
     
        console.log("ListViewController.handleBubblingAction: exit");
        
    },
    

    CreateNewRecord : function(component, event, helper) {
        
        console.log("ListViewController.CreateNewRecord: entered");
        var objectAPIName = component.get("v.objectApiName");

        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": objectAPIName
        });
        createRecordEvent.fire();

        console.log("ListViewController.CreateNewRecord: exit");

    },

    
    
    
    sortGrid : function(component, event, helper) {
        console.log("InterviewsListController.sortGrid: entered");
        var selectedItem = event.currentTarget;
        var selectedFieldSortName = selectedItem.dataset.record;
        console.log('Field to Sort = '+ selectedFieldSortName);
        
        if (selectedFieldSortName == component.get("v.lastSortFieldName"))
        {
            if (component.get("v.lastSortDirection") == 'asc')
            {
               component.set("v.sortDirection", 'desc'); 
            }
            else
            {
                component.set("v.sortDirection", 'asc'); 
            }
        }
        else
        {
            component.set("v.sortFieldName", selectedFieldSortName); 
        }
        
       helper.getListRecords(component);
       var fireListEvent = component.get("v.fireListRecordsEvent");
       if (fireListEvent == true)
       {
            var lstRecs = component.get("v.lstRecords");
            console.log("InterviewsListController.fireListRecordsEvent: lstRecs: " + lstRecs);
            var recordIdsString;
                
                
                if (lstRecs)
                {
                    for (var i=0; i<lstRecs.length; i++) 
                    {
                        var record = lstRecs[i];
                        console.log('InterviewsListController.fireListRecordsEvent.getListRecords: record ' + record);
                        
                        if (i == 0)
                        {
                           recordIdsString = "'" + record.recordID; 
                        }
                        else
                        {
                            recordIdsString = recordIdsString + "','" + record.recordID;
                            if (i == (lstRecs.length - 1))
                            {
                                recordIdsString = recordIdsString + "'";
                            }
                        }
       
                        
                        
                        console.log('InterviewsListController.fireListRecordsEvent.getListRecords: recordIdsString ' + recordIdsString);
                    }
                    
                    if (recordIdsString)
                    {
                        // if there is content in the comma-delimitted list of record ids fire the application event with it as a parameter
                        var appEvent = $A.get("e.c:RecordListIdsEvent");
                        console.log('InterviewsListController.fireListRecordsEvent: appEvent ' + appEvent);
                        appEvent.setParams({ "recordIdsParameter": recordIdsString });
                        console.log('InterviewsListController.fireListRecordsEvent: appEvent ' + appEvent);
                        appEvent.fire();
                    }
              }
         
       }
       
       console.log("Generic_ListController.sortGrid: exit"); 
    },


    OpenVisualForce:function(component,event,helper) {
        
        $A.log("InterviewsListController.OpenVisualForce: entered");
       
       //var btnURL = component.get("v.buttonURL");
       
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url" : component.get("v.buttonURL")
        });
        urlEvent.fire();

        
        $A.log("InterviewsListController.OpenModal: exit");
    },
    
    OpenModal:function(component,event,helper) {
        
        $A.log("InterviewsListController.OpenModal: entered");
       
        // Open Modal
        var toggleText = component.find("modal");
        $A.util.removeClass(toggleText,'toggle');

        
        
        
        
        
        $A.log("InterviewsListController.OpenModal: exit");
    },
    
    CloseModal:function(component,event,helper) {
        
        $A.log("InterviewsListController.CloseModal: entered");
       
        // Close Modal
        var toggleText = component.find("modal");
        $A.util.addClass(toggleText,'toggle');

        
        
        
        
        
        $A.log("InterviewsListController.CloseModal: exit");
    },
    
    
    getSelectedName: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            alert("You selected: " + selectedRows[i].opportunityName);
        }
    }
  
})