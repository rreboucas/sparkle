public with sharing class CandidateListController {
    
     @AuraEnabled
    public static List<Candidate__c> findAll() {
        return [SELECT id, name, Geolocation__Latitude__s, Geolocation__Longitude__s
                FROM Candidate__c
                WHERE Geolocation__Latitude__s != NULL AND Geolocation__Longitude__s != NULL
                LIMIT 50];
    }



}