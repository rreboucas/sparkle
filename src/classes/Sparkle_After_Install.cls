global class Sparkle_After_Install implements InstallHandler {
	
	global void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
      Twitter_User__c cstRecord = new Twitter_User__c(Name = 'TwitterApp',
    	Token_Secret__c  = 'LETjbmGTLmKF9tBldLY8gbNH3pwCgbg7o6ocSixKrkbdRbeJDx',
    	Token__c  = 'crTSqn98nBWCC8lbj0IauMv06');
       Database.UpsertResult urList = Database.upsert(cstRecord, true);
      }

    }
}