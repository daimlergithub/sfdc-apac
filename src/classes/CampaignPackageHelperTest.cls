@istest
public class CampaignPackageHelperTest {
  public static Campaign camobj;
  public static Campaign_Package__c campacknew;
  public static Campaign_Package__c campackold;
  public static List<Campaign_Package__c> campacklistnew;
  public static List<Campaign_Package__c> campacklistold;
  public static User usr;
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
  
  static void createTestData() {
    camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today();
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    insert camobj;
    system.debug('$$$$$$$$$$$$'+camobj);
    system.debug('$$$$$$$$$$$$'+camobj.id);
    
    campacknew = new Campaign_Package__c();
    campacknew.Name = 'tetstcampackernew';
    campacknew.Campaign__c = camobj.id;
    campacknew.Package_Description__c = 'camppacknew';
    //insert campacknew;
    campacklistnew = new List<Campaign_Package__c>();
    campacklistnew.add(campacknew);
    insert campacklistnew;
    system.debug('$$$$$$$$$$$$'+campacknew);
    system.debug('$$$$$$$$$$$$'+campacknew.id);
    system.debug('$$$$$$$$$$$$'+campacklistnew);
    
    campackold = new Campaign_Package__c();
    campackold.Name = 'tetstcampackerold';
    campackold.Campaign__c = camobj.id;
    campackold.Package_Description__c = 'camppackold';
    //campackold.Package_Items__c = ;
    campacklistold = new List<Campaign_Package__c>();
    campacklistold.add(campackold);
    insert campacklistold;
    system.debug('$$$$$$$$$$$$'+campackold);
    system.debug('$$$$$$$$$$$$'+campackold.id);
    system.debug('$$$$$$$$$$$$'+campacklistold);
    
    Profile prof = [select Id from Profile where Name = 'System Administrator'];
    usr = new User (ProfileId = prof.Id, isActive = true, Username='lai143@nttdata.com',LastName='sichaof',Email='sichao.lai43@nttdata.com',Alias='laisc',CommunityNickname='barney1',
                    TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
    insert usr;   
    system.debug('$%$%$%$%$%$%$%$%$'+usr);             
  }
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest() {
    createTestData();
    test.starttest();
    system.runas(usr){    
    try{
    CampaignPackageHelper.GenerateCampaignOfferingHistoryLOG(campacklistnew,campacklistold,true,true,false);
    }catch(exception e){}
    }
    test.stoptest();
 
    
  }
}