/**
* Utility for Trigger on Campaign for IN(India)
* Author: Sravanthi Gudibandi
* Created Date : 5th May 2018
*/


public class CampaignHelperIN {

    string market = System.Label.MarketIN; 
    string parentCampaign =System.Label.Planning_Design_Campaign;    
    
    public void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, string market, string parentCampaign){
            CampaignHelperBase.beforeUpdateEvents(campaignNew,campaignOldMap,market,parentCampaign);    
    }
    
    public void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate,string market, string parentCampaign){
        CampaignHelperBase.afterInsertUpdateEvents(campaignNew,campaignOldMap,isupdate,market,parentCampaign);
    }
     
    public  void rollup(List<Campaign> newCMlist, List<Campaign> oldCMlist, Boolean insertflag, Boolean updateflag, Boolean deleteflag, String market){
      CampaignHelperBase.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market);
    }
    }