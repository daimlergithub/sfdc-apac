Public class RetailtaskInlineEditController{
    public Retail_Task__c retailtask{get;set;}
    public Boolean ShowAmount{get;set;}
	public Boolean ShowAmountMY{get;set;}
	public Boolean MBMY{get;set;}
    public RetailtaskInlineEditController(ApexPages.StandardController sc){
        ShowAmount=false;
        Boolean MBFMBJ = false;
		ShowAmountMY=false;
        MBMY=false;		
        Id id = ApexPages.currentPage().getParameters().get('id');
        
        if(id!=null){
            retailtask = [select id,Service_Labour_Amount__c,Service_Parts_Amount__c,Related_Dealer__r.Dealer_GC_Code__c,Service_Total_Amount__c,Description__c from Retail_Task__c where id=: id];
            system.debug('Taskkkkkk'+retailtask);
            user us=[select id,profile.name,Dealer_GC_Code__c, market__c  from user where id=: userinfo.getUserid()];
            if(us.profile.name == 'Japan CRM' || us.profile.name == 'Japan Call Center' ||  us.profile.name == 'Japan Sales/After-Sales' ||  us.profile.name == 'Japan After-Sales Engineer'||us.profile.name == 'Japan Marketing' ||us.profile.name == 'Japan Area Manager'||us.profile.name == 'Japan IT Department' ||us.profile.name == 'Japan Data Management'||us.profile.name == 'Japan Catalogue Sending Vendor'||us.profile.name == 'Japan Finance')
            {
                system.debug('I am here');
                MBFMBJ = TRUE;
            }
            system.debug('>>> :'+us.Dealer_GC_Code__c);
            system.debug('>>> :'+retailtask.Related_Dealer__r.Dealer_GC_Code__c);
            //added IF condition for MY dealers, amount values and related contact field can be viewed only by the dealer outlets belonging to a certain dealer (same dealer ND code)
            if(us.market__c==Label.MarketMY){
                MBMY=true;
                if((Util_GetPermissionList.checkAccessOnUser(Label.MYDealer) && (us.Dealer_ND_Code__c == retailtask.Related_Dealer__r.Dealer_ND_Code__c))||us.profile.name=='System Administrator' || us.profile.name=='IntegrationAPI'){
                    ShowAmountMY=true;
                }
            }
            else
            If(((us.Dealer_GC_Code__c == retailtask.Related_Dealer__r.Dealer_GC_Code__c ) || us.profile.name=='System Administrator' || us.profile.name=='IntegrationAPI' || us.profile.name == 'MBK Support Profile' || us.profile.name == 'Korea After-Sales Engineer' || us.profile.name == 'Korea Call Center' || us.profile.name == 'Korea CRM' || us.profile.name == 'Korea Data Management' || us.profile.name == 'Korea IT Department' || us.profile.name == 'Korea Marketing' || us.profile.name == 'Korea Sales/After-Sales'|| MBFMBJ == TRUE) && (us.market__c!=Label.MarketMY))
            {
                system.debug('I am here too');
                ShowAmount=true;
            }
        }
    }
}