@isTest
public class DMMaterialHelperTRTest {
    
    
    private static DM_Material__c Material;
 
    private static User usr;
 
    public static void createTestData(){
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh);

     
        Profile taskprofile = [select id, Name from profile where Name='System Administrator' limit 1];
        User user = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest@infosys.com',UserName='sa2222222m@test.com.dev01'+String.valueof(DateTime.now().getTime()),Market__c = 'TR');
        insert user;
        System.runas(user){       
            Profile profileCAC = [select Id from Profile where Name = :Label.IntProfileName];
            usr = new User();
            usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com'+String.valueof(DateTime.now().getTime());        
            if(profileCAC!=Null){
            usr.ProfileId = profileCAC.Id;}
            usr.LastName = 'Test User';
            usr.Email = 'test001@daimler.com.full';
            usr.Alias = 'Atest';
            usr.TimeZoneSidKey = 'Asia/Shanghai';
            usr.EmailEncodingKey = 'UTF-8';
            usr.LanguageLocaleKey = 'en_US';
            usr.localesidkey='en_US';
            usr.isActive = true;
            usr.Market__C='TR';    
      insert usr;

            SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
            sysSet.Debug__c =true;
            sysSet.Error__c = true;
            sysSet.Info__c= true;
            sysSet.Warning__c = true;
            sysSet.Log_Purge__c =10;
            sysSet.Name=taskprofile.Name;
            DMLManagerService.insertAsSystem(sysSet);
        
        } 
    }
    public static void createDMRequest(){
        Trigger__c TriggerDMR=new Trigger__c(Name='DMMaterialTR',Trigger_Name__c='TriggerDMMaterial',Trigger_Handler__c='TriggerDMMaterialTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        upsert TriggerDMR;
           
        system.runAs(usr){
            Material = new DM_Material__c();
            Material.Name='testname';
            Material.Market__c='TR';
            insert Material;

          
        }
    } 
    
}