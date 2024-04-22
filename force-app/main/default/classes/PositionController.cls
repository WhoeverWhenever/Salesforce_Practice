public with sharing class PositionController {

    List<SelectOption> filterOptions {get;set;}
    List<Position__c> positions {get;set;}
    public String selectedFilterOption {get;set;} {selectedFilterOption = 'None';}

    public List<SelectOption> getFilterOptions(){
        filterOptions = new List<SelectOption>();
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Position__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        filterOptions.add(new SelectOption('None', 'None'));
		for( Schema.PicklistEntry pickListVal : ple){
            filterOptions.add(new SelectOption(pickListVal.getLabel(), pickListVal.getLabel()));
		} 

        return filterOptions;
    }

    public List<Position__c> getPositions() {
        String positionQuery = 'SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c';
        if(selectedFilterOption.equals('None') || String.isBlank(selectedFilterOption)){
            positions = Database.query(positionQuery);
        }
        else if (selectedFilterOption.length() > 0){
            positions = Database.query(positionQuery + ' WHERE Status__c = :selectedFilterOption');
        }

        return positions;
    }

    public void save(){
        update positions;
    }
}
