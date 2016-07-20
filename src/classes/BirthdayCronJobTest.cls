@isTest
class BirthdayCronJobTest {

	static testmethod void test() {
		//Test.startTest();
		
		
		Integer testMonth = date.today().month();
		Integer testDay = date.today().day();
		BirthdayCronJob BCJ = new BirthdayCronJob(); 
		
		//run the test once, without ensuring that a contact with today's birthday exists;
		BCJ.sendMail(); 
		 
		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Contact';
		testContact.Email = 'eyewell@salesforce.com';
		testContact.Birthdate           = date.today();
		testContact.Anniversary_Date__c = date.today();
		testContact.Send_Birthday_Email__c    = true;
		testContact.Send_Anniversary_Email__c = true;
		insert testContact;
		
		//run the test again, now that a contact with today's birthday exists
		BCJ.sendMail();
		
		// Schedule the test job  
    
    	String CRON_EXP = '0 0 0 3 9 ? 2022';
		String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BirthdayCronJob());
		
		// Get the information from the CronTrigger API object  
    
		CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
							FROM CronTrigger 
							WHERE id = :jobId];
		
		// Verify the expressions are the same  
		System.assertEquals(CRON_EXP, ct.CronExpression);
	
		// Verify the job has not run  
		System.assertEquals(0, ct.TimesTriggered);
		
		// Verify the next time the job will run  
    
		System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
		//System.assertNotEquals('testScheduledApexFromTestMethodUpdated',
		//	[SELECT id, name FROM account WHERE id = :a.id].name);

		//Test.stopTest();
		
		//System.assertEquals('testScheduledApexFromTestMethodUpdated',
		//	[SELECT id, name FROM account WHERE id = :a.id].name);
		
		//Clean up
		delete testContact;
		
	}
}