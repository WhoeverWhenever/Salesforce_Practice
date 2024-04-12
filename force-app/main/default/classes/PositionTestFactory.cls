@isTest
public with sharing class PositionTestFactory {
    public static Position__c getPosition(String name) {
        Position__c testPosition = new Position__c(Name = name, Location__c = 'Position Filler', 
                                                Status__c = 'Open', Skills__c = 'JS', Description__c = 'Test Description');
        return testPosition;
    }

    public static List<Position__c> generatePositions(Integer amount){
        List<Position__c> positions = new List<Position__c>();
        for (Integer i = 0; i < amount; i++){
            positions.add(getPosition('Position Title'+i));
        }
        return positions;
    }
}