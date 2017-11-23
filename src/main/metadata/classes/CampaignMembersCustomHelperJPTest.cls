@istest
public class CampaignMembersCustomHelperJPTest
{
 public static Account accobj;
  public static Contact contobj;
  public static Campaign camobj;
  public static Retail_Campaign__c campobj;
  public static Retail_Campaign__c parentcampobj;
  public static Campaign_Member__c cm;
   public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];
  public static List<Participating_Dealer__c> padealerlist;
  public static Id DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  public static Id RetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  public static Id parentRetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
  public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
  static void createTestData() {  
 
      List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
    accobj = new Account();
    accobj.FirstName = 'testaccount';
    accobj.lastName = 'testaccount';
    accobj.Email__c = 'Test@test.com';
    accobj.RecordTypeId = personAccRecordTypeId;
    //accobj.Name = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    insert accobj;
    system.debug('$$$$$$$$$$$$'+accobj);
    system.debug('$$$$$$$$$$$$'+accobj.id);
    
    parentcampobj = new Retail_Campaign__c();
    parentcampobj.RecordTypeId = parentRetailcentmarcampRecordTypeId;
    parentcampobj.Name = 'parentcamptest1';
    parentcampobj.MD__c = 'JP';
    insert parentcampobj;
    campobj= new Retail_Campaign__c();
    campobj.RecordTypeId = RetailcentmarcampRecordTypeId;
    campobj.Name = 'camptest1';
    campobj.Parent_Campaign1__c = parentcampobj.id;
    campobj.MD__C = 'JP';
    //campobj.Type = 'Other';
    //campobj.Status = 'Planned';
    //campobj.StartDate = System.today();
    //campobj.EndDate = System.today();
    //campobj.Campaign_Objectives__c = 'camobjectives';
    //campobj.Description = 'testdescrip';
    
    insert campobj;
    cm=new Campaign_Member__c();
    cm.Retail_Campaign_Id__c=campobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
  }
    
  public static testMethod void updateContactTest() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm);
    cm.Response_FirstName__c ='testaccount';
    cm.Response_LastName__c = 'testaccount';
    cm.Response_Email__c = 'Test@test.com';
   cm.Status__c = 'Responded';
   update cm;
 newMap.put(cm.Id , cm);
 newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
  public static testMethod void updateContactTest1() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm);   
      cm.Retail_Campaign_Id__c = campobj.Id;
       cm.Status__c = 'Responded';
       update cm;
     newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
  public static testMethod void updateContactTest2() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm); 
   cm.Response_FirstName__c ='testaccount1t';
    cm.Response_LastName__c = 'testaccount1s';
    cm.Response_Email__c = 'Testtre@test.com';
    update cm;
   newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
    public static testMethod void updateContactTest3() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm); 
   cm.Response_FirstName__c ='testaccount1t';
    cm.Response_LastName__c = 'testaccount1s';
    cm.Response_Email__c = 'Testtre@test.com';
    update cm;
   newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
      public static testMethod void updateContactTest4() {
    createTestData();
      Map<Id, Campaign_Member__c> oldMap = new Map<Id, Campaign_Member__c> ();
    Map<Id, Campaign_Member__c> newMap = new Map<Id, Campaign_Member__c> ();
   List<Campaign_Member__c> newList = new List<Campaign_Member__c> ();
   oldMap.put(cm.Id , cm); 
   cm.Response_FirstName__c ='testaccount1t';
    cm.Response_LastName__c = 'testaccount1s';
    cm.Response_Email__c = 'Testtre@test.com';
    update cm;
   newMap.put(cm.Id , cm);
     newList.add(cm);
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.afterUpdateOperation(oldMap,newMap,newList); 
      CampaignMembersCustomHelperJP.updateCampaignMemberStatusResponseCollection (newList);   
      CampaignMembersCustomHelperJP.afterUpdateCampaignMembers(newMap);
    test.stoptest();
   
  }
   public static testMethod void updateContactTestJP() {
    createTestData();
      
     
            
    Campaign camobj2 = new Campaign();
    camobj2.RecordTypeId = camIdPlan;
    camobj2.Name = 'camptest1';
    camobj2.Type = 'Other';
    camobj2.Status = 'Draft';
    camobj2.StartDate = System.today();
    camobj2.EndDate = System.today()+30;
    camobj2.Campaign_Objectives__c = 'camobjectives';
    camobj2.Description = 'testdescrip';
    camobj2.Campaign_Execution_Channels__c='eMail';
    camobj2.Add_Sales_Staff__c=true;
    insert camobj2;
    
    
    Campaign camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj2.id;
    camobj1.Child_Campaign_Status__c='Execution';
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today()+10;
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    camobj1.Add_Service_Staff__c=true;
    camobj1.Add_Campaign_Member_ID__c=true;
    camobj1.Add_Sales_Staff__c=true;
    camobj1.Share_Campaign_Participation_Flag__c=true;
    insert camobj1;
                   Account newAcc = new Account();
                    newAcc.FirstName = cm.Response_FirstName__c;
                    newAcc.LastName = cm.Response_LastName__c;
                    newAcc.Email__c = cm.Response_Email__c;
                    newAcc.recordtypeId = personAccRecordTypeId ;
                   // accobj.add(newAcc);
                  //  cm.add(cm);
    
    list<Campaign_Member__c> listcampaignmem=new list<Campaign_Member__c>();
    Campaign_Member__c cm1=new Campaign_Member__c();
    cm1.Campaign_ID__c=camobj1.id;
    cm1.Status__c = 'Ready';
    cm1.Retail_Campaign_Id__c=campobj.id;
    cm1.MD__c='JP';
    listcampaignmem.add(cm1);
    Campaign_Member__c cm2=new Campaign_Member__c();
    cm2.Campaign_ID__c=camobj1.id;
    cm2.Status__c = 'Ready';
    cm2.Retail_Campaign_Id__c=campobj.id;
    
    cm2.MD__c='JP';
    listcampaignmem.add(cm2);
    Campaign_Member__c cm3=new Campaign_Member__c();
    cm3.Campaign_ID__c=camobj1.id;
    cm3.Retail_Campaign_Id__c=campobj.id;
    cm3.Status__c = 'Ready';
    cm3.MD__c='JP';
    
    cm3.Contact_Id__c=accobj.id;
    listcampaignmem.add(cm3);
    insert listcampaignmem;
    
    
     
     
    test.startTest();     
      CampaignMembersCustomHelperJP cth = new CampaignMembersCustomHelperJP(); 
      CampaignMembersCustomHelperJP.addSalesCampaignMember(listcampaignmem);
      CampaignMembersCustomHelperJP.afterInsertSharing(listcampaignmem);
      CampaignMembersCustomHelperJP.wholesaleCampaignSharing(listcampaignmem);
      CampaignMembersCustomHelperJP.beforeDeleteOperation(listcampaignmem);
      CampaignMembersCustomHelperJP.CmSharingForDealer(listcampaignmem);
      CampaignMembersCustomHelperJP.addSalesCampaignMember(listcampaignmem);
    test.stoptest();
   }
  

}