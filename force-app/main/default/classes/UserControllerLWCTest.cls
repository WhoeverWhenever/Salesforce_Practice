@isTest
private with sharing class UserControllerLWCTest {
    public static testMethod void testGetCurrentUserProfileName() {
        String profileName = UserControllerLWC.getCurrentUserProfileName();
        System.assert(profileName != null);
    }

    public static testMethod void testGetCurrentUserPermissionsNames() {
        List<String> permissions = UserControllerLWC.getCurrentUserPermissionsNames();
        System.assert(permissions.size() > 0);
    }
}
