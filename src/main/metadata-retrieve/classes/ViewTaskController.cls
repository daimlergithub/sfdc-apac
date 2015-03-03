/*
    Type:       Extension for ViewTask Page
    Purpose:    Display acitvity history
    			(closed task of record types DM, IB Call, MMS, OB Call, SMS, eDM, Social Media.)
    User Story: Data Sharing V1.0
    Used By:    ViewTask.page
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-06-11
*/
public without sharing class ViewTaskController {
    
    // Hitorical Activity List
    public List<ActivityWrapper> wraps {get; set;}
    
    public ViewTaskController (ApexPages.StandardController stdController) {      
        // Current Personal account
        Account acc =  (Account)stdController.getRecord();
        
        String[] recordTypes = new String[]{
        	'DM', 'IB Call', 'MMS', 'OB Call', 'SMS', 'eDM', 'Social Media'
        };
        
        wraps = new List<ActivityWrapper>();
        ActivityWrapper acwrap = null;
        
        // Hitorical task relate to current person account.
        for(Task taskTypeAcc : [select 
									Subject, 
									Status, 
									RecordType.Name, 
									What.Name, 
									CreatedDate,
									WhatId
								from Task 
								where WhatId = :acc.Id
								and Status = 'Closed'
								and RecordType.Name in :recordTypes]) {
        	acwrap = new ActivityWrapper();
        	acwrap.tk = taskTypeAcc;
            acwrap.RelatedTo = taskTypeAcc.What.Name;
        	wraps.add(acwrap);
		}

        // Create a map with case subject relate to case Id.
        Map<id,String> caseIdAndSubjectMap = new Map<id,String>();
        for (Case cs : [Select Id, Subject From Case Where AccountId = :acc.Id]) {
            if(!caseIdAndSubjectMap.containsKey(cs.Id)) {
                caseIdAndSubjectMap.put(cs.Id, cs.Subject);
            }
        }
        
        // Hitorical task relate to cases belongs to the person account.
        for(Task taskTypeCase : [select 
									Subject, 
									Status, 
									RecordType.Name, 
									What.Name, 
									CreatedDate,
									WhatId
								from Task 
								where WhatId in :caseIdAndSubjectMap.keySet() 
								and What.Type = 'Case'
								and Status = 'Closed'
								and RecordType.Name in :recordTypes]) {
        	acwrap = new ActivityWrapper();
        	acwrap.tk = taskTypeCase;
        	// If acitvity is related to a case, put case subject into the column "Related to".
    		acwrap.RelatedTo = caseIdAndSubjectMap.get(taskTypeCase.WhatId);
        	wraps.add(acwrap);
		}
    }
    
    // Inner Wrapper Class
    public class ActivityWrapper {
        public Task tk {get; set;}
        public String RelatedTo {get; set;}
        
        public ActivityWrapper() {}
    }
}