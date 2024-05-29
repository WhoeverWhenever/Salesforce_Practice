@isTest
private with sharing class CandidateControllerLWCTest {
    @TestSetup static void setup() {
        Candidate__c testCandidate = TestFactory.getCandidate('Testing');
        insert testCandidate;
    }

    public static testMethod void testGetUserDetails() {
        Candidate__c testCandidate = [SELECT Id, OwnerId, CreatedById, LastModifiedById FROM Candidate__c][0];

        Set<String> ids = new Set<String>();

        Map<String, Object> fieldsToValue = testCandidate.getPopulatedFieldsAsMap();
        for(String fieldName : fieldsToValue.keySet()){
            if(fieldName != 'Id'){
                ids.add((String)fieldsToValue.get(fieldName));
            }
        }

        List<String> idList = new List<String>(ids);

        List<User> users = CandidateControllerLWC.getUserDetails(idList);
        System.assert(users.size() > 0);

        try{
            List<User> users2 = CandidateControllerLWC.getUserDetails(null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }
}
