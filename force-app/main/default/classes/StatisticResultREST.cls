@RestResource(urlMapping='/api/dbstatisticsResult')
global with sharing class StatisticResultREST {
    @HttpGet
    global static void getStatisticResult(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String JobId = req.params.get('JobId');
        AsyncApexJob statisticBatch = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :JobId];
        if(statisticBatch.Status == 'Completed' && statisticBatch.NumberOfErrors == 0){
            res.responseBody = Blob.valueOf([SELECT Field_Statistic__c FROM DB_Statistic__c WHERE Job_Id__c = :JobId].Field_Statistic__c);
        }
        else if(statisticBatch.Status != null){
            res.responseBody = Blob.valueOf('Status: ' + statisticBatch.Status.toUpperCase() + '\nNumber of errors: ' + statisticBatch.NumberOfErrors);
        }
    }
}