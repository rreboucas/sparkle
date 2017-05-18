({
	scriptsLoaded : function(component, event, helper) {

		var ctx = component.find("chart").getElement();
        component.chart = new Chart(ctx,{
            type: 'bar',
            data: {
                labels: [],
                datasets: [
                    {
                        label: "",
                        data: [],
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
				scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        });
		
	},
    
    chartChange: function(component, event, helper) {
        var colors = {
            gold: "rgba(255,203,75,.7)",
            silver: "rgba(143,134,132,.7)",
            bronze: "rgba(153,119,61,.7)"
        };
        var filters = event.getParam("data");
        if (!filters || !filters.year) {
            return;
        }
        var medalType;
        if (filters.medalType) {
            medalType = filters.medalType;
            component.set("v.medalType", medalType);
        } else {
            medalType = component.get("v.medalType");
        }
        var years = window.olympicDataService.getData();
        years.forEach(function(year) {
            if (year.year == filters.year) {
                component.set("v.title", year.venue + " " + year.year + ", " + medalType + " Medals");
                var labels = [];
                var values = [];
                year.countries.forEach(function(country) {
                    labels.push(country.country);
                    values.push(country[medalType.toLowerCase()]);
                });
				component.chart.data.labels = labels;
				component.chart.data.datasets[0].label = medalType;
				component.chart.data.datasets[0].data = values;
				component.chart.data.datasets[0].backgroundColor = colors[medalType.toLowerCase()];
                component.chart.update();
                return;
            }
        })
    }
    
})