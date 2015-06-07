/*
    Type:       Test Class
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
@isTest public class CampaignHelperTest {
 static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName(); 
    @isTest static void testCopyTopCampaignStatusValueToSavedCampaign(){
        String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
        String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
        String obCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Simple').getRecordTypeId();
        String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
        
        Test.startTest();
       Set<String> topCampaignIds = new Set<String>();
       List<Campaign> listcampaigns=new list<Campaign>();
       Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
       for(integer i=0;i<1;i++)
       {
       Campaign cac= new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId,
            ParentId = top.Id
        );
        listcampaigns.add(cac);
       }
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
            if(campaign.Execution_Type__c == 'OB Call')
            {
                campaignIds.add(campaign.Id);
            }
        }
        if(campaignIds!=null && !campaignIds.isEmpty())
       CampaignHelper.copyTopCampaignStatusValueToSavedCampaign(campaignIds);
       system.debug('@@@@@@@@@ campaignIds '+campaignIds);
        Test.stopTest();
     
    }
     @isTest static void testupdateCampaignMemberStatusToRelatedCampaig()
     {
             String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
        String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();

     Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'b', 
            Phone = '1212313', 
            email = 's@s.s'
        );
        insert contact;
        List<CampaignMember> Listcampmember= new List<CampaignMember>();
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
        for(integer i=0;i<1;i++)
        {
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id,           
            Status = 'Send'
        );
        Listcampmember.add(topmember);
        }
        insert Listcampmember;
        
      
        
        Campaign objcampaign = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            Execution_Type__c ='OB Call',
            EndDate = System.today(),
            RecordTypeId = centralCampaignId
        );
        
        insert objcampaign;
        
        objcampaign.Status='Published';
        update objcampaign;
        
     CampaignHelper.updateCampaignMemberStatusToRelatedCampaign(Listcampmember);
     }
     @isTest static void testbeforeUpdateEvents()
     {
     Id cmpExeReTpIdS = cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId();
        Id cmpExeReTpIdC = cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId();
        
     String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
            List<Campaign> campaignNew=new list<Campaign>();
Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
     for(integer i=0;i<1;i++)
       {
       Campaign cac= new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId,
            ParentId = top.Id
        );
        campaignNew.add(cac);
     }
     insert campaignNew;
     List<Campaign> Listcampain=new list<Campaign>();
     List<Campaign> updatecampain=new list<Campaign>();
      Listcampain=[select name,IsActive,status,startdate,EndDate ,execution_type__c from Campaign where id in:campaignNew];
      for(Campaign cam:Listcampain)
      {
            cam.Name ='Test campain';
            cam.Status ='Started';
            cam.StartDate =System.today()+1;
            cam.EndDate =System.today()+2;
            cam.Execution_Type__c ='OB Call';
            cam.RecordTypeId = topCampRecordTypeId;
           updatecampain.add(cam); 
      }
      update updatecampain;
     
}

 @isTest static void testafterUpdateEvents()
     {
          String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
      List<Campaign> campaignNew=new list<Campaign>();
Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        
        Template__c temp=new Template__c();
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Price List';
        temp.ValidTimeHrs__c=2;
        insert temp;
     for(integer i=0;i<1;i++)
       {
       Campaign cac= new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId,
            ParentId = top.Id
        );
        campaignNew.add(cac);
     }
   insert campaignNew;
     }
     @isTest static void testafterInsertEvents_CampaignShare()
     {
     String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
      String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
       
      List<Campaign> campaignNew=new list<Campaign>();
Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Published', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
     for(integer i=0;i<1;i++)
       {
       Campaign cac= new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Published', 
            StartDate = System.today(), 
            BP_Start_Date__c= System.today(),
            BP_End_Date__c= System.today(),
            Retail_Start_Date__c= System.today(),
            Retail_Due_Date__c= System.today(),
            Region_Due_Date__c= System.today(),
            Region_Best_Number__c=21,
            Region_Recommend_Number__c=12,
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId,
            ParentId = top.Id
        );
        campaignNew.add(cac);
     }
   insert campaignNew;
  // update campaignNew;
            
  Campaign cac= new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Published', 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
            RecordTypeId = topCampRecordTypeId,
            ParentId = top.Id,
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
            cac.Name = 'top';
            cac.Status = 'Started';
            cac.StartDate = System.today();
            cac.EndDate = System.today();
            cac.Execution_Type__c ='OB Call';
            cac.RecordTypeId = topCampRecordTypeId;
            cac.ParentId = top.Id;
            update cac;
            
             Campaign objcampaign = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = centralCampaignId
        );
        
        insert objcampaign;
        
        objcampaign.Status='Published';
        update objcampaign;
            
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
            Status = 'Started',
            Name = 'cmp', 
            StartDate = System.today(), 
            EndDate = System.today()
            );
        insert cmp;
        
        Campaign cmp2 = new Campaign(
            Status = 'Started',
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