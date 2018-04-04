/**
* Utility for Trigger on Opportunity for India
*It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Honey
* Created Date : 2018-03-28
* Modified by: Shashi Goswami 2018-03-29
*/
public without sharing  class  OppHelperIN{
   // private static final String salesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
   // private static final String afterSalesRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    String Market = System.Label.IN;
    
    OppHelperBase helperBase = new OppHelperBase();
    //it will handle the lead reassign functionality befor insert the lead  
    // Added by Laqshay Arora Test Case- When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    public void updateOwnerwithDealer(List<Opportunity> leads){
        helperBase.updateOwnerwithDealer(leads,Market); 
    }
  
    //Added by Asish Nanda, it will handle the lead reassign(Dealer Gate Keeper/ Sales Consultant/Sales Advisor) functionality  
    public void updateOwner(List<Opportunity> leads){        
            helperBase.updateOwner(leads,Market);                 
    }
  
    /*
    Added by : Asish Nanda
   Test Cases : Conditions having When to Share Lead Record With Delaers
    */
    
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
     helperBase.ShareRecordswithDealers(leadList,flag,market);        
    }
    
  // Added by Asish Nanda, Test Case-  A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    Public void CreateRetailCopy(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        OppHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
    }
  
   // Added by Asish Nanda to get a dynamic Url in Email For Dealer Gate Keeper to login to Malaysia Dealer Community 
    public void updatecommunityURL(List<Lead__c> Leadlist){
        LeadHelperBase.updatecommunityurl(Leadlist, Market);
    }
  
    public void CdmLeadcreate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap,string market)
    {
        helperBase.CdmLeadcreate(leadlist, leadOldMap,market);
    }
  
    public void updateRetailLookups(List < Opportunity> leadlist,string market){
    LeadHelperBase.updateRetailLookups(Trigger.New,market);
    }
    //Added by Shashi- To check the address is available when the status of Opportunity is 'Order Placed'
    public void checkAddress(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity o:oppList){
            accIdSet.add(o.AccountId);
        }
        Map<Id,Address__C> opAddressMap = new Map<Id,Address__C>();
        List<Address__c> addressList =[Select Address_Line_1__c, District__c, Province__c, Customer__c from Address__c where Customer__c IN :accIdSet];
        for(Address__c ad:addressList ){
           opAddressMap.put(ad.Customer__c,ad);
        }
        for(Opportunity o:oppList){
            if(o.StageName == 'Order placed' ){
               Address__c address = opAddressMap.get(o.AccountId); 
                if(address== null){
                    o.addError('Address of Related Account cannot be blank');
                }
            }
        }
    }
    
    //Added by Shashi- To change Customer Phase according to the Opportunity Added
    public void changeCustomerPhase(List<Opportunity> oppList){
        System.debug('entered Custom phase ');
        Id SalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
        Id AfterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordtypeID();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> oIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        Map<Id,Account> accSalesToUpdate = new Map<Id,Account>();
        Map<Id,Account> accServiceToUpdate = new Map<Id,Account>();
        Map<Id,List<Opportunity>> accOpMap= new Map<Id,List<Opportunity>>();
        List<Opportunity> opExistingList = new List<Opportunity>();
        List<account> salesList = new List<account>();
        List<account> afterSalessList = new List<account>();
        for(Opportunity o:oppList){
            accIdSet.add(o.AccountId);
            //for update call
            if(o.Id!=null){
                oIdSet.add(o.Id);
            }
        }
        System.debug('entered Custom phase accIdSet '+accIdSet);
        
        if(accIdSet!= null){        
            accList = [Select Id, Customer_Lifecycle_Phase__c from Account where ID IN: accIdSet];
            opExistingList=[Select Id, Name, AccountID, RecordTypeId,StageName from Opportunity where AccountId IN:accIdSet and Id Not IN:oIdSet];
        }
        
        for(account a:accList){
            List<Opportunity> opList = new List<Opportunity>();
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
            System.debug('entered Custom phase opList '+opList);
        }
        System.debug('entered Custom phase accOpMap '+accOpMap);
        for(account a:accList){
            System.debug('entered Custom phase a '+a);
            for(Opportunity o:accOpMap.get(a.Id)){
                System.debug('entered Custom phase o '+o);
                if(o.RecordTypeId == SalesLeadRecordTypeId && o.StageName!= 'Closed Won' && o.StageName!='Closed Lost' ){
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
        System.debug('entered Custom phase accSalesToUpdate '+accSalesToUpdate);
        System.debug('entered Custom phase accServiceToUpdate '+accServiceToUpdate);
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
    public void changeActivityOwner(List<Opportunity> oppList){
        Set<Id> opSet = new Set<Id>();
        Map<Id,Id> opOwnerMap = new Map<Id,Id>();
        List<Task> taskToUpdate = new List<Task>();
        List<Event> eventToUpdate = new List<Event>();
        for(Opportunity o:oppList){
            if(Trigger.oldMap!=null){
                Opportunity oldOp = (Opportunity)Trigger.oldMap.get(o.Id);
                if(o.OwnerId != oldOp.OwnerId){
                    opSet.add(o.Id);
                    opOwnerMap.put(o.Id,o.OwnerId);
                }
            }                
        }
        List<Task> taskList = [Select Id, OwnerId, WhatId from Task where WhatID IN: opSet];
        List<Event> eventList = [Select Id, OwnerId, WhatId from Event where WhatID IN: opSet];
        for(Task t:taskList){
            t.ownerId = opOwnerMap.get(t.WhatId);
            taskToUpdate.add(t);
        }
        for(Event e:eventList){
            e.ownerId = opOwnerMap.get(e.WhatId);
            eventToUpdate.add(e);
        }
        update taskToUpdate;
        update eventToUpdate;
    }
}