public class UtilTaskTH{
public static String  OBCAllTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','OB Task');
public static String  DMTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','DM');
public static String  SMSTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','SMS');
public static String  eDMTaskRecordTypeId = RecordTypeAccessService.getRecordTypeId('Task','eDM');
public static void updateCampaignMemberStatus(List<task> tlst){
    List<task> tasklst=[select id,recordtypeid,Activity_Status__c,whatid,whoid from task where id IN:tlst and (recordtypeid=:SMSTaskRecordTypeId OR recordtypeid=:eDMTaskRecordTypeId OR recordtypeid=:OBCAllTaskRecordTypeId OR recordtypeid=:DMTaskRecordTypeId) and Whoid!=null and Activity_Status__c!=null];
    Map<Id,id> taskwithaccount=new map<Id,id>();
    List<Task> taskstoiterate=new List<Task>();
    for(Task tsk:tasklst){
        if(tsk.WhatId!=null?String.valueOf( tsk.WhatId ).startsWith('701'):false&&tsk.whoid!=null?String.valueOf( tsk.whoid).startsWith('003'):false){
            taskwithaccount.put(tsk.id,tsk.Whoid);
            taskstoiterate.add(tsk);
        }
    
    }
    List<CampaignMember> campmember=[Select id,contactid,campaignid,MBTH_Status__c from Campaignmember where contact.id IN: taskwithaccount.values()];
    set<CampaignMember>campmembertoupdate=new set<CampaignMember>();
    for(Task tk:taskstoiterate){
    
    for(CampaignMember cM:campmember){
        if(tk.whoid==cm.contactid && tk.Whatid==cm.campaignId ){
            if(tk.recordtypeid==OBCAllTaskRecordTypeId){
                if(tk.Activity_Status__c=='not started'){
                    cm.MBTH_Status__c='Open';
                }else if(tk.Activity_Status__c=='no answer'||tk.Activity_Status__c=='wrong number'||tk.Activity_Status__c=='no such person'||tk.Activity_Status__c=='invalid data'||tk.Activity_Status__c=='invalid call'){
                cm.MBTH_Status__c='FAILED/NO RESPONSE';
                system.debug('inside faile');
                }else if(tk.Activity_Status__c=='need call back'||tk.Activity_Status__c=='busy'||tk.Activity_Status__c=='reservation'){
                cm.MBTH_Status__c='Sent';
                }else if(tk.Activity_Status__c=='Successful'){
                cm.MBTH_Status__c='RESPONDED';                
                }else if(tk.Activity_Status__c=='reject'){
                cm.MBTH_Status__c='DECLINE';
                
                }

            }
            else if(tk.recordtypeid==DMTaskRecordTypeId){
                if(tk.Activity_Status__c=='Open'){
                cm.MBTH_Status__c='Open';
                
                }else if(tk.Activity_Status__c=='Sent'){
                cm.MBTH_Status__c='Sent';
                
                }else if(tk.Activity_Status__c=='Returned'||tk.Activity_Status__c=='Failed'){
                cm.MBTH_Status__c='FAILED/NO RESPONSE';
                
                }
            
            }
          else if(tk.recordtypeid==eDMTaskRecordTypeId){
              if(tk.Activity_Status__c=='Open'){
                cm.MBTH_Status__c='Open';
                
                }else if(tk.Activity_Status__c=='Pending'){
                cm.MBTH_Status__c='Sent';
                }
                else if(tk.Activity_Status__c=='Click'){
                cm.MBTH_Status__c='RESPONDED';
                }
                else if(tk.Activity_Status__c=='Subscribe'){
                cm.MBTH_Status__c='REGISTERED';
                }
                else if(tk.Activity_Status__c=='Unsubscribe'){
                cm.MBTH_Status__c='DECLINE';
                }
                else if(tk.Activity_Status__c=='Hard Bounced'||tk.Activity_Status__c=='Soft Bounced'){
                cm.MBTH_Status__c='FAILED/NO RESPONSE';
                }
          }
          
          else{
          if(tk.Activity_Status__c=='Sent'){
                cm.MBTH_Status__c='Sent';
                
                }else if(tk.Activity_Status__c=='Fail-Technical'||tk.Activity_Status__c=='Fail-Content'||tk.Activity_Status__c=='Fail-Blacklist'){
                cm.MBTH_Status__c='FAILED/NO RESPONSE';
                }
                else if(tk.Activity_Status__c=='Success'){
                cm.MBTH_Status__c='RESPONDED';
                }
          
          }
        campmembertoupdate.add(cM);
        }
    
        }
    }
if(campmembertoupdate.size()>0){
List<CampaignMember> updatelist=new List<CampaignMember>();
updatelist.addAll(campmembertoupdate);
update updatelist;
}
}

}