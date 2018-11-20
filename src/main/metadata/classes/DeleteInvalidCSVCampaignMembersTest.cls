@isTest
public class DeleteInvalidCSVCampaignMembersTest {
     public static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
    public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();    

    
    Public static testmethod void CmmTest()
    {
    
    UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'stand1t', Email='testU290ser1@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='tes903se34r2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj){
         test.starttest();
        Account    DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
       // DealerAccount.Market__c='JP';
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
       // camobj2.Market__c='JP';
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
   // camobj1.Market__c='JP';
    insert camobj1;
        
        Retail_Campaign__c   rc = new Retail_Campaign__c(RecordTypeId =RTId,Parent_Campaign__c=camobj1.id,Dealer_Name__c = DealerAccount.Id,Child_Campaign_Status__c='Planning',Campaign_Execution_Channels__c = 'eEmail', Apply_Status__c = 'Approved');
                   insert rc; 
        
         Campaign_Member__c  cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj1.id;
    cm.Status__c = 'Ready';
    cm.Created_By_CSV__c=true;
        cm.Retail_Campaign_Id__c=rc.id; 
        cm.Invalid_campaign_Member__c=true; 
        cm.market__c='JP';
    //cm.contact_Id__c = accobj.Id;   
     
    insert cm;      
        DeleteInvalidCSVCampaignMembers cmms=new DeleteInvalidCSVCampaignMembers(rc.id);
        database.executeBatch(cmms,1);  
        test.stopTest();
        }
        
    }

}
