/**
    Type:       Complaint Description utility
    Purpose:
    1. As the case team member, when a  team member  create  a complaint description/ resolution
          on MB Complaint , and the “Urgent” field of the case is ticked, an notify email will be
          sent to other case team members.

    User Story:
    Used By:  ComplaintDescriptionAfterInsert.trigger
    ---------------------------------------------------------------
    History:
    4-Dec-2013 Bing (NTTData)  Created
 */
public without sharing class ComplaintDesHelper {

    public ComplaintDesHelper() {

    }

    //MB Complaint record type
    static String MB_COMPLAINT_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();

    //salesforce Url
    static String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    /**
       for purpose No.1
     */
    public static void sendMailToCaseMember(List<id> ids){

        Map<id, case> caseIds = new Map<id, case>([select id ,Workflow_Order__c
            from case
            where recordtypeid = :MB_COMPLAINT_RECORD_TYPE
            and   id in          :ids
            and   Urgent__c    = true]);

        if (caseids.keySet().size()>0){
            for (Case c: caseids.values()){
                c.Workflow_Order__c = true;
            }

            update caseids.values();
        }

    }

}