/*
    Type:       Trigger
    Purpose:    1.When a Case that it is MB Complaint created, tracking the custom fields.
                2.When a Case that it is Chrysler Complaint created, tracking the custom fields.
                3.when a case is cloned, if the Parent case is existed, RepeatComplaintTimes plus 1.
                4.As a Complaint Dealer Portal User,  need a Complaint History Tracking
                5.If the Complaint is a promary complaint, sent a SMS to Customer.
                6.when a MB case insert,creat a complaint description record.
                7.Click "Follow Up Inquiry" button to create a Inquiry Case record. Inquiry Number will be updated to the "Follow Up Inquiry" automatically. 
                8.Dealer want to see "Case Owner" and "Case Department" change Logs in Case Description related list. US-DPCR-004
                
    User Story: US-CC-002, US-CC-003 ,US-CC-004 ,US-CC-015, US-CC-023, US-CC-024, US-IB-003, US-DPCR-004
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-05-17
    2. Chaos Edit on 2014-2-21  AS-Complaint_002(2014Release1.1)
    3. 2014-04-11 updated by Justin Yu
*/

trigger CaseAfterInsertOrUpdate on Case (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('CaseAfterInsertOrUpdate')) {
        return;
    }
    List<Sobject> insertCaseHistorys = new List<Sobject>();
    List<Sobject> insertCaseDescriptions = new List<Sobject>();
    List<Sobject> updateObjs = new List<Sobject>();
    Map<id,String> vrsMap = new Map<id,String>();
    Map<id,String> ursMap = new Map<id,String>();
    Map<id,id> casesToShare = new Map<id, id>();
    // ADD START AS-Complaint_002 CHAOS 2014/2/21
    Map<id,Set<Id>> casesToDeleteFromShare = new Map<Id, Set<Id>>();
    Map<id,Set<Id>> casesToShareForSupport = new Map<Id, Set<Id>>();
    // ADD END AS-Complaint_002 CHAOS 2014/2/21
    Map<String, String> vehicleToOwner = new Map<String, String>();
    Map<id,id> casesToShareRO = new Map<id, id>();
    Set<id> vsrIds = new Set<id>();
    Set<id> userIds = new Set<id>();
    Set<id> smsIds = new Set<id>();
    Set<id> accIds = new Set<id>();
    List<String> targetList = null;    
    List<Case> casesForDescription = new List<Case>();
    List<Id> CentralQID = new List<Id>();
    List<Case> closeRelatedCase = new List<Case>();
    if(Trigger.isUpdate) {
        for(QueueSobject q : CaseHelper.BMBS_CENTRAL_CASE_QUEUES) {
            CentralQID.add(q.QueueId);
        }
    }
    
    for(Case caseNew : Trigger.new) {
        if (trigger.isUpdate){
            Case caseOld = Trigger.oldMap.get(caseNew.Id);
            if (caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId){
                targetList = caseHelper.COLS_MB_TRACKING;
            }
            if (caseHelper.C_CHRYSLER_RECORD_TYPE == caseNew.RecordTypeId ){
                targetList = caseHelper.COLS_CHRYSLER_TRACKING;
            }
            //(US-CC-002,US-CC-003,US-CC-015)
            if ( targetList != null){
                for(String cloName: targetList){
                    String newValue = String.valueOf(caseNew.get(cloName));
                    String oldValue = String.valueOf(caseOld.get(cloName));
                    String labelName= CaseHelper.FLDOBJ_MAP.get(cloName).getDescribe().getLabel();
                    String seToGKBef = String.valueOf(caseNew.get('SendEmailToGateKeeper__c'));
                    String seToGKAft = String.valueOf(caseOld.get('SendEmailToGateKeeper__c'));
                    if(seToGKBef != seToGKAft) {
                        continue;
                    }

                    if (cloName == 'Escalate_Date_to_RO__c' || cloName == 'Escalate_Date_to_CO__c') {
                        if (newValue != null) {
                            Integer findex = newValue.indexOf(' ');
                            if (findex > 0) {
                                newValue = newValue.subString(0, findex);
                            }
                        }
                        if (oldValue != null) {
                            Integer findex = oldValue.indexOf(' ');
                            if (findex > 0) {
                                oldValue = oldValue.subString(0, findex);
                            }
                        }
                    }

                    //tracking history
                    if(newValue != oldValue){
                        if (cloName == 'Vehicle_Relationship__c'){
                            vsrIds.add(caseNew.Vehicle_Relationship__c);
                            vsrIds.add(caseOld.Vehicle_Relationship__c);
                        }else if(cloName == 'OwnerId'){
                            userIds.add(caseNew.OwnerId);
                            userIds.add(caseOld.OwnerId);
                        }else{
                            insertCaseHistorys.add(CaseHelper.newCaseHistory(caseNew.Id, labelName , newValue, oldValue));
                            if(cloName == 'Case_Department__c') {
                                insertCaseDescriptions.add(CaseHelper.newCaseDescription(caseNew.Id, labelName , newValue, oldValue));
                            }
                        }
                    }
                }
            }
        }

        //US-CC-023
        if (CaseHelper.C_INQUIRY_RECORD_TYPE == caseNew.RecordTypeId) {
            if (Trigger.isUpdate && caseNew.Case_Dealer__c != null && caseNew.TL_Reviewed__c && !Trigger.oldMap.get(caseNew.Id).TL_Reviewed__c) {
                casesToShare.put(caseNew.Id, caseNew.Case_Dealer__c);
            }
        }
        if (caseHelper.C_CHRYSLER_RECORD_TYPE == caseNew.RecordTypeId ||caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId) {
            // 2014-08-15 Created by lishuang: add for MB Complaint Case Close.
            if (trigger.isUpdate && CaseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && caseNew.Close_Relevant_Repeat_Complaint__c == true && caseNew.Case_Dealer__c != null && caseNew.Status == 'Closed' && Trigger.oldMap.get(caseNew.Id).Status != 'Closed') {
                closeRelatedCase.add(caseNew);
            }
            if (caseNew.Case_Dealer__c != null && 'Yes' == caseNew.Dealer_Contact__c){
                if(trigger.isInsert){
                    casesToShare.put(caseNew.Id, caseNew.Case_Dealer__c);
                }
                if(trigger.isUpdate && 'Yes' != trigger.oldMap.get(caseNew.Id).Dealer_Contact__c){
                    casesToShare.put(caseNew.Id, caseNew.Case_Dealer__c);
                }
                if(trigger.isUpdate && caseNew.OwnerId != Trigger.oldMap.get(caseNew.Id).OwnerId) {
                    casesToShare.put(caseNew.Id, caseNew.Case_Dealer__c);
                    boolean flag = false;
                    for(integer i = 0;i<CentralQID.size();i++) {
                        if(CentralQID[i] == caseNew.OwnerId) {
                            flag = true;
                        }
                    }
                    if(trigger.isUpdate && flag && caseNew.Previous_Owner__c != null) {
                        casesToShareRO.put(caseNew.Id, caseNew.Previous_Owner__c);
                    }
                }
                
                // By Justin - maps the vehicle and owner in case, to share the vehicle to case owner.
                String caseOwnerId = caseNew.OwnerId;
                if(caseNew.Vehicle__c != null && caseNew.ParentId == null && caseOwnerId.startsWith('005') && !(Trigger.isUpdate && caseNew.OwnerId == Trigger.oldMap.get(caseNew.Id).OwnerId)){
                    vehicleToOwner.put(caseNew.Vehicle__c, caseNew.OwnerId);
                }
            } 
            // ADD START AS-Complaint_002 CHAOS 2014/2/21
            Id oldSupportDealer1 = 
                (Trigger.oldMap == null )? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_1__c;
            Id oldSupportDealer2 = 
                (Trigger.oldMap == null )? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_2__c;
            Id oldSupportDealer3 = 
                (Trigger.oldMap == null )? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_3__c;

            if(!casesToShareForSupport.containsKey(caseNew.Id)) {
                casesToShareForSupport.put(caseNew.Id, new Set<Id>());
            }
            if(!casesToDeleteFromShare.containsKey(caseNew.Id)) {
                casesToDeleteFromShare.put(caseNew.Id, new Set<Id>());
            }
            supportDealerMethod(caseNew.Support_Dealer_1__c, oldSupportDealer1, caseNew.Id);
            supportDealerMethod(caseNew.Support_Dealer_2__c, oldSupportDealer2, caseNew.Id);
            supportDealerMethod(caseNew.Support_Dealer_3__c, oldSupportDealer3, caseNew.Id);
            // ADD END AS-Complaint_002 CHAOS 2014/2/21
        }
        if (trigger.isInsert){
            if (caseNew.ParentId == null && caseNew.AccountId != null && caseNew.Handling_Level__c != 'Dealer' && (caseHelper.C_CHRYSLER_RECORD_TYPE == caseNew.RecordTypeId ||caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId)){
                smsIds.add(caseNew.Id);
                accIds.add(caseNew.AccountId);
            }
            
            //US-CC-024
            if(caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && !String.isBlank(caseNew.Description)) {
                casesForDescription.add(caseNew);
            }
        }
    }
    
    if (closeRelatedCase.size() > 0){
        CaseHelper.closeRelatedCase(closeRelatedCase);
    }

    if (vsrIds.size()>0 || userIds.size()>0){
        for(Vehicle_Relationship__c vr : [select id , name from Vehicle_Relationship__c where id in :vsrIds]){
            if(!vrsMap.containsKey(vr.id)){
                vrsMap.put(vr.id,vr.name);
            }
        }
        
        for(user u:[select id , name from user where Id in :userIds]){
            if(!ursMap.containsKey(u.id)){
                ursMap.put(u.id,u.name);
            }        
        }
        for(QueueSobject u:[select QueueId , queue.name from QueueSobject where QueueId in :userIds limit 100]){
            if(!ursMap.containsKey(u.QueueId)){
                ursMap.put(u.QueueId,u.queue.name);
            }        
        }
    
        for(Case caseNew : Trigger.new) {
            Case caseOld = Trigger.oldMap.get(caseNew.Id);
            String seToGKBef = String.valueOf(caseNew.get('SendEmailToGateKeeper__c'));
            String seToGKAft = String.valueOf(caseOld.get('SendEmailToGateKeeper__c'));
            if(seToGKBef != seToGKAft) {
                continue;
            }

            Id newId = caseNew.Vehicle_Relationship__c;
            Id oldId = caseOld.Vehicle_Relationship__c;
            String labelName = CaseHelper.FLDOBJ_MAP.get('Vehicle_Relationship__c').getDescribe().getLabel();
            //tracking history
            if(newId != oldId){
                insertCaseHistorys.add(CaseHelper.newCaseHistory(caseNew.Id, labelName , vrsMap.get(newId), vrsMap.get(oldId)));
            }

            newId = caseNew.OwnerId;
            oldId = caseOld.OwnerId;
            labelName= 'Case Owner';
            //tracking history
            if(newId != oldId){
                insertCaseHistorys.add(CaseHelper.newCaseHistory(caseNew.Id, labelName , ursMap.get(newId), ursMap.get(oldId)));
            }            
        }
    }

    //create SMS tasks
    if(smsIds.size() > 0) {
        CaseHelper.createSmsTasks(smsIds, accIds);
    }
    
    // ADD START AS-Complaint_002 CHAOS 2014/2/21
    if(casesToDeleteFromShare.keySet().size() > 0) {
        CaseHelper.deleteShareFromCase(casesToDeleteFromShare);
    }
    
    if(casesToShareForSupport.keySet().size() > 0) {
        CaseHelper.shareCaseWithoutshareVehicle(casesToShareForSupport);
    }
    // ADD END AS-Complaint_002 CHAOS 2014/2/21
    
    if(casesToShare.keySet().size() > 0) {
        CaseHelper.shareCase(casesToShare, vehicleToOwner);
    }

    if(casesToShareRO.keySet().size() > 0) {
        CaseHelper.shareCaseToRO(casesToShareRO);
    } 
    
    if (insertCaseHistorys.size()>0){
        CaseHelper.insertSobjects(insertCaseHistorys);
    }
    
    if (insertCaseDescriptions.size()>0){
        CaseHelper.insertSobjects(insertCaseDescriptions);
    }
    
    //Creat the case description record
    if(casesForDescription.size() > 0) {
        CaseHelper.creatCaseDescription(casesForDescription);
    }
    
    // ADD START AS-Complaint_002 CHAOS 2014/2/21
    private void supportDealerMethod(Id newDealerId, Id oldDealerId, Id caseId) {

        if(trigger.isInsert){
            if (newDealerId != null && !casesToShareForSupport.get(caseId).contains(newDealerId)){
                casesToShareForSupport.get(caseId).add(newDealerId);
            }
        }
        if(trigger.isUpdate && (newDealerId != oldDealerId)) {
            if( oldDealerId == null  && !casesToShareForSupport.get(caseId).contains(newDealerId)) {
                
                casesToShareForSupport.get(caseId).add(newDealerId);
                
            } else {
                if( newDealerId != null  && !casesToShareForSupport.get(caseId).contains(newDealerId)) {
                    casesToShareForSupport.get(caseId).add(newDealerId);
                }
                if (!casesToDeleteFromShare.get(caseId).contains(oldDealerId)) {
                    casesToDeleteFromShare.get(caseId).add(oldDealerId);
                }
            }
        }
    }
    // ADD END AS-Complaint_002 CHAOS 2014/2/21
    
    /**
     * 2014-03-24 updated by Justin Yu -- Added the child case description to the Parent MB Complaint case
     */
    if(trigger.isInsert){
        Set<String> caseIds = new Set<String>();
        for(Case c : Trigger.new){
            if(c.RecordTypeId == '01290000000rXmLAAU' && c.ParentId != null){
                caseIds.add(c.Id);
            }
        }
        
        List<Case> parentCases = new List<Case>();
        if(caseIds.size() > 0){
            for(Case item : [select Description, DescriptionOne__c, Parent.Description, Parent.DescriptionOne__c from Case where Id in :caseIds]){
                item.Parent.Description = item.Description;
                item.Parent.DescriptionOne__c = item.DescriptionOne__c;
                parentCases.add(item.Parent);
            }
        }
        update parentCases;
    }
    //---------------------Bing add for data sharing-----------------
    AccountSharingDataHandler handler = new AccountSharingDataHandler('Complaint');
    handler.shareAccountByComplaint(trigger.newMap, trigger.oldMap, trigger.isInsert);
    //---------------------Bing add for data sharing-----------------
}