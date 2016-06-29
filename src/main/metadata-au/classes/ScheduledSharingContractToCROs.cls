/*
        Type:       Utility for Contract
        Purpose:    For creation Task and sharing the task to CROs 
        User Story: CR-000185
        Used By:    
        ---------------------------------------------------------------
        History:
            1. Barney Lai Created on 2014-02-25
    */
    
    global class ScheduledSharingContractToCROs implements Database.batchable<sObject>,Schedulable{
    
        private static final Id AnnualCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Annual Call').getRecordTypeId();
        private static final Id EOCCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('EOC Call').getRecordTypeId();
        private static final Id WelcomeCallRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId();
        private static final Id personAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String contractStatus = '(\'Current\',\'Default-Collection Officer\',\'Default-External Agent\',\'Overdue\')';
        
            List<Retail_Task__c> Welcontracts = new List<Retail_Task__c>();
            List<Retail_Task__c> Ann1contracts = new List<Retail_Task__c>();
            List<Retail_Task__c> Ann2contracts = new List<Retail_Task__c>();
            List<Retail_Task__c> Ann3contracts = new List<Retail_Task__c>();
            List<Retail_Task__c> EOC1contracts = new List<Retail_Task__c>();
            List<Retail_Task__c> EOC2contracts = new List<Retail_Task__c>();
            List<Retail_Task__c> EOC3contracts = new List<Retail_Task__c>(); 
            
        
        public void execute(SchedulableContext ctx) {
            ScheduledSharingContractToCROs ScheduledBatch = new ScheduledSharingContractToCROs();
            ID batchprocessid = Database.executeBatch(ScheduledBatch); 
        }
    
        global Database.querylocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(
                'select id, StartDate__c,EndDate__c, Account__c, Welcome_Call__c, Annual_Call__c, EOC_Call__c, '+
                'Welcome_Call_Task__c, Annual_Call_Task_1_del__c, Annual_Call_Task_2_del__c, Annual_Call_Task_3_del__c,'+
                'EOC_Call_Task_1_del__c, EOC_Call_Task_2_del__c, EOC_Call_Task_3_del__c from Retail_Task__c '+ 
                         'where GFV__c = true and Status__c in'+contractStatus+'');
        }
        
        global void execute(Database.BatchableContext BC, List<Retail_Task__c> contracts){     
           
            
            List<Task> preTask = new List<Task>();
            List<Retail_Task__c> preContract = new List<Retail_Task__c>();
            List<Id> accountIds = new List<Id>();
            List<Task> listTask= new List<Task>();
            Map<Id, Id> accountIdContactId = new Map<Id, Id>();
            Map<Id, List<String>> accountIdPhone = new Map<Id, List<String>>(); 
            Map<ID,set<String>> firstendoftask=new Map<ID,set<String>>();      
            listTask=[select id,subject,whatid,whoid from  task where what.type='Retail_Task__c' and (recordtypeid=:EOCCallRT OR recordtypeid=:AnnualCallRT)];
              
              if(listTask.size() > 0)
            for(Task taskObj :listTask){
                
                if(!firstendoftask.containsKey(taskObj.whatId)){
                    firstendoftask.put(taskObj.whatId,new Set<String>());
                }
                    firstendoftask.get(taskObj.whatId).add(taskObj.subject);
            }
            System.debug('@@@@@  firstendoftask'+firstendoftask);
            
            if(contracts.size() > 0)
            {
              for(Retail_Task__c con : contracts) {
                  Date today = Date.today();
                  Date startday = con.StartDate__c;
                  Date endday = con.EndDate__c;
                  
                  accountIds.add(con.Account__c);
                  accountIdContactId.put(con.Account__c, null);
                  List<String> phone = new List<String>();
                  phone.add('');
                  phone.add('');
                  phone.add('');
                  accountIdPhone.put(con.Account__c, phone);
                  boolean flag = false;
                       
                  if(con.Welcome_Call__c == true && con.Welcome_Call_Task__c == true) {
                        system.debug('Welcome_Call_Task__c'+con.Welcome_Call_Task__c);
                      Welcontracts.add(con);
                      con.Welcome_Call_Task__c = false;
                      flag = true;
                  }
                  if(con.Annual_Call__c == true && con.Annual_Call_Task_1_del__c == true) {
                         system.debug('Annual_Call_Task_1_del__c'+con.Annual_Call_Task_1_del__c);
                      Ann1contracts.add(con);
                      con.Annual_Call_Task_1_del__c = false;
                      flag = true;
                  }
                  if(con.Annual_Call__c == true && con.Annual_Call_Task_2_del__c == true) {
                      Ann2contracts.add(con);
                      con.Annual_Call_Task_2_del__c = false;
                      flag = true;
                  }
                  if(con.Annual_Call__c == true && con.Annual_Call_Task_3_del__c == true){
                      Ann3contracts.add(con);
                      con.Annual_Call_Task_3_del__c = false;
                      flag = true;
                  }
                  if(con.EOC_Call__c == true && con.EOC_Call_Task_1_del__c == true) {
                      EOC1contracts.add(con);
                      con.EOC_Call_Task_1_del__c = false;
                      flag = true;
                  }
                  if(con.EOC_Call__c == true && con.EOC_Call_Task_2_del__c == true) {
                      EOC2contracts.add(con);
                      con.EOC_Call_Task_2_del__c = false;
                      flag = true;
                  }
                  if(con.EOC_Call__c == true && con.EOC_Call_Task_3_del__c == true) {
                      EOC3contracts.add(con);
                      con.EOC_Call_Task_3_del__c = false;
                      flag = true;
                  }
                  if(flag == true) {
                      preContract.add(con);
                  }
              }
          }
            for(Account acc : [select id, PersonContactId, Individual_Home_Phone__c, Work_Phone__c, Mobile__c from Account where Id in :accountIds and RecordTypeId = :personAccountRT]) {
                accountIdContactId.put(acc.id, acc.PersonContactId);
                List<String> phone = new List<String>();
                phone.add(acc.Individual_Home_Phone__c);
                phone.add(acc.Work_Phone__c);
                phone.add(acc.Mobile__c);
                accountIdPhone.put(acc.id, phone);
                
            }
             
                  
              //Welcome Call
              if(Welcontracts.size() > 0)
              {                
                for(Retail_Task__c con : Welcontracts) {
                    Id contactid = null;
                    if(accountIdContactId.get(con.Account__c) != null)
                    contactid = accountIdContactId.get(con.Account__c);
                    List<String> phone = new List<String>();
                    if(accountIdPhone.get(con.Account__c) != null)
                    phone = accountIdPhone.get(con.Account__c);  
                        Task t = createTask(con,'Welcome Call', contactid, phone, WelcomeCallRT);                        
                        preTask.add(t);
                        system.debug('tesks'+preTask);
                       
                }
              }
                
               
                
          
            //Annual Call
           
            if(Ann1contracts.size() > 0)
            {
              for(Retail_Task__c con : Ann1contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);
                  if(!firstendoftask.isEmpty() && firstendoftask != null)
                  {
                        if(firstendoftask.get(con.id).contains('First Year Annual Call'))
                      {
                      }
                      else
                      {
                      Task t = createTask(con,'First Year Annual Call', contactid, phone, AnnualCallRT);
                        preTask.add(t);
                      }
                        system.debug('tesks2'+preTask);
                      
                  }
              }
            }
            if(Ann2contracts.size() > 0)
            {
              for(Retail_Task__c con : Ann2contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);                              
              if(!firstendoftask.isEmpty() && firstendoftask != null)
              {
                  if(firstendoftask.get(con.id).contains('Second Year Annual Call'))
                  {
                  }
                  else
                  {
                  Task t = createTask(con,  'Second Year Annual Call', contactid, phone, AnnualCallRT);
                  preTask.add(t); 
                  }
              }
            }
            }
            if(Ann3contracts.size() > 0)
            {
              for(Retail_Task__c con : Ann3contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);              
                if(!firstendoftask.isEmpty() && firstendoftask != null)
                {     
                  if(firstendoftask.get(con.id).contains('Third Year Annual Call') )
                  {
                  }
                  else
                  {
                   Task t = createTask(con,  'Third Year Annual Call', contactid, phone, AnnualCallRT);
                  preTask.add(t);  
                  }          
                  
              }
            }
            }
            //EOC Call
           
            if(EOC1contracts.size() > 0)
            {
              for(Retail_Task__c con : EOC1contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);
                  if(!firstendoftask.isEmpty() && firstendoftask != null)
                  {
                  if(firstendoftask.get(con.id).contains('First End of Contract Call')  && !firstendoftask.isEmpty())
                  { 
                  
                  }
                  else
                  {              
                  Task t = createTask(con,  'First End of Contract Call', contactid, phone, EOCCallRT);
                  preTask.add(t);
                  }
                 } 
              }
            }
            if(EOC2contracts.size() > 0)
            {
              for(Retail_Task__c con : EOC2contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);
                  if(!firstendoftask.isEmpty() && firstendoftask != null)
                  {
                  if(firstendoftask.get(con.id).contains('Second End of Contract Call')  && !firstendoftask.isEmpty())
                  {
                  
                  }
                  else
                  {
                  Task t = createTask(con,  'Second End of Contract Call', contactid, phone, EOCCallRT);
                  preTask.add(t);
                  }
                }
              }
            }
            if(EOC3contracts.size() > 0)
            {
              for(Retail_Task__c con : EOC3contracts) {
                  Id contactid = null;
                  if(accountIdContactId.get(con.Account__c) != null)
                  contactid = accountIdContactId.get(con.Account__c);
                  List<String> phone = new List<String>();
                  if(accountIdPhone.get(con.Account__c) != null)
                  phone = accountIdPhone.get(con.Account__c);
                  if(!firstendoftask.isEmpty() && firstendoftask != null)
                  {
                  if(firstendoftask.get(con.id).contains('Final End of Contract Call') && !firstendoftask.isEmpty())
                  {
                  }
                  else
                  {              
                  Task t = createTask(con,  'Final End of Contract Call', contactid, phone, EOCCallRT);
                  preTask.add(t);              
                  }
                  }    
                  
              }
            }     
            
            try {
                    if(preTask.size() > 0) {
                        insert preTask;                
                    }
                    assignOwner();
                    if(preContract.size() > 0) {
                        update preContract;
                    }
              }catch (Exception ex) {
                system.debug('Insert Update Error:' + ex.getMessage());
              }
            
        }
        
        public Task createTask(Retail_Task__c con,  String str, Id conId, List<String> phone, Id RTId) {
            Task task = new Task();
            task.subject = str;
            task.whatId = con.id;
            task.Reason__c = 'Initial Attempt';
            task.Status = 'Not Started';
            task.ActivityDate = Date.today();
            task.whoId = conId;
            task.Priority = 'Normal';
            task.Description = '';
            task.PersonHomePhone__c= phone[0];
            task.OfficePhone__c= phone[1];
            task.HomeMobilePhone__c= phone[2];
            task.RecordTypeId = RTId;
            if(str == 'First End of Contract Call' || str == 'Second End of Contract Call' || str == 'Final End of Contract Call') {
                task.Activity_Date__c= con.EndDate__c;
            } else {
                task.Activity_Date__c= con.StartDate__c;
            }
            return task;
        } 
        public void assignOwner(){
           
             List<User> customerServiceUserList = new List<User>();
             List<Task> tasks = new List<Task>();
             List<User> customerRetentionUserList = new List<User>();
             List<User> remarketingTeamUserList = new List<User>();
             set<id> recordTypeIdSet = new set<id>{WelcomeCallRT,AnnualCallRT,EOCCallRT};
                 
             customerRetentionUserList = [select id, name from User where Active_Permission_Set__c= true and profile.name = 'Customer Retention' and UserRole.name like '%Customer Retention Office%' and IsActive=true];
             customerServiceUserList = [select id, name from User where Active_Permission_Set__c= true and UserRole.name like '%Customer Service Team%' and IsActive=true];
             remarketingTeamUserList = [select id, name from User where UserRole.name = 'Remarketing Team Lead' and IsActive=true];
            
             System.debug('!!!! RTLusers '+remarketingTeamUserList);
             System.debug('!!!! crusers '+customerRetentionUserList );
             System.debug('!!!! csusers '+customerServiceUserList ); 
            
             tasks = [select id,RecordTypeId, ownerId,PersonHomePhone__c,OfficePhone__c,HomeMobilePhone__c from Task where  status =: 'Not Started' and RecordTypeId IN:recordTypeIdSet];
             system.debug('assign task'+tasks);   
    
            
              
            if(tasks.size() > 0)
            {
              Integer i = 0; 
              for(Task t : tasks) {
                if(customerServiceUserList != null && customerServiceUserList.size() > 0 ) {                
                    if(t.RecordTypeId==WelcomeCallRT){
                        system.debug('WelcomeCallRT'+WelcomeCallRT);
                        t.ownerId = customerServiceUserList[i].id;
                        i++;
                        if(i >= customerServiceUserList.size()) {
                            i = 0;
                        }
                      } 
                  }
              }
         
            
             i = 0;        
            for(Task t : tasks) {
              if(t.RecordTypeId==AnnualCallRT || t.RecordTypeId==EOCCallRT){
                if(customerRetentionUserList != null && customerRetentionUserList.size() > 0) {
    
                        t.ownerId = customerRetentionUserList[i].id;
                        i++;
                        if(i >= customerRetentionUserList.size()) {
                            i = 0;
                        }
                 
               }
                else if(remarketingTeamUserList != null && remarketingTeamUserList.size() > 0  && t.PersonHomePhone__c == null && t.OfficePhone__c == null && t.HomeMobilePhone__c == null){
                    
                        t.ownerId = remarketingTeamUserList[i].id;
                        i++;
                        if(i >= remarketingTeamUserList.size()) {
                            i = 0;
                        }
                    }                
                  }
               }
            }
            if(tasks.size() > 0) {
                UserUpdate(tasks);
                system.debug('UserUpdate'+tasks);
            }
                
            
        }
        
        public void UserUpdate(List<Sobject> obj){
                    try {
                        update obj;
                    } catch (Exception ex) {
                        system.debug('Error message:'+ex.getmessage());
                    }
        }
    
    
    global void finish(Database.BatchableContext bc){
        }   
    }