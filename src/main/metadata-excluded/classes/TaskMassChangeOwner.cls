/*
    Type:       Controller for TaskMassChangeOwener Visualforce page 
    Purpose:    Mass reassign tasks 
    User Story: US-SSI-006
    Used By:    TaskMassChangeOwener.page
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-04-24
    2. Shuang Li Edit on 2014-03-17  US-SMART_SSI-007
*/

public with sharing class TaskMassChangeOwner {
	public Task task{set;get;}    
	private String [] arrObjIds;    
    
	public TaskMassChangeOwner(){        
		//Initalize the variables   
		     
		task = new Task(recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId());        
		Map<String, String> params = ApexPages.currentPage().getParameters();        
		String strObjIds = params.get('objIds');        
		arrObjIds = strObjIds.split(',');                  
	}            
		
	public void assignToOwnerClick(){        
		if(task.OwnerId==null){            
			Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'New Owner Cannot be null.'));            
			return;        
		}                
		List<Id> relatedSSIIds = new List<Id>();
		//ADD START Shuang Li US-SMART_SSI-007
		List<Id> relatedSmartSSIIds = new List<Id>();
		//ADD END Shuang Li US-SMART_SSI-007
		List<Task> tasks = [Select Id, OwnerId, WhatId From Task Where Id=:arrObjIds];        
		for(Task t : tasks){            
			t.OwnerId = task.OwnerId;    
			if(t.WhatId!=null && t.WhatId.getSObjectType()==SSI__c.getSObjectType()){
				relatedSSIIds.add(t.WhatId);
		    //ADD START Shuang Li US-SMART_SSI-007
			}else if(t.WhatId!=null && t.WhatId.getSObjectType()==smart_SSI__c.getSObjectType()){
				relatedSmartSSIIds.add(t.WhatId);
			}    
			//ADD END Shuang Li US-SMART_SSI-007
		}                
		if(tasks.size()>0){                        
			update tasks;     
			if(relatedSSIIds.size()>0){
				updateRelatedSSIs(relatedSSIIds, task.OwnerId);
			}          
			//ADD START Shuang Li US-SMART_SSI-007
			if(relatedSmartSSIIds.size()>0){
				updateRelatedSmartSSIs(relatedSmartSSIIds, task.OwnerId);
			}          
			//ADD END Shuang Li US-SMART_SSI-007
		}    
	}
	public void updateRelatedSSIs(List<Id> relatedSSIIds, Id ownerId){
		List<SSI__c> ssis = [Select Id, OwnerId From SSI__c Where Id in :relatedSSIIds];
		for(SSI__c ssi : ssis){
			ssi.OwnerId = ownerId;
		}
		update ssis;

		List<Survey_Result__c> srs = [
			Select Id, OwnerId 
			From Survey_Result__c 
			Where CreatedDate >= LAST_N_MONTHS:6 And SSI_Record__c In :relatedSSIIds And QC_Approved__c != true And TaskId__c In :arrObjIds];
		for (Survey_Result__c sr : srs) {
			sr.OwnerId = ownerId;
		}

		update srs;
	}
    //ADD START Shuang Li US-SMART_SSI-007
	public void updateRelatedSmartSSIs(List<Id> relatedSmartSSIIds, Id ownerId){
		List<smart_SSI__c> ssis = [Select Id, OwnerId From smart_SSI__c Where Id in :relatedSmartSSIIds];
		for(smart_SSI__c ssi : ssis){
			ssi.OwnerId = ownerId;
		}
		update ssis;

		List<Survey_Result__c> srs = [
			Select Id, OwnerId 
			From Survey_Result__c 
			Where CreatedDate >= LAST_N_MONTHS:6 And smart_SSI_Record__c In :relatedSmartSSIIds And QC_Approved__c != true And TaskId__c In :arrObjIds];
		for (Survey_Result__c sr : srs) {
			sr.OwnerId = ownerId;
		}
		update srs;
	}
	//ADD END Shuang Li US-SMART_SSI-007
}