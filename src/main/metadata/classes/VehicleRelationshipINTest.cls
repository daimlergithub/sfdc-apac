/**
** Class: VehicleRelationshipINTest
** Description: Test Class for TriggerVehicleRelTriggerHandlerIN, VehicleRelationshipHelperBase and VehicleRelationshipHelperIN
** Created By: Prem Kumar
** Date: 23/05/2018
**/
@IsTest
public class VehicleRelationshipINTest {
    
    public static User integrationAPI;
    public static List<Case> CaseFieldsList;
    public static List<Vehicle_Relationship__c> vrlst;
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c','Vehicle Relationship Retail');    
    public static List<Account> accList;
    
    static void setupTestData(){
        Profile p = [SELECT Id,Name FROM Profile WHERE Name=:Label.IntProfileName];
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;        
        integrationAPI = new User(Alias = 'standt', Email='testUser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, Market__c='IN',
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(integrationAPI );
        Group gr=new Group(Name='IN12345');
        insert gr;
        system.runas(integrationAPI){
            Trigger__c CaseTriggerIN = new Trigger__c(Name='TriggerVehicleRelationshipIN',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
            insert CaseTriggerIN;
            
            System.runAs (integrationAPI) {  
                accList = new List<Account>();
                Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();              
                Account accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,Market__c='IN',FirstName = 'India',LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+911234567890', md__c ='IN');
                accList.add(accObj);
                Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
                Id recordTypeAccCompanyAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                Account accObjcomp = new Account(RecordTypeId = recordTypeAccCompanyAccountObjId ,Market__c='IN',Name = 'Mercedez-Benz1',Corporate_Category__c='Corporate Loyalty',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+911234567890', md__c ='IN');
                accList.add(accObjcomp);
                Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Market__c='IN',Name = 'Benz2', Individual_Home_Phone__c='+911234567890',Dealer_ND_Code__c='12345', md__c ='IN');
                accList.add(accObj1);
                Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerObjId,Market__c='IN',Name = 'Benz3', Home_Phone_2__c = '02202245626',Individual_Home_Phone__c='+911234567890',Dealer_ND_Code__c='12345', md__c ='IN');
                accList.add(accObj2);
                insert accList;
                
                Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
                Vehicle__c vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',Market__c='IN',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000, md__c ='IN');
                insert vehicleObj;
                vrlst = new List<Vehicle_Relationship__c>();
                Vehicle_Relationship__c vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Market__c='IN',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(0).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accList.get(2).Id,recordtypeid=retailCompany_RecordTypeId, md__c ='IN');
                vrlst.add(vehicleRelationshipObj);
                Vehicle_Relationship__c vehicleRelationshipObj1 = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Market__c='IN',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(0).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX', md__c ='IN',Owner_Dealer__c=accList.get(2).Id);
                vrlst.add(vehicleRelationshipObj1);
                Vehicle_Relationship__c vehicleRelationshipObj2 = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Market__c='IN',Owner_Relation__c = 'Partner',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(1).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accList.get(2).Id,recordtypeid=retailCompany_RecordTypeId, md__c ='IN');
                vrlst.add(vehicleRelationshipObj2);
                TriggerUtil.userCreate=false;
            }
        } 
    }
    
    static testMethod void testAccAssignment() {
        setupTestData();
        System.runAs (integrationAPI) {  
            test.startTest();
            TriggerUtil.userCreate=false;
            insert vrlst;
            update  vrlst;
            TriggerUtil.userCreate=false;
            delete vrlst;            
            test.stopTest();
        }
    }
        
}