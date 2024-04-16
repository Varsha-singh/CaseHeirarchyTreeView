public with sharing class CaseHierarchyController {

/**
 * @description Retrieves a list of parent cases along with their child cases, formatted as a list of CaseWithChildCases objects.
 * Each parent case is identified using a unique parent ID, and child cases are collected recursively.
 *
 * This method first retrieves the parent case based on the provided parent ID. It then initializes a map
 * to store child case information, recursively populates this map, retrieves detailed information about all cases
 * involved, and finally constructs a list of CaseWithChildCases objects that encapsulate the case hierarchy.
 *
 * @param parentId The Salesforce ID of the parent case. This ID is used to locate the primary case from which
 *                 the child case hierarchy will be built.
 * @return List<CaseWithChildCases> A list of CaseWithChildCases objects, where each object includes details about
 *                                  a parent case and its associated child cases. The structure includes IDs, case numbers,
 *                                  subjects, origins, and child case details.
 */
@AuraEnabled(cacheable=true)
public static List<CaseWithChildCases> getAllParentCasesWithChildCases(String parentId) {
    try {
    
    if (parentId == null) {
        throw new AuraHandledException('No case id found with the provided ID.');
    }

    Map<Id, List<Case>> caseChild = new Map<Id, List<Case>>(); // Map to store the child case information for each case
    caseChild.put(parentId, new List<Case>()); // Recursively traverse the hierarchy to get all child cases
    
    getChildCases(parentId, caseChild);
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

    return caseChildCases;
   } catch (Exception e) {
        throw new AuraHandledException('Error retrieving cases: ' + e.getMessage());
   } 
}

private static void getChildCases(Id caseId, Map<Id, List<Case>> casesMap) {
    List<Case> allCases = [SELECT Id, CaseNumber, ParentId FROM Case WHERE ParentId = :caseId];
    for (Case cases : allCases) {
        List<Case> childCasesList = new List<Case>();
        childCasesList.add(cases);
        casesMap.put(cases.Id, childCasesList);
        getChildCases(cases.Id, casesMap);
    }
}    
}