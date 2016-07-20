public class TwitterUtils {
    
    public static String generateSignature(String httpMethod, String baseUrl, Map<String, String> params, String oauthSignatureMethod, String oauthConsumerKey, String oauthConsumerSecret, String oauthTokenSecret, String oauthVersion){
              
           String encodedString = '';
           Map<String, String> encodeParams = new Map<String, String>();       
           encodeParams.putAll(params);
           encodeParams.put('oauth_nonce', generateNounce());
           encodeParams.put('oauth_signature_method', oauthSignatureMethod);
           encodeParams.put('oauth_timestamp', getTimeStamp());
           encodeParams.put('oauth_consumer_key', oauthConsumerKey);
           encodeParams.put('oauth_version', oauthVersion);
           
           List<String> keyList = New List<String>();
           keyList.addAll(encodeParams.keySet());
           keyList.sort();
           
           for(String key: keyList){
               encodedString +=  EncodingUtil.urlEncode(key,'UTF-8') + '=' + EncodingUtil.urlEncode(encodeParams.get(key),'UTF-8') + '&';
           }
           encodedString = encodedString.removeEnd('&');
            
           String baseString = httpMethod.toUpperCase() + '&' + EncodingUtil.urlEncode(baseUrl,'UTF-8') + '&' + EncodingUtil.urlEncode(encodedString,'UTF-8');
           String signingKey = EncodingUtil.urlEncode(oauthConsumerSecret,'UTF-8') + '&';
           if(params.containsKey('oauth_token') && String.isNotBlank(oauthTokenSecret)){
               signingKey += EncodingUtil.urlEncode(oauthTokenSecret,'UTF-8');
           }   
           
           Blob data = Crypto.generateMac('hmacSHA1', Blob.valueOf(baseString), Blob.valueOf(signingKey));
           String signature =  EncodingUtil.base64Encode(data);
           return signature;
      
  }
    
    
  public static String generateAuthHeader(Map<String, String> params, String oauthConsumerKey, String oauthSignatureMethod, String oauthVersion){
           
           Map<String, String> authParams = new Map<String, String>();
           authParams.putAll(params);
           authParams.put('oauth_consumer_key', oauthConsumerKey);
           authParams.put('oauth_signature_method', oauthSignatureMethod);
           authParams.put('oauth_timestamp', getTimeStamp());
           authParams.put('oauth_nonce', generateNounce());
           authParams .put('oauth_version', oauthVersion);
           
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
    
    private static String getTimeStamp(){
        DateTime dateTimeNow = dateTime.now();
        String tmsTamp = '' +(dateTimeNow.getTime()/1000);
        return tmsTamp;
    }
    
   private static String generateNounce() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        
        while (randStr.length() < 32) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        String oauthNonce =  EncodingUtil.base64Encode(Blob.valueOf(randStr)).remove('=');
       return oauthNonce;
    }
    
    

}