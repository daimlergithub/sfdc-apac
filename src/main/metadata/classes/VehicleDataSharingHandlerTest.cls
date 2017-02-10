@isTest
public With Sharing class VehicleDataSharingHandlerTest
{
    public static List<Account> accList;
    public static Account accObj;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj;
    public static Lead__c leadObj;
    public static List<Lead__c> leadlst;
    public static Contact contactObj;
    public static List<Contact> contactlst;
    public static testmethod void UtilSobjectInsert_test()
    {
        Profile profileObj = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        UserRole roleObj = [Select Id From UserRole Where Name = 'IT Manager' Limit 1];
        User runAsUser = new User(
        Username = System.now().millisecond() + 'test12Z34558@test.com',
        //ContactId = contactObj.Id,
        UserRoleId  = roleObj.Id,
        ProfileId = profileObj.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        //UserType ='Portal',
        CommunityNickname = 'test123451085',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        insert runAsUser;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(runAsUser){
            createData();
        }
        List<User> userlst = new List<User>();
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Partner Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactlst.get(0).Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        isActive = true
        );
        userlst.add(portalUser1);
        portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z35@test.com',
        ContactId = contactlst.get(1).Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'random11',
        Email = 'test123d45@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'test1d234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        isActive = true
        );
        userlst.add(portalUser1);
        portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z3s@test.com',
        ContactId = contactlst.get(2).Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'random12',
        Email = 'test12sd45@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'test1s234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        isActive = true
        );
        userlst.add(portalUser1);
        portalUser1 = new User(
        Username = System.now().millisecond() + 'test1fZ3s@test.com',
        ContactId = contactlst.get(3).Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'random13',
        Email = 'test12fd45@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'teft1s234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        isActive = true
        );
        userlst.add(portalUser1);
        
        
        insert userlst;
        Test.startTest();
           VehicleDataSharingHandler vheicleObj = new VehicleDataSharingHandler();
           vheicleObj.executeProcessByCRMCode(accList);
        Test.stopTest();
    }
    public static void createData(){
        accList = new List<Account>();
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c ='569833');
        accList.add(accObj);
        
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c = '569833');
        accList.add(accObj);
        
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c = '25413698');
        accList.add(accObj);
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c = '25413698');
        accList.add(accObj);
        insert accList;
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='tlikkkkkkkklllll',EuroVIN__c ='tlikkkkkkkkllllll',CurrentMileage__c=5000,NextMileage__c=6000);
        insert vehicleObj;
        Id recordTypeVehicleRObjId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
        
        List<Vehicle_Relationship__c> vehicleRelationshiplst = new List<Vehicle_Relationship__c>();
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(0).Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accList.get(0).Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accList.get(1).Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(2).Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accList.get(2).Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(3).Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accList.get(3).Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        insert vehicleRelationshiplst;
        contactlst = new List<Contact>();
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId = accList.get(0).Id,Dealer_Complaint_Gate_Keeper__c =true);
        contactlst.add(contactObj);
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId = accList.get(1).Id,Dealer_Complaint_Gate_Keeper__c =true);
        contactlst.add(contactObj);
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId = accList.get(2).Id,Dealer_Complaint_Gate_Keeper__c =true);
        contactlst.add(contactObj);
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId = accList.get(3).Id,Dealer_Complaint_Gate_Keeper__c =true);
        contactlst.add(contactObj);
        insert contactlst;
       
        
        
    }
}