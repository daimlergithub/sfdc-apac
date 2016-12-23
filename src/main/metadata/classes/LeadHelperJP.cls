/**
** Utility for Lead trigger for Japan 
** Updation of “Customer_Lifecycle_Phase__c” on Account related to lead based on CAC Lead Status
** Initialise Customer_Lifecycle_Phase__c on Account based on CAC Lead Status of all the leads associated with Account based on CAC Lead Status.
** Create AccountLink with combination of From role and to role with contact and Assigned Dealer for newly inserted leads based on CAC Lead Status.
** Created By: Narasimha 
** Date: 2016-1-19
** Modified By : 
** Modified date :
**/

public class LeadHelperJP 
{
	
/**  Updation of “Customer_Lifecycle_Phase__c” on Account related to lead based on CAC Lead Status
**  Created By: Narasimha  
**  Date: 2016-1-19
**/
    
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
        
        
        
        for(Lead__C lead : listNewLeads)
        {
            if(lead.MD__c == 'JP')
            {
                Lead__c oldLead = LeadOldMap.get(lead.id);
                if(oldLead.CAC_Lead_Status__c != lead.CAC_Lead_Status__c && lead.CAC_Lead_Status__c == 'Approved' )
                {
                    system.debug('!!!!!!!!'+ 'in trigger.new loop');
                    contactIdsUpd.add(lead.Contact__c);         // ids of account(Contact__C) with new lead status "Approved"
                    DealerIds.add(lead.Assigned_Dealer__c);     // Ids of Acccount(Assigned_Dealer__c) with new lead status "Approved"
                    ContactDealerMap.put(lead.contact__C,lead.Assigned_Dealer__c); // Contact Dealer map 
                }
                
                if(oldLead.CAC_Lead_Status__c != lead.CAC_Lead_Status__c && (lead.CAC_Lead_Status__c == 'Purchased(Only Non BDC)' ||
                                                                             lead.CAC_Lead_Status__c == 'Lost(CAC)' || 
                                                                             lead.CAC_Lead_Status__c == 'Not Allocated'))
                {
                    system.debug('!!!!!!!!'+'inside 2nd case loop trigger.new');
                    contactIdsIns.add(lead.Contact__c);
                    
                    
                }
            }
        }
        
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
        createAccountLinkFromDealer(listNewLeads,LeadNewMap,contactIdsUpd,DealerIds,ContactDealerMap);
        
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
     list<lead__c> leadlist = new list<lead__c>();
     leadlist = [Select id,recordtypeId,Assigned_Dealer__r.name,CAC_Lead_Status__c,Assigned_Dealer__c from Lead__c where Id IN:leadlist1];
     list<Lead__share>  leadshare=new list<lead__share>();
     list<Lead__c> leads=new list<lead__c>();
      list<group>assgroupList=new list<group>();
     map<string,id> assgroupMap = new map<string,id>();
      Map<String,id>agroupmap=new Map<String,id>();
     list<string>asslist=new list<string>();
     
      Id rc=Schema.SObjectType.Lead__c.getRecordtypeInfosByName().get('Sales Leads').getRecordTypeId();
      Id rc1=Schema.SObjectType.Lead__c.getRecordtypeInfosByName().get('Aftersales Leads').getRecordTypeId();
      Set<id> leadIdsSet = new Set<id>();
      for(Lead__c lead:leadlist)
        {
          if((lead.RecordTypeId ==rc )||(lead.RecordTypeId == rc1))
            {
                if((( Trigger.isinsert  && lead.CAC_Lead_Status__c=='approved') || (Trigger.Isupdate && lead.CAC_Lead_Status__c=='approved'&& lead.CAC_Lead_Status__c!=leadOldMap.get(lead.id).CAC_Lead_Status__c) ) && lead.Assigned_Dealer__c!=null)
               { 
                // System.debug('lead.Assigned_Dealer__r.name'+lead.Assigned_Dealer__r.name);
                  asslist.add(lead.Assigned_Dealer__r.name);
                  leadIdsSet.add(lead.id);
               }
            }
        }
        for(Group assg:[select id ,Name ,Type from Group where Name IN:asslist] ){
               
           assgroupMap.put(assg.Name, assg.id);

        }
       
      for(Lead__c lead:leadlist) {
          if(leadIdsSet.contains(Lead.id)) {
                 
              if(assgroupMap.containskey(lead.Assigned_Dealer__r.Name)){
              //  system.debug('assgroupMap'+ assgroupMap);
                Lead__share l=new Lead__share();
                l.ParentId=lead.id;
                l.UserOrGroupId = assgroupMap.get(lead.Assigned_Dealer__r.Name);
                l.AccessLevel='edit';
                leadshare.add(l);
                Lead__c ld=new Lead__c();
                ld.Id = lead.id;
                ld.CAC_Lead_Status__c='Allocated';
                ld.Assigned_Date_Time__c=System.now();
                leads.add(ld);   
              }            
            }
          }
        
        insert leadshare;
        update leads;
        
    }
    
}