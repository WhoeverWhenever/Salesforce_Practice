trigger PositionTrigger on Position__c (before update) {
    for (Position__c closedPosition : Trigger.new){
        if(closedPosition.Opened_Date__c != NULL && closedPosition.Closed_Date__c == NULL && 
          (closedPosition.Status__c == 'Closed' || closedPosition.Status__c == 'Closed Cancelled')){
            closedPosition.Closed_Date__c = Date.today();
        }
    }
}