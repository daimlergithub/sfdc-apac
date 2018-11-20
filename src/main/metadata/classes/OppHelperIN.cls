/**
* Utility for Trigger on Opportunity for India
* It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Honey
* Created Date : 2018-03-28
* Modified by: Shashi Goswami 2018-03-29
*/
public without sharing  class  OppHelperIN{
    String Market = System.Label.IN;
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
    
    //to set Lost date on closed lost opty
    public void updateLostDate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap){
        for (Opportunity lds: leadlist) {
            if (leadOldMap.containsKey(lds.Id) && lds.stagename != leadOldMap.get(lds.Id).stageName && lds.stageName == 'Closed Lost') {
                lds.Lost_Date__c = system.Today();
            }
        }
    }

    // Conditions having When to Share Lead Record With Delaers
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
        helperBase.ShareRecordswithDealers(leadList,flag,market);        
    }
    
    // A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    // A retail Copy (Reatil Person/ Retail Company)Will be Created in Dealer account automatically , if a dealer will be assigned to Lead 
    public void CreateRetailCopy(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        OppHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
       //To make call for create account link interface
       //Namitha: Added isUpdate condition below
      if(isUpdate || isInsert){
        set<ID> dealerId = new set<ID>();
          List<account_link__c> acc_Link;
          set<ID> OptyAcc = new set<ID>();
            For(Opportunity o : leadList){
               /* if((isInsert && ((Opportunity)Trigger.newMap.get(o.id)).assigned_dealer__c != NULL) || ((Trigger.oldMap != null && Trigger.oldMap.get(o.id) != null && ((Opportunity)Trigger.newMap.get(o.id)).assigned_dealer__c != ((Opportunity)Trigger.oldMap.get(o.id)).assigned_dealer__c) && ((Opportunity)Trigger.newMap.get(o.id)).assigned_dealer__c != NULL)){
                    dealerId.add(o.assigned_dealer__C);
                }*/
                if(o.assigned_dealer__C != NULL){
                    OptyAcc.add(o.AccountId); 
                    dealerId.add(o.assigned_dealer__C);
                }    
            }
            acc_Link = [select id,missing_flag__c,fromRole__c,toRole__c from Account_Link__c WHERE fromRole__c IN: dealerId and missing_flag__c = TRUE and toRole__c = :OptyAcc];
              
            if(acc_Link.size() > 0 )
                AccountLinkHelperBase.CDMAccountlinkContextGroup(acc_Link,Label.IN,Label.InsertContext); 
        } 
    }
    

	//Prem 09142018 Added to validate orderplaced Leads data before cdm call to prompt select assigned dealer and atleast one preferred interested vehicle.
    public void ValidateOrderPlacedforcdmcall(List<Opportunity> leadlist)
    {
        Id LeadDetRecordTypeId = RecordTypeAccessService.getRecordtypeID('Lead_Details__c','Interested Vehicle');
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Integer> oppLeadDetailsMap = new Map<Id,Integer>();
        for(Opportunity opp : leadlist){
            oppIdSet.add(opp.Id);
            oppLeadDetailsMap.put(opp.Id,0);
        }
        for(Lead_Details__c veh : [Select Car_Model__c,Preferred__c,Type__c,Related_Lead__c from Lead_Details__c where Related_Lead__c IN :oppIdSet AND Preferred__c = TRUE AND RecordTypeID  = :LeadDetRecordTypeId]){
            if(oppLeadDetailsMap.containsKey(veh.Related_Lead__c))
                oppLeadDetailsMap.put(veh.Related_Lead__c,oppLeadDetailsMap.get(veh.Related_Lead__c)+1);
            else
                oppLeadDetailsMap.put(veh.Related_Lead__c,1); 
        }
        for(Opportunity op : leadlist){
            if(oppLeadDetailsMap.containsKey(op.Id)){
                if(op.RecordTypeId==SalesLeadRecordTypeId && op.StageName == 'Order Placed' && (op.assigned_dealer__C == NULL || oppLeadDetailsMap.get(op.Id) != 1))
                    op.addError(System.Label.IN_Required_Dealer_for_OrderPlaces);
            }
        }
    }
    public void CdmLeadcreate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap,string market)
    {
        Set < Id > LeadIdinsert = new Set < Id > ();
        for(Opportunity op : leadlist){
	    if(op.RecordTypeId==SalesLeadRecordTypeId && op.StageName == 'Order Placed')
	            LeadIdinsert.add(op.Id);
        }
		if(!LeadIdinsert.isEmpty())
        	CDMInformatica_Services.createOpportunity(LeadIdinsert,market,'insert');
    }
    
    public void updateRetailLookups(List < Opportunity> leadlist,string market){
        oppHelperbase.updateRetailLookups(Trigger.New,market);
    }
    
    //Added by Shashi- To check whether the address is available when the status of Opportunity is 'Order Placed'
	//Rajesh - added logic to look through opportunities only if stage is order placed and introduced label to check stage and show error
    /*public void checkAddress(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity o:oppList){
			if(o.StageName == System.Label.INAddressValidationStage){
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
            if(o.StageName == System.Label.INAddressValidationStage){
                Address__c address = opAddressMap.get(o.AccountId); 
                if(address== null){
                    o.addError(System.Label.INAddressValidationStageError);
                }
            }
        }
    }
    */
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
    //this is not applicable to events, hence commented out for events
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
                    opp.Created_by_Segment__c = 'Dealer';
                    opp.Assigned_Dealer__c= u.Contact.AccountId;//08222018 Namitha added to populate AssignedDealer for FS Auto Lead Scenario when Lead created by Dealer User.
                }
                else{
                    opp.Created_by_Segment__c = 'MB';
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
			if (FinanceLeadRecordTypeId == o.RecordTypeId && o.Assigned_Dealer__c != null)
				accIdSet.add(o.Assigned_Dealer__c);
        }
		if (accIdSet == null || accIdSet.size() == 0)
			return;
        if(accIdSet != null){
            accList= [Select Id, FS_Gate_Keeper__c from Account where ID IN: accIdSet];
            accMap.putAll(accList);
        }
        for(Opportunity opp:oppList){
            if(FinanceLeadRecordTypeId == opp.RecordTypeId && opp.Assigned_Dealer__c != null){
                if(Trigger.oldMap!=null && accMap.get(opp.Assigned_Dealer__c) != null){
                    Opportunity oldOp = (Opportunity)Trigger.oldMap.get(opp.Id);
                    if(opp.Assigned_Dealer__c != oldOp.Assigned_Dealer__c && accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c != null){
                        opp.OwnerId = accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c;
                    }
                }  
                else if(Trigger.oldMap == null){
                    if(accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c != null){
                        opp.OwnerId = accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c;
                    }
                }
            }
        }
    }
    
    //Added : 07132018 Shashi- To create an FS lead when Sales Lead is assigned to Dealer
	//Updated: Rajesh - to make logic work only if it is a SalesleadRecordtype, added more fields to copy over to FS lead, called sharing logic, deadline update logic
    Public void createFSLead(List<Opportunity> oppList){
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accList= new List<Account>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        //Id FSRecordTypeId = RecordTypeAccessService.getRecordTypeId('Opportunity','Finance Lead');
        //Id SalesRecordTypeId = RecordTypeAccessService.getRecordTypeId('Opportunity','Sales Lead');

        for(Opportunity o:oppList){
            if (o.RecordTypeId==SalesLeadRecordTypeId){
                accIdSet.add(o.Assigned_Dealer__c);
            }
        }

        if(accIdSet != null){
            accList= [Select Id, FS_Gate_Keeper__c from Account where ID IN: accIdSet];
            accMap.putAll(accList);
        }
		else{
			return;
		}
        List<Opportunity> fsOpty = new List<Opportunity>();
        for(Opportunity opp:oppList){
            If(opp.RecordTypeId==SalesLeadRecordTypeId && opp.Assigned_Dealer__c != null && (Trigger.oldMap == null || (Trigger.oldMap != null && ((Opportunity)Trigger.oldMap.get(opp.Id)).Assigned_Dealer__c == null))){
                Opportunity o= new Opportunity(RecordTypeId= FinanceLeadRecordTypeId, name='FS '+opp.name, CloseDate=opp.CloseDate, StageName=System.Label.FSStageNew, Related_Leads__c = opp.Id,market__c = Market, md__c = Market,Type_of_Sale__c=opp.Type_of_Sale__c,Created_by_Segment__c=opp.Created_by_Segment__c,Assigned_Dealer__c=opp.Assigned_Dealer__c,Purchase_Time__c=opp.Purchase_Time__c,accountid=opp.accountid,Contact__c=opp.Contact__c,Preferred_Contact_Method__c=opp.Preferred_Contact_Method__c,Assigned_Date_Time__c=System.Datetime.now(),Retail_Company__c=opp.Retail_Company__c,Retail_Contact__c=opp.Retail_Contact__c);
                if(accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c != null){
                    o.OwnerId = accMap.get(opp.Assigned_Dealer__c).FS_Gate_Keeper__c;
                }
                else{
                    o.OwnerId = opp.OwnerId;
                }
                fsOpty.add(o);
            }
        }
        if (fsOpty.size() > 0){
            updateOppDeadline(fsOpty);
            insert fsOpty;
            helperBase.ShareRecordswithDealers(fsOpty,false,Market);
        }
    }
    
    //Added : 17/07/2018 Prem - to update deadline field on opportunity
	//Updated: Rajesh to remove hard coding of business hours, number of hours to deadline via labels.
    public void updateOppDeadline(List<Opportunity> oppList){
        String sIndBusHours = System.Label.IndiaFSBusinessHours;
        List<BusinessHours> lstIndiaBusinessHours = [Select Id from BusinessHours where Name= :sIndBusHours limit 1];
        if (lstIndiaBusinessHours == null || lstIndiaBusinessHours.size() ==0){
            system.debug('no business hours');
            return;
        }
        BusinessHours indiaBusinessHours = lstIndiaBusinessHours[0];
        DateTime slaDate = DateTime.newInstance(System.today().year(), System.today().month(), System.today().day(), 09, 00, 00);
        for(Opportunity opp : oppList){
            if(FinanceLeadRecordTypeId == opp.RecordTypeId){
                Integer iTimeInterval = (Integer.valueOf(System.Label.IndiaFSEscalationHours)) * 60 * 60 * 1000;
                opp.Opp_SLA_Time__c =BusinessHours.add(indiaBusinessHours.id,slaDate, iTimeInterval);
            }
        }
    }
    
}