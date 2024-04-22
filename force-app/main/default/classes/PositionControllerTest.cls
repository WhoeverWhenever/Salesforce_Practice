@isTest
public with sharing class PositionControllerTest {
    public static testMethod void testPositionController() {
        PageReference pageRef = Page.Positions;
        Test.setCurrentPage(pageRef);

        List<Position__c> testPositions = PositionControllerTestFactory.getTestPositions();
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

        controller.selectedFilterOption = 'Closed Cancelled';
        renderedPositions = controller.getPositions();
        System.assertEquals(2, renderedPositions.size());

        renderedPositions.get(0).Status__c = 'Open Hot';
        controller.save();
        renderedPositions = controller.getPositions();
        System.assertEquals(1, renderedPositions.size());
    }
}
