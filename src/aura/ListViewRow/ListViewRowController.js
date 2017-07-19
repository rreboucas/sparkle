({
	doInit : function(component, event, helper) {
        
        console.log("ListViewRow.doInit: entered");
        
        var rec = component.get("v.rec");
        console.log("ListViewRow.rec: " + rec);
        
        console.log("ListViewRow.doInit: exit");
		
	},
    
    fireRowClickEvents : function(component, event, helper) {

        // Grab the record id from the DOM - Table row that was clicked
       
        var selectedItem = event.currentTarget;
        console.log("selectedItem: " + selectedItem);
        var SelectedRecordID = selectedItem.dataset.record;
        console.log('Selected Record ID = '+ SelectedRecordID);
        
        component.set("v.selectedRecordId", SelectedRecordID);


        // Application Event - Fire standard ltng:selectSobject event to notify other LCs about the record id that was selected:
        var stdAppEvent = $A.get("e.ltng:selectSObject");

        stdAppEvent.setParams({ "recordId": SelectedRecordID, "channel": "Project Sparkle Interview ListViewRow LC" });
        stdAppEvent.fire();
        
        
        // Component Event - Fire bubbling event to notify parent which row was clicked so the parent can handle the CSS class that shows the selected row
        var cmpEvent = component.getEvent("bubblingSelectionEvent");
        var lcLocalId = component.getGlobalId();
;
        //var lcLocalId = "Row" + component.get("v.indexRow");
        
                
        cmpEvent.setParam("selectedChildAuraID", lcLocalId );
        console.log('cmpEvent: ' + cmpEvent);
        
        cmpEvent.fire();
        
        



    },
    
    handleListMenuClick : function(component, event, helper) {
        
        console.log("ListViewRow.handleListMenuClick: entered");
        //var btnLabel = component.get("v.buttonLabel");


        //var selectedItem = event.detail.menuItem.elements["0"].textContent;
        var selectedItem = event.getParam("value");
        console.log("selectedItem: " + selectedItem);

        var selectedRecId = component.get("v.selectedRecordId");
        console.log("selectedRecId: " + selectedRecId);

        switch (selectedItem) {
            case "View":
                console.log("View switch: ");
                var viewRecordEvent = $A.get("e.force:navigateToSObject");
                viewRecordEvent.setParams({"recordId": selectedRecId});
                viewRecordEvent.fire();
                break;
            case "Edit":
                console.log("Edit switch: ");
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({"recordId": selectedRecId});
                editRecordEvent.fire();
                break;
            case "Remove":
                console.log("Remove switch: ");
                // Fire Component (Bubbling) event to ask the ListView LC (Parent) to display reasign LC and refresh the list:                      
                        
                var cmpEvent = component.getEvent("bubblingActionEvent");
                
                
                cmpEvent.setParam("selectedRecordID", selectedRecId );
                cmpEvent.setParam("selectedChildAction", "Remove_Record" );
        		
                var indexVar = component.get("v.indexRow");
                console.log('indexVar: ' + indexVar);
                
                cmpEvent.setParam("indexRow", indexVar ); 
                console.log('cmpEvent: ' + cmpEvent);
                
                cmpEvent.fire();
                
                break;
        }


        console.log("ListViewRow.handleListMenuClick: exit");

    },
})