public class linkedinauth {
    
    public String x{get;set;}
    public static final string REDIRECT_URL='https://rrlightningout-dev-ed.my.salesforce.com/apex/LinkedInReturn';
    public static final string LINKEDIN_API_KEY='77r77tdy23atxb';
    public static final string LINKEDIN_CLIENT_SECRET='UpAQXtUkA2ojBvSG';
	public static final string OAUTH_CODE_END_POINT_URL='https://www.linkedin.com/uas/oauth2/authorization?response_type=code';
    public static final string SCOPE='r_basicprofile r_emailaddress rw_company_admin w_share';
    public static final string STATE='DCEeFWf45A53sdfKef424'; 
   
   public PageReference connect(){
     x=OAUTH_CODE_END_POINT_URL+'&client_id='+LINKEDIN_API_KEY+'&scope='+SCOPE+'&state='+EncodingUtil.urlEncode(STATE,'UTF-8')+'&redirect_uri='+EncodingUtil.urlEncode(REDIRECT_URL,'UTF-8');
     PageReference pageRef = new PageReference(x);
     return pageRef; 
   }
    
    public void MyActionMethod()
   {
      String myoAuthCode = ApexPages.CurrentPage().getParameters().get('code');
       System.debug('########## myoAuthCode : ' + myoAuthCode);
       
       
       // get access token:
       
       String url = 'https://www.linkedin.com/uas/oauth2/accessToken?' +
            'grant_type=authorization_code' +
            '&code=' + myoAuthCode +
            '&redirect_uri=' + REDIRECT_URL +
            '&client_id=' + LINKEDIN_API_KEY +
            '&client_secret=' + LINKEDIN_CLIENT_SECRET;
       
       Http h = new Http();
       
       // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
       HttpRequest req = new HttpRequest();
       req.setEndpoint(url);
       req.setMethod('GET');
       
       // Send the request, and return a response
       HttpResponse res = h.send(req);
       String jSonAccessToken =  res.getBody(); 
       System.debug('########## jSonAccessToken : ' + jSonAccessToken);
       
       JSONParser parser = JSON.createParser(jSonAccessToken);
       
       String strAccessToken = '';
       
       while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'access_token')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                strAccessToken =  parser.getText();
            }
        }
       
       System.debug('########## strAccessToken : ' + strAccessToken);
       
       String strUserId = UserInfo.getUserId();
       
       Schema.SObjectField externalIdField = testautonumdata__LinkedinUser__c.Fields.Name;
       testautonumdata__LinkedinUser__c cstRecord = new testautonumdata__LinkedinUser__c(Name = strUserId,
    	testautonumdata__UserID__c  = strUserId,
    	testautonumdata__Linkedin_Token__c  = strAccessToken);
       Database.UpsertResult urList = Database.upsert(cstRecord, externalIdField, true);
       
       
       
   }

}