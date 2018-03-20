Public class RetailtaskInlineEditControllerGeneric{
    public Retail_Task__c retailtask{get;set;}
    public Boolean ShowAmountMY{get;set;}
    public Boolean MBMY{get;set;}
    public Boolean MBTH{get;set;}
    public RetailtaskInlineEditControllerGeneric(ApexPages.StandardController sc){
        ShowAmountMY=false;
        MBMY=false;   
        MBTH=false;  
        Id id = ApexPages.currentPage().getParameters().get('id');
        
        if(id!=null){
            retailtask = [select id,Service_Labour_Amount__c,Related_Contact__c,Service_Parts_Amount__c,Service_Dealer__c,Service_Currency__c,Related_Dealer__r.Dealer_ND_Code__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Total_Amount__c,Description__c from Retail_Task__c where id=: id];
            user us=[select id,profile.name,Dealer_ND_Code__c,Dealer_GC_Code__c, market__c  from user where id=: userinfo.getUserid()];
            if(us.market__c==Label.TH){
                MBTH=true;
            }
            //added IF condition for MY WS users and dealers, amount values and related contact field can be viewed only by the dealer outlets belonging to a certain dealer (same dealer ND code) and all WS users
            if(us.market__c==Label.MarketMY){
                MBMY=true;
                if((Util_GetPermissionList.checkAccessOnUser(Label.MYDealer) && (us.Dealer_ND_Code__c == retailtask.Related_Dealer__r.Dealer_ND_Code__c))||Userinfo.getUserType()!='PowerPartner'||us.profile.name=='System Administrator' || us.profile.name=='IntegrationAPI'){
                    ShowAmountMY=true;
                }
            }
        }
    }
}