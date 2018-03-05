@istest
public class UtilTaskTHTest{
    public static String  OBCAllTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','OB Call');
    public static String  DMTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','DM');
    public static String  SMSTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','SMS');
    public static String  eDMTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','eDM');
    public static String  recordTypeCampaignId = RecordTypeAccessService.getRecordTypeId('Campaign','Campaign Execution');
    public static User user1 = TestUtils.createAdminUser();
    public Static  Map<String,List<String>> status=new Map<String,List<String>>();
    public static List<Task> tsk=new List<task>(); 
    public static  List<Campaign> camp=new List<campaign>();
    public static List<contact> con=new List<contact>();
    public static List<CampaignMember> campmember=new List<CampaignMember>();
    public static void testdata(String Rectype,List<String> strn){
        for(String s:strn){
            Campaign  campaignObj = new Campaign(Name='Test',RecordTypeId = recordTypeCampaignId,Repeat_From__c= system.now(),Repeat_End__c= system.now());
            Contact contactObj = new Contact(LastName= 'TestClass'+s,Federation_ID__c = '12'+s);
            camp.add(campaignObj);
            con.add(contactObj);    
        }
        insert camp;
        insert con;
        for(Integer i=0;i<con.size();i++){
            CampaignMember campaignMemObj = new CampaignMember(CampaignId = camp[i].Id,ContactId=con[i].Id,Status='sent');
            campmember.add(campaignMemObj);
        }
        insert campmember;
        status.put(Rectype,strn);
        for(String str:status.keySet()){
            integer i=0;
            for(String str1:status.get(str)){ 
                Task t=new Task(whoid=con[i].id,Activity_Status__c=str1,Whatid=camp[i].id,recordtypeid=rectype);
                i++;
                tsk.add(t);
            }
        }    
        insert tsk;
        UtilTaskTH.updateCampaignMemberStatus(tsk);  
    }
	static testMethod void OBCAllTaskRecordTypeIdTest() {
        system.runas(user1){
            Test.startTest();
             testdata(OBCAllTaskRecordTypeId,new List<String>{'not started','no answer','busy','Successful','reject'});
            Test.stopTest();
        }    
	}
 	static testMethod void DMTaskRecordTypeIdTest() {
        system.runas(user1){
            Test.startTest();
             testdata(DMTaskRecordTypeId,new List<String>{'Open','Sent','Returned'});
            Test.stopTest();
        }     
	}
    static testMethod void eDMTaskRecordTypeIdTest() {
        system.runas(user1){
            Test.startTest();
             testdata(eDMTaskRecordTypeId,new List<String>{'Open','Pending','Click','Subscribe','Unsubscribe','Hard Bounced'});
            Test.stopTest();
        }    
	}
     static testMethod void SMSTaskRecordTypeIdtest() {
        system.runas(user1){
            Test.startTest();
             testdata(SMSTaskRecordTypeId,new List<String>{'Fail-Technical','Sent','Success'});
            Test.stopTest();
        }    
	}    
}