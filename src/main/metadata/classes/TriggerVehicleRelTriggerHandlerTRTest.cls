/*
      Name:Hildaa
      Description:Test class for TriggerVehicleRelTriggerHandler for TR
      Modified Date: 
  */

@isTest
public class TriggerVehicleRelTriggerHandlerTRTest{


    public static User user1;
        public static User user2;
        public static User user3;
        public static User integrationAPI;
        public static List<Case> CaseFieldsList;
        public static List<Vehicle_Relationship__c> VehicleRelFieldsList;


    static void setupTestData(){
       Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       Profile p2 = [SELECT Id,Name FROM Profile WHERE Name=:Label.IntProfileName];
       PermissionSet ps = new PermissionSet();
       ps.Name = 'Test';
       ps.Label = 'Test';
       insert ps;
 
     
       user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='TR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user2 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user2 );
        user3 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser3@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user3 );
       system.runas(user1){
        Trigger__c CaseTriggerMY= new Trigger__c(Name='TriggerVehicleRelationshipTR',Trigger_Name__c='TriggerVehicleRelationship',Trigger_Handler__c='TriggerVehicleRelTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
    insert CaseTriggerMY;
   
    
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
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.MYGeneric ];
        
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = user2.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
       System.runAs (user1) {  
        List<String> AccountFields=new List<String>();
        AccountFields.add('Lastname');
        AccountFields.add('Individual_Home_Phone__c');
        AccountFields.add('Work_Phone__c');
        AccountFields.add('fax');
        AccountFields.add('Mobile__c');
        AccountFields.add('MD__c');
    AccountFields.add('Market__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
        AccountFieldsList[0].Lastname='Lastname1';
        AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
        AccountFieldsList[0].Work_Phone__c='+60825634789541';
        AccountFieldsList[0].fax='+60827896541';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].MD__c='TR';
    AccountFieldsList[0].Market__c='TR';
        AccountFieldsList[0].email__c='abc@xyz.com';
        insert AccountFieldsList;
        List<String> VehicleFields=new List<String>();
        //VehicleFields.add('recordtype');
        VehicleFields.add('Brand__c');
        List<Vehicle__c> VehicleFieldsList=DataFactoryServices.createRecords('Vehicle__c',VehicleFields,'',1);
        VehicleFieldsList[0].RecordTypeId=Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        VehicleFieldsList[0].Brand__c='BMW';
        insert VehicleFieldsList;
        
        List<String> VehicleRelFields=new List<String>();
        VehicleRelFields.add('Car_Relation__c');
        VehicleRelFields.add('Contact__c');
        VehicleRelFields.add('Vehicle_ID__c');
        VehicleRelFields.add('Status_1__c');
        VehicleRelFields.add('Market__c');
        VehicleRelFieldsList=DataFactoryServices.createRecords('Vehicle_Relationship__c',VehicleRelFields,'',1);
        VehicleRelFieldsList[0].Car_Relation__c='Purchaser';
        VehicleRelFieldsList[0].Contact__c=AccountFieldsList[0].Id;
        VehicleRelFieldsList[0].Vehicle_ID__c=VehicleFieldsList[0].Id;
        VehicleRelFieldsList[0].Status_1__c='C';
        VehicleRelFieldsList[0].MD__c='TR';
        VehicleRelFieldsList[0].Market__c='TR';
      }
   } 
}
  
    static testMethod void testAccAssignment() {
          setupTestData();
           System.runAs (user2) {  
           test.starttest();
         
                     insert VehicleRelFieldsList;
                     update  VehicleRelFieldsList;
                     delete VehicleRelFieldsList;            
                test.stoptest(); 
        }
     }
    
    static testMethod void testAccAssignmentINT() {
         
          setupTestData();
         
           System.runAs (user3) {  
                   TriggerUtil.userCreate=false;
                     insert VehicleRelFieldsList;
                     update VehicleRelFieldsList;
                     delete VehicleRelFieldsList;            
                
        }
     }
     
   }