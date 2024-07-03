@isTest
private with sharing class SObjectRESTTest {
    @isTest
    static void getSObjectAPINamesTest() {
        RestRequest request = new RestRequest();
        String domainName = URL.getOrgDomainUrl().toExternalForm();
        request.requestUri = domainName + '/services/apexrest/api/SObjects';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        List<String> result = SObjectREST.getSObjectAPINames();

        System.Assert(result.size() > 0);
    }
}
