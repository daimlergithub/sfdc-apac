public class SurveyTakerHelperKR 
{
	Public static Id retailCompanyRectypeId = Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Company').getRecordTypeId();
    Public static Id retailPersonRectypeId = Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Person').getRecordTypeId();
    
    public static void shareSurverTakertoDealer(List<SurveyTaker__c> surveyTkrList)
    {
        set<id> surAccId = new set<id>();
        List<Account_Link__c> accLnkList = new List<Account_Link__c>();
        set<id> dealerIds = new set<id>();
        List<Account> dealerAccountList = new List<Account>();
		set<string> dealerNdCodes = new set<string>();
		List<group> dealergrps = new List<group>();
        List<SurveyTaker__Share> shreSurTkerList = new List<SurveyTaker__Share>();
        
        for(SurveyTaker__c surtk : surveyTkrList)
        {   
            if(surtk.Account__c != null)
            {
                surAccId.add(surtk.Account__c);
            }
        }
        system.debug('surAccId>>>>' + surAccId);
        if(!surAccId.isEmpty() && surAccId != null)
        {
            accLnkList = [select id,fromrole__c,torole__c from Account_Link__c where torole__c =:surAccId AND (RecordTypeId =:retailPersonRectypeId OR RecordTypeId =:retailCompanyRectypeId)];
        }
        system.debug('accLnkList>>>>>' + accLnkList);
        if(!accLnkList.isEmpty() && accLnkList != null && accLnkList.size() >0)
        {
            For(Account_Link__c aclnk : accLnkList)
            {
                if(aclnk.fromRole__c != null)
                {
                    dealerIds.add(aclnk.fromRole__c);
                }
            }
            system.debug('dealerIds>>>>>' + dealerIds);
            if(!dealerIds.isEmpty() && dealerIds != null)
            {
                dealerAccountList = [select id ,Dealer_ND_Code__c from Account where id =:dealerIds];
            }
            system.debug('dealerAccountList>>>>>' + dealerAccountList);
            if(!dealerAccountList.isEmpty() && dealerAccountList != null)
            {
                for(Account acc : dealerAccountList)
                {
                    if(acc.Dealer_ND_Code__c != '' && acc.Dealer_ND_Code__c != null)
                    {
                        dealerNdCodes.add(acc.Dealer_ND_Code__c);
                    }
                }
            }
            system.debug('dealerNdCodes>>>>>' + dealerNdCodes);
            if(!dealerNdCodes.isEmpty() && dealerNdCodes != null)
            {
                dealergrps = [select id ,Name ,Type from Group where  Name =:dealerNdCodes];
            }
            system.debug('dealergrps>>>>>' + dealergrps);
            for(SurveyTaker__c shrSt : surveyTkrList)
            {
                if(shrSt.Account__c != null)
                {
                    for(group g : dealergrps)
                    {
                 		SurveyTaker__Share shreSt = new SurveyTaker__Share();
                        shreSt.ParentId = shrSt.Id;
                        shreSt.AccessLevel = 'Edit';
                        shreSt.UserOrGroupId = g.Id;
                        shreSurTkerList.add(shreSt);
                    }
                }
            }
        }
        system.debug('shreSurTkerList>>>>' + shreSurTkerList);
        if(!shreSurTkerList.isEmpty() && shreSurTkerList != null)
        {
            insert shreSurTkerList;
        }
    }
}