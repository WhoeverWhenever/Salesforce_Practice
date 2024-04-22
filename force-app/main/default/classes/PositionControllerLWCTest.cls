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

        try {
            renderedPositions = PositionControllerLWC.getPositions(null);
            Assert.fail('An exception should have been thrown');
          } catch (Exception e) {
            
          }
    }
}