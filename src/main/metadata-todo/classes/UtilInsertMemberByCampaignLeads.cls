/*
    Type:       Apex Class
    Purpose:    Define methods used in trigger.DearlerOffering
    User Story: US-Cpn-018, US-Cpn-019, US-Cpn-020, US-Cpn-021
    Used By:    TriggerCampaign.trigger
    ---------------------------------------------------------------
    History:
    
    25-Mar-2013 Jorry Chen (Breakingpoint)    Created
    16-Sept-2013 Chris Huang (Breakingpoint)    Update  Changed insert Campaign Member to Any
*/

public class UtilInsertMemberByCampaignLeads {
	public void insertMembers(List<Campaign_Lead__c> clList) {
		List<CampaignMember> cpmList = new List<CampaignMember>();
		Set<ID> idSet = new Set<ID>();
		for(Campaign_Lead__c cl : clList) {
            if (cl.Contact__c != null) {
                idSet.add(cl.Contact__c);
            }			
		}
		
		List<Contact> contactList = [select id, Name, AccountId from Contact where AccountId in :idSet];
		
		for(Contact c : contactList) {
			for(Campaign_Lead__c cl : clList) {
				if(cl.Contact__c == c.AccountId) cpmList.add(new CampaignMember(CampaignId = cl.Campaign__c, ContactId = c.Id, Status = 'Sent'));
			}
		}
		
		Savepoint sp = Database.setSavepoint();
		try {
			//if(cpmList.size() > 0) insert cpmList;
            if(cpmList.size() > 0) Database.Insert(cpmList, false);
		} catch (exception ex) {
			Database.rollback(sp);
            System.debug('create task failed : ' + ex);   
		}
	}
}