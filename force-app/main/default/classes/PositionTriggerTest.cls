@isTest
private with sharing class PositionTriggerTest {
    
    @isTest
    public static void testPositionTrigger() {
        List<Position__c> testPositions = TestFactory.generatePositions(750);
        insert testPositions;  
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
