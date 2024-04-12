@isTest
public with sharing class TestFactory {

    public static User getUser(String uniqueName, String profileName) {
        String uniqueUserName = uniqueName + DateTime.now().getTime() + '@testorg.com';
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName];
        User u = new User(Alias = 'standt', Email=uniqueName+'@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);

         return u;
    }

    public static Candidate__c getCandidate(String name) {
        Candidate__c testCandidate = new Candidate__c(Name = name, Location__c = 'Filler', 
                                                Email__c = name + '@example.com', Phone__c = '+380337651100');
        return testCandidate;
    }

    public static Position__c getPosition(String name) {
        Position__c testPosition = new Position__c(Name = name, Location__c = 'Position Filler', 
                                                Status__c = 'Open', Skills__c = 'JS', Description__c = 'Test Description');
        return testPosition;
    }

    public static Job_Application__c getJobApplication(Id candidate, Id position) {
        Job_Application__c testJA = new Job_Application__c(Candidate__c = candidate, Position__c = position, 
                                                            Status__c = 'Received');
        return testJA;
    }

    public static Review__c getReview(Id ja) {
        Review__c testReview = new Review__c (Job_Application__c = ja, Status__c = 'In progress');
        return testReview;
    }

    public static List<Candidate__c> generateCandidates(Integer amount){
        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer i = 0; i < amount; i++){
            candidates.add(getCandidate('TestName'+i));
        }
        return candidates;
    }

    public static List<Position__c> generatePositions(Integer amount){
        List<Position__c> positions = new List<Position__c>();
        for (Integer i = 0; i < amount; i++){
            positions.add(getPosition('Position Title'+i));
        }
        return positions;
    }

    public static void generateCandidatesWithApplicationsAndReviews(Integer amount){
        List<Candidate__c> candidates = generateCandidates(amount);
        List<Position__c> positions = generatePositions(amount);
        insert candidates;
        insert positions;

        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        for (Integer i = 0; i < amount; i++){
            jobApplications.add(getJobApplication(candidates[i].Id, positions[i].Id));
        }
        insert jobApplications;

        List<Review__c> reviews = new List<Review__c>();
        for (Integer i = 0; i < amount; i++){
            reviews.add(getReview(jobApplications[i].Id));
        }
        insert reviews;
    }
}