/**
** This class will increase coverage DeleteRetailCopy
** Created By: Kiran P 
** Date: 15-12-2016
** Release : JP-3.0
** Modified By : 
** Modified date :
**/
@isTest
public class DeleteRetailCopyTest{
    public static testMethod void deleteRetailCopy_MT(){
        Account_Link__c alklink = new Account_Link__c (Name = 'testName');
        insert alklink;
        ApexPages.currentPage().getParameters().put('id',alklink.id);
        DeleteRetailCopy obj = new DeleteRetailCopy();
        obj.updateRetailCopy();
        
    }
}