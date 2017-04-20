public with sharing class DynamicSearchController {

	private static Map<String, Set<String>> mapObjectsFields = null;

	@AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String displayfieldname { get;set; }

	
	@AuraEnabled
    public static List<DynamicSearchController> findAll(String objectApiName, String displayFieldName, String filter1Field, String filter1Value) {
        
        System.debug('objectApiName: ' + objectApiName);
        List<DynamicSearchController> lstSobjectsToReturn = new List<DynamicSearchController>();

        if (objectApiName != null)
        {
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>();
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        
        
        	String soql = 'Select id';

        	if (displayFieldName != null)
        	{
	            soql += ', ' + String.escapeSingleQuotes(displayFieldName);
	            Sparkle_Helper.AddFieldToObjectsMap(displayFieldName, objectApiName, mapObjectsFields);
        	}

        	// Add object name to query string:        
        	soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);

        	if (filter1Field != null && filter1Value != null)
        	{
        		soql += ' where ' + String.escapeSingleQuotes(filter1Field)  + ' = \'' + String.escapeSingleQuotes(filter1Value) +'\'';
        	}

        	soql += ' order by ' + displayFieldName + ' asc' ;

        	System.debug('######## soql: ' + soql);

        	// CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
	        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
	        {
	        	List<SObject> lstQueriedRecords = Database.query(soql); 

	        	System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);

	        	for (SObject e: lstQueriedRecords)
	            {
	                System.debug('######## e: ' + e);
	                DynamicSearchController i = new DynamicSearchController();
	                
	                
	                i.recordID = String.valueOf( e.get('id') );
	                if (displayFieldName != null)
	                {                
	                    i.displayfieldname = Sparkle_Helper.GetSobjectField(e, displayFieldName);
	                }
	                
	                

	                lstSobjectsToReturn.add(i);

	    			System.debug('######## i: ' + i);               
	            }

	        }


        }
        
        
        System.debug('lstSobjectsToReturn: ' + lstSobjectsToReturn);
        
        return lstSobjectsToReturn;
    }

    @AuraEnabled
    public static List<DynamicSearchController> findByKey(String objectApiName, String displayFieldName , String key, String filter1Field, String filter1Value) {
        
        System.debug('objectApiName: ' + objectApiName);
        System.debug('key: ' + key);
        List<DynamicSearchController> lstSobjectsToReturn = new List<DynamicSearchController>();

        if (objectApiName != null && key != null)
        {
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>();
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Name', objectApiName, mapObjectsFields);
        
        String theKey = '%' + key + '%';
        	String soql = 'Select id';

        	if (displayFieldName != null)
        	{
	            soql += ', ' + String.escapeSingleQuotes(displayFieldName);
	            Sparkle_Helper.AddFieldToObjectsMap(displayFieldName, objectApiName, mapObjectsFields);
        	}

        	// Add object name to query string:        
        	soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);

        	soql += ' where ' + String.escapeSingleQuotes(displayFieldName)  + ' LIKE \''  + String.escapeSingleQuotes(theKey) +'\'';

        	if (filter1Field != null && filter1Value != null)
        	{
        		soql += ' and ' + String.escapeSingleQuotes(filter1Field)  + ' = \'' + String.escapeSingleQuotes(filter1Value) +'\'';
        	}

        	soql += ' order by ' + displayFieldName + ' asc' ;

        	System.debug('######## soql: ' + soql);

        	// CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
	        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
	        {
	        	List<SObject> lstQueriedRecords = Database.query(soql); 

	        	System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);

	        	for (SObject e: lstQueriedRecords)
	            {
	                System.debug('######## e: ' + e);
	                DynamicSearchController i = new DynamicSearchController();
	                
	                
	                i.recordID = String.valueOf( e.get('id') );
	                if (displayFieldName != null)
	                {                
	                    i.displayfieldname = Sparkle_Helper.GetSobjectField(e, displayFieldName);
	                }
	                
	                

	                lstSobjectsToReturn.add(i);

	    			System.debug('######## i: ' + i);               
	            }

	        }


        }
        else
        {	
        	lstSobjectsToReturn = findAll(objectApiName, displayFieldName, filter1Field, filter1Value);

        }
        
        
        System.debug('lstSobjectsToReturn: ' + lstSobjectsToReturn);
        
        return lstSobjectsToReturn;
    }




}