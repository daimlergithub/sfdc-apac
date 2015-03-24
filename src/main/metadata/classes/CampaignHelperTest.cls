/*
    Type:       Test Class
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
@isTest public class CampaignHelperTest {

	@isTest static void testCampaignHelper(){
		String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
		String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
		String obCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Simple').getRecordTypeId();
		String centralCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
		
		Test.startTest();
		
		Campaign top = new Campaign(
			IsActive = true, 
			Name = 'top', 
			Status = 'Started', 
			StartDate = System.today(), 
			EndDate = System.today(),
			RecordTypeId = topCampRecordTypeId
		);
		
		insert top;
		
		Campaign cac = new Campaign(
			Name = 'cac', 
			Status = 'Started', 
			StartDate = System.today(), 
			EndDate = System.today(),
			RecordTypeId = cacCampRecordTypeId,
			ParentId = top.Id
		);
		insert cac;
		
		CampaignMemberStatus status = new CampaignMemberStatus(
			CampaignId = top.Id,
			Label = 'Present',
			SortOrder = 3
		);
		insert status;
		
		Campaign ob1 = top.clone();
		ob1.Name = 'ob1';
		ob1.RecordTypeId = obCampRecordTypeId;
		ob1.ParentId = cac.Id;
		ob1.Execution_Type__c = 'OB Call';
		insert ob1;
		
		Campaign ob2 = ob1.clone();
		ob2.Name = 'ob2';
		insert ob2;
		
		Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
        	AccountId = dealer.Id, 
        	LastName = 'b', 
        	Phone = '1212313', 
        	email = 's@s.s'
        );
        insert contact;
        
		CampaignMember topMember = new CampaignMember(
			CampaignId = top.Id,
			ContactId = contact.Id,
			Status = 'Send'
		);
		CampaignMember ob1Member = new CampaignMember(
			CampaignId = ob1.Id,
			ContactId = contact.Id,
			Status = 'Send'
		);
		CampaignMember ob2Member = new CampaignMember(
			CampaignId = ob2.Id,
			ContactId = contact.Id,
			Status = 'Send'
		);
		insert new CampaignMember[]{topMember, ob1Member, ob2Member};
		
		ob1Member.Status = 'Responsed';
		update ob1Member;
		
		Campaign objcampaign = new Campaign(
			IsActive = true, 
			Name = 'top', 
			Status = 'Started', 
			StartDate = System.today(), 
			EndDate = System.today(),
			RecordTypeId = centralCampaignId
		);
		
		insert objcampaign;
		
		objcampaign.Status='Published';
		update objcampaign;
		Test.stopTest();
		System.assertEquals(ob1Member.status, 'Responsed');
		System.assertEquals(top.RecordTypeId, topCampRecordTypeId);
		System.assertEquals(objcampaign.Status, 'Published');
		System.assertEquals(topMember.CampaignId, top.Id);
		System.assertEquals(ob1Member.ContactId, contact.Id);
		System.assertEquals(ob2Member.CampaignId, ob2.Id);
	}
}