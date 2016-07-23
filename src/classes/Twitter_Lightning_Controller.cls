public with sharing class Twitter_Lightning_Controller {
    
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

        if (!String.isBlank(recordID))
        {
            String soql = 'Select id';
                
            if (twitterIDFieldApiName != null)
                soql += ', ' + twitterIDFieldApiName;
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            soql += ' WHERE id =\'' + recordID + '\'';
            
            // Add limit to query string:        
            soql += ' limit 1';
            
            System.debug('######## soql: ' + soql);
            
            List<SObject> lstQueriedRecords = Database.query(soql);
            if (lstQueriedRecords.size() > 0)
                hasTwitterMemberID = true;
        }

        return hasTwitterMemberID;

    }


    @AuraEnabled
    public static Twitter_Lightning_Controller getRecordDetails(String recordID, String objectApiName, String twitterIDFieldApiName, String firstName, String lastName, String companyName, String email) {

        Boolean hasTwitterMemberID = false;
        Twitter_Lightning_Controller returnRec = new Twitter_Lightning_Controller();

        if (!String.isBlank(recordID))
        {
            String soql = 'Select id';
                
            if (twitterIDFieldApiName != null)
                soql += ', ' + twitterIDFieldApiName;
       
            if (firstName != null)
                soql += ', ' + firstName;
            
            if (lastName != null)
                soql += ', ' + lastName;
            
            if (companyName != null)
                soql += ', ' + companyName;
            
            if (email != null)
                soql += ', ' + email;
            
            // Add object name to query string:        
            soql += ' FROM ' + objectApiName;
            
            soql += ' WHERE id =\'' + recordID + '\'';
            
            // Add limit to query string:        
            soql += ' limit 1';
            
            System.debug('######## soql: ' + soql);
            
            List<SObject> lstQueriedRecords = Database.query(soql);
            if (lstQueriedRecords.size() > 0)
            {
                returnRec.hasTwitterMemberID = true;
                SObject e = lstQueriedRecords[0];

                if (recordID != null)
                {                
                    returnRec.salesforceRecordID = GetSobjectField(e, 'id');
                }
                if (firstName != null)
                {                
                    returnRec.firstName = GetSobjectField(e, firstName);
                }
                if (lastName != null)
                {
                    returnRec.lastName = GetSobjectField(e, lastName);
                }
                if (companyName != null)
                {
                    returnRec.companyName = GetSobjectField(e, companyName);
                }
                    
                if (email != null)
                {
                    returnRec.email = GetSobjectField(e, email);
                }

                if (twitterIDFieldApiName != null)
                {
                    returnRec.twitterName = GetSobjectField(e, twitterIDFieldApiName);
                }
                
            }
            
              
        }




        return returnRec;

    }

    
    @AuraEnabled
    public static Twitter_Lightning_Controller getTwitterPicture(String recordID, String objectApiName, String twitterIDFieldApiName) {
        
        String oauthVersion = '1.0';
        String oauthConsumerKey = 'crTSqn98nBWCC8lbj0IauMv06';
        String oauthConsumerSecret = 'LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx';
        String baseUrl = 'https://api.twitter.com';
        String oauthSignatureMethod = 'HMAC-SHA1';
        String strTwitterId = '';
        String pictureURL = '';
        Twitter_Lightning_Controller returnRec = new Twitter_Lightning_Controller();
        returnRec.pictureUrl = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
        if (!String.isBlank(recordID))
        {
            
        
        
            System.debug('######## Twitter_Lightning_Controller -  objectApiName: ' + objectApiName);
            
            
            // Get the id of the Salesforce user who is making the request in the LC:
            String strUserId = UserInfo.getUserId();
            
 
            
            // Get the value from the object record field (LC Attributes) that stored the linkedin ID
            // 

            
            String soql = 'Select id';
            
            if (twitterIDFieldApiName != null)
                soql += ', ' + twitterIDFieldApiName;
            
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
                
                strTwitterId = GetSobjectField(e, twitterIDFieldApiName);
            }
            
            System.debug('######## strTwitterId: ' + strTwitterId);
            String twitterAcct = strTwitterId.remove('@');
    
            
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
            

            String pictureFullURL = getFieldValueFromJson(responseBody2, 'profile_image_url');
            pictureURL = pictureFullURL.remove('_normal');

            returnRec.pictureUrl = pictureURL;
            returnRec.twitterName = strTwitterId;
            returnRec.location = getFieldValueFromJson(responseBody2, 'location');
            returnRec.numFollowers = getFieldValueFromJson(responseBody2, 'followers_count');
            returnRec.follows = getFieldValueFromJson(responseBody2, 'friends_count');
            returnRec.description = getFieldValueFromJson(responseBody2, 'description');


        }
        
        
        return returnRec;
    }


    @AuraEnabled
    public static Twitter_Lightning_Controller getTwitterUser(String twitterName, String firstName, String lastName, string companyName, String email) {
        
        String oauthVersion = '1.0';
        String oauthConsumerKey = 'crTSqn98nBWCC8lbj0IauMv06';
        String oauthConsumerSecret = 'LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx';
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
            

            String pictureFullURL = getFieldValueFromJson(responseBody2, 'profile_image_url');
            pictureURL = pictureFullURL.remove('_normal');

            returnRec.pictureUrl = pictureURL;
            returnRec.twitterName = twitterName;
            returnRec.location = getFieldValueFromJson(responseBody2, 'location');
            returnRec.numFollowers = getFieldValueFromJson(responseBody2, 'followers_count');
            returnRec.follows = getFieldValueFromJson(responseBody2, 'friends_count');
            returnRec.description = getFieldValueFromJson(responseBody2, 'name');
            //returnRec.tweetDate = getFieldValueFromJson(responseBody2, 'created_at');
            
            String lstTweetDate = getFieldValueFromJson(responseBody2, 'created_at');
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
            DateTime dt = DateTime.newInstance(Integer.valueOf(year), getMonthIntergerValue(month), Integer.valueOf(day), Integer.valueOf(hour), Integer.valueOf(minutes), Integer.valueOf(seconds));
            
            returnRec.tweetDate = dt.format();
            }
            returnRec.tweetText = getFieldValueFromJson(responseBody2, 'text');
            returnRec.tweetLink = getFieldValueFromJson(responseBody2, 'expanded_url');


        }
        else
        {
            pictureURL = 'https://www.lightningdesignsystem.com/assets/images/avatar1.jpg';
        }

        
        
        
        
        
        
        return returnRec;
    }
    
    private static Integer getMonthIntergerValue(String monthStringValue)
    {
        Integer monthValue = 0;
        
        if(monthStringValue.equalsIgnoreCase('Jan'))
            monthValue = 1;
        if(monthStringValue.equalsIgnoreCase('Feb'))
            monthValue = 2;
        if(monthStringValue.equalsIgnoreCase('Mar'))
            monthValue = 3;
        if(monthStringValue.equalsIgnoreCase('Apr'))
            monthValue = 4;
        if(monthStringValue.equalsIgnoreCase('May'))
            monthValue = 5;
        if(monthStringValue.equalsIgnoreCase('Jun'))
            monthValue = 6;
        if(monthStringValue.equalsIgnoreCase('Jul'))
            monthValue = 7;
        if(monthStringValue.equalsIgnoreCase('Aug'))
            monthValue = 8;
        if(monthStringValue.equalsIgnoreCase('Sep'))
            monthValue = 9;
        if(monthStringValue.equalsIgnoreCase('Oct'))
            monthValue = 10;
        if(monthStringValue.equalsIgnoreCase('Nov'))
            monthValue = 11;
        if(monthStringValue.equalsIgnoreCase('Dec'))
            monthValue = 12;
        
        
        return monthValue;
    }


    private static String getFieldValueFromJson(String jsonBody, String fieldName)
    {

        String returnValue = '';
        JSONParser parser2 = JSON.createParser(jsonBody);
           
           Integer textCount = 1;
            while (parser2.nextToken() != null) {
                if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser2.getText() == fieldName)) {
                        
                        parser2.nextToken();
                        String jsonValue = parser2.getText();
                        System.debug('fieldname = '+ fieldName + 'and jsonValue = ' + jsonValue);
                        if (fieldname.equalsIgnoreCase('text'))
                        {
                            
                            System.debug('fieldname is text: ' + jsonValue + 'and textcount = ' + textCount);
                            if (textCount == 1)
                            {
                                System.debug('textcount = 2 : jsonValue = ' + jsonValue);
                                returnValue =  parser2.getText();
                            }
                                
                            textCount ++;
                        }
                        else
                        	returnValue =  parser2.getText();
                        
                    }
            }

            return returnValue;

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