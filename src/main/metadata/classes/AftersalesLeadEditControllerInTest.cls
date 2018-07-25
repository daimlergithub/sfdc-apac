/**
** Class: AftersalesLeadEditControllerInTest 
** Description: Test Class for AftersalesLeadEditController
** Created By: Prem Kumar
** Date: 10/04/2018
**/
@IsTest
public class AftersalesLeadEditControllerInTest {
    
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();    
    public static Profile p1;
    public static User usr;
    public static Account companyAcc;
    public static Opportunity oppAfterSales;
    public static List<Car_Model__c> carModelList;
    public static List<Lead_Details__c> ledDetList;
    
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            oppAfterSales = TestUtils.createGenericOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN');
            carModelList = TestUtils.createBulkCarModel(2);
            ledDetList = TestUtils.createBulkLeadDetails(oppAfterSales, carModelList);
        }
    }
    
    @IsTest
    private static void testSaveOpportunity1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name From Account limit 1];
            Opportunity oppty = [select Id, AccountId,market__c, Name From Opportunity limit 1];
            System.debug('oppty==>' + oppty);
            ApexPages.currentPage().getParameters().put('id', oppty.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadEditController asLeadCtrl = new AfterSalesLeadEditController(objStdCtrl);
            
            asLeadCtrl.opp = oppty;
            asLeadCtrl.opp.Type_of_Sale__c = 'Government';
            asLeadCtrl.getTradeInVehicles();
            asLeadCtrl.addCompRecord();
            asLeadCtrl.addIntRecord();
            asLeadCtrl.checkCompVehiclePreferred();
            asLeadCtrl.checkIntVehiclePreferred();
            asLeadCtrl.UpdateModInfoCtrl();
            asLeadCtrl.saveOpp();
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
            Opportunity oppty = [select Id, AccountId, Name,market__C From Opportunity limit 1];
            System.debug('oppty==>' + oppty);
            ApexPages.currentPage().getParameters().put('id', oppty.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadEditController asLeadCtrl = new AfterSalesLeadEditController(objStdCtrl);
            
            asLeadCtrl.opp = oppty;
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(17);
            List<Lead_Details__c> ldList = new List<Lead_Details__c>();
            for(Car_Model__c cm : carModelList){
                Lead_Details__c lDet = new Lead_Details__c();
                if(cm.Status__c == 'Own Sellable'){
                    lDet.Car_Model__c = cm.Id;
                    lDet.Related_Lead__c = oppty.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    //lDet.market__C = 'IN';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                    ldList.add(lDet);
                }
                else if(cm.Status__c == 'Competitor'){
                    lDet.Car_Model_Competitor__c = cm.Id;
                    lDet.Related_Lead__c = oppty.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    //lDet.market__C = 'IN';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                    ldList.add(lDet);
                } 
            }
            Lead_Details__c lDet1 = new Lead_Details__c();
            lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
            lDet1.Related_Lead__c = oppty.Id;
            lDet1.Trim__c = 'Medium';
            lDet1.Mileage__c = '40';
            //lDet1.market__C = 'IN';
            lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
            ldList.add(lDet1);
            asLeadCtrl.allVehiclesList = ldList;
            asLeadCtrl.getTradeInVehicles();
            asLeadCtrl.addCompRecord();
            asLeadCtrl.addIntRecord();
            asLeadCtrl.checkCompVehiclePreferred();
            asLeadCtrl.checkIntVehiclePreferred();
            asLeadCtrl.UpdateModInfoCtrl();
            asLeadCtrl.saveOpp();
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
            Opportunity oppty = [select Id, AccountId,Name,market__C From Opportunity limit 1];
            System.debug('oppty==>' + oppty);
            ApexPages.currentPage().getParameters().put('id', oppty.Id);
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oppty);
            AfterSalesLeadEditController asLeadCtrl = new AfterSalesLeadEditController(objStdCtrl);
            
            asLeadCtrl.opp = oppty;
            List<Car_Model__c> carModelList = TestUtils.createBulkCarModel(17);
            List<Lead_Details__c> ldList = new List<Lead_Details__c>();
            for(Car_Model__c cm : carModelList){
                Lead_Details__c lDet = new Lead_Details__c();
                if(cm.Status__c == 'Own Sellable'){
                    lDet.Car_Model__c = cm.Id;
                    lDet.Related_Lead__c = oppty.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Preferred__c = true;
                    lDet.Mileage__c = '40';
                    //lDet.market__C = 'IN';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
                    ldList.add(lDet);
                }
                else if(cm.Status__c == 'Competitor'){
                    lDet.Car_Model_Competitor__c = cm.Id;
                    lDet.Related_Lead__c = oppty.Id;
                    lDet.Brand__c = cm.Brand__c;
                    lDet.Color__c = cm.Colour__c;
                    lDet.Preferred__c = true;
                    lDet.Trim__c = cm.Trim__c;
                    lDet.Mileage__c = '40';
                    //lDet.market__C = 'IN';
                    lDet.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
                    ldList.add(lDet);
                } 
            }
            Lead_Details__c lDet1 = new Lead_Details__c();
            lDet1.Trade_In_Vehicle__c = 'Trade In Vehicle';
            lDet1.Related_Lead__c = oppty.Id;
            lDet1.Trim__c = 'Medium';
            lDet1.Mileage__c = '40';
            //lDet1.market__C = 'IN';
            lDet1.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
            ldList.add(lDet1);
            asLeadCtrl.allVehiclesList = ldList;
            asLeadCtrl.getTradeInVehicles();
            asLeadCtrl.addCompRecord();
            asLeadCtrl.addIntRecord();
            asLeadCtrl.checkCompVehiclePreferred();
            asLeadCtrl.checkIntVehiclePreferred();
            asLeadCtrl.UpdateModInfoCtrl();
            asLeadCtrl.saveOpp();
        }
        test.stopTest();
    }
    
}