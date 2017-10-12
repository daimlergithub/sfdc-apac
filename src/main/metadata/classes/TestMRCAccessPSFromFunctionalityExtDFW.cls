@isTest
private class TestMRCAccessPSFromFunctionalityExtDFW{
  @testSetup
  static void setupTestData(){
    List<String> funAccMasterFields=new List<String>();
    funAccMasterFields.add('Module_Name__c');
    funAccMasterFields.add('Permission_Sets__c');
    List<Functionality_Access_Master__c> funAccessMasterList=DataFactoryServices.createRecords('Functionality_Access_Master__c',funAccMasterFields,'Function Access Manager',1);
    List<PermissionSet> psList=new List<PermissionSet>();
    psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet WHERE IsOwnedByProfile =false limit 10];
        if(psList.size()>0) 
        {
          for(PermissionSet ps: psList)
         {
             funAccessMasterList[0].PermissionSet_Ids__c=ps.id;
             funAccessMasterList[0].Permission_Sets__c=ps.Label;
         }  
        }
    insert funAccessMasterList;
  }
  static testMethod void testdisplayPSMapUseCase1(){
    Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
    User usr111 = new User(Username = 'john@acme.com566'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
    Insert usr111;
    System.runAs (usr111) {  
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Id,Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    test.starttest();
    System.assertEquals(true,functionality_access_master_Obj.size()>0);    
    MRC_AccessPSFromFunctionalityExt obj01 = new MRC_AccessPSFromFunctionalityExt(new ApexPages.StandardController(functionality_access_master_Obj[0]));
        obj01.func = functionality_access_master_Obj[0];
        obj01.PermSIDList = new List<String>();
        obj01.PermSMap = new Map<String, String>();
        obj01.PSpresent = false;
        obj01.displayPSMap();
    test.stoptest();
    }    
  }
}