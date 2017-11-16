/***********************************************************************************
Created By          :    Venky
Created Date        :    07.11.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this batch is to revoke account link object sharing .
                         Business Conditions :
                          * Account Link Record with Recordtype Retail person/Retail Company.
                          * Retail_Duplicate_Flag_c  is true.
                          * LastUpdatedDate is within X days. => X days should be configurable by custom setting.
                         Action: 
                          * Change Owner to "User Integration" if Owner is not "User Integration". 
                          * Revoke Apex sharing rule if there is any Apex sharing rule is created for account link
JIRA NO             :    SFDCJP-3115                                                

MODIFICATION DETAILS:

1. Modified By      :  
   Modifide Date    :    
************************************************************************************/

global class revokesharingToRetailCopies implements Database.Batchable<SObject>, Database.Stateful, Schedulable 
    {
     
        global static Id ALK_PersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        global static Id ALK_CompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        global List<User> list_User = new List<User>();
        global List<Account> dealerAccList =new List<Account>();
        global List<Group> groupList =new List<Group>();
        global List<Account_Link__Share> list_SharingDele=new List<Account_Link__Share>();
        global List<Account_Link__c> UpdateAlk=new List<Account_Link__c>();
             
         global Database.QueryLocator start(Database.BatchableContext bc) 
        {
             
            List<Revoke_RT_Sharing__c> lstSettng = Revoke_RT_Sharing__c.getAll().Values();
            Integer integerValue1 = lstSettng[0].Enter_Number_of_Days__c.intValue();
             Date today = Date.today().addDays(-integerValue1);
            System.debug('^&^&^&^&^&&^&^'+today);
            return Database.getQueryLocator([Select Id,Name,fromRole__c,toRole__c,Retail_Duplicate_Flag__c,RecordTypeId,Createddate,LastmodifiedDate from Account_Link__c where Retail_Duplicate_Flag__c=true and  LastmodifiedDate>=:today and (RecordTypeId=:ALK_PersonRecordTypeId or RecordtypeId=:ALK_CompanyRecordTypeId)]);
         
        }
        
         global void execute(Database.BatchableContext bc, List<Account_Link__c> scope) 
        {
             set<id> deletedAlkId = new set<id>();
             set<id> DealerAccId = new set<id>();
            if(Scope !=null)
            {
                    for(Account_Link__c acct : scope)
                {
                    if((acct.RecordTypeId == ALK_PersonRecordTypeId || acct.RecordTypeId == ALK_CompanyRecordTypeId) && (acct.Retail_Duplicate_Flag__c=true))
                                                                                                                         
                    {
                        if(acct.fromRole__c !=null)
                        {
                        DealerAccId.add(acct.fromRole__c);
                        deletedAlkId.add(acct.Id);
                        }
                    }
                    
                }
          }
           /* if(DealerAccId !=null)
            {
              list_User= [SELECT Id, AccountId FROM User WHERE AccountId IN:DealerAccId AND IsPortalEnabled = true];
               dealerAccList = [select Name from Account where Id IN: DealerAccId];
            }
             
            Set<String> dealerAccNameSet = new Set<String>();
            if(dealerAccList !=null)
            {
                   for(Account dealerRec : dealerAccList) 
                    {
                        dealerAccNameSet.add(dealerRec.Name);
                    }
            }
         
            system.debug('dealerAccNameSet>>>' + dealerAccNameSet);
            if(dealerAccNameSet!=null)
            {
                 groupList = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
            } */
            
            if(deletedAlkId !=null)
            {
           list_SharingDele = [SELECT Id FROM Account_Link__Share WHERE ParentId IN:deletedAlkId and RowCause = 'Manual'];
               
            }
              System.debug('^&^&^&^&^&^& list_SharingDele'+list_SharingDele);
              
            if(list_SharingDele.size() > 0)
            {
                Database.delete(list_SharingDele, false);
                User IntegrationUser=new User();
                IntegrationUser=[Select id,firstName,LastName,Profile.Name from User Where profile.Name='IntegrationAPI' and firstName='Integration' and LastName='User' limit 1];
                System.debug('^&^&^&^&^&^& IntegrationUser'+IntegrationUser);
                for(Account_Link__c alk : scope)
                {
                    if(alk.OwnerId !=IntegrationUser.id)
                    {
                        alk.OwnerId=IntegrationUser.id;
                        UpdateAlk.add(alk);
                        
                    }
                     System.debug('^&^&^&^&^&^& UpdateAlk'+UpdateAlk);
                }
            }
              System.debug('^&^&^&^&^&^& UpdateAlk'+UpdateAlk );
            if(UpdateAlk !=null)
            {
                Database.update(UpdateAlk,false);
            }
        }
        
        global void finish(Database.BatchableContext bc) 
        {
               
    
        }
      
       
       global void execute(SchedulableContext ctx) 
       {
                    revokesharingToRetailCopies batchSch = New revokesharingToRetailCopies();
                    Database.executeBatch(new revokesharingToRetailCopies());
        }
        
    }
	
	