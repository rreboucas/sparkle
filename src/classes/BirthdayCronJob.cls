/**************************************************************************/
//The Birthday Emailer
//
//This class can be scheduled to run nightly to send emails to contacts 
//on their birthday, using a birthday email template, or on the contact's 
//anniversary (anniversary of a contact, of doing business) 
// 
//Emails will only be sent to contacts that meet the following conditions:
// *the Birthday or Anniversary field is filled out
// *the Email Opt Out is unchecked
// *the "send birthday email" or "send anniversary email" checkbox is checked
//
// Feel free to edit this code, or change the email templates.
//
/***************************************************************************/



global class BirthdayCronJob implements Schedulable{ 
	
	
		//mandataory function called by the Apex Scheduler
		global void execute(SchedulableContext SC) {
      		sendmail(); // our main function that does the email sending
   		}//end execute()

		//Get email addresses of people with birthdays and who are to receive emails
		public List<Id> getBirthdayEmailAddresses(Integer Month, Integer Day) 
     	{ 
        	List<Id> mailToIds = new List<Id>();
        	 
        	//find a list of contacts with birthdays today
	        Contact[] c = [SELECT Id, email, Birthdate, Send_Birthday_Email__c, HasOptedOutOfEmail
	        				FROM Contact 
	        				WHERE DAY_IN_MONTH(Birthdate) = : Day 
							AND CALENDAR_MONTH(Birthdate) = : Month   
	        				];
        
			//add the list of contacts to a list        
    	    for(Contact recipient : c) {
    	    		
    	    		//If( contacts who's birthday is today can receive emails AND has the "Send Birthday Email" checked)
    	    		//{ add to birthday email recipient list }
    	    		// 
    	    		
    	    		System.Debug('\n*******Found Birthday Recipient');
    	    		    	    		
    	    		if (recipient.Send_Birthday_Email__c == true && recipient.HasOptedOutOfEmail == false)
    	    		{
    	    			mailToIds.add(recipient.Id);	// add to email contact array
    	    			System.Debug('\n*******Recipient: '+ recipient.email);
    	    			//and add to Chatter Array
    	    			 
    	    		} else {
    	    			//Just add to chatter array
    	    			System.Debug('\n*******NO Recipient');
    	    		}
	        	
        	}

        	//return the list
        	return mailToIds;
     	}//end getBirthdayEmailAddresses()






		//Get email addresses of people with anniversaries and who are to receive emails
		public List<Id> getAnniversaryEmailAddresses(Integer Month, Integer Day) 
     	{ 
        	List<Id> mailToIds = new List<Id>();
        	 
        	//find a list of contacts with anniversaries today
	        Contact[] c = [SELECT Id, email, Anniversary_Date__c, Send_Anniversary_Email__c, HasOptedOutOfEmail
	        				FROM Contact 
	        				WHERE DAY_IN_MONTH(Anniversary_Date__c) = : Day 
							AND CALENDAR_MONTH(Anniversary_Date__c) = : Month  
	        				];
        
			//add the list of contacts to a list        
    	    for(Contact recipient : c) {
    	    		
    	    		//If( contacts who's birthday is today can receive emails AND has the "Send Birthday Email" checked)
    	    		//{ add to birthday email recipient list }
    	    		// 
    	    			System.Debug('\n*******Found Anniversary Recipient');    	    		
    	    		if (recipient.Send_Anniversary_Email__c == true && recipient.HasOptedOutOfEmail == false)
    	    		{
    	    			mailToIds.add(recipient.Id);	// add to email contact array
    	    			System.Debug('\n*******Recipient: '+ recipient.email);
    	    			 
    	    		} else {
    	    			//Just add to chatter array
    	    			System.Debug('\n*******NO Recipient');
    	    		}
	        	
        	}

        	//return the list
        	return mailToIds;
     	}//end getAnniversaryEmailAddresses()



		public void sendMail() 
    	{
			//define variables    		
			String debugAddress = 'eyewell@salesforce.com';
			String BirthdayEmailTemplateName = 'Happy_Birthday';
			String AnniversaryEmailTemplateName = 'Celebrating_your_Anniversary';			
			String debugMessage;
        	String[] toAddresses;

    		Integer DayOfEvent   = date.today().day();
			Integer MonthOfEvent = date.today().month();


			// build the Birthday list

			//get the list of people with birthdays - this can justifiably come back empty, on a day when no contacts were born 
        	List<Id> BirthdayIdsList = getBirthdayEmailAddresses(MonthOfEvent,DayOfEvent);

			//Set the templates
        	EmailTemplate birthdayTemplate = [select Id,Name,Subject,body from EmailTemplate where DeveloperName = :BirthdayEmailTemplateName];
		
			//EmailTemplate anniversaryTemplate = [select Id,Name,Subject,body from EmailTemplate where name like :temp+'%'];
			//If we have a template, and we have a list of email addresses, then send the email
        	if(birthdayTemplate != null && BirthdayIdsList.isEmpty() == false)
        	{

           		Messaging.MassEmailMessage birthdayMail = new Messaging.MassEmailMessage();
    
            	birthdayMail.setTargetObjectIds(BirthdayIdsList);
            	birthdayMail.setTemplateId(birthdayTemplate.Id);
            	birthdayMail.setUseSignature(false);
            	birthdayMail.setSaveAsActivity(true);

            	// Send the email
            	try {
            		Messaging.sendEmail(new Messaging.MassEmailMessage[] { birthdayMail });
            	}catch(Exception e)
            	{
            		System.Debug(e);
            	}
           
        	}
        	else
        	{
            	System.Debug('BirthdayCronJob:sendMail(): Either an email template could not be found, or no Contact has a birthday today');
        	}//end if


			// build the anniversary list


			//get the list of people with Anniversaries - this can justifiably come back empty 
        	List<Id> AnniversaryIdsList = getAnniversaryEmailAddresses(MonthOfEvent,DayOfEvent);
			//Set the templates
        	EmailTemplate anniversaryTemplate = [select Id,Name,Subject,body from EmailTemplate where DeveloperName = :AnniversaryEmailTemplateName];
			
			//If we have a template, and we have a list of email addresses, then send the email
        	if(anniversaryTemplate != null && AnniversaryIdsList.isEmpty() == false)
        	{

           		Messaging.MassEmailMessage anniversaryMail = new Messaging.MassEmailMessage();
    
            	anniversaryMail.setTargetObjectIds(AnniversaryIdsList);
            	anniversaryMail.setTemplateId(anniversaryTemplate.Id);
            	anniversaryMail.setUseSignature(false);
            	anniversaryMail.setSaveAsActivity(true);

            	// Send the email
            	try {
            		Messaging.sendEmail(new Messaging.MassEmailMessage[] { anniversaryMail });
            	}catch(Exception e)
            	{
            		System.Debug(e);
            	}
           
        	}
        	else
        	{
            	System.Debug('BirthdayCronJob:sendMail(): Either an email template could not be found, or no Contact has an anniversary today');
        	}//end if
                
		}//end sendMail() 


	
}//end class BirthdayCronJob