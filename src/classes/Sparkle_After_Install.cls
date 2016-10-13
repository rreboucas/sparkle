global class Sparkle_After_Install implements InstallHandler {
	
	global void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
      Twitter_User__c cstRecord = new Twitter_User__c(Name = 'TwitterApp',
    	Token_Secret__c  = 'LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx',
    	Token__c  = 'crTSqn98nBWCC8lbj0IauMv06');
       Database.UpsertResult urList = Database.upsert(cstRecord, true);


       // Insert Sample Position record

       /*
       Date todaysDt = Date.today();
       Date fDate = todaysDt.addMonths(6);
       testautonumdata__Position__c positionA = new testautonumdata__Position__c(
           	   Name = 'Position1',
               testautonumdata__Status__c = 'Open',
               testautonumdata__Fullfilment_Date_Limit__c = fDate

           );
       Database.UpsertResult urList2 = Database.upsert(positionA, true);


       // Insert Sample Candidate Record

       testautonumdata__Candidate__c candidateA = new testautonumdata__Candidate__c(
           	   Name = 'Candidate A',
               testautonumdata__First_Name__c = 'Candidate',
               testautonumdata__City__c = 'San Francisco',
               testautonumdata__E_mail__c = 'r@r.com',
               testautonumdata__Last_Name__c = 'A',
               testautonumdata__State__c = 'CA',
               testautonumdata__Twitter_ID__c = '@roreb'

           );
       Database.UpsertResult urList3 = Database.upsert(candidateA, true);


       // Insert Sample Interview Records

        testautonumdata__Interview__c interviewA = new testautonumdata__Interview__c(
           	   testautonumdata__Candidate__c = candidateA.id,
               testautonumdata__Status__c = 'Pending',
               testautonumdata__Interview_Date__c = fDate,
               testautonumdata__Interview_Type__c = 'Technical Interview'

           );
       Database.UpsertResult urList4 = Database.upsert(interviewA, true);


       // Insert Sample Referral Records

       testautonumdata__Referral__c referralA = new testautonumdata__Referral__c(
           	   testautonumdata__Candidate__c = candidateA.id,
               testautonumdata__Referral_Message__c = 'I refer this candidate'

           );
       Database.UpsertResult urList5 = Database.upsert(referralA, true);
*/

       // Insert Sample Files
       /*
       String myTitle = 'Title for this contentVersion';
       String myPathOnClient = 'file_' + Datetime.now().getTime() + '.txt';
       Blob myVersionData = Blob.valueOf('My Content in file_' + Datetime.now().getTime() + '.txt');
       String myOrigin = 'H';

       ContentVersion entToInsert = new ContentVersion(
                Title = myTitle,
                PathOnClient = myPathOnClient,
                VersionData = myVersionData,
                Origin = myOrigin

           );
       Database.UpsertResult urList6 = Database.upsert(entToInsert, true);


        FeedItem theFile = new FeedItem(
               
            Body = 'Post with related document body', 
            ParentId = candidateA.id, 
            RelatedRecordId = entToInsert.id, 
            Type = 'ContentPost'   
           );

        Database.UpsertResult urList7 = Database.upsert(theFile, true);
        */
      }

    }
}