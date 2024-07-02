public with sharing class UserControllerLWC {

    @AuraEnabled(cacheable=true)
    public static String getCurrentUserProfileName(){
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCurrentUserPermissionsNames(){
            List<String> permissionsNames = new List<String>();
            List<PermissionSetAssignment> currentUserPermissions = [SELECT PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()];
            for(PermissionSetAssignment psa : currentUserPermissions){
                permissionsNames.add(psa.PermissionSet.Name);
            }
            return permissionsNames;
    }
}
