/**
Type:       Test class for GetDependentPicklistValues    
Purpose:    1. Code coverage for GetDependentPicklistValues class

User Story: RCP-141
Used By:    
---------------------------------------------------------------
History:

28-Sep-2018 Surendranath  Created
*/
@isTest
public class GetDependentPicklistValues_Test {
    
    @isTest
    public static void Test_Case(){        
        GetDependentPicklistValues.getDependentPicklistValues('News__c.Approver_List__c');        
    }
}