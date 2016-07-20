global with sharing class LightningServerController {
    
    @AuraEnabled
    global String recordID { get;set; }
    @AuraEnabled
    global String recordName { get;set; }
    @AuraEnabled
    global String averageScore { get;set; }
    @AuraEnabled
    global String numberOfInterviews { get;set; }
    
    //Constructor
    global LightningServerController(String recID) {
        this.recordID = recID;
       
    }
    
    @AuraEnabled
    global static List<LightningServerController> getCandidates()
    {
        
        List<LightningServerController> lstPosts = new List<LightningServerController>();
        
        // Get List of Candidates
        
        List<testautonumdata__Candidate__c> lstCandidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c 
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 3]; 
        
        
        // Create List of LightningServerController 
        
        Integer counter = 0;
        
        for (testautonumdata__Candidate__c e: lstCandidates)
        {
            
            LightningServerController i = new LightningServerController(e.id);
            
            
            i.recordName = e.Name;
            
            i.averageScore = String.valueOf(e.testautonumdata__Average_Score__c);
            
            i.numberOfInterviews = String.valueOf(e.testautonumdata__Number_of_Interviews__c);

            lstPosts.add(i);

                
        }
        
        
        
        System.debug('######## lstPosts: ' + lstPosts);
        
        return lstPosts;
    }
    

}