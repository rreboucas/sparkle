global with sharing class MapRemoter {

    @RemoteAction
    global static List<Candidate__c> findAll() {
        return [SELECT Id, Name, Geolocation__Latitude__s, Geolocation__Longitude__s
                    FROM Candidate__c];
    }

}