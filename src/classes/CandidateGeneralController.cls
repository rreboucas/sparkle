public class CandidateGeneralController {
    
    
    
    public List<testautonumdata__Candidate__c> getTopCandidates() {
        List<testautonumdata__Candidate__c> candidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 5]; 
        return candidates; 
    }
    

}