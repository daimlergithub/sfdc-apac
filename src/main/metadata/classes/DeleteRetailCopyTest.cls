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
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
        // Create dealer
        Account dealer = new Account(Name = 'Shanghai test',
                                     Province__c = 'Shanghai',
                                     City__c = 'Xuhui district,',
                                     Dealer_Sales_Type__c = 'Smart',
                                     MBK_Data_Source__c = 'Email',
                                     Dealer_Service_Codes__c = 'Sales;Parts');
        dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);
        Account_Link__c alklink = new Account_Link__c (Name = 'testName' , toRole__c  = dealer.Id ,RecordTypeId = RetailPerson );
        insert alklink;
        set<Id> dealerId = new set<Id>();
        dealerId.add(dealer.Id);
        ApexPages.currentPage().getParameters().put('id',alklink.id);
        DeleteRetailCopy obj = new DeleteRetailCopy();
        DeleteRetailCopy.updateRetailCopy();
       
    }
}