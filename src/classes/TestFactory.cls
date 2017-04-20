@isTest
public class TestFactory {
    // define default constants that can be accessible to assert against.

    public static final String DEFAULT_ACCOUNT_NAME = 'ACME Inc.';


    /* The “create” methods are used to instantiate the sobjects without inserting them. 
       This is tremendously helpful when you need to create a particular record and then tweak it before 
       it’s inserted from the calling code. */  

    
    public static Account createAccount(){

          return createAccount(DEFAULT_ACCOUNT_NAME);

    }

 

    /* The create methods are commonly overloaded to allow different properties to be set. */

    public static Account createAccount(String name){

           return new Account(

               Name = name

           );

    }
    

    public static Contact createContact(String fname, String lname,  String accountID){

           return new Contact(

               FirstName = fname,
               LastName = lname,
               Accountid = accountID

           );

    }

    public static EntitySubscription createEntitySubs(id prentID, id subscrID){

           return new EntitySubscription(

               ParentId = prentID,
               SubscriberId = subscrID

           );

    }

    public static testautonumdata__Candidate__c createCandidate(String name, String fname, String city, String email, String lname, String state, String twitterid){

           return new testautonumdata__Candidate__c(
           	   Name = name,
               testautonumdata__First_Name__c = fname,
               testautonumdata__City__c = city,
               testautonumdata__E_mail__c = email,
               testautonumdata__Last_Name__c = lname,
               testautonumdata__State__c = state,
               testautonumdata__Twitter_ID__c = twitterid

           );

    }
    
    public static testautonumdata__Candidate__c createCandidateWithPosition(String name, String fname, String city, String email, String lname, String state, String twitterid, String positionId){

           return new testautonumdata__Candidate__c(
           	   Name = name,
               testautonumdata__First_Name__c = fname,
               testautonumdata__City__c = city,
               testautonumdata__E_mail__c = email,
               testautonumdata__Last_Name__c = lname,
               testautonumdata__State__c = state,
               testautonumdata__Twitter_ID__c = twitterid,
               testautonumdata__Position__c = positionId

           );

    }

    public static testautonumdata__Position__c createPosition(String name, String recStatus){

    	Date todaysDt = Date.today();
    	Date fDate = todaysDt.addMonths(6);

           return new testautonumdata__Position__c(
           	   Name = name,
               testautonumdata__Status__c = recStatus,
               testautonumdata__Fullfilment_Date_Limit__c = fDate

           );

    }

    public static testautonumdata__Interview__c createInterview(String candidateId, String recType, String recStatus){

    	DateTime myDateTime = datetime.now();
    	DateTime fDate = myDateTime.addMonths(1);

           return new testautonumdata__Interview__c(
           	   testautonumdata__Candidate__c = candidateId,
               testautonumdata__Status__c = recStatus,
               testautonumdata__Interview_Date__c = fDate,
               testautonumdata__Interview_Type__c = recType

           );

    }

	public static testautonumdata__Interviewer__c createInterviewer(String interviewId){

           return new testautonumdata__Interviewer__c(
           	   testautonumdata__Interview__c = interviewId

           );

    } 
    
    
    public static testautonumdata__Offer__c createOffer(String candidateId, Double salary, Double bonus){

           return new testautonumdata__Offer__c(
           	   testautonumdata__Candidate__c = candidateId, 
               testautonumdata__Annual_Salary_Offered_Amount__c = salary, 
               testautonumdata__Annual_Bonus_Amount__c  = bonus

           );

    }
    
    /*
    public static EmailTemplate createEmailTemplate(String Body,FolderId,HtmlValue,Id,IsActive,Name,NamespacePrefix,OwnerId,Subject){

           return new testautonumdata__Offer__c(
           	   testautonumdata__Candidate__c = candidateId, 
               testautonumdata__Annual_Salary_Offered_Amount__c = salary, 
               testautonumdata__Annual_Bonus_Amount__c  = bonus

           );

    }
*/

    /* The “Insert” methods are used to create the sobjects and then insert them. They delegate 
       the creation to the create methods and then insert the records. Like the create methods,
       the insert methods are overloaded to allow different properties to be set as necessary.
       Another best practice is to bulk insert or bulk create data, but to keep the sample short, that’s omitted. */

    public static Account insertAccount(){

          Account accountToInsert = createAccount();
          insert accountToInsert;
          return accountToInsert;

    }

    public static Contact insertContact(String fname, String lname,  String accountID){

          Contact contactToInsert = createContact(fname, lname, accountID);
          insert contactToInsert;
          return contactToInsert;

    }
    
    public static EntitySubscription insertEntitySubscription(id parentID, id subscriberID){

          EntitySubscription entToInsert = createEntitySubs(parentID, subscriberID);
          insert entToInsert;
          return entToInsert;

    }

    public static testautonumdata__Candidate__c insertCandidate(String name, String fname, String city, String email, String lname, String state, String twitterid){

          testautonumdata__Candidate__c entToInsert = createCandidate(name, fname, city, email, lname, state, twitterid);
          insert entToInsert;
          return entToInsert;

    }
    
    public static testautonumdata__Candidate__c insertCandidatewithPosition(String name, String fname, String city, String email, String lname, String state, String twitterid, String positionId){

          testautonumdata__Candidate__c entToInsert = createCandidateWithPosition(name, fname, city, email, lname, state, twitterid, positionId);
          insert entToInsert;
          return entToInsert;

    }

    public static testautonumdata__Position__c insertPosition(String name, String recStatus){

          testautonumdata__Position__c entToInsert = createPosition(name, recStatus);
          insert entToInsert;
          return entToInsert;

    }

    public static testautonumdata__Interview__c insertInterview(String candidateId, String recType, String recStatus){

          testautonumdata__Interview__c entToInsert = createInterview(candidateId, recType, recStatus);
          insert entToInsert;
          return entToInsert;

    }

    public static testautonumdata__Interviewer__c insertInterviewer(String interviewId){

          testautonumdata__Interviewer__c entToInsert = createInterviewer(interviewId);
          insert entToInsert;
          return entToInsert;

    }
    
    public static testautonumdata__Offer__c insertOffer(String candidateId, Double salary, Double bonus){

          testautonumdata__Offer__c entToInsert = createOffer(candidateId, salary, bonus);
          insert entToInsert;
          return entToInsert;

    }

}