({
    doInit : function(component, event, helper){
        if (component.get("v.showLegend") == true){
            component.set("v.chartContainerClass", "pure-u-1-2");
        } else {
            component.set("v.chartContainerClass", "pure-u-1-1");
        }
    },
    ////
    // Load data from Apex Data Provider and draw chart.
    createChart : function(component, event, helper){
        var action = component.get("c.getChartjsData");
        action.setParams({"dataProviderName":component.get("v.apexDataProvider")});
        action.setCallback(this, function(a){
            var response = a.getReturnValue();
            if (response == null || response == "" || response == "[]" || response == "{}"){
                component.set("v.isChartDataEmpty", true);
                return;
            } else {
                component.set("v.isChartDataEmpty", false);
            }
            helper.drawChart(component, JSON.parse(response), {});
        });
        $A.enqueueAction(action);
    },
    ////
    // updateChart is triggered by ChartDateUpdate event. If event provide chart data, updateChart draws chart with it. Otherwise, do the same as createChart.
    updateChart : function(component, event, helper){
        var chartData = event.getParam("chartData");
        var componentName = event.getParam("componentName");
        if (chartData == null || componentName == null){
            var action = component.get("c.getChartjsData");
            action.setParams({"dataProviderName":component.get("v.apexDataProvider")});
            action.setCallback(this, function(a){
                var response = a.getReturnValue();
                if (response == null || response == "" || response == "[]" || response == "{}"){
                    component.set("v.isChartDataEmpty", true);
                    return;
                } else {
                    component.set("v.isChartDataEmpty", false);
                }
                helper.drawChart(component, JSON.parse(response), {});
            });
            $A.enqueueAction(action);
        } else {
            helper.drawChart(component, chartData, {});
        }
    },
    ////
    // changeChartType is triggered when ChartTypeChange event is fired.
    changeChartType : function(component, event, helper){
        // Retrieve target component id and this component's global id.
        // If this component instance is not target, exit.
        var globalId = component.getGlobalId();
        if (globalId != event.getParam("componentId")){
            return;
        }

        // Retrieve chart instance and destroy to clean the canvas.
        var chart = component.get("v.chart");
        chart.destroy();

        // Draw new chart with new chart type and existing chart data & option.
        var ctx = document.getElementById(globalId + "_chart").getContext("2d");
        chart = new Chart(ctx)[event.getParam("chartType")](component.get("v.chartData"), component.get("v.chartOption"));

        // Set new chart instance to component property.
        component.set("v.chart", chart);
        component.set("v.chartType", event.getParam("chartType"));
    }
})