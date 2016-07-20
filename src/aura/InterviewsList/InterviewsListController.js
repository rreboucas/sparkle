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

        console.log("InterviewsListController.doInit: exit");
        
	},
    
    fireApplicationEvent : function(component, event, helper) {
        //var recId = = event.target.value;
		var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        console.log('data Name = '+ Name);
        // note different syntax for getting application event
        var appEvent = $A.get("e.c:CandidateDetailEvent");

        appEvent.setParams({ "candidateID": Name });
        appEvent.fire();
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
       
       console.log("InterviewsListController.sortGrid: exit"); 
    },


	OpenVisualForce:function(component,event,helper) {
        
        $A.log("InterviewsListController.OpenVisualForce: entered");
       
        
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
	}
  
})