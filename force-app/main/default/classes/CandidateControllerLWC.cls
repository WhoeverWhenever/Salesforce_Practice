public with sharing class CandidateControllerLWC {
    @AuraEnabled (cacheable=true)
    public static List<User> getUserDetails(List<String> userIds){
        try {
            return [SELECT Name, SmallPhotoUrl FROM User WHERE Id IN :userIds];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
