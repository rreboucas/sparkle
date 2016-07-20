global virtual class chartDataTemplateForDatasetTypeChart {
    global list<string> labels;
    global list<chartjsDataset> datasets;
    
    global class chartjsDataset {
        global string label;
        global string fillColor;
        global string strokeColor;
        global string pointColor;
        global string pointStrokeColor;
        global string pointHighlightFill;
        global string pointHighlightStroke;
        global list<integer> data;
    }
}