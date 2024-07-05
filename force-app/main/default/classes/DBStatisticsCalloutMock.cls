@isTest
global class DBStatisticsCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('707WU000004wNlGYAU');
        res.setStatusCode(200);

        return res;
    }
}