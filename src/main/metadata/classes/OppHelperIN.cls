/**
* Utility for Trigger on Opportunity for India
* It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Honey
* Created Date : 2018-03-28
* Modified by: Shashi Goswami 2018-03-29
*/
public without sharing  class  OppHelperIN{
    String Market = System.Label.IN;
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
    
    //Added by Shashi- To change Customer Phase according to the Opportunity Added to the Account
    public void changeCustomerPhase(List<Opportunity> oppList){
        Id SalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
        Id AfterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordtypeID();
        Id careRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordtypeID();
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
            opExistingList=[Select Id, Name, AccountID, RecordTypeId,StageName from Opportunity where AccountId IN:accIdSet and Id Not IN:oIdSet];
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
    
    //Update Complaint creator department
    public void updateOpportunityGeneratedBy(List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            {
                if(Userinfo.getUserType() == 'PowerPartner'){
                    opp.Generated_by__c= 'Dealer';
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
    
    //Added : 07132018 Shashi - To Update Owner of an FS Opportunity when Dealer is assigned
    public void updateFSOwner(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accList= new List<Account>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Opportunity o:oppList){
            accIdSet.add(o.Assigned_Dealer__c);
        }
        if(accIdSet != null){
            accList= [Select Id, FS_Gate_Keeper__c from Account where ID IN: accIdSet];
            accMap.putAll(accList);
        }
        for(Opportunity opp:oppList){
            if(UtilRecordType.getRecordTypeNameById('Opportunity',opp.RecordTypeId) == 'Finance Lead' && opp.Assigned_Dealer__c != null){
                if(Trigger.oldMap!=null && accMap.get(opp.Assigned_Dealer__c) != null){
                    Opportunity oldOp = (Opportunity)Trigger.oldMap.get(opp.Id);
                    system.debug('oldOp.Assigned_Dealer__c...'+oldOp.Assigned_Dealer__c);
                    if(opp.Assigned_Dealer__c != oldOp.Assigned_Dealer__c && accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c != null){
                        opp.OwnerId = accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c;
                        System.debug('opp.OwnerId:'+opp.OwnerId);
                        System.debug('opp.Assigned_Dealer__r.FS_Gate_Keeper__r.Id:'+opp.Assigned_Dealer__r.FS_Gate_Keeper__r.Id);
                    }
                }  
                else if(Trigger.oldMap == null){
                    if(accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c != null){
                        opp.OwnerId = accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c;
                        System.debug('opp.OwnerId:'+opp.OwnerId);
                    }
                }
            }
        }
    }
    
    //Added : 07132018 Shashi- To create an FS lead when Sales Lead is assigned to Dealer
    Public void createFSLead(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accList= new List<Account>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Id FSRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity','Finance Lead');
        Id SalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity','Sales Lead');

        for(Opportunity o:oppList){
            accIdSet.add(o.Assigned_Dealer__c);
        }
        if(accIdSet != null){
            accList= [Select Id, FS_Gate_Keeper__c from Account where ID IN: accIdSet];
            accMap.putAll(accList);
        }
        for(Opportunity opp:oppList){
            if(Trigger.oldMap!=null){
                Opportunity oldOp = (Opportunity)Trigger.oldMap.get(opp.Id);
                If(opp.RecordTypeId==SalesRecordTypeId && opp.Assigned_Dealer__c != null && oldOp.Assigned_Dealer__c == null){
                    Opportunity o= new Opportunity(OwnerId=accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c, RecordTypeId= FSRecordTypeId, name='FS '+opp.name, CloseDate=opp.CloseDate, StageName='New', ForecastCategoryName='Pipeline', Related_Leads__c = opp.Id);
                    Insert o;
                }
            }
            else if(opp.RecordTypeId==SalesRecordTypeId && opp.Assigned_Dealer__c != null){
                Opportunity o= new Opportunity(OwnerId=accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c, RecordTypeId= FSRecordTypeId, name='FS '+opp.name, CloseDate=opp.CloseDate, StageName='New', ForecastCategoryName='Pipeline', Related_Leads__c = opp.Id);
                Insert o;

            }
        }
    }
    
    //Added : 17/07/2018 Prem - to update deadline field on opportunity
    public void updateOppDeadline(List<Opportunity> oppList){
        List<BusinessHours> lstIndiaBusinessHours = [Select Id from BusinessHours where Name='India' limit 1];
        if (lstIndiaBusinessHours == null || lstIndiaBusinessHours.size() ==0){
            system.debug('no business hours');
            return;
        }
        BusinessHours indiaBusinessHours = lstIndiaBusinessHours[0];
        DateTime slaDate = DateTime.newInstance(System.today().year(), System.today().month(), System.today().day(), 09, 00, 00);
        for(Opportunity opp : oppList){
            if(UtilRecordType.getRecordTypeNameById('Opportunity', opp.RecordTypeId) == 'Finance Lead'){
                for(Integer i=0; i<3; ){
                    slaDate = slaDate.addDays(1);
                    if(BusinessHours.isWithin(indiaBusinessHours.Id, slaDate))
                        i++;
                }
                opp.Opp_SLA_Time__c = slaDate;
                //opp.Opp_SLA_Time__c = System.now().addMinutes(1);
            }
        }
    }
}