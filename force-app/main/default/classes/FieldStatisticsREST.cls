@RestResource(urlMapping='/api/dbstatistics')
global with sharing class FieldStatisticsREST {
    @HttpGet
    global static Map<String, Integer> getFieldStatistics(){
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

        String fieldQuery = String.join(fieldNames, ',');
        List<SObject> result = Database.query('SELECT ' + fieldQuery + ' FROM ' + objectAPIName);
        
        for (String fName: fieldNames){
            Integer count = 0;
            for(SObject o : result){
                if(o.get(fName) != null){
                    count++;
                }
            }
            amount.add(count);
        }
        
        for(Integer i = 0; i < fieldNames.size(); i++){
            fieldStatistics.put(fieldNames[i], (amount[i]*100)/amount[0]);
        }

        return fieldStatistics;
    }
}
