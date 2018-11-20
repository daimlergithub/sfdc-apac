@isTest public with sharing class AddressHelperTHTest {

    public static User user1 = TestUtils.createAdminUser();
    public static User user2 = TestUtils.IntegrationAPIUser();

    public static void creatTestData() {
        List < Sobject > sobj = new List < sObject > ();
        List < Campaign > campaignList = new List < Campaign > ();
        Map < Id, Campaign > campaignMap = new Map < Id, Campaign > ();

        Trigger__c tr = new Trigger__C(name = 'TriggerAddressTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAddressTriggerHandlerTH', Trigger_Name__c = 'TriggerAddress', update__c = true);
        sobj.add(tr);
        insert sobj;

        Account acc = new Account();
        acc.owner = user1;
        acc.Phone = '09844650654';
        acc.Name = 'Test';
        acc.Mobile__c = '1234567890';
        acc.Data_Source__c = 'Test4';
        insert acc;

        Address__c address = new Address__c();
        address.Address_Type__c = 'Home';
        address.Province__c = 'test1';
        address.City__c = 'bangalore';
        address.District__c = 'test2';
        address.Block__c = 'test3';
        address.Address_Line_1__c = 'testaddress1';
        address.Address_Line_2__c = 'testaddress2';
        address.Customer__c = acc.id;
        address.TitleOfHonor__c = 'To Person';
        address.preferred__c = True;
        address.MD__c = 'TH';
        insert address;

        Address__c address1 = new Address__c();
        address1.Address_Type__c = 'Other Address 1';
        address1.Province__c = 'test1';
        address1.City__c = 'bangalore';
        address1.District__c = 'test2';
        address1.Block__c = 'test3';
        address1.Address_Line_1__c = 'testaddress1';
        address1.Address_Line_2__c = 'testaddress2';
        address1.Customer__c = acc.id;
        address1.TitleOfHonor__c = 'To Person';
        address1.preferred__c = false;
        address1.MD__c = 'TH';

        insert address1;
        address.Address_Type__c = 'Business';
        update address;

        acc.Primary_Address_Reference__c = address.id;
        update acc;
        list < address__c > list1 = new list < address__c > ();
        list1.add(address);

        map < id, address__c > addmap = new map < id, address__c > ();
        addmap.put(address.id, address);
        AddressHelperTH.updateAddressOnAccount(list1);
        AddressHelperTH.validateSameAddressType(list1, addmap, true, true);
        AddressHelperTH.validateSameAddressType(list1, addmap, False, False);
        AddressHelperTH.updatePrimaryAddressOnAccount(addmap);
        AddressHelperTH.updateAccountonDeletion(list1);
        AddressHelperTH.updateSalesAddressAccount(addmap);

        delete address;

    }

    public static testMethod void Addresstest() {
        System.runAs(user1) {
            test.startTest();
            creatTestData();
            test.stopTest();
        }
    }
	
	public static testMethod void Addresstest2() {
        System.runAs(user2) {
            test.startTest();
			TriggerRecursiveCheck.run = true;
			TriggerUtil.userCreate = false;
            creatTestData();
            test.stopTest();
        }
    }

}
