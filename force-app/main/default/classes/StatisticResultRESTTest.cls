@isTest
private with sharing class StatisticResultRESTTest {
    @TestSetup
    static void setup(){
        List<Position__c> testPositions = TestFactory.generatePositions(2000);
        insert testPositions;
    }
    
    @isTest
    static void getFieldStatisticsResultTest() {
        Test.startTest();
        List<String> fieldNames = new List<String>();
        SObjectType sObjType = ((SObject) Type.forName('Position__c').newInstance()).getSObjectType();
        Schema.DescribeSObjectResult describeSObjResult = sObjType.getDescribe();
        Map<String, Schema.SObjectField> fieldNamesMap = describeSObjResult.fields.getMap();
        for (Schema.SObjectField value : fieldNamesMap.Values()){
            fieldNames.add(value.getDescribe().getName());
        }
        FieldStatisticsBatchable countStatsInBatch = new FieldStatisticsBatchable(fieldNames, 'Position__c');
        Id jobId = Database.executeBatch(countStatsInBatch, 2000);
        Test.stopTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        String domainName = URL.getOrgDomainUrl().toExternalForm();
        request.requestUri = domainName + '/services/apexrest/api/dbstatisticsResult';
        request.httpMethod = 'GET';
        request.addParameter('JobId', jobId);
        RestContext.request = request;
        RestContext.response = response;
        StatisticResultREST.getStatisticResult();
    }

    @isTest
    static void getFieldStatisticsResultWithAnotherStatusTest() {
        Test.startTest();
        List<String> fieldNames = new List<String>();
        SObjectType sObjType = ((SObject) Type.forName('Position__c').newInstance()).getSObjectType();
        Schema.DescribeSObjectResult describeSObjResult = sObjType.getDescribe();
        Map<String, Schema.SObjectField> fieldNamesMap = describeSObjResult.fields.getMap();
        for (Schema.SObjectField value : fieldNamesMap.Values()){
            fieldNames.add(value.getDescribe().getName());
        }
        FieldStatisticsBatchable countStatsInBatch = new FieldStatisticsBatchable(fieldNames, 'Position__c');
        Id jobId = Database.executeBatch(countStatsInBatch, 2000);
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        String domainName = URL.getOrgDomainUrl().toExternalForm();
        request.requestUri = domainName + '/services/apexrest/api/dbstatisticsResult';
        request.httpMethod = 'GET';
        request.addParameter('JobId', jobId);
        RestContext.request = request;
        RestContext.response = response;
        StatisticResultREST.getStatisticResult();
        Test.stopTest();
    }
}