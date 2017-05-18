({
	scriptsLoaded : function(component, event, helper) {

        var data = {
            labels: ["Gold", "Silver", "Bronze"], 
            datasets: [
                {
                    data: [0, 0, 0],
                    backgroundColor: [
                        "rgba(255,203,75,.8)",
                        "rgba(143,134,132,.8)",
                        "rgba(153,119,61,.8)"
                    ],
                    hoverBackgroundColor: [
                        "rgba(255,203,75,1)",
                        "rgba(143,134,132,1)",
                        "rgba(143,125,92,1)"
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
		
	},
    
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