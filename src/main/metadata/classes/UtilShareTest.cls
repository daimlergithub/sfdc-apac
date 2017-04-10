@istest
public class UtilShareTest {
    static testmethod void UtilShareTestMethod(){
    set<id> rtlst = new Set<id>();
    Set<id> dealerAccountIds = new Set<id>();
    Set<id> userIds = new Set<id>();
    Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
    Id salesleadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId(); 
  
    Set<id> parentId1 = new Set<id>();
    Set<id> parentId2 = new Set<id>();
    Set<id> UserOrGroupId = new Set<id>();
    
    List<Account> accobjlist = new List<Account>();
    Account accobj = new account();
    accobj = new Account();
    accobj.RecordTypeId = DealerRecordTypeId ;
    accobj.Name = 'testaccount';
    accobj.Phone = '000-0000-9642';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '000-0000-9642';
    accobj.ZipCode__c= '1002347';
    //accobj.Parentid='001p000000GgV8s';
    accobjlist = new List<Account>();
    accobjlist.add(accobj);
    insert accobjlist;
       
    Vehicle__c vehicle = new Vehicle__c();    
    vehicle = new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
    insert vehicle;
    
    Vehicle_Relationship__c retailVehicleRelationship = new Vehicle_Relationship__c();    
    retailVehicleRelationship.Vehicle_ID__c = vehicle.Id;
    insert retailVehicleRelationship;
    
    User usr = new user();
    Profile prof = [select Id from Profile where Name = 'System Administrator'];
    usr = new User (ProfileId = prof.Id, isActive = true, Username ='lai1@nttdata.com',LastName='sichaof',Email='sichao.lai@nttdata.com',Alias='laisc',CommunityNickname='barney1',
                  TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
    insert usr;    
    Lead__c leadobj = new Lead__c ();
    leadobj = new Lead__c();
    leadobj.RecordTypeId = salesleadRecordTypeId;
    leadobj.CAC_Lead_Status__c = 'Qualified';
    leadobj.Lead_Type__c = 'New Car';
    leadobj.Assigned_Dealer__c = accobj.Id;    
    leadobj.AfterSales_Vehicle__c =vehicle.id;
    leadobj.VehicleRel_No__c =retailVehicleRelationship.id;
    insert leadobj;
    system.debug('vehicle.id >> 1:'+vehicle.id);
    system.debug('vehicle.id >> 2:'+retailVehicleRelationship.id);
    
    parentId2.add(leadobj.VehicleRel_No__c);  
      
        rtlst.add(leadobj.id);
      
        parentId1.add(leadobj.AfterSales_Vehicle__c);      
        system.runas(usr){
        UtilShare us = new UtilShare();
        userids.add(userinfo.getuserid());
        dealerAccountIds.add(accobj.id);
        UserOrGroupId.add(userinfo.getuserid()); 
        
       // us.createShareObject(dealerAccountIds,UserOrGroupId,'READ');        
       // us.VehicleShare(parentId1,UserOrGroupId,'READ');
        
        UtilShare.groupmembersadd(rtlst,dealerAccountIds);
       // us.VehicleRelationshipShare(parentId2,UserOrGroupId,'READ');
        UtilShare.DealerGroupCreation(dealerAccountIds,userids);
    }   
  }
  
}