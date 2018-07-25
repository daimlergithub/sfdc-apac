/**
* Utility for Trigger on Opportunity for Turkey
*It will handle the lead reassinment funtionality and validation rules of MY market
* Author: Hildaa
* Created Date : 05/14/2018
**/
public without sharing  class  OppHelperTR{
   
    String Market = System.Label.TR;
    
    private static final String salesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity', System.Label.Sales_Lead);
    private static final String afterSalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Opportunity', System.Label.Aftersales_Lead);
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String alkContactSectorRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    set<id> accId = new set<id>();
    set<id> newmapid= new set<id>();
    Map<id, id> accUserMap = new Map<id, id>();
    
    public static boolean recursioncheck= true;
    OppHelperBase helperBase = new OppHelperBase();
    //it will handle the lead reassign functionality befor insert the lead  
    //  When a Dealer Will be assigned to a Lead , CAC Lead Status will be changed to Assigned and it Will auto-populate Assigned date time
    public void updateOwnerwithDealer(List<Opportunity> leads){
        List<Opportunity> leadslist=new List<Opportunity>();
        List<Opportunity> ldowner = new List<Opportunity>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Opportunity ld : leads){
            if(Ld.Sales_Consultant__c != NULL && (ld.RecordTypeId==salesRecordTypeId)){
                sConid.add(ld.Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        for(User usr : [Select id, contactID from user where contactID in :sConid]){
            mConToUsr.put(usr.contactID, usr.ID);
        }
        for(Opportunity l : leads){
            if((l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId) && l.Market__c==Market){               
                Boolean checkSAS= true;
                if((string.isnotblank(l.assigned_dealer__c))){
                    if (userInfo.getUserType() != 'PowerPartner' ) {
                        l.Assigned_Date_Time__c = System.now();
                        l.stageName = 'Assigned';
                    }
                }        
                if(string.isnotblank(l.Sales_Consultant__c) && l.RecordTypeId==salesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
                    l.ownerID = mConToUsr.get(L.Sales_Consultant__c);
                    checkSas=false;
                }
                else if(string.isnotblank(l.Assigned_Service_Advisor__c) && l.RecordTypeId==afterSalesRecordTypeId && string.isnotblank(l.assigned_dealer__c)){
                    l.ownerID = L.Assigned_Service_Advisor__c;
                    checkSas=false;
                }
                if(checkSas && (string.isnotblank(l.assigned_dealer__c))){
                    ldowner.add(l);
                    accId.add(l.assigned_dealer__c);    
                }
            }
        }
        if(!ldowner.isEmpty()){         
            if(accId.size()> 0){
                updateOwnership(accid,ldowner,Market);
            }
        }
    }
  
    //this method is common for before update and before insert of leadreassigning functionality   
    public Static void updateOwnership(set<id> acc, List<Opportunity> leadlist, string Market){
        Map<id, id> accUserMap = new Map<id, id>();
        if(acc.size()>0){
            accUserMap = OppHelperBase.getAccountToDLGKUser(acc);
        }
        for(Opportunity lists:leadlist){
            if(accUserMap.get(lists.assigned_dealer__c) !=null && lists.Market__c==Market){
                lists.ownerID = accUserMap.get(lists.assigned_dealer__c); 
            } 
            else if(lists.assigned_dealer__c!=null &&  accUserMap.get(lists.assigned_dealer__c) ==null){
                //  lists.addError('The Dealer Lead Gate Keeper user is either not present or is inactive.');
            }                             
        }
    }
    public void updateOwner(List<Opportunity> leads){        
           List<Opportunity> ldowner = new List<Opportunity>();
        Set<ID> sConid = new Set<ID>();
        Map<ID,ID> mConToUsr = new Map<ID,ID>();
        for(Opportunity ld : leads){
            if(((Opportunity)Trigger.newMap.get(ld.id)).Sales_Consultant__c != NULL && ld.RecordTypeId==salesRecordTypeId){
                sConid.add(((Opportunity)Trigger.newMap.get(ld.id)).Sales_Consultant__c);
            }
        }
        sConid.remove(NULL);
        if(sConid.size()>0){
            for(User usr : [Select id, contactID from user where contactID in :sConid]){
                mConToUsr.put(usr.contactID, usr.ID);
            }                              
        }
        for(Opportunity l : leads){
            if(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId){
                if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                    if (userInfo.getUserType() != 'PowerPartner' ) {
                        l.Assigned_Date_Time__c = System.now();
                        l.StageName = 'Assigned';
                    }
                }
                if(((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c !=((Opportunity)Trigger.oldMap.get(l.id)).Sales_Consultant__c && ((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c != NULL  && (l.RecordTypeId==salesRecordTypeId) && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL) {
                    l.ownerID = mConToUsr.get(((Opportunity)Trigger.newMap.get(l.id)).Sales_Consultant__c);
                }
                else if(((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c !=((Opportunity)Trigger.oldMap.get(l.id)).Assigned_Service_Advisor__c && ((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c != NULL  && ( l.RecordTypeId==afterSalesRecordTypeId) && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL){
                    l.ownerID = ((Opportunity)Trigger.newMap.get(l.id)).Assigned_Service_Advisor__c;
                }
                else if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c && ((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c != NULL)){
                    ldowner.add(l);
                    accId.add(l.assigned_dealer__c); 
                }
                else if((((Opportunity)Trigger.newMap.get(l.id)).assigned_dealer__c ==null && ((Opportunity)Trigger.oldMap.get(l.id)).assigned_dealer__c !=null)){
                    l.ownerId=l.createdbyId;
                    l.Assigned_Date_Time__c = NULL;
                    l.StageName = 'New';
                }
            }
            if(!ldowner.isEmpty() && userInfo.getUserType() != 'PowerPartner' ){
                
                if(accId.size()>0){
                    updateOwnership(accId,ldowner,market);
                }
            }
        }               
    }
  
   
    
    public  void ShareRecordswithDealers(List<Opportunity> leadlist,Boolean flag){
       Set < String > dealerndcodeset = new Set < String > ();
        set < Opportunity > lstlead = new set < Opportunity > ();
        set < OpportunityShare > leadshare = new set < OpportunityShare > ();
        set < id > leadsharingtorevoke = new set < id > ();
        set < String > sharingrevokefromgroups = new set < String > ();
        List < Opportunity > leadlisttoiterat = [select id, createdby.usertype, Market__c,createdby.Dealer_nd_code__c, assigned_dealer__c, assigned_dealer__r.Dealer_nd_code__c,assigned_dealer__r.Market__c,createdby.Market__c,MD__c from Opportunity where id IN: leadlist];
        //below if part will work at the time of insert
        for (Opportunity leadsrec: leadlisttoiterat) {
            if (!flag) {
                //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
                if (leadsrec.createdby.usertype == 'PowerPartner' && leadsrec.createdby.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.createdby.Market__c+leadsrec.createdby.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                } else if (leadsrec.assigned_dealer__c != null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
            } else {
                //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
                if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c == null && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                }
                //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
                else if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.oldMap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c != ((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c && leadsrec.assigned_dealer__r.Dealer_nd_code__c != null) {
                    string GrpName=leadsrec.assigned_dealer__r.Market__c+leadsrec.assigned_dealer__r.Dealer_nd_code__c;
                    dealerndcodeset.add(GrpName);
                    lstlead.add(leadsrec);
                    //will revoke record access depends on dealer nd code  if we change the assigned dealer
                    if (((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c != null) {
                        sharingrevokefromgroups.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).Market__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                        leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                    }
                }
                //if trigger old value is filled and new value did not filled then revoke access from old Dealer
                else if (((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__c != null && ((Opportunity) trigger.newmap.get(leadsrec.id)).assigned_dealer__c == null) {
                    sharingrevokefromgroups.add(leadsrec.Market__c+((Opportunity) trigger.oldmap.get(leadsrec.id)).assigned_dealer__r.Dealer_nd_code__c);
                    leadsharingtorevoke.add(((Opportunity) trigger.oldmap.get(leadsrec.id)).id);
                }
            }
        }
        for (Group gp: [select id, name from Group where name IN: dealerndcodeset]) {
            for (Opportunity leadid: lstlead) {
                //this if part will applicable for Salesforce users
                string grpname=(leadid.Market__c+leadid.assigned_dealer__r.Dealer_nd_code__c);
                string grpCname=(leadid.createdby.Market__c+leadid.createdby.Dealer_nd_code__c );
                if (gp.name == grpname) {
                    leadshare.add(new opportunityshare(opportunityid= leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, OpportunityAccessLevel = 'EDIT'));
                } //this else part will applicable for Dealer users
                else if (gp.name == grpCname && leadid.createdby.Usertype == 'PowerPartner') {
                    leadshare.add(new opportunityshare(opportunityid= leadid.id, UserOrGroupId = gp.id, RowCause = Schema.Lead__share.Rowcause.manual, OpportunityAccessLevel = 'EDIT'));
                }
            }
        }
        //else part will work at the time of Update
        if (leadshare.size() > 0) {
            List < OpportunityShare > leadshareList = new List < OpportunityShare > ();
            leadshareList.addall(leadshare);
            Database.insert(leadshareList);
            if (leadsharingtorevoke.size() > 0) {
                database.delete([select id,opportunityid from OpportunityShare where opportunityid IN: leadsharingtorevoke and UserOrGroupId IN: sharingrevokefromgroups]);
            }
        }      
    }
    
  
    Public void CreateRetailCopy(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap, boolean isInsert, boolean isUpdate,string market) {
        OppHelperBase.CheckRetailCopy( leadlist,  leadOldMap,  isInsert,  isUpdate, market);
    }
  
   
    public void CdmLeadcreate(List < Opportunity> leadlist, map < id, Opportunity> leadOldMap,string market)
    {
        Set < Id > LeadIdinsert = new Set < Id > ();
        for(Opportunity op : leadlist){
	    if(op.RecordTypeId==salesRecordTypeId)
	            LeadIdinsert.add(op.Id);
        }
	if(!LeadIdinsert.isEmpty())
        	CDMInformatica_Services.createOpportunity(LeadIdinsert,market,'insert');
    }
  
    public void updateRetailLookups(List < Opportunity> leadlist,string market){
    for(Opportunity le:Leadlist){
            if (string.isblank(le.Assigned_Dealer__c) && le.Market__c== Market) {
                le.Retail_Contact__c=NULL;
                le.Retail_Company__c=NULL;
            }
        } 
    }
    
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
    
    
    public void changeCustomerPhase(List<Opportunity> oppList){
        System.debug('entered Custom phase ');
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
        System.debug('entered Custom phase accIdSet '+accIdSet);
        
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
            System.debug('entered Custom phase opList '+opList);
        }
        System.debug('entered Custom phase accOpMap '+accOpMap);
        for(account a:accList){
            System.debug('entered Custom phase a '+a);
            if(mapAccCase.get(a.Id)== null){
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
    //UpdateSLATimeForOpportunity
 
 public static void calculateSLATime(List<Opportunity> oppList1)
    {   
        Set<ID> OpptyID = new Set<Id>();
        Integer hotHours;
        Integer coldHours;
        Integer warmHours;
        string country;
        Opp_Escalation__mdt customDate = [Select Id,Hot_Hours__c,Warm_Hours__c,Cold_Hours__c,BusinessHrCountry__c,Market__c from Opp_Escalation__mdt where Market__c=:Label.TR];
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
                if(OppHelperTR.recursioncheck)
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
 
    
}