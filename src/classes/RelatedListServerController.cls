public with sharing class RelatedListServerController {

    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String OwnerName { get;set; }
    @AuraEnabled
    public String OwnerID { get;set; }
    @AuraEnabled
    public String column2 { get;set; }
    @AuraEnabled
    public String ReferralMessage { get;set; }
    @AuraEnabled
    public String ReferralDate { get;set; }
    @AuraEnabled
    public String iconUrl { get;set; }
    
    
    @AuraEnabled
    public static List<RelatedListServerController> getListRecords(String rowsLimit, String recordId, String objectApiName, String ParentObjectFieldName, String filter1Field, String filter1Value, String column1, String RelFieldWithName, String column2) {
        
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## objectApiName: ' + objectApiName);

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        
        
        
        List<RelatedListServerController> lstReturnRecords = new List<RelatedListServerController>();
        
        if (recordId != null)
        {
            String fullUserRelationship = RelFieldWithName + '.Name';
            String soql = 'Select id';      
            
            if (column1 != null){
                soql += ', ' + String.escapeSingleQuotes(column1);
                Sparkle_Helper.AddFieldToObjectsMap(column1, objectApiName, mapObjectsFields);
            }
            
            if (RelFieldWithName != null){
                soql += ', ' + String.escapeSingleQuotes(fullUserRelationship);
            }
            
            if (column2 != null){
                soql += ', ' + String.escapeSingleQuotes(column2);
                Sparkle_Helper.AddFieldToObjectsMap(column2, objectApiName, mapObjectsFields);
            }
            
            
            // Add object name to query string:        
            soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
            
            // Add Filter Where clause if provided
            if (ParentObjectFieldName != null){
                soql += ' where ' + String.escapeSingleQuotes(ParentObjectFieldName)  + ' = \'' + String.escapeSingleQuotes(recordId) +'\'';
                Sparkle_Helper.AddFieldToObjectsMap(ParentObjectFieldName, objectApiName, mapObjectsFields);
            }
            
            if (filter1Field != null && filter1Value != null){
                soql += ' and ' + String.escapeSingleQuotes(filter1Field) + ' = \'' + String.escapeSingleQuotes(filter1Value) +'\'';
                Sparkle_Helper.AddFieldToObjectsMap(filter1Field, objectApiName, mapObjectsFields);
            }
            
            // Add return row limit to query string:        
            soql += ' limit '  + String.escapeSingleQuotes(rowsLimit);
            
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
                        RelatedListServerController i = new RelatedListServerController();
                        
                        i.recordID = Sparkle_Helper.GetSobjectField(e, 'id');
                        
                    	if (column1 != null)
                        {
                            i.OwnerID = Sparkle_Helper.GetSobjectField(e, column1);
                            
                            ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, i.OwnerID);
                                if (userPhoto != null)
                                    i.iconUrl = userPhoto.smallPhotoUrl;
                                else
                                    i.iconUrl = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
                        }

                        if (RelFieldWithName != null)
                        {
                            i.OwnerName = Sparkle_Helper.GetSobjectField(e, fullUserRelationship);
                            
                        }
                        if (column2 != null)
                        {
                            i.column2 = Sparkle_Helper.GetSobjectField(e, column2);
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