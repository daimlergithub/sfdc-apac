/*
    Type:       Test Class
    Purpose:    Test On SelectAddressController
    Created by: Siva Krishna 12/27/2016

*/

@isTest
public with sharing class SelectAddressControllerTest {
    
    /**    
     * @Description : For creation of Account and Address record
     * @author      : Siva Krishna
     * @Date        : 12/27/2016
   **/
   
   public static Address__c objaddress;
   public static Account objAccount;
   private static Id PersonaccRTId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     
   public static void init() {    
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        
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
        objAccount.Home_Phone_2__c = '098765413';    
        objAccount.PersonMobilePhone ='8884545243';
        objAccount.Partner_Surname__c='Test Person';
        
        insert objAccount;
        
        
        objAddress= new Address__c();
        objAddress.Customer__c=objAccount.Id;
        objAddress.TitleOfHonor__c = 'To Person';       
        objAddress.Preferred__c=true;
        objAddress.Province__c='ACT'; 
        objAddress.Address_Type__c = 'Home';  
        objAddress.ZipCode__c ='1234567';    
        insert objAddress;
        
        objAccount.Primary_Address_Reference__c = objAddress.Id;
        update objAccount;
        
        system.debug('objAddress>>>>>'+objAddress.Id);
    }
    
   /**    
     * @Description : Search functionality 
     * @author      : Siva Krishna
     * @Date        : 11/27/2016 
   **/  
    public static testMethod void testUpdateAddress() {
        init();        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id', objAccount.id);     
        ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
        SelectAddressController objSelectAddressController = new SelectAddressController(objSc);
        Pagereference pg = objSelectAddressController.updateAddress();
        test.stopTest();
        
        system.assertEquals(pg, null);
    }  
}