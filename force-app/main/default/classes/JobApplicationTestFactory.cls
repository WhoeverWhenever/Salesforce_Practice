@isTest
public with sharing class JobApplicationTestFactory {
    public static Job_Application__c getJobApplication(Id candidate, Id position) {
        Job_Application__c testJA = new Job_Application__c(Candidate__c = candidate, Position__c = position, 
                                                            Status__c = 'Received');
        return testJA;
    }
}