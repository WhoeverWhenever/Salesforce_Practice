@isTest
private with sharing class JobApplicationServiceTest {
    @isTest
    static void getJobApplicationServiceTest() {
        User u1 = UserTestFactory.getUser('userRecruiter', 'Recruiter');
        User u2 = UserTestFactory.getUser('employeeUser', 'Standard Employee');
        System.runAs(u1){
            CandidateTestFactory.generateCandidatesWithApplicationsAndReviews(5);
        }
        System.runAs(u2){
            CandidateTestFactory.generateCandidatesWithApplicationsAndReviews(3);
        }
        List<Job_Application__c> jobApplications = [SELECT Id, Candidate__r.Owner.Profile.Name FROM Job_Application__c WHERE Candidate__r.Owner.Profile.Name = 'Recruiter'];
        List<Job_Application__c> updatedJobApplications = new List<Job_Application__c>();
        for (Integer i = 0; i < jobApplications.size(); i++){
            if(Math.mod(i, 2) != 0){
                Test.setCreatedDate(jobApplications[i].Id, Date.today().addDays(-10));
                updatedJobApplications.add(jobApplications[i]);
            }
        }
        update updatedJobApplications;


        Test.startTest();
        List<Job_Application__c> testJobApplications = JobApplicationService.getRecentRecruiterJobApplications(7);
        Test.stopTest();

        Assert.areEqual(3, testJobApplications.size(), 'Expected 3 records');
    }
}

