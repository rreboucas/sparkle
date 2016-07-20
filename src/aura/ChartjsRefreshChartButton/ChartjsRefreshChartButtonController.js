({
	updateChartData : function(component, event, helper) {
        var e = $A.get("e.c:ChartjsChartDataUpdate");
        e.fire();
	}
})