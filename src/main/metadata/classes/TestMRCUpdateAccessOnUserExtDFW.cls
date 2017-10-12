@isTest
private class TestMRCUpdateAccessOnUserExtDFW{

  @testSetup
  static void setupTestData(){
    test.startTest();
    List<String> funAccMasterFields=new List<String>();
    funAccMasterFields.add('Module_Name__c');
    funAccMasterFields.add('Permission_Sets__c');
    List<Functionality_Access_Master__c> funAccessMasterList=DataFactoryServices.createRecords('Functionality_Access_Master__c',funAccMasterFields,'Function Access Manager',1);
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
                        Persona_Assigned__c=personaList[0].PersonaName__c           
       );
     Insert usr;
      
    test.stopTest();
  }
  static testMethod void testUpdateUser(){
    Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
    User usr111 = new User(Username = 'john@acme.com142'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
    Insert usr111;
    System.runAs (usr111) {   
    test.startTest();  
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
        MRC_UpdateAccessOnUserExt obj01 = new MRC_UpdateAccessOnUserExt(new ApexPages.StandardController(functionality_access_master_Obj[0]));
        obj01.func = functionality_access_master_Obj[0];
        obj01.UListToUpdate = new List<User>();
        obj01.updateUser(new List<User>());
    test.stopTest();  
    }    
  }
  static testMethod void testRedirect(){
     Profile p=[Select id,name from profile where Name = 'System Administrator' limit 1];
     User usr111 = new User(Username = 'john@acme.com114'+System.now().millisecond(),Market__c='MY',ProfileId = p.Id,Alias = 'test123',Email = 'test12345@test.com',LastName = 'McTesty',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',LanguageLocaleKey = 'en_US',EmailEncodingKey='UTF-8');
     Insert usr111;
     System.runAs (usr111) {  
     test.startTest();
     List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c from Functionality_Access_Master__c];
     System.assertEquals(true,functionality_access_master_Obj.size()>0);
        MRC_UpdateAccessOnUserExt obj01 = new MRC_UpdateAccessOnUserExt(new ApexPages.StandardController(functionality_access_master_Obj[0]));
        obj01.func = functionality_access_master_Obj[0];
        obj01.UListToUpdate = new List<User>();
        obj01.redirect();
       test.stopTest();
     }   
  }
  
}