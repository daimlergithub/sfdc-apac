/*
Description : Updating the lead__c object Time_since_last_activity__c field and First_Activity_date__c, if the lead related
			  accounts recordtype is not soft delete
*/

//global class ScheduleLeadLastActivityDate implements Schedulable{
//    global void execute(SchedulableContext sc){
  
public class ScheduleLeadLastActivityDate{
    public static void  execute(){
		List<Lead__c> leadList = [SELECT Id,contact__r.recordType.name,Company_Account__r.recordType.name FROM Lead__c];
        List<Lead__c> leadToUpdate = new List<Lead__c>();
        Map<Id,Id> leadIdAccId = new Map<Id,Id>();
        List<Id> leadIds = new List<Id>();
        for(Lead__c curLeadTo : leadList)
        {
            if(curLeadTo.contact__c != NULL)
            {
                if(curLeadTo.company_account__c != NULL)
                {
                    if(curLeadTo.Contact__r.RecordType.name == 'Person Account' && curLeadTo.Company_Account__r.RecordType.name == 'Company')
                    leadIds.add(curLeadTo.Id);
                }
            }
            if(curLeadTo.contact__c == NULL)
            {
                if(curLeadTo.company_account__c != NULL)
                {
                    if( curLeadTo.Company_Account__r.RecordType.name == 'Company')
                    leadIds.add(curLeadTo.Id);
                }
            }
            if(curLeadTo.contact__c != null)
            {
                if(curLeadTo.company_account__c == null)
                {
                    if(curLeadTo.Contact__r.RecordType.name == 'person Account')
                    leadIds.add(curLeadTo.Id);
                }
            }    
           
        }
        Map<Id, DateTime> leadIDActivityCreatedDate = new Map<Id, DateTime>();
        Map<Id, Task> leadIdTaskMap = new Map<Id, Task>();
        for(Task tsk : [SELECT Id, CreatedDate,WhatId from Task where WhatId IN: leadIds ORDER BY CreatedDate ASC])
        {
            leadIdTaskMap.put(tsk.WhatId, tsk);
            if(leadIDActivityCreatedDate.get(tsk.WhatId) == null)
            	leadIDActivityCreatedDate.put(tsk.WhatId, tsk.CreatedDate);
        }
        
        Map<Id, Event> leadIdEventMap = new Map<Id, Event>();
        for(Event evnt : [SELECT Id, CreatedDate,WhatId from Event where WhatId IN: leadIds ORDER BY CreatedDate ASC])
        {
            leadIdEventMap.put(evnt.WhatId, evnt);
            if(leadIDActivityCreatedDate.get(evnt.WhatId) != null)
            {
                DateTime alreadyTaskCreatedDate = leadIDActivityCreatedDate.get(evnt.WhatId);
                if(alreadyTaskCreatedDate > evnt.CreatedDate)
                    leadIDActivityCreatedDate.put(evnt.WhatId, evnt.CreatedDate);
            }
            else if(leadIDActivityCreatedDate.get(evnt.WhatId) == null)
            {
                 	leadIDActivityCreatedDate.put(evnt.WhatId, evnt.CreatedDate);
            }
        }
        
        for(Lead__c curLead : [SELECT Id from Lead__C WHERE ID =: LeadIds])
        {
            Boolean updateLead = false;
            DateTime taskDate;
            DateTime eventDate;
            DateTime filteredFinalDate;
            if(leadIdTaskMap.get(curLead.Id) != null)
                taskDate = leadIdTaskMap.get(curLead.Id).CreatedDate;
            if(leadIdEventMap.get(curLead.Id) != null)
                eventDate = leadIdEventMap.get(curLead.Id).CreatedDate;
            if(taskDate != null && eventDate!= null)
            {
                if(taskDate > eventDate)
                    filteredFinalDate = taskDate;
                else
                    filteredFinalDate = eventDate;
            }
            else if(taskDate == null && eventDate!= null)
            {
                filteredFinalDate = eventDate;
            }
            else if(taskDate != null && eventDate== null)
            {
                filteredFinalDate = taskDate;
            }
            if(filteredFinalDate != null)
            {
                Date finalDate = date.newinstance(filteredFinalDate.year(), filteredFinalDate.month(), filteredFinalDate.day());
                Integer numberOfDays = finalDate.daysBetween(System.today());
                curLead.Time_since_Last_Activity__c = numberOfDays;
                 updateLead = true;
            }
            if(leadIDActivityCreatedDate.get(curLead.Id) != null)
            {
                curLead.First_activity_Date__c = leadIDActivityCreatedDate.get(curLead.Id);
                updateLead = true;
            }
            if(updateLead)
                leadToUpdate.add(curLead);
        }
        if(leadToUpdate.size() > 0)
            update leadToUpdate;
    }
}