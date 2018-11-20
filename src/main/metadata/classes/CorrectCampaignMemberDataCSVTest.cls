@isTest
public class CorrectCampaignMemberDataCSVTest {
     public static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();   
    public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();    

    
    Public static testmethod void CmmTest()
    {
     Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
           
    
    UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'stand1t', Email='testU2ser1@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='test3se34r2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj){
         
         
         test.starttest();
         
          Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'タンタンンタ',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
         Vehicle__c   vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000);
            insert vehicleObj;
            
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
        Vehicle_Relationship__c  vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Contact__c =accobj1.id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
        insert vehicleRelationshipObj;
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
    
   Retail_Task__c ret = new Retail_Task__c();
    ret.market__c='JP';
    ret.Account__c = accobj1.id;
    ret.Supporting_Dealer__c = DealerAccount.id;        
    insert ret;  
        
        Retail_Campaign__c   rc = new Retail_Campaign__c(RecordTypeId =RTId,Parent_Campaign__c=camobj1.id,Dealer_Name__c = DealerAccount.Id,Child_Campaign_Status__c='Planning',Campaign_Execution_Channels__c = 'eEmail', Apply_Status__c = 'Approved');
                   insert rc; 
        
         Campaign_Member__c  cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj1.id;
    cm.Status__c = 'Ready';
        cm.Retail_Campaign_Id__c=rc.id;
       cm.Created_By_CSV__c=true; 
        cm.market__c='JP';
        cm.Vehicle_Relationship__c=vehicleRelationshipObj.id;
    cm.contact_Id__c = accobj1.Id;  
    cm.Contract__c=ret.id;
     
    insert cm;   
     CorrectCampaignMemberDataCSV dbs=new CorrectCampaignMemberDataCSV(rc.id);
     database.executeBatch(dbs,1);   
        test.stopTest();
        }
        
    }

}
