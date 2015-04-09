/**
    Type:       Complaint Description utility
    Purpose:
    1. As the case team member, when a  team member  create  a complaint description/ resolution
          on MB Complaint , and the ?Urgent? field of the case is ticked, an notify email will be
          sent to other case team members.

    User Story:
    Used By:  ComplaintDescriptionAfterInsert.trigger
    ---------------------------------------------------------------
    History:
    4-Dec-2013 Bing (NTTData)  Created
 */
public without sharing class ComplaintDesHelper {

    //MB Complaint record type
    static String MB_COMPLAINT_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.MB_COMPLAINT).getRecordTypeId();

    //salesforce Url
    static String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    /**
       for purpose No.1
     */
    public static void sendMailToCaseMember(List<id> ids)
    {

        Map<id, case> caseIds = new Map<id, case>([select id ,Workflow_Order__c from case
            where recordtypeid = :MB_COMPLAINT_RECORD_TYPE
            and   id in          :ids
            and   Urgent__c    = true]);

        if (caseIds!=null && !caseIds.IsEmpty())
        {
            for (Case c: caseids.values())
            {
                c.Workflow_Order__c = true;
            }

            update caseids.values();
        }

    }
    
    public static void before_AfterInsertEvents(list<Complaint_Description__c> complaintDescriptionNew)
    {
		list<id> caseIds = new list<id>();
		for(Complaint_Description__c cdc : complaintDescriptionNew)
		{
			caseIds.add(cdc.Case__c);
		}
		if(caseIds!=null && caseIds.isEmpty())
		{
			sendMailToCaseMember(caseIds);
		}
    }
    
    public static void afterupdateEvents(list<Complaint_Description__c> complaintDescriptionNew,map<id,Complaint_Description__c> complaintDescriptionOldMap)
    {
    	Set<Id> updatedCaseIds = new Set<Id>();
		for(Complaint_Description__c descNew : complaintDescriptionNew)
		{
            Complaint_Description__c descOld = complaintDescriptionOldMap.get(descNew.id);
            if(descNew.Description__c != descOld.Description__c)
            {
                updatedCaseIds.add(descNew.Case__c);
            }
        }
        
        if (updatedCaseIds!=null && !updatedCaseIds.IsEmpty())
        {
	        updatecases(updatedCaseIds);
	    }
    }
    
    public static void afterDeleteEvents(list<Complaint_Description__c> complaintDescriptionOld)
    {
		Set<Id> updatedCaseIds = new Set<Id>();
		for(Complaint_Description__c descOld : complaintDescriptionOld)
		{
            updatedCaseIds.add(descOld.Case__c);
        }
        
        if (updatedCaseIds!=null && !updatedCaseIds.IsEmpty())
        {
	        updatecases(updatedCaseIds);
	    }
    }
    
    public static void updatecases(set<id> updatedCaseIds)
    {
    	List<Case> casesForUpdate = new List<Case>();
        for(Case cas : [select Id, Description_Changed__c from Case where Id in :updatedCaseIds])
        {
            cas.Description_Changed__c = true;
            casesForUpdate.add(cas);
        }
        if (casesForUpdate!=null && !casesForUpdate.IsEmpty())
        {
           try {
               update casesForUpdate;
           }
           catch (DMLException e) {
               System.debug('Exception occured when update the description changed flag on Case: ' + e.getDMLMessage(0));
           } 
        } 
    }
    
    public static void updateComplaintDateandCreatedBy(list<Complaint_Description__c> complaintDescriptionNew)
    {
		for(Complaint_Description__c cd : complaintDescriptionNew)
		{
            cd.Created_By__c = UserInfo.getUserId();
            cd.Date_Time__c = System.now();
        }
    }

}