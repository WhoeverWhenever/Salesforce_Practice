@isTest
private with sharing class SObjectRESTTest {
    @isTest
    static void getSObjectAPINamesTest() {
        RestRequest request = new RestRequest();
        request.requestUri ='https://techmagic22-dev-ed.develop.my.salesforce.com/services/apexrest/api/SObjects';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        List<String> result = SObjectREST.getSObjectAPINames();

        System.Assert(result.size() > 0);
    }
}
