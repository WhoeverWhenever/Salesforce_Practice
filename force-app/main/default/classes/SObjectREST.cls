@RestResource(urlMapping='/api/SObjects')
global with sharing class SObjectREST {
    @HttpGet
    global static List<String> getSObjectAPINames() {
        List<String> sObjectAPINames = new List<String>();
        List<Schema.SObjectType> globalDescribeValues = Schema.getGlobalDescribe().Values();
        for(Schema.SObjectType item : globalDescribeValues){
            sObjectAPINames.add(item.getDescribe().getName());
        }

        return sObjectAPINames;
    }

}