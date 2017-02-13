@istest
public class TriggerAccountLinkTriggerHandlerJPTest{

 public static void TestData(){
 //Trigger__c TriggerAccountJP = new Trigger__c(Name='TriggerAccountJP',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  //insert TriggerAccountJP;
  TriggerAccountLinkTriggerHandlerJP atp= new TriggerAccountLinkTriggerHandlerJP();

atp.handleTrigger(True,True,True,True,True);
atp.handleIntegrationTrigger(True,True,True,True,True);
}
}