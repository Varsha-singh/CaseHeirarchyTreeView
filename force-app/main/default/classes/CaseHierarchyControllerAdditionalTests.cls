@isTest
public class CaseHierarchyControllerAdditionalTests {

    @isTest
    static void testComplexHierarchyRetrieval() {
        TestSetUp.createComplexCaseHierarchy();
        Case topCase = [SELECT Id FROM Case WHERE ParentId = NULL LIMIT 1];

        Test.startTest();
        List<CaseWithChildCases> results = CaseHierarchyController.getAllParentCasesWithChildCases(topCase.Id);
        Test.stopTest();

        System.assertNotEquals(null, topCase, 'Top case should not be null.');
        System.assertNotEquals(null, results, 'The result should not be null.');
        System.assertEquals(7, results.size(), 'There should be one top-level parent case.');
        System.assertEquals(3, results[0].childCases.size(), 'There should be three direct children.');
   
    }
}