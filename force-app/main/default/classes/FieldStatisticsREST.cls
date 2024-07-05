@RestResource(urlMapping='/api/dbstatistics')
global with sharing class FieldStatisticsREST {
    @HttpGet
    global static Id getFieldStatistics(){
        RestRequest req = RestContext.request;
        Map<String, Integer> fieldStatistics = new Map<String, Integer>();
        List<String> fieldNames = new List<String>();
        List<Integer> amount = new List<Integer>();

        String objectAPIName = req.params.get('objectAPIName');
        SObjectType sObjType = ((SObject) Type.forName(objectAPIName).newInstance()).getSObjectType();
        Schema.DescribeSObjectResult describeSObjResult = sObjType.getDescribe();
        Map<String, Schema.SObjectField> fieldNamesMap = describeSObjResult.fields.getMap();

        for (Schema.SObjectField value : fieldNamesMap.Values()){
            fieldNames.add(value.getDescribe().getName());
        }

        FieldStatisticsBatchable countStatsInBatch = new FieldStatisticsBatchable(fieldNames, objectAPIName);
        Id statisticJob = Database.executeBatch(countStatsInBatch, 2000);

        return statisticJob;
    }
}
