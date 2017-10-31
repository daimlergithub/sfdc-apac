global class Batch_BounceStatusretail implements Database.Batchable<SObject>, Database.Stateful, Schedulable 
{
        global Database.QueryLocator start(Database.BatchableContext bc) 
        {
            Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
       Date today = Date.Today();
       // String Response = 'Response collection' ;
        
       // String query = 'Select Id,Name,(Select id,Campaign_ID__c From Campaign_Members1__r) from Campaign Where Child_Campaign_Status__c =:Response';
         //system.debug('+++++++ Query'+query);
            return Database.getQueryLocator([Select Id,Name,Execution_Type__c,Execution_Start_Date__c,(Select id,Contact_Id__c,Status__c,Retail_Campaign_Id__c From Campaign_Members__r Where Status__c ='Bounced') from Retail_Campaign__c Where Response_Date__c=:today]);
         
       // return Database.getQueryLocator(query); 
        }
    
    
        global void execute(Database.BatchableContext bc, List<Retail_Campaign__c> scope) 
        {
                     
                String MainString ;
                List<Campaign_Member__c> campgnm = New List<Campaign_Member__c>();
                List<Account> accMainList = New List<Account>(); 
                set<id> camOBcall = new set<id>();
                set<id> cameMail = new set<id>();
                set<id> camDM = new set<id>();
            system.debug('scope'+scope);    
            for(Retail_Campaign__c cam : scope)
                {
                    
                    system.debug('Nullpointer'+cam.Campaign_Members__r);
                   for(Campaign_Member__c camp : cam.Campaign_Members__r){
                    if(camp.Status__c =='Bounced')
                        {                                   
                           if(cam.Execution_Type__c == 'OB Call'){     
                                camOBcall.add(camp.Contact_Id__c);
                           }
                           else if(cam.Execution_Type__c == 'eMail'){     
                                cameMail.add(camp.Contact_Id__c);
                           }
                           else if(cam.Execution_Type__c == 'DM'){     
                                camDM.add(camp.Contact_Id__c);
                           }
                        }
                    system.debug('+++++++++++++ camp'+camp);
                   }
                } 
         
         
         if(camOBcall.size()>0){
         
         List<Account> addList = [Select Id,FirstName,LastName,Email__c,Email_Status__c,Mobile_Status__c,Email_Last_Modified_Date__c,Mobile__c,SMS_Last_Modified_Date__c,(Select id ,Address_Last_Modified_Date__c,Status__c ,Hardcopy_Last_Modified_Date__c From Addresses__r ) From Account Where Id =: camOBcall];
               for(Retail_Campaign__c campCheck : scope)
                {
                For(Account acc : addList )
                {
                   if(acc.SMS_Last_Modified_Date__c < campCheck.Execution_Start_Date__c && campCheck.Execution_Type__c == 'OB Call')
                                            {
                                                acc.Mobile_Status__c = 'Invalid';
                                              accMainList.add(acc);
                                            }else {
                                                String Recordmain= acc.id+','+acc.LastName+'\n';
                                                MainString = MainString +Recordmain ;
                                
                                            }
                                            
                         
                        system.debug('+++++++++++++accMainList'+accMainList);
                        system.debug('+++++++++++++accMainList'+acc.Mobile_Status__c);
                }
         }
         }
         if(cameMail.size()>0){
         
         List<Account> addListTwo = [Select Id,FirstName,LastName, Email__c,Email_Status__c,Mobile_Status__c,Email_Last_Modified_Date__c,Mobile__c,SMS_Last_Modified_Date__c,(Select id ,Address_Last_Modified_Date__c,Status__c ,Hardcopy_Last_Modified_Date__c From Addresses__r ) From Account Where Id =: cameMail];
             for(Retail_Campaign__c campCheck : scope)
                {
                For(Account acc : addListTwo )
                {
                                                            
                                        if(acc.Email_Last_Modified_Date__c == campCheck.Execution_Start_Date__c && campCheck.Execution_Type__c == 'eMail')
                                            {
                                                acc.Email_Status__c = 'Invalid';
                                                accMainList.add(acc);
                
                                            } else {
                                                
                                                String Recordmain= acc.id+','+acc.LastName+'\n';
                                                MainString = MainString +Recordmain ;
                                                     system.debug('++++Working2++++++');
                                            }
                                       
                          }
                          }
                          }
                 if(camDM.size()>0){
             for(Retail_Campaign__c camp : scope)
                {
         List<Account> addListOne = [Select Id,FirstName,LastName,Email__c,Email_Status__c,Mobile_Status__c,Email_Last_Modified_Date__c,Mobile__c,SMS_Last_Modified_Date__c,(Select id ,Address_Last_Modified_Date__c,Status__c ,Hardcopy_Last_Modified_Date__c From Addresses__r ) From Account Where Id =: cameMail];
        
                For(Account acc : addListOne )
                {
                    
                    For(Address__c add : acc.Addresses__r )
                                                           
                                {
                                  if(add.Address_Last_Modified_Date__c  < camp.Execution_Start_Date__c && camp.Execution_Type__c == 'DM' )
                                    
                                    {
                                                add.Status__c = 'Dead Mail';
                                                accMainList.add(acc);
                                    } else {
                                                
                                                String Recordmain= acc.id+','+acc.Name+'\n';
                                                MainString = MainString +Recordmain ;
                                
                                            }
                                }               
                    
                    //accMainList.add(acc);                   
               
                }
                }
                }
                  system.debug('+++++accMainList++++++'+accMainList);
                 if(accMainList.size()>0){ 
                   update accMainList;
                 }      
                       
                       
               
                List<Attachment> Accbnclist = new List<Attachment>();
     
                For(Retail_Campaign__c cam : Scope)
                {
                       system.debug('+++MainString+++++++'+MainString);
                    
                    if(!String.isBlank(MainString))
                    {
                            Attachment attach = new Attachment();
                            attach.Body = Blob.valueOf(MainString);
                            attach.Name = 'test.csv';
                            //attach.ContentType = 'csv';
                            attach.IsPrivate = false;
                            attach.ParentId = cam.Id;
                            //attach.ParentId = 
       
                            Accbnclist.add(attach);
      
                    }
                    }
                    insert Accbnclist;
                }
            
                
                
    
    
        global void finish(Database.BatchableContext bc) 
        {
               
    
        }
      
       
       global void execute(SchedulableContext ctx) 
       {
                    Batch_BounceStatusretail batchSch = New Batch_BounceStatusretail();
                    Database.executeBatch(new Batch_BounceStatusretail());
        }
}