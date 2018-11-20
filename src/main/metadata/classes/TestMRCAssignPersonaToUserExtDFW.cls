@isTest
public class TestMRCAssignPersonaToUserExtDFW{
     /* @testSetup
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
        system.debug('PersonaList'+personaList);
        Insert personaList;
        
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
            EmailEncodingKey='UTF-8',
            Market__c='MY',
            Persona_Assigned__c='Persona1'
       );
       Insert usr;
     }     
    static testmethod void testMRCAssignPersonaToUser()
    {  Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
       User usr111 = new User(Username = 'john@acme.com565'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
       Insert usr111;
       System.runAs (usr111) { 
       user usr=[select id,name,profileid,Persona_Assigned__c from user where Market__c='MY' and Persona_Assigned__c='Persona1' LIMIT 1];
       List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c from Functionality_Access_Master__c];
       list<Persona__c> personaFinalList=[select id,PersonaName__c,Functionality_Access__c,Market_Access__c from persona__c where PersonaName__c='Persona1'];
       //User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];       
       test.starttest();
       ApexPages.currentPage().getParameters().put('id',usr.id);
       ApexPages.StandardController objSc = new ApexPages.StandardController(usr);
       MRC_AssignPersonaToUserExt MAPext= new MRC_AssignPersonaToUserExt(objSc);
       MAPext.selMajID=personaFinalList[0].id;
       MAPext.isPersona=personaFinalList[0].id;    
       try{
            MAPext.cancel();
            MAPext.getPersonas();
            MAPext.selectPersona();             
          }
           catch(Exception e){}
       
       system.assertEquals('Persona1',usr.Persona_Assigned__c);
       test.stoptest();    
       }     
     }  */
}