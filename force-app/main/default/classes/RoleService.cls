public with sharing class RoleService {
    @AuraEnabled(cacheable=true)
    public static List<CaseWithChildCases> getAllRolesWithAssignedUsers(String parentId) {
        // Query for the parent role
        Case parentCase = [SELECT Id, CaseNumber,Subject,Origin FROM Case WHERE Id = :parentId];
        // Map to store the user information for each role
        Map<Id, List<Case>> caseChild = new Map<Id, List<Case>>();
        caseChild.put(parentCase.Id, new List<Case>());
        // Recursively traverse the hierarchy to get all child roles
        getChildRoles(parentCase.Id, caseChild);
        Map<Id,Case> allCaseMap =new Map<Id,Case> ([SELECT Id, CaseNumber,Subject,Origin, ParentId, (SELECT Id, CaseNumber,Subject,Origin FROM Cases ) FROM Case WHERE Id IN: caseChild.keySet()]);
        
        List<CaseWithChildCases> caseChildCases = new List<CaseWithChildCases>();
        String currentParenId='';
        for (Id caseId : caseChild.keySet()) { 
            currentParenId='';
            Case cases = allCaseMap.get(caseId);
            List<Case> casesList = allCaseMap.get(caseId).Cases;
            List<CaseInfo> caseInfos = new List<CaseInfo>();
            for (Case caseRec : casesList) {
                CaseInfo caseInfo = new CaseInfo(caseRec.Id, caseRec.CaseNumber,caseRec.Subject,caseRec.Origin);
                caseInfos.add(caseInfo);
            }
            if(cases.Id!=parentId)
            {
                currentParenId=cases.ParentId;
            }
            CaseWithChildCases caseWithChild = new CaseWithChildCases(caseId, cases.CaseNumber,currentParenId, caseInfos,cases.Subject,cases.Origin);
            caseChildCases.add(caseWithChild);

        }
                    system.debug('caseChildCases'+caseChildCases);
        return caseChildCases;
    }
    
    private static void getChildRoles(Id caseId, Map<Id, List<Case>> casesMap) {
        List<Case> allCases = [SELECT Id, CaseNumber, ParentId FROM Case WHERE ParentId = :caseId];
        for (Case cases : allCases) {
            List<Case> childCasesList = new List<Case>();
            childCasesList.add(cases);
            casesMap.put(cases.Id, childCasesList);
            getChildRoles(cases.Id, casesMap);
        }
    }    
    
    
}