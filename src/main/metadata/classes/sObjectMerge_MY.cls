public class sObjectMerge_MY {
    static Id vehicleReltnshpRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    static Id vehicleReltnshpRetailRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    static Id vehicleReltnshpSoftDelRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Soft Deleted').getRecordTypeId();
    static Id SalesLeadsSoftDeletedRecordTypeId=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads Soft Deleted').getRecordTypeId();
    static Id AfterSalesLeadsSoftDeletedRecordTypeId=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('After-Sales Leads Soft Deleted').getRecordTypeId();    
    static Id SalesLeadsRecordTypeId=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    static Id AfterSalesLeadsRecordTypeId=Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    static Id SoftdeletedPersonAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Soft Deleted').getRecordTypeId();
    static Id SoftdeletedCompanyAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company Soft Deleted').getRecordTypeId();
    static Id CompanyAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    static Id PersonAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();


    public static Boolean mergeCase(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap){
        Boolean isSuccess = false;
        List<case> Listcase= new List<Case>();
        for(Case CaseObj:[select Id,ContactID,Accountid, Account.RecordTypeId from Case where Accountid IN:duplicateCustmrId2MasterCustmerIdMap.keySet()])
        {
            if(CaseObj.Account.RecordTypeId == SoftdeletedPersonAccountRecordTypeId){
                CaseObj.AccountID = duplicateCustmrId2MasterCustmerIdMap.get(CaseObj.AccountID);
                CaseObj.ContactID = duplicateCustmrId2MasterCustmerIdMap.get(CaseObj.AccountID);
                Listcase.add(CaseObj); 
            }
            else if(CaseObj.Account.RecordTypeId == SoftdeletedCompanyAccountRecordTypeId){
                CaseObj.AccountID = duplicateCustmrId2MasterCustmerIdMap.get(CaseObj.AccountID);
                Listcase.add(CaseObj); 
            }
        }
        if(!ListCase.isEmpty()){
            try{
                update Listcase;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Cases '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;
    }
 /* Added by sravanthi gudibandi for KR Market for merging loyalty card object---start*/
    public static Boolean mergeLoyaltycard(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap){
        Boolean isSuccess = false;
        List<Loyalty_Card__c> Listloyaltycard= new List<Loyalty_Card__c>();
        for(Loyalty_Card__c loyaltycardObj:[select Id,Account__c, Account__r.RecordTypeId from Loyalty_Card__c where Account__c IN:duplicateCustmrId2MasterCustmerIdMap.keySet()])
        {
            if(loyaltycardObj.Account__r.RecordTypeId == SoftdeletedPersonAccountRecordTypeId){
                if(duplicateCustmrId2MasterCustmerIdMap.get(loyaltycardObj.Account__c)!=null)
                    loyaltycardObj.Account__c = duplicateCustmrId2MasterCustmerIdMap.get(loyaltycardObj.Account__c);
                Listloyaltycard.add(loyaltycardObj); 
            }
            else if(loyaltycardObj.Account__r.RecordTypeId == SoftdeletedCompanyAccountRecordTypeId){
                if(duplicateCustmrId2MasterCustmerIdMap.get(loyaltycardObj.Account__c)!=null)
                    loyaltycardObj.Account__c = duplicateCustmrId2MasterCustmerIdMap.get(loyaltycardObj.Account__c);
                Listloyaltycard.add(loyaltycardObj); 
            }
        }
        if(!Listloyaltycard.isEmpty()){
            try{
                update Listloyaltycard;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Loyalty card '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;
    }
    /* Added by sravanthi gudibandi for KR Market for merging loyalty card object---End*/
    
    /* Added by sravanthi gudibandi for KR Market for merging Booking object---start*/ 
    public static Boolean mergeBooking(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap){
        Boolean isSuccess = false;
        List<Booking__c> Listbooking= new List<Booking__c>();
        List<Booking__c> bookings = [select Id,Sales_Consultant_ID__r.AccountID, Sales_Consultant_ID__r.Account.RecordTypeId from Booking__c where Sales_Consultant_ID__r.AccountID IN:duplicateCustmrId2MasterCustmerIdMap.keySet()]; 
        Map<Id,Id> personaccMap = new Map<Id,Id>();
        Set<Id> masAccs = new Set<Id>();
        for(Id key: duplicateCustmrId2MasterCustmerIdMap.keySet()){
            masAccs.add(duplicateCustmrId2MasterCustmerIdMap.get(key));
        }
        List<Account> acns = [SELECT Id,PersonContactId FROM Account WHERE Id IN: masAccs];
        for(Account ac: acns)
        {
            personaccMap.put(ac.Id,ac.PersonContactId);
        }
        for(Booking__c BookingObj: bookings)
        {            
            if(BookingObj.Sales_Consultant_ID__r.Account.RecordTypeId == SoftdeletedPersonAccountRecordTypeId){
                if(duplicateCustmrId2MasterCustmerIdMap.get(BookingObj.Sales_Consultant_ID__r.AccountID)!=null){
                    Id accId = duplicateCustmrId2MasterCustmerIdMap.get(BookingObj.Sales_Consultant_ID__r.AccountID);
                    BookingObj.Sales_Consultant_ID__c = personaccMap.get(accId);
                    Listbooking.add(BookingObj); 
                }
            }
            else if(BookingObj.Sales_Consultant_ID__r.Account.RecordTypeId == SoftdeletedCompanyAccountRecordTypeId){
                if(duplicateCustmrId2MasterCustmerIdMap.get(BookingObj.Sales_Consultant_ID__r.AccountID)!=null){
                    Id accId = duplicateCustmrId2MasterCustmerIdMap.get(BookingObj.Sales_Consultant_ID__r.AccountID);
                    BookingObj.Sales_Consultant_ID__c = personaccMap.get(accId);
                    Listbooking.add(BookingObj); 
                }
            }
        }
        System.debug('Listbooking '+ Listbooking);
        if(!Listbooking.isEmpty()){
            try{
                update Listbooking;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Booking '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;
    }
    /* Added by sravanthi gudibandi for KR Market for merging Booking object---End*/

    public static Boolean mergeLead(List<Duplicate_Merge_Info__c> ldupMergeObj)
    {
        Boolean isSuccess = false;
        Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap=new Map<Id,Id>();
        Map<Id,Id> mduplicateRTToMasterRT=new Map<Id,Id>();
        List<Lead__c> LeadList= new List<Lead__c>();
        for(Duplicate_Merge_Info__c dupMergeObj: ldupMergeObj){
            duplicateCustmrId2MasterCustmerIdMap.put(dupMergeObj.Duplicate_Customer__c, dupMergeObj.Master_Customer__c);
            mduplicateRTToMasterRT.put(dupMergeObj.Duplicate_Retail_Customer__c, dupMergeObj.Master_Retail_Customer__c);
        }
        
        for(Lead__c leadObj:[select Id,Contact__c,Contact__r.RecordTypeId,Company_Account__c,Company_Account__r.RecordTypeId,Retail_Contact__c,recordtypeId from Lead__c where Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.keySet()]){
            if(leadObj.Contact__r.RecordTypeId == SoftdeletedPersonAccountRecordTypeId){
            leadObj.Contact__c = duplicateCustmrId2MasterCustmerIdMap.get(leadObj.Contact__c);
            leadObj.Retail_Contact__c = leadObj.Retail_Contact__c != NULL ? mduplicateRTToMasterRT.get(leadObj.Retail_Contact__c) : NULL;
            LeadList.add(leadObj);
            }
            else if(leadObj.Company_Account__r.RecordTypeId == SoftdeletedCompanyAccountRecordTypeId){
            leadObj.Company_Account__c = duplicateCustmrId2MasterCustmerIdMap.get(leadObj.Company_Account__c);
            leadObj.Retail_Contact__c = leadObj.Retail_Contact__c != NULL ? mduplicateRTToMasterRT.get(leadObj.Retail_Contact__c) : NULL;
            LeadList.add(leadObj);
            }
        }
        
        if(!LeadList.isEmpty()){
            try{
                update LeadList;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Leads '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;    
    }  
    
    public static Boolean mergeOpportunity(List<Duplicate_Merge_Info__c> ldupMergeObj)
    {
        Boolean isSuccess = false;
        Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap=new Map<Id,Id>();
        Map<Id,Id> mduplicateRTToMasterRT=new Map<Id,Id>();
        List<Opportunity> LeadList= new List<Opportunity>();
        for(Duplicate_Merge_Info__c dupMergeObj: ldupMergeObj){
            duplicateCustmrId2MasterCustmerIdMap.put(dupMergeObj.Duplicate_Customer__c, dupMergeObj.Master_Customer__c);
            mduplicateRTToMasterRT.put(dupMergeObj.Duplicate_Retail_Customer__c, dupMergeObj.Master_Retail_Customer__c);
        }
        
        for(Opportunity leadObj:[select Id,AccountId,Account.RecordTypeId,recordtypeId from Opportunity where AccountId IN:duplicateCustmrId2MasterCustmerIdMap.keySet()]){
            if(leadObj.Account.RecordTypeId == SoftdeletedPersonAccountRecordTypeId){
            leadObj.AccountId = duplicateCustmrId2MasterCustmerIdMap.get(leadObj.AccountId);
            LeadList.add(leadObj);
            }
            else if(leadObj.Account.RecordTypeId == SoftdeletedCompanyAccountRecordTypeId){
            leadObj.AccountId = duplicateCustmrId2MasterCustmerIdMap.get(leadObj.AccountId);
            LeadList.add(leadObj);
            }
        }
        
        if(!LeadList.isEmpty()){
            try{
                update LeadList;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Leads '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;    
    }  
    
    public static Boolean mergeRetailTask(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap){
        Boolean isSuccess = false;
        List<Retail_Task__c> ListRT= new List<Retail_Task__c>();
        for(Retail_Task__c RTObj:[select Id, Related_Contact__c,Account__c,Related_Contact__r.recordtypeId, MD__c from Retail_Task__c where Related_Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.keySet()])
        {
            if(RTObj.Related_Contact__r.recordtypeId == SoftdeletedPersonAccountRecordTypeId || RTObj.Related_Contact__r.recordtypeId == SoftdeletedCompanyAccountRecordTypeId){
                RTObj.Related_Contact__c = duplicateCustmrId2MasterCustmerIdMap.get(RTObj.Related_Contact__c);
                RTObj.Account__c = duplicateCustmrId2MasterCustmerIdMap.get(RTObj.Account__c );
                ListRT.add(RTObj); 
            }
        }
        if(!ListRT.isEmpty()){
            try{
                update ListRT;
                isSuccess = true;
                return isSuccess;
            }catch(Exception e){
                System.debug('Failed while re-parenting Retail Tasks '+ e.getMessage());
                return isSuccess;
            }
        }
        return isSuccess=true;
    } 
    
       //merge vehicle relationships records
    //Example: Duplicate AccountName-MBAccount.
    //         VRs of duplicate Account: VR1,VR2,VR3,VR4
    //         Golden AccountName-MBAccount
    //         VRs of Golden Account: VR4,VR5,VR6
    //         After merge, output is:
    //         VRs of Golden Account: VR1,VR2,VR3,VR4,VR5,VR6
    public static Boolean mergeVR(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
        Boolean isSuccess = false;
        //get vehicle relationship records from duplicate accounts.
        List<Vehicle_Relationship__c> vrForDuplicateAccountList=[select Id,Contact__c,car_relation__c,Euro_Vin__c,recordtypeId,Selling_Dealer__c,Selling_Dealer__r.Dealer_ND_Code__c,Owner_Dealer__c,Owner_Dealer__r.Dealer_ND_Code__c from Vehicle_Relationship__c where Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.keySet() and Contact__c != null and Vehicle_ID__c!=null and recordTypeID!=:vehicleReltnshpSoftDelRecordTypeId]; 
        Map<Id,List<Vehicle_Relationship__c>> duplicateCustmrId2LstVrMap=new Map<Id,List<Vehicle_Relationship__c>>();
        if(vrForDuplicateAccountList!=null && vrForDuplicateAccountList.size()>0)
        {
            for(Vehicle_Relationship__c vrObj:vrForDuplicateAccountList)
            {
                if(!duplicateCustmrId2LstVrMap.containsKey(vrObj.Contact__c))
                    duplicateCustmrId2LstVrMap.put(vrObj.Contact__c, new List<Vehicle_Relationship__c>{vrObj});
                else
                    duplicateCustmrId2LstVrMap.get(vrObj.Contact__c).add(vrObj);
            }
        }
        //get vehicle relationship records from Golden accounts.
        List<Vehicle_Relationship__c> vrForGoldenAccountList=[select Id,Contact__c,car_relation__c,Euro_Vin__c,recordtypeId,Selling_Dealer__c,Selling_Dealer__r.Dealer_ND_Code__c,Owner_Dealer__c,Owner_Dealer__r.Dealer_ND_Code__c from Vehicle_Relationship__c where Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.values() and Contact__c != null and Vehicle_ID__c!=null and recordTypeID!=:vehicleReltnshpSoftDelRecordTypeId]; 
        Map<Id,List<Vehicle_Relationship__c>> goldenCustmrId2LstVrMap=new Map<Id,List<Vehicle_Relationship__c>>();
        if(vrForGoldenAccountList!=null && vrForGoldenAccountList.size()>0)
        {
            for(Vehicle_Relationship__c vrObj:vrForGoldenAccountList)
            {
                if(!goldenCustmrId2LstVrMap.containsKey(vrObj.Contact__c))
                    goldenCustmrId2LstVrMap.put(vrObj.Contact__c, new List<Vehicle_Relationship__c>{vrObj});
                else
                    goldenCustmrId2LstVrMap.get(vrObj.Contact__c).add(vrObj);
            }
        }
        Set<Vehicle_Relationship__c> dupVehicleRelnshpSet=new Set<Vehicle_Relationship__c>();
        //logic for comparing vehicle relationship between duplicate and golden accounts.
        if(duplicateCustmrId2LstVrMap!=null && duplicateCustmrId2LstVrMap.size()>0)
        {
            for(Id dupCustId:duplicateCustmrId2LstVrMap.keySet())
            {
                List<Vehicle_Relationship__c> dupVRLst=duplicateCustmrId2LstVrMap.get(dupCustId);
                List<Vehicle_Relationship__c> goldenVRLst=goldenCustmrId2LstVrMap.get(duplicateCustmrId2MasterCustmerIdMap.get(dupCustId));
                for(Vehicle_Relationship__c dupVrObj:dupVRLst)
                {
                    boolean isRecordFound=false;
                    boolean isVRretailWithSameDealer=false;
                    boolean isVRretailWithDiffDealer=false;
                    boolean isVRwithSameDealer=false;
                    boolean isVRwithDiffDealer=false;
                    if(goldenVRLst!=null && goldenVRLst.size()>0)
                    {
                        for(Vehicle_Relationship__c goldenVrObj:goldenVRLst)
                        {
                            //if duplicate VR record found
                            if(dupVrObj.RecordTypeId==goldenVrObj.RecordTypeId && dupVrObj.Euro_Vin__c==goldenVrObj.Euro_Vin__c && dupVrObj.Car_Relation__c==goldenVrObj.Car_Relation__c)
                            {
                                isRecordFound=true;
                                //check if they are under same dealership with vehicle relationship(Wholesale) record type
                                if(dupVrObj.RecordTypeId==vehicleReltnshpRecordTypeId && dupVrObj.Selling_Dealer__c!=null && goldenVrObj.Selling_Dealer__c!=null && dupVrObj.Selling_Dealer__r.Dealer_ND_Code__c==goldenVrObj.Selling_Dealer__r.Dealer_ND_Code__c)
                                {
                                    isVRwithSameDealer=true;  
                                    break;
                                }//check if they are under different dealership with vehicle relationship(Wholesale) record type
                                else if(dupVrObj.RecordTypeId==vehicleReltnshpRecordTypeId && dupVrObj.Selling_Dealer__c!=null && goldenVrObj.Selling_Dealer__c!=null && dupVrObj.Selling_Dealer__r.Dealer_ND_Code__c!=goldenVrObj.Selling_Dealer__r.Dealer_ND_Code__c)
                                {
                                    isVRwithDiffDealer=true;
                                    break;
                                }//check if they are under same dealership with vehicle relationship retail record type
                                else if(dupVrObj.RecordTypeId==vehicleReltnshpRetailRecordTypeId && dupVrObj.Owner_Dealer__c!=null && goldenVrObj.Owner_Dealer__c!=null && dupVrObj.Owner_Dealer__r.Dealer_ND_Code__c==goldenVrObj.Owner_Dealer__r.Dealer_ND_Code__c)
                                {
                                    isVRretailWithSameDealer=true;
                                    break;
                                }//check if they are under different dealership with vehicle relationship retail record type
                                else if(dupVrObj.RecordTypeId==vehicleReltnshpRetailRecordTypeId && dupVrObj.Owner_Dealer__c!=null && goldenVrObj.Owner_Dealer__c!=null && dupVrObj.Owner_Dealer__r.Dealer_ND_Code__c!=goldenVrObj.Owner_Dealer__r.Dealer_ND_Code__c)
                                {
                                    isVRretailWithDiffDealer=true;
                                    
                                }
                            }
                        }
                    }
                    //if vehicle relationship record(wholesale) under same dealer or different. 
                    //if vehicle realtionship retail record under same dealer.  
                    if((isVRwithSameDealer || isVRwithDiffDealer || isVRretailWithSameDealer) && isRecordFound)
                    {
                        dupVrObj.RecordTypeId=vehicleReltnshpSoftDelRecordTypeId;
                        dupVrObj.Contact__c=duplicateCustmrId2MasterCustmerIdMap.get(dupCustId);
                        dupVehicleRelnshpSet.add(dupVrObj);
                    }
                    
                    //if vehicle relationship record is not found in golden account 
                    //if Vehicle relationship retail record have different dealer
                    if(!isRecordFound || (!isVRretailWithSameDealer && isVRretailWithDiffDealer))
                    {
                        dupVrObj.Contact__c=duplicateCustmrId2MasterCustmerIdMap.get(dupCustId);
                        dupVehicleRelnshpSet.add(dupVrObj);
                    }
                }
            }
            if(dupVehicleRelnshpSet!=null && dupVehicleRelnshpSet.size()>0)
            {
                List<Vehicle_Relationship__c> dupVehicleRelnshpList=new List<Vehicle_Relationship__c>();
                dupVehicleRelnshpList.addAll(dupVehicleRelnshpSet);
                try{
                    update dupVehicleRelnshpList;
                    isSuccess = true;
                    return isSuccess;
                }catch(Exception e){
                    System.debug('Failed while repareting VR records MY ' + e.getMessage());
                    return isSuccess;
                }
            }
                
        }
        return isSuccess=true;
    }
    
    //merge open activites
    //Example: Duplicate AccountName-MBAccount
    //         Task & events of MBAccount-T1,T2,E1,E2
    //         Golden AccountName-MBAccount
    //         After Merge, output is:
    //         Task & events of MBAccount(Golden)-T1,T2,E1,E2
    public static Boolean mergeOpenActivities(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
        Boolean isSuccess = false;
        //get open task from duplicate account
        List<Task> openTaskOfDupAccount=[Select Id,WhatId from Task where WhatId IN:duplicateCustmrId2MasterCustmerIdMap.keySet() and status!='Closed'];
        if(openTaskOfDupAccount!=null && openTaskOfDupAccount.size()>0)
        {
            Map<Id,List<Task>> dupAccountId2LstDupTaskMap=new Map<Id,List<Task>>();
            for(Task taskobj:openTaskOfDupAccount)
            {
                if(!dupAccountId2LstDupTaskMap.containsKey(taskobj.whatId))
                    dupAccountId2LstDupTaskMap.put(taskobj.whatId, new List<Task>{taskobj});
                else
                    dupAccountId2LstDupTaskMap.get(taskobj.whatId).add(taskobj);
            }
            if(dupAccountId2LstDupTaskMap!=null && dupAccountId2LstDupTaskMap.size()>0)
            {
                List<Task> tasksTobeUpdatedLst=new List<Task>();
                for(Id dupAccountId:dupAccountId2LstDupTaskMap.keySet())
                {
                    List<Task> openTaskLst=dupAccountId2LstDupTaskMap.get(dupAccountId);
                    for(Task taskObj:openTaskLst)
                    {
                        //assign task to golden account.
                        taskObj.WhatId=duplicateCustmrId2MasterCustmerIdMap.get(dupAccountId);
                        tasksTobeUpdatedLst.add(taskObj);
                    }
                }
                if(tasksTobeUpdatedLst!=null && tasksTobeUpdatedLst.size()>0){
                    try{
                        update tasksTobeUpdatedLst;
                    }catch(Exception e){
                        System.debug('Failed while repareting Open Activities '+ e.getMessage());
                        return isSuccess;
                    }
                }
                    
            }
        }
        
        //get open events from duplicate account
        List<Event> openEventOfDupAccount=[Select Id,WhatId from Event where WhatId IN:duplicateCustmrId2MasterCustmerIdMap.keySet()];
        if(openEventOfDupAccount!=null && openEventOfDupAccount.size()>0)
        {
            Map<Id,List<Event>> dupAccountId2LstDupEventMap=new Map<Id,List<Event>>();
            for(Event eventObj:openEventOfDupAccount)
            {
                if(!dupAccountId2LstDupEventMap.containsKey(eventObj.whatId))
                    dupAccountId2LstDupEventMap.put(eventObj.whatId, new List<Event>{eventObj});
                else
                    dupAccountId2LstDupEventMap.get(eventObj.whatId).add(eventObj);
            }
            if(dupAccountId2LstDupEventMap!=null && dupAccountId2LstDupEventMap.size()>0)
            {
                List<Event> eventsTobeUpdatedLst=new List<Event>();
                for(Id dupAccountId:dupAccountId2LstDupEventMap.keySet())
                {
                    List<Event> openEventLst=dupAccountId2LstDupEventMap.get(dupAccountId);
                    for(Event eventObj:openEventLst)
                    {
                        //assign event to golden account.
                        eventObj.WhatId=duplicateCustmrId2MasterCustmerIdMap.get(dupAccountId);
                        eventsTobeUpdatedLst.add(eventObj);
                    }
                }
                if(eventsTobeUpdatedLst!=null && eventsTobeUpdatedLst.size()>0){
                    try{
                        update eventsTobeUpdatedLst;
                        isSuccess = true;
                        return isSuccess;
                    }catch(Exception e){
                        System.debug('Failed while reparenting activities ' + e.getMessage());
                        return isSuccess;
                    }
                }
                    
            }
        }
       return isSuccess=true;
    }
    
    //merge notes and attachment
    //Example: Duplicate AccountName-MBAccount
    //         Notes & attachment of MBAccount-N1,N2,A1,A2
    //         Golden AccountName-MBAccount
    //         After Merge, output is:
    //         Notes & attachment of MBAccount(Golden)-N1,N2,A1,A2
    public static Boolean mergeNotesAndAttachment(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
        Boolean isSuccess = false;
        //get notes from duplicate account
        List<Note> notesOfDupAccount=[Select parentId,body,title,OwnerId,IsPrivate,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate from Note where parentId IN:duplicateCustmrId2MasterCustmerIdMap.keySet()];
        if(notesOfDupAccount!=null && notesOfDupAccount.size()>0)
        {
            Map<Id,List<Note>> dupAccountId2LstDupNoteMap=new Map<Id,List<Note>>();
            for(Note noteobj:notesOfDupAccount)
            {
                if(!dupAccountId2LstDupNoteMap.containsKey(noteobj.parentId))
                    dupAccountId2LstDupNoteMap.put(noteobj.parentId, new List<Note>{noteobj});
                else
                    dupAccountId2LstDupNoteMap.get(noteobj.parentId).add(noteobj);
            }
            if(dupAccountId2LstDupNoteMap!=null && dupAccountId2LstDupNoteMap.size()>0)
            {
                List<Note> notesTobeInsertedLst=new List<Note>();
                for(Id dupAccountId:dupAccountId2LstDupNoteMap.keySet())
                {
                    List<Note> noteLst=dupAccountId2LstDupNoteMap.get(dupAccountId);
                    for(Note noteObj:noteLst)
                    {
                        //assign note to golden account.
                        Note newNoteForGoldenAccount=new Note();
                        newNoteForGoldenAccount.Body=noteObj.Body;
                        newNoteForGoldenAccount.CreatedById=noteObj.CreatedById;
                        newNoteForGoldenAccount.CreatedDate=noteObj.CreatedDate;
                        newNoteForGoldenAccount.IsPrivate=noteObj.IsPrivate;
                        newNoteForGoldenAccount.LastModifiedById=noteObj.LastModifiedById;
                        newNoteForGoldenAccount.LastModifiedDate=noteObj.LastModifiedDate;
                        newNoteForGoldenAccount.OwnerId=noteObj.OwnerId;
                        newNoteForGoldenAccount.parentId=duplicateCustmrId2MasterCustmerIdMap.get(dupAccountId);
                        newNoteForGoldenAccount.Title=noteObj.Title;
                        notesTobeInsertedLst.add(newNoteForGoldenAccount);
                    }
                }
                if(notesTobeInsertedLst!=null && notesTobeInsertedLst.size()>0){
                    try{
                        insert notesTobeInsertedLst;
                    }catch(Exception e){
                        System.debug('Failed while inserting notes ' + e.getMessage());
                        return isSuccess;
                    }
                }
                    
            }
        }
        
        //get attachments from duplicate account
        List<Attachment> attachmentOfDupAccount=[Select parentId,Body,Name,OwnerId,IsPrivate,LastModifiedDate,LastModifiedById,ContentType,CreatedById,CreatedDate,Description from Attachment where parentId IN:duplicateCustmrId2MasterCustmerIdMap.keySet()];
        if(attachmentOfDupAccount!=null && attachmentOfDupAccount.size()>0)
        {
            Map<Id,List<Attachment>> dupAccountId2LstDupAttachmentMap=new Map<Id,List<Attachment>>();
            for(Attachment attachmentObj:attachmentOfDupAccount)
            {
                if(!dupAccountId2LstDupAttachmentMap.containsKey(attachmentObj.parentId))
                    dupAccountId2LstDupAttachmentMap.put(attachmentObj.parentId, new List<Attachment>{attachmentObj});
                else
                    dupAccountId2LstDupAttachmentMap.get(attachmentObj.parentId).add(attachmentObj);
            }
            if(dupAccountId2LstDupAttachmentMap!=null && dupAccountId2LstDupAttachmentMap.size()>0)
            {
                List<Attachment> attachmentTobeInsertedLst=new List<Attachment>();
                for(Id dupAccountId:dupAccountId2LstDupAttachmentMap.keySet())
                {
                    List<Attachment> attachmentLst=dupAccountId2LstDupAttachmentMap.get(dupAccountId);
                    for(Attachment attachmentObj:attachmentLst)
                    {
                        //assign attachment to golden account.
                        Attachment newAttachmentForGoldenAcc=new Attachment();
                        newAttachmentForGoldenAcc.Body=attachmentObj.Body;
                        newAttachmentForGoldenAcc.ContentType=attachmentObj.ContentType;
                        newAttachmentForGoldenAcc.CreatedById=attachmentObj.CreatedById;
                        newAttachmentForGoldenAcc.CreatedDate=attachmentObj.CreatedDate;
                        newAttachmentForGoldenAcc.Description=attachmentObj.Description;
                        newAttachmentForGoldenAcc.IsPrivate=attachmentObj.IsPrivate;
                        newAttachmentForGoldenAcc.LastModifiedById=attachmentObj.LastModifiedById;
                        newAttachmentForGoldenAcc.LastModifiedDate=attachmentObj.LastModifiedDate;
                        newAttachmentForGoldenAcc.Name=attachmentObj.Name;
                        newAttachmentForGoldenAcc.OwnerId=attachmentObj.OwnerId;
                        newAttachmentForGoldenAcc.parentId=duplicateCustmrId2MasterCustmerIdMap.get(dupAccountId);
                        attachmentTobeInsertedLst.add(newAttachmentForGoldenAcc);
                    }
                }
                if(attachmentTobeInsertedLst!=null && attachmentTobeInsertedLst.size()>0){
                    try{
                        insert attachmentTobeInsertedLst;
                        isSuccess = true;
                        return isSuccess;
                    }catch(Exception e){
                        System.debug('Failed while inserting notes ' + e.getMessage());
                        return isSuccess;
                    }
                }
                    
                    
            }
        }
        return isSuccess=true;
    }
    
}