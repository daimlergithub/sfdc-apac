@isTest
public class ShareALLRecordsToNewUserBatchTest {
   private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
   final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    public static testMethod void ShareALLRecordsToNewUserBatchTest1()
    {
        UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj)
        {    
            
          Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
          dealer.Dealer_Nd_code__c='abcd';
          update dealer;  
          // create a Contact
        
          Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
          insert con;
        
        //create user  
       
        Profile DealerDelegated = [select Id from Profile where Name = 'Japan Dealer Company Manager' limit 1];
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser@Daimler-test.com',
             
            FirstName = 'firstname',
            ProfileId = DealerDelegated.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id,
            Market__c='JP'
        );
        insert usr;    
        Group g = new Group(name='abcd');
        insert g ;   
        Date todaydate=System.today();
       Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       List<Account> AccList= new list<Account>();     
        Account personAccount =  new Account(FirstName='刈乾冠寒刊勘',LastName='刈乾冠寒刊勘',Md__c='JP', Individual_Home_Phone__c='046234824', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        //insert personAccount;
       Account Dealer1 = new Account(Dealer_ND_Code__c='abcd',Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '0000000000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer1);    
       insert AccList;     
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer1.Id,Md__c='JP',fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      //insert accLink;      //Vehicle_External_Link
      Account_Link__c  accLink1 = new Account_Link__c(toRole__c =personAccount.Id,fromRole__c = Dealer1.Id,Retail_Delete_Flag__c = false,Retail_Duplicate_Flag__c = false,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      //insert accLink1;      //Vehicle_External_Link
      ALList.add(accLink);
      ALList.add(accLink1);
      insert ALList;    
       Lead__c lead1 = new Lead__c();
       //lead.Contact__c = personAccount.Id;
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
        List<lead__c> leadList= new List<lead__c>();   
        leadList.add(lead1);    
        Case c3 = new Case( AccountId = personAccount.Id, RecordTypeId = CHRecordtypeid,Problem1__c='ttt', Case_Dealer__c = dealer1.Id);
        insert c3;
        List<Case> Caselist=new List<Case>();    
        Caselist.add(c3);    
        List<AccountShare> aslist = new List<AccountShare>();   
            List<ID> userIdLst = new List<ID>();
           userIdLst.add(usr.id); 
           String sobjectNameStr='User';
           string md='JP';
           String sobjectNameStr1='Account_Link__c';
           String sobjectNameStr2='Vehicle_Relationship__c'; 
           String sobjectNameStr3='Lead__c';
           String sobjectNameStr4='Case'; 
             test.startTest();
            try{
             ShareALLRecordsToNewUserBatch  batcher = new ShareALLRecordsToNewUserBatch (userIdLst,sobjectNameStr,md);           
             Database.executeBatch(batcher, 300);
             aslist = [Select id from AccountShare limit 1];
             system.assertNotEquals(null, aslist[0].id);
             ShareALLRecordsToNewUserBatch  batcher1 = new ShareALLRecordsToNewUserBatch (userIdLst,sobjectNameStr1,md);           
             Database.executeBatch(batcher1, 300);
             ShareALLRecordsToNewUserBatch  batcher2 = new ShareALLRecordsToNewUserBatch (userIdLst,sobjectNameStr2,md);           
             Database.executeBatch(batcher2, 300);   
             ShareALLRecordsToNewUserBatch  batcher4 = new ShareALLRecordsToNewUserBatch (userIdLst,sobjectNameStr4,md);           
             Database.executeBatch(batcher4, 300);
             ShareALLRecordsToNewUserBatch  batcher3 = new ShareALLRecordsToNewUserBatch (userIdLst,sobjectNameStr3,md);           
             Database.executeBatch(batcher3, 300); 
             batcher3.execute(null,leadList);
             //system.assertEquals(campaignMemberObj.Service_Advisor__c ,accLink.Service_Advisor__c)  ;     
             }catch(Exception e)
             { }
             test.stopTest();
        }
        
    }
    

}