@isTest
public class dealerViewForContractTest{
public static Retail_Task__c rell;
public static User us;
public static Retail_Task__c retail;
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
   // rell.recordtype.Name='Contract';
    insert rell;
      
test.startTest();
ApexPages.currentPage().getParameters().put('Id',rell.id);
ApexPages.StandardController controller = new ApexPages.StandardController(rell);
dealerViewForContract v= new dealerViewForContract(controller);
test.stopTest();
}
static testMethod void validateusernotify2() 
 {  
    us=new User();
    //us.Dealer_GC_Code__c='G270331';
    us.Alias='rseetha';
   // us.Name='ramaseetha';
    us.Email='rama.seetha@gmail.com';
    us.Username='rama.seetha@dtt';
    us.CommunityNickname='rama.seetha';
    us.EmailEncodingKey='Japanese(JIS)';
    //us.TimeZoneSidKey='(GMT +5.00)';
    us.User_Type__c ='Dealer';
    //us.ContactID='3456783427';
    insert us;
    
    test.startTest();
    ApexPages.currentPage().getParameters().put('Id',us.id);
    ApexPages.StandardController controller = new ApexPages.StandardController(us);
    dealerViewForContract v= new dealerViewForContract(controller);
    test.stopTest();
    }
    
     /*static testMethod void validateusernotify3()
    {
    retail=new Retail_Task__c();
    //retail.MotuserName='T4';
    //retail.AddressActual='ayfui';
    retail.MotuserNameNative='T5';
    retail.MotuserAddress='T6';
    retail.MotownerName='T8';
    retail.MotuserPostal='5632206';
    retail.MotuserPhone='9758565225';
    retail.MotuserownerNameNative='zgf';
    retail.MotOwnerAddress='afyu';
    insert retail;
      test.startTest();
    ApexPages.currentPage().getParameters().put('Id',retail.id);
    ApexPages.StandardController controller = new ApexPages.StandardController(retail);
    dealerViewForContract v= new dealerViewForContract(controller);
    test.stopTest();
    
    }*/
}