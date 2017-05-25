@isTest
public class AddToRetailCampaignControllerTet
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    final static String INQUIRYRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    static Account acc;
    final static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    final static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
    static Vehicle__c ve1; 
    static Vehicle__c ve2;
    static Vehicle_Relationship__c vrData1; 
    static Vehicle_Relationship__c vrData2;
    static  Community_License_Switch__c cls;
    static Account dealer;
    public Static String ErrorMessageInvalidId = 'Invalid Case Id.';
     static void preparedTestData()
      {
         //List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         //insert updatecustomsettings;
         Trigger__c TriggerDMR=new Trigger__c(Name='TriggerAccount',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerJP',update__c=false,insert__c=false,delete__c=false,after__c=false,before__c=false,enabled__c=false,Market__c='JP');
        upsert TriggerDMR;
         cls=new Community_License_Switch__c();
         cls.Enable__c=true;
         cls.name='Community Enabled';
         insert cls;
         list<Account> lstAccount=new List<Account>();
         acc= new Account(LastName='acme', Phone='011111222', Area_Code__c = '010',RecordTypeId = personRecordtypeid);
         lstAccount.add(acc);
         dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
         lstAccount.add(dealer);
         insert lstAccount;
         ve1=new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200', EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345');
         ve2=new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B220', EuroVIN__c='11111222222111122', UsVIN__c='11111222222111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345');
         list<Vehicle__c> lstVehicle=new List<Vehicle__c>();
         lstVehicle.add(ve1);
         lstVehicle.add(ve2);
         insert lstVehicle;
         //Added community license switching mechanism
         //creating custom setting  
           
          vrData1 = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='1');
          vrData2 = new Vehicle_Relationship__c(Vehicle_ID__c=ve2.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='1');
                                                  
          list<Vehicle_Relationship__c> lstVehicleRelationship=new List<Vehicle_Relationship__c>();
          lstVehicleRelationship.add(vrData1);
          lstVehicleRelationship.add(vrData2);
          insert lstVehicleRelationship;        
       } 
      
     static testMethod void RetailCampaignTest()
        { 
           preparedTestData();
             
           Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=1 , Campaign_Execution_Channels__c = 'DM');     
           insert rc;        
           User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
           
           User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
            //User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and isActive = true limit 1];
            Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                              Case_SubType__c='Dealer-after sales service attitude', Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id);
            insert c1;
                     
            Test.startTest();              
            PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' + c1.Id);
            Test.setCurrentPage(pr);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
            addRetail.addTo();       
            rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
            Case caselst = [select Case_Status__c,Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
            Test.stopTest();           
            system.assertEquals(caselst.Case_Status__c,'Accepted');            
            system.assert(caselst!=Null);
           
    }
     
     static testMethod void RetailCampaignTestcatchException()
        { 
           preparedTestData();
             
           Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=1,Campaign_Execution_Channels__c = 'DM');     
           insert rc;        
           User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
           
           User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
           Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,Case_SubType__c='Dealer-after sales service attitude',
                              Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id,Case_Status__c = 'Accepted');
            insert c1;
            
            Test.startTest();  
                        
            PageReference pr1  = new PageReference('/apex/AddToRetailCampaign?id='+null);
            Test.setCurrentPage(pr1);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();  
            addRetail.addTo();       
            rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
            Case caselst = [select Case_Status__c,Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
            Test.stopTest();           
            system.assert(caselst!=Null);
    } 
    
    
    static testMethod void RetailCampaignTestupdatecatchexception()
        { 
           preparedTestData();
             
           Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=1,Campaign_Execution_Channels__c = 'DM');     
           insert rc;        
           User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
           
           User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
           Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,Case_SubType__c='Dealer-after sales service attitude',
                               Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id);
           insert c1;
                     
            Test.startTest();              
            PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' + c1.Id);
            Test.setCurrentPage(pr);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
            addRetail.addTo();       
            rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
            Case caselst = [select Case_Status__c,Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
            Test.stopTest();           
            system.assertEquals(caselst.Case_Status__c,'Accepted');            
            system.assert(caselst!=Null);
           
    }


    
    static testMethod void RetailCampaignTestupdatecatchexception1()
        { 
           preparedTestData();
             
           Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=2,Campaign_Execution_Channels__c = 'DM');     
           insert rc;        
           User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
           
           User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user limit 1];
           Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,Case_SubType__c='Dealer-after sales service attitude',
                               Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id);
           insert c1;
                     
            Test.startTest();              
            PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' + c1.Id);
            Test.setCurrentPage(pr);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
            
            addRetail.addTo();       
            rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
            Case caselst = [select Case_Status__c,Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
            Test.stopTest();           
            
           
    }
    
    static testMethod void RetailCampaignTestupdatecatchexception2()
        { 
           preparedTestData();
             
           Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=null,Campaign_Execution_Channels__c = 'DM');     
           insert rc;        
           User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
           
           User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user limit 1];
           Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,Case_SubType__c='Dealer-after sales service attitude',
                               Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id);
           insert c1;
                     
            Test.startTest();              
            PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' + c1.Id);
            Test.setCurrentPage(pr);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
            
            addRetail.addTo();       
           
    }
    static testMethod void RetailCampaignTestupdatecatchexception3()
   {
   
   Test.startTest();              
            PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' );
            Test.setCurrentPage(pr);
            AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
            
            addRetail.addTo();       
            //rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
            //Case caselst = [select Case_Status__c,Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
            //List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
            Test.stopTest();      
   
   }
}