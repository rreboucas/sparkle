public class PositionControllerExtension {
    
    private final testautonumdata__Position__c position;
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public PositionControllerExtension(ApexPages.StandardController stdController) {
        this.position = (testautonumdata__Position__c)stdController.getRecord();
    }

    public String getGreeting() {
        return 'Hello ' + position.name + ' (' + position.id + ')';
    }
    
    public List<testautonumdata__Candidate__c> getTopCandidates() {
        List<testautonumdata__Candidate__c> candidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c 
                                                          where testautonumdata__Position__c =: position.id 
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 3]; 
        return candidates; 
    }

}