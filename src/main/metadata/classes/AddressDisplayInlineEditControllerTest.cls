@isTest
public class AddressDisplayInlineEditControllerTest 
{
	public static Address__c objaddress;
    public static Account objAccount;
    public static Id editaddressId;
    public static Id addressId;
    public static Address__c addressobj;
    public static List<Address__c> editadds;
    
    private static Id PersonaccRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void testaddress_details()
    {
        init();
        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',objAccount.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.cancelEdit();
        objAddressDisplayInlineEditController.saveEditedRecords();
        objAddressDisplayInlineEditController.loadData();
        objAddressDisplayInlineEditController.addEditOptions();        
        objAddressDisplayInlineEditController.EditOptions();
        objAddressDisplayInlineEditController.saveAddress();
        objAddressDisplayInlineEditController.delAccountAddress();
        test.stopTest();
        system.assertNotEquals(null,objAddressDisplayInlineEditController);
    }
    
    public static testMethod void testaddress_details1()
    {
        init();
        
        test.startTest();
		ApexPages.currentPage().getParameters().put('Id',objAccount.id);        
        ApexPages.currentPage().getParameters().put('editaddressId',objaddress.id);
        ApexPages.currentPage().getParameters().put('addressId',objaddress.id);
        ApexPages.currentPage().getParameters().put('addressobj',editadds[0].id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        AddressDisplayInlineEditController objAddressDisplayInlineEditController = new AddressDisplayInlineEditController(objSc);
        objAddressDisplayInlineEditController.editaddressId =objaddress.id;
        objAddressDisplayInlineEditController.addressId=objaddress.Id;
        objAddressDisplayInlineEditController.addressobj = editadds[0];
        objAddressDisplayInlineEditController.addEditOptions();  
        objAddressDisplayInlineEditController.saveAddress();
        objAddressDisplayInlineEditController.EditOptions();
		objAddressDisplayInlineEditController.delAccountAddress();    
        test.stopTest();
        system.assertEquals(null,editaddressId);
    }
   public static void init()
    {                                   
        objAccount= new Account();
        objAccount.RecordtypeId=PersonaccRTId;
        objAccount.Firstname='Test Person 1st';
        objAccount.LastName='Test Person';
        objAccount.salutation='Mr.';
        objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.Email__c='test@mbau.com';
        objAccount.Email2__c = 'testemail2@test.com';
        objAccount.Home_Phone_2__c = '98765413';    
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        
        insert objAccount;
        
        
        objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id; 
        objAddress.Preferred__c=true;
        objAddress.Province__c='ACT';        
        insert objAddress;
        system.debug('objAddress>>>>>'+objAddress.Id);
        
        editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                  Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Id =:objAddress.Id];
        system.debug('editadds>>>'+editadds);
        editadds[0].Preferred__c=false;
        editadds[0].Province__c='NSW';        
        update editadds;
        
    }
}