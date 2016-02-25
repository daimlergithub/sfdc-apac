@isTest
private class VehicleRelationshipHelperTest {

    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();     // Dealer.
    static Id accPerson_RecordTypeIdp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
    static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();    //VehicleRelationship
                                            
    static Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
                                                
    
     
    static Account account1 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code1',
                                    //Status__c='Unknown',
                                    City__c='Beijing',
                                    Phone = '080801010',
                                    Area_Code__c = '010',
                                    LastName = 'Beijing XING Limited',                                    
                                    RecordTypeId=accPerson_RecordTypeIdp);

    static Account account2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '080801011',
                                    Area_Code__c = '010',            
                                    Name = 'Test',                                  
                                    RecordTypeId=accPerson_RecordTypeId);
    static Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = VRRecordTypeId);
    // CR-000119
    static Vehicle_Relationship__c VR1 = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Owner', RecordTypeId = VRRecordTypeId);
                                                                                                                                                                                                       
    static testMethod void myUnitTest() {
       User userObj = [Select Id,Name from User where Id =:UserInfo.getUserId()];
       UserRole roleObj;
       system.runAs(userObj){
            roleObj = new UserRole(Name ='Test Partner Executive');
            insert roleObj;
        
       }
        List<User> userlst = new List<User>();
        Profile portalProfile = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
       
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        UserRoleId =roleObj.Id,
        //UserType ='Portal',
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        isActive = true
        );
        userlst.add(portalUser1);
        insert userlst;
       system.runAs(userObj){
       Test.StartTest();
            List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;
            List<Account> accList = new List<Account>();
            insert vehicles;
            accList.add(account1);
            accList.add(account2);
            insert accList;
            List<Vehicle_Relationship__c> vehiclelst = new List<Vehicle_Relationship__c>();
            VR.Contact__c = accList.get(0).id;
            VR.Vehicle_ID__c = vehicles.id;
            VR.Owner_Dealer__c = accList.get(1).id;
            vehiclelst.add(VR);
            VR1.Contact__c = accList.get(0).id;
            VR1.Vehicle_ID__c = vehicles.id;
            VR1.Owner_Dealer__c = accList.get(1).id;
             vehiclelst.add(VR1);
             insert vehiclelst;
           
            VehicleRelationshipHelper.shareVR(vehiclelst);
            
        
         Test.stopTest();
         }
system.assertEquals(VR1.Contact__c,account1.id);
    }
                                                                                                                                                                                      
}