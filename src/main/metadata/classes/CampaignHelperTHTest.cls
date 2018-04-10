@isTest public with sharing class CampaignHelperTHTest 
{
    public static string topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
    public static String mbBestPracticeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
    public static String complex = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static String simple = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Simple').getRecordTypeId();
    public static String cacCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static String tesCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static String pndcampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static User user1= TestUtils.createAdminUser();
    public static string top = 'top';
    public static string Started = 'Started';
    public static string OB_Call = 'OB Call';
    public static string Published = 'Published';
    public static Set < String > topCampaignIds;
    public static List < Campaign > listcampaigns = new List<Campaign>();

  public static void creatTestData(){
        List<Sobject> sobj=new List<sObject>();
        List < Campaign > campaignList = new List < Campaign > ();
        Map < Id, Campaign > campaignMap = new Map < Id, Campaign > ();

        Trigger__c tr= new Trigger__C(name = 'TriggerCampaignTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerCampaignTriggerHandlerTH', Trigger_Name__c = 'TriggerCampaign', update__c = true);
        sobj.add(tr);
        insert sobj;
        
        Contact contact = new Contact(
            LastName = 'test Contact'
        );
        insert contact;
        Campaign top1 = new Campaign(
            Name = top,
            Status = Started,
            StartDate = System.today(),
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        insert top1;

        Campaign cac = new Campaign(
            Name = 'Test Campaign',
            Status = Started,
            IsActive = true,
            StartDate = System.today(),
            EndDate = System.today(),
            Task_Created_By__c = 'Lead',
            Execution_Type__c = OB_Call,
            Create_Task__c = false,
            RecordTypeId = tesCampaign,
            ParentId = top1.Id
        );
        //listcampaigns.add(cac);
        insert cac;
        Campaign c = [Select Id from Campaign Where Id =: cac.Id];
        CampaignMember cms = new CampaignMember(
            CampaignId = cac.Id,
            ContactId = contact.Id

        );
        insert cms;
        Campaign testCampaign1 = new Campaign(
            
            Name = 'Test Campaign2',
            Task_Created_By__c = 'Lead',
            Create_Task__c = false,
            StartDate = System.today(),
            EndDate = System.today(),

            RecordTypeId = pndcampaign
        );
        insert testCampaign1;
        campaignList.add(testCampaign1);
        Campaign testCampaign2 = new Campaign(
            IsActive = false,
            Name = 'Test Campaign3',
            Task_Created_By__c = 'Lead',
            Create_Task__c = false,
            StartDate = System.today(),
            EndDate = System.today(),
            ParentId = testCampaign1.Id,
            RecordTypeId = tesCampaign
        );
        insert testCampaign2;
        
        testCampaign1.isActive=true;
        testCampaign1.Activate_for_retail_campaign__c = true;
        update testCampaign1;
        
        Campaign cpn = [Select Id, Create_Task__c, Task_Created_By__c from Campaign Where Name = 'Test Campaign'];
        cpn.Create_Task__c = true;
        cpn.Task_Created_By__c = 'Lead';
        update cpn;
        cpn.Task_Created_By__c = 'Vehicle';
        cpn.Create_Task__c = false;
        update cpn;
        cpn.Task_Created_By__c = 'Vehicle';
        cpn.Create_Task__c = true;
        update cpn;
        cpn.Task_Created_By__c = 'Case';
        cpn.Create_Task__c = false;
        update cpn;
        cpn.Task_Created_By__c = 'Case';
        cpn.Create_Task__c = true;
        update cpn;
        
  }
  
  public static testMethod void VehicleRelationshipHelperTHTestMethod(){
        System.runAs (user1) {
            test.startTest();
            creatTestData();
            test.stopTest();
        }
  }
}