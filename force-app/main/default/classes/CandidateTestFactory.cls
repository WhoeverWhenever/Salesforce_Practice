@isTest
public with sharing class CandidateTestFactory {
    public static Candidate__c getCandidate(String name) {
        Candidate__c testCandidate = new Candidate__c(Name = name, Location__c = 'Filler', 
                                                Email__c = name + '@example.com', Phone__c = '+380337651100');
        return testCandidate;
    }

    public static List<Candidate__c> generateCandidates(Integer amount){
        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer i = 0; i < amount; i++){
            candidates.add(getCandidate('TestName'+i));
        }
        return candidates;
    }

    public static void generateCandidatesWithApplicationsAndReviews(Integer amount){
        List<Candidate__c> candidates = generateCandidates(amount);
        List<Position__c> positions = PositionTestFactory.generatePositions(amount);
        insert candidates;
        insert positions;

        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        for (Integer i = 0; i < amount; i++){
            jobApplications.add(JobApplicationTestFactory.getJobApplication(candidates[i].Id, positions[i].Id));
        }
        insert jobApplications;

        List<Review__c> reviews = new List<Review__c>();
        for (Integer i = 0; i < amount; i++){
            reviews.add(ReviewTestFactory.getReview(jobApplications[i].Id));
        }
        insert reviews;
    }
}