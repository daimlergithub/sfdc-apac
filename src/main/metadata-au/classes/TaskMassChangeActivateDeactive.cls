/*
    Type:       Controller for TaskMassChangeActivateDeactive Visualforce page 
    Purpose:    Mass reassign tasks 
    User Story: CR-000185
    Used By:    TaskMassChangeActivateDeactive.page
    ---------------------------------------------------------------
    History:
    
    1. Barney lai Created on 2014-02-28
*/
//TODO Active_Inactive_Flag__c commented as part of SFDCAU-57 for now.
public with sharing class TaskMassChangeActivateDeactive {
    public Task task{set;get;}    
    private static final Id AnnualCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Annual Call').getRecordTypeId();
    private static final Id EOCCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('EOC Call').getRecordTypeId();
    private static final Id WelcomeCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
   
    public TaskMassChangeActivateDeactive (){        
        //Initalize the variables             
        task = new Task();                     
    }            
        
    public void Activate(){    
        if(task.ownerId == null){            
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'New Owner Cannot be null.'));            
            return;        
        } 
        List<User> user = [select id, Active_Permission_Set__c from User where id = :task.ownerId];
        user[0].Active_Permission_Set__c = true;
        UserUpdate(user);
    }
    
    public void Deactivate(){    
        if(task.ownerId == null){            
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'New Owner Cannot be null.'));            
            return;        
        }  
        list<User> user = [select id, Active_Permission_Set__c from User where id = :task.ownerId];
        user[0].Active_Permission_Set__c = false;
        UserUpdate(user);
        List<Task> tasks = new List<Task>();
        List<User> csusers = new List<User>();
        List<User> crusers = new List<User>();
        List<User> RTLusers = new List<User>();
		set<id> recordTypeIdSet = new set<id>{WelcomeCallRT,AnnualCallRT,EOCCallRT};
        tasks = [select id, ownerId,RecordTypeId from Task where ownerId = :user[0].id and status =: 'Not Started' and RecordTypeId IN:recordTypeIdSet];
        crusers = [select id, name from User where Active_Permission_Set__c= true and profile.name = 'Customer Retention' and UserRole.name like '%Customer Retention Office%' and IsActive=true];
        csusers = [select id, name from User where Active_Permission_Set__c = true and UserRole.name like '%Customer Service Team%' and IsActive=true];
        RTLusers = [select id, name from User where UserRole.name = 'Remarketing Team Lead' and IsActive=true];
        
        System.debug('!!!! tasks '+tasks);
        System.debug('!!!! users '+crusers );
        System.debug('!!!! users '+csusers );        
        System.debug('!!!! RTLusers '+RTLusers );
        
       if(crusers.size() == 0) {
            crusers = RTLusers;
        }
        
      if(tasks.size() > 0) {
        
        Integer i = 0;  
          for(Task t : tasks) {              
            if(csusers != null && csusers.size() > 0 ) {                
                if(t.RecordTypeId==WelcomeCallRT){
                    system.debug('WelcomeCallRT'+WelcomeCallRT);
                    t.ownerId = csusers[i].id;
                    i++;
                    if(i >= csusers.size()) {
                        i = 0;
                    }
                } 
            }
         }
        
         i = 0;
        for(Task t : tasks) {
            if(crusers != null && crusers.size() > 0 ) {                 
                if(t.RecordTypeId==AnnualCallRT || t.RecordTypeId==EOCCallRT){
                     system.debug('AnnualCallRT'+AnnualCallRT);
                     system.debug('EOCCallRT'+EOCCallRT);
                    t.ownerId = crusers[i].id;
                    i++;
                    if(i >= crusers.size()) {
                        i = 0;
                    }
                } 
            }
         } 
    }        
        
        if(tasks.size() > 0) {
            UserUpdate(tasks);
            system.debug('testing final'+tasks);
        }
    }
    
    public void UserUpdate(List<Sobject> obj){
        try {
            update obj;
        } catch (Exception ex) {
            system.debug('Error message:'+ex.getmessage());
        }
    }
}