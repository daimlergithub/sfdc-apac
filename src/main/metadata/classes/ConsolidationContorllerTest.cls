@isTest
public class ConsolidationContorllerTest  {

       public static Campaign camobj;
       public static Campaign camobj1;
       public static Account accobj;
      
      public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

static testmethod void contorller()
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
     
     
     Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Campaign_ID__c = camobj1.id;
     camMem.Status__c = 'Ready';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj1.id;
     camMem1.Status__c = 'Ready';

      insert camMem1;
      
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

      
     
      Account dealer = new Account(RecordTypeId=dealerRecordtypeid,Name='acme23',MBK_Data_Source__c='Email',Mobile__c='00000009842',Dealer_Sales_Manager_Email__c='test1@gmail.com');
     insert dealer;
     
     
     
     List<Participating_Dealer__c> pdList = New List<Participating_Dealer__c>();
     
   
   Participating_Dealer__c pd=new Participating_Dealer__c();
        pd.Campaign__c=camobj1.id;
        pd.Dealer__c=dealer.id;
        pdList.add(pd);
        insert pd;
        
        
        Dealer_List_Member__c dlm = New Dealer_List_Member__c();
        dlm.Campaign__c=camobj1.id;
        dlm.Participating_Dealer__c = pd.id;
        dlm.Campaign_Member__c = camMem.id;
        insert dlm;
        
        Dealer_List_Member__c dlm1 = New Dealer_List_Member__c();
        dlm1.Campaign__c=camobj1.id;
        dlm1.Participating_Dealer__c = pd.id;
        dlm1.Campaign_Member__c = camMem.id;
        dlm1.List_Maintenance_CM_Status__c = 'Removed';
        insert dlm1;
        
        Dealer_List_Member__c dlm2 = New Dealer_List_Member__c();
        dlm2.Campaign__c=camobj1.id;
        dlm2.Participating_Dealer__c = pd.id;
        dlm2.NewAccount__c = accobj.id;
        dlm2.List_Maintenance_CM_Status__c = 'New';
        insert dlm2;
        
       PageReference pageRef = Page.Consolidation_List; 
      Test.setCurrentPage(pageRef);
   pageRef.getParameters().put('id',camobj1.id);
  //ApexPages.StandardController sc = new ApexPages.standardController(camobj1);
   ConsolidationContorller controller = new ConsolidationContorller();
   //controller.paDealer= pdList;
   
   controller.consolidationMaintenance();
   
   
   test.stopTest();




//Test.startTest();
    // ConsolidationContorller.consolidationMaintenance(camobj1,pd,camMem1);
   
    // Test.stopTest();
   
   
   
   
   
   }



}