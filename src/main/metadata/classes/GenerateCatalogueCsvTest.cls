@istest
public class GenerateCatalogueCsvTest
{
    public Static Account objAccount;
    public Static Account DealerAccount;
    public static DM_Request__c Dmr;
    public static Dealer_Locator__c Dl ;
    public static Dealer_Locator__c Dl2 ;
    public static Dealer_Locator__c Dl3;
    public static DM_Material__c Dmm;
    
    public static User usr ;
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    
    public static testMethod void test_getDMRequests()
    {   
         
        createTestData();
        
        test.startTest();
        insert Dl;
        GenerateCatalogueCsv generateCsvClass = new GenerateCatalogueCsv();
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        system.assertEquals('true', retString);
        
    }
    
   public static testMethod void test_getDMRequestsWithoutDl()
    {   
         
        createTestData();
        
        test.startTest();
        
        GenerateCatalogueCsv generateCsvClass = new GenerateCatalogueCsv();
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        system.assertEquals('true', retString);
        system.assertEquals(0, GenerateCatalogueCsv.DlList.Size());
        
    }
    
    public static testMethod void test_getDMRequest1()
    {
        createTestData();
        
       
        test.startTest();
        insert Dl2;
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        system.assertEquals('true', retString);
        
    } 
    
    public static testMethod void test_getDMRequest2()
    {
        
        createTestData();
        
        test.startTest();
        insert Dl2;
        insert Dl3;
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        //system.assertEquals(2, GenerateCatalogueCsv.DlList.Size());
        
        
    }
    
     public static testMethod void test_getDMRequest3()
    {
        createTestData();
        insert Dl;
        insert Dl2;
        insert Dl3;
        test.startTest();
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        system.assertEquals('true', retString);
        
    } 
    
     public static testMethod void test_getDMRequestNeg()
    {
        
        createTestData();
       
        test.startTest();
        delete Dmr;
        string retString = GenerateCatalogueCsv.getDMRequests();
        test.stopTest();
        system.assertEquals('false', retString);
        
    }
    
    static void createTestData()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
       
        
        
        DealerAccount= new Account();
        DealerAccount.RecordtypeId=DealerAccRecordTypeId;
        DealerAccount.Name='Test Person 1st';
        DealerAccount.Type='Personal';
        DealerAccount.Status__c='Active';
        DealerAccount.Province__c='Province1';
        DealerAccount.City__c='Test';
        DealerAccount.Email__c='test@mbj.com';
        DealerAccount.Mobile__c ='0435488899';
        DealerAccount.ZipCode__c = '1021421';
        
        insert DealerAccount;
        
        objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';
        //objAccount.Type='Personal';
        objAccount.Status__c='Active';
        objAccount.Province__c='Province1';
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1003425';
        objAccount.Email__c='test@mbj.com';
        objAccount.Mobile__c ='0435488899';
        objAccount.Phone = '08022420181';
        objAccount.Main_Dealer__c = DealerAccount.id;
        
        insert objAccount;
        
         Dmm = new DM_Material__c();
         Dmm.Name = 'DM Material';   
         Dmm.Type__c = 'Car Book';
         Dmm.Preliminary_Flag__c = false;
         Dmm.Label_Printing_Name__c = 'Test Name';
         insert Dmm; 
         
        Dmr = new DM_Request__c();
        Dmr.Customer_Name__c = objAccount.id;
        Dmr.Status__c = 'to be sent';
        Dmr.Status1__c = 'to be sent';
        Dmr.Status2__c = 'to be sent';
        Dmr.Status3__c = 'to be sent';
        Dmr.Expected_DM_Material1__c = Dmm.id;
        Dmr.Expected_DM_Material2__c = Dmm.id;
        Dmr.Expected_DM_Material3__c = Dmm.id;
        insert Dmr;
        
        Dl = new Dealer_Locator__c();
        Dl.Post_Code__c = '1040031';
        Dl.Dealer_Name__c = DealerAccount.id;
        Dl.Sequence_No__c = '1';
        //insert Dl;
        
         Dl2 = new Dealer_Locator__c();
        Dl2.Post_Code__c = '1040031';
        Dl2.Dealer_Name__c = DealerAccount.id;
        Dl2.Sequence_No__c = '1';
        //insert Dl2;
        
         Dl3 = new Dealer_Locator__c();
        Dl3.Post_Code__c = '1040031';
        Dl3.Dealer_Name__c = DealerAccount.id;
        Dl3.Sequence_No__c = '1';
        //insert Dl3;
        
        
        
        
            }
    
    
    
}