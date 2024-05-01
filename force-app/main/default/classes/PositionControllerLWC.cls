public with sharing class PositionControllerLWC {
    static List<Position__c> positions {get;set;}
    
    @AuraEnabled (cacheable=true)
    public static List<Position__c> getPositions(String selectedFilterOption){
        SObjectAccessDecision strippedPositionRecords;
        try {
            if(selectedFilterOption.equals('None') || String.isBlank(selectedFilterOption)){
                strippedPositionRecords = Security.stripInaccessible(AccessType.READABLE, 
                                                                    [SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c]);
            }
            else if (selectedFilterOption.length() > 0){
                strippedPositionRecords = Security.stripInaccessible(AccessType.READABLE, 
                                                                    [SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c WHERE Status__c = :selectedFilterOption]);
            }

            positions = strippedPositionRecords.getRecords();
            List<String> removedFields = new List<String>(strippedPositionRecords.getRemovedFields().get('Position__c'));
            
            if(removedFields.size() > 0){
                for(Position__c p : positions){
                    for(String field : removedFields){
                        p.put(field, null);
                    }
                }
            }

            return positions;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
