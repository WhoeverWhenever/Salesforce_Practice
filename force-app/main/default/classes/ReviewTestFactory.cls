@isTest
public with sharing class ReviewTestFactory {
    public static Review__c getReview(Id ja) {
        Review__c testReview = new Review__c (Job_Application__c = ja, Status__c = 'In progress');
        return testReview;
    }
}