public with sharing class ReferralsServerController {
    
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
    public static List<ReferralsServerController> getListRecords(Integer rowsLimit, String recordId, String objectApiName, String ParentObjectFieldName, String filter1Field, String filter1Value, String column1, String RelFieldWithName, String column2) {
        
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## objectApiName: ' + objectApiName);
        
        
        
        List<ReferralsServerController> lstReturnRecords = new List<ReferralsServerController>();
        
        if (recordId != null)
        {
            String fullUserRelationship = RelFieldWithName + '.Name';
            String soql = 'Select id';      
            
            if (column1 != null)
                soql += ', ' + column1;
            
            if (RelFieldWithName != null)
                soql += ', ' + fullUserRelationship;
            
            if (column2 != null)
                soql += ', ' + column2;
            
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            // Add Filter Where clause if provided
            if (ParentObjectFieldName != null)
                soql += ' where ' + ParentObjectFieldName + ' = \'' + recordId +'\'';
            
            if (filter1Field != null && filter1Value != null)
                soql += ' and ' + filter1Field + ' = \'' + filter1Value+'\'';
            
            // Add return row limit to query string:        
            soql += ' limit ' + rowsLimit;
            
            // Get List of QueriedRecords
            
            System.debug('######## soql: ' + soql);
            
            List<SObject> lstQueriedRecords = Database.query(soql); 
            
            System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
           
            
            
            for (SObject e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                ReferralsServerController i = new ReferralsServerController();
                
                i.recordID = GetSobjectField(e, 'id');
                
            	if (column1 != null)
                {
                    i.OwnerID = GetSobjectField(e, column1);
                    
                    ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, i.OwnerID);
                        if (userPhoto != null)
                            i.iconUrl = userPhoto.smallPhotoUrl;
                        else
                            i.iconUrl = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
                }

                if (RelFieldWithName != null)
                {
                    i.OwnerName = GetSobjectField(e, fullUserRelationship);
                    
                }
                if (column2 != null)
                {
                    i.column2 = GetSobjectField(e, column2);
                }
                    
                
    
                lstReturnRecords.add(i);
    
                System.debug('######## i: ' + i);               
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
        
        List<testautonumdata__Referral__c > referralsList = [SELECT Id,OwnerId, Owner.Name,testautonumdata__Referral_Message__c, createddate 
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
        
        System.debug('lstReturnRecords'+ lstReturnRecords);
        
        
        
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