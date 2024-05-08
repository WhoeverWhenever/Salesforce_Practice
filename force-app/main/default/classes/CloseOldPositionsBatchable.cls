public with sharing class CloseOldPositionsBatchable implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Status__c, Opened_Date__c 
                                        FROM Position__c
                                        WHERE Opened_Date__c <= :Date.today().addDays(-90)
                                        AND (Status__c = 'Open'
                                        OR Status__c = 'Open Hot')]);
     }
  
     public void execute(Database.BatchableContext bc, List<Position__c> scope){
        for (Position__c position : scope){
            position.Status__c = 'Closed';
        }
        update scope;
     }
  
     public void finish(Database.BatchableContext bc){
     }
}
