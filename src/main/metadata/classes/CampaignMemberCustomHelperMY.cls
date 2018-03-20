/**************************************************************************************************************************************************
* Class:                            CampaignMemberCustomHelperMY
* Description:                      This class will handles the Custom Campaign Member functionalities
@ CampaignmemberssharewithsubDealers() this method will Share the records to the set of users Under a particular Dealer
* --------------------------------------------------------------------------------------------------------------------------------------------------
* Date                              Name                        Modification Description
* Created Date : 2017-10-10     Dhanamjaya D                    Created  

=====================================================================================================================================================*/
public class CampaignMemberCustomHelperMY{
CampaignMemberCustomHelperBase helper=new CampaignMemberCustomHelperBase();
public void campaignMemberHelperBeforeInsert(List<Campaign_member__c> Camlist){ 
        helper.campaignMemberHelperBeforeInsert(Camlist,Label.MarketMY);   
    }
public void CampaignmemberssharewithsubDealers(List<Campaign_member__c> Camplist){
	helper.CampaignmemberssharewithsubDealers(Camplist,Label.MarketMY);
	}
 
public void beforeDeleteOperation(List<Campaign_member__c> Camplist){
	helper.beforeDeleteOperation(Camplist);
	} 
}