/**
** Utility for Lead trigger for Japan 
** Updation of Ã¢â‚¬Å“Customer_Lifecycle_Phase__cÃ¢â‚¬Â on Account related to lead based on CAC Lead Status
** Initialise Customer_Lifecycle_Phase__c on Account based on CAC Lead Status of all the leads associated with Account based on CAC Lead Status.
** Create AccountLink with combination of From role and to role with contact and Assigned Dealer for newly inserted leads based on CAC Lead Status.
** Created By: Narasimha 
** Date: 2016-1-19
** Modified By : 
** Modified date :
**/

public class LeadHelperJP 
{
    
/**  Updation of Ã¢â‚¬Å“Customer_Lifecycle_Phase__cÃ¢â‚¬Â on Account related to lead based on CAC Lead Status
**  Created By: Narasimha  
**  Date: 2016-1-19
**/
     private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    static boolean isNotificationSendtoAdivisor = false;
    static boolean isNotificationSendtosalesmanager = false;
    public static void updateCustomerStage(list<Lead__C> listNewLeads,map<id,Lead__C> LeadOldMap,map<id,Lead__c> LeadNewMap)
    {
        // Variables Declaration 
        set<id> contactIdsUpd = new set<id>(); 
        set<id> contactIdsIns = new set<id>();
        set<id> DealerIds = new set<id>();
        map<id,id> ContactDealerMap = new map<id,id>();
        map<id,List<id>> AccLeadMap = new map<id,List<id>>();
        List<id> tempLeads = new List<id>();
        list<id> leadIds = new List<id>();
        map<id,Lead__C> leadMap = new Map<id,Lead__C>();
        List<Account> AccountListIns =  new List<Account>();
        List<Account> AccountListUpd =  new List<Account>();
        list<Account> AccountsToBeUpdated = new list<Account>();
        List<Lead__c> Leads = new List<Lead__c>();
        
        
        if(LeadUtil.updateCustomerStageMethod){
        for(Lead__C lead : listNewLeads)
        {
            if(lead.MD__c == 'JP')
            {
                Lead__c oldLead = LeadOldMap.get(lead.id);
                if(oldLead.CAC_Lead_Status__c != lead.CAC_Lead_Status__c && lead.CAC_Lead_Status__c == 'Approved' )
                {
                    system.debug('!!!!!!!!'+ 'in trigger.new loop');
                    if(lead.Contact__c != null){
                        contactIdsUpd.add(lead.Contact__c);         // ids of account(Contact__C) with new lead status "Approved"
                    }
                    if(lead.Assigned_Dealer__c != null){
                        DealerIds.add(lead.Assigned_Dealer__c);     // Ids of Acccount(Assigned_Dealer__c) with new lead status "Approved"
                    }
                    ContactDealerMap.put(lead.contact__C,lead.Assigned_Dealer__c); // Contact Dealer map 
                }
                
                if(oldLead.CAC_Lead_Status__c != lead.CAC_Lead_Status__c && (lead.CAC_Lead_Status__c == 'Purchased(Only Non BDC)' ||
                                                                             lead.CAC_Lead_Status__c == 'Lost(CAC)' || 
                                                                             lead.CAC_Lead_Status__c == 'Not Allocated'))
                {
                    system.debug('!!!!!!!!'+'inside 2nd case loop trigger.new');
                    if(lead.Contact__c != null){
                        contactIdsIns.add(lead.Contact__c);
                    }
                    
                }
            }
        }
        if(contactIdsUpd !=null)
        {
        
        AccountListUpd = [select id,Customer_Lifecycle_Phase__c from Account where id in :contactIdsUpd];        
        
        if(!AccountListUpd.isEmpty())
        {
            system.debug('!!!!!!!!'+ 'inside acctupd loop');
            for(Account acc : AccountListUpd)
            {
                if(acc.Customer_Lifecycle_Phase__c == 'Care')
                {
                    acc.Customer_Lifecycle_Phase__c = 'Sales Lead';
                }
                
            }
            
            update AccountListUpd;
        }
        }
        
        if( contactIdsIns!=null)
        {
        AccountListIns = [select id,Customer_Lifecycle_Phase__c from Account where id in : contactIdsIns];
        
        Leads = [select id,contact__c,CAC_Lead_Status__c from Lead__c where contact__c in : contactIdsIns];
        if(!Leads.isEmpty())
        {
            for(Lead__c lead : Leads)   // getting map of (Acc,List<Leads>) Account and list of leads associated with it.
            {
                LeadMap.put(lead.id,lead);
                tempLeads = AccLeadMap.get(lead.contact__C);
                if (tempLeads == null){
                    AccLeadMap.put(lead.contact__C, new List<Id>{lead.Id});
                }else{
                    tempLeads.add(lead.Id);
                }
                
                
                
            }
        }
        
        }
        if(!AccountListIns.isEmpty())
        {
            for(Account Acc : AccountListIns)
            {
                system.debug('!!!!!!!!'+'inside 2nd case loop AccInsert');
                boolean AccUpdFlag = true ;
                leadIds = AccLeadMap.get(Acc.id);
                if(leadIds != null)
                {
                for(id LeadId : leadIds)
                {
                    system.debug('!!!!!!!!'+'inside 2nd case loop Leads'+ LeadId);
                    Lead__C tempLead = LeadMap.get(LeadId);
                    
                    Lead__c Currentlead = LeadNewMap.get(LeadId);
                    
                    system.debug('!!!!!!!!'+'inside 2nd case loop Leads'+ tempLead.id + 'status:' + tempLead.CAC_Lead_Status__c );
                    
                    
                    if(tempLead.CAC_Lead_Status__c == 'Purchased(Only Non BDC)' || tempLead.CAC_Lead_Status__c == 'Lost(CAC)'  || tempLead.CAC_Lead_Status__c == 'Not Allocated' || (Currentlead != null && Currentlead.id == tempLead.id ) )
                    {
                        
                        continue;
                    }
                    else
                    {
                        AccUpdFlag = false ;
                        break;
                    }
                    
                }
                }
                
                if (AccUpdFlag == true)
                {
                    system.debug('!!!!!!!' + 'acc update in 2nd case true' );
                    Acc.Customer_Lifecycle_Phase__c = 'Care';
                    AccountsToBeUpdated.add(Acc);
                    
                }
                system.debug('!!!!!!!' + 'flag ' +AccUpdFlag);
            }
            
            
            update AccountsToBeUpdated;
        }
        if(!contactIdsUpd.isEmpty()){
            //createAccountLinkFromDealer(listNewLeads,LeadNewMap,contactIdsUpd,DealerIds,ContactDealerMap);
        }
        LeadUtil.updateCustomerStageMethod = false;
        }//
    }
    
