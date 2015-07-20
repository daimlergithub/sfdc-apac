@isTest
public with sharing class UtilCampaignTaskGenerationByLeadsTest {
     private static Campaign top;
    private static string retailLeadType =Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Retail Sales Leads').getRecordTypeId();    
    private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static String topTemplateTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
     private static String topSMSTemplateTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    private static String topEDMTemplateTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    
    private static Template__c temp;
    private static Account dealer;
    private static Account account2;
    private static Contact contact;
    private static Lead__c lead;
        private static User usr;
    private static void createAccount(){
        account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    PersonMobilePhone='5879875698',
                                    Phone = '80801011',
                                    Area_Code__c = '010',            
                                    lastName = 'Beijing XING Services Limited - Alpha Review',
                                    ZipCode__c='100101',
                                    Salutation='Brother',
                                    FirstName='TestName',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413',
                                    RecordTypeId=accPerson_RecordTypeIdp);
                                    insert account2;  
          dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        dealer.Email__c='test@mbau.com';
                    dealer.Email2__c = 'testemail2@test.com';
                    dealer.Home_Phone_2__c = '98765413';
        update dealer;
         contact = new Contact(
            AccountId = dealer.Id, 
            Salutation='Attorney',
             FirstName='testFirstname',
            LastName = 'testLastname', 
            Phone = '1212313', 
            email = 's@s.s'
        );
        insert contact;

        
    }
     private static void createUser(){
        List<User> newUsers = new List<User>();
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs ( thisUser ) {
        
            String[] csrProfiles = new String[]{'IntegrationAPI'};
            List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name In :csrProfiles];
            
            for(Profile p : profileIds){
                 usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                 
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test1';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                newUsers.add(usr);
            }
            
            insert newUsers;
        }
    
        
    }
    
    private static void createLead(){
        lead = new Lead__c();
       lead.Assigned_Dealer__c = dealer.Id;
       lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Allow_Data_Sharing__c=true;
        lead.Relation_With_The_Leads__c = 'test1';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'test2';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'test5';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.RecordTypeId=retailLeadType;
        lead.Contact__c=account2.id;
      // lead.Company_Account__c=dealer.Id;
        insert lead;
    }
 private static void createTemplate(){
         
        temp=new Template__c();
        temp.RecordTypeId=topTemplateTypeId;
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test2';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Price List';
        temp.ValidTimeHrs__c=2;
        insert temp;
    }
     private static void createTemplate1(){
         
        temp=new Template__c();
        temp.RecordTypeId=topSMSTemplateTypeId;
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test2';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Price List';
        temp.ValidTimeHrs__c=2;
        insert temp;
    }
    private static void createTemplate2(){
         
        temp=new Template__c();
        temp.RecordTypeId=topEDMTemplateTypeId;
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test2';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Price List';
        temp.ValidTimeHrs__c=2;
        insert temp;
    }
    

    
     public static testMethod void testUtilCampaignTaskGenerationByLeads1() {
           createUser();         
           createAccount();    
           createLead();
         createTemplate2();
         
           top = new Campaign(           
            Name = 'top', 
            Status = 'Started', 
           Template__c=temp.id,
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='eDM',           
            RecordTypeId = topCampRecordTypeId
          );
          insert top;  
         
           List<Campaign> listCampaign = new  List<Campaign>();
           listCampaign.add(top);
    
          Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true,Campaign__c=top.id);        
          insert ob1Member;
         
          Id jobId;
          test.startTest();
          UtilCampaignTaskGenerationByLeads  batcher= new UtilCampaignTaskGenerationByLeads(listCampaign,jobId);
          Database.executeBatch(batcher);      
          test.stopTest();
         Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
             system.assertEquals(objTask.ActivityDate, system.today());
          
      }
     public static testMethod void testUtilCampaignTaskGenerationByLeads2() {
           createUser();         
           createAccount();    
           createLead();
           createTemplate();
         
           top = new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='MMS', 
            Template__c=temp.id,
            RecordTypeId = topCampRecordTypeId
          );
          insert top;  
         
           List<Campaign> listCampaign = new  List<Campaign>();
           listCampaign.add(top);
    
          Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true,Campaign__c=top.id);        
          insert ob1Member;
         
          Id jobId;
          test.startTest();
          UtilCampaignTaskGenerationByLeads  batcher= new UtilCampaignTaskGenerationByLeads(listCampaign,jobId);
          Database.executeBatch(batcher);      
          test.stopTest();
         Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
             system.assertEquals(objTask.ActivityDate, system.today());
          
      }
     public static testMethod void testUtilCampaignTaskGenerationByLeads3() {
           createUser();         
           createAccount();    
           createLead();
           createTemplate1();
         
           top = new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='SMS', 
            Template__c=temp.id,
            RecordTypeId = topCampRecordTypeId
          );
          insert top;  
         
           List<Campaign> listCampaign = new  List<Campaign>();
           listCampaign.add(top);
    
          Campaign_Lead__c  ob1Member = new Campaign_Lead__c(Lead_DataSource__c='Event',lead__c=lead.id,Task_Generated__c=false,FirstTimeImported__c = true,Campaign__c=top.id);        
          insert ob1Member;
         
          Id jobId;
          test.startTest();
          UtilCampaignTaskGenerationByLeads  batcher= new UtilCampaignTaskGenerationByLeads(listCampaign,jobId);
          Database.executeBatch(batcher);      
          test.stopTest();
         
         Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
             system.assertEquals(objTask.ActivityDate, system.today());
          
          
          
      }
    
    
    
    
       }