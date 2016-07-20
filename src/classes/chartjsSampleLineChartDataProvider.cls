global with sharing class chartjsSampleLineChartDataProvider extends chartjsLineChartData implements iChartjsDataProvider {
    global static string getChartjsData(){
        chartjsLineChartData chartjsData = new chartjsLineChartData();
        chartjsData.labels = new list<string>{'Jan','Feb','Mar','Apr','May','Jun','Jul'};
        chartjsData.datasets = new list<chartjsDataset>();
        chartjsDataset dataset;
        
        dataset = new chartjsDataset();
        dataset.label = 'My First dataset';
        dataset.fillColor = 'rgba(220,220,220,0.2)';
        dataset.strokeColor = 'rgba(220,220,220,1)';
        dataset.pointColor = 'rgba(220,220,220,1)';
        dataset.pointStrokeColor = '#fff';
        dataset.pointHighlightFill = '#fff';
        dataset.pointHighlightStroke = 'rgba(220,220,220,1)';
        dataset.data = new list<integer>{65, 59, 80, 81, 56, 55, 40};
        chartjsData.datasets.add(dataset);
        
        dataset = new chartjsDataset();
        dataset.label = 'My Second dataset';
        dataset.fillColor = 'rgba(151,187,205,0.2)';
        dataset.strokeColor = 'rgba(151,187,205,1)';
        dataset.pointColor = 'rgba(151,187,205,1)';
        dataset.pointStrokeColor = '#fff';
        dataset.pointHighlightFill = '#fff';
        dataset.pointHighlightStroke = 'rgba(151,187,205,1)';
        dataset.data = new list<integer>{28, 48, 40, 19, 86, 27, 90};
        chartjsData.datasets.add(dataset);
        
        return JSON.serialize(chartjsData);
    }
}