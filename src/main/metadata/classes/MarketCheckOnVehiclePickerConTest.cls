@isTest (seeAllData = false)
public class MarketCheckOnVehiclePickerConTest{
    private static user usr;
    private static Profile profile;
    private static UserRole role;
    private static String testString='test';
    private static String languageString='en_US';
    private static Lead__c testlead;
    public static testMethod void insertNewUser() {
        
        profile = [select id, name from profile where name = 'Korea Call Center'];
        role = [SELECT Id,Name FROM UserRole where name = 'Call Center Operator'];
        // tried the below code to use the util to input the data, but this method is marked private
        // usr = UtilTestData.createUser(role.id, profile.id);
        // for the above reason went with the custom insert of user in the same test class
        usr = new User();
        usr.UserName = testString + Math.rint(Math.random() * 100000) + '@daimler.com';
        usr.UserRoleId = role.id;
        usr.ProfileId = profile.id;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = testString;
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = languageString;
        usr.localesidkey=languageString;
        usr.isActive = true;
        insert usr;
    }
    
    public static testMethod void MarketCheckOnVehicleTest(){
    testlead = new Lead__c();
    ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
    MarketCheckOnVehiclePickerCon mvp = new MarketCheckOnVehiclePickerCon(sc);
    //Dhanamjaya code
    mvp.marketChecker2=true;
    mvp.marketChecker=false;

    profile = [select id, name from profile where name = 'Thailand Call Center'];
       
        // tried the below code to use the util to input the data, but this method is marked private
        // usr = UtilTestData.createUser(role.id, profile.id);
        // for the above reason went with the custom insert of user in the same test class
        usr = new User();
        usr.UserName = testString + Math.rint(Math.random() * 100000) + '@daimler.com';
       
        usr.ProfileId = profile.id;
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = testString;
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = languageString;
        usr.localesidkey=languageString;
        usr.isActive = true;
        insert usr;
    usr.Market__c='JP';
    update usr;
    System.RunAs(usr){
      ApexPages.StandardController sc1 = new ApexPages.StandardController(testLead);
      MarketCheckOnVehiclePickerCon mvp1 = new MarketCheckOnVehiclePickerCon(sc);
      system.assertEquals(usr.Market__c,System.label.marketJP);
    }
    usr.Market__c='KR';
    update usr;
    System.RunAs(usr){
      ApexPages.StandardController sc2 = new ApexPages.StandardController(testLead);
      MarketCheckOnVehiclePickerCon mvp2 = new MarketCheckOnVehiclePickerCon(sc);
      system.assertEquals(usr.Market__c,System.label.marketKR);
        }     
        usr.Market__c='TH';
    update usr;
    System.RunAs(usr){
      ApexPages.StandardController sc2 = new ApexPages.StandardController(testLead);
      MarketCheckOnVehiclePickerCon mvp2 = new MarketCheckOnVehiclePickerCon(sc);
      system.assertEquals(usr.Market__c,System.label.marketKR);
        } 
  }
}