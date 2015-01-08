/*
    Type:       Trigger
    Purpose:    1. When MB Complaint or Chrysler Complaint creat,"Subject" will be auto input value as "Case Subtype".
                2. When MB Complaint or Chrysler Complaint creat or update,If User select a Vehicle Relationship,
                   "Vehicle Brand","Vehicle Class", "Vehicle Model" and "VIN Code" will be auto input value as Vehicle's information.
                3. when a case is cloned, if the Parent case is existed, RepeatComplaintTimes plus 1.

    User Story: US-CC-002 , US-CC-003, US-CC-004,US-CC-008 ,US-CC-011 ,BRD-Tickets to CR
    Used By:
    ---------------------------------------------------------------
    History:

    1. Bing Bai Created on 2013-05-17
    2. Sinow Modified on 2013-07-19: If Feedback to CAC changed from null to any values, change Has Feedback to true.
    3. Sinow Modified on 2013-07-19: Update 15 Minutes Before Deadline when Deadline is inserted or updated.
    4. Chaos Edit on 2014-2-28  AS-Complaint_002(2014Release1.1)
    5. Justin Yu updated on 2014-03-24
    6. Cyril Huang updated on 2014-04-30(2014Release1.1b)
    7. Barney Lai updated on 2014-05-23
    8. Sinow updated for Once a Retail Inquiry Case was created by CAC IB CSR, the Case Owner shall be changed to Community Dealer S&M user. 2014/06/25.
    9. Shuang Li updated for Repeat Complaint Times  on 2014-08-14
    10. Cyril Huang updated on 2014-10-10(2014Release1.3)
*/
trigger CaseBeforeInsertUpdate on Case (before insert, before update) { 
    if (!UtilCustomSettings.isEnabled('CaseBeforeInsertUpdate')) {
        return;
    }
    
    // [Start] Added by Cyril Huang on 2014-05-06(Release1.1b)
    String[] eAddresses = null;
    String email = null;
    Boolean isError = false;
    Set<id> caseIds = new Set<id>();
    Map<id,String> vrsMap = new Map<id,String>();
    Profile currentUserProfle = CaseHelper.CURRENT_PROFILE;
    for(Case caseNew : Trigger.new) {
        if(Trigger.isInsert && caseNew.RecordTypeId == CaseHelper.RETAIL_CAMPAIGN_RECORD_TYPE && currentUserProfle.Name.startsWith('CAC')) {
            caseIds.add(caseNew.Id);
        }
        // Check the Others email address
        if (caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId){
            // if the email address of the manager is blank, it can't be the recipient.
            if (caseNew.Notice_AS__c && (caseNew.Aftersales_Manager__c == null || caseNew.Aftersales_Manager__c.trim() == '')) {
                caseNew.Notice_AS__c = false;
            }
            if (caseNew.Notice_CRM__c && (caseNew.CRM_Manager__c == null || caseNew.CRM_Manager__c.trim() == '')) {
                caseNew.Notice_CRM__c = false;
            }
            if (caseNew.Notice_GM__c && (caseNew.General_Manager__c == null || caseNew.General_Manager__c.trim() == '')) {
                caseNew.Notice_GM__c = false;
            }
            if (caseNew.Notice_SM__c && (caseNew.Sales_Manager__c == null || caseNew.Sales_Manager__c.trim() == '')) {
                caseNew.Notice_SM__c = false;
            }
                
            if (caseNew.Others__c != null && caseNew.Others__c.trim() != '') {
                isError = false;
                email = '';
                eAddresses = caseNew.Others__c.trim().split('\n');
                
                for (String e : eAddresses) {
                    if (e.trim() != '') {
                        if (!pattern.matches('[_a-zA-Z\\d\\-\\./]+@[_a-zA-Z\\d\\-]+(\\.[_a-zA-Z\\d\\-]+)+',e.trim())) {
                            caseNew.addError('其他邮箱地址格式有误,而且一行只能填写一个邮箱地址.');
                            break;
                        } else {
                            email = email + e.trim() + '\n';
                        }
                    }
                }
                caseNew.Others__c = email.trim();
            }
        }
    }
    if (caseIds.size()>0){
        for(Case vr : [Select Id, Retail_Campaign__r.Record_Type_Name__c, Retail_Campaign__c From Case where id in :caseIds]){
            if(!vrsMap.containsKey(vr.id)){
                vrsMap.put(vr.id,vr.Retail_Campaign__r.Record_Type_Name__c);
            }
        }
    }
    // [End] Added by Cyril Huang on 2014-05-06(Release1.1b)
    
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    Set<Id> vehicleRelationships = new Set<Id>();
    Map<Id, Vehicle_Relationship__c> vehicleRelationshipInfo = new Map<Id, Vehicle_Relationship__c>();
    List<Case> changeOwnerAndSendMailObjs = new List<Case>();
    // Delete Start - Release 1.3 - Deleted by Cyril
    //List<Case> changeOwnerObjs = new List<Case>();
    //Map<id,User> changeOwnerObjsResult = new Map<id,User>();
    // Delete End - Release 1.3 - Deleted by Cyril
    Map<id,User> changeOwnerAndSendMailObjsResult = new Map<id,User>();
    Set<Id> queueIds = new Set<Id>();
    Map<String, String> subTypeMap = new Map<String, String>();
    Map<Id, String> dealerIdsforRetailInquiry = new Map<Id, String>();
    Map<Id, Id> dealerIdUserId = new Map<Id, Id>();
    Set<Id> retailCaseOwners = new Set<id>();
    List<Case> retailCases = new List<Case>();
    Boolean viewCACIBSVUsers = false;
    List<User> CACIBSVUsers;
    Id accountId;
    if(UserInfo.getUserType() == 'PowerPartner' && trigger.isInsert) {
        accountId = [select id , AccountId from user where id = :userinfo.getUserId()].AccountId;
    }
    
    //get subtype chinese subject
    if(trigger.isInsert && currentUserProfle.Name.startsWith('CAC')){
        for(Case_SubType_Mapping__c csm: [select Name,Case_Subject_CN__c from Case_SubType_Mapping__c]){
            subTypeMap.put(csm.Name, csm.Case_Subject_CN__c);
        }
    }

    for(Case caseNew : Trigger.new) {
        if (caseHelper.C_CHRYSLER_RECORD_TYPE == caseNew.RecordTypeId || caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId){
            if (trigger.isInsert) {
                if(caseNew.ParentId != null){
                    parentIds.add(caseNew.ParentId);
                }
                if(accountId != null && caseNew.Case_Dealer__c == null ){
                    caseNew.Case_Dealer__c = accountId;
                    caseNew.Handling_Level__c = 'Dealer';
                }
            }

            if (caseNew.Vehicle_Relationship__c != null){
                vehicleRelationships.add(caseNew.Vehicle_Relationship__c);
            }

            // Modify Start - Release 1.3 - Deleted by Cyril
            // the complaint Case Owner will be auto changed to the Dealer's Complaint Gate keeper, if the following criteria is meet:
            // -Case Record Type = MB Complaints and Dealer Contact=Yes
            // and (Case SubType !="Fire or Gasbag Case" or On-Site Manager confirmed = True)
            //if (caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && 'Yes' == caseNew.Dealer_Contact__c && 
            //    ('Fire or Gasbag Case' != caseNew.Case_SubType__c || caseNew.On_Site_Manager_Confirmed__c ) && currentUserProfle.Name.startsWith('CAC')){
            //    changeOwnerAndSendMailObjs.add(caseNew);
            //}
            //If Onsite Manager need to to assign the "Fire or Gasbag Case" Complaint to Dealer,
            //s/he will check "On-Site Manager Confirmed" field and the Complaint will be assigned to Dealer Gate Keeper following
            //if (Trigger.isUpdate && caseNew.On_Site_Manager_Confirmed__c && caseHelper.P_BMBS_ONSITE_CM_ID == UserInfo.getProfileId() && caseNew.OwnerId == Trigger.oldMap.get(caseNew.Id).OwnerId){
            //    changeOwnerObjs.add(caseNew);
            //}
            
            // All MB Cases that were created by CAC will be assigned to Dealer
            if (caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && currentUserProfle.Name.startsWith('CAC')){
                changeOwnerAndSendMailObjs.add(caseNew);
            }
            // Modify End - Release 1.3 - Deleted by Cyril
        }
        if (caseHelper.C_MBDA_RECORD_TYPE == caseNew.RecordTypeId ){
            if (trigger.isInsert) {
                if(caseNew.ParentId != null){
                    parentIds.add(caseNew.ParentId);
                }
            }
        }
        
        if(Trigger.isInsert && caseNew.RecordTypeId == CaseHelper.RETAIL_CAMPAIGN_RECORD_TYPE && currentUserProfle.Name.startsWith('CAC')) {
            dealerIdsforRetailInquiry.put(caseNew.Case_Dealer__c , vrsMap.get(caseNew.Id));
        }
        
         if(Trigger.isInsert && caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && (caseNew.Case_SubType__c == 'RSA - Waiting Time of Assistance' 
            || caseNew.Case_SubType__c == 'RSA-RSA service attitude' || caseNew.Case_SubType__c == 'RSA - Professionalism of Rescue Worker' || caseNew.Case_Type__c == 'Finance service') 
            && !(currentUserProfle.Name.startsWith('Dealer'))) {
            viewCACIBSVUsers = true;   
        }
        
        // Added by Cyril Start -- Release1.3 Complaint Solution Team CR
        if (Trigger.isInsert && currentUserProfle.Name.startsWith('CAC')) {
            caseNew.CreateByCAC__c = true;
        }
        // Added by Cyril End -- Release1.3 Complaint Solution Team CR
    }
    
    if(dealerIdsforRetailInquiry.size() > 0) {
        dealerIdUserId = CaseHelper.getDealerSMManager(dealerIdsforRetailInquiry);
    }

    if (parentIds.size()>0){
        for(Case ca : [select Id, ParentId from Case where ParentId in :parentIds]) {
            if(!parentIdChildIds.containsKey(ca.ParentId)) {
                parentIdChildIds.put(ca.ParentId, new List<Id>());
            }
            parentIdChildIds.get(ca.ParentId).add(ca.Id);
        }

        for(Case ca : [select Id, ParentId from Case where Id in :parentIds]) {
            if(ca.ParentId != null) {
                parenthasParents.add(ca.Id);
            }
        }
    }

    //get vehicle infomation
    if (vehicleRelationships.size()>0){
        for(Vehicle_Relationship__c vr : [select Vehicle_Brand__c, Vehicle_Class__c , Vehicle_Model__c, Vehicle_ID__c, Vehicle_ID__r.UsVIN__c, Vehicle_ID__r.EuroVIN__c, Vehicle_ID__r.Latest_Sales_Person__c, Vehicle_ID__r.Warranty_Start_Date__c, Vehicle_ID__r.FirstRegistrationDate__c, Registration_Number__c from Vehicle_Relationship__c where Id in :vehicleRelationships]){
            vehicleRelationshipInfo.put(vr.id,vr);
        }
    }
    // Delete Start - Release 1.3 - Deleted by Cyril
    //get Gate Keeper Owner
    //if(changeOwnerObjs.size()>0){
    //    changeOwnerObjsResult = CaseHelper.getGateKeepers(changeOwnerObjs);
    //}
    // Delete End - Release 1.3 - Deleted by Cyril

    //get Gate Keeper Owner US-CC-008
    if(changeOwnerAndSendMailObjs.size()>0){
        changeOwnerAndSendMailObjsResult = CaseHelper.getGateKeepers(changeOwnerAndSendMailObjs);
    }

    for(QueueSobject qs : CaseHelper.CENTRAL_REGIONAL_CASE_QUEUES) {
        queueIds.add(qs.QueueId);
    }
    
    if(viewCACIBSVUsers) {
        CACIBSVUsers = [select id from User where profile.name = 'CAC IB SV' and isActive = true];
    }
    
    for(Case caseNew : Trigger.new) {
        if (caseHelper.C_MBDA_RECORD_TYPE == caseNew.RecordTypeId){
            if(trigger.isInsert) {
                if(caseNew.CCMS_SourceId__c == '' || caseNew.CCMS_SourceId__c == null) {
                        caseNew.Repeat_Complaint_Times__c = 1;
                }
                //set repeat complaint times
                if (caseNew.ParentId != null){
                    if(parenthasParents.contains(caseNew.ParentId)) {
                            caseNew.addError(caseHelper.NOT_PRIMARY_REMINDER );
                        }
                        else
                        {
                            if(parentIdChildIds.containsKey(caseNew.ParentId)) {
                                caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 2;
                            }
                            else {
                                caseNew.Repeat_Complaint_Times__c = 2;
                            }
                    }
                }
            }
        }
        if (caseHelper.C_CHRYSLER_RECORD_TYPE == caseNew.RecordTypeId || caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId){
            if(trigger.isInsert) {
                //set "Case Subtype" to field "Subject"
                if(currentUserProfle.Name.startsWith('CAC')){
                    caseNew.Subject = subTypeMap.get(caseNew.Case_SubType__c);
                }

                if(caseNew.CCMS_SourceId__c == '' || caseNew.CCMS_SourceId__c == null) {
                    caseNew.Repeat_Complaint_Times__c = 1;
                }

                //set repeat complaint times
                if (caseNew.ParentId != null){
                    if(parenthasParents.contains(caseNew.ParentId)) {
                        caseNew.addError(caseHelper.NOT_PRIMARY_REMINDER );
                    }
                    else
                    {
                        if(parentIdChildIds.containsKey(caseNew.ParentId)) {
                            caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 2;
                        }
                        else {
                            caseNew.Repeat_Complaint_Times__c = 2;
                        }
                        caseNew.Feedback_to_CAC_New__c = '';
                        caseNew.Feedback_Read__c = false;
                        caseNew.Results_Response__c = '';
                        caseNew.Result__c = '';
                        caseNew.Final__c = false;
                        caseNew.On_Site_Manager_Confirmed__c = false;
                    }
                }
            }
            // ADD START AS-Complaint_002 CHAOS 2014/2/28
            Set<id> dealerAccounts = new Set<id>();
            
            Id oldSupportDealer1 = 
                (Trigger.oldMap == null ) ? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_1__c;
            Id oldSupportDealer2 = 
                (Trigger.oldMap == null ) ? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_2__c;
            Id oldSupportDealer3 = 
                (Trigger.oldMap == null ) ? null : Trigger.oldMap.get(caseNew.Id).Support_Dealer_3__c;
            
            if (caseNew.Support_Dealer_1__c != oldSupportDealer1 
                && caseNew.Support_Dealer_1__c != null ){
                dealerAccounts.add(caseNew.Support_Dealer_1__c);
            }
            if (caseNew.Support_Dealer_2__c != oldSupportDealer2 
                && caseNew.Support_Dealer_2__c != null ){
                dealerAccounts.add(caseNew.Support_Dealer_2__c);
            }
            if (caseNew.Support_Dealer_3__c != oldSupportDealer3
                && caseNew.Support_Dealer_3__c != null ){
                dealerAccounts.add(caseNew.Support_Dealer_3__c);
            }
            Map<id,String> accountAndKeeperEmail = caseHelper.getComplaintGateKeeperEmail(dealerAccounts);
            
            if (caseNew.Support_Dealer_1__c != oldSupportDealer1
                && caseNew.Support_Dealer_1__c != null 
                && caseNew.Send_Email_Support_Dealer1_Keeper_Email__c 
                            != accountAndKeeperEmail.get(caseNew.Support_Dealer_1__c)){
                caseNew.Send_Email_Support_Dealer1_Keeper__c = true;
                caseNew.Send_Email_Support_Dealer1_Keeper_Email__c =
                        accountAndKeeperEmail.get(caseNew.Support_Dealer_1__c);
            } else {
                caseNew.Send_Email_Support_Dealer1_Keeper_Email__c = '';
            }

            if (caseNew.Support_Dealer_2__c != oldSupportDealer2
                && caseNew.Support_Dealer_2__c != null
                && caseNew.Send_Email_Support_Dealer2_Keeper_Email__c 
                            != accountAndKeeperEmail.get(caseNew.Support_Dealer_2__c)){
                caseNew.Send_Email_Support_Dealer2_Keeper__c = true;
                caseNew.Send_Email_Support_Dealer2_Keeper_Email__c =
                        accountAndKeeperEmail.get(caseNew.Support_Dealer_2__c);
            } else {
                caseNew.Send_Email_Support_Dealer2_Keeper_Email__c = '';
            }
            
            if (caseNew.Support_Dealer_3__c != oldSupportDealer3
                && caseNew.Support_Dealer_3__c != null
                && caseNew.Send_Email_Support_Dealer3_Keeper_Email__c 
                            != accountAndKeeperEmail.get(caseNew.Support_Dealer_3__c)){
                caseNew.Send_Email_Support_Dealer3_Keeper__c = true;
                caseNew.Send_Email_Support_Dealer3_Keeper_Email__c =
                        accountAndKeeperEmail.get(caseNew.Support_Dealer_3__c);
            } else {
                caseNew.Send_Email_Support_Dealer3_Keeper_Email__c = '';
            }
            // ADD END AS-Complaint_002 CHAOS 2014/2/28
            
            //set Vehicle infomation
            if (caseNew.Vehicle_Relationship__c != null && vehicleRelationshipInfo.get(caseNew.Vehicle_Relationship__c) != null){
                caseNew = caseHelper.setVehicleInfo(caseNew,vehicleRelationshipInfo.get(caseNew.Vehicle_Relationship__c));
            }

            // Delete Start - Release 1.3 - Deleted by Cyril
            //if(changeOwnerObjsResult.containsKey(caseNew.id) && !queueIds.contains(caseNew.OwnerId)) {
            //    caseNew.OwnerId = changeOwnerObjsResult.get(caseNew.id).id;
            //    caseNew.Handling_Level__c = 'Dealer';
            //}
            // Delete End - Release 1.3 - Deleted by Cyril

            if(changeOwnerAndSendMailObjsResult.containsKey(caseNew.id) && !queueIds.contains(caseNew.OwnerId)) {
                caseNew.OwnerId = changeOwnerAndSendMailObjsResult.get(caseNew.id).id;
                caseNew.Handling_Level__c = 'Dealer';
                caseNew.SendEmailToGateKeeper__c = true;
            }

            //when owner changed, save previous owner in field
            if (CaseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && trigger.isUpdate) {
                Id previousId = Trigger.oldMap.get(caseNew.Id).OwnerId;
                if (caseNew.OwnerId != previousId && String.valueOf(previousId).substring(0,3).equals('005')) {
                    caseNew.Previous_Owner__c = previousId;
                }
            }
        }

        //If Feedback to CAC changed from null to any values, change Has Feedback to true.
        if(Trigger.isUpdate) {
            if(caseNew.Feedback_to_CAC_New__c != null && caseNew.Feedback_to_CAC_New__c != '' && (Trigger.oldMap.get(caseNew.Id).Feedback_to_CAC_New__c == null || Trigger.oldMap.get(caseNew.Id).Feedback_to_CAC_New__c == '')) {
                caseNew.Has_Feedback__c = true;
            }

            //Update 15 Minutes Before Deadline when Deadline is inserted or updated.
            if(caseNew.Deadline__c != null && caseNew.Deadline__c != Trigger.oldMap.get(caseNew.Id).Deadline__c) {
                caseNew.X15_Minutes_Before_Deadline__c = caseNew.Deadline__c.addMinutes(-15);
            }
        }

        if(Trigger.isInsert && caseNew.Deadline__c != null) {
            caseNew.X15_Minutes_Before_Deadline__c = caseNew.Deadline__c.addMinutes(-15);
        }
        
        if(Trigger.isInsert && caseNew.RecordTypeId == CaseHelper.RETAIL_CAMPAIGN_RECORD_TYPE && currentUserProfle.Name.startsWith('CAC') && dealerIdUserId.containsKey(caseNew.Case_Dealer__c)) {
            caseNew.OwnerId = dealerIdUserId.get(caseNew.Case_Dealer__c);
            caseNew.Retail_Case_Notice_Dealer_Flag__c = true;
        }
        
        if(Trigger.isInsert && caseHelper.C_MB_RECORD_TYPE == caseNew.RecordTypeId && (caseNew.Case_SubType__c == 'RSA - Waiting Time of Assistance' 
            || caseNew.Case_SubType__c == 'RSA-RSA service attitude' || caseNew.Case_SubType__c == 'RSA - Professionalism of Rescue Worker' || caseNew.Case_Type__c == 'Finance service') 
            && !(currentUserProfle.Name.startsWith('Dealer')) && CACIBSVUsers.size() > 0) {
            caseNew.ownerId = CACIBSVUsers[0].id;
        }
    }

    // 2013-09-06 Created by Justin: Populate the car owner values to case.
    Set<String> carOwnerIds = new Set<String>();
    List<Case> cases = new List<Case>();

    List<Case> casesForVehicle = new List<Case>();
    List<Id> vehicleIds = new List<Id>();

    for(Case newCase : trigger.new){
        if(newCase.Car_Owner__c != null && (Trigger.isInsert || (Trigger.isUpdate && newCase.Car_Owner__c != Trigger.oldMap.get(newCase.Id).Car_Owner__c))){
            carOwnerIds.add(newCase.Car_Owner__c);
            cases.add(newCase);
        }

        if(newCase.Vehicle__c != null && (Trigger.isInsert || (Trigger.isUpdate && newCase.Vehicle__c != Trigger.oldMap.get(newCase.Id).Vehicle__c)))
        {
            casesForVehicle.add(newCase);
            vehicleIds.add(newCase.Vehicle__c);
        }
    }

    if(carOwnerIds.size() > 0) {
       CaseHelper.populateCarOwnerValuesToCase(carOwnerIds, cases);
    }
    if(casesForVehicle.size() > 0) {
        CaseHelper.updateVehicleRelatedFields(casesForVehicle, vehicleIds);
    }
    
    // [Start] Added by Cyril Huang on 2014-05-06(Release1.1b)
    // Send case updating notification email to Dealer Managers
    boolean isStatus = false;
    boolean isInfo = false;
    boolean isSettlement = false;
    boolean isDescChanged = false;
    String eAddress = '';
    String content = '';
    String accName = '';
    String statusTrack = '';
    String handleTrack = '';
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    // Add Start - Release 1.3 - Added by Cyril
    List<Task> taskListOf48H = new List<Task>();
    List<Task> taskListOf72H = new List<Task>();
    // Add End - Release 1.3 - Added by Cyril
    
    if (trigger.isUpdate) {
        for(Case caseNew : Trigger.new) {
            Case caseOld = trigger.oldMap.get(caseNew.id);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            isStatus = false;
            isInfo = false;
            isSettlement = false;
            eAddress = '';
            content = '';
            statusTrack = '';
            handleTrack = '';
            
            // Add Start - Release 1.3 - Added by Cyril
            if (caseNew.CheckFlag_48H__c && !caseOld.CheckFlag_48H__c && caseNew.Customer_Care_Owner__c != null) {
                taskListOf48H.add(new Task(
                    Subject= '个案' + caseNew.CaseNumber + (caseNew.Dealer_Contact__c == 'Yes' ? '已过48小时，请检查经销商是否给出FP' : '已过48小时，请检查经销商/区域/中心是否给出FP'),
                    RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId(),
                    OwnerId = caseNew.Customer_Care_Owner__c,
                    Status = 'Open',
                    WhoId = caseNew.Account.id,
                    WhatId = caseNew.id,
                    ActivityDate = date.today(),
                    ReminderDateTime = DateTime.now(),
                    IsReminderSet = true
                    ));
            }
            if (caseNew.CheckFlag_72H__c && !caseOld.CheckFlag_72H__c && caseNew.Customer_Care_Owner__c != null) {
                taskListOf72H.add(new Task(
                    Subject= '个案' + caseNew.CaseNumber + (caseNew.Dealer_Contact__c == 'Yes' ? '已过72小时，请检查经销商是否给出FP' : '已过72小时，请检查经销商/区域/中心是否给出FP，并在24小时内给终端客户回复'),
                    RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId(),
                    OwnerId = caseNew.Customer_Care_Owner__c,
                    Status = 'Open',
                    WhoId = caseNew.Account.id,
                    WhatId = caseNew.id,
                    ActivityDate = date.today(),
                    ReminderDateTime = DateTime.now(),
                    IsReminderSet = true
                    ));
            }
            if (caseNew.CheckFlag_48H__c) caseNew.CheckFlag_48H__c = false;
            if (caseNew.CheckFlag_72H__c) caseNew.CheckFlag_72H__c = false;
            // Add End - Release 1.3 - Added by Cyril
            
            if (caseNew.Status != caseOld.Status) {
                isStatus = true;
                statusTrack = 'Updated From ' + caseOld.Status + ' To ' + caseNew.Status;
            }
            if (caseNew.Handling_Level__c != caseOld.Handling_Level__c) {
                isInfo = true;
                handleTrack = 'Updated From ' + caseOld.Handling_Level__c + ' To ' + caseNew.Handling_Level__c;
            }
            if (caseNew.Description_Changed__c) {
                isInfo = true;
                isDescChanged = true;
                caseNew.Description_Changed__c = false;
            }
            if (caseNew.Settlement_Changed__c) {
                isSettlement = true;
            }
            
            if (isStatus == false && isInfo == false && isSettlement == false) {
                continue;
            }
            
            if (caseNew.Notice_AS__c) {
                eAddress = eAddress + caseNew.Aftersales_Manager__c + '\n';
            }
            if (caseNew.Notice_CRM__c) {
                eAddress = eAddress + caseNew.CRM_Manager__c + '\n';
            }
            if (caseNew.Notice_GM__c) {
                eAddress = eAddress + caseNew.General_Manager__c + '\n';
            }
            if (caseNew.Notice_SM__c) {
                eAddress = eAddress + caseNew.Sales_Manager__c + '\n';
            }
            if (caseNew.Notice_Others__c) {
                eAddress = eAddress + caseNew.Others__c;
            } else if (eAddress != '') {
                eAddress = eAddress.substring(0, eAddress.lastIndexOf('\n'));
            }
            
            if (eAddress != '') {
                content = 'Dear Dealer Managers, \n\n' + 'Case ' + caseNew.CaseNumber + ' has been updated in the';
                if (isStatus) {
                    content = content + ' Status';
                }
                if (isInfo) {
                    content = content + ' ComplaintInfo';
                }
                if (isSettlement) {
                    content = content + ' Settlement';
                }
                if (caseNew.AccountId == null) {
                    accName = null;
                } else {
                    accName = [select name from Account where id = :caseNew.AccountId].name;
                }
                content = content + ' Section by ' + UserInfo.getName() + '.\n\n';
                content = content + 'The main information of the updated case:\n' 
                                  + ' - Subject = ' + caseNew.Subject + '\n'
                                  + ' - Complaint Status = ' + caseNew.Status + '\n'
                                  + ' - Complaint Date = ' + caseNew.Complaint_Date__c + '\n'
                                  + ' - Case Source = ' + caseNew.Case_Source__c + '\n'
                                  + ' - Account Name = ' + accName + '\n'
                                  + ' - Vehicle Series = ' + caseNew.Vehicle_Class__c + '\n'
                                  + ' - Vehicle Model = ' + caseNew.Car_Model__c + '\n'
                                  + ' - Description = ' + caseNew.Description + '\n'
                                  + ' - Description1 = ' + caseNew.DescriptionOne__c + '\n';
                if (statusTrack != '') {
                    content = content + ' - Status Tracking = ' + statusTrack + '\n';
                }
                if (handleTrack != '') {
                    content = content + ' - Handling Level Tracking = ' + handleTrack + '\n';
                }
                content = content + '\n';
                if (caseNew.Settlement_Changed__c) {
                    caseNew.Settlement_Changed__c = false;
                    content = content + 'Settlement Section:\n';
                    for (Settlement_Management__c sm : [select Name, Settlement_Type__c, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c, Total_Settlement_Amount__c, Other_Settlement_Type__c, LastModifiedDate from Settlement_Management__c where Case__c = :caseNew.Id order by LastModifiedDate Desc]) {
                        content = content + 'Settlement Management ' + sm.Name + ', '
                                          + 'LastModifiedDate = ' + sm.LastModifiedDate.format('yyyy/MM/dd HH:mm:ss') + '\n'
                                          + ' - Settlement Type = ' + sm.Settlement_Type__c + '\n'
                                          + ' - Customer Settlement Amount = ' + sm.Customer_Settlement_Amount__c + '\n'
                                          + ' - Dealer Settlement Amount = ' + sm.Dealer_Settlement_Amount__c + '\n'
                                          + ' - MB Settlement Amount = ' + sm.MB_Settlement_Amount__c + '\n'
                                          + ' - Total Settlement Amount = ' + sm.Total_Settlement_Amount__c + '\n'
                                          + ' - Other Settlement Type = ' + sm.Other_Settlement_Type__c + '\n\n';
                    }
                }
                if (isDescChanged) {
                    content = content + 'ComplaintInfo Section:\n';
                    for (Complaint_Description__c cd : [select Name, Description__c, LastModifiedDate from Complaint_Description__c where Case__c =: caseNew.Id order by LastModifiedDate Desc]) {
                        content = content + 'Complaint Description / Resolution ' + cd.Name + ', '
                                          + 'LastModifiedDate = ' + cd.LastModifiedDate.format('yyyy/MM/dd HH:mm:ss') + '\n'
                                          + ' - ' + cd.Description__c + '\n\n';
                    }
                }
                content = content + 'Best Regards,\n\n' + UserInfo.getName() + '.';
                
                message.setToAddresses(eAddress.split('\n'));
                message.setSubject('Case ' + caseNew.CaseNumber + ' has been updated');
                message.setSaveAsActivity(false);
                message.setPlainTextBody(content);
                messages.add(message);
            }
        }
        
        // Add Start - Release 1.3 - Added by Cyril
        if (taskListOf48H.size() > 0) {
            insert taskListOf48H;
        }
        if (taskListOf72H.size() > 0) {
            insert taskListOf72H;
        }
        // Add End - Release 1.3 - Added by Cyril
            
        if (messages.size() > 0) {
            Messaging.Email[] emails = new Messaging.Email[messages.size()];
            for(Integer i = 0; i < messages.size(); i++) {
                emails[i] = messages.get(i);
            }
            
            try {
                Messaging.sendEmail(emails);
            } catch(Exception ex) {
                system.debug('Exception occured when sending Case Updating Notification eamils to Dealer Managers :' + ex.getMessage());
            }
        }
    }
}