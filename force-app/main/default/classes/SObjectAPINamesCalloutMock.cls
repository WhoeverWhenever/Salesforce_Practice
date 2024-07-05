@isTest
global class SObjectAPINamesCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        String domainName = URL.getOrgDomainUrl().toExternalForm();
        System.assertEquals(domainName + '/services/apexrest/api/SObjects', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('["Account", "Lead", "Contact", "Custom_Object__c"]');
        res.setStatusCode(200);

        return res;
    }
}
