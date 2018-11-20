/**
** Class: AddToDealershipCommonTest
** Description: Test class for AddToDealershipCommon controller
** Created By: Prem Kumar
** Date: 10-October-2018
**/
@isTest
public class AddToDealershipCommonTest {
    static Id accDealer_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
    static User admUser = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
    static Account compAccount = new Account();
    @testSetup
    static void createTestData(){
        System.runAs(admUser){
            //Create portal account owner
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(UserRoleId = portalRole.Id, ProfileId = profile1.Id, Market__c='IN', isActive = true,
                                                Alias = 'batman', Email='bruce.wayne@wayneenterprises.com', EmailEncodingKey='UTF-8',
                                                Firstname='Bruce', Lastname='Wayne', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago', Username = System.now().millisecond() + 'addtoDealer@daimler.com');
            Database.insert(portalAccountOwner1);
            //Create account
            Account portalAccount1 = new Account(Name = 'TestAccount', recordtypeId = accDealer_RecordTypeId, OwnerId = portalAccountOwner1.Id,
                                                 Market__c='IN', Dealer_ND_Code__c='nd1234');
            Database.insert(portalAccount1);
            //Create contact
            Contact contact1 = new Contact(FirstName = 'Test', Lastname = 'McTesty', AccountId = portalAccount1.Id, 
                                           Email = System.now().millisecond() + 'test@test.com', Market__c='IN');
            Database.insert(contact1);
            //Create user
            Id pId = [select id from profile where name='Partner Community User'].id;
            User portalUser = new User(Username = System.now().millisecond() + 'test12345@test.com', ContactId = contact1.Id, 
                                       ProfileId = pId, Alias = 'test123',  Email = 'test125@test.com', EmailEncodingKey = 'UTF-8',
                                       LastName = 'McTesty', CommunityNickname = 'qwertyu', TimeZoneSidKey = 'America/Los_Angeles',
                                       LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', Market__c='IN', isActive = true);
            Database.insert(portalUser);
        }
    }
    @isTest
    static void testAddToDealership(){
        test.startTest();
        Id pId = [select id from profile where name='Partner Community User'].id;
        User portUsr = [Select Id, Name From User Where ContactId != null And ProfileId =: pId and isActive = true limit 1];
        System.runAs(admUser){
            compAccount = new Account(Name = 'TestAccount', recordtypeId = accCompany_RecordTypeId, Dealer_ND_Code__c = 'nd1234',
                                              Market__c = 'IN', Corporate_Category__c = 'Corporate Loyalty', Work_Phone__c='+911234567890');
            Database.insert(compAccount);
            
            //Create Vehicle 
            Id mbVehRecordTypeId = RecordTypeAccessService.getRecordTypeId('Vehicle__c','MB');
            Vehicle__c veh = new Vehicle__c(Brand__c = 'MB New', recordTypeId = mbVehRecordTypeId, UsVIN__c = '12345678901234567', 
                                            RegistrationNo__c = 'reg1234');
            insert veh;
            Vehicle_Relationship__c vehRel = new Vehicle_Relationship__c(Contact__c=compAccount.Id, Vehicle_ID__c=veh.Id, Status_1__c='A', 
                                                                         Market__c='IN', Registration_Number__c = 'reg1234',
                                                                         OwnerId = portUsr.Id);
            Database.insert(vehRel);
        }
        System.runAs(portUsr){
            AddToDealershipCommon ctrlObj = new AddToDealershipCommon();
            ctrlObj.regNumber = 'reg1234';
            ctrlObj.search();
            ctrlObj.vin = '12345678901234567';
            ctrlObj.search();
            ctrlObj.showPopup();  
            Vehicle_Relationship__c vRel = [Select Id, Contact__c From Vehicle_Relationship__c limit 1];
            AddToDealershipCommon.vehicleRelWrapper testWrap = new AddToDealershipCommon.vehicleRelWrapper(vRel);
            testWrap.selected = true;
            ctrlObj.vehRelWrapList.add(testWrap);
            ctrlObj.showPopup();
            ctrlObj.closePopup();
            ctrlObj.disableCheckbox();
            ctrlObj.retailCopyList = new List<Account_Link__c>();
            ctrlObj.accList.add(compAccount);
            //ctrlObj.createRetailCopyAndRedirect();
        }
        test.stopTest();
    }
}