public class sObjectMerge {
	
    static Id vehicleReltnshpRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    static Id vehicleReltnshpRetailRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
	static Id vehicleReltnshpSoftDelRecordTypeId=Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Soft Deleted').getRecordTypeId();
    	
    //merge vehicle relationships records
    //Example: Duplicate AccountName-MBAccount.
    //		   VRs of duplicate Account: VR1,VR2,VR3,VR4
    //		   Golden AccountName-MBAccount
    //		   VRs of Golden Account: VR4,VR5,VR6
    //		   After merge, output is:
    //		   VRs of Golden Account: VR1,VR2,VR3,VR4,VR5,VR6
    public static void mergeVR(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
        //get vehicle relationship records from duplicate accounts.
        List<Vehicle_Relationship__c> vrForDuplicateAccountList=[select Id,Contact__c,car_relation__c,Euro_Vin__c,recordtypeId,Selling_Dealer__c,Selling_Dealer__r.Dealer_ND_Code__c,Owner_Dealer__c,Owner_Dealer__r.Dealer_ND_Code__c from Vehicle_Relationship__c where Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.keySet() and Vehicle_ID__c!=null and recordTypeID!=:vehicleReltnshpSoftDelRecordTypeId]; 
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
        List<Vehicle_Relationship__c> vrForGoldenAccountList=[select Id,Contact__c,car_relation__c,Euro_Vin__c,recordtypeId,Selling_Dealer__c,Selling_Dealer__r.Dealer_ND_Code__c,Owner_Dealer__c,Owner_Dealer__r.Dealer_ND_Code__c from Vehicle_Relationship__c where Contact__c IN:duplicateCustmrId2MasterCustmerIdMap.values() and Vehicle_ID__c!=null and recordTypeID!=:vehicleReltnshpSoftDelRecordTypeId]; 
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
                    //if vehicle relationship record(wholesale) under same dealer or different. 
                    //if vehicle realtionship retail record under same dealer.  
                    if((isVRwithSameDealer || isVRwithDiffDealer || isVRretailWithSameDealer) && isRecordFound)
                    {
                        dupVrObj.RecordTypeId=vehicleReltnshpSoftDelRecordTypeId;
                        dupVrObj.Contact__c=null;
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
                update dupVehicleRelnshpList;
            }
                
        }
    }
    
    //merge open activites
    //Example: Duplicate AccountName-MBAccount
    //		   Task & events of MBAccount-T1,T2,E1,E2
    //		   Golden AccountName-MBAccount
    //		   After Merge, output is:
    //		   Task & events of MBAccount(Golden)-T1,T2,E1,E2
    public static void mergeOpenActivities(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
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
                if(tasksTobeUpdatedLst!=null && tasksTobeUpdatedLst.size()>0)
                    update tasksTobeUpdatedLst;
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
                if(eventsTobeUpdatedLst!=null && eventsTobeUpdatedLst.size()>0)
                    update eventsTobeUpdatedLst;
            }
        }
    }
    
    //merge notes and attachment
    //Example: Duplicate AccountName-MBAccount
    //		   Notes & attachment of MBAccount-N1,N2,A1,A2
    //		   Golden AccountName-MBAccount
    //		   After Merge, output is:
    //		   Notes & attachment of MBAccount(Golden)-N1,N2,A1,A2
    public static void mergeNotesAndAttachment(Map<Id,Id> duplicateCustmrId2MasterCustmerIdMap)
    {
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
                if(notesTobeInsertedLst!=null && notesTobeInsertedLst.size()>0)
                    insert notesTobeInsertedLst;
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
                if(attachmentTobeInsertedLst!=null && attachmentTobeInsertedLst.size()>0)
                    insert attachmentTobeInsertedLst;
            }
        }
    }
    
}