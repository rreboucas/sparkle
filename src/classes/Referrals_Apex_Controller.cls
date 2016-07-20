public with sharing class Referrals_Apex_Controller {
    
    @AuraEnabled
    public String recordID { get;set; }
    @AuraEnabled
    public String OwnerName { get;set; }
    @AuraEnabled
    public String OwnerID { get;set; }
    @AuraEnabled
    public String ReferralMessage { get;set; }
    @AuraEnabled
    public String ReferralDate { get;set; }
    @AuraEnabled
    public String iconUrl { get;set; }
    
    
    @AuraEnabled
    public static List<Referrals_Apex_Controller> getReferralsForCandidate(Integer rowsLimit, String recordId) {
        
        List<Referrals_Apex_Controller> lstReturnRecords = new List<Referrals_Apex_Controller>();
        
     	System.debug('######## rowsLimit: ' + rowsLimit);
        
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## rLimit: ' + rLimit);
        
        List<testautonumdata__Referral__c > referralsList = [SELECT Id,OwnerId, Owner.Name,testautonumdata__Referral_Message__c, createddate 
                                                         FROM testautonumdata__Referral__c
                                                         where id =: recordId
                                                         limit: rLimit ];
        
        
        
        if (referralsList.size() > 0)
        {
            System.debug('referralsList.size()'+ referralsList.size());
            for (testautonumdata__Referral__c e: referralsList)
            {
                
                Referrals_Apex_Controller i = new Referrals_Apex_Controller();
                
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

}