({
    doInit : function(component, event, helper) {
        
        console.log("React_LC_ContainerController.doInit: entered");
        

        //helper.getTwitterPicture(component);
        
        var cmpType = component.getType();
        var namespace= cmpType.substr(0, cmpType.indexOf(':'));
        console.log("namespace: " + namespace);
        component.set("v.auraVersion", namespace)

        console.log("React_LC_ContainerController.doInit: exit");
        
    },
    
    handleApplicationEvent : function(component, event, helper) {
        
        console.log("React_LC_ContainerController.handleApplicationEvent: entered");
        
        var params = event.getParams();
        component.set("v.recordId", params.recordId);

        console.log("React_LC_ContainerController: ltng:SelectSobject - recordID = " + params.recordId);
        console.log("React_LC_ContainerController: ltng:SelectSobject - channel = " + params.channel);
        
        // Send message to Lightning Container App:        
        
        var msg = {
            name: "Record ID Passed by LC",
            value: component.get("v.recordId")
        };
        component.find("ReactApp").message(msg);
        

        console.log("React_LC_ContainerController.handleApplicationEvent: exit");
        
    },
    
    handleMessage: function(component, message, helper) {
        var payload = message.getParams().payload;
        var name = payload.name;
        if (name === "PropertyCreated") {
            var value = payload.value;
            var messageToUser;
            if (value.price > 1000000) {
                messageToUser = "Big Real Estate Opportunity in " + value.city + ", " + value.state + " : $" + value.price;
            }
            else {
                messageToUser = "Small Real Estate Opportunity in " + value.city + ", " + value.state + " : $" + value.price;
            }
            //var log = component.get("v.log");
            //log.push(messageToUser);
            //component.set("v.log", log);
            //component.set("v.messageReceived", messageToUser);
            //$A.get('e.force:refreshView').fire();
        }
    },

    handleError: function(component, error, helper) {
        var e = error;
    }
})