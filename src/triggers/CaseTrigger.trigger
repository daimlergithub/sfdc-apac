/*
    Type:       Trigger
    Purpose:    1. When MB Complaint or Chrysler Complaint creat,"Subject" will be auto input value as "Case Subtype".
                2. When MB Complaint or Chrysler Complaint creat or update,If User select a Vehicle Relationship,
                   "Vehicle Brand","Vehicle Class", "Vehicle Model" and "VIN Code" will be auto input value as Vehicle's information.
                3. when a case is cloned, if the Parent case is existed, RepeatComplaintTimes plus 1.

    User Story: US-CC-002 , US-CC-003, US-CC-004,US-CC-008 ,US-CC-011 ,BRD-Tickets to CR
    Used By:
    ---------------------------------------------------------------
    History:

    1. Bing Bai Created on 2013-05-17
    2. Sinow Modified on 2013-07-19: If Feedback to CAC changed from null to any values, change Has Feedback to true.
    3. Sinow Modified on 2013-07-19: Update 15 Minutes Before Deadline when Deadline is inserted or updated.
    4. Chaos Edit on 2014-2-28  AS-Complaint_002(2014Release1.1)
    5. Justin Yu updated on 2014-03-24
    6. Cyril Huang updated on 2014-04-30(2014Release1.1b)
    7. Barney Lai updated on 2014-05-23
    8. Sinow updated for Once a Retail Inquiry Case was created by CAC IB CSR, the Case Owner shall be changed to Community Dealer S&M user. 2014/06/25.
    9. Shuang Li updated for Repeat Complaint Times  on 2014-08-14
    10. Cyril Huang updated on 2014-10-10(2014Release1.3)
    11. 2015-04-21 Gerhard Henning (NTTData)  Moved code to CaseTriggerHandler
*/
trigger CaseTrigger on Case (before insert, before update, after insert, after update, after delete,before delete) 
{ 
    TriggerUtil.handleTrigger('CaseTrigger');
}