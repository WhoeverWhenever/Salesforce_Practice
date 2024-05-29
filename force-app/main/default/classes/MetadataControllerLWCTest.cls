@isTest
private with sharing class MetadataControllerLWCTest {

    @isTest
    public static void testGetAllRecruitingAppSettings() {
        List<Recruiting_App_Setting__mdt> testSettings = MetadataControllerLWC.getAllRecruitingAppSettings();
        System.assert(testSettings.size() > 0);
    }

    @isTest
    public static void testGetRecruitingAppSettings() {
        Recruiting_App_Setting__mdt setting = MetadataControllerLWC.getRecruitingAppSettings('Recruiter_Settings');
        System.assert(setting != null);

        try{
            Recruiting_App_Setting__mdt settingFailed = MetadataControllerLWC.getRecruitingAppSettings('null');
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }

    @isTest
    public static void testGetFieldSetNames() {
        List<String> fieldsetList = MetadataControllerLWC.getFieldSetNames('Candidate__c', 'Candidate_Modal_for_Recruiter');
        System.assert(fieldsetList.size() > 0);

        try{
            List<String> fieldsetListFailed = MetadataControllerLWC.getFieldSetNames(null, null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }

    @isTest
    public static void testGetFieldSetNamesWithPaths() {
        Map<String, String> fieldsetMap = MetadataControllerLWC.getFieldSetNamesWithPaths('Candidate__c', 'Candidate_Modal_for_Recruiter');
        System.assert(fieldsetMap.size() > 0);

        try{
            Map<String, String> fieldsetMapFailed = MetadataControllerLWC.getFieldSetNamesWithPaths(null, null);
            Assert.fail('An exception should have been thrown');
        }
        catch(Exception e){

        }
    }
}