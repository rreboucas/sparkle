global with sharing class OffersLCServerController {
@AuraEnabled
    global String recordID { get;set; }
    @AuraEnabled
    global String recordName { get;set; }
    @AuraEnabled
    global String recordStatus { get;set; }
    @AuraEnabled
    global String ExpirationDate { get;set; }
    
    //Constructor
    global OffersLCServerController(String recID) {
        this.recordID = recID;
       
    }
    
    @AuraEnabled
    global static List<OffersLCServerController> getCandidates()
    {
        
        List<OffersLCServerController> lstPosts = new List<OffersLCServerController>();
        
        // Get List of Candidates
        
        List<testautonumdata__Offer__c> lstOffers = [SELECT id, Name,testautonumdata__Candidate__r.Name, testautonumdata__Annual_Salary_Agreed_Amount__c,testautonumdata__Annual_Salary_Offered_Amount__c,testautonumdata__Approved__c,testautonumdata__Expiration_Date__c 
                                                             FROM testautonumdata__Offer__c 
                                                             order by testautonumdata__Approved__c desc, testautonumdata__Expiration_Date__c desc limit 3]; 
        
        
        // Create List of LightningServerController 
        
        Integer counter = 0;
        
        for (testautonumdata__Offer__c e: lstOffers)
        {
            
            OffersLCServerController i = new OffersLCServerController(e.id);
            
            
            i.recordName = e.Name;
            
            String offerStatus = ' ';
            if (e.testautonumdata__Approved__c)
                offerStatus = 'Approved';
            i.recordStatus = offerStatus;
            i.ExpirationDate = e.testautonumdata__Expiration_Date__c.format();

            lstPosts.add(i);

                
        }
        
        
        
        System.debug('######## lstPosts: ' + lstPosts);
        
        return lstPosts;
    }
    

}