     /** Create AccountLink with reocrdtype contact2contact wherever lead is created with contact and company account field is not null
       Created By: Sivaramakrishna Aduri
       Date: 27th Feb, 2017**/
   
    
    public static void createContactToContactAccounlink(list<Lead__C> leadList){
    LeadUtil.iscreated = false;
    if(LeadUtil.createContactToContactAccounlink )
   {
        Id aclConttoContId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
        List<Account_Link__c> accountLinkInsert = new List<Account_Link__C>();
        for(Lead__C curLead : leadList){
            if(curLead.Company_Account__c != NULL && curLead.Contact__c != NULL){
                accountLinkInsert.add(new Account_Link__c(Name = curLead.id,RecordTypeId = aclConttoContId, fromRole__c = curLead.Company_Account__c, toRole__c = curLead.Contact__c,Role__c = 'Company',Role2__c = 'Employee'));
            
            }
        }
        try{
            if(accountLinkInsert != NULL && !accountLinkInsert.isEmpty()){
                insert accountLinkInsert;
                System.debug('^&^&^&^&^&^&^&&^accountLinkInsert'+accountLinkInsert);
            }
        }
        catch(exception e){
            System.debug('Role is Same');
        }
       }
       LeadUtil.createContactToContactAccounlink =false;
    }
    
