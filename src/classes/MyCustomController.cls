public class MyCustomController {

    private final Account account;

    public MyCustomController() {
        account = new Account();
    }

    public List<testautonumdata__Candidate__c> getTopCandidates() {
        List<testautonumdata__Candidate__c> candidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c 
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 3]; 
        return candidates; 
    }
    
    
    public List<testautonumdata__Position__c> getUpcomingPositions() {
        List<testautonumdata__Position__c> positions = [SELECT Id,Name,owner.name, ownerid, testautonumdata__Fullfilment_Date_Limit__c,testautonumdata__Hiring_Manager__c, testautonumdata__Hiring_Manager__r.Name,testautonumdata__Status__c 
                                                        FROM testautonumdata__Position__c 
                                                        where testautonumdata__Fullfilment_Date_Limit__c > TODAY 
                                                        order by testautonumdata__Fullfilment_Date_Limit__c desc limit 3]; 
        return positions; 
    }
    
    
    public List<testautonumdata__Interview__c> getTodaysInterviews() {
        List<testautonumdata__Interview__c> interviews = [SELECT Id,name,testautonumdata__Candidate__c,testautonumdata__Candidate__r.Name, testautonumdata__Interview_Type__c 
                                                          FROM testautonumdata__Interview__c limit 3]; 
        return interviews; 
    }

    public PageReference save() {
        update account;
        return null;
    }
}