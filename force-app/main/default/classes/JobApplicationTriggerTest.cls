@isTest
private with sharing class JobApplicationTriggerTest {
    @isTest
    public static void testJobApplicationTrigger() {
        List<Position__c> testPositions = TestFactory.generatePositions(500);
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(500);
        insert testPositions;
        insert testCandidates;

        List<Job_Application__c> testJobApplications = TestFactory.generateJobApplications(500, testCandidates, testPositions);
        insert testJobApplications;

        Test.startTest();
        for(Integer i = 0; i < 300; i++){
            testJobApplications[i].Status__c = 'Hired';
        }
        update testJobApplications;
        Test.stopTest();

        List<Position__c> updatedPositions = [SELECT Status__c FROM Position__c WHERE Status__c = 'Closed'];
        System.assertEquals(300, updatedPositions.size());
    }
}
