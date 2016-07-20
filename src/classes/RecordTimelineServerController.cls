public with sharing class RecordTimelineServerController {
    
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
        
        List<RecordTimelineServerController> lstReturnRecords = new List<RecordTimelineServerController>();
        if (!String.isBlank(recordID))
        {
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## RecordTimelineServerController: rLimit: ' + rLimit);
        
        String soql = 'Select id';
        
        if (objectDisplayDateFieldName != null)
            soql += ', ' + objectDisplayDateFieldName;
        
        if (detail1FieldAPIName != null)
            soql += ', ' + detail1FieldAPIName;
        
        if (detail2FieldAPIName != null)
            soql += ', ' + detail2FieldAPIName;
        
        if (titleFieldAPIName != null)
            soql += ', ' + titleFieldAPIName;
        
        if (subtitleFieldAPIName != null)
            soql += ', ' + subtitleFieldAPIName;
        
        // Add object name to query string:        
        soql += ' FROM ' + objectApiName;
        
        // Add Filter Where clause if provided
        if (parentObjectIDFieldName != null && recordID != null)
            soql += ' where ' + parentObjectIDFieldName + ' = \'' + recordID+'\'';
        
        if (filter1Field != null && filter1Value != null)
            soql += ' AND ' + filter1Field + ' = \'' + filter1Value+'\'';
        
        
        // Add order by:
        if (objectDateFieldName != null)
           soql += ' ORDER BY ' + objectDateFieldName + ' DESC'; 
        
        // Add return row limit to query string:        
        soql += ' limit ' + rowsLimit;
        
        // Get List of QueriedRecords
        
        System.debug('######## RecordTimelineServerController - soql: ' + soql);
        
        List<SObject> lstQueriedRecords = Database.query(soql); 
        
        System.debug('######## RecordTimelineServerController -  lstQueriedRecords: ' + lstQueriedRecords);
       
        
        
        for (SObject e: lstQueriedRecords)
        {
            System.debug('######## e: ' + e);
            RecordTimelineServerController i = new RecordTimelineServerController();
            
            
            i.recordID = String.valueOf( e.get('id') );
            if (objectDisplayDateFieldName != null)
            {                
                i.dateValue = GetSobjectField(e, objectDisplayDateFieldName);
            }
            if (subtitleFieldAPIName != null)
            {
                i.subtitle = GetSobjectField(e, subtitleFieldAPIName);
            }
            if (titleFieldAPIName != null)
            {
                i.title = GetSobjectField(e, titleFieldAPIName);
            }
            	
            if (detail1FieldAPIName != null)
            {
                i.detail1 = GetSobjectField(e, detail1FieldAPIName); 
            }
            	
            if (detail2FieldAPIName != null)
            {
                i.detail2 = GetSobjectField(e, detail2FieldAPIName);
            }
            

            lstReturnRecords.add(i);

			System.debug('######## i: ' + i);               
        }
        
        
        
        System.debug('######## RecordTimelineServerController - lstReturnRecords: ' + lstReturnRecords);
        }
        return lstReturnRecords;
        //
        
    }
    
    private static String GetSobjectField(Sobject e, String lcfield)
    {
        
        String returnValue = '';
        
        if (lcfield.contains('.')) // than it is a parent-relationship field
                {
                    String relName = lcfield.substringBefore('.');
                    String relField = lcfield.substringAfter('.');
                    if (relField.contains('.')) // than it is a 2 level parent-relationship field
                    {
                       String relName2 = relField.substringBefore('.');
                       String relField2 = relField.substringAfter('.');
                       returnValue = String.valueOf(e.getSObject(relName).getSObject(relName2).get(relField2));
                    }
                    else
                    	returnValue = String.valueOf(e.getSObject(relName).get(relField));
                }
                    
                else
                	returnValue = String.valueOf( e.get(lcfield) );
     
        return returnValue;
    } 
    


}