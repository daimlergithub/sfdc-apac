@isTest
public class TestMRCListOfFeaturesExtDFW{
  @testSetup
  static void setupTestData(){
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
    insert personaList;
  
  }
  static testMethod void testGetItems(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getItems();
  }
  static testMethod void testGetfeatureTypes(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getfeatureTypes();
  }
  static testMethod void testGetFeatureList(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getFeatureList();
  }
  static testMethod void testSearchFeatures(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.searchFeatures();
  }
  static testMethod void testGetPageNumber(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getPageNumber();
    MRC_ListOfFeaturesExt.FeatureDetails obj241 = new MRC_ListOfFeaturesExt.FeatureDetails();
   
  }
  static testMethod void testGetTotalPages(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getTotalPages();
   
  }
  static testMethod void testFirstPage(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.FirstPage();
    
  }
  static testMethod void testPrevious(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.previous();
   
  }
  static testMethod void testGetPrev(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getprev();
    
  }
  static testMethod void testGetNxt(){
    List<Persona__c> market_access_junction_Obj  =  [SELECT Market_Access__c,Functionality_Access__c,Market__c,Functionality__c,Active__c,Profiles__c,ProfileId__c,PersonaName__c from Persona__c];
    System.assertEquals(true,market_access_junction_Obj.size()>0);
    List<Market__c> market_Obj  =  [SELECT Market__c,Market_Code__c from Market__c];
    System.assertEquals(true,market_Obj.size()>0);
    List<Functionality_Access_Master__c> functionality_access_master_Obj  =  [SELECT Module_Name__c,Permission_Sets__c,Description__c,PermissionSet_Ids__c from Functionality_Access_Master__c];
    System.assertEquals(true,functionality_access_master_Obj.size()>0);
    MRC_ListOfFeaturesExt obj01 = new MRC_ListOfFeaturesExt(new ApexPages.StandardController(market_access_junction_Obj[0]));
    obj01.PScheck = false;
    obj01.CPcheck = false;
    obj01.FeatureList = new List<MRC_ListOfFeaturesExt.FeatureDetails>();
    obj01.majList = market_access_junction_Obj;
    obj01.SMkt = 'test data';
    obj01.SProf = 'test data';
    obj01.SActive = 'test data';
    obj01.SPersona = 'test data';
    obj01.SFunctionality = 'test data';
    obj01.SFeatureType = 'test data';
    obj01.Flag3 = false;
    obj01.Flag4 = false;
    obj01.flag = false;
    obj01.check = false;
    obj01.query1 = 'test data';
    obj01.totalno = 10;
    obj01.OffsetSize = 10;
    obj01.LimitSize = 10;
    obj01.getnxt();
    obj01.LastPage();
    obj01.next();
    
  }
}