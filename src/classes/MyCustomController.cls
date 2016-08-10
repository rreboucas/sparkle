public with sharing class MyCustomController {

    private final Account account;

    public MyCustomController() {
        account = new Account();
    }

    public List<testautonumdata__Candidate__c> getTopCandidates() {


        Boolean userHasAccesstoField1 = Schema.sObjectType.testautonumdata__Candidate__c.fields.id.isAccessible() ;
        Boolean userHasAccesstoField2 = Schema.sObjectType.testautonumdata__Candidate__c.fields.testautonumdata__Average_Score__c.isAccessible() ;
        Boolean userHasAccesstoField3 = Schema.sObjectType.testautonumdata__Candidate__c.fields.testautonumdata__Number_of_Interviews__c.isAccessible() ;
        Boolean userHasAccesstoField4 = Schema.sObjectType.testautonumdata__Candidate__c.fields.Name.isAccessible() ;
        List<testautonumdata__Candidate__c> candidates = null;

        if (userHasAccesstoField1 && userHasAccesstoField2 && userHasAccesstoField3 && userHasAccesstoField4){
        candidates = [SELECT id, Name,testautonumdata__Average_Score__c,
                                                          testautonumdata__Number_of_Interviews__c FROM testautonumdata__Candidate__c 
                                                          order by testautonumdata__Number_of_Interviews__c desc, testautonumdata__Average_Score__c desc limit 3]; 
                           }
        return candidates; 
    }
    
    
    public List<testautonumdata__Position__c> getUpcomingPositions() {

        
        Boolean userHasAccesstoField1 = Schema.sObjectType.testautonumdata__Position__c.fields.id.isAccessible() ;
        Boolean userHasAccesstoField2 = Schema.sObjectType.User.fields.name.isAccessible() ;
        Boolean userHasAccesstoField3 = Schema.sObjectType.testautonumdata__Position__c.fields.ownerid.isAccessible() ;
        Boolean userHasAccesstoField4 = Schema.sObjectType.testautonumdata__Position__c.fields.Name.isAccessible() ;
        Boolean userHasAccesstoField5 = Schema.sObjectType.testautonumdata__Position__c.fields.testautonumdata__Fullfilment_Date_Limit__c.isAccessible() ;
        Boolean userHasAccesstoField6 = Schema.sObjectType.testautonumdata__Position__c.fields.testautonumdata__Hiring_Manager__c.isAccessible() ;

        List<testautonumdata__Position__c> positions = null;
        
        if (userHasAccesstoField1 && userHasAccesstoField2 && userHasAccesstoField3 && userHasAccesstoField4 && userHasAccesstoField5 && userHasAccesstoField6){
        positions = [SELECT Id,Name,owner.name, ownerid, testautonumdata__Fullfilment_Date_Limit__c,testautonumdata__Hiring_Manager__c, testautonumdata__Hiring_Manager__r.Name,testautonumdata__Status__c 
                                                        FROM testautonumdata__Position__c 
                                                        where testautonumdata__Fullfilment_Date_Limit__c > TODAY 
                                                        order by testautonumdata__Fullfilment_Date_Limit__c desc limit 3]; 
                                                    }
        return positions; 
    }
    
    
    public List<testautonumdata__Interview__c> getTodaysInterviews() {

        Boolean userHasAccesstoField1 = Schema.sObjectType.testautonumdata__Interview__c.fields.id.isAccessible() ;
        Boolean userHasAccesstoField2 = Schema.sObjectType.testautonumdata__Candidate__c.fields.name.isAccessible() ;
        Boolean userHasAccesstoField3 = Schema.sObjectType.testautonumdata__Interview__c.fields.testautonumdata__Candidate__c.isAccessible() ;
        Boolean userHasAccesstoField4 = Schema.sObjectType.testautonumdata__Interview__c.fields.Name.isAccessible() ;
        Boolean userHasAccesstoField5 = Schema.sObjectType.testautonumdata__Interview__c.fields.testautonumdata__Interview_Type__c.isAccessible() ;

        List<testautonumdata__Interview__c> interviews = null;
        if (userHasAccesstoField1 && userHasAccesstoField2 && userHasAccesstoField3 && userHasAccesstoField4 && userHasAccesstoField5){
        interviews = [SELECT Id,name,testautonumdata__Candidate__c,testautonumdata__Candidate__r.Name, testautonumdata__Interview_Type__c 
                                                          FROM testautonumdata__Interview__c limit 3]; 
                                                      }
        return interviews; 
    }

    public PageReference save() {
        Schema.DescribeSObjectResult drSObj = Schema.sObjectType.Account;
        if (drSObj.isUpdateable()){
            update account;
        }
        return null;
    }
}