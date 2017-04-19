Public class RetailtaskInlineEditController{
    public Retail_Task__c retailtask{get;set;}
    public Boolean ShowAmount{get;set;}
    public RetailtaskInlineEditController(ApexPages.StandardController sc){
        ShowAmount=false;
        Boolean MBFMBJ = false;
        Id id = ApexPages.currentPage().getParameters().get('id');
        
        if(id!=null){
            retailtask = [select id,Service_Labour_Amount__c,Service_Parts_Amount__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Total_Amount__c,Description__c from Retail_Task__c where id=: id];
            system.debug('Taskkkkkk'+retailtask);
            user us=[select id,profile.name,Dealer_GC_Code__c  from user where id=: userinfo.getUserid()];
            if(us.profile.name == 'Japan CRM' || us.profile.name == 'Japan Call Center' ||  us.profile.name == 'Japan Sales/After-Sales' ||  us.profile.name == 'Japan After-Sales Engineer'||us.profile.name == 'Japan Marketing' ||us.profile.name == 'Japan Area Manager'||us.profile.name == 'Japan IT Department' ||us.profile.name == 'Japan Data Management'||us.profile.name == 'Japan Catalogue Sending Vendor'||us.profile.name == 'Japan Finance')
            {
                system.debug('I am here');
                MBFMBJ = TRUE;
            }
            If((us.Dealer_GC_Code__c == retailtask.Related_Dealer__r.Dealer_GC_Code__c && us.profile.name.contains('Dealer')) || us.profile.name=='System Administrator' || us.profile.name=='IntegrationAPI' || MBFMBJ == TRUE )
            {
                system.debug('I am here too');
                ShowAmount=true;
            }
        }
    }
}