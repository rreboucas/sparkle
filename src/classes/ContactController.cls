public with sharing class ContactController {
 
    @AuraEnabled
    public static List<Contact> findAll() {
        return [SELECT Id, Name from Contact limit 20];
    }
 
    @AuraEnabled
    public static List<Contact> findByName(String name) {
        
        System.debug('name: ' + name);
        List<Contact> lstContactsToReturn = new List<Contact>();
        if (Schema.SObjectType.Contact.fields.Name.isAccessible() ) {
            if (name != null)
            {
            String key = '%' + name + '%';
            lstContactsToReturn = [SELECT Id, Name FROM Contact WHERE Name LIKE :key LIMIT 20];
            }
            else
                lstContactsToReturn = findAll();
            
            System.debug('lstContactsToReturn: ' + lstContactsToReturn);
        }
        return lstContactsToReturn;
    }
}