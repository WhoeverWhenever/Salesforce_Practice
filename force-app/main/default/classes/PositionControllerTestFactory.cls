@isTest
public with sharing class PositionControllerTestFactory {
    public static List<Position__c> getTestPositions() {
        List<Position__c> testPositions = new List<Position__c>();
        testPositions.add(new Position__c(Name = 'Test Position 1', Status__c = 'Open', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 2', Status__c = 'Open', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 3', Status__c = 'Closed', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 4', Status__c = 'Closed', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 5', Status__c = 'Closed', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 6', Status__c = 'Closed Cancelled', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 7', Status__c = 'Open Hot', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 8', Status__c = 'Closed Cancelled', Min_Pay__c = 7, Max_Pay__c = 10,
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        
        return testPositions;
    }
}
