@isTest
public With Sharing class UtilCaseShareTest
{
     public static Account accObj;
     public static Vehicle__c vehicleObj;
     public static Case caseObj;
     public static caseTeamMember caseTeamMemberObj;
     public static Contact contactObj;
     public static List<Account> accList;
     public static UserRole userRoleObj;
    // public static Community_License_Switch__c communityLicenceObj;
     public static testmethod void ShareVehicleToNewUser_test()
    {
        createData();
        Test.startTest();
            Map<Id, Id> casesToShare = new Map<Id,Id>();
            Map<String, String> vehicleToOwner = new Map<String,String>();
            casesToShare.put(caseObj.Id,accObj.Id);
            vehicleToOwner.put(vehicleObj.Id,caseObj.OwnerId);
            UtilCaseShare.shareCase(casesToShare, vehicleToOwner);
        Test.stopTest();
    }
    public static testmethod void shareCaseWithoutshareVehicle_test()
    {
        
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
            createData();
        }
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Dealer Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1]; 
        /*User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactObj.Id,
        UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        //UserType ='Portal',
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        
        insert portalUser1;
        */
        
        Test.startTest();
            
            Map<id,Set<Id>> casesToShare = new Map<id,Set<Id>>();
            if(!casesToShare.containsKey(caseObj.Id)){
                casesToShare.put(caseObj.Id,new Set<Id>());
            }
            casesToShare.get(caseObj.Id).add(caseObj.Support_Dealer_1__c);
            
            
            
            System.runAs(thisUser){
                
                CaseTeamRole caseTeamRoleObj = [Select Id from CaseTeamRole where Name='Dealer'];
                
                caseTeamMemberObj = new caseTeamMember(parentId = caseObj.Id,MemberId = UserInfo.getUserId(),TeamRoleId=caseTeamRoleObj.Id );
                insert  caseTeamMemberObj;
                UtilCaseShare.shareCaseWithoutshareVehicle(casesToShare);
                system.assertNotEquals(caseTeamMemberObj.parentId ,null);
            }
            
            // caseTeamMemberObj = 
        Test.stopTest();
    } 
    public static testmethod void getGateKeepers_test()
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
        
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Dealer Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactObj.Id,
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
        LanguageLocaleKey = 'en_US'
        );
        
        insert portalUser1;
        Test.startTest();
           // createData();
            List<Case> caseIds = new List<Case>();
            caseIds.add(caseObj);
            UtilCaseShare.getGateKeepers(caseIds);
            system.assertNotEquals(caseIds,null);
        Test.stopTest();
    }
    public static testmethod void shareCustomerToGateKeeper_test()
    {
        Test.startTest();
            createData();
            Map<Id, Id> customerGateKeepers = new Map<Id,Id>();
            system.assertNotEquals(customerGateKeepers ,null);
            //UtilCaseShare.shareCustomerToGateKeeper(customerGateKeepers);
        Test.stopTest();
    }
    
    public static testmethod void utilConstantTest()
    {
        Test.startTest();
            UtilConstant utilContant = new UtilConstant();
            UtilConstant.getUserRoleId('Dealer User');
            UtilConstant.getProfileId('System Administrator');
            system.assertNotEquals(utilContant ,null);
        Test.stopTest();
    }
    public static testmethod void UtilCustomSettings_Test()
    {
        Test.startTest();
            createCustomSettingData();
            UtilCustomSettings.getProfileId('System Administrator');
            UtilCustomSettings.getIsEnableCommunity('Test');
            system.assertNotEquals(UtilCustomSettings.getProfileId('System Administrator'),null);
        Test.stopTest();
    }
    public static testmethod void UtilCustomSettingsNegative_Test()
    {
        Test.startTest();
            createCustomSettingData();
            UtilCustomSettings.getProfileId(null);
            UtilCustomSettings.getIsEnableCommunity(null);
            system.assertNotEquals(UtilCustomSettings.getProfileId(null),'System Administrator');
        Test.stopTest();
    }
    public static void createData(){
        
        accList = new List<Account>();
        Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez');
        accList.add(accObj);
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez');
        accList.add(accObj);
        insert accList;
        Id recordTypeVehiObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehiObjId,Brand__c = 'Maybach',Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                
        insert vehicleObj;
        Id recordTypeCaseObjId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        caseObj =new Case(RecordTypeId= recordTypeCaseObjId,AccountId=accList.get(0).Id,Vehicle__c = vehicleObj.Id,Support_Dealer_1__c = accObj.Id,Case_Dealer__c =accList.get(1).Id );
        insert caseObj;
        
        
        
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId = accList.get(1).Id,Dealer_Complaint_Gate_Keeper__c =true);
        insert contactObj;
        
    }
    
    public static void createCustomSettingData(){
        List<Community_License_Switch__c> customSettinglst = new List<Community_License_Switch__c>();
        Community_License_Switch__c communityLicenceObj = new Community_License_Switch__c(Name = 'Test', Enable__c = true);
        customSettinglst.add(communityLicenceObj);
        insert customSettinglst;
        List<Environment_Specific_Values__c> enviromentlst = new List<Environment_Specific_Values__c>();
        Environment_Specific_Values__c enviromentObj = new Environment_Specific_Values__c(Name = 'System Administrator', Value__c = '00eO0000000MIUb');
        enviromentlst.add(enviromentObj);
        insert enviromentlst;
    }
    
}