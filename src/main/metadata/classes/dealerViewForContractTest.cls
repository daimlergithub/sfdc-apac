@isTest
public class dealerViewForContractTest{
public static Retail_Task__c rell;
static testMethod void validateusernotify() {
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
     
    insert rell;
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',rell.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(rell);
        dealerViewForContract v= new dealerViewForContract(controller);
        test.stopTest();
       
    }
}