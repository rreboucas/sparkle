public with sharing class TestLSBugServerController {
    
    @AuraEnabled
    public static List<Contact> getServerData() {
        
        List<Contact> lstContacts = [SELECT id, Name FROM Contact];
        
        return lstContacts;
     
        
    }

}