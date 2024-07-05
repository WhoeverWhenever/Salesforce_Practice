public with sharing class MetadataControllerLWC {

    @AuraEnabled(cacheable=true)
    public static List<Recruiting_App_Setting__mdt> getAllRecruitingAppSettings(){
        try {
            return Recruiting_App_Setting__mdt.getAll().values();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Recruiting_App_Setting__mdt getRecruitingAppSettings(String developerName){
        try {
            Recruiting_App_Setting__mdt setting = Recruiting_App_Setting__mdt.getInstance(developerName);
            if(setting != null){
                return setting;
            }
            else {
                throw new RecruitingAppUtilitiesException('Couldn\'t find needed settings!');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Candidate_Modal_New_Setting__mdt getCandidateModalNewSettings(String developerName){
        try {
            Candidate_Modal_New_Setting__mdt setting = Candidate_Modal_New_Setting__mdt.getInstance(developerName);
            if(setting != null){
                return setting;
            }
            else {
                throw new RecruitingAppUtilitiesException('Couldn\'t find needed settings!');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldSetNames(String sObjectName, String fieldSetName){
        List<String> result = new List<String>();
        try {
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult description = objToken.getDescribe();
            Map<String, Schema.FieldSet> fieldSetMap = description.fieldsets.getMap();

            if(fieldSetMap.containsKey(fieldSetName)){
                    for(Schema.FieldSetMember f : fieldSetMap.get(fieldSetName).getFields()){
                        result.add(f.getLabel());
                    }
            }

            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getFieldSetNamesWithPaths(String sObjectName, String fieldSetName){
        Map<String, String> result = new Map<String, String>();
        try {
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult description = objToken.getDescribe();
            Map<String, Schema.FieldSet> fieldSetMap = description.fieldsets.getMap();

            if(fieldSetMap.containsKey(fieldSetName)){
                    for(Schema.FieldSetMember f : fieldSetMap.get(fieldSetName).getFields()){
                        result.put(f.getLabel(), f.getFieldPath());
                    }
            }

            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
