@isTest

public with sharing class SharingDataHandlerBaseTest {

public static testMethod void testSharingDataHandlerBase() 
{     
     List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
  insert updatecustomsettings;
    
    User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    System.runAs(thisUser){

        String AccessLevel = 'Read';
        String  originalTypeName='Account';
            
        User usr = UtilTestData.createUser('Dealer User', 'System Administrator');
        User usr2 = UtilTestData.createUser('Dealer User', 'System Administrator');
        CMap parentIds = new CMap();
        parentIds.add('usr1', usr.Id);
            
        CMap userOrGroupIds = new CMap();
        userOrGroupIds.add('usr1', usr2.Id);
            
        Group theGroup = [select id from Group Limit 1];
        
        List<sObject> scope=new list<sObject>();
        List<sObject> crmCodeList=new list<sObject>();
        Test.startTest();
        SharingDataHandlerBase sh=new SharingDataHandlerBase(originalTypeName,AccessLevel);
        sh.filterDealer(scope);
        sh.executeProcessByCRMCode(crmCodeList);
        sh.makeInserRecords(parentIds,userOrGroupIds);
        sh.createShareObject(usr.Id,usr.Id);
        Test.stopTest();
       system.assertNotEquals(null, sh);
    }
}
}