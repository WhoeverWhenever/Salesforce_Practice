// List<Job_Application__c> jobApplications = [SELECT Name, Candidate__r.Name, Position__r.Name,
//                                             (SELECT Name FROM Reviews__r),
//                                             CreatedDate, Candidate__r.Owner.Name
//                                             FROM Job_Application__c 
//                                             WHERE CreatedDate >= :Date.today().addDays(-withinLastDays)
//                                             AND Candidate__r.Owner.Profile.Name = 'Recruiter'];
List<Job_Application__c> jobApplications = JobApplicationService.getRecentRecruiterJobApplications(3);
System.Debug('\n\nDEBUG AREA SOQL\n');
for (Job_Application__c ja : jobApplications){
    System.Debug(ja);
}
System.Debug('\n\nDEBUG AREA SOQL\n');

// List<List<SObject>> soslResult = [FIND 'develop' IN ALL FIELDS RETURNING 
//                                     Position__c(Name WHERE CreatedDate <= :Date.today().addDays(-withinLastDays)), 
//                                     Candidate__c(Name WHERE CreatedDate <= :Date.today().addDays(-withinLastDays)), 
//                                     Review__c(Name WHERE CreatedDate <= :Date.today().addDays(-withinLastDays))];
List<List<SObject>> soslResult = RecruitingAppUtilities.findWord('develop', 3);
System.Debug('\n\nDEBUG AREA SOSL\n');
for (List<SObject> so : soslResult){
    System.Debug(so);
}
System.Debug('\n\nDEBUG AREA SOSL\n');