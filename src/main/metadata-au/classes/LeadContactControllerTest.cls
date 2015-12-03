@istest 
public class LeadContactControllerTest 
{

  private static Account objAccount;
  private static Account objAccount1;
  private static Account personAcc;
  public static Lead__c objlead;
  public static Lead__c objlead1;
  private static Address__c objAddress;
  private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
  private static final String accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  
  @istest(seealldata = true)
  public static void test_showPopup()
  {
     
      createAccount();
      createAddress(objAccount);
      createLead();
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objlead.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objlead);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.showPopup();
      test.stopTest();
        
      //verify
      System.assert(objLeadContactController.displayPopup);
  }
   
  public static testMethod void test_updateAccount1()
  {
      //prepare test data
    objAccount1= new Account();
    objAccount1.RecordtypeId=companyAccRecordTypeId;
    objAccount1.Name=' Person 1st';
    objAccount1.Type='Personal';
    objAccount1.Status__c='Active';
    objAccount1.Province__c='Province1';
    objAccount1.City__c='HYD';
    objAccount1.Email__c='test@mbau.com';
    objAccount1.Mobile__c ='042548';      
    insert objAccount1;
    
    createAddress(objAccount1);
     
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.updateAccount();
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
  
 @istest(seealldata = true)
     public static void test_updateAccount2()
  {
       createpersonAcc();
      //prepare test data
            personAcc = new Account();
                      personAcc.Dealer_Default_Flag__c=false;
                      personAcc.Dealer_DMS_SR_Code__c='test1 code 2';
                      personAcc.Status__c='NoCustomer';
                      personAcc.City__c='Beijing';
                      personAcc.Gender__c = 'Male';
                      personAcc.Phone = '801801010';
                      personAcc.Area_code__c = '0101';
                      personAcc.LastName = 'galaxy1';
                      personAcc.FirstName = 'First Name';
                      personAcc.Salutation = 'Unknown';
                      personAcc.Province__c = 'Shanghai';
                      personAcc.ZipCode__c='0000001';
                      personAcc.Allow_Data_Sharing__c='no';
                      personAcc.Preferred_Language__c = 'English';
                      personAcc.Dealer_Lead_System__c = 'Salesforce';
                      personAcc.RecordTypeId=accPerson_RecordTypeId;   
                      personAcc.Mobile__c ='0425388899';
                      personAcc.Mobile2__c='0425383899';       
                      personAcc.Individual_Home_Phone__c='0425487899';
                      personAcc.Home_Phone_2__c='0425487698';
                      personAcc.Work_Phone__c='0435487698';
                      personAcc.Phone='43548';  
                      insert personAcc;
      
       objlead1= new Lead__c();
        objlead1.Contact__c=personAcc.id;
        objlead1.recordTypeId = leadFinanceRT;
        objlead1.Lead_Type__c = 'New Car';
        objlead1.CAC_Lead_Status__c = 'New Enquiry';
        objlead1.Lead_Source__c =  'Campaign';
        objlead1.Nature_of_Request__c= 'Key 2 Key';
        objlead1.Business_Unit__c= 'Finance';
        objlead1.Sub_BusinessUnit__c= 'Finance & Insurance';
        objlead1.X24H_Untouched__c=false;
        objlead1.X72H_Untouched__c=false;
        insert objlead1;
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objlead1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objlead1);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.updateAccount();       
      test.stopTest();
        
      //verify
      System.assertEquals(objlead1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
  
  public static testMethod void test_updateAccount3()
  {
      //prepare test data
      objAccount1= new Account();
    objAccount1.RecordtypeId=companyAccRecordTypeId;
    objAccount1.Name='Te Person 1st';
    objAccount1.Type='Personal';
    objAccount1.Status__c='Active';
    objAccount1.Province__c='Province1';
    objAccount1.City__c='bangalore';
    objAccount1.Email__c='test@mbau.com';
    objAccount1.Mobile__c ='0425388899';
      objAccount1.Mobile2__c='0425';       
      
    insert objAccount1;
      
      createAddress(objAccount1);
      
      //process
      test.startTest();
      
      ApexPages.currentPage().getParameters().put('Id',objAccount1.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount1);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.updateAccount();
      LeadContactController.ValidatePhoneNumberFields('042538');
       LeadContactController.ValidatePhoneNumberFields('+61232145');
       LeadContactController.ValidatePhoneNumberFields('130042538');
       LeadContactController.ValidatePhoneNumberFields('1338');
      test.stopTest();
        
      //verify
      System.assertEquals(objAccount1.id,ApexPages.currentPage().getParameters().get('Id'));
  }
 
  public static testMethod void test_userInfo()
  {
      //prepare test data
      createAccount();
      createAddress(objAccount);
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.selectedUserName=userinfo.getFirstName()+' '+userinfo.getlastName();
      objLeadContactController.userInfo();
      test.stopTest();
        
      //verify
      System.assert(objLeadContactController.usrInfolst!=null);
       }
  
  public static testMethod void test_closePopup()
  {
      //prepare test data
      createAccount();
      createAddress(objAccount);
      
      //process
      test.startTest();
      ApexPages.currentPage().getParameters().put('Id',objAccount.id);
      ApexPages.StandardController objSc = new ApexPages.StandardController(objAccount);
      LeadContactController objLeadContactController= new LeadContactController(objSc);
      objLeadContactController.selectedUserName=userinfo.getName();
      objLeadContactController.userInfo();
      objLeadContactController.closePopup();
      objLeadContactController.LastModifiedby='Testve';
      objLeadContactController.LastModifieddate='Testsu';
      objLeadContactController.FSLastModifiedby='Tests';
      objLeadContactController.FSLastModifieddate=system.today();
      test.stopTest();
        
      //verify
      System.assert(!objLeadContactController.displayPopup);
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
    objAccount.Mobile__c ='0435488899';
    
      
    insert objAccount;
     
  }
   
  
  static void createAddress(Account objAcc)
  {
    objAddress= new Address__c();
    objAddress.Customer__c=objAcc.Id;
    objAddress.Preferred__c=true;
    objAddress.Province__c='ACT';
    insert objAddress;
     
  }
  
   static void createpersonAcc()
  {   
   personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '801801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='0000001',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',                                    
                                    RecordTypeId=accPerson_RecordTypeId);       
                                   insert personAcc;
                                   
   }
  
  static void createLead()
  {
   
   createAccount();
     Vehicle__c vehicles1 = new Vehicle__c(EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222');
        insert vehicles1;
        system.debug('@!!@!@!@!@ vehicles1 '+vehicles1);
        objlead= new Lead__c();
        objlead.Company_Account__c=objAccount.id;
        objlead.recordTypeId = leadFinanceRT;
        objlead.Current_Vehicle__c=vehicles1.id;
        objlead.Lead_Type__c = 'New Car';
        objlead.CAC_Lead_Status__c = 'New Enquiry';
        objlead.Lead_Source__c =  'Campaign';
        objlead.Nature_of_Request__c= 'Key 2 Key';
        objlead.Business_Unit__c= 'Finance';
        objlead.Sub_BusinessUnit__c= 'Finance & Insurance';
        objlead.X24H_Untouched__c=false;
        objlead.X72H_Untouched__c=false;
        insert objlead;
        
  }
}