  /** Create AccountLink with combination of From role and to role with contact and Assigned Dealer for newly inserted leads based on CAC Lead Status.
**  Created By: Narasimha  
**  Date: 2016-1-19
**/  
    
    public static void createAccountLinkFromDealer(list<Lead__C> listNewLeads,map<id,Lead__C> LeadNewMap,set<id> contactIds,set<id> DealerIds,map<id,id> ContactDealerMap)
    {
        
        List<Account_Link__c> AccountLinkList = new list<Account_Link__c>();
        List<Account_Link__c> AccountLinkInsert = new list<Account_Link__c>();
        Id AclRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
        AccountLinkList = [select id,fromRole__c,toRole__c from Account_Link__c where fromRole__c in :contactIds ];
        system.debug('!!!!!!!!!!!' + AccountLinkList);
        system.debug('!!!!!!!!!!!' + ContactDealerMap);
        if(!AccountLinkList.isempty())
        {
            for (Account_Link__c acl : AccountLinkList )
            {
                if (acl.toRole__c == ContactDealerMap.get(acl.fromRole__c) )
                    ContactDealerMap.remove(acl.fromRole__c);
                
            }
            
        }
        set<id> fromRoleIds = ContactDealerMap.keySet();
        for(id fromRole : fromRoleIds)
        {
            AccountLinkInsert.add(new Account_Link__c(RecordTypeId = AclRecordTypeId,Active__c = true,fromRole__c = fromRole,toRole__c = ContactDealerMap.get(fromRole),Role2__c = 'Sales'));
            
        }
        if(!AccountLinkInsert.isEmpty())
        {
            Insert AccountLinkInsert;
        } 
        
    }
    /*
     Once Sales or After-Sales lead is approved (created as approved lead or updated to the approved status):
     Update sharing rule so that Dealer User, who belongs to the company to which the Assigned Dealer outlet of lead, can view/edit that lead. 
     Created by:Surya Varma
     Date:1/12/2016
   */
     public static void handleAfterInsertOrUpdate(list<lead__c> leadlist1,Map<Id,Lead__C> leadOldMap)
    {
    // if(LeadUtil.handleAfterInsert){
     Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     list<lead__c> leadlist = new list<lead__c>();
     list<account> dealerAccountList =new list<account>();
        Map<String,account>accountMap=new Map<String,account>();
       // Map<id,account>aMap=new Map<id,account>();
     set<id>dealerAccountIds = new set<id>();
     set<String> GCCode = new set<String>();
     set<id> leadIds = new set<id>();
     for(Lead__c lead:leadlist1)
        {
          if((lead.RecordTypeId ==salesRecordTypeId )||(lead.RecordTypeId ==afterSalesRecordTypeId))
            {
                if((( Trigger.isinsert  && lead.CAC_Lead_Status__c=='approved') || (Trigger.Isupdate && lead.CAC_Lead_Status__c=='approved'&& lead.CAC_Lead_Status__c!=leadOldMap.get(lead.id).CAC_Lead_Status__c) )&& lead .Assigned_Dealer__c!=null)
                { 
                 leadIds.add(lead.id);
                 
               
                }
            }
        }
     leadlist = [Select id,recordtypeId,Assigned_Dealer__r.name,CAC_Lead_Status__c,Assigned_Dealer__r.Dealer_GC_Code__c,Assigned_Dealer__c from Lead__c where Id IN:leadIds];
        for(lead__c le:leadlist)
        {
            if(le.Assigned_Dealer__c != null){dealerAccountIds.add(le.Assigned_Dealer__c);}
        }
        if(dealerAccountIds.size()>0)
        {
            dealerAccountList = [select id,name,Dealer_Rollout_Status__c from account where ID IN:dealerAccountIds];
        }
        if(dealerAccountList.size()>0)
        {
            for(account a:dealerAccountList)
            {
                if(a.Dealer_Rollout_Status__c != null)
                {
                     accountMap.put(a.name,a);
                   
                }
            }
        }
     list<Lead__share>  leadshare=new list<lead__share>();
    // list<Lead__c> leads=new list<lead__c>();
    Map<id,Lead__c>  leads=new Map<id,Lead__c>();
     list<Lead__c> leadslist=new list<lead__c>();
      list<group>assgroupList=new list<group>();
     map<string,id> assgroupMap = new map<string,id>();
      Map<String,id>agroupmap=new Map<String,id>();
      
       
     list<string>asslist=new list<string>();
     list<String> AccountNAme = new List<String>();
      
      Set<id> leadIdsSet = new Set<id>();
        if(leadlist!=null)
        {
          for(lead__c l:leadlist )
            {
          
                // System.debug('lead.Assigned_Dealer__r.name'+lead.Assigned_Dealer__r.name);
                asslist.add(l.Assigned_Dealer__r.name);
                GCCode.add(l.Assigned_Dealer__r.Dealer_GC_Code__c );
                leadIdsSet.add(l.id);          
          
            }
        
        
        }
        list<account>acl=new list<account>([select id, Name, RecordType.DeveloperName,Dealer_GC_Code__c from Account WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeid=:Dealer_RecordTypeId]);
       for(Account acc : acl){
           system.debug('acc.Name'+acc.Name);
           AccountNAme.add(acc.Name);   
       }
        list<Group>grplist=new list<Group>([select id ,Name ,Type from Group where Name IN:asslist OR Name IN: AccountNAme]);
        for(Group assg:grplist)
        {
               
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);

        }
       
