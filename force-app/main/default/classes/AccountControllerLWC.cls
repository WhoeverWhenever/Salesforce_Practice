public with sharing class AccountControllerLWC {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        try {

            return [SELECT Name, AccountNumber, AnnualRevenue, Phone FROM Account];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
