public with sharing class CandidateControllerLWC {
    @AuraEnabled (cacheable=true)
    public static User getOwnerDetails(String candidateId){
        try {
            Id ownerId = [SELECT OwnerId FROM Candidate__c WHERE Id = :candidateId].OwnerId;
            
            return [SELECT Name, SmallPhotoUrl FROM User WHERE Id = :ownerId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static User getCreatorDetails(String candidateId){
        try {
            Id creatorId = [SELECT CreatedById FROM Candidate__c WHERE Id = :candidateId].CreatedById;

            return [SELECT Name, SmallPhotoUrl FROM User WHERE Id = :creatorId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static User getModifierDetails(String candidateId){
        try {
            Id modifierId = [SELECT LastModifiedById FROM Candidate__c WHERE Id = :candidateId].LastModifiedById;

            return [SELECT Name, SmallPhotoUrl FROM User WHERE Id = :modifierId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static List<User> getUserDetails(List<String> userIds){
        try {
            return [SELECT Name, SmallPhotoUrl FROM User WHERE Id IN :userIds];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
