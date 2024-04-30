@isTest
private with sharing class RecruitingAppUtilitiesTest {

    @isTest
    static void getJobApplicationServiceTest() {
        User u1 = TestFactory.getUser('userRecruiter', 'Recruiter');
        User u2 = TestFactory.getUser('employeeUser', 'Standard Employee');
        System.runAs(u1){
            TestFactory.generateCandidatesWithApplicationsAndReviews(5);
        }
        System.runAs(u2){
            TestFactory.generateCandidatesWithApplicationsAndReviews(3);
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
        List<Job_Application__c> testJobApplications = RecruitingAppUtilities.getRecentRecruiterJobApplications(7);
        Assert.areEqual(3, testJobApplications.size(), 'Expected 3 records');

        try {
            List<Job_Application__c> testNegativeJobApplications = RecruitingAppUtilities.getRecentRecruiterJobApplications(-2);
            Assert.fail('An exception should have been thrown');
        } 
        catch (RecruitingAppUtilitiesException e) {
            Assert.isTrue(
              e.getMessage().equalsIgnoreCase('Invalid time period!'),
              'Exception message does not match: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void findWordTest() {
        
        List<Id> fixedSearchResults= new List<Id>();

        TestFactory.generateCandidatesWithApplicationsAndReviews(7);
        Candidate__c candidate = [SELECT Id, Email__c FROM Candidate__c WHERE Name = 'TestName3'];
        Test.setCreatedDate(candidate.Id, Date.today().addDays(-7));
        candidate.Email__c = 'develop@example.com';
        update candidate;
        fixedSearchResults.add(candidate.id);

        List<Position__c> positions = [SELECT Id, Description__c FROM Position__c];
        List<Position__c> updatedPositions = new List<Position__c>();
        for (Integer i = 0; i < positions.size(); i++){
            if(Math.mod(i, 2) != 0){
                Test.setCreatedDate(positions[i].Id, Date.today().addDays(-10));
                positions[i].Description__c = 'develop some code';
                updatedPositions.add(positions[i]);
                fixedSearchResults.add(positions[i].id);
            }
        }

        List<Review__c> reviews = [SELECT Id, Review_Text__c FROM Review__c LIMIT 5];
        for (Review__c r : reviews){
            Test.setCreatedDate(r.Id, Date.today().addDays(-11));
            r.Review_Text__c = 'Need to develop character';
            fixedSearchResults.add(r.id);
        }
        update reviews;

        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<List<SObject>> result = RecruitingAppUtilities.findWord('develop', 7);

        Assert.areEqual(3, result.size(), 'Expected 3 lists');
        Assert.areEqual(3, result[0].size(), 'Expected 3 records of Position');
        Assert.areEqual(1, result[1].size(), 'Expected 1 record of Candidate');
        Assert.areEqual(5, result[2].size(), 'Expected 5 records of Reviews');

        try {
            List<List<SObject>> negativeResult1 = RecruitingAppUtilities.findWord('devel0p', 7);
            Assert.fail('An exception should have been thrown');
        } 
        catch (RecruitingAppUtilitiesException e) {
            Assert.isTrue(
              e.getMessage().equalsIgnoreCase('Invalid input parameters!'),
              'Exception message does not match: ' + e.getMessage()
            );
        }

        try {
            List<List<SObject>> negativeResult2 = RecruitingAppUtilities.findWord('develop', 0);
            Assert.fail('An exception should have been thrown');
        } 
        catch (RecruitingAppUtilitiesException e) {
            Assert.isTrue(
              e.getMessage().equalsIgnoreCase('Invalid input parameters!'),
              'Exception message does not match: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
}
