@isTest
public class CaseCommentHelperTHTest {
	 public static User user1= TestUtils.createAdminUser();
     public static Casecomment c;
    Private static void createtestData(){
        Trigger__C casetrigger=new Trigger__C(name='CaseCommentTrigger',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseCommentTriggerHandlerTH',Trigger_Name__c='CaseCommentTrigger',update__c=true);
    	insert casetrigger;
        case cs=new Case(COS_Ticket_Number__c='123');
        insert cs;
        c=new CaseComment(commentbody='dhanam',parentid=cs.id);
        insert c;
	}
    @isTest
    private static void SendCaseCommentsToCOSTest(){
        system.runas(user1){
            Test.startTest();
            createtestData();
            new CaseCommentTriggerHandlerTH().handleIntegrationTrigger(false,false,false,false,false);
            Test.stopTest();   
        }
    }
}