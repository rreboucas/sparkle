@isTest
public class testOfferLetter {
    
    
    @isTest static void test_OfferLetterCompController() {
		// Implement test code
		Test.startTest();
		testautonumdata__Position__c positionA = TestFactory.insertPosition('Position1', 'Open');
        testautonumdata__Candidate__c candidateA = TestFactory.insertCandidateWithPosition('Candidate A', 'Candidate', 'San Francisco', 'r@r.com', 'A', 'CA', '@roreb', positionA.id);
		
        // Test getEmailTemplatesNames method:
		List<OfferLetterCompController> lstRecs = OfferLetterCompController.getEmailTemplatesNames(candidateA.id);
      	
        Double salary = 10000;
        Double bonus = 5000;
        
      	testautonumdata__Offer__c offerA = TestFactory.insertOffer(candidateA.id, salary, bonus);
      	EmailTemplate templateA = [SELECT Id FROM EmailTemplate where Folder.Name = 'Recruitment Templates' LIMIT 1];
        System.debug('templateA: ' + templateA);
        
        // Test getEmailTemplatebyId method:
      	List<OfferLetterCompController> lstRecs2 = OfferLetterCompController.getEmailTemplatebyId(templateA.id, candidateA.id, offerA.id);

        
        // Test upsertOfferRecord method:
        String lstRecs3 =  OfferLetterCompController.upsertOfferRecord(offerA.id, candidateA.id, salary, bonus);
        String lstRecs4 =  OfferLetterCompController.upsertOfferRecord(null, candidateA.id, salary, bonus);
        
        // Test sendEmail method:
        
        OfferLetterCompController.sendEmail('test body', 'test subject', 'r@r.com', offerA.id);
        
      	Test.stopTest();
	}

}