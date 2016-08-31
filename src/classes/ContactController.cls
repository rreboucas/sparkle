public with sharing class ContactController {
 
     @AuraEnabled
    public static List<Contact> findAll() {
        return [SELECT Id, Name from Contact limit 10];
    }
 
    @AuraEnabled
    public static List<Contact> findByName(String name) {
        
        System.debug('name: ' + name);
        List<Contact> lstContactsToReturn = new List<Contact>();
        if (name != null)
        {
        String key = '%' + name + '%';
        lstContactsToReturn = [SELECT Id, Name FROM Contact WHERE Name LIKE :key limit 10];
        }
        else
            lstContactsToReturn = findAll();
        
        System.debug('lstContactsToReturn: ' + lstContactsToReturn);
        
        return lstContactsToReturn;
    }
}