/*
    Type:      class
    Purpose:   Test class for AddressHelperJp
    Create By: Sriram kalluri
*/
@isTest
public class AddressHelperJPTest {
     private static Account account;
     private static Address__c address;
     private static User user1;
     private static  profile ProfileAdmin = [select Id from Profile where Name = 'System Administrator'];
     public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
     public static List<Address__c> addresslist =new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
       //create test data
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser1@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = ProfileAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            Market__c= 'KR'
        );
        system.runAs(usr){
       Address__c address1=new Address__c();
        address1.Address_Type__c='Bussiness';
        address1.Province__c='test1';
        address1.City__c='bangalore';
        address1.District__c='test2';
        address1.Block__c='test3';
        address1.Address_Line_1__c='testaddress1';
        address1.Address_Line_2__c='testaddress2';
        address1.Customer__c=account.id;
        address1.TitleOfHonor__c = 'To Person';
        address1.preferred__c = true;
        insert address1;
        }
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
        vehicle_relationship__c vrship = new Vehicle_Relationship__c(Contact__c=account.Id, vehicle_address__c = address.id);
        insert vrship;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
       try{
       insert al;}catch(Exception e){}
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
           
       }
         public static testMethod void testUpdatePrimaryAddressOnAccount1(){
         
        
       
        User u =[select id,name from user where profile.name='IntegrationAPI' and Isactive=true limit 1];
        
        system.runas(u){
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        
        account= new Account();
        account.Phone='09844650654';
        account.FirstName = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
        
      
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='test1';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
        
        addresslist.add(address);
        newmap.putAll(addresslist);
        account.Primary_Address_Reference__c=address.id;
        update account;
        
         Account_Link__c al=new Account_Link__c(Name='new al',
          //toRole__c=account.id,
          fromRole__c=account.id,
          Retail_Address_Reference__c=addresslist[0].id,
         RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
    try{
       insert al;}catch(Exception e){}
         //start test        
        test.startTest();
        address.Address_Type__c='Business';
        try{
         update address;}catch(Exception e){}
         delete address;
        test.stopTest();
        
        //verify
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        //system.assertEquals(account.Primary_Address_Display__c, address.Province__c+address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c+address.Address_Line_2__c);
          } 
       }
        Public static testmethod void afterInsetAddressUpdateRetailPersonTest()
        {
        profile p=[select id from Profile where name='Japan Dealer Company Manager'];
        
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser1@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = p.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id
        );
        
        insert usr;
        System.runAs(usr){
        Account  personAcc = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = '刈乾冠寒刊勘',
                               FirstName = '刈乾冠寒刊勘',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '023482832',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               MD__c = 'JP',
                               Industry = 'Other',
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       insert personAcc;
       
        List<Address__c> addlist=new List<Address__c>();
        
        Address__c add=new Address__c();
        add.Customer__c=personAcc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        add.MD__c='JP';
        add.RecordTypeId= Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
      addlist.add(add);
        //insert addlist;
       Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=personAcc.id,Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
         Test.Starttest(); 
         AddressHelperJP.afterInsetAddressUpdateRetailPerson(addlist);
           Test.Stoptest();
        
        }
      
       }
       
        Public static testmethod void afterInsetAddressUpdateRetailPersonTest2()
        {
        profile p=[select id from Profile where name='Japan Dealer Company Manager'];
        
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        
        Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
        
        User usr = new User(
            Username = System.now().millisecond() + 'testDaimlerUser1@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = p.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ContactId=con.id
        );
        
        insert usr;
        System.runAs(usr){
        Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '024482832',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                OwnerId = usr.id,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
       insert personAcc;
       
        List<Address__c> addlist=new List<Address__c>();
        
        Address__c add=new Address__c();
        add.Customer__c=personAcc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        add.MD__c='JP';
        add.RecordTypeId= Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
      addlist.add(add);
        insert addlist;
        add.Address_Type__c='Home';
        newmap.putAll(addlist);
        
       // update account;
       Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=personAcc.id, Retail_LastName__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female');
        insert al1;
        
        
         Test.Starttest(); 
         AddressHelperJP.afterInsetAddressUpdateRetailPerson(addlist);
         AddressHelperJP.afterUpdateVehicleRelationship(addlist,newmap);
           Test.Stoptest();
        
        }
      
       }
       public static testMethod void beforeupdateEventAddressTestNew(){
           
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Dealer_Rollout_Status__c = 'Done',Phone ='09874760605');
            insert accobj1;
            
             Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c = 'Done');
            insert accobj2;
             list<Account_Link__c> listcampaigns=new list<Account_Link__c>();
             
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='tokyo';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
          
           Map<Id, Address__c> mapAddress = New Map<Id,Address__c>();
           mapAddress.put(address1.id,address1);
       
           List<Account_Link__c> listcampaigns1=new List<Account_Link__c>();
           
           Account_Link__c al1= new Account_Link__c(Name='new al',toRole__c=accobj1.id,fromRole__c=accobj2.id,Retail_Preferred_Language__c='English',Retail_Company_Name__c='heii',Retail_Full_Name__c='saranya Gotrala',Retail_Full_Name_Title__c='Mrs',Retail_FirstName__c='Saru',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Retail_DMS_Customer_ID__c='1122',Retail_Gender__c='Female',Retail_Address_Reference__c=address1.id,Retail_Province__c='akira');
            
            
           listcampaigns1.add(al1);
           insert listcampaigns1;
           
           Account_Link__c listCampaign =[select Name,toRole__c,Retail_Gender__c,RecordTypeId,fromRole__c,Retail_UCID__c,Retail_LastName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,Retail_Full_Name_Native__c,Retail_FirstName__c,Retail_LastName_Native__c,Retail_FirstName_Native__c,Retail_Company_Name__c,Retail_Company_Name_Native1__c,Retail_Preferred_Language__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Vat_No__c,Retail_Commercial_Reg_No__c,Retail_Foundation_Month__c,Retail_Website__c,Retail_Industry__c,Retail_Primary_Phone__c,Retail_Allow_Data_Sharing__c,Retail_Delete_Flag__c,Retail_Duplicate_Flag__c,Retail_Email__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Mobile__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Related_Company__c,Retail_Position__c from Account_Link__c where id IN:listcampaigns1 ];
           list<Account_Link__c> oldList = new  list<Account_Link__c>();
           oldList.add(listCampaign);
           map<id,Account_Link__c> oldMap = new map<id,Account_Link__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           al1.Retail_Company_Name__c='Sai';
           update al1;
           update listcampaigns1;
          
          
         // AccountLinkHelper.getRelatedIndividualCustomerRecordTypeAccountLink(listcampaigns1);
                 al1.Retail_Preferred_Language__c='Japan';
           update al1;
           update listcampaigns1;
           
           AddressHelperJP.updateAccountlinks(mapAddress);
           
          
       }
       
    }