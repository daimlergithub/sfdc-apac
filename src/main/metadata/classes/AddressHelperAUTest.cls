@isTest
public class AddressHelperAUTest{
    
    private static Account account;
    private static Address__c address,address2;
    private static List<Address__c> addressList=new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
       //create test data
       Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User'+System.Today(),Market__c='AU',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',
	   UserName= System.now().millisecond() + 'testAUUse1@Daimler-test.com');
       insert user1;
       System.runAs (user1) {  
   
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerAU',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
        upsert TriggerAddress;
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
         cs.DEFAULT_CALLOUT_TIME__c='1000';
         cs.MAX_CALLOUT_TIME__c='5000';
         cs.Name='CalloutValues';
         insert cs;
        
         
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        account= new Account();
        account.Phone='09844650654';
        account.Name = 'Test';        
        account.MBK_Data_Source__c ='Email';
        account.Data_Source__c  = 'Test4';
        account.Dealer_Rollout_Status__c = 'Done';
      //  account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);        
       account.RecordTypeId   = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert account;
      
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
        address.Preferred__c = true;
        address.country__c = 'Australia';
         address.State_City__c = 'NSW';
        address.ZipCode__c = '2345';
        addressList.add(address);
        DMLManagerService.insertAsSystem(addressList);
        //insert address;
        
        address2=new Address__c();
        address2.Address_Type__c='Home';
        address2.Province__c='test1';
        address2.City__c='bangalore';
        address2.District__c='test2';
        address2.Block__c='test3';
        address2.Address_Line_1__c='testaddress1';
        address2.Address_Line_2__c='testaddress2';
        address2.Customer__c=account.id;
        address2.TitleOfHonor__c = 'To Person'; 
        address2.Preferred__c = true;
        address2.country__c = 'Australia';
        address2.ZipCode__c = '12345';
        string MarketDiscriminator='AU'; 
        string updateType='';
        try{
            insert address2;
        }catch(Exception e){}
        
        account.Primary_Address_Reference__c=address.id;
        update account;
        map<id,Address__c> addressOldMap=new map<id,Address__c>();
        addressOldMap.put(address.id,address);
        test.startTest();
        TriggerRecursiveCheck.run = true;
        
        try{
        // update address;
         AddressHelperAU.updateAddressOnAccount(addressList);
         AddressHelperBase.updatemarket(addressList); 
         AddressHelperAU.updatePrimaryAddressOnAccount(addressOldMap);
         AddressHelperAU.validateSameAddressType(addressList,addressOldMap,true,true);
         addressList[0].Address_Type__c='Business';
         DMLManagerService.updateAsSystem(addressList);
         AddressHelperAU.updateAccountonDeletion(addressList);
         AddressHelperAU.updateAddressCDM(addressList,MarketDiscriminator,updateType);
         delete address;
        }catch(Exception e){}
        test.stopTest();
        account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
       }
       }
    }