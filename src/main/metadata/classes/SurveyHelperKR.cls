/*********************************************************************************
    Class Name  : SurveyHelperKR
    Created By   : 
    Created Date : 8th December 2017
    Project      : Daimler APAC
    Usages       : This a KR market Survey realted helperclass class.
                   1. Share the Survey records with the dealer HQ / Dealer Call Center
    
 ***********************************************************************************/
public class SurveyHelperKR 
{
	 /*************************************************************************************************************************
     Method Name  : shareSurverWithDealer
     Created By   : 
     Created Date : 8th December 2017
     Project      : Daimler APAC
     Usages       : This method would share the Survey records to dealers based on below conditions.
                    2. Records created by Dealer HQ / Dealer Call Center users will be shared with everyone within Dealer HQ / Dealer Call Center and MBK. 
        
    ***************************************************************************************************************************/
    public static void shareSurverWithDealer(List<Survey__c> surveyList)
    {
    	User currentUser = [select Id, Contact.Account.Dealer_Type__c, Contact.Account.Dealer_GC_Code__c from User where Id =: UserInfo.getUserId()];
    	set<string> dealerNdCodes = new set<string>();
		List<group> dealergrps = new List<group>();
		List<Survey__Share> shareSurveyList = new List<Survey__Share>();
		List<Account> dealerAccountList = new List<Account>();
		Id dealerAccntRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
		
    	dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccntRecTypId and MD__c = 'KR' and Dealer_GC_code__c =: currentUser.Contact.Account.Dealer_GC_Code__c];
    	
    	if(userinfo.getUserType()== 'PowerPartner' && currentUser.Contact.Account.Dealer_Type__c == 'Company')
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
	    	if(surveyList != null && !surveyList.isEMpty() && dealergrps != null && !dealergrps.isEmpty())
			{
				for(Survey__c suvy : surveyList)
				{
					for(Group dlrGrp : dealergrps)
					{
						Survey__Share shreSuvy = new Survey__Share();
		                shreSuvy.ParentId = suvy.Id;
		                shreSuvy.AccessLevel = 'Edit';
		                shreSuvy.UserOrGroupId = dlrGrp.Id;
		                shareSurveyList.add(shreSuvy);
					}
				}
			}
    	}
    	system.debug('shreSurTkerList>>>>' + shareSurveyList);
        if(shareSurveyList != null && !shareSurveyList.isEmpty())
        {
            insert shareSurveyList;
        }
    }
}