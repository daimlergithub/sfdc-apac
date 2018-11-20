@isTest
private  class ServiceRetailTaskLTGTest
{
    public static Retail_Task__c Ser;
    public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id ServiceRecordtype = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Account accobj;
    public static Account accobj2;
    public static Account accobj3;
    public static Account accobj4;
    
    @isTest
    private static  void ValidateService()
    {
        accobj= new Account();
        accobj.Firstname='Test Person First';
        accobj.LastName='Test Person';
        accobj.salutation='Mr.';
        accobj.Type='Personal';
        accobj.Status__c='Active';
        accobj.Province__c='Province1';
        accobj.City__c='Test';
        accobj.Email__c='test@mbau.com';
        accobj.Email2__c = 'testemail2@test.com';
        accobj.Home_Phone_2__c = '098765413';    
        accobj.PersonMobilePhone ='8884545243';
        accobj.Partner_Surname__c='Test Person';
        accobj.RecordTypeId=personRecordtypeid;
        insert accobj;
        
        accobj2= new Account();
        accobj2.Firstname='Test Person Seconnd';
        accobj2.LastName='Test Person';
        accobj2.salutation='Mr.';
        accobj.Type='Personal';
        accobj2.Status__c='Active';
        accobj2.Province__c='Province2';
        accobj2.City__c='Test';
        accobj2.Email__c='test@mbau.com';
        accobj.Email2__c = 'testemail2@test.com';
        accobj2.Home_Phone_2__c = '098765413';    
        accobj2.PersonMobilePhone ='8884545243';
        accobj2.Partner_Surname__c='Test Person2';
        accobj2.RecordTypeId=personRecordtypeid;
        insert accobj2;
        
        accobj3= new Account();
        accobj3.Firstname='Test Person Third';
        accobj3.LastName='Test Person';
        accobj3.salutation='Mr.';
        accobj3.Type='Personal';
        accobj3.Status__c='Active';
        accobj.Province__c='Province3';
        accobj3.City__c='Test';
        accobj3.Email__c='test@mbau.com';
        accobj3.Email2__c = 'testemail2@test.com';
        accobj3.Home_Phone_2__c = '098765413';    
        accobj3.PersonMobilePhone ='8884545243';
        accobj3.Partner_Surname__c='Test Person3';
        accobj3.RecordTypeId=personRecordtypeid;
        insert accobj3;
        
        accobj4= new Account();
        accobj4.Firstname='Test Person Fourth';
        accobj4.LastName='Test Person';
        accobj4.salutation='Mr.';
        accobj4.Type='Personal';
        accobj4.Status__c='Active';
        accobj4.Province__c='Province4';
        accobj4.City__c='Test';
        accobj4.Email__c='test@mbau.com';
        accobj4.Email2__c = 'testemail2@test.com';
        accobj4.Home_Phone_2__c = '098765413';    
        accobj4.PersonMobilePhone ='8884545243';
        accobj4.Partner_Surname__c='Test Person4';
        accobj4.RecordTypeId=personRecordtypeid;
        insert accobj4;
        
        Account dealer1 = new Account(RecordTypeId=dealerRecordtypeid,Name='acme',MBK_Data_Source__c='Email',
                                      Mobile__c='00000009842',Dealer_GC_Code__c='12345');
        insert dealer1;
        
        Ser=new Retail_Task__c();
        Ser.Service_Total_Amount__c=10000;
        Ser.Service_Parts_Amount__c=2000;
        Ser.Service_Labour_Amount__c=2000;
        Ser.Service_Currency__c ='2000';
        Ser.Related_Contact__c=accobj.id;
        Ser.Related_Contact2__c=accobj2.id;
        Ser.Related_Contact3__c=accobj3.id;
        Ser.Related_Contact4__c=accobj4.id;
        Ser.RecordTypeId=ServiceRecordtype;
        Ser.Service_Number__c='2565263';
        Ser.Service_Code__c='26565';
        Ser.Service_Date__c=System.Today();
        Ser.Service_Details__c='acbd';
        Ser.Service_Date_In__c=System.today()+3;
        Ser.Service_Date_Out__c=System.today()+5;
        Ser.Service_Mileage__c=47.0;
        Ser.Service_Invoice_Number__c='846284';
        Ser.Related_Dealer__c=dealer1.id;
        insert Ser;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
       User usrDatatable = new User(
            Alias = 'testu',
            Email = 'test@unitingambition.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test@unitingamb2.com',
            Market__c='IN'
        );
       insert usrDatatable; 
       System.runAs(usrDatatable) {
        Test.StartTest();
        ServiceRetailtaskLTG.getResponse('','','ServiceRetailTask',Ser.id);
        Test.StopTest();
       }
    }
}