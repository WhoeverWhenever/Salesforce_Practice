public with sharing class RecruitingAppUtilities {
    public static List<List<SObject>> findWord(String word, Integer createdDaysAgo) {
        List<List<SObject>> soslResult = [FIND :word IN ALL FIELDS RETURNING 
                                    Position__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo)), 
                                    Candidate__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo)), 
                                    Review__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo))];
        return soslResult;
    }
}