@isTest
public class AddresshelperTRTest {
    private static Account acc;
    private static Address__c address,address2;
    private static List<Address__c> addressList=new List<Address__c>();
    
    public static testMethod void testUpdatePrimaryAddressOnAccount(){
        //create test data
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        User user1 = new User(LastName='User'+System.Today(),Market__c='TR',country='Turkey',firstName='Test',ProfileId=p1.Id,Alias='Test',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Test@infosys.com',UserName='Test@infosys.com.asiadevty4'+String.valueof(DateTime.now().getTime()));
        insert user1;
        System.runAs (user1) {  
            
            Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
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
            
            acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            acc.social_id__c ='11900313862';
            acc.Personal_Agreement__c = 'No';
            acc.Mobile__c='';
            acc.Email__c='abc@gmail.com';
            update acc;
            
            
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='KEPEZ';
            address.City__c='ANTALYA';
            address.District__c='DOKUMA';
            
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=acc.id;
            address.Preferred__c = true;
            address.country__c = 'Turkey';
            address.ZipCode__c = '07025';
            address.Market__c = 'TR';
            addressList.add(address);
            DMLManagerService.insertAsSystem(addressList);
            
            address2=new Address__c();
            address2.Address_Type__c='Home';
            address2.Province__c='KEPEZ';
            address2.City__c='ANTALYA';
            address2.District__c='DOKUMA';
           
            address2.Address_Line_1__c='testaddress1';
            address2.Address_Line_2__c='testaddress2';
            address2.Customer__c=acc.id;
            address2.Preferred__c = true;
            address2.country__c = 'Turkey';
            address2.ZipCode__c = '07025';
            address.Market__c = 'TR';
            string MarketDiscriminator='TR'; 
            string updateType='';
            try{
                insert address2;
            }catch(Exception e){}
            
            acc.Primary_Address_Reference__c=address.id;
            update acc;
            map<id,Address__c> addressOldMap=new map<id,Address__c>();
            addressOldMap.put(address.id,address);
            test.startTest();
            TriggerRecursiveCheck.run = true;
            
            try{
                AddressHelperTR.updateAddressOnAccount(addressList);
                AddressHelperBase.updatemarket(addressList); 
                AddressHelperTR.updatePrimaryAddressOnAccount(addressOldMap);
                AddressHelperTR.validateSameAddressType(addressList,addressOldMap,true,true);
                addressList[0].Address_Type__c='Business';
                DMLManagerService.updateAsSystem(addressList);
                AddressHelperTR.updateAccountonDeletion(addressList);
                AddressHelperTR.updateAddressCDM(addressList,MarketDiscriminator,updateType);
                delete address;
            }catch(Exception e){}
            test.stopTest();
            acc = [select Primary_Address_Display__c from Account where id =:address.Customer__c ];
        }
    }
}