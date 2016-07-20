public class twitterauth {
    
    final String oauthVersion = '1.0';
    final String oauthConsumerKey = 'crTSqn98nBWCC8lbj0IauMv06';
    final String oauthConsumerSecret = 'LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx';
    final String baseUrl = 'https://api.twitter.com';
    final String oauthSignatureMethod = 'HMAC-SHA1';
    final String oauth_callback = 'https://rrlightningout-dev-ed.my.salesforce.com/apex/TwitterReturn';
    
    String oauthTimestamp;
    String oauthNonce;
    String oauthToken;
    String oauthTokenSecret;
    String accessToken;
    String accessTokenSecret;
    
    
    public static final string REDIRECT_URL='https://rrlightningout-dev-ed.my.salesforce.com/apex/TwitterReturn';
    public static final string API_KEY='crTSqn98nBWCC8lbj0IauMv06';
    public static final string API_SECRET='LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx';
    public static final string AUTHORIZE_URL='https://api.twitter.com/oauth/authorize'; 
    public static final string TOKEN_URL = 'https://api.twitter.com/oauth/access_token';
    public static final string OAUTH_TOKEN = '26842218-UtqgrIpvVw1PmOTJd0HyLaVYgV74nhTG19OpcgpMW';
    public final string REQUEST_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';
   
   public PageReference connect(){
     //Authenticating  
     //PageReference pg = new PageReference(AUTHORIZE_URL + '?response_type=code&client_id='+ API_KEY + '&redirect_uri='+ REDIRECT_URL) ;  
     //PageReference pg = new PageReference(REQUEST_TOKEN_URL) ;  
     //return pg ; 
     //
     //
     

       
       String requestUrl = this.baseUrl + '/oauth/request_token';
         String requestMethod = 'POST';
         
         this.getTimeStamp();
         this.generateNounce();
         
         Map<String, String> params = new Map<String, String>();
         params.put('oauth_callback', this.oauth_callback);         
         String authSignature = this.generateSignature(requestMethod, requestUrl, params);
         
         params = new Map<String, String>();
         params .put('oauth_callback',this.oauth_callback);
         params .put('oauth_signature', authSignature);
          
          HttpRequest request = new HttpRequest();
          request.setHeader('Authorization', this.generateAuthHeader(params));
          request.setMethod(requestMethod);
          request.setEndpoint(requestUrl);
          HttpResponse response = new HttpResponse();
          this.oauthToken = '';
          Http  http = new Http();
          try{
              response = http.send(request);
              String responseBody = response.getBody();
              System.debug('########## responseBody : ' + responseBody);
              this.oauthToken = responseBody.substringBefore('&').substringAfter('=');
              System.debug('########## oauthToken : ' + oauthToken);
              this.oauthTokenSecret = responseBody.substringAfter('&').substringBetween('=','&');
              System.debug('########## oauthTokenSecret : ' + oauthTokenSecret);
              //ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('TSecret', oauthTokenSecret, null, -1, false)});
          }catch(Exception e){
              system.debug(e.getMessage());
          }
       
       
       PageReference pg = new PageReference(AUTHORIZE_URL + '?oauth_token='+ oauthToken) ;  

       
        
       
       return pg;
    
   }
    
    public void MyActionMethod()
   {
      this.oauthtoken = ApexPages.currentPage().getparameters().get('oauth_token');
       
       if(String.isNotBlank(this.oauthtoken)){
           
            String twitterId;
            Cookie counter = ApexPages.currentPage().getCookies().get('TSecret');
            if(counter != null) {
                this.oauthTokenSecret = counter.getValue();
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie('TSecret', '', null, -1, false)});
            }
    
           String requestUrl = this.baseUrl + '/oauth/access_token';
           String httpMethod = 'POST';        
           String oauthVerifier = ApexPages.currentPage().getparameters().get('oauth_verifier');
           
           this.getTimeStamp();
           this.generateNounce();
           
           Map<String, String> params = new Map<String, String>();
           params.put('oauth_token', this.oauthToken);
           params.put('oauth_verifier', oauthVerifier);           
           String authSignature = this.generateSignature(httpMethod, requestUrl, params);
           
           params = new Map<String, String>();
           params.put('oauth_token',this.oauthtoken);
           params.put('oauth_signature',authSignature);
           
           HttpRequest request = new HttpRequest();
           HttpResponse response = new HttpResponse();
           Http  http = new Http();
           request.setEndPoint(requestUrl);
           request.setMethod(httpMethod);
           request.setHeader('Authorization', this.generateAuthHeader(params));
           request.setBody('oauth_verifier='+EncodingUtil.urlEncode(oauthVerifier, 'UTF-8'));
           try{
              response = http.send(request);
              String responseBody = response.getBody();
              System.debug('########## Final responseBody : ' + responseBody);
              this.oauthToken = responseBody.substringBetween('oauth_token=', '&');
              System.debug('########## Final oauthToken : ' + oauthToken);
              this.oauthTokenSecret = responseBody.substringBetween('oauth_token_secret=', '&');
              twitterId = responseBody.substringBetween('user_id=', '&');
              System.debug('########## Final twitterId : ' + twitterId);
              String detail = twitterId;
          }catch(Exception e){
              system.debug(e.getMessage());
          }
           
           
           String strUserId = UserInfo.getUserId();
       
       	   Schema.SObjectField externalIdField = testautonumdata__Twitter_User__c.Fields.Name;
       	   testautonumdata__Twitter_User__c  cstRecord = new testautonumdata__Twitter_User__c (Name = strUserId,
    	   testautonumdata__Token__c   = oauthToken,
    	   testautonumdata__Token_Secret__c   = oauthTokenSecret);
           Database.UpsertResult urList = Database.upsert(cstRecord, externalIdField, true);
          
      }
       
       
   }
    
   private void getTimeStamp(){
        DateTime dateTimeNow = dateTime.now();
        this.oauthTimestamp = ''+(dateTimeNow.getTime()/1000);
    }
    
   private  void generateNounce() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        
        while (randStr.length() < 32) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        this.oauthNonce =  EncodingUtil.base64Encode(Blob.valueOf(randStr)).remove('=');
    }
    
  private String generateSignature(String httpMethod, String baseUrl, Map<String, String> params){
              
           String encodedString = '';
           Map<String, String> encodeParams = new Map<String, String>();       
           encodeParams.putAll(params);
           encodeParams.put('oauth_nonce', this.oauthNonce);
           encodeParams.put('oauth_signature_method', this.oauthSignatureMethod);
           encodeParams.put('oauth_timestamp', this.oauthTimestamp);
           encodeParams.put('oauth_consumer_key', this.oauthConsumerKey);
           encodeParams.put('oauth_version', this.oauthVersion);
           
           List<String> keyList = New List<String>();
           keyList.addAll(encodeParams.keySet());
           keyList.sort();
           
           for(String key: keyList){
               encodedString +=  EncodingUtil.urlEncode(key,'UTF-8') + '=' + EncodingUtil.urlEncode(encodeParams.get(key),'UTF-8') + '&';
           }
           encodedString = encodedString.removeEnd('&');
            
           String baseString = httpMethod.toUpperCase() + '&' + EncodingUtil.urlEncode(baseUrl,'UTF-8') + '&' + EncodingUtil.urlEncode(encodedString,'UTF-8');
           String signingKey = EncodingUtil.urlEncode(this.oauthConsumerSecret,'UTF-8') + '&';
           if(params.containsKey('oauth_token') && String.isNotBlank(this.oauthTokenSecret)){
               signingKey += EncodingUtil.urlEncode(this.oauthTokenSecret,'UTF-8');
           }   
           
           Blob data = Crypto.generateMac('hmacSHA1', Blob.valueOf(baseString), Blob.valueOf(signingKey));
           String signature =  EncodingUtil.base64Encode(data);
           return signature;
      
  }
    
    
  private String generateAuthHeader(Map<String, String> params){
           
           Map<String, String> authParams = new Map<String, String>();
           authParams.putAll(params);
           authParams.put('oauth_consumer_key', this.oauthConsumerKey);
           authParams.put('oauth_signature_method', this.oauthSignatureMethod);
           authParams.put('oauth_timestamp', this.oauthTimestamp);
           authParams.put('oauth_nonce', this.oauthNonce);
           authParams .put('oauth_version', this.oauthVersion);
           
           List<String> keyList = New List<String>();
           keyList.addAll(authParams .keySet());
           keyList.sort();
           String OathString = '';    
           for(String key: keyList){
              OathString += EncodingUtil.urlEncode(key,'UTF-8') + '=' + '"' + EncodingUtil.urlEncode(authParams.get(key),'UTF-8') + '"' + ', '; 
           }
           OathString = 'OAuth ' + OathString.removeEnd(', ');
           return  OathString ;
    
} 


}