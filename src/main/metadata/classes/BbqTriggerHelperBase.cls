/************************************************************************************
* Created By:Sarath Kumar M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description: 
1)Task creation: Create task to the call center supervisior after the referral is created.
2) Point calculation: Update the referralCreated and referralWon fields after the record is inserted or updated.
3) autoPopulateDealerEmailAddress: To update the dealerEmail address based on the market and dealer name.
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
                //BbqCreateTask__c bbqCT = BbqCreateTask__c.getValues(ref.Market__c);//get out of loopp	      
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
    public static void autoPopulateDealerEmailAddress(list<referral__c> referralList){        
        Map<string, BbqDealerData__c> bbqDD = BbqDealerData__c.getAll();
        list<referral__c> refList=new list<referral__c>();
        for(referral__c ref:referralList){
            if(ref.Dealer__c!=null){
                string dealer=ref.Dealer__c.toUpperCase();
                string dealerSeq=ref.Market__c+'-'+dealer;
                if(bbqDD.get(dealerSeq)!=null){
                    ref.Dealer_Email_address__c=bbqDD.get(dealerSeq).Dealer_Email__c;
                }
            }
            refList.add(ref);
        }
    }
    public static void pointCalculation(list<referral__c> refferalList,Map<id, referral__c> refNewMap, Map<id, referral__c> refOldMap){  
        //loop and get the employees to be updated
        Set<Id> empRefList = new Set<Id>();
        for (Referral__c refl:refferalList){
            if(refl.ReferredEmployee__c != null){
                empRefList.add(refl.ReferredEmployee__c);
            }
        }
        if (empRefList == null || empRefList.size() == 0) {
            return;
        }
        list<Employee__c> employeeList=[SELECT Id,ReferralsCreated__c,market__c,ReferralsWon__c,Email__c FROM Employee__c where Id in : empRefList];
        list<Employee__c> empList=new list<Employee__c>();
        for(referral__c ref:refferalList){
            for(Employee__c emp: employeeList){
                if(ref.ReferredEmployee__c == emp.id){
                    //Modified Here  for Referral Created__c :: For counting JP and SG referrals Count
                    if(trigger.Isinsert){
                        if(emp.Market__c=='SG'){
                            emp.ReferralsCreated__c=emp.ReferralsCreated__c+1;
                        }
                    }else if(trigger.isupdate) { 
                        if(emp.market__c=='JP' && ref.Lead__c!=null && refOldMap.get(ref.id)!=null && (refOldMap.get(ref.id).Lead__c == null)){
                            emp.ReferralsCreated__c=emp.ReferralsCreated__c+1;
                            
                        }else if(emp.market__c=='JP' && ref.Lead__c == null && refOldMap.get(ref.id)!= null && (refOldMap.get(ref.id).Lead__c != null)){
                            emp.ReferralsCreated__c=emp.ReferralsCreated__c-1;
                        } 
                        if(ref.Status__c=='Won' && (refOldMap.get(ref.id).status__c != refNewMap.get(ref.id).status__c)){
                            emp.ReferralsWon__c=emp.ReferralsWon__c+1;
                        }
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