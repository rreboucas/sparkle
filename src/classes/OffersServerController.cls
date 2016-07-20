global with sharing class OffersServerController {
    
    @AuraEnabled
    global String recordID { get;set; }
    @AuraEnabled
    global String offerName { get;set; }
    @AuraEnabled
    global String CandidateId { get;set; }
    @AuraEnabled
    global String CandidateName { get;set; }
    @AuraEnabled
    global String OfferedSalary { get;set; }
    @AuraEnabled
    global String AgreedSalary { get;set; }
    @AuraEnabled
    global String OfferStatus { get;set; }
    @AuraEnabled
    global String ExpirationDate { get;set; }
    
    //Constructor
    global OffersServerController(String recID) {
        this.recordID = recID;
       
    }
    
    @AuraEnabled
    global static List<OffersServerController> getOffers(String positionID)
    {
        
        List<OffersServerController> lstPosts = new List<OffersServerController>();
        
        // Get List of Offers
        
        List<testautonumdata__Offer__c> lstOffers = [SELECT id, Name,testautonumdata__Candidate__c,testautonumdata__Candidate__r.Name, testautonumdata__Annual_Salary_Agreed_Amount__c,testautonumdata__Annual_Salary_Offered_Amount__c,testautonumdata__Approved__c,testautonumdata__Expiration_Date__c 
                                                             FROM testautonumdata__Offer__c where testautonumdata__Candidate__r.testautonumdata__Position__c =: positionID 
                                                             order by testautonumdata__Approved__c desc, testautonumdata__Expiration_Date__c desc limit 5]; 
        
        
        // Create List of OffersServerController 
        
        Integer counter = 0;
        
        for (testautonumdata__Offer__c e: lstOffers)
        {
            
            OffersServerController i = new OffersServerController(e.id);
            
            
            i.offerName = e.Name;
            i.CandidateId = e.testautonumdata__Candidate__c;
            i.CandidateName = e.testautonumdata__Candidate__r.Name;
            i.OfferedSalary = e.testautonumdata__Annual_Salary_Offered_Amount__c.toPlainString();
            i.AgreedSalary = e.testautonumdata__Annual_Salary_Agreed_Amount__c.toPlainString();
            String offerStatus = ' ';
            if (e.testautonumdata__Approved__c)
                offerStatus = 'Approved';
            i.OfferStatus = offerStatus;
            i.ExpirationDate = e.testautonumdata__Expiration_Date__c.format();

            lstPosts.add(i);

                
        }
        
        
        
        System.debug('######## lstPosts: ' + lstPosts);
        
        return lstPosts;
    }

}