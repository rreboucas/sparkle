({
	changeChartType : function(component, event, helper) {
		var chartTypeName = component.get("v.chartTypeName");
		var componentId = component.get("v.componentId");
		var e = $A.get("e.c:ChartjsChartTypeChange");
		e.setParams({chartType:chartTypeName, componentId:componentId});
		e.fire();
	}
})