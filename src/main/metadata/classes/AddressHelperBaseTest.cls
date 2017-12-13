@isTest
public class AddressHelperBaseTest {

    private static Account account;
    private static Address__c address,address2,address3;
    private static List<Address__c> addressList=new List<Address__c>();

    
    public static testMethod void testAddressHelperBase(){
       //create test data
       Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User'+System.Today(),Market__c='MY',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
       insert user1;
       System.runAs (user1) { 
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
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
        address.Preferred__c = true;
        address.country__c = 'Malaysia';
        address.ZipCode__c = '12345';
        addressList.add(address);
        DMLManagerService.insertAsSystem(addressList);
        
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
        address2.country__c = 'Malaysia';
        address2.ZipCode__c = '12345';
        
        try{
            insert address2;
        }catch(Exception e){}
        
        account.Primary_Address_Reference__c=address.id;
        update account;
       
        test.startTest();
        TriggerRecursiveCheck.run = true;
        address.Address_Type__c='Business';
        map<id,Address__c> addressOldMap=new map<id,Address__c>();
        addressOldMap.put(address.id,address);
        string MarketDiscriminator='MY'; 
        string updateType='';
        string Market='MY';
        
        try{
         AddressHelperBase.updateAddressOnAccount(addressList);
         AddressHelperBase.updatemarket(addressList); 
         AddressHelperBase.updatePrimaryAddressOnAccount(addressOldMap);
         AddressHelperBase.validateSameAddressType(addressList,addressOldMap,true,true,market);
         addressList[0].Address_Type__c='Business';
         DMLManagerService.updateAsSystem(addressList);
         AddressHelperBase.updateAccountonDeletion(addressList);
         AddressHelperBase.updateAddressCDM(addressList,MarketDiscriminator,updateType);
        }catch(Exception e){}
        test.stopTest();
       }
    }
    
}