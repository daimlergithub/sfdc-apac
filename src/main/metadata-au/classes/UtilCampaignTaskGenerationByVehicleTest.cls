@isTest
public class UtilCampaignTaskGenerationByVehicleTest {
    private static Campaign top;
    private static Account account2;
    private static User usr;
    private static Contact contact;
    private static  Template__c temp;
    private static String topTemplateTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    private static String topTemplateSMSTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
     private static String topTemplateMMSTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
     private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
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
         Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        dealer.Email__c='test@mbau.com';
                    dealer.Email2__c = 'testemail2@test.com';
                    dealer.Home_Phone_2__c = '98765413';
        update dealer;
         contact = new Contact(
            AccountId = dealer.Id, 
            LastName = 'ba', 
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
        temp.RecordTypeId=topTemplateSMSTypeId;
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test3';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Folding';
        temp.ValidTimeHrs__c=2;
        insert temp;
    }
    private static void createTemplate2(){
         
        temp=new Template__c();
        temp.RecordTypeId=topTemplateMMSTypeId;
        temp.Active__c=true;
        temp.AnalyzeRequired__c=true;
        temp.Closure_SMS__c='test4';
        temp.Subject__c='Helloo';
        temp.Template_ID__c='test1234';
        temp.Type__c='Presents';
        temp.ValidTimeHrs__c=2;
        insert temp;
    }

    public static testMethod void testUtilCampaignTaskGenerationByVehicle() {
        //create test data
        
      createUser();         
      createAccount();                     
                    
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111112',
                                                UsVIN__c = '12345678902222221');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
       
         
        

       
         top = new Campaign(           
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Execution_Type__c ='OB Call',
           
            RecordTypeId = topCampRecordTypeId
        );
        insert top;
        List<Campaign> listCampaign = new  List<Campaign>();
        listCampaign.add(top);
            
        
                
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id, 
            Vehicle_Case_ID__c=ob1Member.id,
            Status = 'Send'
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
          test.startTest();
        
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
          test.stopTest();
        
        //verify
        Task objTask =[select Activity_Status__c,Campaign_Member_ID__c,ActivityDate,WhoId,WhatId,Campaign_Name__c from Task where Campaign_Name__c = 'top' Limit 1];
        system.assertEquals(objTask.Campaign_Name__c, 'top');
        system.assertEquals(objTask.Activity_Status__c, 'not started');
        system.assertEquals(objTask.WhatId,top.id);

         
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle1() {
        //create test data
        
      createUser();         
      createAccount();                     
      DM_Material__c objDM = new DM_Material__c(Name='newDB',Type__c='Price List');insert objDM;
         
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111113',
                                                UsVIN__c = '12345678902222225');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top5', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            DM_Material__c=objDM.id,
            Execution_Type__c ='DM',
           
            RecordTypeId = topCampRecordTypeId
        );
        insert top;
        List<Campaign> listCampaign = new  List<Campaign>();
        listCampaign.add(top);
            
        
                
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id, 
            Vehicle_Case_ID__c=ob1Member.id,
            Status = 'Send'
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
          test.startTest();
        
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
          test.stopTest();
        
        //verify
        Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask.ActivityDate, system.today());
          system.assertEquals(objTask.WhatId,top.id);

         
        }
    public static testMethod void testUtilCampaignTaskGenerationByVehicle2() {
        //create test data
        
      createUser();         
      createAccount();                     
      createTemplate();
         
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111119',
                                                UsVIN__c = '12345678902222226');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
       
       
         top = new Campaign(           
            Name = 'top3', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Template__c=temp.id,
            Execution_Type__c ='eDM',
           
            RecordTypeId = topCampRecordTypeId
        );
        insert top;
        List<Campaign> listCampaign = new  List<Campaign>();
        listCampaign.add(top);
            
        
                
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id, 
            Vehicle_Case_ID__c=ob1Member.id,
            Status = 'Send'
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
          test.startTest();
        
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
          test.stopTest();
        
        //verify
         Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask.ActivityDate, system.today());
          system.assertEquals(objTask.WhatId,top.id);

         
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle3() {
        //create test data
        
      createUser();         
      createAccount();                     
      createTemplate1();
         
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111114',
                                                UsVIN__c = '12345678902222223');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top2', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Template__c=temp.id,
            Execution_Type__c ='SMS',
           
            RecordTypeId = topCampRecordTypeId
        );
        insert top;
        List<Campaign> listCampaign = new  List<Campaign>();
        listCampaign.add(top);
            
        
                
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id, 
            Vehicle_Case_ID__c=ob1Member.id,
            Status = 'Send'
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
          test.startTest();
        
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
          test.stopTest();
        
        //verify
        Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask.ActivityDate, system.today());
          system.assertEquals(objTask.WhatId,top.id);

         
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle4() {
        //create test data
        
      createUser();         
      createAccount();                     
      createTemplate2();
         
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top1', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            Template__c=temp.id,
            Execution_Type__c ='MMS',
           
            RecordTypeId = topCampRecordTypeId
        );
        insert top;
        List<Campaign> listCampaign = new  List<Campaign>();
        listCampaign.add(top);
            
        
                
         CampaignMember topMember = new CampaignMember(
            CampaignId = top.Id,
            ContactId = contact.Id, 
            Vehicle_Case_ID__c=ob1Member.id,
            Status = 'Send'
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
          test.startTest();
        
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
          test.stopTest();
        
        //verify
        Task objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask.ActivityDate, system.today());
          system.assertEquals(objTask.WhatId,top.id);

         
        }
       }