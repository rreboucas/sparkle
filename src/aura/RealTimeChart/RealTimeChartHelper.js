({
	getData : function(helper, length) {
        var data = [];
        for (var i=0; i< length; i++) {
            data.push(Math.round(helper.getRandomNumber(0, 10000))/100);
        }
        return data;
	},
    
    getRandomNumber : function(min, max) {
		return Math.random() * (max - min) + min;
    }
})