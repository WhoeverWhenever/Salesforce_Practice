@isTest
private with sharing class PositionControllerTest {
    public static testMethod void testPositionController() {
        PageReference pageRef = Page.Positions;
        Test.setCurrentPage(pageRef);

        List<Position__c> testPositions = new List<Position__c>();
        testPositions.add(new Position__c(Name = 'Test Position 1', Status__c = 'Open',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 2', Status__c = 'Open',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 3', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 4', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 5', Status__c = 'Closed',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 6', Status__c = 'Closed Canceled',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 7', Status__c = 'Open Hot',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        testPositions.add(new Position__c(Name = 'Test Position 8', Status__c = 'Closed Canceled',
                                          Description__c = 'Some Description', Skills__c = 'JS',
                                          Location__c = 'Filler'));
        insert testPositions;

        PositionController controller = new PositionController();

        List<SelectOption> filterOptions = controller.getFilterOptions();
        System.assertEquals(5, filterOptions.size());

        controller.selectedFilterOption = 'None';
        List<Position__c> renderedPositions = controller.getPositions();
        System.assertEquals(8, renderedPositions.size());

        controller.selectedFilterOption = '';
        renderedPositions = controller.getPositions();
        System.assertEquals(8, renderedPositions.size());

        controller.selectedFilterOption = 'Open';
        renderedPositions = controller.getPositions();
        System.assertEquals(2, renderedPositions.size());

        controller.selectedFilterOption = 'Open Hot';
        renderedPositions = controller.getPositions();
        System.assertEquals(1, renderedPositions.size());

        controller.selectedFilterOption = 'Closed';
        renderedPositions = controller.getPositions();
        System.assertEquals(3, renderedPositions.size());

        controller.selectedFilterOption = 'Closed Canceled';
        renderedPositions = controller.getPositions();
        System.assertEquals(2, renderedPositions.size());

        renderedPositions.get(0).Status__c = 'Open Hot';
        controller.save();
        renderedPositions = controller.getPositions();
        System.assertEquals(1, renderedPositions.size());

    }
}