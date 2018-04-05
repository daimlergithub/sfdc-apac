@isTest
public class TestFunctionalityAccessExtDFW {
   
   @testSetup
   static void setupTestData(){
    List<String> funAccMasterFields=new List<String>();
    funAccMasterFields.add('Module_Name__c');
    funAccMasterFields.add('Permission_Sets__c');
    List<Functionality_Access_Master__c> funAccessMasterList=DataFactoryServices.createRecords('Functionality_Access_Master__c',funAccMasterFields,'Function Access Manager',1);
    List<PermissionSet> psList=new List<PermissionSet>();
    psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet limit 1];
    for(PermissionSet ps: psList)
             {
               funAccessMasterList[0].PermissionSet_Ids__c=ps.id;
             }
    insert funAccessMasterList;
   } 
    
  static testmethod void testAssignPermissionSetToFunctionalityAccessMaster()
    {
       Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
       User usr111 = new User(Username = 'johtestSystemn@acme.com1'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
       Insert usr111;
       System.runAs (usr111) { 
       test.starttest();      
       List<PermissionSet> psList=new List<PermissionSet>();
       psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet limit 1];
       List<SelectOption> selectedPermissionSets=new List<SelectOption>();
       if(psList.size()>0)
        {
           for(PermissionSet ps: psList)
             {
              selectedPermissionSets.add(new SelectOption(ps.id,ps.label));
             } 
        }
        List<Functionality_Access_Master__c> functionalityAaccessMasterObj  =  [SELECT Module_Name__c,PermissionSet_Ids__c,Permission_Sets__c from Functionality_Access_Master__c];
        ApexPages.currentPage().getParameters().put('id',functionalityAaccessMasterObj[0].id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(functionalityAaccessMasterObj[0]);
        FunctionalityAccessExt extFA= new FunctionalityAccessExt(objSc);
        extFA.selectedPermissionSets=selectedPermissionSets;
        extFA.saveRecord();
        System.assertEquals(true,functionalityAaccessMasterObj[0].Permission_Sets__c !=null ); 
        test.stoptest();
       }   
     }   
}