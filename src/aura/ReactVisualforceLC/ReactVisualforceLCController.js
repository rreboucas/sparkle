({
	setupLightningConverterListener: function(){
      var listener = function(event) {
          if(event.data.action === 'toast'){
              this.processToast(event.data)
          }
          else if(event.data.action === 'navigateToSObject'){
              this.processNavigateToSObject(event.data)
          }
      }.bind(this);
      window.addEventListener('message', listener);
      console.log("ReactVisualforceLCController.setupLightningConverterListener: exit");
    },
     
    processToast: function(data){
    	console.log("ReactVisualforceLCController.processToast: entered");
       var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": event.data.title,
            "message": event.data.message
        });
        toastEvent.fire(); 
    },
     
    processNavigateToSObject: function(data){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.data.recordId,
            "slideDevName": event.data.slideDevName //"related"
        });
        navEvt.fire();
    }
})