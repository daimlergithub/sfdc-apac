/**
** Class: salesLeadEditControllerTest 
** Description: Test Class for salesLeadEditController
** Created By: Sravanthi Gudibandi
** Date: 10-April-2018
** Updated By: Madhusudhan CS - 24-05-2018
**/

@IsTest
public class SalesLeadEditControllerTest {
    
    
    
    public static String salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    public static Profile p1;
    public static User usr;
    public static Account companyAcc;
    public static Opportunity oppSales;
    public static List<Car_Model__c> carModelList;
    public static List<Lead_Details__c> ledDetList;
    
    @TestSetup
    
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            oppSales = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
            carModelList = createBulkCarModel(7);
            ledDetList = TestUtils.createBulkLeadDetails(oppSales, carModelList);
        }
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            // Opportunity oppty = [select Id, Name From Opportunity];
            Opportunity opp = new Opportunity();
            opp.AccountId =  companyAcc.Id;
            opp.StageName = 'New';
            opp.Market__c = 'IN';
            opp.Name = 'Generic Opportunity';
            opp.RecordTypeId = salesLeadRecordTypeId;
            opp.Lead_Type__c = 'Activities';
            opp.Lead_Sub_Type__c = 'Dealer Event';
            opp.Lead_DataSource__c = 'Event';
            opp.Type_of_Sale__c = 'Corporate';
            opp.CloseDate = Date.Today();
            opp.Selected_Car_Model__c ='CLA;A-Class'; 
            insert opp;   
            List<Car_Model__c> cmlList = [Select Id, Name From Car_Model__c limit 14];
            List<Lead_Details__c> ldList = [Select Id, Name From Lead_Details__c Where Related_Lead__c =: opp.Id];
            ApexPages.currentPage().getParameters().put('id', opp.Id);
            ApexPages.StandardController objsc = new ApexPages.StandardController(opp);
            
            SalesLeadEditController slec = new SalesLeadEditController(objsc);
            PageReference pageRef = Page.SalesLeadEditPage;
            slec.getTradeInVehicles();
            slec.addIntRecord();
            slec.checkCompVehiclePreferred();
            slec.addCompRecord();
            slec.UpdateModInfoCtrl();
            slec.checkIntVehiclePreferred();
            slec.saveOpp();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveOpportunity2() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            // Opportunity oppty = [select Id, AccountId, Name From Opportunity limit 1];
            Opportunity opp = new Opportunity();
            opp.AccountId =  companyAcc.Id;
            opp.StageName = 'New';
            opp.Market__c = 'IN';
            opp.Name = 'Generic Opportunity';
            opp.RecordTypeId = salesLeadRecordTypeId;
            opp.Lead_Type__c = 'Activities';
            opp.Lead_Sub_Type__c = 'Dealer Event';
            opp.Lead_DataSource__c = 'Event';
            opp.Type_of_Sale__c = 'Corporate';
            opp.CloseDate = Date.Today();
            opp.Selected_Car_Model__c ='CLA;A-Class'; 
            insert opp;   
            ApexPages.currentPage().getParameters().put('id', opp.Id);
            ApexPages.StandardController objsc = new ApexPages.StandardController(opp);
            SalesLeadEditController slec = new SalesLeadEditController(objsc);
            PageReference pageRef = Page.SalesLeadEditPage;
            
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(17);
            List<Lead_Details__c> ldList = new List<Lead_Details__c>();
            for(Car_Model__c cm : carModelList){
                Lead_Details__c lDet = new Lead_Details__c();
                if(cm.Status__c == 'Own Sellable'){
                    lDet.Car_Model__c = cm.Id;
                    lDet.Related_Lead__c = opp.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                    ldList.add(lDet);
                }
                else if(cm.Status__c == 'Competitor'){
                    lDet.Car_Model_Competitor__c = cm.Id;
                    lDet.Related_Lead__c = opp.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                    ldList.add(lDet);
                } 
            }
            Lead_Details__c lDet1 = new Lead_Details__c();
            lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
            lDet1.Related_Lead__c = opp.Id;
            lDet1.Trim__c = 'Medium';
            lDet1.Mileage__c = '40';
            lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
            ldList.add(lDet1);
            slec.allVehiclesList = ldList;
            slec.getTradeInVehicles();
            slec.addIntRecord();
            slec.checkCompVehiclePreferred();
            slec.addCompRecord();
            slec.UpdateModInfoCtrl();
            slec.checkIntVehiclePreferred();
            slec.saveOpp();
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testSaveOpportunity3() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            //Opportunity oppty = [select Id, AccountId, Name From Opportunity limit 1];
            Opportunity opp = new Opportunity();
            opp.AccountId =  companyAcc.Id;
            opp.StageName = 'New';
            opp.Market__c = 'IN';
            opp.Name = 'Generic Opportunity';
            opp.RecordTypeId = salesLeadRecordTypeId;
            opp.Lead_Type__c = 'Activities';
            opp.Lead_Sub_Type__c = 'Dealer Event';
            opp.Lead_DataSource__c = 'Event';
            opp.Type_of_Sale__c = 'Corporate';
            opp.CloseDate = Date.Today();
            opp.Selected_Car_Model__c ='CLA;A-Class'; 
            insert opp;   
            System.debug('oppty==>' + opp);
            ApexPages.currentPage().getParameters().put('id', opp.Id);
            ApexPages.StandardController objsc = new ApexPages.StandardController(opp);
            SalesLeadEditController slec = new SalesLeadEditController(objsc);
            PageReference pageRef = Page.SalesLeadEditPage;
            
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(17);
            List<Lead_Details__c> ldList = new List<Lead_Details__c>();
            for(Car_Model__c cm : carModelList){
                Lead_Details__c lDet = new Lead_Details__c();
                if(cm.Status__c == 'Own Sellable'){
                    lDet.Car_Model__c = cm.Id;
                    lDet.Related_Lead__c = opp.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Preferred__c = true;
                    lDet.Mileage__c = '40';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                    ldList.add(lDet);
                }
                else if(cm.Status__c == 'Competitor'){
                    lDet.Car_Model_Competitor__c = cm.Id;
                    lDet.Related_Lead__c = opp.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Preferred__c = true;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                    ldList.add(lDet);
                } 
            }
            Lead_Details__c lDet1 = new Lead_Details__c();
            lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
            lDet1.Related_Lead__c = opp.Id;
            lDet1.Trim__c = 'Medium';
            lDet1.Mileage__c = '40';
            lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
            ldList.add(lDet1);
            slec.allVehiclesList = ldList;
            
            slec.getTradeInVehicles();
            slec.addIntRecord();
            slec.checkCompVehiclePreferred();
            slec.addCompRecord();
            slec.UpdateModInfoCtrl();
            slec.checkIntVehiclePreferred();
            slec.saveOpp();
        }
        test.stopTest();
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
            cm.Variant__c = 'abc';
            cm.Market__c ='IN';
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
            cm.Variant__c = 'abc';
            cm.Trim__c = 'Small';
            cm.Market__c ='IN';
            cm.DFE_Marker__c ='Y';
            cm.Marketing_Class__c = 'A-Class';
            cModelList.add(cm);
        }
        insert cModelList;
        return cModelList;
    }
    
}