@isTest
public class TestMRCMAJNewEditExtDFW{
@testSetup
  static void setupTestData(){
    List<String> funAccMasterFields=new List<String>();
    funAccMasterFields.add('Module_Name__c');
    funAccMasterFields.add('Permission_Sets__c');
    List<Functionality_Access_Master__c> funAccessMasterList=DataFactoryServices.createRecords('Functionality_Access_Master__c',funAccMasterFields,'Function Access Manager',1);
    List<PermissionSet> psList=new List<PermissionSet>();
        psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet limit 1];
        if(psList.size()>0) 
        {
          for(PermissionSet ps: psList)
         {
             funAccessMasterList[0].PermissionSet_Ids__c=ps.id;
             funAccessMasterList[0].Permission_Sets__c=ps.Label;
         }  
        }
    insert funAccessMasterList;
    
    List<String> marketFields=new List<String>();
    marketFields.add('Market__c');
    marketFields.add('Market_Code__c');
    List<Market__c> marketList = DataFactoryServices.createRecords('Market__c',marketFields,'MY',1);
    insert marketList;
        
    List<String> personaFields=new List<String>();
    personaFields.add('Functionality_Access__c');
    personaFields.add('Market_Access__c');
    personaFields.add('PersonaName__c');    
    list<Persona__c> personaList=DataFactoryServices.createRecords('Persona__c',personaFields,'Persona',1);
    
    DataFactoryServices.createRelationships(personaList,funAccessMasterList,'Functionality_Access__c');
    DataFactoryServices.createRelationships(personaList,marketList,'Market_Access__c');     
    
    Profile p=[Select id,name from profile limit 1];
        if(p!=null)
        {
            personaList[0].ProfileId__c=p.id;
            personaList[0].Profiles__c=p.name;
        }
    insert personaList;    
  }
  
  static testmethod void testMRCMAJNewEditExt()
    {   
        Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
        User usr111 = new User(Username = 'john@acme.com1'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
        Insert usr111;
        System.runAs (usr111) { 
        List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c from Functionality_Access_Master__c];
        List<Market__c> marketList=[select id,Market__c,Market_code__c from market__c];
        List<Persona__c> personaList=[select id,Functionality_Access__c,Market_Access__c,PersonaName__c,Profiles__c from persona__c];
        
        ApexPages.currentPage().getParameters().put('id',personaList[0].id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(personaList[0]);
        MRC_MAJNewEditExt majExt= new MRC_MAJNewEditExt(objSc);
        majExt.selectedProfile=personaList[0].Profiles__c;
        
        test.startTest();
        majExt.saveRecord();
        majExt.revokeAccess();
        System.assertEquals(true,majExt.selectedProfile !=null ); 
        test.stopTest();
        }
    }
}