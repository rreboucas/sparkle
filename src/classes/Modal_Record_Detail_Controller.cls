public with sharing class Modal_Record_Detail_Controller {
    
    
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
        
        if (recordId != null && objectApiName != null)
        {
            String soql = 'Select id';      
            
            if (column1 != null)
                soql += ', ' + column1;
            
            if (column2 != null)
                soql += ', ' + column2;
            
            if (column3 != null)
                soql += ', ' + column3;
            
            if (column4 != null)
                soql += ', ' + column4;
            
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            // Add Filter Where clause if provided
			soql += ' where id = \'' + recordId +'\'';
            
            
            // Add return row limit to query string:        
            soql += ' limit 1' ;
            
            // Get List of QueriedRecords
            
            System.debug('######## soql: ' + soql);
            
            List<SObject> lstQueriedRecords = Database.query(soql); 
            
            System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
           
            
            
            for (SObject e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                Modal_Record_Detail_Controller i = new Modal_Record_Detail_Controller();
                
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