@isTest
public class AccountLinkHelperTest 
{
    private static Account objAccount;
    private static Account objPerAccount;
    private static Account_Link__c AccLink;
    Private static Account_Link__c AccLink2;
    Private static Account_Link__c AccLink3;
    Private static Vehicle_Relationship__c VehRel;
    Private static Vehicle__c Vehicle;
    private static Group pubGroup;
    private static Group pubGroup2;
    private static String vehMbRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static String vehRelIndRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    
    public static testMethod void test_nameParsing()
    {
        string crmcode ;
        string name =  'nameDMS-';
        test.startTest();
        String testStr = AccountLinkHelper.nameParsing('nameDMS-');
        test.stopTest();
        name = name.substring(name.indexOf('DMS-'));
        crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
        system.assertEquals(crmCode, testStr);
    }
    
    public static testMethod void test_auBefore_Insert_Events()
    {
        createAccount();
        createAccLink();
        List<Account_Link__c> listALNew = new List<Account_Link__c>();
        listALNew.add(AccLink);
        listAlNew.add(AccLink2);
        test.startTest();
        AccountLinkHelper.auBefore_Insert_Events(listALNew);
        test.stopTest();
        system.assertNotEquals(null, AccountLinkHelper.getAllExistentRelationships(listALNew));
    }
    
    public static testMethod void test_isHigherPriority()
    {
        createAccount();
        createAccLink();
        boolean testIhp;
        List<Account_Link__c> relationships = new List<Account_Link__c>();
        relationships.add(AccLink);
        test.startTest();
        AccountLinkHelper.isHigherPriority('one','two');
        testIhp = AccountLinkHelper.isHigherPriority('Customer','two');
        system.assertEquals(true, testIhp);
        testIhp = AccountLinkHelper.isHigherPriority('one','Customer');
        system.assertEquals(false, testIhp);
        
        test.stopTest();
        
    }
    
    public static testMethod void test_getIndex()
    {
        createAccount();
        createAccLink();
        String cid = AccLink.toRole__c, did = AccLink.fromRole__c;
        test.startTest();
        string testStr = AccountLinkHelper.getIndex(AccLink);
        
        test.stopTest();
        system.assertEquals(cid.substring(0, 15) + ';' + did.substring(0, 15),testStr);
    }
    public static testMethod void test_shareAccountToDealer(){
        createAccount();
        createAccLink();
        createVehicle();
        createVehRel();
        createGroup();
        List<Account_Link__c> listAlNew = new List<Account_Link__c>();
        listAlNew.add(AccLink);
        listAlNew.add(AccLink2);
        listAlNew.add(AccLink3);
        test.startTest();
        AccountLinkHelper.shareAccountToDealer(listAlNew);
        test.stopTest();
        
    }
    
    
    static void createAccount()
    {
        objAccount= new Account();
        objAccount.RecordtypeId=companyAccRecordTypeId;
        objAccount.Name='Test Person 1st';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Mobile__c ='8884545243';
        insert objAccount;
        objPerAccount = new Account();
        objPerAccount.RecordTypeId = personAccRecordTypeId;
        objPerAccount.FirstName = 'test';
        objPerAccount.LastName = 'Person';
        objPerAccount.Salutation = 'Brother';
        objPerAccount.Email__c='test@mbau.com';
        insert objPerAccount;
    }
    
    static void createAccLink()
    {
        AccLink = new Account_Link__c();
        AccLink.fromRole__c = objAccount.Id;
        AccLink.toRole__c =  objperAccount.Id;
        AccLink.Status__c = 'Preferred';
        AccLink2 = new Account_Link__c();
        AccLink2.name = 'Testing';
        AccLink3 = new Account_Link__c();
        AccLink3.fromRole__c = objAccount.Id;
        AccLink3.toRole__c =  objPerAccount.Id;
        AccLink3.Status__c = 'Preferred';
        insert AccLink3;
    } 
    
    static void createVehicle()
    {
        vehicle = new vehicle__c();
        vehicle.RecordTypeId = vehMbRecordTypeId;
        vehicle.Brand__c = 'AC';
        vehicle.AMG__c = true;
        vehicle.Class__c = 'AMG';
        vehicle.Vehicle_Group__c = 'PC';
        insert vehicle;
        VehRel = new vehicle_relationship__c();
        vehRel.RecordTypeId = vehRelIndRecordTypeId;
        vehRel.Contact__c = objPerAccount.Id;
        vehRel.Vehicle_ID__c = vehicle.Id;
        insert vehRel;
    } 
    
    static void createVehRel()
    {
        VehRel = new vehicle_relationship__c();
        vehRel.RecordTypeId = vehRelIndRecordTypeId;
        vehRel.Contact__c = objPerAccount.Id;
        vehRel.Vehicle_ID__c = vehicle.Id;
        insert vehRel;
    } 
    
    static void createGroup(){
        pubGroup = new Group();
        pubGroup.Name = objAccount.name;
        insert pubGroup;
    }
}