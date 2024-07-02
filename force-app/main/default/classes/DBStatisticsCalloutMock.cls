@isTest
global class DBStatisticsCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Name":100,"Custom__c":81,"Unneccessary":33,"Id":100}');
        res.setStatusCode(200);

        return res;
    }
}