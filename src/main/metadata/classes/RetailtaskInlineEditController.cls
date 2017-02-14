Public class RetailtaskInlineEditController{
    public Retail_Task__c retailtask{get;set;}
    public Boolean ShowAmount{get;set;}
    public RetailtaskInlineEditController(ApexPages.StandardController sc){
        ShowAmount=false;
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id!=null){
            retailtask = [select id,Service_Labour_Amount__c,Service_Parts_Amount__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Total_Amount__c from Retail_Task__c where id=: id];
            user us=[select id,profile.name,Dealer_GC_Code__c  from user where id=: userinfo.getUserid()];
            
            If(us.Dealer_GC_Code__c ==retailtask .Related_Dealer__r.Dealer_GC_Code__c && (us.profile.name.contains('MBJ')||us.profile.name.contains('MBF') ||us.profile.name.contains('Dealer') ||(us.profile.name=='System Administrator')) )
            {
                ShowAmount=true;
            }
        }
    }
}