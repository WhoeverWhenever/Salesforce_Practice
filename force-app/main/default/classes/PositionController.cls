public with sharing class PositionController {

    List<SelectOption> filterOptions {get;set;}
    List<Position__c> positions {get;set;}
    public String selectedFilterOption {get;set;} {selectedFilterOption = 'None';}

    public List<SelectOption> getFilterOptions(){
        filterOptions = new List<SelectOption>();
        List<String> pickListValuesList= new List<String>();
        try{
            if(Schema.SObjectType.Position__c.fields.Status__c.isAccessible()){
                Schema.DescribeFieldResult fieldResult = Position__c.Status__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

                filterOptions.add(new SelectOption('None', 'None'));
                for( Schema.PicklistEntry pickListVal : ple){
                    filterOptions.add(new SelectOption(pickListVal.getLabel(), pickListVal.getLabel()));
                }
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
        }
        
        return filterOptions;
    }

    public List<Position__c> getPositions() {
        try{
            List<SelectOption> listOfOptions = getFilterOptions();
            List<String> filterOptionValues = new List<String>();
            SObjectAccessDecision strippedPositionRecords;

            for (SelectOption option : listOfOptions) {
                if(option.getValue() != 'None'){
                    filterOptionValues.add(option.getValue());
                }
            }

            if(selectedFilterOption.equals('None') || String.isBlank(selectedFilterOption)){
                strippedPositionRecords = Security.stripInaccessible(AccessType.READABLE, 
                                                                    [SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c]);
            }
            else if (filterOptionValues.contains(selectedFilterOption)){
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
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
        }

        return positions;
    }

    public void save(){
        try {
            if (Schema.SObjectType.Position__c.isUpdateable()){
                update positions;
            }
        }
        catch(DmlException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'DML error occured: ' + e.getMessage()));
        }
    }
}
