trigger JobApplicationTrigger on Job_Application__c (after update) {
    List<Id> positionIds = new List<Id>();
    for(Job_Application__c ja : [SELECT Position__c FROM Job_Application__c WHERE Id IN :Trigger.new AND Status__c = 'Hired']){
        positionIds.add(ja.Position__c);
    }
    List<Position__c> positionsToUpdate = [SELECT Status__c FROM Position__c WHERE Id IN :positionIds];
    for(Position__c position : positionsToUpdate){
        position.Status__c = 'Closed';
    }
    
    update positionsToUpdate;
}
