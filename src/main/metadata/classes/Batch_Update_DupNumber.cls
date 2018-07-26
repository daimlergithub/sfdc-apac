/***********************************************************************************
Created By          :    venky    
Created Date        :    04.06.2018
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch class is to delete DupNumber and related fields.
Business Conditions :
*  Record Type = Person Account or Company Account.
* Account.DUPNumber__c is Not Null and Last modified date number of days can be set in custom label Dup_Number_Last_Modification.
* Count Account having same DupNumber, If more than two accounts have same dupnumber do nothing.
* If dupnnumber matches with only one Account clear below fields.
DUPNumber__c,Dup_Reason__c,Master_Account_Id__c,Mster_Record__c (Please set to False).
JIRA NO             :    SFDCJP-3398   

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/


global class Batch_Update_DupNumber implements Database.Batchable<sObject> ,Database.stateful{
    
     global static Id AccountPersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     global static Id AccountCompanyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    global Database.QueryLocator start(Database.BatchableContext BC){
        String dupnumber=label.Dup_Number_Last_Modification;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        return Database.getQueryLocator([Select id,Md__c,Dup_Reason__c,RecordTypeId,DUPNumber__c,Master_Account_Id__c,Master_Record__c from Account where Lastmodifieddate >=:lastmodifedDupNum and Md__c='JP' and DUPNumber__c!=null and (RecordtypeID=:AccountPersonRecordTypeId OR REcordTypeId=:AccountCompanyRecordTypeId)]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Set<String> Accdupnumber=new set<String>();
        List<Account> DuplicateAcc=new List<Account>();
        Map<Id,Account> updateAcc=new Map<Id,Account>();
          
        for(Account acc:Scope)
        {
            if((acc.RecordTypeId == AccountPersonRecordTypeId || acc.RecordTypeId == AccountCompanyRecordTypeId) && (acc.MD__c=='JP') && (acc.DUPNumber__c!=null))
            {
                Accdupnumber.add(acc.DUPNumber__c);
            }
            
        }
        if(Accdupnumber !=null)
        {
          DuplicateAcc=[Select id,Md__c,Dup_Reason__c,DUPNumber__c,RecordTypeId,Master_Account_Id__c,Master_Record__c from Account where  DUPNumber__c=:Accdupnumber and Md__c='JP' and ((RecordtypeID=:AccountPersonRecordTypeId) OR (REcordTypeId=:AccountCompanyRecordTypeId))];
          
        }
        
        if(DuplicateAcc.size()==1)
        {
            for(Account dupAcc:DuplicateAcc)
            {
                dupAcc.DUPNumber__c='';
                dupAcc.Dup_Reason__c='';
                dupAcc.Master_Account_Id__c='';
                dupAcc.Master_Record__c=false;
                updateAcc.put(dupAcc.id,dupAcc);
            }
        }
        
        try{
            if(updateAcc !=null)
            {
                Database.update(updateAcc.values(),false);
            }
        }Catch(Exception E)
        {
            
        }
    }
     global void finish(Database.BatchableContext BC){
     }
    

}