@isTest
public class TriggerRecallTriggerHandlerTest{
 public static Account dealer;
    Private static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     static set<Id> vehicleIDS = new set <Id> ();
    private static List<Recall__c> cpofferList = new List<Recall__c>();
    public static List<Account> accList;
    static Recall__c custom = new Recall__c(VIN__c = '12345678901011000');  
     public static Account accObj;
 @isTest static void testCampaignHelper(){
 try{
         Trigger__c TriggerLeadKR = new Trigger__c(Name='TriggerRecall',Trigger_Name__c='TriggerRecall',Trigger_Handler__c='TriggerRecallTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
         insert TriggerLeadKR;
        String topCampRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
       
         Test.startTest();
        
        Vehicle__c top = new Vehicle__c(
           Recall__c = FALSE,
           EuroVIN__c = '12345678901111111',
           UsVIN__c = '12345678902222222',
           Brand__c ='Mercedes-Benz',
           FirstRegistrationDate__c = date.today(),
           Purchase_Month__c ='02', Model__c = 'R350L 4MATIC',
           Class__c = 'A-Class',
           Purchase_Year__c = '2004',
           RegistrationNo__c = '12345',
           RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
       
        
         Recall__c recall=new Recall__c();
        recall.Vehicle_ID__c=top.id;
        recall.VIN__c='12345678902222222';
        insert recall;
        
        
        accList = new List<Account>();
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez', Dealer_Default_Flag__c = true);
        accList.add(accObj);
        insert accList;
        
        
        
       
        
        
        
        TriggerRecallTriggerHandlerJP CampaignofferHandlerJP = new TriggerRecallTriggerHandlerJP();
        CampaignofferHandlerJP.handleTrigger(false, false, false, false, false);
        CampaignofferHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
        
        
        TriggerRecallTriggerHandlerJP CampaignofferHandler = new TriggerRecallTriggerHandlerJP();
        CampaignofferHandler.handleTrigger(false, false, false, false, false);
        CampaignofferHandler.handleIntegrationTrigger(false, false, false, false, false);
        
        
        
        Recall__c recall1=new Recall__c();
        recall1.Vehicle_ID__c=top.id;
        recall1.VIN__c='12345678902222222';
        insert recall1;
        
       
        
        TriggerRecallTriggerHandler CampaignofferHandlerJP1 =new TriggerRecallTriggerHandler();
        CampaignofferHandlerJP1.handleTrigger(false, false, false, false, false);
        CampaignofferHandlerJP1.handleIntegrationTrigger(false, false, false, false, false);
        
        custom.Vehicle_ID__c = top.id;
        insert custom;
        vehicleIDS.add(top.id);
        cpofferList.add(custom);
        delete custom;
        TriggerRecallTriggerHandler CampaignofferHandlerJP2 =new TriggerRecallTriggerHandler ();
        CampaignofferHandlerJP2.handleTrigger(false, false, false, false, false);
        CampaignofferHandlerJP2.handleIntegrationTrigger(false, false, false, false, false);
        RecallHelper.beforeDeleteEvent(cpofferList);
        Test.stopTest();
       system.assertEquals([select Vehicle_ID__c,VIN__c from Recall__c where id=:custom.id].IsEmpty(),true);
 }catch(exception e){}
 }
 
}