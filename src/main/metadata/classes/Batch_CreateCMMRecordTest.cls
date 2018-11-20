/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.08.23
Company             :    NTT Data,Inc.
Usage               :   Test Class for CustomIterableBatchForCampaignMember,CreateCampaignMemberCsv classes  
************************************************************************************/

   @isTest
public class Batch_CreateCMMRecordTest {
    
     public static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
  public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();    
     //   static String str = 'NO,Accountid,Vehicle ID,Vehicle relationship Id,Retail task contract Id,Primary Dealer,UcID \n 8,001N000001J0Vh0,a04N000000H99awIAB,a03N000000MCNuhIAH,a0dN000000BwB2aIAF,001N000001IrcyPIAR,JEPXXXXXXXXXX';
        static String str = 'NO,Accountid,Vehicle ID,Vehicle relationship Id,Retail task contract Id,Primary Dealer,UcID \n' ;
    public static String[] csvFileLines;
  public static Blob csvFileBody;
    
    Public static testmethod void FileUploadTest()
    {
      Account    DealerAccount= new Account();
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
        String camid;
        camid=rc.id;
        CreateCampaignMemberCsv csv=new CreateCampaignMemberCsv();
        CreateCampaignMemberCsv.FileUpload(camid);
        
         csvFileBody = Blob.valueOf(str);

        Attachment attach=new Attachment();     
      attach.Name='Unit Test Attachment';
      Blob bodyBlob=csvFileBody;
      attach.body=bodyBlob;
        attach.parentId=rc.id;
        insert attach;
        Batch_CreateCMMRecord bt=new Batch_CreateCMMRecord(rc.id);
        database.executeBatch(bt,1);
        
    
    }

}