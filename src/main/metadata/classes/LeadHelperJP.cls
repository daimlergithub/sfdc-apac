/**
** Utility for Lead trigger for Japan 
** Updation of ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œCustomer_Lifecycle_Phase__cÃƒÂ¢Ã¢â€šÂ¬Ã‚Â on Account related to lead based on CAC Lead Status
** Initialise Customer_Lifecycle_Phase__c on Account based on CAC Lead Status of all the leads associated with Account based on CAC Lead Status.
** Create AccountLink with combination of From role and to role with contact and Assigned Dealer for newly inserted leads based on CAC Lead Status.
** Created By: Narasimha 
** Date: 2016-1-19
** Modified By : 
** Modified date :
**/

public class LeadHelperJP 
{
    
/**  Updation of ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œCustomer_Lifecycle_Phase__cÃƒÂ¢Ã¢â€šÂ¬Ã‚Â on Account related to lead based on CAC Lead Status
**  Created By: Narasimha  
**  Date: 2016-1-19
**/
     private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static final String SalesLeadSoftDeletedRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RECORDTYPE_SALES_LEAD_SOFT_DELETED).getRecordTypeId();
    private static final String afterSalesLeadSoftDeletedRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RECORDTYPE_AFTERSALES_LEAD_SOFT_DELETED).getRecordTypeId();
    static boolean isNotificationSendtoAdivisor = false;
    static boolean isNotificationSendtosalesmanager = false;
    private static  final profile p = [select Name from profile where id =:userinfo.getprofileId()]; //JP-1942
    private static  final User assigneduser=[select id,Market__c,profile.name,Profile.UserLicense.Name,ContactId,Contact.Accountid from User where id =:Userinfo.getUserId()];
    private static final EmailTemplate e =  [select id,name from EmailTemplate WHERE Name = 'Lead assignment to dealer outlet' limit 1];
    private static final EmailTemplate salesAdvisorNotification =  [select id,name from EmailTemplate WHERE Name = 'Lead assignment to Service Advisor' limit 1]; 
       
    
    
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
       /** 
       Created By: Dinesh Govindaswamy
     SFDCjp-2915
       **/
  
  
            public static void InsertAssignedDealer(List<Lead__c> dealerLeadList )
    {
        List<User> userList = new List<User>();
        set<id> userid = new set<id>();
       // map<id, id> mapsalesConandUsrId = new map<id, id>();
        userList = [select id,Market__c,Profile.UserLicense.Name,ContactId,Contact.Accountid from User where id =:Userinfo.getUserId()];
        
         if(!userList.isEmpty() && userList != null)
            {
      
               for(Lead__c dellead: dealerLeadList)
               
                {
                
  
        
                  for(User u : userList)
                {
                
                    if(u.Market__c == 'JP' && u.ContactId != null)
                    {
                        dellead.Service_Advisor__c = u.Id;
                        system.debug('+++++++++ u.Contact.AccountId' + u.Contact.AccountId);
                                             
                    }
                }
          }            
          }
       
       
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
    
/** Update Lead Status and Owner to Service Advisor 
** Created By: Sudhir  
**  Date: 2017-8-16
**/  
    
    
    public static void afterInsertUpdateEvent(List<Lead__c> leadsList,map<id,Lead__c> leadsOldMap,boolean isInsert,boolean isUpdate)
    {
        set<id> leadsId = new set<id>();
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Lead__c> ledsList = new List<Lead__c>();
        if(leadsList != null && !leadsList.isEmpty())
        {
            for(Lead__c les : leadsList)
            {
                if(les.RecordTypeId ==salesRecordTypeId || les.RecordTypeId ==afterSalesRecordTypeId)
                {
                    
                    if(les.CAC_Lead_Status__c == 'Approved' && userinfo.getUserType() != 'PowerPartner' && les.Assigned_Dealer__c != null 
                       && (isInsert || (isUpdate && les.CAC_Lead_Status__c != leadsOldMap.get(les.id).CAC_Lead_Status__c ||
                                        les.Service_Advisor__c != leadsOldMap.get(les.id).Service_Advisor__c)))
                    {
                        leadsId.add(les.Id);
                    }
                    else if(les.CAC_Lead_Status__c == 'Allocated' && userinfo.getUserType() != 'PowerPartner' && les.Assigned_Dealer__c != null 
                            && isUpdate && les.Service_Advisor__c != leadsOldMap.get(les.id).Service_Advisor__c)
                    {
                        leadsId.add(les.Id);
                    }
                    else if(userinfo.getUserType() == 'PowerPartner' && (les.CAC_Lead_Status__c != leadsOldMap.get(les.id).CAC_Lead_Status__c ||
                                                                         les.Service_Advisor__c != leadsOldMap.get(les.id).Service_Advisor__c))
                    {
                        leadsId.add(les.id);
                    }
                    if(isUpdate && les.Source_Campaign__c!=null && les.CAC_Lead_Status__c == 'Approved' && userinfo.getUserType() != 'PowerPartner' && les.Assigned_Dealer__c != null )
                    {
                    System.debug('venky here..........');
                     leadsId.add(les.id);
                    }
                }
            }
        }
        system.debug('leadsId<><><>' + leadsId);
        if(!leadsId.isEmpty() && leadsId != null)
        {
            ledsList = [select id ,Assigned_Dealer__c ,Service_Advisor__c ,Source_Campaign__c,Assigned_Dealer__r.Dealer_Rollout_Status__c ,CAC_Lead_Status__c from Lead__c where id =:leadsId];
        }
        system.debug('ledsList<><><>' + ledsList);
        
        if(ledsList != null && !ledsList.isEmpty())
        {
            for(Lead__c lds : ledsList)
            {
                if(p.Name.contains('MBF') )
                {   
                    lds.CAC_Lead_Status__c='Approved';
                }
                else if(isUpdate && lds.CAC_Lead_Status__c == 'Approved' && lds.CAC_Lead_Status__c != leadsOldMap.get(lds.id).CAC_Lead_Status__c && lds.Assigned_Dealer__r.Dealer_Rollout_Status__c == 'Done' && Userinfo.getUserType() == 'PowerPartner')
                {   
                    system.debug('Entereed><><><>');
                    lds.CAC_Lead_Status__c = 'Allocated';
                }
                else if(lds.CAC_Lead_Status__c == 'Approved' && lds.Assigned_Dealer__r.Dealer_Rollout_Status__c == 'Done' && (isInsert || (isUpdate && lds.CAC_Lead_Status__c != leadsOldMap.get(lds.id).CAC_Lead_Status__c && lds.CAC_Lead_Status__c == 'Approved' && Userinfo.getUserType() != 'PowerPartner')))
                {
                    lds.CAC_Lead_Status__c = 'Allocated';
                }
                if(isUpdate && lds.Service_Advisor__c != leadsOldMap.get(lds.id).Service_Advisor__c)
                {
                    lds.OwnerId = lds.Service_Advisor__c;
                }
                 if(isUpdate && lds.Source_Campaign__c!=null && lds.CAC_Lead_Status__c == 'Approved' && userinfo.getUserType() != 'PowerPartner' && lds.Assigned_Dealer__c != null )
                    {
                    System.debug('venky here..........');
                    lds.CAC_Lead_Status__c = 'Allocated';
                    }
                system.debug('LeadStatus<><><>' + lds.CAC_Lead_Status__c);
                updateLeadList.add(lds);
            }
        }
        system.debug('updateLeadList<><><>' + updateLeadList);
        if(!updateLeadList.isEmpty() && updateLeadList != null)
        {
         
            update updateLeadList; 
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
        map<string,list<String>> dealeraccntMap = new Map<string,list<String>>();
        Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        list<lead__c> leadlist = new list<lead__c>();
        list<account> dealerAccountList =new list<account>();
        Map<String,account>accountMap=new Map<String,account>();
        // Map<id,account>aMap=new Map<id,account>();
        set<id>dealerAccountIds = new set<id>();
        set<String> GCCode = new set<String>();
        set<id> leadIds = new set<id>();
        
        if(leadlist1 !=null)
        {
            for(Lead__c lead:leadlist1)
            {
                if((lead.RecordTypeId ==salesRecordTypeId )||(lead.RecordTypeId ==afterSalesRecordTypeId))
                {
                    if(lead.CAC_Lead_Status__c=='approved' && ( Trigger.isinsert || (Trigger.Isupdate && (lead.CAC_Lead_Status__c!=leadOldMap.get(lead.id).CAC_Lead_Status__c)))&& lead .Assigned_Dealer__c!=null)
                    { 
                        leadIds.add(lead.id);
            system.debug('******************************************Lead No.:' + lead.Name + ' had been added to the target list leadIds as the status was approved*************************************');
                    }
                    else if(lead.CAC_Lead_Status__c == 'Allocated' && trigger.isUpdate && lead.OwnerId != leadOldMap.get(lead.id).OwnerId)
                    {
                        leadIds.add(lead.id);
            system.debug('******************************************Lead No.:' + lead.Name + ' had been added to the target list leadIds as the status was Allocated*************************************');
                    }
                }
            }
        }
        system.debug('leadIds><><><>' + leadIds);
        if(leadIds !=null)
        {
            leadlist = [Select id,recordtypeId,Assigned_Dealer__r.name,CAC_Lead_Status__c,Assigned_Dealer__r.Dealer_GC_Code__c,Assigned_Dealer__c from Lead__c where Id IN:leadIds];
            for (Lead__c lead: leadlist){
            system.debug('******************************************leadlist : Lead Id.:' + lead.Id + ' had been added to the target list leadlist*************************************');                
            }
        }
        if(leadlist !=null)
        {
            for(lead__c le:leadlist)
            {
                if(le.Assigned_Dealer__c != null){dealerAccountIds.add(le.Assigned_Dealer__c);}
            system.debug('******************************************dealerAccountIds : AssignedDealer:' + le.Assigned_Dealer__c + ' had been added to the target list dealerAccountIds*************************************');                
            }
        }
        if(dealerAccountIds.size()>0)
        {
            dealerAccountList = [select id,name,Dealer_Rollout_Status__c from account where ID IN:dealerAccountIds];
            for (Account a: dealerAccountList){
            system.debug('******************************************dealerAccountList : Name:' + a.Name + ' had been added to the target list dealerAccountList*************************************');                
                }
        }
        if(dealerAccountList.size()>0)
        {
            for(account a:dealerAccountList)
            {
                if(a.Dealer_Rollout_Status__c == 'Done')
                {
                    accountMap.put(a.name,a);
            system.debug('******************************************accountMap : Name:' + a.Name + ' had been added to the target Map accountMap*************************************');                
                    
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
        list<account> acl=new list<account>();
        Set<id> leadIdsSet = new Set<id>();
        if(leadlist!=null)
        {
            for(lead__c l:leadlist )
            {
                
                // System.debug('lead.Assigned_Dealer__r.name'+lead.Assigned_Dealer__r.name);
                asslist.add(l.Assigned_Dealer__r.name);
                GCCode.add(l.Assigned_Dealer__r.Dealer_GC_Code__c );
                leadIdsSet.add(l.id);          
                
            system.debug('******************************************asslist : Name:' + l.Assigned_Dealer__r.name + ' had been added to the target list asslist*************************************');                
            system.debug('******************************************GCCode : GC_Code:' + l.Assigned_Dealer__r.Dealer_GC_Code__c + ' had been added to the target list GCCode*************************************');                
            system.debug('******************************************leadIdsSet : Lead Id:' + l.id + ' had been added to the target list leadIdsSet*************************************');                
            }
            
            
        }
        if(GCCode !=null)
        {
            acl=[select id, Name, RecordType.DeveloperName,Dealer_GC_Code__c from Account WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeid=:Dealer_RecordTypeId];
            for (Account a: acl){
            system.debug('******************************************asslist : Name:' + a.Name + ' had been added to the target list acl*************************************');                                
            }
        }
        
        if(acl!=null)
        {
            for(Account acc :acl)
            {
                system.debug('acc.Name'+acc.Name);
                if(!dealeraccntMap.containsKey(acc.Dealer_GC_Code__c))
                {
                    dealeraccntMap.put(acc.Dealer_GC_Code__c, new List<string>());
            system.debug('******************************************dealeraccntMap : GC Code:' + acc.Dealer_GC_Code__c + ' had been added to the target list dealeraccntMap*************************************');                                
                }
                dealeraccntMap.get(acc.Dealer_GC_Code__c).add(acc.Name);
            system.debug('******************************************dealeraccntMap : Name:' + acc.Name + ' had been added to the target Map dealeraccntMap in the position of ' + dealeraccntMap.get(acc.Dealer_GC_Code__c) + '*************************************');                                
                AccountNAme.add(acc.Name);
            system.debug('******************************************AccountNAme : Name:' + acc.Name + ' had been added to the target list AccountNAme*************************************');                                
            }
        }
        system.debug('dealeraccntMap><><><' + dealeraccntMap);
        list<Group> grplist=new list<Group>();
        if(AccountNAme !=null)
        {
            grplist=[select id ,Name ,Type from Group where Name IN: AccountNAme];
            for (Group g: grplist){
            system.debug('******************************************grplist : Name:' + g.Name + ' had been added to the target list grplist*************************************');                                                
            }
        }
        
        if(grplist!=null)
        {
            for(Group assg:grplist)
            {
                
                assgroupMap.put(assg.Name, assg.id);
                
            system.debug('******************************************assgroupMap : Name:' + assg.Name + ' had been added to the target list assgroupMap*************************************');                                                
                
            }
        }
        system.debug('assgroupMap><><><>'+assgroupMap);
        if(leadlist !=null)
        {
            for(Lead__c lead:leadlist)  
            {
                for(integer i=0 ; i < dealeraccntMap.get(lead.Assigned_Dealer__r.Dealer_GC_Code__c).size();i++)
                {
                    
                    if(assgroupMap.get(dealeraccntMap.get(lead.Assigned_Dealer__r.Dealer_GC_Code__c)[i]) != null)
                    {
                        Lead__share l=new Lead__share();
                        l.ParentId=lead.id;
                        l.UserOrGroupId = assgroupMap.get(dealeraccntMap.get(lead.Assigned_Dealer__r.Dealer_GC_Code__c)[i]);
                        
                        l.rowcause = Schema.Lead__Share.rowcause.Assigned_Dealer__c ;  
                        l.AccessLevel='edit';
                        leadshare.add(l);
            system.debug('******************************************leadshare : Lead Id:' + lead.id + ' Group Id: ' + assgroupMap.get(dealeraccntMap.get(lead.Assigned_Dealer__r.Dealer_GC_Code__c)[i]) +' had been added to the target list leadshare*************************************');                                                
                    }
                }
            }
        }
        if(!leadshare.isEmpty() && leadshare != null)
        {
            insert leadshare;
            system.debug('*******************************************leadshare Inserted*****************************************');
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
        set<id> dealerleadIds = new set<id>();
        set<id> DealerAccid = new set<id>();
        set<string> DealerGcCode = new set<string>();
        set<string> AfterSalesDealerGcCode = new set<string>();
        List<Lead__C> Leadlist =new List<Lead__C>();
        Set<id> serusrIds = new Set<id>();
        List<User> serviceAdvisorList = new List<User>();
        List<User> dealerUserList = new List<User>();
        map<string,List<User>> dealerUserMap = new map<string,List<User>>();
        List<Lead__c> updateLeadLists = new List<Lead__c>();
        List<Messaging.SingleEmailMessage > mails  = new  List<Messaging.SingleEmailMessage >();
        List<String> assignedList = new List<String>();
        List<User> userGCCode = new List<User>();
        List<User> ChangeList=new List<User>();
        
        if(!listNewLeads.isEmpty() && listNewLeads != null)
        {
            for(Lead__c dels : listNewLeads)
            {
                if(dels.Assigned_Dealer__c != null && dels.CAC_Lead_Status__c == 'Allocated'  && (isInsert || (isUpdate && dels.CAC_Lead_Status__c != leadOldMap.get(dels.id).CAC_Lead_Status__c
                                                                                                              ))) //|| dels.Service_Advisor__c != leadOldMap.get(dels.id).Service_Advisor__c
                {
                    dealerleadIds.add(dels.Id);
                }
            }
        }
        system.debug('dealerleadIds><><><' + dealerleadIds);
        if(dealerleadIds !=null && !dealerleadIds.isEmpty())
        {
            Leadlist = [Select id,MD__c,Assigned_Dealer__r.id,Lead_DataSource__c,ownerid,contact__c,Assigned_Dealer__r.Dealer_GC_Code__c,
                        Service_Advisor__r.Email,contact__r.ownerId,Service_Advisor__c,Person_Assign_Notificaton_Done__c,
                        RecordTypeId,CAC_Lead_Status__c ,Assigned_Dealer__r.Name,Lead_Assignment_Notification_Done__c , Assigned_Dealer__c ,
                        Assigned_Dealer__r.ownerid,Assigned_Dealer__r.salesLead_Notification_Timing__c,Assigned_Dealer__r.Dealer_Sales_Manager_Email__c ,RecordType.developerName,
                        Assigned_Dealer__r.Dealer_Aftersales_Manager_Email__c from Lead__c where Id IN :dealerleadIds];
        }
        system.debug('Leadlist><><><' + Leadlist);
        if(!Leadlist.isEmpty() && Leadlist != null)
        {
            for(Lead__c lsds : Leadlist)
            {
                if(lsds.Lead_DataSource__c != 'Dealer Outlet' && lsds.Lead_Assignment_Notification_Done__c == false
                  && lsds.Assigned_Dealer__r.salesLead_Notification_Timing__c == 'Immediately')
                { 
                    DealerAccid.add(lsds.Assigned_Dealer__c);
                    if(lsds.RecordType.DeveloperName == 'Sales_Leads'){
                        DealerGcCode.add(lsds.Assigned_Dealer__r.Dealer_GC_Code__c);
                    }
                    if(lsds.RecordType.DeveloperName == 'Aftersales_Leads'){
                        AfterSalesDealerGcCode.add(lsds.Assigned_Dealer__r.Dealer_GC_Code__c);
                    }
                }
            }
        }
        if(!DealerGcCode.isEmpty()){
            userGCCode = [select id ,profile.name ,Dealer_GC_Code__c,Name ,email,contactid,contact.AccountId,contact.Account.Dealer_GC_Code__c,Notification_Lead_Dealer_Assignment__c from User where Dealer_GC_Code__c IN:DealerGcCode and ContactId != null and isActive = true ];
        }if(!AfterSalesDealerGcCode.isEmpty()){
            userGCCode = [select id ,profile.name ,Dealer_GC_Code__c,Name ,email,contactid,contact.AccountId,contact.Account.Dealer_GC_Code__c,Notification_Lead_Dealer_Assignment__c from User where Dealer_GC_Code__c IN:AfterSalesDealerGcCode and ContactId != null and isActive = true ];
        }
        
        set<String> usrlst = New set<String>();
        if(Leadlist !=null && userGCCode!=null)
        {
        for(Lead__c led : Leadlist){
        for(User usr : userGCCode){ 
            if(usr.Notification_Lead_Dealer_Assignment__c != null){
            
              List<string> LeadAssignement = (usr.Notification_Lead_Dealer_Assignment__c.split(';')); 
              system.debug('&*&*&*&*&*LeadAssignement'+LeadAssignement);
               for(String leadAssinstr: LeadAssignement ){
                   if(leadAssinstr == led.Assigned_Dealer__r.Name){
                   if(usr.Notification_Lead_Dealer_Assignment__c!=null && led.Assigned_Dealer__r.Dealer_GC_Code__c == usr.Dealer_GC_Code__c)
                       usrlst.add(usr.id);    
                   }
               }
            }
            
        }
        }
        }
         system.debug('usrlst*****************'+usrlst);
         if(usrlst !=null)
         {
       ChangeList =[Select id,Notification_Lead_Dealer_Assignment__c,Dealer_GC_Code__c From User Where id =: usrlst and ((Dealer_GC_Code__c In:DealerGcCode) OR (Dealer_GC_Code__c In:AfterSalesDealerGcCode)) and ContactId != null and isActive = true];
        }
        //List<User> LeadAssignedusers = [select Id,Name from User WHERE Name IN:assignedList];
        
        
        system.debug('DealerAccid ><><><>' + DealerAccid);
        if(!DealerAccid.isEmpty() && DealerAccid != null)
        {
            if(!DealerGcCode.isEmpty()){
            dealerUserList = [select id ,profile.name ,Name ,email,Dealer_GC_Code__c,contactid,contact.AccountId,contact.Account.Dealer_GC_Code__c,Notification_Lead_Dealer_Assignment__c from User
                             where contact.AccountId =: DealerAccid  and ContactId != null and isActive = true and ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') OR (profile.Name='Japan Dealer Sales Representative'))];
            }if(!AfterSalesDealerGcCode.isEmpty()){
                dealerUserList = [select id ,profile.name ,Name ,Dealer_GC_Code__c,email,contactid,contact.AccountId,contact.Account.Dealer_GC_Code__c,Notification_Lead_Dealer_Assignment__c from User
                             where contact.AccountId =: DealerAccid  and ContactId != null and isActive = true and ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') OR (profile.Name='Japan Dealer Service Advisor'))];
            }            
        }
        
        
        system.debug('dealerUserList ><><><>' + dealerUserList);
        
        
        if(!Leadlist.isEmpty() && Leadlist != null)
        {
            
            for(Lead__c emaLeds : Leadlist)
            {
                // System.debug('$$$$$$$$&^&^&^'+dealerUserList);
                if((!dealerUserList.isEmpty() && dealerUserList != null) || (ChangeList!=null && !ChangeList.isempty()))
                {   
                    if(dealerUserList !=null)
                    {
                    for(User us : dealerUserList)
                    {   
                        System.debug('$$$$$$$$&^&^&^'+dealerUserList);
                        if(emaLeds.Lead_Assignment_Notification_Done__c == false && emaLeds.Lead_DataSource__c != 'Dealer Outlet' && emaLeds.Assigned_Dealer__c == us.Contact.AccountId)
                        {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                            mail.setWhatId(emaLeds.id); 
                            mail.setTemplateID(e.Id); 
                            //mail.setTargetObjectId(con.id);
                            mail.setTargetObjectId(us.Id);                            
                            mail.setBccSender(false);
                            mail.setWhatId(emaLeds.Id);
                            mail.setUseSignature(false);              
                            mail.setSaveAsActivity(false);     
                            mails.add(mail);
                            
                        }
                    }
                    }
                    if(ChangeList !=null)
                    {
                    for(User us : ChangeList)
                    {   
                        System.debug('$$$$$$$$&^&^&^'+dealerUserList);
                        if(emaLeds.Lead_Assignment_Notification_Done__c == false && emaLeds.Lead_DataSource__c != 'Dealer Outlet' && us.Notification_Lead_Dealer_Assignment__c!=null && emaLeds.Assigned_Dealer__r.Dealer_GC_Code__c == us.Dealer_GC_Code__c)
                        {
                        List<string> LeadAssignement = (us.Notification_Lead_Dealer_Assignment__c.split(';')); 
                        
                         for(String leadAssinstr: LeadAssignement ){
                         
                          if(leadAssinstr == emaLeds.Assigned_Dealer__r.Name){
                          
                           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                            mail.setWhatId(emaLeds.id); 
                            mail.setTemplateID(e.Id); 
                            //mail.setTargetObjectId(con.id);
                            mail.setTargetObjectId(us.Id);                            
                            mail.setBccSender(false);
                            mail.setWhatId(emaLeds.Id);
                            mail.setUseSignature(false);              
                            mail.setSaveAsActivity(false);     
                            mails.add(mail);
                     
                          }
                         
                         }
                           
                            
                        }
                    }
                    }
                    
                    //if(emaLeds.CAC_Lead_Status__c == 'Allocated' && (isInsert || (isUpdate && (emaLeds.CAC_Lead_Status__c != leadOldMap.get(emaLeds.id).CAC_Lead_Status__c))))
                    //{
                        emaLeds.Lead_Assignment_Notification_Done__c = True;
                   // }
                }
                // Commented below and achived this through workflow rulw
                /*if(emaLeds.Service_Advisor__c != null && emaLeds.Service_Advisor__c != Userinfo.getUserId() && emaLeds.Person_Assign_Notificaton_Done__c == false)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                    mail.setWhatId(emaLeds.id); 
                    mail.setTemplateID(salesAdvisorNotification.Id); 
                    //mail.setTargetObjectId(con.id);
                    mail.setTargetObjectId(emaLeds.Service_Advisor__c);                            
                    mail.setBccSender(false);
                    mail.setWhatId(emaLeds.Id);
                    mail.setUseSignature(false);              
                    mail.setSaveAsActivity(false);     
                    mails.add(mail);
                    if(emaLeds.Service_Advisor__c != null && emaLeds.CAC_Lead_Status__c == 'Allocated')
                    {
                        emaLeds.Person_Assign_Notificaton_Done__c = True;
                    }
                }*/
                updateLeadLists.add(emaLeds);
            }
        }
        system.debug('++++++++++'+mails);
        if(mails.size()>0)
        {
             
            try  
            {    
                Messaging.sendEmail(mails);
                system.debug('++++++++++'+mails); 
            }
            Catch(Exception exe)
            {
               
            }
        }
        system.debug('updateLeadLists++++++++++'+updateLeadLists);
        if(updateLeadLists.size()>0)
        {
            //try  
            //{
                update updateLeadLists; 
            //}
            //Catch(Exception excep)
            //{
            //System.debug('@@#@#@#@#@#@#@#@#'+excep.getMessage());    
            //}                     
        }
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
                        //Changes as part of SFDCKR-1429
                        if((dellead.recordtypeId == salesRecordTypeId && dellead.Dealer_Lead_Status__c != 'Lost (Dealer)' && dellead.Dealer_Lead_Status__c != 'Received' && dellead.Dealer_Lead_Status__c != 'Invoiced' && dellead.Dealer_Lead_Status__c != 'Lost') || (dellead.recordtypeId == afterSalesRecordTypeId && dellead.Dealer_Lead_Status__c != 'Lost (Dealer)' && dellead.Dealer_Lead_Status__c != 'Service Completed' && dellead.Dealer_Lead_Status__c != 'Lost'))
                        {
                            dellead.Dealer_Assigned_Date_Time__c = system.now();
                        }
                    }
                }
            }
        }
    } 

      public static void deleteSharingTODealers(list<Lead__C> leadList,Map<Id,Lead__C> oldMap)
      {    
            set<id> leadID=new set<id>();
            list<Lead__Share> lstShare=new  list<Lead__Share>(); 
             for(Lead__C les:leadList)
             {
                 if(les.MD__c=='JP' && (les.RecordTypeId!=oldMap.get(les.id).RecordTypeId && (les.RecordTypeId ==SalesLeadSoftDeletedRecordTypeId || les.RecordTypeId ==afterSalesLeadSoftDeletedRecordTypeId)))
                     leadID.add(les.id);
                 
             }
             
            if(!leadID.isEmpty() && leadID != null)
            {
                 lstShare=[SELECT Id,ParentId FROM Lead__Share where ParentId IN : leadID AND RowCause = 'Assigned_Dealer__c'];
                system.debug('lstShare.....'+lstShare);
            }
            
            
            if(!lstShare.isEmpty() && lstShare != null)
            {
                
                delete lstShare;
            }
      }  
      
     public static void sharingTOJapanDataManagement(list<Lead__C> leadList,Map<Id,Lead__C> oldMap){
         
            set<id> leadID=new set<id>();
            list<User> shareUser=new list<User>();
            list<Lead__Share> lstShare=new  list<Lead__Share>(); 
             for(Lead__C les:leadList)
             {
                 if(les.MD__c=='JP' && (les.RecordTypeId!=oldMap.get(les.id).RecordTypeId && (les.RecordTypeId ==SalesLeadSoftDeletedRecordTypeId || les.RecordTypeId ==afterSalesLeadSoftDeletedRecordTypeId)))
                     leadID.add(les.id);
                 
             }
             
            if(!leadID.isEmpty() && leadID != null)
            {
                 shareUser=[SELECT id,UserRole.Name,Profile.Name,IsActive,Market__c FROM User where IsActive =true and Profile.Name='Japan Data Management' and Market__c='JP' ];
                 for(id ldID:leadID){
                     for(user u:shareUser){
                         Lead__share l=new Lead__share();
                        l.ParentId=ldID;
                        l.UserOrGroupId =u.id;
                        
                        l.rowcause = Schema.Lead__share.RowCause.Manual;  
                        l.AccessLevel='edit';
                        lstShare.add(l);
                     }
                 }
            }
            if(!lstShare.isEmpty() && lstShare != null)
            {
                
                insert lstShare;
            }
     }    
   }