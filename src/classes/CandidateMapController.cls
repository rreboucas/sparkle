public with sharing class CandidateMapController {
    
     @AuraEnabled
    public static List<Candidate__c> findAll() {
        return [SELECT id, name, Geolocation__Latitude__s, Geolocation__Longitude__s
                FROM Candidate__c
                WHERE Geolocation__Latitude__s != NULL AND Geolocation__Longitude__s != NULL
                LIMIT 50];
    }

     @AuraEnabled
    public static List<Candidate__c> findCandidateByID(string candidateID) {
        return [SELECT id, name, Geolocation__Latitude__s, Geolocation__Longitude__s
                FROM Candidate__c
                WHERE Geolocation__Latitude__s != NULL AND Geolocation__Longitude__s != NULL
                AND id =: candidateID
                
                LIMIT 50];
    }


}

/*Does this need the namespace before it?
 * 
 *     public static List<Candidate__c> findAll() {
        return [SELECT id, name, testautonumdata__Geolocation__Latitude__s, testautonumdata__Geolocation__Longitude__s
                FROM Candidate__c
                WHERE testautonumdata__Geolocation__Latitude__s != NULL AND testautonumdata__Geolocation__Longitude__s != NULL
                LIMIT 50];
    }
*/