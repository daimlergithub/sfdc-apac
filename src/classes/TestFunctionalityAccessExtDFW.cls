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
     }   
}