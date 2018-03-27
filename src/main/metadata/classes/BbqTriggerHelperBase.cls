/************************************************************************************
* Created By:Sarath Kumar M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description: 
1)Task creation: Create task to the call center supervisior after the referral is created.
2) Point calculation: Update the referralCreated and referralWon fields after the record is inserted or updated.		
*********************************************************************************************/
public class BbqTriggerHelperBase {    
    public static void taskCreation(list<referral__c> refNew){     
        BbqTaskData__c bbqTask = BbqTaskData__c.getValues('CreateTask');
        Integer activityDays=integer.valueOf(bbqTask.taskActivityDate__c);
        String recordType=bbqTask.taskRecordType__c;        
        Integer reminderDays=integer.valueOf(bbqTask.taskReminderDate__c);
   		Id TaskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        Map<string, BbqCreateTask__c> bbqCT = BbqCreateTask__c.getAll();  
        List<Task> taskList = new List<Task>();
        For (referral__c ref:refNew){
           if (ref.Status__c == 'Submitted'){               
                //BbqCreateTask__c bbqCT = BbqCreateTask__c.getValues(ref.Market__c);			//get out of loopp	      
               
               Task tsk =new Task();    
                tsk.RecordTypeId     = TaskRecTypeId;
                tsk.WhatId           = ref.Id; 
                if (bbqCT!=null && ref.Market__c!=null && bbqCT.get(ref.Market__c) != null){
                    tsk.ownerId			 = bbqCT.get(ref.Market__c).user__c;   
                }
                tsk.ActivityDate     = System.today().addDays(activityDays); 
                tsk.Status           = 'Open';
                tsk.Priority         = 'General';
                tsk.Subject          = 'New Prospect Referral';                                     
                tsk.Description      = 'Please follow up with this new Prospect';                    
                tsk.IsReminderSet    = true;
                tsk.ReminderDateTime = System.today().addDays(reminderDays);
                if (bbqCT.get(ref.Market__c) != null)
                	taskList.add(tsk);               
            }
        }
        if (!taskList.isEmpty()){
            Database.insert(taskList, false);
        }        
    }
    
    public static void pointCalculation(list<referral__c> refferalList,Map<id, referral__c> refNewMap, Map<id, referral__c> refOldMap){   

        list<Employee__c> employeeList=[SELECT Id,ReferralsCreated__c,ReferralsWon__c,Email__c FROM Employee__c];
        system.debug('<<<empList'+employeeList);
        list<Employee__c> empList=new list<Employee__c>();
        for(referral__c ref:refferalList){
            for(Employee__c emp: employeeList){
                if(ref.ReferredEmployee__c == emp.id){
					if(trigger.Isinsert){
                        emp.ReferralsCreated__c=emp.ReferralsCreated__c+1;
                    }
                    if(ref.Status__c=='Won' && (refOldMap.get(ref.id).status__c != refNewMap.get(ref.id).status__c)){
                        emp.ReferralsWon__c=emp.ReferralsWon__c+1;                        
                    }
                	empList.add(emp); 
                }	
            }            
        }
        if(empList.size()>0){
            try{
                update empList;
            }
            catch(Exception e){                
                system.debug('<<<Exception e--->'+e);
                CustomLogUtil.DebugException(e);
            }
        }       
    }
}