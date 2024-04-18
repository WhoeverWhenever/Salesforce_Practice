@isTest
public with sharing class PositionControllerTestFactory {
    public static List<Position__c> getTestPositions() {
        List<Position__c> testPositions = new List<Position__c>();
        testPositions.add(new Position__c(Name = 'Test Position 1', Status__c = 'Open',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 2', Status__c = 'Open',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 3', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 4', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 5', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 6', Status__c = 'Closed Cancelled',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 7', Status__c = 'Open Hot',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 8', Status__c = 'Closed Cancelled',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        return testPositions;
    }
}