@isTest
public class EmailNotificationAfter24HoursTest{
 private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
 private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
 private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
    
    User user2 = new User(LastName='GEORGE',managerid=user1.id,country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
    
    System.runAs (user2) {
    test.starttest();
        set<id> accid=new set<id>();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = user1.Id;
        dealer.Smart_Account_Owner__c = user1.Id;
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'english';
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
        dealer.Dealer_Sales_Manager_Email__c='dhanamjaya1.d@infosys.com';
        dealer.Dealer_Aftersales_Manager_Email__c='dhanamjaya.d@infosys.com';
       insert dealer;
       
       Account perAcc= new Account();
        perAcc.Allow_Data_Sharing__c = 'yes'; 
        perAcc.Province__c = 'jiangsu'; 
        perAcc.City__c = 'nanjing';
        perAcc.Preferred_Language__c = 'english';
        perAcc.Dealer_Lead_System__c = 'salesforce';
        perAcc.LastName = 'Customer';
        perAcc.Gender__c = '0=Male';
        perAcc.ZipCode__c = '2002351';
        perAcc.Type = '0=Company';
        perAcc.Phone = '01233214'; 
        perAcc.Status__c = '0=Customer';
        perAcc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        perAcc.Dealer_Lead_Gate_Keeper__c = user1.Id;
        perAcc.Area_Code__c = '030';
       
        insert perAcc;

       List<String> li=new List<String>();
       Lead__c lead = new Lead__c();
        lead.Contact__c = perAcc.Id;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.md__c='TH';
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;
        system.debug('hello rajesh'+lead);
        Lead__c l=[select id,RecordTypeID,lead_desired_service__c,name,assigned_dealer__r.Dealer_Aftersales_Manager_Email__c,assigned_dealer__r.Dealer_Sales_Manager_Email__c,ownerId from Lead__c where id=:lead.id];
        li.add(l.id);
        
        EmailNotificationAfter24Hours.SendEmails(li);
         Lead__c lead1 = new Lead__c();
        lead.Contact__c = perAcc.Id;
       
        lead1.CAC_Lead_Status__c = 'Qualified';
        lead1.Lead_Type__c = 'New Car';
        lead1.Relation_With_The_Leads__c = 'testR';
        lead1.Lead_Desired_Service__c = 'SERVICE BOOKING';
        lead1.Purchase_Time__c = '0 - 3 months';
        lead1.Interested_Vehicle_Brand__c = 'testI';
        lead1.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead1.Trade_In_Vehicle_Brand__c = 'c230';
        lead1.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead1.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead1.Interested_Vehicle_Brand__c = 'Smart';
        lead1.md__c='TH';
        lead1.RecordTypeId=afterSalesRecordTypeId;
        lead1.Assigned_Dealer__c = dealer.Id;
        insert lead1;
         Lead__c l1=[select id,RecordTypeID,lead_desired_service__c,name,assigned_dealer__r.Dealer_Aftersales_Manager_Email__c,assigned_dealer__r.Dealer_Sales_Manager_Email__c,ownerId from Lead__c where id=:lead1.id];
        List<String> li1=new List<String>();
        li1.add(l1.id);
        EmailNotificationAfter24Hours.SendEmails(li1);
        system.assertEquals([select id from lead__c where id=:lead1.id].size(),1); 
    
         Lead__c lead2 = new Lead__c();
        lead.Contact__c = perAcc.Id;
        lead2.CAC_Lead_Status__c = 'Qualified';
        lead2.Lead_Type__c = 'New Car';
        lead2.Relation_With_The_Leads__c = 'testR';
        lead2.Lead_Desired_Service__c = 'BOOKING';
        lead2.Purchase_Time__c = '0 - 3 months';
        lead2.Interested_Vehicle_Brand__c = 'testI';
        lead2.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead2.Trade_In_Vehicle_Brand__c = 'c230';
        lead2.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead2.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead2.Interested_Vehicle_Brand__c = 'Smart';
        lead2.md__c='TH';
        lead2.RecordTypeId=afterSalesRecordTypeId;
        lead2.Assigned_Dealer__c = dealer.Id;
        insert lead2 ;
        
        List<String> li2=new List<String>();
        li2.add(lead2.id);
        EmailNotificationAfter24Hours.SendEmails(li2);
        Test.stopTest();
    }
    
    }


}