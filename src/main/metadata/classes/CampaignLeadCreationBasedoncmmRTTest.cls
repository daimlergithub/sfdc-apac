@isTest
public class CampaignLeadCreationBasedoncmmRTTest {
    
    private static Account personAcc;
    private static Lead__c saleslead;
    public static Lead__C lead2;
    public Static Account DealerAccount;
     public static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
      public static Id parentRetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
 public static Id RetailcentmarcampRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Public static testmethod void TestUpdateCampaignLeadBatch()
    {
       
        String dupnumber=label.Dup_Number_Last_Modification;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'stand1t', Email='testUser1@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuse34r2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj){
        
          test.starttest();
        personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testveemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other', 
                                DUPNumber__c='123443',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
            insert personAcc;
        saleslead=new lead__c();
        
         DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        DealerAccount.Dealer_Rollout_Status__c = 'Done';
        
        insert DealerAccount;
       
         lead2 = new lead__C();
        lead2.MD__c = 'JP';
        lead2.Contact__c = personAcc.id;
        lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'Allocated';
        lead2.RecordTypeId=salesRecordTypeId;
        insert lead2;
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
        camobj2.Campaign_Sub_Type__c='Sales';
    insert camobj2;
        
        
          Campaign camobj1 = new Campaign();
    camobj1.RecordTypeId = camIdExec;
    camobj1.ParentId=camobj2.id;
    camobj1.Child_Campaign_Status__c='Execution';
    camobj1.Name = 'camptest1';
    camobj1.Type = 'Other'; 
    camobj1.Segmentation_Date__c= System.today()+4;
    camobj1.Execution_Start_Date__c = System.today();
    camobj1.Execution_Type__c= 'eMail';
    camobj1.Description = 'testdescrip';
    camobj1.Add_Service_Staff__c=true;
    camobj1.Add_Campaign_Member_ID__c=true;
    camobj1.Add_Sales_Staff__c=true;
    camobj1.Share_Campaign_Participation_Flag__c=true;
    camobj1.Segmentation_Base__c='Customer';
    insert camobj1;
           Retail_Campaign__c   rc = new Retail_Campaign__c(RecordTypeId =RTId,Parent_Campaign__c=camobj1.id,Dealer_Name__c = DealerAccount.Id,Child_Campaign_Status__c='Planning',Campaign_Execution_Channels__c = 'eEmail', Apply_Status__c = 'Approved');
                   insert rc; 
         system.debug('@@@@@@@@@@@@@@camobj1@@cm'+camobj1);
       list<Campaign_Member__c> insertcm=new List<Campaign_Member__c>();
    Campaign_Member__c cm=new Campaign_Member__c();
   // cm.Campaign_ID__c=camobj1.id;
    // cm.Campaign_ID__r.Child_Campaign_Status__c='Execution';
    cm.Status__c = 'Ready';
    cm.contact_Id__c = personAcc.Id;   
        cm.Retail_Campaign_Id__c=rc.id;
        cm.Market__c='JP';
  //  cm.Preferred_Dealer__c=DealerAccount.id;
    insert cm;   
        system.debug('@@@@@@@@@@@@@@@@campaign'+camobj2);
            system.debug('@@@@@@@@@@@@@@@@parent cm'+rc);
         system.debug('@@@@@@@@@@@@@@@@cm'+cm);
        
         List<Campaign_member__c> listCamMember=new List<Campaign_member__c>();
          listCamMember=[Select id,Retail_Campaign_Id__c,Retail_Campaign_Id__r.Segmentation_Base__c,Vehicle__c,Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c,Retail_Campaign_Id__r.Parent_Campaign__c,Preferred_Dealer__r.Dealer_GC_Code__c ,Retail_Campaign_Id__r.Child_Campaign_Status__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Sub_Type__c,contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Retail_Campaign_Id__c !=null and Contact_Id__c !=null  and Retail_Campaign_Id__r.Parent_Campaign__c !=null and Campaign_ID__r.Execution_Start_Date__c=today and Retail_Campaign_Id__r.Child_Campaign_Status__c !='My Mercedes'  and  Retail_Campaign_Id__r.Child_Campaign_Status__c !='Lead' and  Retail_Campaign_Id__r.Child_Campaign_Status__c !='Survey' and (Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='Sales' Or Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='sales and After Sales')];
        //and (Campaign_ID__r.Child_Campaign_Status__c='Execution' or Campaign_ID__r.Child_Campaign_Status__c='Response collection') and (Campaign_ID__r.Execution_type__c !='My Mercedes' and Campaign_ID__r.Execution_type__c !='Lead' and Campaign_ID__r.Execution_type__c !='Survey')  and (Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales' OR Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales and After Sales') and (Campaign_ID__r.Segmentation_Base__c='Customer' OR Campaign_ID__r.Segmentation_Base__c='Vehicle')
        system.debug('@@@@@@@@@@@@@@@@'+listCamMember);
  /*  insertcm.add(cm);
        
        Campaign_Member__c cm1=new Campaign_Member__c();
    cm1.Campaign_ID__c=camobj1.id;
    cm1.Status__c = 'Ready';
    cm1.contact_Id__c = personAcc.Id;   
    cm1.Preferred_Dealer__c=DealerAccount.id;
   // insert cm;   
   insertcm.add(cm1);
        
       insert insertcm;*/
            
        
     CampaignLeadCreationBasedoncmmRT batch=new CampaignLeadCreationBasedoncmmRT();
        database.executeBatch(batch,1);
        test.stopTest();
        }
    }
    
    

}
