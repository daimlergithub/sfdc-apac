@IsTest
public class MultiselectAutoCompleteCtrlTest
{
    public static SelectOption[] leftOptions   { get; set; }
  	public SelectOption[] rightOptions  { get; set; }
  	public SelectOption[] prePopulateOptions { get; set; }
  	public String strSelectedOptions    { get; set; }  
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static String aftersalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    public static Opportunity oppSales;
    public static Opportunity oppafterSales;
    public static List<Car_Model__c> carModelList ;
      public static  List<Lead_Details__c> ledDetList ;
       public static  List<Lead_Details__c> ledDetList1;
    @TestSetup
    public static void initData(){
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            Account companyAcc = TestUtils.createGenericAccount(usr, '1236', companyAccRecordTypeId, '+61445789654');
         
        }
    }
    
    @IsTest
    private static void CarModelMappingUtilityTest() {
        test.startTest();
        User user1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs (user1) {
            initData();
           SelectOption leftOptions = new SelectOption('a','a');
            MultiselectAutoCompleteCtrl MS = new MultiselectAutoCompleteCtrl();
           MS.assignToSelectedOption();
            String Str = MS.getMultiselectOptions();
            Str = MS.getPrepopulatedData();
     
        }
        test.stopTest();
        
        
    }
     
}