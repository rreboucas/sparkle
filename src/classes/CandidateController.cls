public with sharing class CandidateController {


    
    @AuraEnabled
    public static List<Candidate__c> findAll() {
        return [SELECT Id,Name,testautonumdata__Geolocation__Latitude__s,testautonumdata__Geolocation__Longitude__s 
                FROM testautonumdata__Candidate__c where testautonumdata__Geolocation__Longitude__s <> null 
                and testautonumdata__Geolocation__Latitude__s <> null limit 50];
    }
    
     @AuraEnabled
    public static List<Candidate__c> findCandidateByID(String candidateID) {
        return [SELECT Id,Name,testautonumdata__Geolocation__Latitude__s,testautonumdata__Geolocation__Longitude__s, testautonumdata__City__c,testautonumdata__State__c 
                FROM testautonumdata__Candidate__c where testautonumdata__Geolocation__Longitude__s <> null 
                and testautonumdata__Geolocation__Latitude__s <> null and id =: candidateID limit 1];
    }

}