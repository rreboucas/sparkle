global with sharing class chartjsSamplePieChartDataProvider extends chartjsPieChartData implements iChartjsDataProvider {
    global static string getChartjsData(){
        list<chartjsPieChartData> chartjsData = new list<chartjsPieChartData>();

        chartjsPieChartData d;
        d = new chartjsPieChartData();
        d.label = 'Red';
        d.value = 300;
        d.color = '#F7464A';
        d.highlight = '#FF5A5E';
        chartjsData.add(d);

        d = new chartjsPieChartData();
        d.label = 'Green';
        d.value = 50;
        d.color = '#46BFBD';
        d.highlight = '#5AD3D1';
        chartjsData.add(d);

        d = new chartjsPieChartData();
        d.label = 'Yellow';
        d.value = 100;
        d.color = '#FDB45C';
        d.highlight = '#FFC870';
        chartjsData.add(d);

        return JSON.serialize(chartjsData);
    }
}