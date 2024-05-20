public with sharing class PositionControllerLWC {
    static List<Position__c> positions {get;set;}
    static List<Candidate__c> relatedCandidates {get;set;}
    
    @AuraEnabled (cacheable=true)
    public static List<Position__c> getPositions(String selectedFilterOption){
        SObjectAccessDecision strippedPositionRecords;
        try {
            if(selectedFilterOption.equals('None') || String.isBlank(selectedFilterOption)){
                strippedPositionRecords = Security.stripInaccessible(AccessType.READABLE, 
                                                                    [SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c]);
            }
            else if (selectedFilterOption.length() > 0){
                strippedPositionRecords = Security.stripInaccessible(AccessType.READABLE, 
                                                                    [SELECT Name, Status__c, Opened_Date__c, Closed_Date__c, Min_Pay__c, Max_Pay__c FROM Position__c WHERE Status__c = :selectedFilterOption]);
            }

            positions = strippedPositionRecords.getRecords();
            List<String> removedFields = new List<String>(strippedPositionRecords.getRemovedFields().get('Position__c'));
            
            if(removedFields.size() > 0){
                for(Position__c p : positions){
                    for(String field : removedFields){
                        p.put(field, null);
                    }
                }
            }

            return positions;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static List<Candidate__c> getRelatedCandidatesWithJAs(String positionId){
        try {
            List<Job_Application__c> relatedJAs = [SELECT Candidate__c FROM Job_Application__c WHERE Position__c = :positionId];
            
            if (relatedJAs.size() > 0){
                Set<Id> candidateIds = new Set<Id>();
                for(Job_Application__c ja : relatedJAs){
                    candidateIds.add(ja.Candidate__c);
                }
                relatedCandidates = [SELECT Name, Phone__c, Email__c, Location__c, Ready_to_Relocate__c, CV_Link__c, Avatar_image__c,
                                    (SELECT Name, Candidate__c, Status__c, Cover_Letter__c, Number_of_Reviews__c, Average_Rating__c 
                                        FROM Job_Applications__r WHERE Position__c = :positionId)
                                    FROM Candidate__c WHERE Id IN :candidateIds WITH SECURITY_ENFORCED];
            }

            return relatedCandidates;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true)
    public static List<Candidate__c> getRelatedCandidatesWithJAsByQuery(String positionId, List<String> candidateQueryData, List<String> jobApplicationQueryData){
        try {
            List<Job_Application__c> relatedJAs = [SELECT Candidate__c FROM Job_Application__c WHERE Position__c = :positionId];

            System.debug(candidateQueryData);
            System.debug(jobApplicationQueryData);

            String candidateQuery = String.join(candidateQueryData, ', ');
            String jobApplicationQuery = String.join(jobApplicationQueryData, ', ');

            System.debug(candidateQuery);
            System.debug(jobApplicationQuery);


            String fullQuery = String.format('SELECT Name, Avatar_Image__c, {0}, (SELECT Name, Candidate__c, ' +
                                '{1} FROM Job_Applications__r WHERE Position__c = :positionId) ' +
                                'FROM Candidate__c WHERE Id IN :candidateIds', new List<String>{candidateQuery, jobApplicationQuery});

            System.debug(fullQuery);
            
            if (relatedJAs.size() > 0){
                Set<Id> candidateIds = new Set<Id>();
                for(Job_Application__c ja : relatedJAs){
                    candidateIds.add(ja.Candidate__c);
                }
                relatedCandidates = Database.query(fullQuery);
                System.debug(relatedCandidates);
            }

            return relatedCandidates;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
