/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountHelperTest
{
    private static final Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static final Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static Account objAccount;
    private static Account objAccDisplayName;
    private static Account objPersonAcc;
    private static Address__c objAddress;
    private static Dealer_Locator__c objDL;
    private static Vehicle_Relationship__c objVR;
    private static Vehicle__c objVehicle;
        
    public static testMethod void testauBefore_Insert_Update_Events()
    {
    	//prepare test data
        Account objAcc=createAccount();
        insert objAcc;
        createAddress(objAcc.id);
      
        //process
        test.startTest();
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void testupdateDisplayName()
    {
    	//prepare test data
        Account objAcc=createAccount();
        objAcc.Partner_Surname__c='Test';
        insert objAcc;
        //process
        test.startTest();
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void testupdateDisplayName_Lastname_Equals_Partnersurname()
    {
    	//prepare test data
        Account objAcc=createPersonAccount();
        insert objAcc;
        //process
        test.startTest();
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_trackUpdatHistoryForFsInfo()
    {
    	//prepare test data
        Account objAcc=createPersonAccount();
        objAcc.FS_Opt_In_Email__c=false;
        objAcc.FS_Opt_In_SMS__c=false;
        objAcc.Opt_In_Email__c=false;
        objAcc.Opt_In_SMS__c=false;
        insert objAcc;
        //process
        test.startTest();
        objAcc.FS_Opt_In_Email__c=true;
        objAcc.FS_Opt_In_SMS__c=true;
        objAcc.Opt_In_Email__c=true;
        objAcc.Opt_In_SMS__c=true;
        update objAcc;
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_auAfter_Insert_Update_Delete_Events()
    {
    	//prepare test data
    	Account objCompany=createAccount();
    	insert objCompany;
    	Account objCompany1=createAccount();
    	insert objCompany1;
        Account objAcc=createPersonAccount();
        objAcc.FS_Opt_In_Email__c=false;
        objAcc.FS_Opt_In_SMS__c=false;
        objAcc.Opt_In_Email__c=false;
        objAcc.Opt_In_SMS__c=false;
        objAcc.Primary__pc=true;
        insert objAcc;
        
        Account objAcc1=createPersonAccount();
        objAcc1.FS_Opt_In_Email__c=false;
        objAcc1.FS_Opt_In_SMS__c=false;
        objAcc1.Opt_In_Email__c=false;
        objAcc1.Opt_In_SMS__c=false;
        objAcc1.Primary__pc=true;
        insert objAcc1;
        
        //process
        test.startTest();
        objAcc.FS_Opt_In_Email__c=true;
        objAcc.FS_Opt_In_SMS__c=true;
        objAcc.Opt_In_Email__c=true;
        objAcc.Opt_In_SMS__c=true;
        objAcc.Company__c=objCompany1.id;
        update objAcc;
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_getCustomerInfos()
    {
    	//prepare test data
        Account objAcc=createPersonAccount();
        objAcc.FS_Opt_In_Email__c=false;
        objAcc.FS_Opt_In_SMS__c=false;
        objAcc.Opt_In_Email__c=false;
        objAcc.Opt_In_SMS__c=false;
        insert objAcc;
        //process
        test.startTest();
        set<id> AccId= new set<id>();
        AccId.add(objAcc.id);
        AccountHelper.getCustomerInfos(AccId);
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_flagPrimaryContact()
    {
    	//prepare test data
        Account objAcc=createAccount();
        Account objAcc1=createPersonAccount();
        objAcc1.Company__c=objAcc.Id;
        insert objAcc1;
        //process
        test.startTest();
        set<string> AccId= new set<string>();
        AccId.add(objAcc.id);
        AccountHelper.flagPrimaryContact(AccId);
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_deleteDealerLocators()
    {
    	//prepare test data
        Account objAcc=createAccount();
        insert objAcc;
        createDealerLocator();
        //process
        test.startTest();
        set<id> AccId= new set<id>();
        AccId.add(objAcc.id);
        AccountHelper.deleteDealerLocators(AccId);
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_getVSCountInfo()
    {
    	//prepare test data
        Account objAcc=createAccount();
        insert objAcc;
        createVehicle();
        createVehicleRelationship();
        //process
        test.startTest();
        list<id> AccId= new list<id>();
        AccId.add(objAcc.id);
        AccountHelper.getVSCountInfo(AccId);
        test.stopTest();
        
        //verify
    }
    
    public static testMethod void test_getDealerCountInfo()
    {
    	//prepare test data
        Account objDealer=createAccount();
        objDealer.RecordtypeId=accDealer_RecordTypeId;
        objDealer.Dealer_DMS_SR_Code__c='DEALER_CODE_1';
        objDealer.Dealer_Default_Flag__c=true;
        insert objDealer;
        //process
        test.startTest();
        list<String> dealerCode= new list<String>();
        dealerCode.add(objDealer.Dealer_DMS_SR_Code__c);
        AccountHelper.getDealerCountInfo(dealerCode);
        test.stopTest();
        
        //verify
    }
    
    static account createAccount()
    {
	   objAccount= new Account();
	   objAccount.RecordtypeId=accCompany_RecordTypeId;
	   objAccount.Name='Test Person 1st';
	   objAccount.Type='Personal';
	   objAccount.Status__c='Active';
	   objAccount.Province__c='Province1';
	   objAccount.City__c='Test';
	   objAccount.Email__c='test@mbau.com';
	   objAccount.Mobile__c ='8884545243';
	   return objAccount;
    }
    
    static account createPersonAccount()
    {
	   objPersonAcc= new Account();
	   objPersonAcc.RecordtypeId=accPerson_RecordTypeId;
	   objPersonAcc.Firstname='Test Person 1st';
	   objPersonAcc.LastName='Test Person';
       objPersonAcc.salutation='Mr.';
	   objPersonAcc.Type='Personal';
	   objPersonAcc.Status__c='Active';
	   objPersonAcc.Province__c='Province1';
	   objPersonAcc.City__c='Test';
	   objPersonAcc.Email__c='test@mbau.com';
	   objPersonAcc.PersonMobilePhone ='8884545243';
	   objPersonAcc.Partner_Surname__c='Test Person';
	   return objPersonAcc;
    }
	
    static void createAddress(id accountid)
    {
	   objAddress= new Address__c();
	   objAddress.Customer__c=accountid;
	   objAddress.Preferred__c=true;
	   objAddress.Province__c='ACT';
	   insert objAddress;
    }
    
    static void createDealerLocator()
    {
    	objDL= new Dealer_Locator__c();
    	objDL.Dealer_Name__c=objAccount.id;
    	objDL.Inactive__c=false;
    	insert objDL;
    }
    
    static void createVehicleRelationship()
    {
    	objVR= new Vehicle_Relationship__c();
    	objVR.Contact__c=objAccount.id;
    	objVR.Vehicle_ID__c=objVehicle.id;
    	insert objVR;
    }
    
    static void createVehicle()
    {
    	objVehicle= new Vehicle__c(Class__c='C-Class Sedan');
    	insert objVehicle;
    }
}