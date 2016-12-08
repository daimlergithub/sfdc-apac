/*
Type        : Scheduled Apex Class on Account
Purpose     : If a Lead is not modified for last 5 years and if the corresponding account activities also not modified for 5 years and the account PC_Status__c = 'Prospect' AND VAN_Status__c = 'Prospect' AND Insurance_Status__c = 'Prospect'
	  then change the account record type to 'Company Soft Deleted'.
Issue nO    : SFDCAU-974
Created Date: 7th Oct, 2016
ReCreated Date : 5th Dec, 2016 By Sudheer Kandukuri

*/

global class AccountRecordTypeToSoftDelete implements Schedulable {
	private static final String PersonAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.PERSON_ACCOUNT).getRecordTypeId();
	private static final String CompanyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.COMPANY_ACCOUNT).getRecordTypeId();
	private static final String PersonAccountSoftDeletedRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.PERSON_SOFT_DELETE_ACCOUNT).getRecordTypeId();
	private static final String CompanyAccountSoftDeletedRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilConstant.COMPANY_SOFT_DELETE_ACCOUNT).getRecordTypeId();

	global void execute(SchedulableContext sc){

	List<Account> acctList=[SELECT id, RecordtypeID, LastModifiedDate, (SELECT id, Name,LastModifiedDate  FROM Lead_Contact__r ORDER BY LastModifiedDate DESC LIMIT 1) , 
											(SELECT id, Name,LastModifiedDate  FROM Leads__r  ORDER BY LastModifiedDate DESC LIMIT 1), 
											(SELECT id, LastModifiedDate  FROM tasks ORDER BY LastModifiedDate DESC LIMIT 1), 
											(SELECT id, LastModifiedDate  FROM Events ORDER BY LastModifiedDate DESC LIMIT 1) 
											From Account WHERE (RecordtypeID =: PersonAccountRecordTypeId OR RecordtypeID =: CompanyAccountRecordTypeId) AND
											(PC_Status__c =: UtilConstant.Prospect_Value AND VAN_Status__c =: UtilConstant.Prospect_Value AND Insurance_Status__c =: UtilConstant.Prospect_Value)];


	List<account> modifiedacclist = new List<account>();
	Datetime lastFiveYears = System.Now().addyears(-5);

	for (Account acc:acctList)
	{
	datetime lastmodifieddate_lead;
	datetime lastmodifieddate_task_event;

	if (acc.Lead_Contact__r!= null && !acc.Lead_Contact__r.isEmpty())
	{
	   lastmodifieddate_lead =  acc.Lead_Contact__r[0].lastmodifieddate;
	}
	 if (acc.Leads__r != null && !acc.Leads__r.isEmpty())
	{
		if (lastmodifieddate_lead == null || lastmodifieddate_lead < acc.Leads__r[0].lastmodifieddate)
		{
			 lastmodifieddate_lead =  acc.Leads__r[0].lastmodifieddate;
		} 
	  
	}
	 if (acc.tasks!= null && !acc.tasks.isEmpty())
	{
	   lastmodifieddate_task_event =  acc.tasks[0].lastmodifieddate;
	}
	 if (acc.Events != null && !acc.Events.isEmpty())
	{
		if (lastmodifieddate_task_event == null || lastmodifieddate_task_event < acc.Events[0].lastmodifieddate)
		{
			 lastmodifieddate_task_event =  acc.Events[0].lastmodifieddate;
		} 
	  
	}
	if ((lastmodifieddate_lead != null && lastmodifieddate_lead < lastFiveYears) && (lastmodifieddate_task_event == null || lastmodifieddate_task_event < lastFiveYears ) ) 

		{
			
			if (acc.RecordtypeID == PersonAccountRecordTypeId)
			{
				acc.RecordtypeID= PersonAccountSoftDeletedRecordTypeId;
			}
			if (acc.RecordtypeID == CompanyAccountRecordTypeId)
			{
				acc.RecordtypeID= CompanyAccountSoftDeletedRecordTypeId;
			}
			Account acct= new Account();
			acct.id= acc.id;
			 acct.RecordtypeID= acc.RecordtypeID;
			modifiedacclist.add(acct);
			System.debug('Change Record Type to SoftDelete >>>>>>>>>>>' + acc.name + '<<<ID >>>>' + acc.id);
		}
		else 
		{
			if (acc.LastModifiedDate < lastFiveYears){
				if (acc.RecordtypeID == PersonAccountRecordTypeId)
				{
					acc.RecordtypeID= PersonAccountSoftDeletedRecordTypeId;
				}
				if (acc.RecordtypeID == CompanyAccountRecordTypeId)
				{
					acc.RecordtypeID= CompanyAccountSoftDeletedRecordTypeId;
				}
				Account acct= new Account();
				acct.id= acc.id;
				acct.RecordtypeID= acc.RecordtypeID;
				modifiedacclist.add(acct);
			}
		}


	}


		if(!modifiedacclist.isEmpty())
		{
			Update modifiedacclist;
		}

	}
}