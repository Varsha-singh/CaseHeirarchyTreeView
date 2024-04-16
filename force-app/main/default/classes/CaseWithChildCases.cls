/**
 * @description Represents a structured data model for a Case record along with its child cases.
 * This class is used to encapsulate the details of a case and its associated child cases,
 * This class includes properties marked with @AuraEnabled to make them accessible
 * from Lightning components. It provides a constructor to initialize all the fields required
 * to fully describe a case and its hierarchy.
 */
public class CaseWithChildCases {
/*Salesforce ID of the case.*/
@AuraEnabled public Id caseId;
/* The official number of the case.*/
@AuraEnabled public String caseNumber;
/* Salesforce ID of the parent case. Null if this is the top-level case. */
@AuraEnabled public String parentId;
/* A list of CaseInfo objects representing the child cases. */
@AuraEnabled public List<CaseInfo> childCases;
/*The subject  of the case.*/
@AuraEnabled public String subject;
/* The origin of the case, describing how the case was created. */
@AuraEnabled public String origin;
/** 
* Constructor:
*  CaseWithChildCases(Id caseId, String caseNumber, String parentId, List<CaseInfo> childCases, String subject, String origin)
*  Initializes a new instance of the CaseWithChildCases class with specified details.
**/
public CaseWithChildCases(Id caseId, String caseNumber, String  parentId, List<CaseInfo> childCases, String subject, String origin) {
    this.caseId = caseId;
    this.caseNumber = caseNumber;
    this.parentId = parentId;
    this.childCases = childCases;
    this.subject = subject;
    this.origin = origin;
}
}