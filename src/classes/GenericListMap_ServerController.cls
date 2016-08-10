public with sharing class GenericListMap_ServerController {

    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String Name { get;set; }
    @AuraEnabled
    public String LatValue { get;set; }
    @AuraEnabled
    public String LongValue { get;set; }
    @AuraEnabled
    public String City { get;set; }
    @AuraEnabled
    public String State { get;set; }

    
    
    @AuraEnabled
    public static List<GenericListMap_ServerController> getListRecords(String recordIds, String objectApiName, String NameField, String latField, String longField, String CityField, String StateField) {
        
        System.debug('######## GenericListMap_ServerController.getListRecords: objectApiName: ' + objectApiName);
        System.debug('######## GenericListMap_ServerController.getListRecords: recordIds: ' + recordIds);
        
        
        List<GenericListMap_ServerController> lstReturnRecords = new List<GenericListMap_ServerController>();
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 

        if (recordIds != null && objectApiName != null)
        {
            String soql = 'Select id'; 
            Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);     
            
            if (NameField != null){
                soql += ', ' + String.escapeSingleQuotes(NameField);
                Sparkle_Helper.AddFieldToObjectsMap(NameField, objectApiName, mapObjectsFields);
            }
            
            if (latField != null){
                soql += ', ' + String.escapeSingleQuotes(latField);
                Sparkle_Helper.AddFieldToObjectsMap(latField, objectApiName, mapObjectsFields);
            }
            
            if (longField != null){
                soql += ', ' + String.escapeSingleQuotes(longField);
                Sparkle_Helper.AddFieldToObjectsMap(longField, objectApiName, mapObjectsFields);
            }
                  
            if (CityField != null){
                soql += ', ' + String.escapeSingleQuotes(CityField);
                Sparkle_Helper.AddFieldToObjectsMap(CityField, objectApiName, mapObjectsFields);
            }
            
            if (StateField != null){
                soql += ', ' + String.escapeSingleQuotes(StateField);
                Sparkle_Helper.AddFieldToObjectsMap(StateField, objectApiName, mapObjectsFields);
            }
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            // Add Filter Where clause if provided
            soql += ' where id in (' + recordIds + ')';
        
            
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
                GenericListMap_ServerController i = new GenericListMap_ServerController();
                
                i.recordID = Sparkle_Helper.GetSobjectField(e, 'id');
                
                if (NameField != null)
                {
                    i.Name = Sparkle_Helper.GetSobjectField(e, NameField);      
                }
                
            	if (latField != null)
                {
                    i.LatValue = Sparkle_Helper.GetSobjectField(e, latField);      
                }

                if (longField != null)
                {
                    i.LongValue = Sparkle_Helper.GetSobjectField(e, longField);
                    
                }
                if (CityField != null)
                {
                    i.City = Sparkle_Helper.GetSobjectField(e, CityField);
                }
                if (StateField != null)
                {
                    i.State = Sparkle_Helper.GetSobjectField(e, StateField);
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