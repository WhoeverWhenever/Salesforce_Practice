@isTest
private with sharing class ReviewTriggerTest {

    @TestSetup static void reviewTriggerTestSetup() {
        List<Position__c> testPositions = TestFactory.generatePositions(50);
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(50);
        insert testPositions;
        insert testCandidates;

        List<Job_Application__c> testJobApplications = TestFactory.generateJobApplications(50, testCandidates, testPositions);
        insert testJobApplications;

        List<Review__c> testReviews = TestFactory.generateReviews(5, testJobApplications);
        insert testReviews;
    }

    @isTest
    public static void testReviewTriggerInsertion() {
        List<Job_Application__c> testJobApplications = [SELECT Id FROM Job_Application__c];
        List<Review__c> testReviews = TestFactory.generateReviews(3, testJobApplications);

        Test.startTest();
        insert testReviews;
        Test.stopTest();

        List<Job_Application__c> jobApplicationReviews = [SELECT Number_of_Reviews__c FROM Job_Application__c Limit 1];
        System.assertEquals(8, jobApplicationReviews[0].Number_of_Reviews__c);
    }

    @isTest
    public static void testReviewTriggerUpdate() {
        List<Review__c> reviewsToUpdate = [SELECT Name, Rating__c, Job_Application__c FROM Review__c ORDER BY Name LIMIT 5];
        Set<Id> jaIds = new Set<Id>();

        Test.startTest();
        for (Review__c r : reviewsToUpdate){
            r.Rating__c = 75;
            jaIds.add(r.Job_Application__c);
        }
        update reviewsToUpdate;
        Test.stopTest();

        List<Job_Application__c> jobApplicationUpdatedRating = [SELECT Average_Rating__c FROM Job_Application__c WHERE Id IN :jaIds];
        System.assertEquals(1, jobApplicationUpdatedRating.size());
        System.assertEquals(75, jobApplicationUpdatedRating[0].Average_Rating__c);
    }

    @isTest
    public static void testReviewTriggerDeletion() {
        List<Review__c> reviewsToDelete = [SELECT Name, Rating__c, Job_Application__c FROM Review__c LIMIT 3 OFFSET 245];

        Test.startTest();
        delete reviewsToDelete;
        Test.stopTest();

        Job_Application__c jobApplicationWithDeletedReviews = [SELECT Number_of_Reviews__c FROM Job_Application__c ORDER BY Name OFFSET 49];
        System.assertEquals(2, jobApplicationWithDeletedReviews.Number_of_Reviews__c);
    }

    @isTest
    public static void testReviewTriggerUndeletion() {
        List<Review__c> reviewsToDelete = [SELECT Name, Rating__c, Job_Application__c FROM Review__c LIMIT 3 OFFSET 245];
        delete reviewsToDelete;
        Review__c deletedReview = [SELECT Id FROM Review__c WHERE Name = :reviewsToDelete[1].Name ALL ROWS];

        Test.startTest();
        undelete deletedReview;
        Test.stopTest();

        Job_Application__c jobApplicationWithRestoredReview = [SELECT Number_of_Reviews__c FROM Job_Application__c ORDER BY Name OFFSET 49];
        System.assertEquals(3, jobApplicationWithRestoredReview.Number_of_Reviews__c);
    }
}