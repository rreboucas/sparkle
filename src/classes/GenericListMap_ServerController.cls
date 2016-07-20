public with sharing class GenericListMap_ServerController {
    
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
        
        if (recordIds != null && objectApiName != null)
        {
            String soql = 'Select id';      
            
            if (NameField != null)
                soql += ', ' + NameField;
            
            if (latField != null)
                soql += ', ' + latField ;  
            
            if (longField != null)
                soql += ', ' + longField;
                  
            if (CityField != null)
                soql += ', ' + CityField;
            
            if (StateField != null)
                soql += ', ' + StateField;
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            // Add Filter Where clause if provided
            soql += ' where id in (' + recordIds + ')';
        
            
            // Get List of QueriedRecords
            
            System.debug('######## soql: ' + soql);
            
            List<SObject> lstQueriedRecords = Database.query(soql); 
            
            System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
           
            
            
            for (SObject e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                GenericListMap_ServerController i = new GenericListMap_ServerController();
                
                i.recordID = GetSobjectField(e, 'id');
                
                if (NameField != null)
                {
                    i.Name = GetSobjectField(e, NameField);      
                }
                
            	if (latField != null)
                {
                    i.LatValue = GetSobjectField(e, latField);      
                }

                if (longField != null)
                {
                    i.LongValue = GetSobjectField(e, longField);
                    
                }
                if (CityField != null)
                {
                    i.City = GetSobjectField(e, CityField);
                }
                if (StateField != null)
                {
                    i.State = GetSobjectField(e, StateField);
                }    
                
    
                lstReturnRecords.add(i);
    
                System.debug('######## i: ' + i);               
            }
        
        
        }
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
        return lstReturnRecords;
        
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