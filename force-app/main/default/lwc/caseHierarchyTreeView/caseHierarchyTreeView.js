import { LightningElement, api, wire ,track} from 'lwc';
import getCaseDetails from '@salesforce/apex/CaseHierarchyController.getAllParentCasesWithChildCases';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    {
        label: 'Case Number',
        fieldName: 'caseUrl', 
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'caseNumber' }
        }
    },
    { label: 'Origin', fieldName: 'origin' },
    { label: 'Subject', fieldName: 'subject' }
];

export default class CaseHierarchy extends NavigationMixin(LightningElement) {
    @api recordId; // API property to pass the record ID to the component
    caseData = [];
    columns = columns;
    processing = true;

    
    @wire(getCaseDetails, { parentId: '$recordId' })
    wiredCases({ data, error }) {
        if (data) {
            let caseHierarchy = {};
            let rootCases = [];
            for (let caseRec of data) {
                if (caseRec.parentId) {
                    if (caseHierarchy[caseRec.parentId]) {
                        caseHierarchy[caseRec.parentId].push(caseRec);
                    } else {
                        caseHierarchy[caseRec.parentId] = [caseRec];
                    }
                } else {
                    rootCases.push(caseRec);
                }
            }
            this.caseData = this.buildCaseTreeData(rootCases, caseHierarchy);
            this.processing = false;

        } else if (error) {
            this.caseData = [];
            this.processing = false;
            console.error(error);
        }
    }

    buildCaseTreeData(rootCases, caseHierarchy) {
        let caseTreeData = [];
        for (let caseObj of rootCases) {
            let caseNode = {
                "id": caseObj.caseId, // Make sure this matches the JSON structure
                "origin": caseObj.origin,
                "subject": caseObj.subject,
                "caseNumber": caseObj.caseNumber,
                "caseUrl": window.location.origin + '/' + caseObj.caseId,
                "_children": this.buildChildren(caseObj.caseId, caseHierarchy) // Build children recursively
            };
            caseTreeData.push(caseNode);
        }
        return caseTreeData;
    }

    buildChildren(caseId, caseHierarchy) {
        if (caseHierarchy[caseId]) {
            return this.buildCaseTreeData(caseHierarchy[caseId], caseHierarchy);
        }
        return []; // No children found, return empty array
    }

    clickToExpandAll(e) {
        const grid =  this.template.querySelector('lightning-tree-grid');
        grid.expandAll();
    }

    clickToCollapseAll(e) {
        const grid =  this.template.querySelector('lightning-tree-grid');
        grid.collapseAll();
    }
}