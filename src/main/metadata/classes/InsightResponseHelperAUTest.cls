@isTest
public class InsightResponseHelperAUTest {
 
    private static user us1;
    public static testMethod void invokemethIR1()
    {
         Profile p = [SELECT Id,Name FROM Profile WHERE Name='IntegrationAPI'];
        us1 = new User(Alias = 'standt11', Email='testUser1@testorg.com', 
                   EmailEncodingKey='UTF-8', LastName='TestUserAU', LanguageLocaleKey='en_US', 
                   LocaleSidKey='en_US', ProfileId = p.Id, Market__c='AU',
                   TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(us1);
        system.runAs(us1 )
        {
   					List<Insights_Response__c>  refIR=new List<Insights_Response__c>();
            		Insights_Response__c r=new Insights_Response__c();
            		r.Name='Ashok response1';
            		r.Market__c='AU';
            		refIR.add(r) ;
      					
            	InsightResponseHelperAU.UpdateRelation(refIR);
         		InsightResponseHelperAU.afterInsertEventShareInsightResponse(refIR);
            	
        }
            
    }
}