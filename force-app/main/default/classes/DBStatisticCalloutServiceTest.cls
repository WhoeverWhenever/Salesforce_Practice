@isTest
private class DBStatisticCalloutServiceTest {

    @isTest
    static void getSObjectAPINamesTestCallout() {
        Test.setMock(HttpCalloutMock.class, new SObjectAPINamesCalloutMock());
        
        HttpResponse res = DBStatisticCalloutService.getSObjectAPINames();
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = res.getBody();
        String expectedValue = '["Account", "Lead", "Contact", "Custom_Object__c"]';
        System.assertEquals(actualValue, expectedValue);

        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void getDBStatisticsTestCallout() {
        Test.setMock(HttpCalloutMock.class, new DBStatisticsCalloutMock());
        
        HttpResponse res = DBStatisticCalloutService.getDBStatistics('Review__c');
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = res.getBody();
        String expectedValue = '{"Name":100,"Custom__c":81,"Unneccessary":33,"Id":100}';
        System.assertEquals(actualValue, expectedValue);

        System.assertEquals(200, res.getStatusCode());
    }
}
