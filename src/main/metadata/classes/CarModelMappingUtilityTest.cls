/**
** Class: CarModelMappingUtilityTest

**/

@IsTest
public class CarModelMappingUtilityTest {
    
    
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
            oppSales = createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'AU');
            oppafterSales = createGenericOpportunity(usr, companyAcc, aftersalesLeadRecordTypeId, 'AU');
            carModelList = createBulkCarModel(7);
            List<Lead_Details__c> ledDetList = TestUtils.createBulkLeadDetails(oppSales, carModelList);
            List<Lead_Details__c> ledDetList1 = TestUtils.createBulkLeadDetails(oppafterSales, carModelList);
        }
    }
    
    @IsTest
    private static void CarModelMappingUtilityTest() {
        test.startTest();
        User user1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs (user1) {
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = oppSales;
                //[select Id,AccountID,Selected_Car_Model__c,Name From Opportunity limit 1];
            	List<Opportunity> LsOpty = new List<Opportunity>() ;
            LsOpty.add(oppSales);
            LsOpty.add(oppafterSales);
 
           
            Map<Id, Opportunity> mapIdOppty =  new Map<Id, Opportunity>(LsOpty);
            
            ApexPages.currentPage().getParameters().put('recordType','Sales Lead');
            ApexPages.currentPage().getParameters().put('recordType','Aftersales Lead');
            ApexPages.currentPage().getParameters().put('id', oppty.Id);
            ApexPages.currentPage().getParameters().get('id');
            
            ApexPages.StandardController objsc = new ApexPages.StandardController(oppty);
            CarModelMappingUtility  oivc= new CarModelMappingUtility();
            CarModelMappingUtility.mapIdOpportunity =mapIdOppty;
			CarModelMappingUtility.mapCarModelOpportunity();
     
        }
        test.stopTest();
        
        
    }
    
      public static Opportunity createGenericOpportunity(User u, Account acc, Id oppRecordTypeId, String market){
        /*
        DescribeFieldResult describeType = Opportunity.Lead_Type__c.getDescribe();
        List<PicklistEntry> typeValues = describeType.getPicklistValues();
        DescribeFieldResult describeSubType = Opportunity.Lead_Sub_Type__c.getDescribe();
        List<PicklistEntry> subTypeValues = describeSubType.getPicklistValues();
    */
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Market__c = market;
        opp.Name = 'Generic Opportunity';
        opp.RecordTypeId = oppRecordTypeId;
        opp.CloseDate = Date.newInstance(2018, 4, 17);
        opp.Selected_Car_Model__c ='CLA;A-Class';
        if(UtilRecordType.getRecordTypeNameById('Opportunity', oppRecordTypeId) == 'Sales Lead'){
            opp.Lead_Type__c = 'New Car';
            opp.Lead_Sub_Type__c = 'Car Configurator';
            opp.Lead_DataSource__c = '3rd Party';
        }
        else{
            opp.Lead_Type__c = 'Parts';
            opp.Lead_Sub_Type__c = 'Accessories';
            opp.Lead_DataSource__c = '3rd Party';
        }
        //opp.Lead_Type__c = typeValues[0].getValue();
        //opp.Lead_Sub_Type__c = subTypeValues[0].getValue();
        insert opp;
        return opp;
    }
    
        public static List<Car_Model__c> createBulkCarModel(Integer n){
        List<Car_Model__c> cModelList = new List<Car_Model__c>();
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'Mercedes-Benz' + i;
            cm.Brand__c = 'Mercedes-Benz';
            cm.Series__c = 'A' + 1;
            cm.Status__c = 'Own Sellable';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cm.Market__c ='AU';
            cm.DFE_Marker__c ='Y';
             cm.Marketing_Class__c = 'CLA';
            cModelList.add(cm);
        }
        for(Integer i=0; i<5; i++){
            Car_Model__c cm = new Car_Model__c();
            cm.Name = 'BMW GT Series' + i;
            cm.Brand__c = 'BMW';
            cm.Series__c = 'GT' + 1;
            cm.Status__c = 'Competitor';
            cm.Colour__c = 'Blue';
            cm.Trim__c = 'Small';
            cm.Market__c ='AU';
            cm.DFE_Marker__c ='Y';
            cm.Marketing_Class__c = 'A-Class';
            cModelList.add(cm);
        }
        insert cModelList;
        return cModelList;
    }
    
    
    
}