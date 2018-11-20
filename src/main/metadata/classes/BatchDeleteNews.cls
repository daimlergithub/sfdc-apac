/**
Type:       Batch class for News deletion    
Purpose:    1. To delete records that are Draft selected for inactivated users

User Story: RCP-26
Used By:    
---------------------------------------------------------------
History:

14-August-2018 Surendranath  Created
*/
global class BatchDeleteNews implements 
Database.Batchable<sObject>, Database.Stateful {    
    //Variable Section
    global List<Id> lstId;
    String sql;
    //Batch Start method    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(lstId != null && lstId.size() > 0){            
            sql = 'select ID,NAME from News__c Where OwnerId ';
            IF(lstId.size()==1){
                sql+= '=  \''+lstId[0]+'\'';            
            }
            else{          
                Set<Id> setIds = new Set<Id>();            
                setIds.addAll(lstId);            
                Sql+='IN: setIDs';
            }
            sql+=' and Save_As_Draft__c='+true;
        }
        return Database.getQueryLocator(sql);
    }
    //Batch Execute method    
    global void execute(Database.BatchableContext bc, List<News__c> scope){
        // process each batch of records        
        delete scope;
    }
    //Batch Finish method for after execution of batch work    
    global void finish(Database.BatchableContext bc){
        system.debug('The batch Apex Job Processed Successfully '+bc.getJobId());        
    }    
}