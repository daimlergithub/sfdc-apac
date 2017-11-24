/*********************************************************************************
	Class Name  : DMRequestHelperKR
	Created By   : 
	Created Date : 17th November 2017
	Project      : Daimler APAC
	Usages       : This a KR market DM Request realted helperclass class.
				   1. Share the DM Request records within the dealership and dealer outlets
				      based on dealer users hierarchy setup.
	
 ***********************************************************************************/
 
public class DMRequestHelperKR 
{
	  /*************************************************************************************************************************
		Method Name  : shareDMRequestRecordsWithinDealership
		Created By   : 
		Created Date : 17th November 2017
		Project      : Daimler APAC
		Usages       : This method would share the DM Request records within the dealership based on below 2 conditions.
					   1. Records created by Team Leads or Managers. Record owner and people in above hierarchy will get to view the data. 
					   2. Records created by Dealer outlet users will be shared with Dealer HQ / Dealer Call Center. 
		
	  ***************************************************************************************************************************/
    public static void shareDMRequestRecordsWithinDealership (list<DM_Request__c> dmRequestList)
    {
    	if(userinfo.getUserType()== 'PowerPartner')
    	{
    		list<DM_Request__Share> insertDMRequestShareList = new list<DM_Request__Share>();
	    	list<Id> userIdList = new list<Id>();
	    	set<Id> ownerIdSet = new set<Id>();
	    	set<string> dealerCompNdCodeSet = new set<string>();
	    	list<Group> dealerCompGroupList = new list<Group>();
	    	Id dealerAccountRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	    	User currentUser = [select Id, Account.Dealer_Type__c, Account.Dealer_GC_Code__c, Account.Dealer_ND_Code__c from User where Id =: UserInfo.getUserId()];
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
	    		if(!dmRequestList.isEmpty() && dmRequestList != null)
		    	{
		    		for(DM_Request__c dmRqst : dmRequestList)
			    	{
			    		ownerIdSet.add(dmRqst.OwnerId);
			    		if(!dealerCompGroupList.isEmpty() && dealerCompGroupList != null)
				    	{
				    		for(group grp : dealerCompGroupList)
				    		{
				    			DM_Request__Share dmRqstShare = new DM_Request__Share();
			    				dmRqstShare.ParentId = dmRqst.Id;
			    				dmRqstShare.AccessLevel = 'Edit';
			    				dmRqstShare.UserOrGroupId = grp.Id;
			    				insertDMRequestShareList.add(dmRqstShare);
				    		}
				    	}
			    	}
			    	userIdList = utilDealerLevelRecordShare.shareRecordsWithinDealership(ownerIdSet);
			    	if(!userIdList.isEmpty() && userIdList != null)
			    	{
			    		for(DM_Request__c dmRqst : dmRequestList)
			    		{
			    			for(Id usrId : userIdList)
			    			{
			    				DM_Request__Share dmRqstShare = new DM_Request__Share();
			    				dmRqstShare.ParentId = dmRqst.Id;
			    				dmRqstShare.AccessLevel = 'Edit';
			    				dmRqstShare.UserOrGroupId = usrId;
			    				insertDMRequestShareList.add(dmRqstShare);
			    			}
			    		}
			    	}
		    	}
		    	
	    	}
	    	else if(currentUser.Account.Dealer_Type__c == 'Company')
	    	{
	    		//dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccountRecTypId and MD__c = 'KR' and Dealer_GC_code__c =: currentUser.Account.Dealer_GC_Code__c];
	    		//if(!dealerAccountList.isEmpty() && dealerAccountList != null)
	    		//{
	    			//for(Account accnt : dealerAccountList)
	    			//{
	    				//dealerCompNdCodeSet.add(accnt.Dealer_ND_Code__c);
	    			//}
	    			//if(!dealerCompNdCodeSet.isEmpty() && dealerCompNdCodeSet != null)
			    	//{
			    		dealerCompGroupList = [select Id, Name from Group where Name =: currentUser.Account.Dealer_ND_Code__c];
			    	//}
	    		//}
	    		if(dmRequestList != null && !dmRequestList.isEmpty())
	    		{
		    		if(dealerCompGroupList != null && !dealerCompGroupList.isEmpty())
			    	{
			    		for(DM_Request__c dmRqst : dmRequestList)
				    	{
			    		ownerIdSet.add(dmRqst.OwnerId);
			    		for(group grp : dealerCompGroupList)
			    		{
			    			DM_Request__Share dmRqstShare = new DM_Request__Share();
		    				dmRqstShare.ParentId = dmRqst.Id;
		    				dmRqstShare.AccessLevel = 'Edit';
		    				dmRqstShare.UserOrGroupId = grp.Id;
		    				insertDMRequestShareList.add(dmRqstShare);
			    		}
			    	}
		    	}			    
			    userIdList = utilDealerLevelRecordShare.shareRecordsWithinDealership(ownerIdSet);
			    	if(!userIdList.isEmpty() && userIdList != null)
			    	{
			    		for(DM_Request__c dmRqst : dmRequestList)
			    		{
			    			for(Id usrId : userIdList)
			    			{
			    				DM_Request__Share dmRqstShare = new DM_Request__Share();
			    				dmRqstShare.ParentId = dmRqst.Id;
			    				dmRqstShare.AccessLevel = 'Edit';
			    				dmRqstShare.UserOrGroupId = usrId;
			    				insertDMRequestShareList.add(dmRqstShare);
			    			}
			    		}
			    	}
		    	}
	    	}
	    	system.debug('*$*$*$*$* insertDMRequestShareList  ' + insertDMRequestShareList);
	    	if(!insertDMRequestShareList.isEmpty() && insertDMRequestShareList != null)
	    	{
	    		insert insertDMRequestShareList;
	    	}
	    }
    }
}