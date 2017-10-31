@isTest
public class CampaignMemberDisributionTest { 

public static Campaign camobj;
       public static Campaign camobj1;
       public static Account accobj;
      
      public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

static testmethod void campaignDistribution ()
   {
   
   
   Test.startTest();
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
     insert camobj1;
     
     Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer;
     Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer1;
     
     Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Campaign_ID__c = camobj1.id;
     camMem.Status__c = 'Ready';
     camMem.Preferred_Dealer__c=dealer.id;

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj1.id;
     camMem1.Status__c = 'Ready';
     camMem1.Preferred_Dealer__c= dealer1.id;

      insert camMem1;
      
   
     
     
     //List<Participating_Dealer__c> pdList = New List<Participating_Dealer__c>();
     
   
   Participating_Dealer__c pd=new Participating_Dealer__c();
        pd.Campaign__c=camobj1.id;
        pd.Dealer__c=dealer.id;
        //pdList.add(pd);
        insert pd;
        
      Participating_Dealer__c pd1=new Participating_Dealer__c();
        pd1.Campaign__c=camobj1.id;
        pd1.Dealer__c=dealer1.id;
        //pdList.add(pd);
        insert pd1;  
        
        
  
   //ConsolidationContorller controller = new ConsolidationContorller();
   //controller.paDealer= pdList;
       String campId = camobj1.Id; 
           CampaignMemberDisribution.cmDistributionToDealer(campId);
   //controller.cmDistributionToDealer(camobj1.id);
   
   
   test.stopTest();





   
   
   
   
   
   }



}