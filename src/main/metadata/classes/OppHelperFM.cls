/**
* Utility for Trigger on Opportunity for Factory Model
* It will handle the lead reassinment funtionality and validation rules of FM markets
* Author: Kaaviya Rathinam
* Created Date : 2018-08-10
*/

public without sharing  class  OppHelperFM{
    Public static User u= Utility_FM.getLoggedInUserInfo(); 
    Public static String Market = u.Market__c;

    public static boolean recursioncheck= true;
    Id SalesLeadRecordTypeId = RecordTypeAccessService.getRecordtypeID('Opportunity','Sales Lead');
    Id AfterSalesLeadRecordTypeId = RecordTypeAccessService.getRecordtypeID('Opportunity','Aftersales Lead');
    Id FinanceLeadRecordTypeId = RecordTypeAccessService.getRecordtypeID('Opportunity','Finance Lead');
    Id careRecordTypeId = RecordTypeAccessService.getRecordtypeID('Case','MB Complaint');
    OppHelperBase helperBase = new OppHelperBase();
    // it will handle the lead reassign functionality before inserting the lead  
    // When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    public void updateOwnerwithDealer(List<Opportunity> leads){
        helperBase.updateOwnerwithDealer(leads,Market); 
    }
    // it will handle the lead reassign(Dealer Gate Keeper/ Sales Consultant/Sales Advisor) functionality  
    public void updateOwner(List<Opportunity> leads){        
        helperBase.updateOwner(leads,Market);                 
    }
    
    // Conditions having When to Share Lead Record With Delaers
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
        helperBase.ShareRecordswithDealers(leadList,flag,market);        
    }
    
    // A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    Public void CreateRetailCopy(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        OppHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
    }
    
    public void CdmLeadcreate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap,string market)
    {
        helperBase.CdmLeadcreate(leadlist, leadOldMap,market);
    }
    
    public void updateRetailLookups(List < Opportunity> leadlist,string market){
        oppHelperbase.updateRetailLookups(Trigger.New,market);
    }
    
    //Added by Shashi- To check whether the address is available when the status of Opportunity is 'Order Placed'
    //Rajesh - added logic to look through opportunities only if stage is order placed and introduced label to check stage and show error
    public void checkAddress(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity o:oppList){
            if(o.StageName == System.Label.FMAddressValidationStage){
                accIdSet.add(o.AccountId);
            }
        }
        if (accIdSet.size() == 0){
            return;
        }
        Map<Id,Address__C> opAddressMap = new Map<Id,Address__C>();
        List<Address__c> addressList =[Select Address_Line_1__c, District__c, Province__c, Customer__c from Address__c where Customer__c IN :accIdSet];
        for(Address__c ad:addressList ){
            opAddressMap.put(ad.Customer__c,ad);
        }
        for(Opportunity o:oppList){
            if(o.StageName == System.Label.FMAddressValidationStage){
                Address__c address = opAddressMap.get(o.AccountId); 
                if(address== null){
                    o.addError(System.Label.FMAddressValidationStageError);
                }
            }
        }
    }
    
    //Added by Shashi- To change Customer Phase according to the Opportunity Added to the Account
    //updated during demo - to check of closed status via isClosed boolean field
    public void changeCustomerPhase(List<Opportunity> oppList){
        //Id SalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        Map<Id,Account> accSalesToUpdate = new Map<Id,Account>();
        Map<Id,Account> accServiceToUpdate = new Map<Id,Account>();
        Map<Id,List<Opportunity>> accOpMap= new Map<Id,List<Opportunity>>();
        List<Opportunity> opExistingList = new List<Opportunity>();
        List<account> salesList = new List<account>();
        List<account> afterSalessList = new List<account>();
        List<Case> caseList = new List<Case>();
        Map<Id,Id> mapAccCase= new Map<Id,Id>();
        for(Opportunity o:oppList){
            accIdSet.add(o.AccountId);
            //for update call
            if(o.Id!=null){
                oIdSet.add(o.Id);
            }
        }
        if(accIdSet!= null){        
            accList = [Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet];
            opExistingList=[Select Id, Name, AccountID, RecordTypeId,StageName,IsClosed from Opportunity where AccountId IN:accIdSet and Id Not IN:oIdSet];
            caseList=[Select Id, AccountID, Status, RecordTypeId from Case where AccountId IN:accIdSet and Status='Open' and RecordTypeId=:careRecordTypeId];
        }
        for(account a:accList){
            List<Opportunity> opList = new List<Opportunity>();
            for(Case c:caseList){
                if(a.Id==c.AccountId){
                    mapAccCase.put(a.Id,c.Id);
                }
            }
            for(Opportunity o:opExistingList){
                if(a.Id==o.AccountId){
                    opList.add(o);
                }   
            }
            for(Opportunity o:oppList){
                if(a.Id==o.AccountId){
                    opList.add(o);
                } 
            }
            accOpMap.put(a.Id,opList);
        }
        for(account a:accList){
            if(mapAccCase.get(a.Id)== null){
                for(Opportunity o:accOpMap.get(a.Id)){
                    if(o.RecordTypeId == SalesLeadRecordTypeId && o.IsClosed == false ){
                        a.Customer_Lifecycle_Phase__c = 'Sales';
                        accSalesToUpdate.put(a.Id,a);
                        if(accServiceToUpdate.containsKey(o.AccountId)){
                            accServiceToUpdate.remove(a.Id);
                        }
                    }
                    else if(o.RecordTypeId == AfterSalesLeadRecordTypeId && !accSalesToUpdate.containsKey(o.AccountId)){
                        a.Customer_Lifecycle_Phase__c = 'Service';
                        accServiceToUpdate.put(a.Id,a);
                    }
                }
            }
        } 
        salesList = accSalesToUpdate.values();
        afterSalessList = accServiceToUpdate.values();
        if(salesList!= null){
            update salesList;
        }
        if(afterSalessList!= null){
            update afterSalessList;
        }
    }
    
    //Added by Shashi- To Change the owner of Activities when Opportunity owner is changed
    //Updated by Rajesh during review to ensure if conditions check size prior to dml
    public void changeActivityOwner(List<Opportunity> oppList){
        Set<Id> opSet = new Set<Id>();
        Map<Id,Id> opOwnerMap = new Map<Id,Id>();
        List<Task> taskToUpdate = new List<Task>();
        List<Event> eventToUpdate = new List<Event>();
        for(Opportunity o:oppList){
            if(Trigger.oldMap!=null){
                Opportunity oldOp = (Opportunity)Trigger.oldMap.get(o.Id);
                if(oldOp != null && o.OwnerId != oldOp.OwnerId){
                    opSet.add(o.Id);
                    opOwnerMap.put(o.Id,o.OwnerId);
                }
            }                
        }
        List<Task> taskList = [Select Id, OwnerId, WhatId from Task where WhatID IN: opSet];
        List<Event> eventList = [Select Id, OwnerId, WhatId from Event where WhatID IN: opSet];
        for(Task t:taskList){
            if (t.ownerId != opOwnerMap.get(t.WhatId)){
                t.ownerId = opOwnerMap.get(t.WhatId);
                taskToUpdate.add(t);
            }
        }
        for(Event e:eventList){
            if (e.ownerId != opOwnerMap.get(e.WhatId)){
                e.ownerId = opOwnerMap.get(e.WhatId);
                eventToUpdate.add(e);
            }
        }
        if(taskToUpdate.size() > 0)
            update taskToUpdate;
        if (eventToUpdate.size() > 0)
            update eventToUpdate;
    }
    
    //Update Complaint creator department
    public void updateOpportunityGeneratedBy(List<Opportunity> oppList){
    User u;
    u = [SELECT Contact.AccountId  FROM User WHERE Id=:UserInfo.getUserId()] ;
        for(Opportunity opp:oppList){
            {
                if(Userinfo.getUserType() == 'PowerPartner'){
                    opp.Generated_by__c= 'Dealer';
                    opp.Assigned_Dealer__c= u.Contact.AccountId;//08222018 Namitha added to populate AssignedDealer for FS Auto Lead Scenario when Lead created by Dealer User.
                }
                else{
                    opp.Generated_by__c= 'MB';
                }
            }
        }
    }
    
    //Added : 06142018 Namitha -- To Update preferred contact date as created date +1 if it is not selected,consider business days
    public void updateOpportunityPreferredContactDate(List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            {
                if(opp.Preferred_Contact_Time__c == null){
                    datetime dt = DateTime.Now();
                    if(dt.format('EEEE') != 'Friday')
                        opp.Preferred_Contact_Time__c = dt.AddDays(1);
                    else
                    {   
                        //Added considering business days if opty created on Friday task followup should be due for monday.
                        opp.Preferred_Contact_Time__c = dt.AddDays(3);
                    }
                }
            }
        }
    }

  
 /*Added by Kaaviya Rathinam for Opty SLA functionality
       //UpdateSLATimeForOpportunity*/
 
 public static void calculateSLATime(List<Opportunity> oppList1)
    {   
        Set<ID> OpptyID = new Set<Id>();
        Integer hotHours;
        Integer coldHours;
        Integer warmHours;
        string country;
        Opp_Escalation__mdt customDate = [Select Id,Hot_Hours__c,Warm_Hours__c,Cold_Hours__c,BusinessHrCountry__c,Market__c from Opp_Escalation__mdt where Market__c =:Market];
        hotHours=Integer.valueOf(customdate.Hot_Hours__c);        
        warmHours=Integer.valueOf(customdate.Warm_Hours__c);
        coldHours=Integer.valueOf(customdate.Cold_Hours__c);
        country=string.valueOf(customdate.BusinessHrCountry__c);
        
        try{
            for(SObject obj:Trigger.new)
            {   
                Opportunity newo=(Opportunity)obj;
                Opportunity oldo;
                
                if(trigger.isupdate){
                    oldo=(Opportunity)trigger.oldmap.get(newo.id);
                }                
                //system.debug('<<old0'+oldo+'<<dealerName'+oldo.Assigned_Dealer__c);
                //system.debug('<<newo'+newo+'<<Dealer naem' +newo.Assigned_Dealer__c);
                if( oldo!=null && newo.Assigned_Dealer__c != oldo.Assigned_Dealer__c && trigger.isupdate)
                {                    
                    OpptyID.add(newo.id); 
                }                 
                else if(trigger.isInsert && newo!=null ){
                    OpptyID.add(newo.id);
                }
            }
            System.debug('<<OpptyID'+ OpptyID);
            if(OpptyID != null && OpptyID.size()>0)
            {
                system.debug('<<Entered IF condition'); 
                List<Opportunity> OppList = new List<Opportunity>();               
                OppList=[Select id,Lead_Temperature__c,Opp_SLA_Time__c,Assigned_Date_Time__c,Assigned_Dealer__c from Opportunity where id in : OpptyID];  
                System.debug('<<OppList'+OppList);
                list<Opportunity> OpptyToUpdate = new List<Opportunity>();
                //Please xplain abt the recursive check u used.
                if(OppHelperFM.recursioncheck)
                {
                    for(Opportunity opp : OppList)
                    {
                        System.debug('<<Entered For Loop1');
                        if(opp.Assigned_Dealer__c == null)
                        {
                            opp.Assigned_Date_Time__c=null;
                            opp.Opp_SLA_Time__c =null;
                            opp.StageName='New';
                            opp.SLA_Status__c=null;
                            System.debug('<<Entered IF Condition');
                        }
                        else{   
                            System.debug('<<Enterd Else block ');
                            opp.Assigned_Date_Time__c = Datetime.now();   
                            //Datetime dt = Datetime.now();
                            Datetime dt = opp.Assigned_Date_Time__c;  
                            opp.SLA_Status__c=null;
                            opp.StageName='Assigned';
                            BusinessHours bhrs = [Select Id from BusinessHours where Name = :country]; 
                            if(opp.Lead_Temperature__c=='hot') opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , hotHours * 60 * 60 * 1000L) ;    
                            else if (opp.Lead_Temperature__c=='warm')  opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , warmHours * 60 * 60 * 1000L) ;
                            else if (opp.Lead_Temperature__c=='cold')  opp.Opp_SLA_Time__c = BusinessHours.addGmt(bhrs.id, dt , coldHours * 60 * 60 * 1000L) ;   
                        }    
                        OpptyToUpdate.add(opp);   
                    }
                    
                    //Opp_SLA_Time__c
                    //Opp_Assigned_time__c
                    system.debug('<<Updaed succesfully');
                    update OpptyToUpdate;
                    recursioncheck = false;
                }
            }
        }
        catch(Exception e)
        {
            System.debug('<<Some Error has Come');
            system.debug(e.getMessage());
        }
        
    }
 
 
 //RelatedOpporunitySLA
 
 public static void updaterelatedOppRecord(List<Opportunity> opplist,Map<Id,Opportunity> oldmap){
 List<Opportunity_SLA__c> oppslalist = new List<Opportunity_SLA__c>();
 try{
 for(Opportunity opp : opplist){
 if(oldmap.get(opp.Id).SLA_Status__c != opp.SLA_Status__c){
            Opportunity_SLA__c sla = new Opportunity_SLA__c();
            //sla.Name = opp.Id;
            sla.Related_Opportunity__c = opp.Id;
            sla.Dealer_Name__c = opp.Assigned_Dealer__c;
            sla.Lead_Temperature__c = opp.Lead_Temperature__c;
            sla.Market__c = opp.Market__c;
            sla.Opp_SLA_Time__c = opp.Opp_SLA_Time__c;
            sla.SLA_Expired_Count__c = opp.SLA_Expired_Count__c;
            sla.SLA_Status__c = opp.SLA_Status__c;
            oppslalist.add(sla);
        }
    }
     if(!oppslalist.isEmpty()){
        insert oppslalist;
    }
    } catch(Exception e)
        {
            System.debug('<<Some Error has Come');
            system.debug(e.getMessage());
        }
   

 }
//Method to get the dealer gatekeepers based on assigned Dealer at opportunity
 public static map<ID,String> findGatekeepers(Set<ID> assignedDealers)
 {
     //soql on contact/Account to get gatekeeper emails based on assigned dealer at opportunity
     Map<ID,string> dealergkemail=new Map<ID,string>();
     List<Contact> conts=[SELECT Id, Name, Email, Account.Id FROM Contact where market__c= :market and Account.ispartner=True and Dealer_Lead_Gate_Keeper__c=True and Account.ID in :assignedDealers];
     for(contact c:conts)
        dealergkemail.put(c.Account.ID,c.Email);
    return dealergkemail;
     
 } 

}