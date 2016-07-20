public with sharing class Linkedin_Lightning_Controller {
    
    public static final string LINKEDIN_API_KEY='77r77tdy23atxb';
    
    @AuraEnabled
    public static String getLinkedinPicture(String recordID, String objectApiName, String linkedinIDFieldApiName) {
        System.debug('######## Linkedin_Lightning_Controller -  objectApiName: ' + objectApiName);
        String linkedinPictureURL = '';
        
        // Get the id of the Salesforce user who is making the request in the LC:
        String strUserId = UserInfo.getUserId();
        
        // Get the Linkedin Access token of the user who is making the request in the LC from the Linkedin Users Custom Setting:
        testautonumdata__LinkedinUser__c myCS1 = testautonumdata__LinkedinUser__c.getValues(strUserId);
		String accessToken = myCS1.testautonumdata__Linkedin_Token__c;
        
        // Get the value from the object record field (LC Attributes) that stored the linkedin ID
        // 
        String strLinkedinId = '';
        
        String soql = 'Select id';
        
        if (linkedinIDFieldApiName != null)
            soql += ', ' + linkedinIDFieldApiName;
        
        // Add object name to query string:        
        soql += ' FROM ' + objectApiName;
        
        soql += ' WHERE id =\'' + recordID + '\'';
        
        // Add limit to query string:        
        soql += ' limit 1';
        
        System.debug('######## soql: ' + soql);
        
        List<SObject> lstQueriedRecords = Database.query(soql); 
        
        System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
        
        for (SObject e: lstQueriedRecords)
        {
            System.debug('######## e: ' + e);
            
            strLinkedinId = GetSobjectField(e, linkedinIDFieldApiName);
        }
        
        System.debug('######## strLinkedinId: ' + strLinkedinId);
        
        // Make a callout to Linkedin with the Users Access Token and record linkedin ID to get the picture of the Linkedin user that corresponds with the object record
        
        
        Http h = new Http();
		HttpRequest req = new HttpRequest();
        req.setHeader('id', strLinkedinId);		
		req.setEndpoint('https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url)?format=json&id='+ strLinkedinId + '&format=json-get&format=json-get&oauth2_access_token=' + accessToken);
        req.setMethod('GET');
        
        // Send the request, and return a response
       HttpResponse res = h.send(req);
       String response =  res.getBody(); 
       System.debug('########## response : ' + response);
        
        
        JSONParser parser = JSON.createParser(response);
       
       String strAccessToken = '';
       
       while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'pictureUrl')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                linkedinPictureURL =  parser.getText();
            }
        }
       
       System.debug('########## linkedinPictureURL : ' + linkedinPictureURL);
        
        
        return linkedinPictureURL;
    }
    
    private static String GetSobjectField(Sobject e, String lcfield)
    {
        
        String returnValue = '';
        
        if (lcfield.contains('.')) // than it is a parent-relationship field
                {
                    String relName = lcfield.substringBefore('.');
                    String relField = lcfield.substringAfter('.');
                    if (relField.contains('.')) // than it is a 2 level parent-relationship field
                    {
                       String relName2 = relField.substringBefore('.');
                       String relField2 = relField.substringAfter('.');
                       returnValue = String.valueOf(e.getSObject(relName).getSObject(relName2).get(relField2));
                    }
                    else
                    	returnValue = String.valueOf(e.getSObject(relName).get(relField));
                }
                    
                else
                	returnValue = String.valueOf( e.get(lcfield) );
     
        return returnValue;
    } 

}