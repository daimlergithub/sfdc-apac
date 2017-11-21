@isTest
public with sharing class UtilCampaignTaskGenerationByVehicleTest {
    private static Campaign top;
    private static Account account2;
    public static User usr;
    public static User u ;
    private static Contact contact;
    private static  Template__c temp;
    private static String Started='Started';
    private static String send='send';
    private static String topTemplateTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('eDM').getRecordTypeId();
    private static String topTemplateSMSTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
     private static String topTemplateMMSTypeId = Schema.SObjectType.Template__c.getRecordTypeInfosByName().get('MMS').getRecordTypeId();
     private static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    private static String  accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
    private static void createAccount(){
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        u = new User(Alias = 'standt', Email='test@mbj.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
        
        account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    PersonMobilePhone='5879875698',
                                    Phone = '080801011',
                                    Area_Code__c = '010',            
                                    lastName = 'Beijing XING Limited',
                                    ZipCode__c='1004324',
                                    Salutation='Brother',Mobile__c ='01234567897',
                                    FirstName='TestName',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',
                                    RecordTypeId=accPerson_RecordTypeIdp);
                                    insert account2;  
        Account companyAcc= new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
      
         insert companyAcc;
        contact = new Contact(
          AccountId = companyAcc.Id, 
          LastName = 'b', 
          Phone = '1212313', 
          MobilePhone='1236547890',
          email = 's@s.s',
          DUP_Number__c='test dup'
        );
        insert contact;

        
    }

    private static void createUser(){
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
                usr.Active__c = true;
               
            }
            
            insert usr;
        
    
        
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
         
       System.runAs(u) { 
           
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111112',
                                                UsVIN__c = '12345678902222221',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
       
         
        

       
         top = new Campaign(           
            Name = 'top', 
            Status = Started, 
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
            Status = send
        );
            insert topMember;
        List<CampaignMember> Listcampmember= new List<CampaignMember>(); 
        Listcampmember.add(topmember);        
        
       
          Id jobId;
        //start trest
         test.startTest();
        system.debug('!!!!!! Integraion user '+ usr.id);
          UtilCampaignTaskGenerationByVehicle  batcher= new UtilCampaignTaskGenerationByVehicle(listCampaign,jobId);
          Database.executeBatch(batcher);          
          batcher.execute(null,listcamp);
        
           test.stopTest();
          
        
        //verify
        list<Task> objTask =[select Activity_Status__c,Campaign_Member_ID__c,ActivityDate,WhoId,WhatId,Campaign_Name__c from Task where Campaign_Name__c = 'top' Limit 1];
        system.assertEquals(objTask[0].Campaign_Name__c, 'top');
        system.assertEquals(objTask[0].Activity_Status__c, 'not started');
        system.assertEquals(objTask[0].WhatId,top.id);

        }
        
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle1() {
        //create test data
        
      createUser();         
      createAccount(); 
      System.runAs(u) {                   
      DM_Material__c objDM = new DM_Material__c(Name='newDB',Type__c='Price List');insert objDM;
         
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111113',
                                                UsVIN__c = '12345678902222225',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top5', 
            Status = Started, 
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
            Status = send
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
        list<Task> objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask[0].ActivityDate, system.today());
          system.assertEquals(objTask[0].WhatId,top.id);

        }
        }
    public static testMethod void testUtilCampaignTaskGenerationByVehicle2() {
        //create test data
        
      createUser();         
      createAccount();                     
      createTemplate();
       System.runAs(u) { 
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111119',
                                                UsVIN__c = '12345678902222226',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
       
       
         top = new Campaign(           
            Name = 'top3', 
            Status = Started, 
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
            Status = send
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
         list<Task> objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask[0].ActivityDate, system.today());
          system.assertEquals(objTask[0].WhatId,top.id);

        }
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle3() {
        //create test data
        
     createUser();         
      createAccount();                     
      createTemplate1();
       System.runAs(u) {
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111114',
                                                UsVIN__c = '12345678902222223',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top2', 
            Status = Started, 
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
            Status = send
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
        list<Task> objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          system.assertEquals(objTask[0].ActivityDate, system.today());
          system.assertEquals(objTask[0].WhatId,top.id);
       
        }
        }
     public static testMethod void testUtilCampaignTaskGenerationByVehicle4() {
        //create test data
        
      createUser();         
      createAccount();                     
      createTemplate2();
      System.runAs(u) {
       Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                insert vehicles;         
                     
                    
       List<Vehicle_Relationship__c> listcamp =new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c ob1Member = new Vehicle_Relationship__c(Vehicle_ID__c=vehicles.id,Contact__c=account2.id);
       insert ob1Member;
       listcamp.add(ob1Member);
           
         
        
      
       
         top = new Campaign(           
            Name = 'top1', 
            Status = Started, 
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
            Status = send
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
        list<Task> objTask =[select ActivityDate,Campaign_Member_ID__c,WhoId,WhatId,Campaign_Name__c from Task Limit 1];
          
          //system.assertEquals(objTask[0].ActivityDate, system.today());
          //system.assertEquals(objTask[0].WhatId,top.id);

         }
        }
     }