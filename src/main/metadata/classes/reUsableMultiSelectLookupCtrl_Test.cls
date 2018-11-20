/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:03-Oct-2018
* Company:Infosys Ltd
* Description:Test class for reUsableMultiSelectLookupCtrl.
* **********************************************************************************/
@isTest
public class reUsableMultiSelectLookupCtrl_Test {
    @isTest
    public static void fetchLookUpValues_test(){
        user usr ;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //create user  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            usr = new User(
                Username = System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',
                FirstName = 'firstname',
                ProfileId = p.Id,            
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = System.now().millisecond() + 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'                
            );
            
            insert usr;
        }
        Group grp = new Group();
        grp.Name = 'Test';
        grp.Type = 'Regular';
        insert grp;
        //create Community File
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);        
        CF.SelectedGroups__c = grp.Name;
        CF.SelectedUsers__c = usr.Alias;
        insert CF; 
        List<SObject> ExcludeitemsList = new List<SObject>();
        List<SObject> usrList = new List<SObject>();
        usrList.add(usr);
        List<SObject> grpList = new List<SObject>();
        grpList.add(grp);
        reUsableMultiSelectLookupCtrl.fetchLookUpValues(CF.Id,'test','User',ExcludeitemsList);        
        reUsableMultiSelectLookupCtrl.fetchLookUpValues(CF.Id,'test','Group',ExcludeitemsList);
        reUsableMultiSelectLookupCtrl.shreRecord(CF.Id,usrList,grpList);
    }
    @isTest
    public static void getrecordDetails_Test(){
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);        
        CF.SelectedGroups__c = 'testgroup';
        CF.SelectedUsers__c = 'testuser';
        insert CF; 
        reUsableMultiSelectLookupCtrl.getrecordDetails(CF.Id);
    }
}