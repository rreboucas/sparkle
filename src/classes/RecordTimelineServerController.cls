public with sharing class RecordTimelineServerController {

    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String eventField { get;set; }
    @AuraEnabled
    public String dateValue { get;set; }
    @AuraEnabled
    public String title { get;set; }
    @AuraEnabled
    public String subtitle { get;set; }
    @AuraEnabled
    public String detail1 { get;set; }
    @AuraEnabled
    public String detail2 { get;set; }


    //Use @AuraEnabled to enable client- and server-side access to the method
    
    @AuraEnabled
    public static List<RecordTimelineServerController> getListRecords(String recordID, String rowsLimit, String objectApiName, String filter1Field, String filter1Value, String objectDateFieldName, String objectDisplayDateFieldName, String parentObjectIDFieldName, String detail1FieldAPIName, String detail2FieldAPIName, String titleFieldAPIName, String subtitleFieldAPIName) {
        
        System.debug('######## RecordTimelineServerController: rowsLimit: ' + rowsLimit);
        System.debug('######## RecordTimelineServerController: objectApiName: ' + objectApiName);

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        
        List<RecordTimelineServerController> lstReturnRecords = new List<RecordTimelineServerController>();
        if (!String.isBlank(recordID))
        {
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## RecordTimelineServerController: rLimit: ' + rLimit);
        
        String soql = 'Select id';
        
        if (objectDisplayDateFieldName != null){
            soql += ', ' + String.escapeSingleQuotes(objectDisplayDateFieldName);
            Sparkle_Helper.AddFieldToObjectsMap(objectDisplayDateFieldName, objectApiName, mapObjectsFields);
        }
        
        if (detail1FieldAPIName != null){
            soql += ', ' + detail1FieldAPIName;
            Sparkle_Helper.AddFieldToObjectsMap(detail1FieldAPIName, objectApiName, mapObjectsFields);
        }
        
        if (detail2FieldAPIName != null){
            soql += ', ' + String.escapeSingleQuotes(detail2FieldAPIName);
            Sparkle_Helper.AddFieldToObjectsMap(detail2FieldAPIName, objectApiName, mapObjectsFields);
        }
        
        if (titleFieldAPIName != null){
            soql += ', ' + String.escapeSingleQuotes(titleFieldAPIName);
            Sparkle_Helper.AddFieldToObjectsMap(titleFieldAPIName, objectApiName, mapObjectsFields);
        }
        
        if (subtitleFieldAPIName != null){
            soql += ', ' + String.escapeSingleQuotes(subtitleFieldAPIName);
            Sparkle_Helper.AddFieldToObjectsMap(subtitleFieldAPIName, objectApiName, mapObjectsFields);
        }
        
        // Add object name to query string:        
        soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
        
        // Add Filter Where clause if provided
        if (parentObjectIDFieldName != null && recordID != null){
            soql += ' where ' + String.escapeSingleQuotes(parentObjectIDFieldName)  + ' = \'' + String.escapeSingleQuotes(recordID) +'\'';
            Sparkle_Helper.AddFieldToObjectsMap(parentObjectIDFieldName, objectApiName, mapObjectsFields);
        }
        
        if (filter1Field != null && filter1Value != null){
            soql += ' AND ' + String.escapeSingleQuotes(filter1Field) + ' = \'' + String.escapeSingleQuotes(filter1Value) + '\'';
            Sparkle_Helper.AddFieldToObjectsMap(filter1Field, objectApiName, mapObjectsFields);
        }
        
        
        // Add order by:
        if (objectDateFieldName != null){
           soql += ' ORDER BY ' + String.escapeSingleQuotes(objectDateFieldName) + ' DESC';
           Sparkle_Helper.AddFieldToObjectsMap(objectDateFieldName, objectApiName, mapObjectsFields); 
        }
        
        // Add return row limit to query string:        
        soql += ' limit ' + String.escapeSingleQuotes(rowsLimit);
        
        // Get List of QueriedRecords
        
        System.debug('######## RecordTimelineServerController - soql: ' + soql);

        // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
        
            List<SObject> lstQueriedRecords = Database.query(soql); 
            
            System.debug('######## RecordTimelineServerController -  lstQueriedRecords: ' + lstQueriedRecords);
           
            
            
            for (SObject e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                RecordTimelineServerController i = new RecordTimelineServerController();
                
                
                i.recordID = String.valueOf( e.get('id') );
                if (objectDisplayDateFieldName != null)
                {                
                    i.dateValue = Sparkle_Helper.GetSobjectField(e, objectDisplayDateFieldName);
                }
                if (subtitleFieldAPIName != null)
                {
                    i.subtitle = Sparkle_Helper.GetSobjectField(e, subtitleFieldAPIName);
                }
                if (titleFieldAPIName != null)
                {
                    i.title = Sparkle_Helper.GetSobjectField(e, titleFieldAPIName);
                }
                	
                if (detail1FieldAPIName != null)
                {
                    i.detail1 = Sparkle_Helper.GetSobjectField(e, detail1FieldAPIName); 
                }
                	
                if (detail2FieldAPIName != null)
                {
                    i.detail2 = Sparkle_Helper.GetSobjectField(e, detail2FieldAPIName);
                }
                

                lstReturnRecords.add(i);

    			System.debug('######## i: ' + i);               
            }
        
        }
        
        System.debug('######## RecordTimelineServerController - lstReturnRecords: ' + lstReturnRecords);
        }

        return lstReturnRecords;

        
    }
    
    


}