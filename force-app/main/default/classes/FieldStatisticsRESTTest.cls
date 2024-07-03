@isTest
private with sharing class FieldStatisticsRESTTest {
    @TestSetup
    static void setup(){
        List<Position__c> testPositions = TestFactory.generatePositions(10000);
        insert testPositions;
    }

    @isTest
    static void getFieldStatisticsTest() {
        RestRequest request = new RestRequest();
        String objectAPIName = 'Position__c';
        String domainName = URL.getOrgDomainUrl().toExternalForm();
        request.requestUri = domainName + '/services/apexrest/api/dbstatistics';
        request.httpMethod = 'GET';
        request.addParameter('objectAPIName', objectAPIName);
        RestContext.request = request;

        Map<String, Integer> result = FieldStatisticsREST.getFieldStatistics();

        System.Assert(result.size() > 0);
        System.assertEquals(100, result.get('Id'), 'Id must have 100% filled statistic');
        System.assertEquals(100, result.get('Name'), 'Name must have 100% filled statistic');
    }
}
