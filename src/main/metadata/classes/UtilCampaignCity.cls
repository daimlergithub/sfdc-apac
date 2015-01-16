/*
    Type:       Apex Class
    Purpose:    Define methods used in triggerCampaignCity
    User Story: US-Cpn-002, US-Cpn-004
    Used By:    TriggerCampaignCity.trigger
    ---------------------------------------------------------------
    History:
    
	08-Mar-2013 Jorry Chen (Breakingpoint)    Created
*/

public class UtilCampaignCity {
	public static void deleteParticipatingDealer(List<Campaign_City__c> cpCityList){
		Savepoint sp = Database.setSavepoint();
		try{
			List<ID> cityIdList = new List<ID>();
			
			System.debug('@!!!!! begin');
			
			List<Participating_Dealer__c> pDealerList = [select id from Participating_Dealer__c
															where Campaign__c = :cpCityList[0].Campaign__c];
															
			if(pDealerList.size() > 0) {
				delete pDealerList;
			}
		} catch(exception ex) {
			Database.rollback(sp);
            System.debug('deleteCampaigndealer failed : ' + ex);
		}
	}	
}