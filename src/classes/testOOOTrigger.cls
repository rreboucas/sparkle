@isTest
private class testOOOTrigger {

    public static testMethod void testOOONotification() {
    	Profile p = [select id from profile where name='Standard User'];
    	User u = new User(	alias = 'standt', email='standarduser@testorg.com',
							emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
							localesidkey='en_US', profileid = p.Id,
							timezonesidkey='America/Los_Angeles', username='testOOOTrigger@testorg.com');
    	insert u;					

    	User u2 = new User(	alias = 'standt2', email='standarduser2@testorg.com',
							emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
							localesidkey='en_US', profileid = p.Id,
							timezonesidkey='America/Los_Angeles', username='testOOOTrigger2@testorg.com');
    	insert u2;					
    	
    	Out_Of_Office__c newOOO = new Out_Of_Office__c (user__c = u.Id,
    													Message__c = 'Test',
    													Active__c  = true,
    													Start_Time__c = System.now() - 1,
    													End_Time__c = System.now() + 1);
    	insert newOOO;												

    	Out_Of_Office__c duplicateOOO = new Out_Of_Office__c (user__c = u.Id);

		Database.SaveResult[] sr = Database.insert(new Out_Of_Office__c[] {duplicateOOO},false);
		
		System.assertEquals(sr[0].isSuccess(), false);
		
		System.runAs(u2)
		{
			FeedItem post = new FeedItem (ParentId = u.Id,
										  Body = 'test');
			insert post;
			
			post = [select id, (select id, CommentBody from FeedComments) from FeedItem where id = :post.Id];
			System.assertEquals(post.feedComments[0].CommentBody, 'Test');							  
		}
    }
}