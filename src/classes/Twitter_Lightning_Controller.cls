public with sharing class Twitter_Lightning_Controller {
    
    private static Map<String, Set<String>> mapObjectsFields = null;

    @AuraEnabled
    public String salesforceRecordID { get;set; }
    @AuraEnabled
    public String pictureUrl { get;set; }
    @AuraEnabled
    public String twitterName { get;set; }
    @AuraEnabled
    public Boolean hasTwitterMemberID { get;set; }
    @AuraEnabled
    public String firstName { get;set; }
    @AuraEnabled
    public String lastName { get;set; }
    @AuraEnabled
    public String companyName { get;set; }
    @AuraEnabled
    public String email { get;set; }
    @AuraEnabled
    public String location { get;set; }
    @AuraEnabled
    public String numFollowers { get;set; }
    @AuraEnabled
    public String follows { get;set; }
    @AuraEnabled
    public String description { get;set; }
    @AuraEnabled
    public String tweetDate { get;set; }
    @AuraEnabled
    public String tweetText { get;set; }
    @AuraEnabled
    public String tweetLink { get;set; }
    

    @AuraEnabled
    public static Boolean hasTwitterID(String recordID, String objectApiName, String twitterIDFieldApiName) {

        Boolean hasTwitterMemberID = false;

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 

        if (!String.isBlank(recordID))
        {
            String soql = 'Select id';
            Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);

            if (twitterIDFieldApiName != null)
            {
                soql += ', ' + String.escapeSingleQuotes(twitterIDFieldApiName);
                Sparkle_Helper.AddFieldToObjectsMap(twitterIDFieldApiName, objectApiName, mapObjectsFields);
            }
            
            // Add object name to query string:        
            soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
            
            soql += ' WHERE id =\'' + String.escapeSingleQuotes(recordID) + '\'';
            
            // Add limit to query string:        
            soql += ' limit 1';
            
            System.debug('######## soql: ' + soql);
            
            // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
            if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
            {
                List<SObject> lstQueriedRecords = Database.query(soql);
                if (lstQueriedRecords.size() > 0)
                    hasTwitterMemberID = true;
            }
        }

        return hasTwitterMemberID;

    }


    @AuraEnabled
    public static Twitter_Lightning_Controller getRecordDetails(String recordID, String objectApiName, String twitterIDFieldApiName, String firstName, String lastName, String companyName, String email) {

        Boolean hasTwitterMemberID = false;
        Twitter_Lightning_Controller returnRec = new Twitter_Lightning_Controller();

        // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
        mapObjectsFields = new Map<String, Set<String>>(); 

        if (!String.isBlank(recordID))
        {
            String soql = 'Select id';
            Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
                
            if (twitterIDFieldApiName != null){
                soql += ', ' + String.escapeSingleQuotes(twitterIDFieldApiName);
                Sparkle_Helper.AddFieldToObjectsMap(twitterIDFieldApiName, objectApiName, mapObjectsFields);
            }
       
            if (firstName != null){
                soql += ', ' + String.escapeSingleQuotes(firstName);
                Sparkle_Helper.AddFieldToObjectsMap(firstName, objectApiName, mapObjectsFields);
            }
            
            if (lastName != null){
                soql += ', ' + String.escapeSingleQuotes(lastName);
                Sparkle_Helper.AddFieldToObjectsMap(lastName, objectApiName, mapObjectsFields);
            }
            
            if (companyName != null){
                soql += ', ' + String.escapeSingleQuotes(companyName);
                Sparkle_Helper.AddFieldToObjectsMap(companyName, objectApiName, mapObjectsFields);
            }
            
            if (email != null){
                soql += ', ' + String.escapeSingleQuotes(email);
                Sparkle_Helper.AddFieldToObjectsMap(email, objectApiName, mapObjectsFields);
            }
            
            // Add object name to query string:        
            soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
            
            soql += ' WHERE id =\'' + String.escapeSingleQuotes(recordID)  + '\'';
            
            // Add limit to query string:        
            soql += ' limit 1';
            
            System.debug('######## soql: ' + soql);

            // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
        if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
        {
            
            List<SObject> lstQueriedRecords = Database.query(soql);
            if (lstQueriedRecords.size() > 0)
            {
                returnRec.hasTwitterMemberID = true;
                SObject e = lstQueriedRecords[0];

                if (recordID != null)
                {                
                    returnRec.salesforceRecordID = Sparkle_Helper.GetSobjectField(e, 'id');
                }
                if (firstName != null)
                {                
                    returnRec.firstName = Sparkle_Helper.GetSobjectField(e, firstName);
                }
                if (lastName != null)
                {
                    returnRec.lastName = Sparkle_Helper.GetSobjectField(e, lastName);
                }
                if (companyName != null)
                {
                    returnRec.companyName = Sparkle_Helper.GetSobjectField(e, companyName);
                }
                    
                if (email != null)
                {
                    returnRec.email = Sparkle_Helper.GetSobjectField(e, email);
                }

                if (twitterIDFieldApiName != null)
                {
                    returnRec.twitterName = Sparkle_Helper.GetSobjectField(e, twitterIDFieldApiName);
                }
                
            }
        }
            
              
        }




        return returnRec;

    }

    
    @AuraEnabled
    public static Twitter_Lightning_Controller getTwitterPicture(String recordID, String objectApiName, String twitterIDFieldApiName) {
        
        String oauthVersion = '1.0';
        
// Get the Twitter App Access token from the Twitter Users Custom Setting: 

        Twitter_User__c myCS1 = Twitter_User__c.getValues('TwitterApp');
        String oauthConsumerKey = myCS1.Token__c;        
        String oauthConsumerSecret = myCS1.Token_Secret__c;
        
        String baseUrl = 'https://api.twitter.com';
        String oauthSignatureMethod = 'HMAC-SHA1';
        String strTwitterId = '';
        String pictureURL = '';
        String twitterAcct = '';
        Twitter_Lightning_Controller returnRec = new Twitter_Lightning_Controller();
        returnRec.pictureUrl = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
        if (!String.isBlank(recordID))
        {
            
        
        
            System.debug('######## Twitter_Lightning_Controller -  objectApiName: ' + objectApiName);
            
            
            // Get the id of the Salesforce user who is making the request in the LC:
            String strUserId = UserInfo.getUserId();
            
        
            // CRUD / FLS Check - Create a map with the object names and fields for CRUD\FLS check
            mapObjectsFields = new Map<String, Set<String>>(); 

            
            // Get the value from the object record field (LC Attributes) that stored the Twitter Id

            
            String soql = 'Select id';
            Sparkle_Helper.AddFieldToObjectsMap('Id', objectApiName, mapObjectsFields);
            
            if (twitterIDFieldApiName != null){
                soql += ', ' + String.escapeSingleQuotes(twitterIDFieldApiName);
                Sparkle_Helper.AddFieldToObjectsMap(twitterIDFieldApiName, objectApiName, mapObjectsFields);
            }
            
            // Add object name to query string:        
            soql += ' FROM ' + String.escapeSingleQuotes(objectApiName);
            
            soql += ' WHERE id =\'' + String.escapeSingleQuotes(recordID)  + '\'';
            
            // Add limit to query string:        
            soql += ' limit 1';
            
            System.debug('######## soql: ' + soql);

            // CRUD\FLS Check: Before running the SOQL query check if the user who is invoking this method has access to the Object and to the fields requested
        
            if (Sparkle_Helper.UserHasAccessToObjectsAndFields(mapObjectsFields))
            {
            
                List<SObject> lstQueriedRecords = Database.query(soql); 
                
                System.debug('######## lstQueriedRecords: ' + lstQueriedRecords);
                
                for (SObject e: lstQueriedRecords)
                {
                    System.debug('######## e: ' + e);
                    
                    strTwitterId = Sparkle_Helper.GetSobjectField(e, twitterIDFieldApiName);
                }
                
                System.debug('######## strTwitterId: ' + strTwitterId);
                twitterAcct = strTwitterId.remove('@');
            }
            
            // Make a callout to Twitter
            
            String keyencoded = EncodingUtil.urlEncode(oauthConsumerKey, 'UTF-8');
            String secretkeyencoded = EncodingUtil.urlEncode(oauthConsumerSecret, 'UTF-8');
            
            //Create Final Key String
            String sFinal = keyencoded + ':' + secretkeyencoded;
            //Convert to Blob
            Blob headerValue = Blob.valueOf(sFinal);
            
            //Build Request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.twitter.com/oauth2/token');
            req.setMethod('POST');
            
            //Add Auth Header
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            
            //You need to add this to the request - proved easy to miss in instructions...
            req.setBody('grant_type=client_credentials');
            
            //Make request
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String responseBody = res.getBody();
            System.debug('########## responseBody : ' + responseBody);
            String stoken;
            //Parse JSON for Bearer Token
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) 
            {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token')
                {
                    parser.nextToken();
                    stoken = parser.getText();
                    System.debug('########## bearer token : ' + stoken);
                }
            }
            
            
            // Make another request to twitter to get the user details:
            
            HttpRequest req2 = new HttpRequest();
            //I actually store the endpoint in the same custom setting and build dynamically, but for purposes of demo:
            req2.setEndpoint('https://api.twitter.com/1.1/users/show.json?screen_name=' + twitterAcct);
            req2.setMethod('GET');
        
            //Call Bearer token Method
            //Note - unless invalidated, I believe you can store this and keep using it indefinitely, but again, to demo concept
            String authorizationHeader2 = 'Bearer ' + stoken;
            req2.setHeader('Authorization', authorizationHeader2);
        
            Http http2 = new Http();
            HTTPResponse res2 = http2.send(req2);
            String sBody2 = res2.getBody();
            String responseBody2 = res2.getBody();
            System.debug('########## responseBody2 : ' + responseBody2);
            

            String pictureFullURL = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'profile_image_url');
            pictureURL = pictureFullURL.remove('_normal');

            returnRec.pictureUrl = pictureURL;
            returnRec.twitterName = strTwitterId;
            returnRec.location = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'location');
            returnRec.numFollowers = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'followers_count');
            returnRec.follows = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'friends_count');
            returnRec.description = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'description');


        }
        
        
        return returnRec;
    }

    @AuraEnabled
    public static List<String> getTwitterImages(String twitterID) {
        
        String oauthVersion = '1.0';
        
// Get the Twitter App Access token from the Twitter Users Custom Setting: 

        Twitter_User__c myCS1 = Twitter_User__c.getValues('TwitterApp');
        String oauthConsumerKey = myCS1.Token__c;        
        String oauthConsumerSecret = myCS1.Token_Secret__c;
        
        String baseUrl = 'https://api.twitter.com';
        String oauthSignatureMethod = 'HMAC-SHA1';
        String strTwitterId = twitterID;
        String pictureURL = '';
        String twitterAcct = '';
        List<String> picUrlsList = new List<String>();

		twitterAcct = strTwitterId.remove('@');

            
            // Make a callout to Twitter
            
            String keyencoded = EncodingUtil.urlEncode(oauthConsumerKey, 'UTF-8');
            String secretkeyencoded = EncodingUtil.urlEncode(oauthConsumerSecret, 'UTF-8');
            
            //Create Final Key String
            String sFinal = keyencoded + ':' + secretkeyencoded;
            //Convert to Blob
            Blob headerValue = Blob.valueOf(sFinal);
            
            //Build Request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.twitter.com/oauth2/token');
            req.setMethod('POST');
            
            //Add Auth Header
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            
            //You need to add this to the request - proved easy to miss in instructions...
            req.setBody('grant_type=client_credentials');
            
            //Make request
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String responseBody = res.getBody();
            System.debug('########## responseBody : ' + responseBody);
            String stoken;
            //Parse JSON for Bearer Token
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) 
            {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token')
                {
                    parser.nextToken();
                    stoken = parser.getText();
                    System.debug('########## bearer token : ' + stoken);
                }
            }
            
            
            // Make another request to twitter to get the user images:
            
            HttpRequest req2 = new HttpRequest();
            //I actually store the endpoint in the same custom setting and build dynamically, but for purposes of demo:
            req2.setEndpoint('https://api.twitter.com/1.1/search/tweets.json?q=%23from='+ twitterAcct + '&filter=images&tweet_mode=extended&result_type=mixed&count=24');
            req2.setMethod('GET');
        
            //Call Bearer token Method
            //Note - unless invalidated, I believe you can store this and keep using it indefinitely, but again, to demo concept
            String authorizationHeader2 = 'Bearer ' + stoken;
            req2.setHeader('Authorization', authorizationHeader2);
        
            Http http2 = new Http();
            HTTPResponse res2 = http2.send(req2);
            String sBody2 = res2.getBody();
            String responseBody2 = res2.getBody();
            System.debug('########## responseBody2 : ' + responseBody2);
            

            String pictureFullURL = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'profile_image_url');
            pictureURL = pictureFullURL.remove('_normal');

            



        
        
        return picUrlsList;
    }

    @AuraEnabled
    public static Twitter_Lightning_Controller getTwitterUser(String twitterName, String firstName, String lastName, string companyName, String email) {
        
        String oauthVersion = '1.0';

        // Get the Twitter App Access token from the Twitter Users Custom Setting:

        Twitter_User__c myCS1 = Twitter_User__c.getValues('TwitterApp');
        String oauthConsumerKey = myCS1.Token__c;        
        String oauthConsumerSecret = myCS1.Token_Secret__c;

        String baseUrl = 'https://api.twitter.com';
        String oauthSignatureMethod = 'HMAC-SHA1';
        String strTwitterId = '';
        String pictureURL = '';
        Twitter_Lightning_Controller returnRec = new Twitter_Lightning_Controller();
        if (!String.isBlank(twitterName))
        {
            
        
            System.debug('######## twitterName: ' + twitterName);
            String twitterAcct = twitterName.remove('@');
    
            
            // Make a callout to Twitter
            
            String keyencoded = EncodingUtil.urlEncode(oauthConsumerKey, 'UTF-8');
            String secretkeyencoded = EncodingUtil.urlEncode(oauthConsumerSecret, 'UTF-8');
            
            //Create Final Key String
            String sFinal = keyencoded + ':' + secretkeyencoded;
            //Convert to Blob
            Blob headerValue = Blob.valueOf(sFinal);
            
            //Build Request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.twitter.com/oauth2/token');
            req.setMethod('POST');
            
            //Add Auth Header
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            
            //You need to add this to the request - proved easy to miss in instructions...
            req.setBody('grant_type=client_credentials');
            
            //Make request
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String responseBody = res.getBody();
            System.debug('########## responseBody : ' + responseBody);
            String stoken;
            //Parse JSON for Bearer Token
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token'){
            parser.nextToken();
            stoken = parser.getText();
            System.debug('########## bearer token : ' + stoken);
            }
            }
            
            
            // Make another request to twitter to get the user details:
            
            HttpRequest req2 = new HttpRequest();
            //I actually store the endpoint in the same custom setting and build dynamically, but for purposes of demo:
            req2.setEndpoint('https://api.twitter.com/1.1/users/show.json?screen_name=' + twitterAcct);
            req2.setMethod('GET');
        
            //Call Bearer token Method
            //Note - unless invalidated, I believe you can store this and keep using it indefinitely, but again, to demo concept
            String authorizationHeader2 = 'Bearer ' + stoken;
            req2.setHeader('Authorization', authorizationHeader2);
        
            Http http2 = new Http();
            HTTPResponse res2 = http2.send(req2);
            String sBody2 = res2.getBody();
            String responseBody2 = res2.getBody();
            System.debug('########## responseBody2 : ' + responseBody2);
            

            String pictureFullURL = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'profile_image_url');
            pictureURL = pictureFullURL.remove('_normal');

            returnRec.pictureUrl = pictureURL;
            returnRec.twitterName = twitterName;
            returnRec.location = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'location');
            returnRec.numFollowers = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'followers_count');
            returnRec.follows = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'friends_count');
            returnRec.description = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'name');
            
            String lstTweetDate = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'created_at');
            String weekDay = lstTweetDate.substringBefore(' ') ;
            System.debug('########## weekDay : ' + weekDay);
            lstTweetDate = lstTweetDate.removeStart(weekDay + ' ');
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String month = lstTweetDate.substringBefore(' ') ;
            System.debug('########## month : ' + month);
            lstTweetDate = lstTweetDate.removeStart(month + ' ');  
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String day = lstTweetDate.substringBefore(' ') ;
            System.debug('########## day : ' + day);            
            lstTweetDate = lstTweetDate.removeStart(day + ' ');
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String hour = lstTweetDate.substringBefore(':') ;
            System.debug('########## hour : ' + hour);            
            lstTweetDate = lstTweetDate.removeStart(hour + ':');
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String minutes = lstTweetDate.substringBefore(':') ;
            System.debug('########## minutes : ' + minutes);            
            lstTweetDate = lstTweetDate.removeStart(minutes + ':');
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String seconds = lstTweetDate.substringBefore(' ') ;
            System.debug('########## seconds : ' + seconds);            
            lstTweetDate = lstTweetDate.removeStart(seconds + ' ');
            System.debug('########## lstTweetDate : ' + lstTweetDate);
            String miliSeconds = lstTweetDate.substringBefore(' ') ;
            System.debug('########## miliSeconds : ' + miliSeconds);
            String year = lstTweetDate.removeStart(miliSeconds + ' ');
            System.debug('########## lstTweetDate / year : ' + lstTweetDate);
            System.debug('########## year : ' + year);
            
            if (!Test.isRunningTest())
            {
            DateTime dt = DateTime.newInstance(Integer.valueOf(year), Sparkle_Helper.getMonthIntergerValue(month), Integer.valueOf(day), Integer.valueOf(hour), Integer.valueOf(minutes), Integer.valueOf(seconds));
            
            returnRec.tweetDate = dt.format();
            }
            returnRec.tweetText = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'text');
            returnRec.tweetLink = Sparkle_Helper.getFieldValueFromJson(responseBody2, 'expanded_url');


        }
        else
        {
            pictureURL = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
        }

        
        
        
        
        
        
        return returnRec;
    }
 


}