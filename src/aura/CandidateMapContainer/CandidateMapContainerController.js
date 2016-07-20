({
	handleBubbling : function(component, event) {
        console.log("Grandchild handler for " + event.getName());
        
        var params = event.getParams();
        var cityValue = params.city;
        console.log("cityValue: " + cityValue);
        var stateValue = params.state;
        console.log("stateValue: " + stateValue);
        component.set("v.City", cityValue);
        component.set("v.State", stateValue);
        //event.stopPropagation();

    }
})