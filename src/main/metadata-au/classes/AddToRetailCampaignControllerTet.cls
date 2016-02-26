@isTest
public class AddToRetailCampaignControllerTet
{
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    final static String INQUIRYRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Enquiry').getRecordTypeId();
    static Account acc = new Account(LastName='acme', Phone='11111222', Area_Code__c = '010' ,RecordTypeId = personRecordtypeid,firstname='test acme',Salutation='Brother');
    final static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    final static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();
    static Vehicle__c ve1 = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200', EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'));
    static Vehicle__c ve2 = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B220', EuroVIN__c='11111222222111122', UsVIN__c='11111222222111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'));
    static{
 		upsert new Trigger__c(Name = 'TriggerRetailCampaignMember', Trigger_Name__c = 'TriggerRetailCampaignMember', Trigger_Handler__c = 'TriggerRetailCampaignMemberHandler', 
		enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='AU');       
    }
    static testMethod void RetailCampaignTest()
    {
        Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.name='Community Enabled';
        cls.Enable__c=true;
        insert cls;
    	system.debug('test>>>$$$$test'+UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH));
    	//Added community license switching mechanism
    	if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
    	{
	        Test.startTest();
	        List<Sobject> sos = new List<Sobject>();        
	        insert acc;
	        insert ve1;
	        insert ve2;        
	        Vehicle_Relationship__c vrData1 = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, 
	                                              Contact__c = acc.Id,Registration_Number__c ='1');
	        Vehicle_Relationship__c vrData2 = new Vehicle_Relationship__c(Vehicle_ID__c=ve2.id, 
	                                              Contact__c = acc.Id,Registration_Number__c ='1');
	        insert vrData1;
	        insert vrData2;
	        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
	        insert dealer;   
	        Retail_Campaign__c rc = new Retail_Campaign__c(RecordTypeId = RTId, Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved',Total_CAC_Source_Campaign_Member__c=1);     
	        insert rc;        
	        User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
	        system.debug('!!!!! user1 Records'+user1);
	        User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
	        //User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and isActive = true limit 1];
	
	        Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
	                          Case_SubType__c='Dealer-after sales service attitude', Case_Dealer__c = portalUser1.AccountId,Retail_Campaign__c=rc.Id,Case_Status__c = 'Accepted');
	        sos.add(c1);
	        if(sos!=null && !sos.IsEmpty())
	        UtilSobject.insertSobjects(sos);  
	        PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=' + c1.Id);
	        Test.setCurrentPage(pr);
	        AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
	        addRetail.addTo();
	        PageReference pr1  = new PageReference('/apex/AddToRetailCampaign?id='+null);
	        Test.setCurrentPage(pr1);
	        AddToRetailCampaignController addRetail1 = new AddToRetailCampaignController();  
	        rc=[select Id, Total_CAC_Source_Campaign_Member__c from Retail_Campaign__c where Id = :c1.Retail_Campaign__c];    
	        c1 = [select Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,Retail_Campaign__c,VIN_Code__c from case where id=:c1.id];
	        c1.Vehicle_Relationship__c = vrData2.id;
	        update c1;
	        List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];        
	        Test.stopTest();
	        /*system.assertEquals(c1.Vehicle_Brand__c,'BENZ');
	        system.assertEquals(c1.Vehicle_Class__c,'class-B');
	        system.assertEquals(c1.Vehicle_Model__c,'B200');
	        system.assertEquals(c1.VIN_Code__c,ve1.UsVIN__c); 
	        system.assert(ctcs.size()>0);
	        system.assertEquals(c1.Vehicle_Relationship__c,vrData2.id); 
	        system.assertEquals(rc.id,c1.Retail_Campaign__c);*/
    	}
    	//Added community license switching mechanism
    	else
    	{
    		Test.startTest();
    		PageReference pr  = new PageReference('/apex/AddToRetailCampaign?id=');
	        Test.setCurrentPage(pr);
	        AddToRetailCampaignController addRetail = new AddToRetailCampaignController();
	        addRetail.addTo();
    		Test.stopTest();
    	} 
    }
}