window.olympicDataService = (function() {

    var data = [
        {
            year: "1996",
            venue: "Atlanta",
            countries: [
                {country: "USA", gold: 44, silver: 32, bronze: 25},
                {country: "Russia", gold: 26, silver: 21, bronze: 16},
                {country: "China", gold: 16, silver: 22, bronze: 12},
                {country: "UK", gold: 1, silver: 8, bronze: 6},
                {country: "Germany", gold: 20, silver: 18, bronze: 27}
            ]
        },
        {
            year: "2000",
            venue: "Sydney",
            countries: [
                {country: "USA", gold: 37, silver: 24, bronze: 32},
                {country: "Russia", gold: 32, silver: 28, bronze: 29},
                {country: "China", gold: 28, silver: 16, bronze: 14},
                {country: "UK", gold: 11, silver: 10, bronze: 7},
                {country: "Germany", gold: 13, silver: 17, bronze: 26}
            ]
        },
        {
            year: "2004",
            venue: "Athens",
            countries: [
                {country: "USA", gold: 36, silver: 39, bronze: 26},
                {country: "Russia", gold: 28, silver: 26, bronze: 36},
                {country: "China", gold: 32, silver: 17, bronze: 14},
                {country: "UK", gold: 9, silver: 9, bronze: 12},
                {country: "Germany", gold: 13, silver: 16, bronze: 20}
            ]
        },
        {
            year: "2008",
            venue: "Beijing",
            countries: [
                {country: "USA", gold: 36, silver: 39, bronze: 36},
                {country: "Russia", gold: 22, silver: 15, bronze: 23},
                {country: "China", gold: 48, silver: 21, bronze: 29},
                {country: "UK", gold: 19, silver: 13, bronze: 15},
                {country: "Germany", gold: 16, silver: 10, bronze: 15}
            ]
        },
        {
            year: "2012",
            venue: "London",
            countries: [
                {country: "USA", gold: 46, silver: 28, bronze: 29},
                {country: "Russia", gold: 20, silver: 19, bronze: 31},
                {country: "China", gold: 38, silver: 29, bronze: 21},
                {country: "UK", gold: 29, silver: 17, bronze: 19},
                {country: "Germany", gold: 11, silver: 19, bronze: 14}
            ]
        },
        {
            year: "2016",
            venue: "Rio",
            countries: [
                {country: "USA", gold: 46, silver: 37, bronze: 38},
                {country: "Russia", gold: 19, silver: 17, bronze: 19},
                {country: "China", gold: 26, silver: 18, bronze: 26},
                {country: "UK", gold: 27, silver: 23, bronze: 17},
                {country: "Germany", gold: 17, silver: 10, bronze: 15}
            ]
        },
    ];
    

	return {
        getData: function() {
    	   return data;				
        }
	};

}())