      for(Lead__c lead:leadlist)  
        {
          
                  if(AccountNAme.size()>0)
                 {
                    for(id m:assgroupMap.values()){
                       
                    Lead__share l=new Lead__share();
                    l.ParentId=lead.id;
                    l.UserOrGroupId = m;
                    system.debug('mid'+m);
                    l.AccessLevel='edit';
                    leadshare.add(l);
                    }
                     if(accountMap != null && !accountMap.isEmpty()){
                    if(accountMap.get(lead.Assigned_Dealer__r.name).Dealer_Rollout_Status__c!=null && accountMap.get(lead.Assigned_Dealer__r.name).Dealer_Rollout_Status__c == 'Done')
                     {
                        Lead__c ld=new Lead__c();
                        ld.Id = lead.id;
                        ld.CAC_Lead_Status__c='Allocated';
                        ld.Assigned_Date_Time__c=System.now();
                       // leadslist.add(ld);
                        leads.put(ld.id,ld);
                     
                     }
                     }
                   
                 }
                 
                 else
                 {
                    Lead__share l=new Lead__share();
                    l.ParentId=lead.id;
                    l.UserOrGroupId = assgroupMap.get(lead.Assigned_Dealer__r.Name);
                    l.AccessLevel='edit';
                    leadshare.add(l);
                    if(accountMap != null && !accountMap.isEmpty()){
                     if(accountMap.get(lead.Assigned_Dealer__r.name).Dealer_Rollout_Status__c!=null && accountMap.get(lead.Assigned_Dealer__r.name).Dealer_Rollout_Status__c == 'Done')
                     {
                    Lead__c ld=new Lead__c();
                    ld.Id = lead.id;
                    ld.CAC_Lead_Status__c='Allocated';
                    ld.Assigned_Date_Time__c=System.now();
                      
                        leads.put(ld.id,ld);
                     }
                   }
                 } 
                            
            
          }
        
        insert leadshare;
        if(leads.size()>0)
        {
          update leads.values();
        }
      //  }
       // LeadUtil.handleAfterInsert=false;
    }
    
    /*DesCription : Send E-mail notification when dealer outlet is assigned to the Lead (LEA-T06)
    Created By : Ramana
    Created Date : 11/11/2016
    Releage   : P3
    */
