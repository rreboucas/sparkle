public with sharing class MapServerController {
	@AuraEnabled
    public static List<Candidate__c> findAll() {
        return [SELECT Id,Name,Geolocation__Latitude__s,Geolocation__Longitude__s 
                FROM Candidate__c where Geolocation__Longitude__s <> null 
                and Geolocation__Latitude__s <> null limit 50];
    }
    
     @AuraEnabled
    public static List<Candidate__c> findCandidateByID(String candidateID) {
        return [SELECT Id,Name,Geolocation__Latitude__s,Geolocation__Longitude__s, City__c,State__c 
                FROM Candidate__c where Geolocation__Longitude__s <> null 
                and Geolocation__Latitude__s <> null and id =: candidateID limit 1];
    }
}