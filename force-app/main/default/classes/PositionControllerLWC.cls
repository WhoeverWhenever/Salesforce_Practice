public with sharing class PositionControllerLWC {
    static List<Position__c> positions {get;set;}
    
    @AuraEnabled (cacheable=true)
    public static List<Position__c> getPositions(String selectedFilterOption){
        try {
            String positionQuery = 'SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c';
            if(selectedFilterOption.equals('None') || String.isBlank(selectedFilterOption)){
                positions = Database.query(positionQuery);
            }
            else if (selectedFilterOption.length() > 0){
                positions = Database.query(positionQuery + ' WHERE Status__c = :selectedFilterOption');
            }

            return positions;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
