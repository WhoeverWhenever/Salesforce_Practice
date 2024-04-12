public with sharing class JobApplicationService {
    public static List<Job_Application__c> getRecentRecruiterJobApplications(Integer withinNumOfDays) {
        List<Job_Application__c> jobApplications = [SELECT Name, Candidate__r.Name, Position__r.Name,
                                            (SELECT Name FROM Reviews__r),
                                            CreatedDate, Candidate__r.Owner.Name
                                            FROM Job_Application__c 
                                            WHERE CreatedDate >= :Date.today().addDays(-withinNumOfDays)
                                            AND Candidate__r.Owner.Profile.Name = 'Recruiter'];
        return jobApplications;
    }
}