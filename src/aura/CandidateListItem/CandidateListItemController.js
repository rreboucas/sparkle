({
    candidateSelected : function(component) {
       
       console.log('CandidateListItemController.candidateSelected - candidate: ');
        var appEvent = $A.get("e.c:CandidateSelected");
        
        appEvent.setParams({"candidate": component.get("v.candidate")});
        appEvent.fire();
        
    }
})