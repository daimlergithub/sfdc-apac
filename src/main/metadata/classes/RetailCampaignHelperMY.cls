public class RetailCampaignHelperMY{
    
    public Static boolean booleanCampaignUpdate=true;
    
    public static String getCommunityURLforMY(){
        String communityName='Dealer Community Malaysia';
        String commubaseurl='';
        boolean flag1;
        List<Network>  myNetwork = [SELECT Id,Name FROM Network];
        for(Network net:myNetwork){
           if(net.name==communityName){
           flag1=true;
           commubaseurl=Network.getLoginUrl(net.id);
           break;
           }
       }
       return commubaseurl.replace('login','');
    }
    
    String commURLMY=getCommunityURLforMY();
    
    public void parentCampaingStatusChange(List<Retail_Campaign__c> rclist,boolean isInsertflag){
        RetailCampaignHelperBase.parentCampaingStatusChange(rclist,isInsertflag);
    }
    
    public void UpdateDealerEmail(List<Retail_Campaign__c> rclist){
        RetailCampaignHelperBase.UpdateDealerEmail(rclist,commURLMY);
    }
    
    public void deleteParentCampaignsandRelatedChildcampaigns(List<Retail_Campaign__c> rclistOld){
        RetailCampaignHelperBase.deleteParentCampaignsandRelatedChildcampaigns(rclistOld);
    }
}