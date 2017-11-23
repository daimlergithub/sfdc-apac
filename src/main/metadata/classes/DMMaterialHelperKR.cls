/*********************************************************************************
	Class Name  : DMMaterialHelperKR
	Created By   : 
	Created Date : 16th November 2017
	Project      : Daimler APAC
	Usages       : This a KR market DM Material realted helperclass class.
				   1. Share the DM Maretial records within the dealership and dealer outlets
				      based on dealer users hierarchy setup.
	
 ***********************************************************************************/
 
public class DMMaterialHelperKR 
{
	  /*************************************************************************************************************************
		Method Name  : shareDMMaterialRecordsWithinDealership
		Created By   : 
		Created Date : 16th November 2017
		Project      : Daimler APAC
		Usages       : This method would share the DM Material records within the dealership based on below 2 conditions.
					   1. Records created by Team Leads or Managers. Record owner and people in above hierarchy will get to view the data. 
					   2. Records created by Dealer outlet users will be shared with Dealer HQ / Dealer Call Center. 
		
	  ***************************************************************************************************************************/
    public static void shareDMMaterialRecordsWithinDealership (list<DM_Material__c> dmMaterialList)
    {
    	if(userinfo.getUserType()== 'PowerPartner')
    	{
    		list<DM_Material__Share> insertDMMaterialShareList = new list<DM_Material__Share>();
	    	list<Id> userIdList = new list<Id>();
	    	set<Id> ownerIdSet = new set<Id>();
	    	set<string> dealerCompNdCodeSet = new set<string>();
	    	list<Group> dealerCompGroupList = new list<Group>();
	    	Id dealerAccountRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	    	User currentUser = [select Id, Contact.Account.Dealer_Type__c, Contact.Account.Dealer_GC_Code__c from User where Id =: UserInfo.getUserId()];
	    	list<Account> dealerAccountList = new list<Account>();
	    	
	    	if(currentUser.Account.Dealer_Type__c == 'Outlet')
	    	{
	    		dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccountRecTypId and MD__c = 'KR' and Dealer_Type__c = 'Company' and Dealer_GC_code__c =: currentUser.Account.Dealer_GC_Code__c];
	    		if(!dealerAccountList.isEmpty() && dealerAccountList != null)
	    		{
	    			for(Account accnt : dealerAccountList)
	    			{
	    				dealerCompNdCodeSet.add(accnt.Dealer_ND_Code__c);
	    			}
	    			if(!dealerCompNdCodeSet.isEmpty() && dealerCompNdCodeSet != null)
			    	{
			    		dealerCompGroupList = [select Id, Name from Group where Name in : dealerCompNdCodeSet];
			    	}
	    		}
	    		if(!dmMaterialList.isEmpty() && dmMaterialList != null)
		    	{
		    		for(DM_Material__c dmMtrl : dmMaterialList)
			    	{
			    		ownerIdSet.add(dmMtrl.OwnerId);
			    		if(!dealerCompGroupList.isEmpty() && dealerCompGroupList != null)
				    	{
				    		for(group grp : dealerCompGroupList)
				    		{
				    			DM_Material__Share dmMtrlShare = new DM_Material__Share();
			    				dmMtrlShare.ParentId = dmMtrl.Id;
			    				dmMtrlShare.AccessLevel = 'Edit';
			    				dmMtrlShare.UserOrGroupId = grp.Id;
			    				insertDMMaterialShareList.add(dmMtrlShare);
				    		}
				    	}
			    	}
			    	userIdList = utilDealerLevelRecordShare.shareRecordsWithinDealership(ownerIdSet);
			    	if(!userIdList.isEmpty() && userIdList != null)
			    	{
			    		for(DM_Material__c dmMtrl : dmMaterialList)
			    		{
			    			for(Id usrId : userIdList)
			    			{
			    				DM_Material__Share dmMtrlShare = new DM_Material__Share();
			    				dmMtrlShare.ParentId = dmMtrl.Id;
			    				dmMtrlShare.AccessLevel = 'Edit';
			    				dmMtrlShare.UserOrGroupId = usrId;
			    				insertDMMaterialShareList.add(dmMtrlShare);
			    			}
			    		}
			    	}
		    	}
		    	
	    	}
	    	else if(currentUser.Account.Dealer_Type__c == 'Company')
	    	{
	    		dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccountRecTypId and MD__c = 'KR' and Dealer_GC_code__c =: currentUser.Account.Dealer_GC_Code__c];
	    		if(!dealerAccountList.isEmpty() && dealerAccountList != null)
	    		{
	    			for(Account accnt : dealerAccountList)
	    			{
	    				dealerCompNdCodeSet.add(accnt.Dealer_ND_Code__c);
	    			}
	    			if(!dealerCompNdCodeSet.isEmpty() && dealerCompNdCodeSet != null)
			    	{
			    		dealerCompGroupList = [select Id, Name from Group where Name in : dealerCompNdCodeSet];
			    	}
	    		}
	    		if(!dmMaterialList.isEmpty() && dmMaterialList != null && !dealerCompGroupList.isEmpty() && dealerCompGroupList != null)
		    	{
		    		for(DM_Material__c dmMtrl : dmMaterialList)
			    	{
			    		for(group grp : dealerCompGroupList)
			    		{
			    			DM_Material__Share dmMtrlShare = new DM_Material__Share();
		    				dmMtrlShare.ParentId = dmMtrl.Id;
		    				dmMtrlShare.AccessLevel = 'Edit';
		    				dmMtrlShare.UserOrGroupId = grp.Id;
		    				insertDMMaterialShareList.add(dmMtrlShare);
			    		}
			    	}
			    }
	    	}
	    	system.debug('*$*$*$*$* insertDMMaterialShareList  ' + insertDMMaterialShareList);
	    	if(!insertDMMaterialShareList.isEmpty() && insertDMMaterialShareList != null)
	    	{
	    		insert insertDMMaterialShareList;
	    	}
	    }
    }
}