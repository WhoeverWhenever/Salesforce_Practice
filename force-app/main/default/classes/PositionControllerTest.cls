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

        User stdEmployee = TestFactory.getUser('employeeUser', 'Standard Employee');
        System.runAs(stdEmployee){
            controller.selectedFilterOption = 'None';
            List<Position__c> newRenderedPositions = controller.getPositions();
            System.assertEquals(null, newRenderedPositions[0].Min_Pay__c);
            System.assertEquals(null, newRenderedPositions[0].Max_Pay__c);
        }

        User noAccessUser = TestFactory.getUser('noAccessUser', 'Minimum Access - API Only Integrations');
        System.runAs(noAccessUser){
            List<Position__c> testRenderedPositions = controller.getPositions();
            System.assertEquals(1, ApexPages.getMessages().size());
        }
    }
}
