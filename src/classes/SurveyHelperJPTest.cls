@isTest
public class SurveyHelperJPTest{
    public static Survey__c testSurvey;
    public static Survey__c testSurvey1;
    public static List<Survey__c> SurveyList;
    public static Map<Id,Survey__c> surveyMap;
    public static SurveyTaker__c svrTkrtest;
    public static Account dlrAcc;
    public static Contact dlrContact;
    public static User usr;
    public static Group accGrp;
    public static Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('DealerStaff').getRecordTypeId();
    public static Id dlrAccRecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
public static testmethod  void handleInsertOrUpdateEventtest(){
     
    createTestData();
     test.startTest();
        SurveyHelperJP.handleInsertOrUpdateEvent(SurveyList,surveyMap);
     test.stopTest();
    
     }
    static void createTestData(){
     // Survey__c record
     SurveyList = new List<Survey__c>();
    testSurvey =new Survey__c(Name='Survey1');
    insert testSurvey;
    testSurvey1 =new Survey__c(Name='Survey2');
    insert testSurvey1;
    
    SurveyList.add(testSurvey);
    SurveyList.add(testSurvey1);
    
    testSurvey.Submit_Response__c ='Response to Survey';
    update testSurvey;
    testSurvey1.Submit_Response__c = 'Response to Survey1';
    update testSurvey1;
    
    surveyMap = new Map<Id,Survey__c>();
     surveyMap.put(testSurvey.Id,testSurvey);
     surveyMap.put(testSurvey1.Id,testSurvey1);
        
    // Dealer Account 
        dlrAcc = (Account)UtilTestData.createSobject(new Account(mobile__c='09865324152'), UTilTestData.ACCOUNT_RT_DEALER);  
    // Create Contact
        dlrContact =new Contact(AccountId=dlrAcc.Id,LastName ='Contact1',Federation_ID__c='12546',Email='contact@dealer.com',Phone='(856)421-3702');
        insert dlrContact;
        
     // Japan Dealer Company Manager Profile
          Profile profile= [select Id from Profile where name='Japan Dealer Company Manager'];
     // UserRole
     // UserRole ur = new UserRole(name = dlrAcc.name + ' ' + 'Partner Executive');
      //  insert ur;   
    // Create User 
           usr = new User(alias = 'standt',email = 'test@9876test.com',emailencodingkey = 'UTF-8'
                         , lastname = 'TestLasName', languagelocalekey = 'en_US',ContactID= dlrContact.Id,
                                      localesidkey = 'en_US', profileid =profile.Id,
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com'); 
        insert usr;  
    // Survey Taker Record
       svrTkrtest = new SurveyTaker__c(Survey__c=testSurvey.Id,Account__c=dlrAcc.Id); 
        insert svrTkrtest;
        accGrp = new Group(Name='test dealer');
        insert accGrp;
    }
}