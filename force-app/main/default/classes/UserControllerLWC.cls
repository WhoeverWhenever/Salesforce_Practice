public with sharing class UserControllerLWC {

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfileName(){
        try {
            return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCurrentUserPermissionsNames(){
        try {
            List<String> permissionsNames = new List<String>();
            List<PermissionSetAssignment> currentUserPermissions = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()];
            for(PermissionSetAssignment psa : currentUserPermissions){
                permissionsNames.add(psa.PermissionSet.Name);
            }
            return permissionsNames;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}