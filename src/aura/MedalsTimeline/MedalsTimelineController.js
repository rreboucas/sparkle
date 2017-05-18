({
	scriptsLoaded : function(component, event, helper) {
        
        var colors = [
            'rgba(23, 48, 91, 1)',
            'rgba(62, 159, 222, 1)',
            'rgba(48, 165, 154, 1)',
            'rgba(132, 220, 214, 1)',
            'rgba(222, 159, 0, 1)',
            'rgba(223, 205, 114, 1)'
        ];
        
        var years = window.olympicDataService.getData();
        
		var labels = [];
		var datasets = [];
        var countries = {};
        
        years.forEach(function(year) {
            labels.push(year.year);
            year.countries.forEach(function(country) {
                var total = country.gold + country.silver + country.bronze;
                if (countries[country.country]) {
                	countries[country.country].push(total);    
                } else {
                 	countries[country.country] = [total];   
                }
            })
        });
        
        var i=0;
        for (var key in countries) {
            datasets.push({
                label: key, 
                data: countries[key],
                fill: false,
                borderWidth: 1.5,
                backgroundColor: colors[i++],
                borderColor: colors[i],
                pointBackgroundColor: "#FFFFFF",
                pointBorderWidth: 4,
                pointHoverRadius: 8,
                pointRadius: 6,
                pointHitRadius: 10,
            });
        }
        
        var ctx = component.find("chart").getElement();
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio :false,
                onClick: function(event) {
                    var elements = chart.getElementAtEvent(event);
                    console.log("elements");
                    console.log(elements);
                    if (elements.length === 1) {
                        var year = labels[elements[0]._index];
                        var country = datasets[elements[0]._datasetIndex].label;
						var chartEvent = $A.get("e.c:ChartEvent");
                        chartEvent.setParams({
                            data: {year: year, country: country}
                        });
        				chartEvent.fire();
                    }
                }
            }
        });
        
	}
})