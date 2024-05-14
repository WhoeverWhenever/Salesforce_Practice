@isTest
private with sharing class PositionControllerLWCTest {
    public static testMethod void testPositionControllerLWC() {

        List<Position__c> testPositions = PositionControllerTestFactory.getTestPositions();
        insert testPositions;

        List<Position__c> renderedPositions = PositionControllerLWC.getPositions('None');
        System.assertEquals(8, renderedPositions.size());

        renderedPositions = PositionControllerLWC.getPositions('');
        System.assertEquals(8, renderedPositions.size());

        renderedPositions = PositionControllerLWC.getPositions('Open');
        System.assertEquals(2, renderedPositions.size());

        renderedPositions = PositionControllerLWC.getPositions('Open Hot');
        System.assertEquals(1, renderedPositions.size());

        renderedPositions = PositionControllerLWC.getPositions('Closed');
        System.assertEquals(3, renderedPositions.size());

        renderedPositions = PositionControllerLWC.getPositions('Closed Cancelled');
        System.assertEquals(2, renderedPositions.size());

        User stdEmployee = TestFactory.getUser('employeeUser', 'Standard Employee');
        System.runAs(stdEmployee){
            List<Position__c> newRenderedPositions = PositionControllerLWC.getPositions('None');
            System.assertEquals(null, newRenderedPositions[0].Min_Pay__c);
            System.assertEquals(null, newRenderedPositions[0].Max_Pay__c);
        }

        try {
            renderedPositions = PositionControllerLWC.getPositions(null);
            Assert.fail('An exception should have been thrown');
          } catch (Exception e) {
            
          }
    }

    public static testMethod void testGetRelatedCandidates() {

        Position__c testPosition = TestFactory.getPosition('TestPosition');
        insert testPosition;

        List<Candidate__c> testCandidates = TestFactory.generateCandidates(5);
        insert testCandidates;

        List<Job_Application__c> testJobApplications = TestFactory.applyCandidatesForPosition(testCandidates, testPosition);
        insert testJobApplications;

        List<Candidate__c> relatedCandidates = PositionControllerLWC.getRelatedCandidatesWithJAs(testPosition.Id);
        System.assertEquals(5, relatedCandidates.size());

        User stdEmployee = TestFactory.getUser('employeeUser', 'Standard Employee');

        System.runAs(stdEmployee){
            try {
                List<Candidate__c> newRelatedCandidates = PositionControllerLWC.getRelatedCandidatesWithJAs(testPosition.Id);
                Assert.fail('An exception should have been thrown');
            } catch (Exception e) {
                
            }
        }

    }
}
