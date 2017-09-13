@isTest
public class TestMRCPermissionHandlerDFW{
@testSetup
  static void setupTestData(){
    List<String> funAccMasterFields=new List<String>();
    funAccMasterFields.add('Module_Name__c');
    funAccMasterFields.add('Permission_Sets__c');
    List<Functionality_Access_Master__c> funAccessMasterList=DataFactoryServices.createRecords('Functionality_Access_Master__c',funAccMasterFields,'Function Access Manager',1);
    List<PermissionSet> psList=new List<PermissionSet>();
    psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet WHERE IsOwnedByProfile =false limit 1];
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
    
    Profile pp=[Select id,name from profile where Name = 'System Administrator' limit 1];
    personaList[0].ProfileId__c=pp.id;
    personaList[0].Profiles__c=pp.name;
    insert personaList;
    
    Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];        
    User usr = new User(
            Username = 'john@acme.com'+System.now().millisecond(),
            ProfileId = p.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey='UTF-8'        
       );
       Insert usr;
  }
  
  static testmethod void testMRCPermissionHandler()
    {
       List<user> usr=[select id,name,profileid,Persona_Assigned__c from user];
       List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT id,Module_Name__c,Permission_Sets__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
       List<market__c> marketList=[select id,Market__c,Market_Code__c from market__c];
       List<Persona__c> personaList=[select id,Functionality_Access__c,Market_Access__c,PersonaName__c,Functionality_Access__r.PermissionSet_Ids__c from persona__c];
       MRC_PermissionHandler mph=new MRC_PermissionHandler();
       usr[0].Persona_Assigned__c=personaList[0].PersonaName__c;
       try{update usr[0];}
       catch(exception e){}
       test.startTest();
       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       System.runAs (thisUser) {
           mph.assignMarketBasedPermisionSetsToUsers(usr);
           mph.revokePermissions(personaList[0]);
        }   
       test.stopTest();       
    }
}