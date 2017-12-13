public without sharing class ManageTasks{

private final String campaignId = ApexPages.currentPage().getParameters().get('campid');
private final Id taskId;
private string getObject;
public List<TaskInfo> taskselect {get; set;}
public string statusvalfp{get;set;}
public String oldstatus {get;set;}
public String newstatus{get;set;}
public String usrname{get;set;}
public String usrid{get;set;}
public Boolean dontshow {get;set;}
public Boolean dontshow11 {get;set;}
public Boolean showuser{get;set;}
public list<Task> tsk{get;set;}
List<Contact> MonkContacts = new List<Contact>();
public List<User> UserList{get;set;}
public String userinput{get;set;}

public ManageTasks(ApexPages.StandardController controller) {
//getObject = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
system.debug('campaignId'+campaignId);
dontshow = true;
dontshow11 = false;
showuser=false;
//statusvalfp = 'Open';
if(campaignId != '')
{
  
  String query = 'Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status,Owner.Email';
     
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
   /* Method to Search the User database to fetch the query results */
    public List<User> Usersearch()
    {
        showuser=true;
         UserList = new List<User>();
        if(String.isNotBlank(userinput))
         {
        for(User c : [select Id,Name,Profile.Name,UserRole.Name from User where Market__c='KR' and IsActive = true AND Name like :'%'+userinput+'%'])
        {
            UserList.add(c);
        }
        }else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Input String is Empty'));
        }
     return null;

    }
    /* End of method */
    
    public List<User> getUsers()
    {
        showuser=false;
        return [select ID,Name,Profile.Name,UserRole.Name from User where IsActive = true AND Market__c='KR' ORDER By Name limit 1000];
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
        options.add(new SelectOption(Label.ALL,Label.ALL));
        options.add(new SelectOption(Label.OpenMT,Label.OpenMT));        
        options.add(new SelectOption(Label.CloseMT,Label.CloseMT));
        options.add(new SelectOption(Label.CancelledMT,Label.CancelledMT));
        return options;
    } 
    
    Public Void dropDown(){
    system.debug('oldstatus ======'+oldstatus);
    system.debug(UserInfo.getLanguage());
    if(UserInfo.getLanguage() == 'ko' && (oldstatus !=null || oldstatus != ''))
    {
    system.debug('I am here');
     if(oldstatus == '전체')
     {
      oldstatus = 'ALL';
      dontshow11=false;
     }
     else if(oldstatus == '시작됨')
     {
     
      oldstatus ='Open';
      dontshow11=true;
     }
     else if(oldstatus == '종결됨')
     {
     oldstatus ='Closed';
     dontshow11=false;
     }
     else if(oldstatus == '취소됨')
     {
     oldstatus = 'Cancelled';
     dontshow11=true;
     }
     
    }
    system.debug('oldstatus ======'+oldstatus );
    system.debug('Query==='+ [Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status FROM Task Where WhatId =: campaignId and MD__c= 'KR' and status=: oldstatus limit 10]);
     if(oldstatus !=null || oldstatus != ''){
       
       List<Task> tasklsss = new List<Task>();
        taskselect.clear();
        if(oldstatus == 'Open' || oldstatus == 'Closed'){
        
        tasklsss=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status,Owner.Email FROM Task Where WhatId =: campaignId and MD__c= 'KR' and status=: oldstatus limit 1000];
        }else if(oldstatus == 'Cancelled')
        {
       tasklsss=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.Developername,Owner.name,OwnerId,Status,Owner.Email FROM Task Where WhatId =: campaignId and MD__c= 'KR' and status=: oldstatus limit 1000];
        }
        else
        {
       tasklsss=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.name,Owner.name,OwnerId,Status,Owner.Email FROM Task Where WhatId =: campaignId and MD__c= 'KR' limit 1000];
        }
        system.debug('tasklsss-----'+tasklsss);
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
            options.add(new SelectOption('None','None'));   
            options.add(new SelectOption(Label.CancelledMT,Label.CancelledMT));
            
             dontshow = true;
             dontshow11=false;
        }
        else if(oldstatus == 'Cancelled')
        {   
            options.add(new SelectOption('None','None'));    
            options.add(new SelectOption(Label.OpenMT,Label.OpenMT));
            dontshow = true;
            dontshow11=false;
        }
        else if(oldstatus == 'Closed')
        { 
            dontshow = false;
            dontshow11=true;
            
        }else
        { 
          dontshow = false;
          dontshow11=true;
          //options.add(new SelectOption('Cancelled','Cancelled'));
          //options.add(new SelectOption('Closed','Closed'));
        }    
        return options;
    }       
   
     public PageReference Changestatus() 
    {
     system.debug('taskselect'+taskselect);
     if(usrid!=null)
     {
     system.debug('usrid'+usrid);
     }
      system.debug('taskselect size'+taskselect.size());
    System.debug('Status-----checked  in method' + statusvalfp);
    if(UserInfo.getLanguage() == 'ko' && (newstatus !=null || newstatus != ''))
    {
    system.debug('I am here');
     if(newstatus == '전체')
     {
      newstatus = 'ALL';
     }
     else if(newstatus == '시작됨')
     {
     
      newstatus ='Open';
     }
     else if(oldstatus == '종결됨')
     {
     newstatus ='Closed';
     }
     else if(newstatus == '취소됨')
     {
     newstatus = 'Cancelled';
     }
     
    }
    if(statusvalfp != 'trues')
    {
     List<Task> TaskListtoUpdate = new List<Task>();
    
    
    for(TaskInfo taskRec : taskselect) 
        {
            if(taskRec.isSelected)
            {
             if(newstatus != null && newstatus != '' && newstatus != 'None'){
              taskRec.taskselects.Status = newstatus;
              taskRec.taskselects.Status__c = newstatus;
              }
              if(usrid!=null && usrid!='')
              {
              taskRec.taskselects.Ownerid=usrid;
              }
              TaskListtoUpdate.add(taskRec.taskselects);
            }
             
         
        } 
        
        try{
        update TaskListtoUpdate;
        notifyTaskOwner(TaskListtoUpdate);
        if(!MonkContacts.isEmpty() && MonkContacts != null)
        {
            delete MonkContacts;
        }
        }catch(DMLException e)
        {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getDMLMessage(0)));
        }
        }
        else
        {
         List<Task> oldTaskList;
         List<Task> TaskListtoUpdate1 = new List<Task>();
         
         if(newstatus == 'Open'){
         oldTaskList=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.Developername,RecordType.name,Owner.name,OwnerId,Status,Owner.Email FROM Task Where WhatId =: campaignId and MD__c= 'KR'];
         system.debug('oldTaskList---'+oldTaskList);
          }else{
         oldTaskList=[Select Id,WhoId,Type,Who.name,WhatId,Subject,ActivityDate,RecordType.Developername,RecordType.name,Owner.name,OwnerId,Status,Owner.Email FROM Task Where WhatId =: campaignId and MD__c= 'KR'];
          }
         for(Task ts1: oldTaskList)
         { 
           if(newstatus != null && newstatus != '' && newstatus != 'None'){
           ts1.status = newstatus;
           ts1.Status__c = newstatus;
           }
           if(usrid!=null && usrid!='')
              {
              ts1.Ownerid=usrid;
             
              }
           TaskListtoUpdate1.add(ts1);
         }
         try{

         update TaskListtoUpdate1;
         notifyTaskOwner(TaskListtoUpdate1);
         if(!MonkContacts.isEmpty() && MonkContacts != null)
         {
            delete MonkContacts;
         }
                  }catch(Exception ex){
         ApexPages.addMessages(ex);
         }
         
        }
        
     return null;
    }   
    public void notifyTaskOwner(list<Task> taskList)
    {
        List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
        list<Campaign> campList = [select Id,Campaign_Code__c from Campaign where Id =: campaignId];
        Messaging.SingleEmailMessage sendMail = new Messaging.SingleEmailMessage();
        
        for(Task tsk : taskList)
        {
            Contact MonkContact = MonkCotact(tsk.Owner.Email);
            MonkContacts.add(MonkContact);            
            sendMail.setSubject(tsk.WhatId + ' 관련 작업이 할당되었습니다');
            string emailBody = '안녕하세요, </BR>';
            emailBody =  emailBody + '새로운 Task가 인입되었습니다.</BR>';
            emailBody =  emailBody + '캠페인 이름: ' + tsk.WhatId + '</BR>';
            for(Campaign camp : campList)
            {
                if(tsk.WhatId == camp.Id)
                {
                    emailBody =  emailBody + '캠페인 코드: ' + camp.Campaign_Code__c + '</BR>';
                }
                
            }
            emailBody =  emailBody + '작업 레코드 유형: ' + tsk.RecordType.name + '</BR>';
            emailBody =  emailBody + '인입된 Task 개수: ' + taskList.size() + '</BR>';
            emailBody =  emailBody + '기한: ' + tsk.ActivityDate + '</BR>';
            emailBody =  emailBody + '다음 링크를 통해 해당 Task의 자세한 정보를 확인하실 수 있습니다.</BR>';
            emailBody =  emailBody + 'MBK 사용자: <a href=' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.WhatId + '>' + System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.WhatId + '</a></BR>';
            emailBody =  emailBody + '- MBK 고객 센터 -';
            sendMail.setHtmlBody(emailBody);
            sendMail.setTargetObjectId(MonkContact.Id); 
            sendMail.setSaveAsActivity(false);
            sendEmailList.add(sendMail);
        }
        try
        {   
            if(!sendEmailList.isEmpty() && sendEmailList != null)
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(sendEmailList);
                if (results[0].success) 
                {                
                    System.debug('The Task email notification was sent successfully.');
                } 
            }               
        }       
        catch(Exception e)
        {
            system.debug('Task Email Notification Failure Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
        }
    }
    @TestVisible
    private static Contact MonkCotact(String mailAdd)
    {   
        String monkLastName = 'Contact' + Math.round(Math.random() * (1000 - 1)) + 1;
        while(true)
        {
            list<Contact> contactList = [select id from Contact where lastName=:monkLastName];
            if (contactList.size()<1) 
            {
                Contact monkc = new Contact(lastName=monkLastName,Email=mailAdd);
                insert monkc;
                return monkc;
            }
            monkLastName = 'monkContact' + Math.round(Math.random() * (1000 - 1)) + 1;
        }       
        return null;
    }
}