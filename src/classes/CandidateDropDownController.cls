public with sharing class CandidateDropDownController {

    @AuraEnabled
    public static List<Candidate__c> findAll(string objectApiName) {
        return [SELECT id, name FROM Candidate__c LIMIT 50];
    }

    @AuraEnabled
    public static List<Candidate__c> findByName(String searchKey) {
        String name = '%' + searchKey + '%';
        return [SELECT id, name FROM Candidate__c WHERE name LIKE :name LIMIT 50];
    }

    @AuraEnabled
    public static Candidate__c findById(String candidateId) {
        return [SELECT id, name/*, Candidate__c.Name*/
                    FROM Candidate__c WHERE Id = :candidateId];
    }

}