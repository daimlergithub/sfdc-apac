/**
* Utility for Trigger on Campaign for MY(Malaysia)
* Author: Sushma
* Created Date : 10th Oct 2017
*/

//SB2017
public class CampaignHelperMY {

    string market = System.Label.MarketMY; 
    string parentCampaign =System.Label.Planning_Design_Campaign;    
    
    public void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, string market, string parentCampaign){
            CampaignHelperBase.beforeUpdateEvents(campaignNew,campaignOldMap,market,parentCampaign);    
    }
    
    public void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate,string market, string parentCampaign){
        CampaignHelperBase.afterInsertUpdateEvents(campaignNew,campaignOldMap,isupdate,market,parentCampaign);
    }
    
}