public with sharing class DBStatisticCalloutService {
    public static HttpResponse getSObjectAPINames() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String authValue = 'Bearer '+ UserInfo.getSessionId();
        request.setEndpoint('https://techmagic22-dev-ed.develop.my.salesforce.com/services/apexrest/api/SObjects');
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
        request.setEndpoint('https://techmagic22-dev-ed.develop.my.salesforce.com/services/apexrest/api/dbstatistics?objectAPIName=' + 
                             EncodingUtil.urlEncode(objectAPIName,'utf-8'));
        request.setMethod('GET');
        request.setHeader('Authorization', authValue);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            for(String key : results.keySet()){
                System.debug(key + ': ' + results.get(key));
            }
        }

        return response;
    }
}