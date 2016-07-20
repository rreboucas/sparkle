({
    navigateToDetailsView : function(candidateId) {
        var event = $A.get("e.force:navigateToSObject");
        event.setParams({
            "recordId": candidateId
        });
        event.fire();
    }
})