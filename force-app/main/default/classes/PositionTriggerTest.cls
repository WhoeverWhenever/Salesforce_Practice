@isTest
private with sharing class PositionTriggerTest {

    @testSetup static void setupTestPositions() {
        List<Position__c> testPositions = new List<Position__c>();
        for(Integer i = 0; i < 750; i++) {
            testPositions.add(new Position__c(Name = 'TestPosition' + i, Status__c = 'Open', Location__c = 'Filler', Skills__c = 'Java', Description__c = 'Test Description ' + i));
        }
        insert testPositions;        
    }

    @isTest
    public static void testPositionTrigger() {
        List<Position__c> testPositions = [SELECT Status__c FROM Position__c];
        List<Position__c> testPositionsToUpdate = new List<Position__c>();

        Test.startTest();
        for(Integer i = 0; i < 500; i++){
            if(i < 250){
                testPositions[i].Status__c = 'Closed';
                testPositionsToUpdate.add(testPositions[i]);
            }
            else{
                testPositions[i].Status__c = 'Closed Cancelled';
                testPositionsToUpdate.add(testPositions[i]);
            }
        }
        update testPositionsToUpdate;
        Test.stopTest();

        List<Position__c> closedPositions = [SELECT Closed_Date__c FROM Position__c WHERE Closed_Date__c = :Date.today()];
        System.assertEquals(500, closedPositions.size());
    }
}
