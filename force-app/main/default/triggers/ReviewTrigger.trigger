trigger ReviewTrigger on Review__c (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        Set<Id> jobApplicationIds = new Set<Id>();

        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
            for (Review__c review : Trigger.new){
                jobApplicationIds.add(review.Job_Application__c);
            }
        }

        if(Trigger.isDelete){
            for (Review__c review : Trigger.old){
                jobApplicationIds.add(review.Job_Application__c);
            }
        }

        List<AggregateResult> groupedResults = [SELECT Job_Application__c, AVG(Rating__c) averageRating, COUNT(Id) numOfReviews FROM Review__c 
                                                WHERE Job_Application__c IN :jobApplicationIds GROUP BY Job_Application__c];

        List<Job_Application__c> jasToUpdate = new List<Job_Application__c>();
        for (AggregateResult ar : groupedResults){
            jasToUpdate.add(new Job_Application__c(Id = (Id)ar.get('Job_Application__c'), 
                                                   Average_Rating__c = (Double)ar.get('averageRating'), 
                                                   Number_of_Reviews__c = (Integer)ar.get('numOfReviews')));
        }

        update jasToUpdate;
    }
}
