@isTest
public class ParticipatingDealerHelperTest
{	
    public static Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
    public static user testUser;
    
    static testmethod void testGenerateCampaignParticipatingDealerHistoryLOG(){
         Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.name='Community Enabled';
        cls.Enable__c=true;
        insert cls;
        
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
    	{
	     
	        Test.startTest();
	        //Create a Community User:
	        User usr = [Select id from User where Id = :UserInfo.getUserId()];
	        System.RunAs(usr){
	        testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
	        update testUser;
            system.debug('@@@###$%%'+testUser);
            }
       
       
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Published',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=centCampaignRT);  
        insert TestData_CCA;
        
         usr = [Select id from User where Id = :UserInfo.getUserId()];
	        System.RunAs(usr){
	        testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
	        update testUser;
            }
 
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
        Account dealer = new Account(Name='TEST Dealer999', ZipCode__c='123456', Phone='123456789', RecordTypeId=accDealerRT,OwnerId = testUser.Id);
        insert dealer;
      
       Campaign_Package__c campckg = new Campaign_Package__c(Campaign__c =TestData_CCA.Id, Name = 'Test package');
       insert campckg;
       Participating_Dealer__c opd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id, 
                                                                 Dealer__c=dealer.Id , Campaign_Package__c = campckg.Id ,Session_Start_Date__c = date.newinstance(2013, 7, 13));
       
        insert opd;
        opd.Session_Start_Date__c = date.newinstance(2013, 7, 14);        
        update opd; 
        delete opd;
        
        Test.stopTest();     
        System.assertEquals(TestData_CCA.Id,opd.Campaign__c);
        System.assertEquals(accDealerRT,dealer.RecordTypeId);  
    
}
}
}