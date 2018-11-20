//SB2017
    /*
      Name:Sushma Bharti
      Description:Test class for TriggerVehicleRelTriggerHandler for AU
      Modified Date: 2017-09-13
  */

@isTest
public class TriggerVehicleRelTriggerHandlerAUTest{


  public static User user1;
       public static User user2;
       public static User user3;
       public static User integrationAPI;
       public static List<Case> CaseFieldsList;
       public static List<Vehicle_Relationship__c> vrlst;
       public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle_Relationship__c','Vehicle Relationship Retail');
   
       public static List<Account> accList;


    static void setupTestData(){
       Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       Profile p2 = [SELECT Id,Name FROM Profile WHERE Name='IntegrationAPI'];
       PermissionSet ps = new PermissionSet();
       ps.Name = 'Test';
       ps.Label = 'Test';
       insert ps;
 
     
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='AU',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user2 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user2 );
        user3 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser3@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user3 );
         Group gr=new Group(Name='AU12345');
        insert gr;
       system.runas(user1){
        Trigger__c VRTriggerAU= new Trigger__c(Name='TriggerVehicleRelationshipAU',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerAU',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='AU');
    insert VRTriggerAU;
   
   Configuration_Rule__c  Config =  New Configuration_Rule__c (active__c = true, market__c = 'AU', Rule_Name__C = 'Australia Mapping', type__C = 'Field Mapping');
    insert Config;
    Configuration_Rule_Item__c Citem = new Configuration_Rule_Item__c (active__c = true, Configuration_Rule__c = Config.Id, Destination__C = 'ip_vehicleRel_Id', 	Object_API__c = 'Vehicle_Relationship__c');
    insert Citem;
    Configuration_Rule_Item__c Citem1 = new Configuration_Rule_Item__c (active__c = true, Configuration_Rule__c = Config.Id, Destination__C = 'ip_VehicleId', 	Object_API__c = 'Vehicle__c');
    insert Citem1;            
    
    SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        //.debug('p--'+TriggerAccountTH);
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh); 
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.AUGeneric ];
        
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user2.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        System.runAs (user1) {  
         accList = new List<Account>();
        Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
        Account accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+6612123789', md__c ='AU');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Id recordTypeAccCompanyAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       Account accObjcomp = new Account(RecordTypeId = recordTypeAccCompanyAccountObjId ,Name = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+6612123789', md__c ='AU');
        accList.add(accObjcomp);
        Account accObj1 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Individual_Home_Phone__c='+6612123789',Dealer_ND_Code__c='12345', md__c ='AU');
        accList.add(accObj1);
        Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Home_Phone_2__c = '02202245626',Individual_Home_Phone__c='+6612123789',Dealer_ND_Code__c='12345', md__c ='AU');
        accList.add(accObj2);
        insert accList;
        
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        Vehicle__c vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000, md__c ='AU');
        insert vehicleObj;
        vrlst = new List<Vehicle_Relationship__c>();
       Vehicle_Relationship__c vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(0).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accList.get(2).Id,recordtypeid=retailCompany_RecordTypeId, md__c ='AU');
        vrlst.add(vehicleRelationshipObj);
        Vehicle_Relationship__c vehicleRelationshipObj1 = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(0).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX', md__c ='AU',Owner_Dealer__c=accList.get(2).Id);
        vrlst.add(vehicleRelationshipObj1);
        Vehicle_Relationship__c vehicleRelationshipObj2 = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Partner',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Company_Account__C=accList.get(1).Id,Contact__c =accList.get(1).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data',vehicle_mail_picklist__c='MyMercedes Email',vehicle_fax_picklist__c='Work FAX',Owner_Dealer__c=accList.get(2).Id,recordtypeid=retailCompany_RecordTypeId, md__c ='AU');
        vrlst.add(vehicleRelationshipObj2);
        
       
        
      }
   } 
}
  
    static testMethod void testAccAssignment() {
          setupTestData();
           System.runAs (user2) {  
           test.starttest();
            TriggerUtil.userCreate=false;
           insert vrlst;
           update  vrlst;
            TriggerUtil.userCreate=false;
           delete vrlst;            
           test.stoptest(); 
        }
     }
    
    static testMethod void testAccAssignmentINT() {
         
          setupTestData();
         TriggerUtil.userCreate=false;
           System.runAs (user1) {  
                   TriggerUtil.userCreate=false;
                     insert vrlst;
                     update vrlst;
                     vrlst[0].owner_Dealer__c=null;
                     Vrlst[1].owner_Dealer__c=acclist[3].id;
                      update vrlst;
                     delete vrlst;            
                
        }
     }
     
   }