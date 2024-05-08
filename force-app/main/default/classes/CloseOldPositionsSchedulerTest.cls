@isTest
private class CloseOldPositionsSchedulerTest {
    @testSetup
    static void setup() {
        List<Position__c> primaryTestPositions = TestFactory.generatePositions(2000);
        insert primaryTestPositions;

        List<Position__c> primaryTestPositionsToUpdate = [SELECT Opened_Date__c FROM Position__c];
        for (Position__c p : primaryTestPositionsToUpdate){
            p.Opened_Date__c = Date.newInstance(1960, 2, 17);
        }
        update primaryTestPositionsToUpdate;
    }

    @isTest
    static void testCloseOldPositionsScheduler() {
        Test.startTest();
        CloseOldPositionsScheduler scheduler = new CloseOldPositionsScheduler();
        scheduler.execute(null);
        Test.stopTest();

        List<Position__c> closedPositions = [SELECT Id FROM Position__c WHERE Status__c = 'Closed'];
        System.assertEquals(2000, closedPositions.size());
    }
}
