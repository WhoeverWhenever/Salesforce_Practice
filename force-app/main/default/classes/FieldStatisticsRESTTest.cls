@isTest
private class FieldStatisticsRESTTest {
    @TestSetup
    static void setup(){
        List<Position__c> testPositions = TestFactory.generatePositions(2000);
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

        Test.startTest();
        Id resultId = FieldStatisticsREST.getFieldStatistics();
        Test.stopTest();
        
        AsyncApexJob resultJob = [SELECT TotalJobItems FROM AsyncApexJob WHERE Id = :resultId];

        Assert.areEqual(1, resultJob.TotalJobItems);
        Assert.isInstanceOfType(resultId, Id.class);
    }
}
