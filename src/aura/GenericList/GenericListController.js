({
    doInit : function(component, event, helper) {
        
        console.log("InterviewsListController.doInit: entered");
        
        // check if the user supplied a field for the columns and hide them if not
        var col2Content = component.get("v.column2_fieldapiname") ;
        if (!col2Content)
        {
            var toggleText = component.find("col2");
            $A.util.addClass(toggleText,'toggle');
            
            var toggleRow = component.find("col2Row");
            $A.util.addClass(toggleRow,'toggle');
        }
        
        var col3Content = component.get("v.column3_fieldapiname") ;
        if (!col3Content)
        {
            var toggleText = component.find("col3");
            $A.util.addClass(toggleText,'toggle');
            
            var toggleRow = component.find("col3Row");
            $A.util.addClass(toggleRow,'toggle');
        }
        
        var col4Content = component.get("v.column4_fieldapiname") ;
        if (!col4Content)
        {
            var toggleText = component.find("col4");
            $A.util.addClass(toggleText,'toggle');
            
            var toggleRow = component.find("col4Row");
            $A.util.addClass(toggleRow,'toggle');
        }
        
        var showButton = component.get("v.showButton") ;
        if (showButton == false)
        {
            var toggleText = component.find("colButton");
            $A.util.addClass(toggleText,'toggle');
            
            var toggleRow = component.find("colButtonRow");
            $A.util.addClass(toggleRow,'toggle');
        }
        
        // Call client side helper action to populate the list with records
        helper.getListRecords(component);

        // Call client side helper action to call server and get the running user Id
        helper.getRunningUser(component);

        console.log("InterviewsListController.doInit: exit");
        
    },
    
    doneRendering : function(component, event, helper) {
        console.log("InterviewsListController.doneRendering: entered");
        var lstRecs = component.get("v.lstRecords");
        var arr = [];
        arr = lstRecs;
        if (arr != null && !component.get("v.isDoneRendering")){

            var firstRow = component.find("firstRow");

            console.log("firstRow: " + firstRow);
            $A.util.removeClass(firstRow, "slds-hint-parent");
            $A.util.addClass(firstRow, "slds-is-selected"); 
            component.set("v.isDoneRendering", true);
            
            
            // Fire standard ltng:selectSobject event:
            var stdAppEvent = $A.get("e.ltng:selectSObject");
    
            stdAppEvent.setParams({ "recordId": arr[0].eventField, "channel": "Project Sparkle Interview List LC" });
            stdAppEvent.fire();

        }
        
        

        
		console.log("InterviewsListController.doneRendering: exit")


    },
    
    fireApplicationEvent : function(component, event, helper) {

        //CSS - Remove Selected class from first row and any other rows that were selected before        
        var firstRow = component.find("firstRow");
        console.log("firstRow: " + firstRow);
        $A.util.removeClass(firstRow, "slds-is-selected");
        $A.util.addClass(firstRow, "slds-hint-parent"); 
        
        
        var lastSelectedRow = component.get("v.lastSelectedRow");
		console.log("lastSelectedRow: " + lastSelectedRow);
        if (lastSelectedRow){
            $A.util.removeClass(lastSelectedRow, "slds-is-selected");
        	$A.util.addClass(lastSelectedRow, "slds-hint-parent");
        }
        
        // Grab the record id from the DOM - Table row that was clicked
       
        var selectedItem = event.currentTarget;
        console.log("selectedItem: " + selectedItem);
        var SelectedRecordID = selectedItem.dataset.record;
        console.log('Selected Record ID = '+ SelectedRecordID);




        var SelectedParentRecID = selectedItem.dataset.mainrec;
        console.log('SelectedParentRecID = '+ SelectedParentRecID);
        component.set("v.selectedRecordId", SelectedParentRecID);
        
        //CSS - Add Selected class to the row that was clicked        
        $A.util.removeClass(selectedItem, "slds-hint-parent");
        $A.util.addClass(selectedItem, "slds-is-selected"); 
        
        // Store the last Table Rown that was clicked
        component.set("v.lastSelectedRow", selectedItem);


        // Fire standard ltng:selectSobject event:
        var stdAppEvent = $A.get("e.ltng:selectSObject");

        stdAppEvent.setParams({ "recordId": SelectedRecordID, "channel": "Project Sparkle Interview List LC" });
        stdAppEvent.fire();



    },

    CreateNewRecord : function(component, event, helper) {
        
        console.log("InterviewsListController.CreateNewRecord: entered");
        var objectAPIName = component.get("v.objectApiName");

        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": objectAPIName
        });
        createRecordEvent.fire();

        console.log("InterviewsListController.CreateNewRecord: exit");

    },

    handleListMenuClick : function(component, event, helper) {
        
        console.log("InterviewsListController.handleListMenuClick: entered");
        var btnLabel = component.get("v.buttonLabel");


        var selectedItem = event.detail.menuItem.elements["0"].textContent;
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
            case btnLabel:
                console.log("btnLabel switch: ");
                break;
        }


        console.log("InterviewsListController.handleListMenuClick: exit");

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

       /* TODO: Handle App Builder Parameters and List Row Clicks to allow VF page parameters to be passed dynamically

       var btnUrlParameterFieldName = component.get("v.buttonURLParameter");
       var blnUserIdAsParameter = component.get("v.userIdParameterValue");

       console.log("blnUserIdAsParameter: " + blnUserIdAsParameter); 

       var linkUrl = btnURL + '?' + btnUrlParameterFieldName + '=' ;

       console.log("linkUrl before param value: " + linkUrl);

       if(blnUserIdAsParameter)
       {
            // Get user id and append it to URL as parameter
            var usr = component.get("v.runningUser");
            console.log("usr: " + usr); 

            var usrId = usr.Id;
            console.log("usrId: " + usrId); 

            linkUrl = linkUrl + usrId;

            console.log("linkUrl with user id: " + linkUrl);


       }

       var SecondUrlParameterFieldName = component.get("v.buttonURLParameter2");

       if (SecondUrlParameterFieldName)
       {
           // Parameter 2 (get record id from List row user click event)
           var selectedItem = event.currentTarget;
           var clickedRecId = selectedItem.dataset.record;
           console.log('Clicked RecId = '+ clickedRecId);

           linkUrl = linkUrl + '&' + SecondUrlParameterFieldName + '=' + clickedRecId;

           console.log("linkUrl with 2nd parameter appended: " + linkUrl);
       }

       // Fire Lightning Navigation Event to take user to Page with parameters
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url" : linkUrl
        });
        urlEvent.fire();
        
        
        */
        
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
    }
  
})