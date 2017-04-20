public with sharing class CandidateGeneralController {
    
    
    
    public List<testautonumdata__Candidate__c> getTopCandidates() {

    	Boolean userHasAccesstoField1 = Schema.sObjectType.testautonumdata__Candidate__c.fields.id.isAccessible() ;
        Boolean userHasAccesstoField2 = Schema.sObjectType.testautonumdata__Candidate__c.fields.testautonumdata__Average_Score__c.isAccessible() ;
        Boolean userHasAccesstoField3 = Schema.sObjectType.testautonumdata__Candidate__c.fields.testautonumdata__Number_of_Interviews__c.isAccessible() ;
        Boolean userHasAccesstoField4 = Schema.sObjectType.testautonumdata__Candidate__c.fields.Name.isAccessible() ;

        List<testautonumdata__Candidate__c> candidates = null;
        
        if (userHasAccesstoField1 && userHasAccesstoField2 && userHasAccesstoField3 && userHasAccesstoField4){
        candidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 5]; 
                                                      }
        return candidates; 
    }
    

}