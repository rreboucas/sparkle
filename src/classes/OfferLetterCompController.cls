public with sharing class OfferLetterCompController {
    
    private static Map<String, Set<String>> mapObjectsFields = null;
    
    @AuraEnabled
    public String emailTemplateID { get;set; }
    @AuraEnabled
    public String emailTemplateName { get;set; }
    @AuraEnabled
    public String emailTemplateSubject { get;set; }
    @AuraEnabled
    public String emailTemplateBody { get;set; }
    @AuraEnabled
    public String candidateName { get;set; }
    @AuraEnabled
    public String candidateEmail { get;set; }
    @AuraEnabled
    public String PositionName { get;set; }
    @AuraEnabled
    public Boolean SendSuccessful { get;set; }
    @AuraEnabled
    public String SendResults { get;set; }
    
    /*
    @AuraEnabled
    public static List<EmailTemplate> getEmailTemplates() {
        return [SELECT Body,Id,Name,Subject,TemplateType FROM EmailTemplate Limit 20];
    }
    */
    
    @AuraEnabled
    public static List<OfferLetterCompController> getEmailTemplatesNames(String candidateID) {
        
        List<OfferLetterCompController> lstReturnRecords = new List<OfferLetterCompController>();
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check - 
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Name', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__E_mail__c', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Position__c', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Position__r.testautonumdata__Level__c', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Position__r.Name', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('FolderId', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('IsActive', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Name', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('NamespacePrefix', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Subject', 'EmailTemplate', mapObjectsFields);
        
        // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
            
            // Grab Position level from associated Position record
             
            String soql2 = 'SELECT Id,Name,testautonumdata__E_mail__c,testautonumdata__Position__r.Name,testautonumdata__Position__r.testautonumdata__Level__c FROM testautonumdata__Candidate__c where id = ' +'\'' +  candidateID +'\' limit 1' ;
                
            System.debug('######## soql2: ' + soql2);
            testautonumdata__Candidate__c candidateRec = Database.query(soql2);
            System.debug('######## candidateRec: ' + candidateRec);
            
            String positionLevel = candidateRec.testautonumdata__Position__r.testautonumdata__Level__c;
            System.debug('######## positionLevel: ' + positionLevel);
            
            String cName = candidateRec.Name;
            System.debug('######## cName: ' + cName);
            
            String cEmail = candidateRec.testautonumdata__E_mail__c;
            System.debug('######## cEmail: ' + cEmail);
            
            String posName = candidateRec.testautonumdata__Position__r.Name;
            System.debug('######## posName: ' + posName);
            
            String soql = 'SELECT FolderId,Id,IsActive,Name,NamespacePrefix,Subject FROM EmailTemplate where Folder.Name ='+'\'' + 'Recruitment Templates' +'\'' + 
                'and IsActive = true and Name LIKE '
                 +'\'' + '%'+ positionLevel +'%' +'\'';
            
            System.debug('######## soql: ' + soql);
            
            List<EmailTemplate> lstQueriedRecords = Database.query(soql);
            
            System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
           

            for (EmailTemplate e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                OfferLetterCompController i = new OfferLetterCompController();
                
                
                i.emailTemplateID = String.valueOf( e.get('id') );
                if (e.Name != null)
                {                
                    i.emailTemplateName = Sparkle_Helper.GetSobjectField(e, 'Name');
                    i.candidateName = cName;
                    i.candidateEmail = cEmail;
                    i.PositionName = posName;
                }
                 

                lstReturnRecords.add(i);

    			System.debug('######## i: ' + i); 
            }
            
            
        }
        
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
        return lstReturnRecords;
        
        
        
        
    }
    
    
    @AuraEnabled
    public static List<OfferLetterCompController> getEmailTemplatebyId(String templateId, String candidateID, String offerID) {
        
        List<OfferLetterCompController> lstReturnRecords = new List<OfferLetterCompController>();
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Position__c', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Offer__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Body', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('FolderId', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('HtmlValue', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('IsActive', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Name', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('NamespacePrefix', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('OwnerId', 'EmailTemplate', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Subject', 'EmailTemplate', mapObjectsFields);
        
        // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
            String soql = 'SELECT Body,FolderId,HtmlValue,Id,IsActive,Name,NamespacePrefix,OwnerId,Subject FROM EmailTemplate where id = ' +'\'' +  templateId +'\'' ;
            
            System.debug('######## soql: ' + soql);
            
            List<EmailTemplate> lstQueriedRecords = Database.query(soql);
            
            System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
            
            // Grab PositionId from Candidate record:
           
            String soql2 = 'SELECT Id,testautonumdata__Position__c FROM testautonumdata__Candidate__c where id = ' +'\'' +  candidateID +'\' limit 1' ;
                
            System.debug('######## soql2: ' + soql2);
            
            testautonumdata__Candidate__c candidateRec = Database.query(soql2);
            System.debug('######## candidateRec: ' + candidateRec);

            for (EmailTemplate e: lstQueriedRecords)
            {
                System.debug('######## e: ' + e);
                OfferLetterCompController i = new OfferLetterCompController();
                
                
                i.emailTemplateID = String.valueOf( e.get('id') );
                if (e.Name != null)
                {                
                    i.emailTemplateName = Sparkle_Helper.GetSobjectField(e, 'Name');
                    String tmpSubjectMergeFields = Sparkle_Helper.GetSobjectField(e, 'Subject');
                    tmpSubjectMergeFields = TemplateResolver.positionFields(tmpSubjectMergeFields, candidateRec.testautonumdata__Position__c);
                    System.debug('######## tmpSubjectMergeFields: ' + tmpSubjectMergeFields);
                    i.emailTemplateSubject = tmpSubjectMergeFields;
                    
                    String tmpBodyMergeFields = Sparkle_Helper.GetSobjectField(e, 'Body');
                    tmpBodyMergeFields = TemplateResolver.candidateFields(tmpBodyMergeFields, candidateID);
                    tmpBodyMergeFields = TemplateResolver.positionFields(tmpBodyMergeFields, candidateRec.testautonumdata__Position__c);
                    tmpBodyMergeFields = TemplateResolver.offerFields(tmpBodyMergeFields, offerID);
                    tmpBodyMergeFields = TemplateResolver.userFields(tmpBodyMergeFields, UserInfo.getUserId());
                    System.debug('######## tmpBodyMergeFields: ' + tmpBodyMergeFields);
                    i.emailTemplateBody = tmpBodyMergeFields;
                }
                 

                lstReturnRecords.add(i);

    			System.debug('######## i: ' + i); 
            }
            
            
        }
        
        System.debug('######## lstReturnRecords: ' + lstReturnRecords);
        
        return lstReturnRecords;
        
        
        
        
    }
    
    @AuraEnabled
    public static String upsertOfferRecord(String offerId, String candidateID, Double annualSalary, Double annualBonus) {
        
        String offerRecId;
        
        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 
        
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Candidate__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('Id', 'testautonumdata__Offer__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Annual_Salary_Offered_Amount__c', 'testautonumdata__Offer__c', mapObjectsFields);
        Sparkle_Helper.AddFieldToObjectsMap('testautonumdata__Annual_Bonus_Amount__c', 'testautonumdata__Offer__c', mapObjectsFields);

        
        // CRUD\FLS Check: Before DML check if the user who is invoking this method has access to the Object and to the fields requested 
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
        	testautonumdata__Offer__c rec = new testautonumdata__Offer__c(testautonumdata__Candidate__c = candidateID, 
                                                                          testautonumdata__Annual_Salary_Offered_Amount__c = annualSalary, 
                                                                          testautonumdata__Annual_Bonus_Amount__c  = annualBonus);
            if (String.isEmpty(offerId))
            {
                System.debug('######## Insert a new Offer record ');
                insert rec;  
            }
            else
            {
                rec.Id = offerId;
                System.debug('######## Update Offer record ' + rec.Id);
                update rec;
            }
            
            
            
            offerRecId = rec.Id;
        }
            

        
        System.debug('######## offerRecId: ' + offerRecId);
        
        return offerRecId;
        
        
        
        
    }
    
    @AuraEnabled
    public static OfferLetterCompController sendEmail(String body, String subject, String email, String offerId) {
        
        
        OfferLetterCompController result = new OfferLetterCompController() ;
       // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(1);
        
        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {email}; 
          
        
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('manager@sparkle.com');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName(UserInfo.getName());
        
        // Specify the subject line for your email address.
        mail.setSubject(subject);
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email. 
        mail.setPlainTextBody(body);
        
        mail.setHtmlBody(body);
        
        
        
        // Send the email you have created.
        Messaging.SendEmailResult[] lstResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
        for (Messaging.SendEmailResult s : lstResults)
        {
            if (s.isSuccess())
            {
                result.SendResults = 'Your offer letter was sent successfully by e-mail to ' + email ;
                result.SendSuccessful = true;
                
                
                String userId = UserInfo.getUserId();

                Task t = new Task();
                t.OwnerId = userId;
                t.Subject = 'Offer - Email Sent';
                t.Status = 'Closed';
                t.Priority = 'Normal';
                t.WhatId = offerId;
                t.TaskSubtype = 'Email';
                t.Description = body;
                t.ActivityDate = Date.today();
                insert t;
                
                
            }
            else
            {
                result.SendResults = s.getErrors().get(0).getMessage();
                result.SendSuccessful = false;
            }
        }
        
        return result;
    }
    
          
}