Public class RetailtaskInlineEditController{
public Retail_Task__c retailtask{get;set;}
public Boolean ShowAmount{get;set;}
public RetailtaskInlineEditController(ApexPages.StandardController sc){
ShowAmount=false;
Id id = ApexPages.currentPage().getParameters().get('id');
if(id!=null){
    retailtask = [select id,Service_Labour_Amount__c,Service_Parts_Amount__c,Related_Dealer__r.name,Service_Total_Amount__c from Retail_Task__c where id=: id];
    user us=[select id,Dealer_Company_Name__c,profile.name from user where id=: userinfo.getUserid()];
    
    If(us.Dealer_Company_Name__c==retailtask.Related_Dealer__r.name && (us.profile.name.contains('MBJ')||us.profile.name.contains('MBF') ||us.profile.name.contains('Dealer') ||(us.profile.name=='System Administrator')) )
    {
        ShowAmount=true;
    }
}
}
}