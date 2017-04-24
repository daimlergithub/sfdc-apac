/*
    Type:       Test Class
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
@isTest public with sharing class CampaignHelperTest {
    static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName(); 
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
    public static String mbBestPracticeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
    public static String complex = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static String cacCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static string top = 'top';
    public static string Started = 'Started';
    public static string OB_Call = 'OB Call';
    public static string Published = 'Published';
    public static Set<String> topCampaignIds;
    private static List<Campaign> rclist; 
     private static Map<id,Campaign> CampaignMap1;
       public static Campaign camobj;
       public static Campaign camobj1;
      public static set<Id> campid;
        // public static id DealRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
     
   
    public static List<Campaign> listcampaigns;
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     static void preparetestdata(){
     
     camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Draft';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Executer__c='Retail';
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
    rclist=new List<Campaign>();
   // rclist.add(camobj);
     system.debug('rclist---'+rclist);
    
        camobj1 = new Campaign();
        camobj1.RecordTypeId = camIdExec;
        camobj1.ParentId=camobj.id;
        camobj1.Child_Campaign_Status__c='Execution';
       // camobj1.Consolidated_List_Completed__c= true;
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
        camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'eMail';
        camobj1.Description = 'testdescrip';
    rclist.add(camobj1);
    
     insert rclist;
    system.debug('rclist---'+rclist);
    CampaignMap1 = new Map<id,Campaign>();
   
      
      CampaignMap1.put(camobj1.id,camobj1);
      system.debug('CampaignMap1'+CampaignMap1);
    
    }
     public static void preparedTestDataCustomsettings()
     {
        Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.Enable__c=true;
        cls.name='Community Enabled';
        insert cls;
    }
    
     public static void preparedTestData(){      
       List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
       insert updatecustomsettings;
       topCampaignIds = new Set<String>();
       listcampaigns=new list<Campaign>();
       
       Contact contact = new Contact(
           LastName = 'test Contact'
       );
       insert contact;
       
       Campaign top1 = new Campaign(          
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId,
            Child_Campaign_Status__c = 'Execution' ,
            Set_List_Maintenance_Flag__c = false
        );
        insert top1;
                    
       Campaign cac= new Campaign(           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = topCampRecordTypeId,
            ParentId = top1.Id
        );
        listcampaigns.add(cac);       
        insert listcampaigns;
        
        Campaign c = [Select Id from Campaign Where Id =: listcampaigns[0].Id];
        /*Inserting Campaign member status*/
        CampaignMember cms = new CampaignMember(
            CampaignId = c.Id,
            ContactId = contact.Id
            
        );
        insert cms;
    }
    
    
    @isTest static void testCopyTopCampaignStatusValueToSavedCampaign(){
    preparedTestData();
    preparedTestDataCustomsettings();
          Test.startTest();
      List<Campaign> campaigns = [select ParentId, Parent.ParentId,Execution_Type__c from Campaign where Id in: listcampaigns];     
       for(Campaign cam : campaigns){
       if(cam.ParentId != null){     
                topCampaignIds.add(cam.Parent.ParentId);
                
            }
       }
         Set<String> campaignIds = new Set<String>();
        for(Campaign campaign : campaigns){
            if(campaign.Execution_Type__c == OB_Call)
            {
                campaignIds.add(campaign.Id);
            }
        }
        if(campaignIds!=null && !campaignIds.isEmpty())
       CampaignHelper.copyTopCampaignStatusValueToSavedCampaign(campaignIds);
       Test.stopTest();
       system.assertNotEquals(null, listcampaigns[0].parentId);
    }
    
    
    @isTest static void testupdateCampaignMemberStatusToRelatedCampaig()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = topCampRecordTypeId,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
            IsActive = true, 
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            Execution_Type__c =OB_Call,
            EndDate = System.today(),
            RecordTypeId = centralCampaignId
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Status=Published;
        update objcampaign;
      
       /*Create Participating Dealer*/
      /* Participating_Dealer__c pd = new Participating_Dealer__c (
           Dealer__c = dealer.Id,
           Campaign__c = objcampaign.Id
       );
       insert pd;
      */

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        CampaignHelper.afterInsertUpdateEvents(listcampaigns,oldMap,true);
        CampaignHelper.parentCampaignSatus(listcampaigns,oldMap);
        CampaignHelper.validationParentCampaign(listcampaigns,oldMap,false,true);
        CampaignHelper.validationChildCampaign(listcampaigns,oldMap,false,true);
        CampaignHelper.beforeUpdateEvents(listcampaigns,oldMap);
        CampaignHelper.afterInsertEvents(listcampaigns);
        CampaignHelper.afterInsertEvents_CampaignShare(listcampaigns,oldMap);
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
    
     @isTest static void testbeforeUpdateEvents()
     {
     preparedTestDataCustomsettings();
     Test.StartTest();
            List<Campaign> campaignNew=new list<Campaign>();
          Campaign top3 = new Campaign(           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId);
         insert top3;
     
       Campaign cac= new Campaign(           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = topCampRecordTypeId,
            ParentId = top3.Id
        );
        campaignNew.add(cac);
     
     insert campaignNew;
     List<Campaign> Listcampain=new list<Campaign>();
     List<Campaign> updatecampain=new list<Campaign>();
      Listcampain=[select name,IsActive,status,startdate,EndDate ,execution_type__c from Campaign where id in:campaignNew];
      for(Campaign cam:Listcampain)
      {
            cam.Name ='Test campain';
            cam.Status =Started;
            cam.StartDate =System.today()+1;
            cam.EndDate =System.today()+2;
            cam.Execution_Type__c =OB_Call;
            cam.RecordTypeId = topCampRecordTypeId;
           updatecampain.add(cam); 
      }
      update updatecampain;
      Test.StopTest();
        system.assertNotEquals(null, updatecampain[0].StartDate); 
     
} 

 @isTest static void testafterUpdateEvents(){          
        preparedTestDataCustomsettings();
        Test.StartTest();
        
        
        List<Campaign> campaignNew = new list<Campaign>();
        Campaign top4 = new Campaign(           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        insert top4; 
        campaignNew.add(top4);
        
        Template__c temp=new Template__c();
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Price List';
        temp.ValidTimeHrs__c=2;
        insert temp;
        
        Campaign cac= new Campaign(
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = topCampRecordTypeId,
            ParentId = top4.Id
        );
        
        insert cac;
        
        campaignNew.add(cac);         
        update campaignNew;
        Test.StopTest();
        //system.assertEquals(false, campaignNew[0].SMS_Task_Verified__c);
}
     
     
      @isTest static void testafterInsertEvents_CampaignShare()
     {
     preparedTestDataCustomsettings();
      Test.StartTest();
      List<Campaign> campaignNew=new list<Campaign>();
     Campaign top5 = new Campaign(
            //IsActive = true, 
            Name = top, 
            Status = Published, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId  );
         insert top5;
         for(integer i=0;i<1;i++)
         {
           Campaign cac= new Campaign(
            IsActive = true, 
            Name = top, 
            Status = Published, 
            StartDate = System.today(), 
            BP_Start_Date__c= System.today(),
            BP_End_Date__c= System.today(),
            Retail_Start_Date__c= System.today(),
            Retail_Due_Date__c= System.today(),
            Region_Due_Date__c= System.today(),
            Region_Best_Number__c=21,
            Region_Recommend_Number__c=12,
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = mbBestPracticeId,
            ParentId = top5.Id );
           campaignNew.add(cac);
         }
   insert campaignNew;
  // update campaignNew;
            
  Campaign cac = new Campaign(
            IsActive = true, 
            Name = top, 
            Status = Published, 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = mbBestPracticeId,
            ParentId = top5.Id,
            StartDate = System.today(), 
            BP_Start_Date__c= System.today(),
            BP_End_Date__c= System.today(),
            Retail_Start_Date__c= System.today(),
            Retail_Due_Date__c= System.today(),
            Region_Due_Date__c= System.today(),
            Region_Best_Number__c=21,
            Region_Recommend_Number__c=12
        );
        insert cac;
        
        
            cac.IsActive = true;
            cac.Name = top;
            cac.Status = Started;
            cac.StartDate = System.today();
            cac.EndDate = System.today();
            cac.Execution_Type__c =OB_Call;
            cac.RecordTypeId = mbBestPracticeId;
            cac.ParentId = top5.Id;
            update cac;
            
        Campaign objcampaign = new Campaign(
            IsActive = true, 
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = centralCampaignId
        );
        
        insert objcampaign;
        
        objcampaign.Status=Published;
        update objcampaign;
        Test.StopTest();
        CampaignShare TestShareAs = [select id from CampaignShare where CampaignId =:cac.id limit 1];   
        system.assertNotEquals(null, TestShareAs);

     }
     
     
     @isTest static void afterInsertUpdateEvents1(){
        List<Campaign> campaignList = new List<Campaign>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        Campaign testCampaign1 = new Campaign(
            IsActive = true, 
            Name = 'Test Campaign', 
            Task_Created_By__c = 'Contact',
            Create_Task__c = true, 
            StartDate = System.today(), 
            EndDate = System.today(),
            
            RecordTypeId = complex
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        
        Campaign cpn = [Select Id,Create_Task__c,Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.Create_Task__c = false;                
        update cpn;        
        campaignMap.put(cpn.Id, cpn);
        CampaignHelper.afterInsertUpdateEvents(campaignList, campaignMap, true);
        
     }
     
     @isTest static void afterInsertUpdateEvents2(){
        List<Campaign> campaignList = new List<Campaign>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        Campaign testCampaign1 = new Campaign(
            IsActive = true, 
            Name = 'Test Campaign', 
            Task_Created_By__c = 'Lead',
            Create_Task__c = true, 
            StartDate = System.today(), 
            EndDate = System.today(),
            
            RecordTypeId = complex
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        
        Campaign cpn = [Select Id,Create_Task__c,Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.Create_Task__c = false;                
        update cpn;        
        campaignMap.put(cpn.Id, cpn);
        CampaignHelper.afterInsertUpdateEvents(campaignList, campaignMap, true);
        
     }
     
     @isTest static void afterInsertUpdateEvents3(){
        List<Campaign> campaignList = new List<Campaign>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        /*Campaign1*/
        Campaign testCampaign1 = new Campaign(
            IsActive = true, 
            Name = 'Test Campaign', 
            Task_Created_By__c = 'Vehicle',
            Create_Task__c = true, 
            StartDate = System.today(), 
            EndDate = System.today(),           
            RecordTypeId = complex
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        
        Campaign cpn = [Select Id,Create_Task__c,Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.Create_Task__c = false;                
        update cpn;        
        campaignMap.put(cpn.Id, cpn);
        CampaignHelper.afterInsertUpdateEvents(campaignList, campaignMap, true);
        
     }
     
     @isTest static void afterInsertUpdateEvents4(){
        List<Campaign> campaignList = new List<Campaign>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        /*Campaign1*/
        Campaign testCampaign1 = new Campaign(
            IsActive = true, 
            Name = 'Test Campaign', 
            Task_Created_By__c = 'Case',
            Create_Task__c = true, 
            StartDate = System.today(), 
            EndDate = System.today(),           
            RecordTypeId = complex
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        
        Campaign cpn = [Select Id,Create_Task__c,Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.Create_Task__c = false;                
        update cpn;        
        campaignMap.put(cpn.Id, cpn);
        CampaignHelper.afterInsertUpdateEvents(campaignList, campaignMap, true);
        
     }
     
     @isTest static void afterInsertUpdateEvents5(){
        List<Campaign> campaignList = new List<Campaign>();
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        
        /*Campaign1*/
        Campaign testCampaign1 = new Campaign(
            //IsActive = true, 
            Name = 'Test Campaign', 
            Task_Created_By__c = 'Case',
            Create_Task__c = true, 
            StartDate = System.today(), 
            EndDate = System.today(),           
            RecordTypeId = cacCampaign
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        
        
        Campaign cpn = [Select Id,Create_Task__c,Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.IsActive = false;                
        update cpn;        
        campaignMap.put(cpn.Id, cpn);
        CampaignHelper.afterInsertUpdateEvents(campaignList, campaignMap, true);
        
     }
  
   static testmethod void MethodTest2()
   {
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
   
    camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Completed';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    rclist=new List<Campaign>();
    rclist.add(camobj);
    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj.id;
    camobj1.Child_Campaign_Status__c='Execution';
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today()+10;
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    rclist.add(camobj1);
       
    insert rclist;
    
    
     Test.startTest();
     CampaignHelper.beforeDeleteEvents(rclist);
   
     Test.stopTest();
    }
  } 
  
   static testmethod void MethodTest3()
   {
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
    
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2345@test.com',
                Alias = 'batman',
                Email='sai.waynedsse@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
             Database.insert(portalAccountOwner1);
    
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
    
    camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Draft';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    rclist=new List<Campaign>();
    rclist.add(camobj);
    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj.id;
    camobj1.Child_Campaign_Status__c='Execution';
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today()+10;
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    rclist.add(camobj1);
       
    insert rclist;
    
    
     Test.startTest();
     CampaignHelper.beforeDeleteCampaignStatus(rclist);
   
     Test.stopTest();
    }
  } 
  
 
  static testmethod void MethodTest5()
   {
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
     
       Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2345@test.com',
                Alias = 'batman',
                Email='test1@gmail.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert portalAccountOwner1;
    
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer;
     
    camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Draft';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Executer__c='Retail';
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
    rclist=new List<Campaign>();
   // rclist.add(camobj);
     system.debug('rclist---'+rclist);
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj.id;
    camobj1.Child_Campaign_Status__c='Completed';
    camobj1.Consolidated_List_Completed__c= true;
    camobj1.MD__c='AU';
    camobj1.Name = 'camptest1';
    camobj1.Campaign_Type__c='After Sales';
    camobj1.Type = 'Other';
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today()+10;
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    rclist.add(camobj1);
    insert rclist;
    system.debug('rclist---'+rclist);
   
    
     Test.startTest();
     CampaignHelper.copyCampaignToRetailCampaign(rclist);
   
     Test.stopTest();
    }
  } 
  @isTest static void testCopy()
     {   
        User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
     
       Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test234@test.com',
                Alias = 'batman',
                Email='test1@gmail.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert portalAccountOwner1;
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
       listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today()+10,
            Execution_Type__c =OB_Call,
            Campaign_Executer__c='Retail',
            RecordTypeId = camIdPlan,
            Campaign_Type__c='Sales',
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Execution',
                Set_List_Maintenance_Flag__c = false,
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+12,
                Ready_for_List_Maintenance__c=false,
                Campaign_Type__c='Sales',
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        
        Participating_Dealer__c pd=new Participating_Dealer__c();
        pd.Campaign__c=objcampaign.id;
        pd.Dealer__c=dealer.id;
        insert pd;
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c,Ready_for_List_Maintenance__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Ready_for_List_Maintenance__c=true;
        update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.copyCampaignToRetailCampaign(listcampaigns);
        
        top2.Campaign_Type__c='After Sales';
        update top2;
        CampaignHelper.copyCampaignToRetailCampaign(listcampaigns);
        
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
        }
     }
     
     
   @isTest static void testparent()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Completed',
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+10,
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Child_Campaign_Status__c='Response collection';
        update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.parentCampaignSatus(listcampaigns,oldMap);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
    
     @isTest static void testchild()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Status='Completed';
        update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.parentCampaignSatus(listcampaigns,oldMap);
        
        
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
    
     @isTest static void testUseseg()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Completed',
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                SegWorkingMonth__c = 'Jan',
                SegWorkingDay__c = '23',
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+10,
                Use_Segmentation_Criteria__c=true,
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        //objcampaign.Status='Completed';
        //update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Feb';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Mar';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Feb';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Apr';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'May';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
         objcampaign.SegWorkingMonth__c  = 'Jun';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
    
      @isTest static void testUseseg1()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Completed',
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                SegWorkingMonth__c = 'Jul',
                SegWorkingDay__c = '23',
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+10,
                Use_Segmentation_Criteria__c=true,
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        //objcampaign.Status='Completed';
        //update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Aug';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Sep';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Oct';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Nov';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        objcampaign.SegWorkingMonth__c  = 'Dec';
        update objcampaign;
        CampaignHelper.useSegmentationCampaign(listcampaigns,oldMap,true,false);
        
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
   
   @isTest static void testEmail()
     {   
        User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
     
       Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test234@test.com',
                Alias = 'batman',
                Email='test1@gmail.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
            );
            insert portalAccountOwner1;
           preparedTestData(); 
           preparedTestDataCustomsettings();     
        Test.StartTest();
       listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            Campaign_Executer__c='Retail',
            RecordTypeId = camIdPlan,
            Campaign_Type__c='Sales',
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Completed',
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+10,
                Ready_for_List_Maintenance__c=false,
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        
        Participating_Dealer__c pd=new Participating_Dealer__c();
        pd.Campaign__c=objcampaign.id;
        pd.Dealer__c=dealer.id;
        insert pd;
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c,Ready_for_List_Maintenance__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Ready_for_List_Maintenance__c=true;
        update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.emailNotificationToDealer(listcampaigns,oldMap);
        
        top2.Campaign_Type__c='After Sales';
        update top2;
        CampaignHelper.emailNotificationToDealer(listcampaigns,oldMap);
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
        }
     }
     
      static testmethod void updateLogicTest()
   {
    User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser){
   
    camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Completed';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    insert camobj;
    
    
    camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj.id;
    camobj1.Child_Campaign_Status__c='Execution';
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other';
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today()+10;
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    rclist=new List<Campaign>();
    rclist.add(camobj1);
    
    Campaign camobj2 = new Campaign();
    camobj2.RecordTypeId = camIdPlan;
    camobj2.CloneCampaign__c=camobj.id;
    camobj2.Status = 'Draft';
    camobj2.Campaign_Execution_Channels__c='eMail';
    camobj2.Name = 'camptest1';
    camobj2.Type = 'Other';
    camobj2.StartDate = System.today();
    camobj2.EndDate = System.today()+30;
    camobj2.Execution_Type__c= 'eMail';
    camobj2.Description = 'testdescrip';
   
    rclist.add(camobj2);
    
       
    insert rclist;
    
    
     Test.startTest();
     CampaignHelper.updateLogic(rclist);
   
     Test.stopTest();
    }
  } 
  
   @isTest static void testValidationChildCampgin()
     {
           preparedTestData(); 
           preparedTestDataCustomsettings();     
    Test.StartTest();
   listcampaigns=new List<Campaign>();
     //Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842');
     insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top2 = new Campaign(
           
            Name = top, 
            Status = 'Draft', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c =OB_Call,
            RecordTypeId = camIdPlan,
            IsActive = true
        );
        
        insert top2;
        
         CampaignMember topMember = new CampaignMember(
            CampaignId = top2.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
                IsActive = true, 
                Name = top, 
                Status = Started, 
                ParentId=top2.id,
                Child_Campaign_Status__c='Completed',
                StartDate = System.today(), 
                Execution_Type__c =OB_Call,
                Segmentation_Date__c= System.today()+4,
                Execution_Start_Date__c = System.today()+10,
                RecordTypeId = camIdExec
        );

        insert objcampaign;
        listcampaigns.add(objcampaign);
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c,ParentId,Create_Task__c,Child_Campaign_Status__c from Campaign where id IN:listcampaigns ];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Child_Campaign_Status__c='Response collection';
        update objcampaign;
      
     

        CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
        listcampaigns.add(objcampaign);
        
        CampaignHelper.validationChildCampaign(listcampaigns,oldMap,true,false);
        
        //try{CampaignHelper.afterInsertUpdateCampaign(oldMap);}catch(Exception e){}
        Test.StopTest();
        system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
}