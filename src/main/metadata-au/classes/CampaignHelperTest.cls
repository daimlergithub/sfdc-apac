/*
    Type:       Test Class
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
@isTest(SeeAllData=true) public class CampaignHelperTest {
    //variables
 static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName(); 
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
    public static string top = 'top';
    public static string Started = 'Started';
    public static string OB_Call = 'OB Call';
    public static string Published = 'Published';
    @isTest static void testCopyTopCampaignStatusValueToSavedCampaign(){
        
        
        
        
        
        Test.startTest();
       Set<String> topCampaignIds = new Set<String>();
       List<Campaign> listcampaigns=new list<Campaign>();
       Campaign top1 = new Campaign(
          
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
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
              system.debug('@@@@@@@@@ listcampaigns'+listcampaigns);

       List<Campaign> campaigns = [select ParentId, Parent.ParentId,Execution_Type__c from Campaign where Id in: listcampaigns];
       system.debug('@@@@@@@@@ campaigns '+campaigns);
       for(Campaign cam : campaigns){
       if(cam.ParentId != null){
       system.debug('@@@@@@@@@ cam'+cam);
                topCampaignIds.add(cam.Parent.ParentId);
                
            }
       }
       system.debug('@@@@@@@@@ topCampaignIds'+topCampaignIds);
       Set<String> campaignIds = new Set<String>();
        for(Campaign campaign : campaigns){
            if(campaign.Execution_Type__c == OB_Call)
            {
                campaignIds.add(campaign.Id);
            }
        }
        if(campaignIds!=null && !campaignIds.isEmpty())
       CampaignHelper.copyTopCampaignStatusValueToSavedCampaign(campaignIds);
       system.debug('@@@@@@@@@ campaignIds '+campaignIds);
        Test.stopTest();
     system.assertNotEquals(null, listcampaigns[0].parentId);
    }
     @isTest static void testupdateCampaignMemberStatusToRelatedCampaig()
     {
          List<Campaign> listcampaigns=new list<Campaign>();
             
        

     Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            Salutation='Attorney',
             FirstName='testFirstname',
            LastName = 'testLastname',  
            Phone = '1212313', 
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
            RecordTypeId = topCampRecordTypeId
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
        Campaign listCampaign =[select IsActive,Name,Status,StartDate,Execution_Type__c,SMS_Task_Verified__c from Campaign where id IN:listcampaigns];
         list<Campaign> oldList = new  list<Campaign>();
         oldList.add(listCampaign);
        map<id,Campaign> oldMap = new map<id,Campaign>();
         oldMap.put(listCampaign.id, listCampaign);
         
        objcampaign.Status=Published;
        update objcampaign;
      
     CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
           listcampaigns.add(objcampaign);
         CampaignHelper.afterInsertUpdateEvents(listcampaigns,oldMap,true);
         CampaignHelper.beforeUpdateEvents(listcampaigns,oldMap);
         CampaignHelper.afterInsertEvents(listcampaigns);
        CampaignHelper.afterUpdateEvents(listcampaigns,listcampaigns);
        CampaignHelper.afterInsertEvents_CampaignShare(listcampaigns,oldMap);
         
         system.assertNotEquals(null, listcampaigns[0].StartDate);
     }
     @isTest static void testbeforeUpdateEvents()
     {
     
        
        
     
            List<Campaign> campaignNew=new list<Campaign>();
Campaign top3 = new Campaign(
           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
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
        system.assertNotEquals(null, updatecampain[0].StartDate); 
     
}

 @isTest static void testafterUpdateEvents()
     {
          
      List<Campaign> campaignNew=new list<Campaign>();
Campaign top4 = new Campaign(
           
            Name = top, 
            Status = Started, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
      insert top4;  
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
        campaignNew.add(cac);
           
           
     
   insert campaignNew;
         
         system.assertEquals(false, campaignNew[0].SMS_Task_Verified__c);
         
         
     }
     @isTest static void testafterInsertEvents_CampaignShare()
     {
     String mbBestPracticeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
      
       
      List<Campaign> campaignNew=new list<Campaign>();
Campaign top5 = new Campaign(
            //IsActive = true, 
            Name = top, 
            Status = Published, 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
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
            ParentId = top5.Id
        );
        campaignNew.add(cac);
     }
   insert campaignNew;
  // update campaignNew;
            
  Campaign cac= new Campaign(
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
        CampaignShare TestShareAs = [select id from CampaignShare where CampaignId =:cac.id limit 1];   
         system.assertNotEquals(null, TestShareAs);
     }
     
    // Test method to test au specific code
   @isTest(SeeAllData=true)  public static void testau_Before_Insert_Update_Events() 
    {
        // creating test data
        // 
        
        User u1 = UtilTestData.createUser('IT Manager', 'CAC Data Manager');
        User u2 = UtilTestData.createUser('IT Manager', 'CAC Data Manager');
        
        System.runAs(u1){

        Campaign cmp = new Campaign(
            Status = Started,
            Name = 'cmp', 
            StartDate = System.today(), 
            EndDate = System.today()
            );
        insert cmp;
        
        Campaign cmp2 = new Campaign(
            Status = Started,
            Name = 'cmp2', 
            StartDate = System.today(), 
            EndDate = System.today()
            );
        insert cmp2;
        
        
        
        u2.ManagerId = u1.id;
        update u2;
        cmp.OwnerId = u2.id;
        cmp2.OwnerId = u2.id;
        
        List<Campaign> cmplist = new List<Campaign>();
        cmplist.add(cmp);
        
        map<id,Campaign> cmpmap = new map<id,Campaign>();
        cmpmap.put(cmp.id, cmp);
        cmpmap.put(cmp2.id, cmp2);
        
        test.startTest();
        CampaignHelper.au_Before_Insert_Update_Events(cmplist, cmpmap, true, false);
        
        test.stopTest();
        
        system.assert(cmp.Approver__c != null);
    }        
    }
}