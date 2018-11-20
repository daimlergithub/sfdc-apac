@istest
public class CreateMissingCampaignLeadTest {

    private static Account personAcc;
    private static Lead__c saleslead;
    public static Lead__C lead2;
   
    public Static Account DealerAccount;
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
          set<Id> ledid=new set<Id>();
        
          test.starttest();
        personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
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
        ledid.add(lead2.id);
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
    camobj1.Child_Campaign_Status__c='Planning';
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
    camobj1.Segmentation_Base__c='Customer';
    insert camobj1; 
    camobj1.Child_Campaign_Status__c='Response collection';
    
    update camobj1;
         system.debug('@@@@@@@@@@@@@@camobj1@@cm'+camobj1);
       list<Campaign_Member__c> insertcm=new List<Campaign_Member__c>();
    Campaign_Member__c cm=new Campaign_Member__c();
    cm.Campaign_ID__c=camobj1.id;
    // cm.Campaign_ID__r.Child_Campaign_Status__c='Execution';
    cm.Status__c = 'Ready';
    cm.contact_Id__c = personAcc.Id;   
  //  cm.Preferred_Dealer__c=DealerAccount.id;
    insert cm;    
         system.debug('@@@@@@@@@@@@@@@@cm'+cm.Campaign_ID__r.Child_Campaign_Status__c);
          system.debug('@@@@@@@@@@@@@@@@cm'+cm.Campaign_ID__r.Execution_type__c);
           system.debug('@@@@@@@@@@@@@@@@cm'+camobj1.Child_Campaign_Status__c); 
             
         List<Campaign_member__c> listCamMember=new List<Campaign_member__c>();
          listCamMember=[Select id,Campaign_ID__c,Campaign_ID__r.Segmentation_Base__c,Vehicle__c,Preferred_Dealer__r.Dealer_GC_Code__c,Contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign_ID__r.Parent.Campaign_Sub_Type__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Campaign_ID__c =:camobj1.id and Contact_Id__c=:personAcc.id ];
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
            
        
        CreateMissingCampaignLead  db=new CreateMissingCampaignLead(ledid);
        database.executeBatch(db,1);
        test.stopTest();
    }
    
     Public static testmethod void TestAfterSaleslead()
    {
          set<Id> ledid=new set<Id>();
        String dupnumber=label.Dup_Number_Last_Modification;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        
          test.starttest();
        personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
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
        
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
         Vehicle__c   vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000);
            insert vehicleObj;
        
      Lead__c  lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = personAcc.id;
        lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'Allocated';
        lead1.RecordTypeId=afterSalesRecordTypeId;
        lead1.AfterSales_Vehicle__c=vehicleObj.id;
        insert lead1;
            ledid.add(lead1.id);
            
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
    
      Campaign camobj4 = new Campaign();
    camobj4.RecordTypeId = camIdExec;
    camobj4.ParentId=camobj2.id;
    camobj4.Child_Campaign_Status__c='Planning';
    camobj4.Name = 'camptest1';
    camobj4.Type = 'Other'; 
    camobj4.Segmentation_Date__c= System.today()+4;
    camobj4.Execution_Start_Date__c = System.today()+10;
    camobj4.Execution_Type__c= 'eMail';
    camobj4.Description = 'testdescrip';
    camobj4.Add_Service_Staff__c=true;
    camobj4.Add_Campaign_Member_ID__c=true;
    camobj4.Add_Sales_Staff__c=true;
    camobj4.Share_Campaign_Participation_Flag__c=true;
    camobj4.Segmentation_Base__c='Customer';
    insert camobj4; 
    
         Retail_Campaign__c camobj = new Retail_Campaign__c();
    camobj.RecordTypeId = parentRetailcentmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Campaign_Sub_Type__c= 'Sales';
    camobj.Status__c= 'Draft';
    camobj.Parent_Campaign__c=camobj4.id;
    camobj.Response_Date__c = date.today();
    camobj.Start_Date__c= System.today();
    camobj.Close_Date__c= System.today()+30;
    //camobj.Campaign_Executer__c='Retail';
    camobj.Child_Campaign_Status__c='Response collection';
   // camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description__c= 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
  
    
        Retail_Campaign__c camobj1 = new Retail_Campaign__c();
        camobj1.RecordTypeId = RetailcentmarcampRecordTypeId;
        camobj1.Parent_Campaign1__c=camobj.id;
        camobj1.Child_Campaign_Status__c='Planning';
         camobj1.Response_Date__c = date.today();
      
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
      //  camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'eMail';
       // camobj1.Description = 'testdescrip';
        insert camobj1;
        camobj1.Child_Campaign_Status__c='Execution';
        update camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Retail_Campaign_Id__c = camobj1.id;
     camMem.Status__c = 'Bounced';
     camMem.Contact_Id__c = personAcc.id;

      insert camMem;
      
        CreateMissingCampaignLead  db=new CreateMissingCampaignLead(ledid);
        database.executeBatch(db,1);
        test.stopTest();
    }
}