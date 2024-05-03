public with sharing class RecruitingAppUtilities {
    public static List<Job_Application__c> getRecentRecruiterJobApplications(Integer withinNumOfDays) {
        if(withinNumOfDays > 0){
            List<Job_Application__c> jobApplications = [SELECT Name, Candidate__r.Name, Position__r.Name,
                                            (SELECT Name FROM Reviews__r),
                                            CreatedDate, Candidate__r.Owner.Name
                                            FROM Job_Application__c 
                                            WHERE CreatedDate >= :Date.today().addDays(-withinNumOfDays)
                                            AND Candidate__r.Owner.Profile.Name = 'Recruiter'];

            return jobApplications;
        }
        else{
            throw new RecruitingAppUtilitiesException('Invalid time period!');
        }
    }

    public static List<List<SObject>> findWord(String word, Integer createdDaysAgo) {
        if(createdDaysAgo > 0 && Pattern.matches('^[A-Za-z]+$', word)){
            List<List<SObject>> soslResult = [FIND :word IN ALL FIELDS RETURNING 
                                    Position__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo)), 
                                    Candidate__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo)), 
                                    Review__c(Name WHERE CreatedDate <= :Date.today().addDays(-createdDaysAgo))];

            return soslResult;
        }
        else{
            throw new RecruitingAppUtilitiesException('Invalid input parameters!');
        }
    }
}
