@RestResource(urlMapping='/api/JobApplication/*')
global with sharing class JobApplicationREST {
    @HttpGet
    global static Job_Application__c getJobApplicationDetails() {
        RestRequest request = RestContext.request;
        String jobApplicationId = request.requestURI.substring(
                                  request.requestURI.lastIndexOf('/')+1);

        Job_Application__c result =  [SELECT Name,Candidate__r.Name, Position__r.Name,
                                             Status__c, Link_to_Application__c, 
                                             Cover_Letter__c, Number_of_Reviews__c, Average_Rating__c 
                                      FROM Job_Application__c
                                      WHERE Id = :jobApplicationId];

        return result;
    }

    @HttpPost
    global static String createJobApplication(){
        RestRequest request = RestContext.request;
        Map<String,Object> jsonJobApplication = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
        Job_Application__c jobApplication = new Job_Application__c();
        
        for(String fieldName : jsonJobApplication.keySet()) {
            jobApplication.put(fieldName, jsonJobApplication.get(fieldName));
        }

        insert jobApplication;

        return getResultString('id', jobApplication.Id, 'created');
    }

    @HttpPatch
    global static String updateJobApplication(){
        RestRequest request = RestContext.request;
        String jobApplicationId = request.requestURI.substring(
                                  request.requestURI.lastIndexOf('/')+1);

        Map<String,Object> jsonJobApplication = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
        Job_Application__c jobApplication = [SELECT Id FROM Job_Application__c WHERE Id = :jobApplicationId];
        
        for(String fieldName : jsonJobApplication.keySet()) {
            jobApplication.put(fieldName, jsonJobApplication.get(fieldName));
        }

        update jobApplication;

        return getResultString('id', jobApplication.Id, 'updated');
    }

    @HttpDelete
    global static String deleteJobApplication() {
        RestRequest request = RestContext.request;

        String jobApplicationName = request.requestURI.substring(
                                    request.requestURI.lastIndexOf('/')+1);

        Job_Application__c jobApplication =  [SELECT Id FROM Job_Application__c WHERE Id = :jobApplicationName];

        delete jobApplication;

        return getResultString('id', jobApplication.Id, 'deleted');
    }

    private static String getResultString(String itemName, String item, String operation){
        String template = 'Job Application with the {0} \'{\'{1}\'}\' was successfully {2}';
        List<Object> parameters = new List<Object> {itemName, item, operation};
        String formatted = String.format(template, parameters);

        return formatted;
    }
}