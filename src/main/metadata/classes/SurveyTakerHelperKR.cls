/*********************************************************************************
    Class Name  : SurveyTakerHelperKR
    Created By   : 
    Created Date : 16th November 2017
    Project      : Daimler APAC
    Usages       : This a KR market DM Material realted helperclass class.
                   1. Share the Survey Taken records with the dealer HQ / Dealer Call Center
    
 ***********************************************************************************/
public class SurveyTakerHelperKR 
{
    /*************************************************************************************************************************
     Method Name  : shareSurverTakertoDealer
     Created By   : 
     Created Date : 8th December 2017
     Project      : Daimler APAC
     Usages       : This method would share the Survey Taken records to dealers based on below 2 conditions.
                    1. Records created by MBK. Dealer HQ and Dealer Call Center users will get to view the records. 
                    2. Records created by Dealer HQ / Dealer Call Center users will be shared with everyone within Dealer HQ / Dealer Call Center and MBK. 
        
    ***************************************************************************************************************************/
    public static void shareSurverTakertoDealer(List<SurveyTaker__c> surveyTkrList)
    {
    	Id dealerAccntRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    	User currentUser = [select Id, Contact.Account.Dealer_Type__c, Contact.Account.Dealer_GC_Code__c, Contact.Account.Dealer_ND_Code__c from User where Id =: UserInfo.getUserId()];
    	set<string> dealerNdCodes = new set<string>();
		List<group> dealergrps = new List<group>();
	    List<SurveyTaker__Share> shreSurTkerList = new List<SurveyTaker__Share>();
	    List<Account> dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccntRecTypId and MD__c = 'KR' and Dealer_Type__c = 'Company'];
    	
    	if(userinfo.getUserType()!= 'PowerPartner')
    	{
	        if(dealerAccountList != null && !dealerAccountList.isEmpty())
	        {
	        	for(Account dlrAcnt : dealerAccountList)
		        {
		            if(dlrAcnt.Dealer_ND_Code__c != null)
		            {
		                dealerNdCodes.add(dlrAcnt.Dealer_ND_Code__c);
		            }
		        }
	        }
	        if(dealerNdCodes != null && !dealerNdCodes.isEmpty())
	    	{
	    		dealergrps = [select Id, Name from Group where Name in : dealerNdCodes];
	    	}
			if(surveyTkrList != null && !surveyTkrList.isEMpty() && dealergrps != null && !dealergrps.isEmpty())
			{
				for(SurveyTaker__c suvTkr : surveyTkrList)
				{   
				    if(suvTkr.md__c=='KR'){
					for(Group dlrGrp : dealergrps)
					{
						SurveyTaker__Share shreSuvTkr = new SurveyTaker__Share();
		                shreSuvTkr.ParentId = suvTkr.Id;
		                shreSuvTkr.AccessLevel = 'Edit';
		                shreSuvTkr.UserOrGroupId = dlrGrp.Id;
		                shreSurTkerList.add(shreSuvTkr);
					}
					}
				}
			}
    	}
    	else if(userinfo.getUserType()== 'PowerPartner' && currentUser.Contact.Account.Dealer_Type__c == 'Company')
    	{
    		dealergrps = [select Id, Name from Group where Name =: currentUser.Contact.Account.Dealer_ND_Code__c];
    		if(surveyTkrList != null && !surveyTkrList.isEMpty() && dealergrps != null && !dealergrps.isEmpty())
			{
				for(SurveyTaker__c suvTkr : surveyTkrList)
				{
				    if(suvTkr.md__c=='KR'){
					for(Group dlrGrp : dealergrps)
					{
						SurveyTaker__Share shreSuvTkr = new SurveyTaker__Share();
		                shreSuvTkr.ParentId = suvTkr.Id;
		                shreSuvTkr.AccessLevel = 'Edit';
		                shreSuvTkr.UserOrGroupId = dlrGrp.Id;
		                shreSurTkerList.add(shreSuvTkr);
					}
					}
				}
			}
    	}
    	system.debug('shreSurTkerList>>>>' + shreSurTkerList);
        if(shreSurTkerList != null && !shreSurTkerList.isEmpty())
        {
            insert shreSurTkerList;
        }
    }
}