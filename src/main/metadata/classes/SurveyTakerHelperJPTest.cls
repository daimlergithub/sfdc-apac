@isTest
public class SurveyTakerHelperJPTest{
 public Static Account objAccount;
  public static Account objAccount2;  
  public static Account objAccount3; 
  public Static Account DealerAccount;
  public Static Account DealerAccount1;
  public static Account_Link__c AccLink;
  public static  Group grp;
   public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
 
 
public static  testmethod void afterUpdateEvent_test()
  {
         createTestData();
        Survey__c sur= new Survey__c();
          sur.name = 'testsurvey';
          insert sur;
       SurveyTaker__c st = new SurveyTaker__c();
            st.account__c = objAccount.id;
            st.survey__c = sur.id;
           insert st;
           test.starttest();
           st.account__c = objAccount2.id;
           update st;
           test.stoptest();
  }
public static  testmethod void afterInsertEvent_test()
  {
         createTestData();
      
           test.starttest();
            Survey__c sur= new Survey__c();
          sur.name = 'testsurvey';
          insert sur;
           SurveyTaker__c st = new SurveyTaker__c();
            st.dealer_account__c= DealerAccount.id;
             st.survey__c = sur.id;
           insert st;
           test.stoptest();
  }
public static  testmethod void afterInsertEvent_test1()
  {
         createTestData();
      
           test.starttest();
            Survey__c sur= new Survey__c();
          sur.name = 'testsurvey';
          insert sur;
           SurveyTaker__c st = new SurveyTaker__c();
            st.dealer_account__c= DealerAccount.id;
             st.survey__c = sur.id;
             st.view_by_all__c = true;
           insert st;
           st.view_by_all__c = false;
           update st;
           test.stoptest();
  }
  public static  testmethod void afterInsertEvent_test2()
  {
         createTestData();
      
           test.starttest();
            Survey__c sur= new Survey__c();
          sur.name = 'testsurvey';
          insert sur;
           SurveyTaker__c st = new SurveyTaker__c();
            st.dealer_account__c= DealerAccount.id;
             st.survey__c = sur.id;
             st.view_by_all__c = false;
           insert st;
           st.view_by_all__c = true;
           update st;
           test.stoptest();
  }
  
  public static  testmethod void afterInsertEvent_test3()
  {
         createTestData();
      
           test.starttest();
            Survey__c sur= new Survey__c();
          sur.name = 'testsurvey';
          insert sur;
           SurveyTaker__c st = new SurveyTaker__c();
            st.dealer_account__c= DealerAccount.id;
             st.survey__c = sur.id;
            
           insert st;
           st.dealer_account__c= DealerAccount1.id;
           update st;
           test.stoptest();
  }
  static void createTestData()
    {
        Trigger__c TriggerSurveTaker=new Trigger__c(Name='TriggerSurveyTaker',Trigger_Name__c='TriggerSurveyTaker',Trigger_Handler__c='TriggerSurveyTakerTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
             insert TriggerSurveTaker;
     
        
         DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        
        
        insert DealerAccount;
        
        DealerAccount1= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount1.Name='Test Person';
        DealerAccount1.Type='Personal';
        DealerAccount1.Status__c='Active';
        DealerAccount1.Province__c='Province1';
        DealerAccount1.City__c='Test';
        DealerAccount1.Email__c='test@mbj.com';
        DealerAccount1.Mobile__c ='0435488899';
        
        
        insert DealerAccount1;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;    
        //inserted new address record
        Address__c addr = new Address__c(Customer__c = objAccount.id, Address_Type__c = 'Home', Province__c = 'Hokkaido');
        insert addr;
        //added address reference to address 
        Account objacc = new Account(id = objAccount.id, Primary_Address_Reference__c = addr.id); 
        update objacc;
        
        objAccount2= new Account();
        objAccount2.RecordtypeId=personAccRecordTypeId;
        objAccount2.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount2.Status__c='Active';
        objAccount2.Province__c='Province1';
        objAccount2.City__c='Test';
        objAccount2.ZipCode__c = '1004209';
        objAccount2.Email__c='test@mbj.com';
        objAccount2.Mobile__c ='0435488899';
        objAccount2.Phone = '08022420181';
        objAccount2.Main_Dealer__c = DealerAccount.id;
        objAccount2.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount2;
        
        objAccount3= new Account();
        objAccount3.RecordtypeId=personAccRecordTypeId;
        objAccount3.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount3.Status__c='Active';
        objAccount3.Province__c='Province1';
        objAccount3.City__c='Test';
        objAccount3.ZipCode__c = '1063723';
        objAccount3.Email__c='test@mbj.com';
        objAccount3.Mobile__c ='0435488899';
        objAccount3.Phone = '08022420181';
        objAccount3.Main_Dealer__c = DealerAccount.id;
        objAccount3.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount3;
        
      
           
        
        AccLink = new Account_Link__c();
        AccLink.fromRole__c = DealerAccount.id;
        AccLink.toRole__c = objAccount.id;        
        
        insert AccLink; 
        grp=new Group();
        grp.name=DealerAccount.Name;
        insert grp;
        
    }

}