//Send E-mail notification when dealer outlet is assigned to the Lead (LEA-T06)

     
     public static void  EmailnotificationforLeads(list<Lead__C> listNewLeads,map<id,Lead__C> LeadOldMap,boolean isInsert, boolean isUpdate)
             {
                 Set<String> EmailAddress = new Set<String>();
                 
                 List<User> serviceAdvisorList = new List<User>();
                 List<String> userIds = new List<String>();  
                 List<Lead__c> LeadUpdate = new List<Lead__c>();             
                 //Contact con = [Select id from Contact where email!= null AND AccountId != null AND Federation_ID__c != null limit 1];
                 EmailTemplate e =  [select id,name from EmailTemplate WHERE Name = 'Lead assignment to dealer outlet' limit 1];  
                 List<Messaging.SingleEmailMessage > mails  = new  List<Messaging.SingleEmailMessage >();
                 List<Messaging.SingleEmailMessage > UFRbulkEmails = new  List<Messaging.SingleEmailMessage >();
                 Set<Id> LeadId = new Set<Id>();
                 for(Lead__C lead : listNewLeads)
                 {
                     LeadId.add(lead.Id); 
                     system.debug('+++++++++++++'+LeadId); 
                 }
                 
                 set<Id> DealerAccid=new set<id>();
                 List<User> userRecords=new List<user>();
                 List<Lead__C> Leadlist = [Select id,MD__c,Assigned_Dealer__r.id,ownerid,contact__c,Service_Advisor__r.Email,contact__r.ownerId,Service_Advisor__c,Person_Assign_Notificaton_Done__c,RecordTypeId,CAC_Lead_Status__c ,Lead_Assignment_Notification_Done__c , Assigned_Dealer__c ,Assigned_Dealer__r.ownerid,Assigned_Dealer__r.salesLead_Notification_Timing__c,Assigned_Dealer__r.Dealer_Sales_Manager_Email__c ,Assigned_Dealer__r.Dealer_Aftersales_Manager_Email__c from Lead__c where Id IN :LeadId];
                 system.debug('+++++++++++++'+Leadlist);
                 for(Lead__c ledealer: Leadlist)
                 {
                     DealerAccid.add(ledealer.Assigned_Dealer__r.id);
                 }
                 
                 system.debug('+++DealerUser++++'+DealerAccid);
                 
                 for(Lead__c lead : Leadlist)
                 {
                     if(lead.MD__c == 'JP'  )
                     {                
                         if(isInsert || (isUpdate && (lead.CAC_Lead_Status__c != leadOldMap.get(lead.id).CAC_Lead_Status__c && lead.CAC_Lead_Status__c == 'Allocated' )))
                         {
                            
                             system.debug('Insert Method 1');
                             if(lead.Assigned_Dealer__c != NULL && lead.Lead_Assignment_Notification_Done__c == false && lead.Assigned_Dealer__r.salesLead_Notification_Timing__c == 'Immediately')
                             {
                                isNotificationSendtosalesmanager = true;
                                 system.debug('Insert Method 2');
                                 if(lead.RecordTypeId == salesRecordTypeId)
                                 {                                                            
                                     EmailAddress.add(lead.Service_Advisor__r.Email); 
                                     system.debug('EmailAddress>>>>>>'+EmailAddress);                     
                                 }
                                 if(lead.RecordTypeId == afterSalesRecordTypeId )
                                 { 
                                     //EmailAddress.add(lead.Assigned_Dealer__r.Dealer_Aftersales_Manager_Email__c);
                                     EmailAddress.add(lead.Service_Advisor__r.Email);   
                                     system.debug('EmailAddress>>>>>>'+EmailAddress);                            
                                 }                        
                               }  
                            } 
                             if(lead.Assigned_Dealer__c != NULL && lead.Service_Advisor__c != null &&lead.Person_Assign_Notificaton_Done__c == false) 
                             {
                                 isNotificationSendtoAdivisor = true;
                                 if(lead.RecordTypeId == salesRecordTypeId)
                                 {                                                            
                                     EmailAddress.add(lead.Service_Advisor__r.Email); 
                                     system.debug('EmailAddress>>>>>>'+EmailAddress);                     
                                 }
                                 if(lead.RecordTypeId == afterSalesRecordTypeId )
                                 { 
                                     //EmailAddress.add(lead.Assigned_Dealer__r.Dealer_Aftersales_Manager_Email__c);
                                     EmailAddress.add(lead.Service_Advisor__r.Email);   
                                     system.debug('EmailAddress>>>>>>'+EmailAddress);                            
                                 }       
                             }
                         
                         // if((isinsert || isupdate && lead.Assigned_Dealer__c != LeadOldMap.get(lead.id).Assigned_Dealer__c) && lead.MD__c== 'JP' && lead.Assigned_Dealer__c != null && lead.CAC_Lead_Status__c == 'Approved' && lead.Service_Advisor__c != null && !lead.Person_Assign_Notificaton_Done__c){
                         //EmailAddress.add(lead.Assigned_Dealer__r.Dealer_Sales_Manager_Email__c);
                         // lead.Person_Assign_Notificaton_Done__c = true; 
                         // lead.Lead_Assignment_Notification_Done__c = true;
                         //userIds.add(led.Service_Advisor__c);
                         //}
                         
                     } 
                 }
                 EmailTemplate salesAdvisorNotification =  [select id,name from EmailTemplate WHERE Name = 'Lead assignment to Service Advisor' limit 1];  
                 system.debug('+++++++++++++'+EmailAddress);
                 if(EmailAddress !=null)
                 {
                     serviceAdvisorList = [select id,email from User where email =:EmailAddress];
                 }
                 system.debug('serviceAdvisorList>>>>' + serviceAdvisorList);
                 if(!DealerAccid.isEmpty() && DealerAccid !=null && isNotificationSendtosalesmanager == true)
                 {
                    userRecords = [Select id,profile.name,Name,email,contactid,contact.AccountId from User where IsActive = True and contact.Accountid=:DealerAccid and ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') OR (profile.Name='Japan Dealer Company Manager') OR (profile.Name='Japan Dealer Sales Representative'))];
                 }else if(isNotificationSendtoAdivisor == true){
                        userRecords = [Select id,profile.name,Name,email,contactid,contact.AccountId from User where IsActive = True and contact.Accountid=:DealerAccid and profile.Name='Japan Dealer Sales Representative'];
                 }
                 if(!serviceAdvisorList.isEmpty() && serviceAdvisorList != null)
                 {
                     userRecords.addAll(serviceAdvisorList);
                 }
                 system.debug('+++userRecords +++++'+userRecords );
                 if(!userRecords.isEmpty() && userRecords != null)
                 {                     
                     If(LeadUtil.LeadTrigger)
                     { 
                         for(Lead__c led : Leadlist)
                         {
                             system.debug('++++++++++'+Leadlist);
                         //  if(isInsert || (isUpdate && (led.CAC_Lead_Status__c != leadOldMap.get(led.id).CAC_Lead_Status__c && led.CAC_Lead_Status__c == 'Allocated' )))
                          if(isInsert || (isUpdate && ((led.CAC_Lead_Status__c != leadOldMap.get(led.id).CAC_Lead_Status__c && led.CAC_Lead_Status__c == 'Allocated' )||(led.Service_Advisor__c != null && leadOldMap.get(led.id).Service_Advisor__c == null))))  
                           
						   {                                 
                                 if(isNotificationSendtosalesmanager == true){
                                    led.Lead_Assignment_Notification_Done__c = True;
                                }
                                 if(isNotificationSendtoAdivisor == true){
                                     led.Person_Assign_Notificaton_Done__c = True;
                                 } 
                                 for(User u : userRecords)
                                 {
                                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                                     mail.setWhatId(led.id);
                                     if(isNotificationSendtoAdivisor == True)
                                         mail.setTemplateID(salesAdvisorNotification.Id);
                                     else
                                         mail.setTemplateID(e.Id);
                                     //mail.setTargetObjectId(con.id);
                                     mail.setTargetObjectId(u.id);                            
                                     mail.setBccSender(false);
                                     mail.setWhatId(led.Id);
                                     mail.setUseSignature(false);              
                                     mail.setSaveAsActivity(false);     
                                     mails.add(mail);
                                 }                                 
                                 LeadUpdate.add(led);
                            }
                         }                         
                     }                                          
                 }
                 LeadUtil.LeadTrigger = false;
                 if(mails.size()>0)
                 {
                     system.debug('++++++++++'+mails);                     
                     Messaging.sendEmail(mails);
                 }
                 
                 if(LeadUpdate.size()>0)
                 {
                     system.debug('++++++++++'+LeadUpdate); 
                     update LeadUpdate;                      
                 }      
                 /* for(Messaging.SingleEmailMessage email : mails)
                    *{
                        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                        emailToSend.setToAddresses(email.getToAddresses()); 
                        emailToSend.setPlainTextBody(email.getPlainTextBody());
                        emailToSend.setHTMLBody(email.getHTMLBody());
                        emailToSend.setSubject(email.getSubject());               
                        UFRbulkEmails.add(emailToSend);                
                    } 
                if(UFRbulkEmails.size()>0)
                {
                    try
                    {
                    Messaging.sendEmail(UFRbulkEmails);
                    if(LeadUpdate.size()> 0)
                    {
                    update LeadUpdate;
                    }
                }
                    catch(Exception emailexe)
                    {
                        system.debug('UFR Mail Sending Invalid------>'+emailexe.getMessage());
                    } 
                } */
        }   
        
         public static void updateAssignedDealer(List<Lead__c> dealerLeadList, set<Id> salesConIds)
    {
        List<User> userList = new List<User>();
        set<id> userid = new set<id>();
		map<id, id> mapsalesConandUsrId = new map<id, id>();
        userList = [select id,Market__c,Profile.UserLicense.Name,ContactId,Contact.Accountid from User where id =:Userinfo.getUserId()];
         if(salesConIds.size()>0){
			for(User usr: [select id, ContactId from user where ContactId in: salesConIds]){
			   mapsalesConandUsrId.put(usr.ContactId, usr.id);
			}
		 }
        for(Lead__c dellead: dealerLeadList)
        {
			if(dellead.RecordTypeId == salesRecordTypeId && dellead.Sales_Consultant__c != null)
			{
				dellead.Service_Advisor__c =  mapsalesConandUsrId.get(dellead.Sales_Consultant__c);//dellead.Sales_Consultant__c;
			}
            if(!userList.isEmpty() && userList != null)
            {
                for(User u : userList)
                {
                    if(u.Market__c == 'KR' && u.Profile.UserLicense.Name == 'Partner Community')
                    {
                        dellead.Assigned_Dealer__c = u.Contact.AccountId;
                    }
                }
            }
        }
    }    
   /*     
  public Static boolean isCreated =false;
  public static void populateRetailCompany(List<Lead__c> LeadLst, Map<Id,Lead__c> oldLeadmap, boolean isInsert, boolean isUpdate){
        system.debug('====#####'+isInsert);
        system.debug('====#####'+isUpdate);
        Id CompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        List<Account_Link__c> AccounliunkUpdate = new List<Account_Link__c>();
        List<Account_Link__c> AccounliunkRetailUpdate = new List<Account_Link__c>();
        set<string> companyId = new set<string>();
        set<string> AssignedDealerId = new set<string>();
        set<String> retailconctId = new set<String>();
        for(Lead__C led : LeadLst){
            
            if(Userinfo.getUserType() == 'PowerPartner' && (isInsert || (isUpdate && led.CAC_Lead_Status__c != oldLeadmap.get(led.id).CAC_Lead_Status__c || led.Retail_Contact__c != oldLeadmap.get(led.id).Retail_Contact__c))){
                if(led.Company_Account__c != null && led.Contact__c != null && led.CAC_Lead_Status__c == 'Allocated'){
                    isCreated = true;
                    companyId.add(led.Company_Account__c);
                    AssignedDealerId.add(led.Assigned_Dealer__c);
                    if(led.Retail_Contact__c != null){                        
                        retailconctId.add(led.Retail_Contact__c);
                    }  
                      
                }
            }
            
            system.debug(led.Company_Account__c +'    '+ oldLeadmap.get(led.id).Company_Account__c +'    '+ led.Contact__c +'    '+ oldLeadmap.get(led.id).Contact__c +'    '+ led.CAC_Lead_Status__c +'    '+ oldLeadmap.get(led.id).CAC_Lead_Status__c +'    '+ led.Retail_Contact__c +'    '+ oldLeadmap.get(led.id).Retail_Contact__c);
             else if(isInsert || (isUpdate && (led.Company_Account__c != oldLeadmap.get(led.id).Company_Account__c || led.Contact__c != oldLeadmap.get(led.id).Contact__c ))){
                system.debug('Conditions are saisfied11111111'+led.Retail_Contact__c);
                if(led.Contact__c != null && led.Company_Account__c != null && led.CAC_Lead_Status__c == 'Allocated' && (led.RecordtypeId == salesRecordTypeId || led.RecordtypeId == afterSalesRecordTypeId )){
                //&& (RecordType.DeveloperName == 'Sales_Leads' || RecordType.DeveloperName == 'Aftersales_Leads') && led.Company_Account__c != null
                    isCreated = true;
                    system.debug('Recordype.developerName'+led.Recordtype.Developername);
                    companyId.add(led.Company_Account__c);
                    AssignedDealerId.add(led.Assigned_Dealer__c);
                    system.debug('Conditions are saisfied222222'+led.Retail_Contact__c);
                    if(led.Retail_Contact__c != null){
                        system.debug('retail  contzct'+led.Retail_Contact__c);
                        retailconctId.add(led.Retail_Contact__c);
                    }    
                }
            }
        }
        List<Account_Link__C> AccountLink = [select Id, toRole__c, fromRole__c, Retail_Delete_Flag__c, Retail_Duplicate_Flag__c from Account_Link__c WHERE toRole__c IN : companyId AND fromRole__c IN : AssignedDealerId AND Retail_Delete_Flag__c = False AND Retail_Duplicate_Flag__c = False AND Recordtype.DeveloperName = 'Retail_Company'];
        List<Account_Link__C> AcclkLst = [select id,Retail_Related_Company__c from Account_Link__C WHERE id IN : retailconctId];
        if(!AccountLink.isEmpty()){
            for(Account_Link__c acc : AcclkLst){
                acc.Retail_Related_Company__c  = AccountLink[0].id;
                AccounliunkRetailUpdate.add(acc);
            }
        }
        
        if(AccountLink.isEmpty()){
            
            for(Lead__C led : LeadLst){
                //Account_Link__C acclnk = new Account_Link__C(RecordtypeId = CompanyRecordTypeId, toRole__c = (led.Company_Account__c!=null?led.Company_Account__c : ''), fromRole__c = (led.Assigned_Dealer__c!=null?led.Assigned_Dealer__c : ''), Retail_Address_Reference__c =  (led.Company_Account__r.Primary_Address_Reference__c!= null ? led.Company_Account__r.Primary_Address_Reference__c : '') 
                //);
                if(isCreated == true){
                    Account_Link__C acclnk = new Account_Link__C(RecordtypeId = CompanyRecordTypeId, toRole__c = led.Company_Account__c, fromRole__c = led.Assigned_Dealer__c, Retail_Address_Reference__c =  led.Company_Account__r.Primary_Address_Reference__c);
                    AccounliunkUpdate.add(acclnk);
                    
                }
                
            }
                if(!AccounliunkUpdate.isEmpty()){
                    insert AccounliunkUpdate;
            
            for(Account_Link__c acc1:AcclkLst){
                system.debug('updared_______>');
                acc1.Retail_Related_Company__c  = AccounliunkUpdate[0].id;
                AccounliunkRetailUpdate.add(acc1);
            }
            }
            
       
        update AccounliunkRetailUpdate;
        }
    }
     */ 
        
   }