public without sharing class ManageTasks{

private final String campaignId = ApexPages.currentPage().getParameters().get('campid');
private final Id taskId;
private string getObject;
public List<TaskInfo> taskselect {get; set;}
public string statusvalfp{get;set;}
public String oldstatus {get;set;}
public String newstatus{get;set;}
public Boolean dontshow {get;set;}
public Boolean dontshow11 {get;set;}
public list<Task> tsk{get;set;}

public ManageTasks(ApexPages.StandardController controller) {
//getObject = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
system.debug('campaignId'+campaignId);
dontshow = true;
dontshow11 = false;
//statusvalfp = 'Open';
if(campaignId != '')
{
  
  String query = 'Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status';
     
     query += ' FROM Task Where ';
     query +='WhatId =: campaignId and MD__c= \'KR\'  limit 1000 ';
     system.debug('Query'+query);
     
      List<Task> TaskList = Database.query(query);
        taskselect = new List<TaskInfo>();
        system.debug('TaskList'+TaskList);
        for(Task TaskselRec : TaskList) 
        {
            taskselect.add(new TaskInfo(TaskselRec));
        }
      system.debug('taskselectnn'+taskselect);
      system.debug('taskselectnnsize'+taskselect.size());
}

}


public void getstatusval() {
   System.debug('Status-----checked' + statusvalfp);
   }
   
 public class TaskInfo
   {
      public Task taskselects{ get; set; }
      public Boolean isSelected { get; set; }
      public TaskInfo(Task TaskselRec)
     {
        this.taskselects = TaskselRec;
        this.isSelected = false;
     }
   }
    public List<SelectOption> getoldstatuses()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.All,Label.All));
        options.add(new SelectOption('Open','Open'));        
        options.add(new SelectOption('Closed','Closed'));
        options.add(new SelectOption('Cancelled','Cancelled'));
        return options;
    } 
    
    Public Void dropDown(){
    system.debug('oldstatus ======'+oldstatus );
    system.debug('Query==='+ [Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status FROM Task Where WhatId =: campaignId and MD__c= 'KR' and status=: oldstatus limit 10]);
     if(oldstatus !=null || oldstatus != ''){
       List<Task> tasklsss = new List<Task>();
        taskselect.clear();
        if(oldstatus != 'ALL'){
        tasklsss=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status FROM Task Where WhatId =: campaignId and MD__c= 'KR' and status=: oldstatus limit 1000];
        }else
        {
       tasklsss=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status FROM Task Where WhatId =: campaignId and MD__c= 'KR' limit 1000];
        }
        for(Task TaskselRec1 : tasklsss) 
        { 
            taskselect.add(new TaskInfo(TaskselRec1));
        }
        system.debug('taskselect'+taskselect);
        system.debug('taskselect size'+taskselect.size());
        }
    } 
    
    
    
   public List<SelectOption> getChangingstatus()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(oldstatus == 'Open')
        {       
            options.add(new SelectOption('Cancelled','Cancelled'));
             dontshow = true;
        }
        else if(oldstatus == 'Cancelled')
        {       
            options.add(new SelectOption('Open','Open'));
            dontshow = true;
        }
        else if(oldstatus == 'Closed')
        { 
            dontshow = false;
            
            
        }else
        { 
          dontshow = false;
          //options.add(new SelectOption('Cancelled','Cancelled'));
          //options.add(new SelectOption('Closed','Closed'));
        }    
        return options;
    }       
   
     public PageReference Changestatus() 
    {
    System.debug('Status-----checked  in method' + statusvalfp);
    if(statusvalfp != 'trues')
    {
     List<Task> TaskListtoUpdate = new List<Task>();
    
    if(newstatus != null || newstatus != ''){
    for(TaskInfo taskRec : taskselect) 
        {
            if(taskRec.isSelected)
            {
              taskRec.taskselects.Status = newstatus;
              taskRec.taskselects.Status__c = newstatus;
              TaskListtoUpdate.add(taskRec.taskselects);
            }
             
        } 
        } 
        
        try{
        update TaskListtoUpdate;
        }catch(Exception e)
        {
        
        }
        }
        else
        {
         List<Task> oldTaskList;
         List<Task> TaskListtoUpdate1 = new List<Task>();
         oldTaskList=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status FROM Task Where WhatId =: campaignId and MD__c= 'KR'];
         system.debug('oldTaskList---'+oldTaskList);
         for(Task ts1: oldTaskList)
         {
           ts1.status = newstatus;
           ts1.Status__c = newstatus;
           TaskListtoUpdate1.add(ts1);
         }
         try{
         update TaskListtoUpdate1;
         }catch(Exception e){}
        }
        
     return null;
    }   

}