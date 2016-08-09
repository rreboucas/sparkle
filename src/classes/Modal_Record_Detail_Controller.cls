public with sharing class Modal_Record_Detail_Controller {
    
    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String column1 { get;set; }
    @AuraEnabled
    public String column2 { get;set; }
    @AuraEnabled
    public String column3 { get;set; }
    @AuraEnabled
    public String column4 { get;set; }
    
    
    @AuraEnabled
    public static List<Modal_Record_Detail_Controller> getListRecords(String recordId, String objectApiName, String column1, String column2, String column3, String column4) {
        
        System.debug('########Modal_Record_Detail_Controller:  recordId: ' + recordId);
        System.debug('########Modal_Record_Detail_Controller:  objectApiName: ' + objectApiName);
        
        
        List<Modal_Record_Detail_Controller> lstReturnRecords = new List<Modal_Record_Detail_Controller>();
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 

        if (recordId != null && objectApiName != null)
        {
            String soql = 'Select id';
            Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);      
            
            if (column1 != null){
                soql += ', ' + String.escapeSingleQuotes(column1);
                Sparkle_Helper.AddFieldToObjectsMap(column1, objectApiName, mapObjectsFields);
            }
            
            if (column2 != null){
                soql += ', ' + String.escapeSingleQuotes(column2);
                Sparkle_Helper.AddFieldToObjectsMap(column2, objectApiName, mapObjectsFields);
            }
            
            if (column3 != null){
                soql += ', ' + String.escapeSingleQuotes(column3);
                Sparkle_Helper.AddFieldToObjectsMap(column3, objectApiName, mapObjectsFields);
            }
            
            if (column4 != null){
                soql += ', ' + String.escapeSingleQuotes(column4);
                Sparkle_Helper.AddFieldToObjectsMap(column4, objectApiName, mapObjectsFields);
            }
            
            
            // Add object name to query string:        
            soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
            
            // Add Filter Where clause if provided
			soql += ' where id = \'' + String.escapeSingleQuotes(recordId)  + '\'';
            
            
            // Add return row limit to query string:        
            soql += ' limit 1' ;
            
            // Get List of QueriedRecords
            
            System.debug('######## soql: ' + soql);

            // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
            if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
            {
            
                List<SObject> lstQueriedRecords = Database.query(soql); 
                
                System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
               
                
                
                for (SObject e: lstQueriedRecords)
                {
                    System.debug('######## e: ' + e);
                    Modal_Record_Detail_Controller i = new Modal_Record_Detail_Controller();
                    
                	if (column1 != null)
                    {
                        i.column1 = Sparkle_Helper.GetSobjectField(e, column1);                     
                    }

                    if (column2 != null)
                    {
                        i.column2 = Sparkle_Helper.GetSobjectField(e, column2);
                    }
                    if (column3 != null)
                    {
                        i.column3 = Sparkle_Helper.GetSobjectField(e, column3);
                    }    
                    if (column4 != null)
                    {
                        i.column4 = Sparkle_Helper.GetSobjectField(e, column4);
                    }
        
                    lstReturnRecords.add(i);
        
                    System.debug('######## i: ' + i);               
                }
            }
        
        }
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
        return lstReturnRecords;
        
    }
    


}