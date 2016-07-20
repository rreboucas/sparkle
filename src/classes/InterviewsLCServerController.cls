public with sharing class InterviewsLCServerController {
    
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
    

    
    
    private static void AddFieldToObjectsMap(String fieldName, String initialObjectName)
    {
        if (fieldName.contains('.')) // than it is a parent-relationship field
                { 
                    String relName1 = fieldName.substringBefore('.');
                    String relField1 = fieldName.substringAfter('.');
                    if (relField1.contains('.')) // than it is a 2 level parent-relationship field
                    {
                       String relName2 = relField1.substringBefore('.');
                       String relField2 = relField1.substringAfter('.');
                       
                        // Check if it is a custom relationship field
                        if (relName2.contains('__r')) // than it is a custom relationship
                        {
                            // Object name is the field name replacing "__r" for "__c"
                            String objectName2 = relName2.replace('__r', '__c');
                            AddFieldToMap(relField2, objectName2);
                        }
                        else // than it is a standard relationship field
                        {
                            // get the standard object name from a list of values (example: Ownerid = User)
                        }
                        
                    }
                    else // than it is a 1 level parent-relationship field
                    {
                        // Check if it is a custom relationship field
                        if (relName1.contains('__r')) // than it is a custom relationship
                        {
                            // Object name is the field name replacing "__r" for "__c"
                            String objectName1 = relName1.replace('__r', '__c');
                            AddFieldToMap(relField1, objectName1);
                        }
                        else // than it is a standard relationship field
                        {
                            // get the standard object name from a list of values (example: Ownerid = User)
                        }
                        
                    }
                    
                    
                }
        else
			AddFieldToMap(fieldName, initialObjectName);
        
    }
    
    private static void AddFieldToMap(String fieldName, String ObjectName)
    {
        // Check if object name is already on the map of objects and fields 
        if (mapObjectsFields.containsKey(ObjectName)) // if it is, add the field to the set of field names for the object
            {
                Set<String> existingFieldSet = mapObjectsFields.get(ObjectName);
                existingFieldSet.add(fieldName);
                mapObjectsFields.put(ObjectName, existingFieldSet);
            }
        else // if not, add the object name and the field name to the map
        {
            Set<String> newFieldSet = new Set<String>();
            newFieldSet.add(fieldName);
            mapObjectsFields.put(ObjectName, newFieldSet);
        }
        
    }


    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static List<InterviewsLCServerController> getListRecords(String rowsLimit, String objectApiName, String filter1Field, String filter1Value, String eventField, String column1, String column2, String column3, String column4, String sortField, String sortDirection) {
        
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## objectApiName: ' + objectApiName);
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        AddFieldToObjectsMap('Id', objectApiName);
        
        List<InterviewsLCServerController> lstReturnRecords = new List<InterviewsLCServerController>();
        
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## rLimit: ' + rLimit);
        
        
        
        String soql = 'Select id';
        
        if (eventField != null && !eventField.equalsIgnoreCase('Id'))
        {
            soql += ', ' + String.escapeSingleQuotes(eventField);
            AddFieldToObjectsMap(eventField, objectApiName);
        }
        
        if (column1 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column1);
            AddFieldToObjectsMap(column1, objectApiName);
        }
        if (column2 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column2);
            AddFieldToObjectsMap(column2, objectApiName);
        }
        if (column3 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column3);
            AddFieldToObjectsMap(column3, objectApiName);
        }
        if (column4 != null)
        {
            soql += ', ' + String.escapeSingleQuotes(column4);
            AddFieldToObjectsMap(column4, objectApiName);
        }
        // Add object name to query string:        
        soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
        
        // Add Filter Where clause if provided
        if (filter1Field != null && filter1Value != null)
        {
            soql += ' where ' + String.escapeSingleQuotes(filter1Field)  + ' = \'' + String.escapeSingleQuotes(filter1Value) +'\'';
            AddFieldToObjectsMap(filter1Field, objectApiName);
        }
        // Add Order By clause if provided
        if (sortField != null && sortDirection != null)
        {
            soql += ' order by ' + String.escapeSingleQuotes(sortField)  + ' ' + String.escapeSingleQuotes(sortDirection);
            AddFieldToObjectsMap(sortField, objectApiName);
        }
        // Add return row limit to query string:        
        soql += ' limit ' + String.escapeSingleQuotes(rowsLimit);
        
        // Get List of QueriedRecords
        
        System.debug('######## soql: ' + soql);
        
        
        
        
        // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested:
        // Check if map of object fields has values
        if (mapObjectsFields.size() > 0)
        {
            System.debug('######## mapObjectsFields: ' + mapObjectsFields);
            for (String objectName: mapObjectsFields.keySet())
            {
                System.debug('######## objectName: ' + objectName);
                SObject sObj = Schema.getGlobalDescribe().get(objectName).newSObject() ;
                Map<String,Schema.SObjectField> m = sObj.getSobjectType().getDescribe().fields.getMap();
                Set<String> objectFieldSet = mapObjectsFields.get(objectName);
                
                for (String fieldToCheck : objectFieldSet) {
    				System.debug('######## fieldToCheck: ' + fieldToCheck);
                    // Check if the user has access to view field
                    if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
            			System.debug('######## User does not have access to field: ' + fieldToCheck);
                        // Pass error to client
                        throw new System.NoAccessException();
            
                       // Suppress editor logs
                       return null;
                    }
                    System.debug('######## User has access to field: ' + fieldToCheck);
                }
                
            }
            
        }
        
        
        List<SObject> lstQueriedRecords = Database.query(soql); 
        
        System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
       
        
        
        for (SObject e: lstQueriedRecords)
        {
            System.debug('######## e: ' + e);
            InterviewsLCServerController i = new InterviewsLCServerController();
            
            
            i.recordID = String.valueOf( e.get('id') );
            if (eventField != null)
            {                
                i.eventField = GetSobjectField(e, eventField);
            }
            if (column1 != null)
            {
                i.column1 = GetSobjectField(e, column1);
            }
            if (column2 != null)
            {
                i.column2 = GetSobjectField(e, column2);
            }
            	
            if (column3 != null)
            {
                i.column3 = GetSobjectField(e, column3); 
            }
            	
            if (column4 != null)
            {
                i.column4 = GetSobjectField(e, column4);
            }
            

            lstReturnRecords.add(i);

			System.debug('######## i: ' + i);               
        }
        
        
        
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
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