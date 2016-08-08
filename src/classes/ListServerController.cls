public with sharing class ListServerController {
    
    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String eventField { get;set; }
    @AuraEnabled
    public String column1 { get;set; }
    @AuraEnabled
    public String column2 { get;set; }
    @AuraEnabled
    public String column3 { get;set; }
    @AuraEnabled
    public String column4 { get;set; }
    

    

    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static List<ListServerController> getListRecords(String rowsLimit, String objectApiName, String filter1Field, String filter1Value, String eventField, String column1, String column2, String column3, String column4, String sortField, String sortDirection) {
        
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## objectApiName: ' + objectApiName);
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        
        List<ListServerController> lstReturnRecords = new List<ListServerController>();
        
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## rLimit: ' + rLimit);
        
        
        
        String soql = 'Select id';
        
        if (eventField != null && !eventField.equalsIgnoreCase('Id'))
        {
            soql += ', ' + String.escapeSingleQuotes(eventField);
            Sparkle_Helper.AddFieldToObjectsMap(eventField, objectApiName, mapObjectsFields);
        }
        
        if (column1 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column1);
            Sparkle_Helper.AddFieldToObjectsMap(column1, objectApiName, mapObjectsFields);
        }
        if (column2 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column2);
            Sparkle_Helper.AddFieldToObjectsMap(column2, objectApiName, mapObjectsFields);
        }
        if (column3 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column3);
            Sparkle_Helper.AddFieldToObjectsMap(column3, objectApiName, mapObjectsFields);
        }
        if (column4 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column4);
            Sparkle_Helper.AddFieldToObjectsMap(column4, objectApiName, mapObjectsFields);
        }
        // Add object name to query string:        
        soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
        
        // Add Filter Where clause if provided
        if (filter1Field != null && filter1Value != null)
        {
            soql += ' where ' + String.escapeSingleQuotes(filter1Field)  + ' = \'' + String.escapeSingleQuotes(filter1Value) +'\'';
            Sparkle_Helper.AddFieldToObjectsMap(filter1Field, objectApiName, mapObjectsFields);
        }
        // Add Order By clause if provided
        if (sortField != null && sortDirection != null)
        {
            soql += ' order by ' + String.escapeSingleQuotes(sortField)  + ' ' + String.escapeSingleQuotes(sortDirection);
            Sparkle_Helper.AddFieldToObjectsMap(sortField, objectApiName, mapObjectsFields);
        }
        // Add return row limit to query string:        
        soql += ' limit ' + String.escapeSingleQuotes(rowsLimit);
        
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
                ListServerController i = new ListServerController();
                
                
                i.recordID = String.valueOf( e.get('id') );
                if (eventField != null)
                {                
                    i.eventField = Sparkle_Helper.GetSobjectField(e, eventField);
                }
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
        
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
        return lstReturnRecords;
        //
        
    }

    @AuraEnabled
    public static User getCurrentUser() {
      User user = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
      return user;
  }
    


    
}