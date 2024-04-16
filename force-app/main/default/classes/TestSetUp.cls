@iSTest
public class TestSetUp {
    
    @testsetup
    public static void createComplexCaseHierarchy() {

        /** Create Parent Case */
        Case topCase = new Case(Subject = 'Top Case', Origin = 'Email');
        insert topCase;
        
        /** Create Child Case of Above Case */
        Case childCase1 = new Case(ParentId = topCase.Id, Subject = 'Child Case 1', Origin = 'Web');
        Case childCase2 = new Case(ParentId = topCase.Id, Subject = 'Child Case 2', Origin = 'Phone');
        Case childCase3 = new Case(ParentId = topCase.Id, Subject = 'Child Case 3', Origin = 'Phone');
        insert new List<Case>{childCase1, childCase2, childCase3};
            
        /** Create Grand Child Case to maintain the heirarchy */
        Case grandChildCase1 = new Case(ParentId = childCase1.Id, Subject = 'Grandchild Case 1', Origin = 'Web');
        Case grandChildCase2 = new Case(ParentId = childCase2.Id, Subject = 'Grandchild Case 2', Origin = 'Email');
        insert new List<Case>{grandChildCase1, grandChildCase2};
        
        /** Create Great Grand Child Case to maintain the heirarchy */
        Case greatGrandChildCase1 = new Case(ParentId = grandChildCase1.Id, Subject = 'Great-Grandchild Case 1', Origin = 'Web');
        insert greatGrandChildCase1;
 
    }
    
}