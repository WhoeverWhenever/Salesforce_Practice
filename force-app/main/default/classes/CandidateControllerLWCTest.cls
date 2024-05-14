@isTest
private with sharing class CandidateControllerLWCTest {
    @TestSetup static void setup() {
        Candidate__c testCandidate = TestFactory.getCandidate('Testing');
        insert testCandidate;
    }

    public static testMethod void testGetOwnerDetails() {
        Candidate__c testCandidate = [SELECT Id FROM Candidate__c][0];

        User owner = CandidateControllerLWC.getOwnerDetails(testCandidate.Id);
        System.assert(owner != null);

        try{
            User owner2 = CandidateControllerLWC.getOwnerDetails(null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }

    public static testMethod void testGetCreatorDetails() {
        Candidate__c testCandidate = [SELECT Id FROM Candidate__c][0];

        User creator = CandidateControllerLWC.getCreatorDetails(testCandidate.Id);
        System.assert(creator != null);

        try{
            User creator2 = CandidateControllerLWC.getCreatorDetails(null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }

    public static testMethod void testGetModifierDetails() {
        Candidate__c testCandidate = [SELECT Id FROM Candidate__c][0];

        User modifier = CandidateControllerLWC.getModifierDetails(testCandidate.Id);
        System.assert(modifier != null);
        
        try{
            User modifier2 = CandidateControllerLWC.getModifierDetails(null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }
}
