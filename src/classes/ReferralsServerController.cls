public with sharing class ReferralsServerController {

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
    public static List<ReferralsServerController> getListRecords(String rowsLimit, String recordId, String objectApiName, String ParentObjectFieldName, String filter1Field, String filter1Value, String column1, String RelFieldWithName, String column2) {
        
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## objectApiName: ' + objectApiName);
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
        
        List<ReferralsServerController> lstReturnRecords = new List<ReferralsServerController>();
        
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


            
                List<SObject> lstQueriedRecords = Database.query(soql); 
                
                System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
               
            // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
            if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
            {    
                
                for (SObject e: lstQueriedRecords)
                {
                    System.debug('######## e: ' + e);
                    ReferralsServerController i = new ReferralsServerController();
                    
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
    
    @AuraEnabled
    public static List<ReferralsServerController> getReferralsForCandidate(Integer rowsLimit, String recordId) {
        
        List<ReferralsServerController> lstReturnRecords = new List<ReferralsServerController>();
        
     	System.debug('######## rowsLimit: ' + rowsLimit);
        
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## rLimit: ' + rLimit);

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Referral__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('OwnerId', 'testautonumdata__Referral__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Referral_Message__c', 'testautonumdata__Referral__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('createddate', 'testautonumdata__Referral__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Candidate__c', 'testautonumdata__Referral__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Name', 'User', mapObjectsFields);
        
        List<testautonumdata__Referral__c > referralsList = null;

            if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
            {  

                referralsList = [SELECT Id,OwnerId, Owner.Name,testautonumdata__Referral_Message__c, createddate 
                                                                 FROM testautonumdata__Referral__c
                                                                 where testautonumdata__Candidate__c =: recordId
                                                                 limit: rLimit ];
                
                
                
                if (referralsList.size() > 0)
                {
                    System.debug('referralsList.size()'+ referralsList.size());
                    for (testautonumdata__Referral__c e: referralsList)
                    {
                        
                        ReferralsServerController i = new ReferralsServerController();
                        
                        ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, e.OwnerId);
                                if (userPhoto != null)
                                    i.iconUrl = userPhoto.smallPhotoUrl;
                                else
                                    i.iconUrl = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
                        
                        i.recordID = e.Id;
                        
                        i.OwnerName = e.Owner.Name;
                        
                        i.OwnerID = e.OwnerId;
                        
                        i.ReferralMessage = e.testautonumdata__Referral_Message__c;
                        
                        i.ReferralDate = e.createddate.format();
                        
                                        
                        
                        System.debug('i: '+ i);
                        lstReturnRecords.add(i);
                    
                    }
                       System.debug('lstReturnRecords'+ lstReturnRecords);
            	}

            }
        
        System.debug('lstReturnRecords'+ lstReturnRecords);
        
        
        
        return lstReturnRecords;
        
    }


}