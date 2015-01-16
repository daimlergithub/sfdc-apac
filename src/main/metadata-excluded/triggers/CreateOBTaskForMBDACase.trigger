trigger CreateOBTaskForMBDACase on Case (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('CreateOBTaskForMBDACase')) {
        return;
    }
    
    String MBDAComplaintCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MBDA Complaint').getRecordTypeId();
    String MBDAInquiryCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MBDA Inquiry').getRecordTypeId();
    String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    
    Id cacMbdaQueueId = getCACMBDAQueueId();
    List<Task> newOBTasks = new List<Task>();
    
    List<Case> mbdaCompliantCases = new List<Case>();
    List<Case> mbdaInquiryCases = new List<Case>();
    Set<Id> relatedAccountIds = new Set<Id>();
    
    if(trigger.isInsert) {
        for(Case tempCase : trigger.new) {
            if(IsComplaintCase(tempCase) && OwnerIsCACMBDAQueue(tempCase)) { 
                mbdaCompliantCases.add(tempCase);
                relatedAccountIds.add(tempCase.AccountId);
            }
            if(IsInquiryCase(tempCase) && OwnerIsCACMBDAQueue(tempCase)) { 
                mbdaInquiryCases.add(tempCase);
                relatedAccountIds.add(tempCase.AccountId);
            }
        }
    }
    
    if(trigger.isUpdate) {
        for(Case tempCase : trigger.new) {
            if(IsComplaintCase(tempCase) && IsCaseOwnerChangedToCACMBDAQueue(tempCase)) {
                //newOBTasks.add(createOBTask(tempCase, 'MBDA投诉回访'));
                mbdaCompliantCases.add(tempCase);
                relatedAccountIds.add(tempCase.AccountId);
            }
            if(IsInquiryCase(tempCase) && IsCaseOwnerChangedToCACMBDAQueue(tempCase)) {
                //newOBTasks.add(createOBTask(tempCase, 'MBDA问询回访'));
                mbdaInquiryCases.add(tempCase);
                relatedAccountIds.add(tempCase.AccountId);
            }
        }
    }
    
    if(mbdaInquiryCases.size() > 0 || mbdaCompliantCases.size() > 0) {
        /*
        *    Get specialist User.
        */
        User mbdaSpecialistUser = getMBDASpecialistUser();
        String mbdaSpecialistUserId;
        if(mbdaSpecialistUser != null) {
            mbdaSpecialistUserId = mbdaSpecialistUser.Id;
        }
        
        Map<Id, Account> relatedAccMap = new Map<Id, Account>([select Id, PersonContactId, IsPersonAccount, (select Id from Contacts order by createdDate desc limit 1) from Account where Id in :relatedAccountIds]);
        
        for(Case tempCase : mbdaCompliantCases) {
            newOBTasks.add(createOBTask(tempCase, relatedAccMap.get(tempCase.AccountId), mbdaSpecialistUserId, 'MBDA投诉回访'));
        }
        
        for(Case tempCase : mbdaInquiryCases) {
            newOBTasks.add(createOBTask(tempCase, relatedAccMap.get(tempCase.AccountId), mbdaSpecialistUserId, 'MBDA问询回访'));
        }
        
        insert newOBTasks;
    }
    
    private Task createOBTask(Case tempCase, Account tempAccount, String tempSpecialistUserId, String tempSubject) {
        Task newTask = new Task(Subject = tempSubject, RecordTypeId = OBTaskRecordTypeId);
        newTask.WhatId = tempCase.Id;
        if(tempAccount != null) {
            if(tempAccount.IsPersonAccount == true) {
                newTask.WhoId = tempAccount.PersonContactId;
            }
            else {
                String tempContactId = (tempAccount.Contacts.size() > 0)? tempAccount.Contacts[0].Id : null;
                newTask.WhoId = tempContactId;
            }
        }
        newTask.OwnerId = tempSpecialistUserId; // newTask It is a role :MBDA specialist
        return newTask;
    }
    
    private Id getCACMBDAQueueId()
    {
        Id queueId;
        List<Group> tempGroups = [select Id from Group where DeveloperName = 'CAC_MBDA' and Type = 'Queue' order by CreatedDate desc limit 1 ];
        if(tempGroups.size() > 0) {
            queueId = tempGroups[0].Id;
        }
        return queueId;
    }
    
    private Boolean IsCaseOwnerChangedToCACMBDAQueue(Case tempCase) {
        if(tempCase.OwnerId == cacMbdaQueueId && tempCase.OwnerId != trigger.oldMap.get(tempCase.Id).OwnerId) {
            return true;
        }
        return false;
    }
    
    private Boolean IsComplaintCase(Case tempCase) {
        return tempCase.RecordTypeId == MBDAComplaintCaseRecordTypeId;
    }
    
    private Boolean IsInquiryCase(Case tempCase) {
        return tempCase.RecordTypeId == MBDAInquiryCaseRecordTypeId;
    }
    
    private Boolean OwnerIsCACMBDAQueue(Case tempCase) {
        return tempCase.OwnerId == cacMbdaQueueId;
    }

    private User getMBDASpecialistUser() {
        User tempSpecialistUser;
        List<User> specialistUsers = [select Id, Name from User where UserRole.Name = 'MBDA specialist' and IsActive = true limit 1];
        if(specialistUsers.size() > 0) {
            tempSpecialistUser = specialistUsers[0];
        }
        return tempSpecialistUser;
    } 
}