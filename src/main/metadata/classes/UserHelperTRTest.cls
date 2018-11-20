@isTest
public class UserHelperTRTest {
    
    Private static Profile adminProfileObj;
    Private static User adminUserObj;
    
    public static void createtestdata(){
        Trigger__c TriggerUser=new Trigger__c(Name='UserTriggerTR',Trigger_Name__c='UserTrigger',Trigger_Handler__c='UserTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        insert TriggerUser;
        adminProfileObj = [select id from profile where Name='System Administrator' limit 1];
        adminUserObj = new User(LastName='adminUser',country='Turkey',firstName='BCI',ProfileId=adminProfileObj.Id,Alias='aiwen123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser0563@testing.com',UserName='admusr343@daimler.com'+String.valueof(DateTime.now().getTime()),Market__c = 'TR',isActive=true);
        insert adminUserObj;    
    }
    public static testmethod  void  ShareUsersToDealersAfterInsertAndUpdateTest(){
        test.startTest();
        createtestdata();
        
        test.stopTest();
    } 
    

}