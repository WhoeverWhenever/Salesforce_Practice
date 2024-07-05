public with sharing class DBStatisticCalloutService {
    final static String domainName = URL.getOrgDomainUrl().toExternalForm();

    public static HttpResponse getSObjectAPINames() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String authValue = 'Bearer '+ UserInfo.getSessionId();
        request.setEndpoint(domainName + '/services/apexrest/api/SObjects');
        request.setMethod('GET');
        request.setHeader('Authorization', authValue);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<String> sObjectNames = response.getBody().split(',');
            for(String sObjectName : sObjectNames){
                System.debug(sObjectName);
            }
        }
        
        return response;
    }

    public static HttpResponse getDBStatistics(String objectAPIName){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String authValue = 'Bearer '+ UserInfo.getSessionId();
        request.setEndpoint(domainName + '/services/apexrest/api/dbstatistics?objectAPIName=' + 
                             EncodingUtil.urlEncode(objectAPIName,'utf-8'));
        request.setMethod('GET');
        request.setHeader('Authorization', authValue);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            String result = response.getBody();
            System.debug(result);
        }

        return response;
    }

    public static HttpResponse getDBStatisticsResult(String jobId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String authValue = 'Bearer '+ UserInfo.getSessionId();
        request.setEndpoint(domainName + '/services/apexrest/api/dbstatisticsResult?JobId=' + 
                             EncodingUtil.urlEncode(jobId,'utf-8'));
        request.setMethod('GET');
        request.setHeader('Authorization', authValue);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            String result = response.getBody();
            System.debug(result);
        }

        return response;
    }
}