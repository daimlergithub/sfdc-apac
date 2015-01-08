/*
    Type:       Social Media Account Controller
    Purpose:    Test Class
    User Story: -

    Used By:    (Page)SocialAccountPage
    ---------------------------------------------------------------
    History:

    17-June-2013 Stephano.shi (Breakingpoint)    Created
*/
@isTest(SeeAllData=true)
public class SocialAccountController_TestClass{
    static testmethod void runSocialAccountController(){
        
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();     // Person Account.       
        
        // Person Account/Contact 
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City_CN__c='宝山区',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='12345678123',
                                      RecordTypeId=accPerson_RecordTypeId
                                     );
        insert(testPerAcc);
      
        // Social Media Account
        Social_Media_Account__c testSma = new Social_Media_Account__c(Name='Stephano Test', Account__c=testPerAcc.Id, Type__c='WeChat');
        insert(testSma);   
          
    	ApexPages.currentPage().getParameters().put('phone', '12345678123');
        ApexPages.currentPage().getParameters().put('name', 'Stephano');
        ApexPages.currentPage().getParameters().put('smId', 'Stephano Test');
        ApexPages.currentPage().getParameters().put('type', 'WeiChat');
        socialAccountController sac = new socialAccountController();
        sac.getAccounts();
        sac.accountList[0].selected=true;        
    	sac.getSelected();
        sac.getSeletedAccounts();
        sac.getAccountList();
        sac.linksUp();
        sac.srchAccounts();
        
    }
}