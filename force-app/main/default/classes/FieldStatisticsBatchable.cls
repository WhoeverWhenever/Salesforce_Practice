public with sharing class FieldStatisticsBatchable implements Database.Batchable<SObject>, Database.Stateful{

    List<String> fieldNames;
    String objectName;
    Map<String, Decimal> fieldMap = new Map<String, Decimal>();

    public FieldStatisticsBatchable(List<String> objectFieldNames, String objectAPIName) {
        fieldNames = objectFieldNames.clone();
        objectName = objectAPIName;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        String fieldQuery = String.join(fieldNames, ',');
        return Database.getQueryLocator('SELECT ' + fieldQuery + ' FROM ' + objectName);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope){
        for(SObject sobj : scope){
            for(String fieldName : fieldNames){
                if(sobj.get(fieldName) != null && fieldMap.containsKey(fieldName)){
                    fieldMap.put(fieldName, fieldMap.get(fieldName)+1);
                }
                else if(sobj.get(fieldName) != null && !fieldMap.containsKey(fieldName)){
                    fieldMap.put(fieldName, 1);
                }
                else if(sobj.get(fieldName) == null && !fieldMap.containsKey(fieldName)){
                    fieldMap.put(fieldName, 0);
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        Integer numberOfRecords = fieldMap.get('Id').intValue();
        for(String fieldName : fieldNames){
            fieldMap.put(fieldName, ((fieldMap.get(fieldName)*100)/numberOfRecords).setScale(2));
        }
        String jsonResult = JSON.serialize(fieldMap);
        DB_Statistic__c statisticObject = new DB_Statistic__c(Field_Statistic__c = jsonResult, Job_Id__c = bc.getJobId());
        insert statisticObject;
    }
}