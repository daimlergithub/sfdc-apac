/*
Type:     Test  class
Create By: Sravanthi Gudibandi
Purpose: To test address helper India
*/
@isTest
public class AddressHelperINTest{
    
    private static Account account;
    private static Address__c address,address2;
    private static List<Address__c> addressList=new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
        //create test data
        User user1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs (user1) {  
            
            Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
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
            //  sysSet.Name=p1.Name;
            DMLManagerService.insertAsSystem(sysSet);
            
            account= new Account();
            account.Phone='+911234567890';
            account.FirstName = 'Test';        
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
            address.Preferred__c = true;
            address.market__c = 'IN';
            address.country__c = 'India';
            address.ZipCode__c = '123456';
            addressList.add(address);
            DMLManagerService.insertAsSystem(addressList);
            
            address2=new Address__c();
            address2.Address_Type__c='Home';
            address2.Province__c='test1';
            address2.City__c='bangalore';
            address2.District__c='test2';
            address2.Address_Line_1__c='testaddress1';
            address2.Address_Line_2__c='testaddress2';
            address2.Customer__c=account.id;
            address2.Preferred__c = true;
            address2.country__c = 'India';
            address2.ZipCode__c = '123450';
            string MarketDiscriminator='IN'; 
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
                AddressHelperIN.updateAddressOnAccount(addressList);
                AddressHelperIN.updatePrimaryAddressOnAccount(addressOldMap);
                AddressHelperIN.validateSameAddressType(addressList,addressOldMap,true,true);
                addressList[0].Address_Type__c='Business';
                DMLManagerService.updateAsSystem(addressList);
                AddressHelperIN.updateAccountonDeletion(addressList);
                AddressHelperIN.updateAddressCDM(addressList,MarketDiscriminator,updateType);
                delete address;
            }catch(Exception e){}
            
            System.assertEquals(address.Market__c, 'IN');
            test.stopTest();
        }
    }
}