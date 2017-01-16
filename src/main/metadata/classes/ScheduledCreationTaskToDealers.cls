/*
    Type:       Schedule For creation Task
    Purpose:    For creation Task to Dealers 
    User Story: Retail Campaign
    Used By:    
    ---------------------------------------------------------------
    History:
        1. Shuang Li Created on 2014-05-12
*/

global class ScheduledCreationTaskToDealers  implements Schedulable{

    global void execute(SchedulableContext SC) 
    {
		//Added community license switching mechanism
    	if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
    	{
	        //List<User> DealerUserList = [Select Id, ContactId From User Where (Profile.Name = 'Dealer Community S&M Manager' OR Profile.Name = 'Dealer Community Marketing Manager') And IsActive = true];
	        List<User> DealerUserList = [Select Id, ContactId From User Where Contact.Permission_Set_Settings__c includes ('S_M_Retail_Campaign') And IsActive = true];
	        List<Task> taskList = new List<Task>();
	        for(User user : DealerUserList ){
	             taskList.add(generateTask(user, 'Please submit plan of activities and feedback'));
	        }
	        if(taskList.size() > 0){
	            try {
	                insert(taskList);
	                }
	            catch (DMLException e) {
	                System.debug('Exception message is :' + e.getDMLMessage(0));
	            }
	        }
    	}
    }
    
    private Task generateTask(User user ,String strSubject) {
    Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
    return   new Task(
                Subject= strSubject, 
                RecordTypeId = cpRecordTypeMap.get('General Task').getRecordTypeId(),
                OwnerId = user.id,
                Status = 'open',
                Priority = 'High',
                WhoId = user.ContactId,
                WhatId = null,
                ActivityDate = date.today());
    }
}