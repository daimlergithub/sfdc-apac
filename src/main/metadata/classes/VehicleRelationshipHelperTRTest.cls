@istest
public class VehicleRelationshipHelperTRTest {
@testSetup
    static void setupTestData(){    
    
    Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User1'+System.Today(),Market__c='TR',country='Turkey',firstName='first',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='veena.adhyapak@infosys.com',UserName='veena@infosys.com.dev');
       insert user1;
       System.runAs (user1) {  
        List<String> AccountFields=new List<String>();
        AccountFields.add('name');
        AccountFields.add('Mobile__c');
        AccountFields.add('Market__c');
        AccountFields.add('Data_Source__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',2);
        AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.Company);
        AccountFieldsList[0].name='compname1';
        AccountFieldsList[0].Mobile__c='9856321478';
        AccountFieldsList[0].Market__c='TR'; 
        AccountFieldsList[0].Data_Source__c='Past data';
        AccountFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.Company);
        AccountFieldsList[1].name='compname2';
        AccountFieldsList[1].Mobile__c='9856321478';
        AccountFieldsList[1].Market__c='TR'; 
        AccountFieldsList[1].Data_Source__c='Past data';
      
        insert AccountFieldsList;
        
        List<String> ContactFields=new List<String>();
        ContactFields.add('Accountid');
        ContactFields.add('lastname');
        ContactFields.add('email');
        ContactFields.add('Federation_ID__c');
        ContactFields.add('phone');
            ContactFields.add('Market__c');   
        List<Contact> ContactFieldsList=DataFactoryServices.createRecords('Contact',ContactFields,'',1);
        ContactFieldsList[0].accountid=AccountFieldsList[0].id;
        ContactFieldsList[0].Lastname='Lastname1';
        ContactFieldsList[0].Federation_ID__c='9856321478';
        ContactFieldsList[0].email='ab@cd.com';   
        ContactFieldsList[0].phone='7412563089';
            ContactFieldsList[0].Market__c='TR';
        insert ContactFieldsList;
        
        List<String> VehicleFields=new List<String>();
        //VehicleFields.add('recordtype');
        VehicleFields.add('Brand__c');
            VehicleFields.add('Market__c');
        List<Vehicle__c> VehicleFieldsList=DataFactoryServices.createRecords('Vehicle__c',VehicleFields,'',1);
        VehicleFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Vehicle__c',Label.MB_Vehicle);
        VehicleFieldsList[0].Brand__c='BMW';
            VehicleFieldsList[0].Market__c='TR';
        insert VehicleFieldsList;
        
        List<String> VehicleRelFields=new List<String>();
        VehicleRelFields.add('Car_Relation__c');
        VehicleRelFields.add('Contact__c');
        VehicleRelFields.add('Vehicle_ID__c');
        VehicleRelFields.add('Status_1__c');
        VehicleRelFields.add('Validity__c');
        VehicleRelFields.add('Owner_Relation__c');
        VehicleRelFields.add('Market__c');
        List<Vehicle_Relationship__c> VehicleRelFieldsList=DataFactoryServices.createRecords('Vehicle_Relationship__c',VehicleRelFields,'',2);
        VehicleRelFieldsList[0].Car_Relation__c='Purchaser';
        VehicleRelFieldsList[0].Contact__c=AccountFieldsList[0].Id;
        VehicleRelFieldsList[0].Vehicle_ID__c=VehicleFieldsList[0].Id;
        VehicleRelFieldsList[0].Status_1__c='C';
        VehicleRelFieldsList[0].Start_Date__c=system.today();
        VehicleRelFieldsList[0].End_Date__c=null;
        VehicleRelFieldsList[0].Validity__c='Yes';
        VehicleRelFieldsList[0].Owner_Relation__c='Friend';
        VehicleRelFieldsList[0].Market__c='TR';
        VehicleRelFieldsList[1].Car_Relation__c='Sales Contact Target';
        VehicleRelFieldsList[1].Contact__c=AccountFieldsList[1].Id;
        VehicleRelFieldsList[1].Vehicle_ID__c=VehicleFieldsList[0].Id;
        VehicleRelFieldsList[1].Status_1__c='C';
        VehicleRelFieldsList[1].Start_Date__c=system.today();
        VehicleRelFieldsList[1].End_Date__c=null;
        VehicleRelFieldsList[1].Validity__c='Yes';
        VehicleRelFieldsList[1].Market__c='TR';
        VehicleRelFieldsList[0].Owner_Relation__c='Colleague';
        insert VehicleRelFieldsList;
        
        }
                
    }
    
    //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-10-09
  */
//Added for TR
    static testmethod void testVehicleRelationshipHelperTR1(){
    
    Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
       User user1 = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral1.com.dev01');
       insert user1;
       System.runAs (user1) {  
      test.startTest();
      List<Account> AccountList  =  [SELECT RecordTypeid, Lastname, Mobile__c, MD__c, Market__c from Account];
      List<Contact> ContactList  =  [SELECT accountid,lastname,email,phone,Federation_ID__c from Contact];
      Set<id> contactids=new set<id>();
      contactids.add(contactlist[0].id);
      List<Vehicle__c> VehicleList  =  [SELECT Brand__c from Vehicle__c];
      List<Vehicle_Relationship__c> VehRelList  =  [SELECT Car_Relation__c, Contact__c, Status_1__c, Vehicle_ID__c,Start_Date__c,End_Date__c,Validity__c,Owner_Relation__c from Vehicle_Relationship__c];
      Map<Id,Vehicle_Relationship__c> oldMapVR=new Map<Id,Vehicle_Relationship__c>();
      oldMapVR.put(VehRelList[0].id,vehRelList[0]);
      oldMapVR.put(VehRelList[1].id,vehRelList[1]);
      Set<id> VehicleIds=new set<id>();
      VehicleIds.add(vehiclelist[0].id);
      Set<id> VehicleRelationshipIds=new set<id>();
      VehicleRelationshipIds.add(vehrellist[0].id);
      VehicleRelationshipIds.add(vehrellist[1].id);
      Set<Id> contactIdofVehicleRelationship=new set<id>();
      contactIdofVehicleRelationship.add(VehRelList[0].Contact__c);
      contactIdofVehicleRelationship.add(VehRelList[1].Contact__c);
      VehicleRelationshipHelperTR.OnAfterInsert(VehRelList);
      VehicleRelationshipHelperTR.OnAfterUpdate(VehRelList,oldMapVR);
      VehicleRelationshipHelperTR.OnAfterDelete(VehRelList);
      VehicleRelationshipHelperTR.updateAccountstatus(ContactIds);
      VehicleRelationshipHelperTR.updateVehicleAmount(ContactIds);
      //VehicleRelationshipHelperTR.createAccountLink(VehicleIds, VehicleRelationshipIds,contactIdofVehicleRelationship);
      test.stopTest(); 
      
      }   
    }
}