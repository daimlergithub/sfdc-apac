@isTest
public class TriggerAddressTriggerHandlerTRTest{
    private static Account account;
    private static Address__c address,address2;
    private static List<Address__c> addressList=new List<Address__c>();
    public static PermissionSet ps;
    public static PermissionSet ps1;
    public static User user1;
    
    public static testMethod void testTriggerAddressTriggerHandlerTRTest(){
        //create test data
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator' limit 1];
        User user_Obj = new User(LastName='User'+System.Today(),Market__c='TR',country='Turkey',firstName='Test',ProfileId=p1.Id,Alias='Test',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Test@infosys.com',UserName='Test@infosys.com.asiadevty4'+String.valueof(DateTime.now().getTime()));
        DMLManagerService.insertAsSystem(user_Obj);
        system.runAs(user_Obj)
        {
            
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
            
            ps = new PermissionSet();
            ps.Name = 'Test1';
            ps.Label = 'Test77';
            insert ps;  
            CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.TRGeneric ];
            system.debug('check '+cps);
            SetupEntityAccess sea = new SetupEntityAccess();
            sea.ParentId = ps.Id;
            sea.SetupEntityId = cps.id;
            insert sea;
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = user_Obj.id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        user1 = UtilTestData.createPersornaUser(ps, p1);
        user1.market__c='TR';
        insert user1;
        System.runAs (user1) {
            
            ps1 = new PermissionSet(Name = 'Test12', Label = 'Test12');
            insert ps1;  
            
            account= new Account();
            account.Phone='5478963217';
            account.FirstName = 'Test';
            account.LastName = 'Test';
            account.Status__c = 'Prospect';
            account.Data_Source__c  = 'Test4';
            account.Market__c = 'TR';
            upsert account;       
            
            
            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='KEPEZ';
            address.City__c='ANTALYA';
            address.District__c='DOKUMA';
            //address.Neighbourhood__c='MAHMUTLU MAH';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=account.id;
            address.TitleOfHonor__c = 'To Person'; 
            address.Preferred__c = true;
            address.country__c = 'Turkey';
            address.ZipCode__c = '07025';
            address.Market__c = 'TR';
            addressList.add(address);
            DMLManagerService.insertAsSystem(addressList);
            //insert address;
            
            address2=new Address__c();
            address2.Address_Type__c='Home';
            address2.Province__c='KEPEZ';
            address2.City__c='ANTALYA';
            address2.District__c='DOKUMA';
            //address2.Neighbourhood__c='MAHMUTLU MAH';
            address2.Address_Line_1__c='testaddress1';
            address2.Address_Line_2__c='testaddress2';
            address2.Customer__c=account.id;
            address2.TitleOfHonor__c = 'To Person'; 
            address2.Preferred__c = true;
            address2.country__c = 'Turkey';
            address2.ZipCode__c = '07025';
            address.Market__c = 'TR';
            string MarketDiscriminator='TR'; 
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
                AddressHelperTR.updateAddressOnAccount(addressList);
                
                AddressHelperTR.updatePrimaryAddressOnAccount(addressOldMap);
                TriggerAddressTriggerHandlerTR td=new TriggerAddressTriggerHandlerTR();
                td.handleIntegrationTrigger(True,True,True,True,True);
                AddressHelperTR.validateSameAddressType(addressList,addressOldMap,true,true);
                addressList[0].Address_Type__c='Business';
                DMLManagerService.updateAsSystem(addressList);
                AddressHelperTR.updateAccountonDeletion(addressList);
                AddressHelperTR.updateAddressCDM(addressList,MarketDiscriminator,updateType);
                system.assertNotEquals(null, addressList[0].id);
                delete address;
            }catch(Exception e){}
            test.stopTest();
            account = [select Primary_Address_Display__c from Account where id =:address.Customer__c ] ;
        }
    }
}