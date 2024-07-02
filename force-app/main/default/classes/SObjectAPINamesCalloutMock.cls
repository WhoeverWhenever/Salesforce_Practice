@isTest
global class SObjectAPINamesCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://techmagic22-dev-ed.develop.my.salesforce.com/services/apexrest/api/SObjects', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('["Account", "Lead", "Contact", "Custom_Object__c"]');
        res.setStatusCode(200);

        return res;
    }
}
