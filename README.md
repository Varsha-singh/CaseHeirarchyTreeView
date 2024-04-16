CaseHierarchyController

Overview
The CaseHierarchyController class is designed to interact with Salesforce Case objects to retrieve and organize cases into hierarchical relationships. This Apex class is particularly useful for Salesforce Lightning components where there is a need to display parent cases and their associated child cases efficiently.

Features
Retrieve Hierarchical Case Data: Fetches parent cases along with their child cases as a structured list.

AuraEnabled Method: Exposes the main method for use in Lightning components, supporting efficient client-side caching.

Usage
The class is used within Salesforce Lightning components to display a case hierarchy based on a specified parent case ID. It provides a seamless integration point for developers to fetch and display case data in a hierarchical structure without additional processing on the client side.

Methods
@AuraEnabled(cacheable=true)
public static List<CaseWithChildCases> getAllParentCasesWithChildCases(String parentId)

Description: Retrieves a list of CaseWithChildCases objects, each representing a parent case and its related child cases. The method uses a recursive strategy to gather all child cases associated with the given parent case ID.

Parameters:
String parentId: The Salesforce ID of the parent case.
Returns: A list of CaseWithChildCases objects, where each object includes comprehensive details about the case and its children.
