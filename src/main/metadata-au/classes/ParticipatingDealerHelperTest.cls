@isTest
public class ParticipatingDealerHelperTest
{	
    public static Id centCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
    public static user usr;
    public static Profile userprofile = [select Id from Profile where Name = 'Dealer Delegate Admin' limit 1];
    
    static testmethod void testGenerateCampaignParticipatingDealerHistoryLOG(){
         Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.name='Community Enabled';
        cls.Enable__c=true;
        insert cls;
        
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
    	{
	     
	        Test.startTest();
	        //Create a Community User:
	      /*  User usr = [Select id from User where Id = :UserInfo.getUserId()];
	        System.RunAs(usr){
	        testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
	        update testUser;
            system.debug('@@@###$%%'+testUser);
            }*/
       
       
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
        
       /*  usr = [Select id from User where Id = :UserInfo.getUserId()];
	        System.RunAs(usr){
	        testUser = (User)UtilTestData.createPortalUser('Dealer User', 'Dealer Delegate Admin');
	        update testUser;
            }*/
 
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
        Account dealer = new Account(Name='TEST Dealer999', ZipCode__c='123456', Phone='123456789', RecordTypeId=accDealerRT);
        insert dealer;
        Contact contact = new Contact(
            AccountId = dealer.Id, 
            Salutation='Attorney',
             FirstName='testFirstname',
            LastName = 'testLastname',  
            Phone = '1212313', 
            Permission_Set_Settings__c = 'AS_Retail_Campaign',
            email = 's@s.s'
        );
        insert contact;
        
        
        User testuser = new User();
         usr = [Select id from User where Id = :UserInfo.getUserId()];
	        System.RunAs(usr){
	      		testuser.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';            
                testuser.ProfileId= userprofile.Id ;
                //usr.UserRoleId=userRoleId;
                testuser.LastName = 'Test User';
                testuser.Email = 'test001@daimler.com.full';
                testuser.Alias = 'test';
                testuser.TimeZoneSidKey = 'Asia/Shanghai';
                testuser.EmailEncodingKey = 'UTF-8';
                testuser.LanguageLocaleKey = 'en_US';
                testuser.localesidkey='en_US';
                testuser.isActive = true;
                testuser.ContactId =contact.Id;
                insert testuser; 
            } 
      
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