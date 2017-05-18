({
	scriptsLoaded : function(component, event, helper) {
        
        var feedName = component.get("v.feedName");
        
        var ctx = component.find("chart").getElement();
        
        var data = {
            labels: feedName ? [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : [],
              datasets: [
                  {
                      label: feedName,
                      data: feedName ? helper.getData(helper, 10) : [],
                      borderWidth: 1.5,
                      borderColor: "rgba(62, 159, 222, 0.8)",
                      backgroundColor: "rgba(62, 159, 222, 0.1)",
                  }
              ]
            };

        var lastLabel = 10;
        
        var chart = new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                animation : false
            }
        });
        
        
        setInterval($A.getCallback(function() {
			data.datasets[0].data.push(Math.round(helper.getRandomNumber(0, 10000))/100);
			data.datasets[0].data.shift();
			data.labels.push(++lastLabel);
			data.labels.shift();
			chart.update();
		}), Math.round(helper.getRandomNumber(1000, 2000)));
        
	}
    
})