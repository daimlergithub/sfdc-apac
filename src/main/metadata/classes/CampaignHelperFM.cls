/**
* Handler for Trigger on Campaign for Factory Model
* Author: Ankit Kapoor
* Created Date : 2018-09-09
*/
public class CampaignHelperFM {


    //string market = System.Label.MarketMY;  //AnkitK commented as market is being passed from HandlerFM
  //string parentCampaign =System.Label.Planning_Design_Campaign;    
    
    public void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, string market, string parentCampaign){
            CampaignHelperBase.beforeUpdateEvents(campaignNew,campaignOldMap,market,parentCampaign);    
    }
    
    public void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate,string market, string parentCampaign){
        CampaignHelperBase.afterInsertUpdateEvents(campaignNew,campaignOldMap,isupdate,market,parentCampaign);
    }
    // RSVP for Campaign Members- Asish Kumar Nanda
    
    public  void rollup(List<Campaign> newCMlist, List<Campaign> oldCMlist, Boolean insertflag, Boolean updateflag, Boolean deleteflag, String market){
      CampaignHelperBase.rollup(Trigger.new,Trigger.old,insertflag,updateflag,deleteflag,market);
    }
    

    
}