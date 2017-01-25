@isTest
public class CampaignOfferingHelperTest {
  public static Campaign camobj;
  public static Campaign_Offering__c camoffnew;
  public static Campaign_Offering__c camoffold;
  public static List<Campaign_Offering__c> camofflistnew;
  public static List<Campaign_Offering__c> camofflistold;
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
    
    camoffnew = new Campaign_Offering__c();
    camoffnew.Name = 'tetstcamoffer';
    camoffnew.Campaign__c = camobj.id;
    camoffnew.Description__c = 'campoffer';
    camoffnew.Start_Date__c = System.today();
    camoffnew.End_Date__c = System.today();
    //insert camoff;
    camofflistnew = new List<Campaign_Offering__c>();
    camofflistnew.add(camoffnew);
    insert camofflistnew;
    system.debug('$$$$$$$$$$$$'+camoffnew);
    system.debug('$$$$$$$$$$$$'+camoffnew.id);
    system.debug('$$$$$$$$$$$$'+camofflistnew);
    
    camoffold = new Campaign_Offering__c();
    camoffold.Name = 'tetstcamofferold';
    camoffold.Campaign__c = camobj.id;
    camoffold.Description__c = 'campofferild';
    camoffold.Start_Date__c = System.today();
    camoffold.End_Date__c = System.today();
    camofflistold = new List<Campaign_Offering__c>();
    camofflistold.add(camoffold);
    insert camofflistold;
    
    Profile prof = [select Id from Profile where Name = 'IntegrationAPI'];
    usr = new User (ProfileId = prof.Id, isActive = true, Username='lai1@nttdata.com',LastName='sichaof',Email='sichao.lai@nttdata.com',Alias='laisc',CommunityNickname='barney1',
                    TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
  }
  public static testmethod void GenerateCampaignOfferingHistoryLOGtest() {
    createTestData();
    test.starttest();
    system.runas(usr){
    CampaignOfferingHelper.GenerateCampaignOfferingHistoryLOG(camofflistnew,camofflistold,true,true,true);
    }
    test.stoptest();
    System.assertEquals(camoffold.Name,'tetstcamofferold');
  }
}