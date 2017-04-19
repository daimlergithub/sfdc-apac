@isTest
public class dealerViewForContractTest{
    public static Retail_Task__c rell;
    public static User sysAdminUser1;
     private static Account dealer;
     public static Contact contact;
static testMethod void validateusernotify() {
   RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_GC_Code__c = 'Test12');
        insert dealer;

contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = 'sysAdmin1@dialmer.com';
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = dealer.Id;
        contact.Dealer_Presales__c = true;
        insert contact;
        
  // Fetch Profile Id
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'Japan Dealer Sales Manager' limit 1].ID;
// Create User       
        sysAdminUser1 = new User ( Alias = 'sysA1'
                                        , Email='sysAdmin1@dialmer.com'
                                        , EmailEncodingKey='UTF-8'
                                        , LastName='Adminstrator'
                                        , FirstName='System'
                                        , LanguageLocaleKey='en_US'
                                        , LocaleSidKey='en_US'
                                        , ProfileId = sysAdminProfileId
                                        , TimeZoneSidKey='America/Los_Angeles'
                                        , Market__c = 'JP'
                                        , UserName='sysAdmin1@mbj.daimler-apac.com.asiadev1'
                                        , User_Type__c = 'Dealer'
                                        , ContactId = contact.Id);
        insert sysAdminUser1;
      
        
    System.runas(sysAdminUser1) {

    rell = new Retail_Task__c(); 
    rell.Latest_Sales_Person__c='T1';
    rell.Contractor_Name__c='T2';
    rell.Contractor_Name_Native__c='T3';
    rell.Vehicle_Registration_No__c='13245';
    rell.Contractor_ZipCode1__c='5600000';
    rell.Contractor_Address1__c='ayfui';
    rell.MOT_User_Name__c='T4';
    rell.MOT_User_Name_Native__c='T5';
    rell.MOT_User_Postal__c='5632206';
    rell.MOT_User_Address__c='T6';
    rell.MOT_User_Phone__c='9758565225';
    rell.MOT_Owner_Name__c='T8';
    rell.MOT_Owner_Name_Native__c='zgf';
    rell.MOT_Owner_Address__c='afyu';
    rell.Related_Dealer__c = dealer.Id;
    rell.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Contract');
     
    insert rell;
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',rell.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(rell);
        dealerViewForContract v= new dealerViewForContract(controller);
        test.stopTest();
     }   
       
    }
}