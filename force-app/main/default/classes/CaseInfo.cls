/**
 * @description This class is used to efficiently pass case details between Lightning components and Apex controllers,
 * enabling the display and manipulation of case data on the client side.
 *
 * The CaseInfo class includes properties that are annotated with @AuraEnabled to ensure
 * they are accessible within Salesforce Lightning components. The class constructor is designed to 
 * initialize the instance with the essential fields of a Case record.
 */
public class CaseInfo {
    /*Salesforce ID of the case.*/
    @AuraEnabled public Id caseId;
    /* The official number of the case.*/
    @AuraEnabled public String caseNumber;
    /*The subject  of the case.*/
    @AuraEnabled public String subject;
    /* The origin of the case, describing how the case was created. */
    @AuraEnabled public String origin;
    
    /** 
     * Constructor:
     * CaseInfo(Id caseId, String caseNumber, String subject, String origin)
     * This constructor initializes a new instance of the CaseInfo class with specified case details.
     **/

    public CaseInfo(Id caseId, String caseNumber, String subject, String origin) {
        this.caseId = caseId;
        this.caseNumber = caseNumber;
        this.subject = subject;
        this.origin = origin;
    }
}