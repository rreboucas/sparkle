({
	 doInit : function(component, event, helper) {
         
        
         
         
     }
    
    ,
    
    handleRecordChange : function(component, event, helper) {
        
        
        
        var changeType = event.getParams().changeType;

        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") { /* handle record load */ }
        else if (changeType === "REMOVED") { /* handle record removal */ }
        else if (changeType === "CHANGED") { 
            
            console.log("CandidateScoreController - record changed ");
            
            
            var techScore = component.get("v.candidate.testautonumdata__Technical_Interview_Score__c");
            console.log("handleRecordChange.techScore: " + techScore);
    
            var recScore = component.get("v.candidate.testautonumdata__Recruiter_Interview_Score__c");
            console.log("handleRecordChange.recScore: " + recScore);
    
            var manScore = component.get("v.candidate.testautonumdata__Management_Interview_Score__c");
            console.log("handleRecordChange.manScore: " + manScore);
            
            var medals = [recScore , manScore, techScore];
            component.chart.data.datasets[0].data = medals;
            component.chart.update();
            return;
        }
        
        
        
        
        
        
        
        
        
    }
    ,
    scriptsLoaded : function(component, event, helper) {

        
        var techScore = component.get("v.candidate.testautonumdata__Technical_Interview_Score__c");
        console.log("InterviewsListController.techScore: " + techScore);

        var recScore = component.get("v.candidate.testautonumdata__Recruiter_Interview_Score__c");
        console.log("InterviewsListController.recScore: " + recScore);

        var manScore = component.get("v.candidate.testautonumdata__Management_Interview_Score__c");
        console.log("InterviewsListController.manScore: " + manScore);
        
        var data = {
            labels: ["Recruiter", "Management", "Technical"], 
            datasets: [
                {
                    data: [recScore , manScore, techScore],
                    backgroundColor: [
                        "rgba(162,26,26,.8)",
                        "rgba(38,141,232,.8)",
                        "rgba(20,178,94,.8)"
                    ],
                    hoverBackgroundColor: [
                        "rgba(130,27,27,1)",
                        "rgba(27,82,130,1)",
                        "rgba(26,142,80,1)"
                    ]                
                }
            ]
        };
        
		var ctx = component.find("chart").getElement();
        component.chart = new Chart(ctx,{
            type: 'doughnut',
            data: data,
			options: {
                responsive: true,
                maintainAspectRatio: false,
                onClick: function(event) {
                    var elements = component.chart.getElementAtEvent(event);
                    if (elements.length === 1) {
						var chartEvent = $A.get("e.c:ChartEvent");
                        chartEvent.setParams({
                            data: {
                                year: component.get("v.year"),
                                country: component.get("v.country"),
                                medalType: component.chart.data.labels[elements[0]._index]
                            }
                        });
        				chartEvent.fire();
                    }
                }
            }

        });
		
	}
    
    ,
    
    chartChange: function(component, event, helper) {
        var filters = event.getParam("data");
        component.set("v.year", filters.year);
        component.set("v.country", filters.country);
        var years = window.olympicDataService.getData();
        years.forEach(function(year) {
            if (year.year == filters.year) {
                year.countries.forEach(function(country) {
                    if (country.country == filters.country) {
		                component.set("v.title", year.venue + ' ' + year.year + ", " + filters.country + " (" + (country.gold + country.silver + country.bronze) + " medals)");
                        var medals = [country.gold, country.silver, country.bronze];
                        component.chart.data.datasets[0].data = medals;
                        component.chart.update();
                        return;
                    }
                });
            }
        });
    }
    
})