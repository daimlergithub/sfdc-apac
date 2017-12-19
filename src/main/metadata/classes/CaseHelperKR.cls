/*
Share case record with Japan Dealer Company Manager,Japan Dealer Sales Manager,Japan Dealer Service Manager,
if this Case record belongs to the dealer user's company and Dealer_Contact__c value as "Yes" and
Dealer_GC_Code_c field value of the Account linked to the "Case_Dealer_c" field of target Case match the Dealer_GC_Code__c and Dealer_GS_Code__c of the target User
*/
public class CaseHelperKR
{
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    /*public static void CaseHelperKR(List<Case> shcaseList)
    {
        Set<String> DealerGccode = new Set<String>();
        Set<String> DealerGScode = new Set<String>();
        Set<String> DealerNDCode= new Set<String>();
        List<Account> DealeAcc=new List<Account>();  
        Id caseRecId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
        List<CaseShare> CaseSharingRecord = new List<CaseShare>();        
        List<Case> caserecList = new List<Case>();
        set<id> shrcaseId = new set<id>();
        set<id> userId = new set<id>();      
        List<Group> partnerUserList = new List<Group>();       
        set<id> dealerId = new set<id>();     
        set<id> CaseDealerUserId = new set<id>();
        
        
        if(shcaseList!=null && !shcaseList.isempty())
        {
            for(Case c : shcaseList)
            {
                if(c.RecordTypeId == caseRecId && c.Dealer_Contact__c == 'Yes' && c.Case_Dealer__c != null)
                {
                    shrcaseId.add(c.Id);
                    dealerId.add(c.Case_Dealer__c);
                }
                
            }
        }
        if(!shrcaseId.isEmpty() && shrcaseId != null)
        { 
            caserecList = [select id,Case_Dealer__c,Case_Dealer_User__c,Case_Dealer__r.Dealer_ND_Code__c,Case_Dealer__r.Name,Case_Dealer_User__r.Dealer_GC_Code__c,Case_Dealer__r.Dealer_GS_Code__c from Case where ID =:shrcaseId];                
        }
        if(!caserecList.isEmpty() && caserecList != null)
        {
            for(Case listca:caserecList)
            {           
                userId.add(listca.Case_Dealer__c);  
                CaseDealerUserId.add(listca.Case_Dealer_User__c); 
                if(listca.Case_Dealer_User__r.Dealer_GC_Code__c !=null)
                {
                    DealerGccode.add(listca.Case_Dealer_User__r.Dealer_GC_Code__c);
                }                       
                if(listca.Case_Dealer__r.Dealer_GS_Code__c!=null)
                {
                    DealerGScode.add(listca.Case_Dealer__r.Dealer_GS_Code__c); 
                }              
            }
        }
        if(DealerGccode!=null || DealerGScode!=null)
        {
            DealeAcc=[Select id,Dealer_GC_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and (Dealer_GC_Code__c=:DealerGccode OR Dealer_GS_Code__c =:DealerGScode)];
        }
        if(DealeAcc!=null)
            for(Account dealerac:DealeAcc)
        {
            if(dealerac.Dealer_ND_Code__c !=null)
                DealerNDCode.add(dealerac.Dealer_ND_Code__c);
        }     
        System.debug('@@@@@@ userId venky'+userId);
        
        if(!DealerNDCode.isempty() && DealerNDCode != null)
        {
            partnerUserList = [select id,name,developername from group where name =:DealerNDCode];
        }
        
        if(!caserecList.isEmpty() && caserecList != null)
        { 
            for(group us : partnerUserList)
            {
                for(Case shrcs : caserecList)
                {           
                    CaseShare shrcase = new CaseShare();
                    shrcase.CaseId = shrcs.id;
                    shrcase.CaseAccessLevel = 'edit';
                    shrcase.UserOrGroupId = us.id;
                    CaseSharingRecord.add(shrcase);                 
                }
            } 
        }
        Database.SaveResult[] lsr = Database.insert(CaseSharingRecord,false);       
    } */
   /* public static void roleRestrictionForCCC(List<Case> LstnewCase,Map<Id,Case> oldValcase,Boolean isUpdate,Boolean isDelete)
    {
      Id caseMBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
      Id caseInqRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
      Id userids=userinfo.getUserId();
       Id roleId=userinfo.getUserRoleId();
       Id profileId=userinfo.getProfileId();
       String rolename=[Select Id,Name from UserRole where Id=:roleId].Name;
       String profilename=[Select Id,Name from Profile where Id=:profileId].Name;
       system.debug('RoleName::'+rolename);
       if(trigger.isBefore && trigger.isUpdate)
       {
         for(case cs: LstnewCase)
            { 
              if((rolename == 'Call Center Operator' || profilename == 'MBK CCC Retail Operator') && cs.Ownerid != userids && cs.MD__c=='KR' && (cs.RecordTypeId == caseMBRecordTypeId || cs.RecordTypeId == caseInqRecordTypeId))
              {
                if(cs.AccountId !=oldValcase.get(cs.id).AccountId || cs.Other_Type_Comments__c !=oldValcase.get(cs.id).Other_Type_Comments__c || cs.Subject !=oldValcase.get(cs.id).Subject || cs.Case_Class__c !=oldValcase.get(cs.id).Case_Class__c || cs.Case_Type__c !=oldValcase.get(cs.id).Case_Type__c || cs.Case_SubType__c !=oldValcase.get(cs.id).Case_SubType__c || cs.Case_SubSubType__c !=oldValcase.get(cs.id).Case_SubSubType__c || 
                cs.Case_Situation__c !=oldValcase.get(cs.id).Case_Situation__c || cs.Case_Department__c !=oldValcase.get(cs.id).Case_Department__c || cs.Customer_Request__c !=oldValcase.get(cs.id).Customer_Request__c || cs.Response_Type__c !=oldValcase.get(cs.id).Response_Type__c || cs.Contact !=oldValcase.get(cs.id).Contact || cs.Requires_Dealer_Contact__c !=oldValcase.get(cs.id).Requires_Dealer_Contact__c || 
                cs.Info_Source__c !=oldValcase.get(cs.id).Info_Source__c || cs.Perferred_Contact_Email__c !=oldValcase.get(cs.id).Perferred_Contact_Email__c || cs.Info_Subsource__c !=oldValcase.get(cs.id).Info_Subsource__c || cs.Handling_Level__c !=oldValcase.get(cs.id).Handling_Level__c || cs.Cause__c !=oldValcase.get(cs.id). Cause__c || cs.Case_Status__c !=oldValcase.get(cs.id).Case_Status__c || 
                cs.DeadLine__c !=oldValcase.get(cs.id).DeadLine__c || cs.Data_Subsource__c !=oldValcase.get(cs.id).Data_Subsource__c || cs.Approval_Submit_Date__c !=oldValcase.get(cs.id).Approval_Submit_Date__c || cs.Escalate_Date_to_CO__c !=oldValcase.get(cs.id).Escalate_Date_to_CO__c || cs.Progress_Status__c !=oldValcase.get(cs.id).Progress_Status__c || cs.MBK_Case_Class__c !=oldValcase.get(cs.id).MBK_Case_Class__c || 
                cs.MBK_Case_Sub_Type__c !=oldValcase.get(cs.id).MBK_Case_Sub_Type__c || cs.MBK_Case_Type__c !=oldValcase.get(cs.id).MBK_Case_Type__c || cs.Customer_Type__c !=oldValcase.get(cs.id).Customer_Type__c || cs.Car_Type__c !=oldValcase.get(cs.id).Car_Type__c || cs.Dealer_Contact__c !=oldValcase.get(cs.id).Dealer_Contact__c || cs.Customer_Satisfaction__c !=oldValcase.get(cs.id).Customer_Satisfaction__c || 
                cs.Call_Duration__c !=oldValcase.get(cs.id).Call_Duration__c || cs.SendEmailToGateKeeper__c !=oldValcase.get(cs.id).SendEmailToGateKeeper__c || cs.Vehicle_Brand__c !=oldValcase.get(cs.id).Vehicle_Brand__c || cs.US_VIN__c !=oldValcase.get(cs.id).US_VIN__c || cs.Car_Model__c !=oldValcase.get(cs.id).Car_Model__c || cs.EU_VIN__c !=oldValcase.get(cs.id).EU_VIN__c || cs.Vehicle_Model__c !=oldValcase.get(cs.id).Vehicle_Model__c || 
                cs.Vehicle_Class__c !=oldValcase.get(cs.id).Vehicle_Class__c || cs.CarBrandOne__c !=oldValcase.get(cs.id).CarBrandOne__c || cs.Car_Remarks__c !=oldValcase.get(cs.id).Car_Remarks__c || cs.CarModelOne__c !=oldValcase.get(cs.id).CarModelOne__c || cs.CarModelTwo__c !=oldValcase.get(cs.id).CarModelTwo__c || cs.CarModelThree__c !=oldValcase.get(cs.id).CarModelThree__c || cs.CarBrandTwo__c !=oldValcase.get(cs.id).CarBrandTwo__c || 
                cs.CarBrandThree__c !=oldValcase.get(cs.id).CarBrandThree__c || cs.CarClassOne__c !=oldValcase.get(cs.id).CarClassOne__c || cs.CarClassTwo__c !=oldValcase.get(cs.id).CarClassTwo__c || cs.CarClassThree__c !=oldValcase.get(cs.id).CarClassThree__c || (oldValcase.get(cs.id).Parentid !=null && cs.Parentid !=oldValcase.get(cs.id).Parentid) || 
                cs.Risk_classification__c !=oldValcase.get(cs.id).Risk_classification__c || cs.Critical_Complaint__c !=oldValcase.get(cs.id).Critical_Complaint__c || cs.Related_Department__c !=oldValcase.get(cs.id).Related_Department__c || cs.Number_of_Customer_Visits__c !=oldValcase.get(cs.id).Number_of_Customer_Visits__c || cs.Improvement_Department__c !=oldValcase.get(cs.id).Improvement_Department__c || cs.Recall_ID__c !=oldValcase.get(cs.id).Recall_ID__c || 
                cs.Case_Dealer_User__c !=oldValcase.get(cs.id).Case_Dealer_User__c || cs.Feedback_to_CAC_New__c !=oldValcase.get(cs.id).Feedback_to_CAC_New__c || cs.Feedback_Read__c !=oldValcase.get(cs.id).Feedback_Read__c || cs.Dealer_Feedback__c !=oldValcase.get(cs.id).Dealer_Feedback__c || cs.Feedback_Required__c !=oldValcase.get(cs.id).Feedback_Required__c || cs.Feedback_Date__c !=oldValcase.get(cs.id).Feedback_Date__c || cs.TL_Reviewed__c !=oldValcase.get(cs.id).TL_Reviewed__c || 
                cs.Lead__c !=oldValcase.get(cs.id).Lead__c || cs.Campaign__c !=oldValcase.get(cs.id).Campaign__c || cs.Submit_to_public_solutions__c !=oldValcase.get(cs.id).Submit_to_public_solutions__c || cs.Knowledge_Complete_Flag__c !=oldValcase.get(cs.id).Knowledge_Complete_Flag__c || cs.Customer_Care_Owner__c !=oldValcase.get(cs.id).Customer_Care_Owner__c || cs.Approver__c !=oldValcase.get(cs.id).Approver__c || cs.Ref_No_Central__c !=oldValcase.get(cs.id).Ref_No_Central__c || 
                cs.Customer_Statement__c !=oldValcase.get(cs.id).Customer_Statement__c || cs.MPC_Internal_Notes__c !=oldValcase.get(cs.id).MPC_Internal_Notes__c || cs.Description !=oldValcase.get(cs.id).Description || cs.PR_Comment_for_Dealer__c !=oldValcase.get(cs.id).PR_Comment_for_Dealer__c || cs.RecordTypeId !=oldValcase.get(cs.id).RecordTypeId || cs.Origin !=oldValcase.get(cs.id).Origin || cs.Data_Source__c !=oldValcase.get(cs.id).Data_Source__c)
                {
                  cs.addError(system.label.Insufficient_access_to_update +'Owner,Vehicle,Status,Overdue,Overdue Reason,Priority,Resolved date,Primary case dealer');
                }
                if(cs.AccountId !=oldValcase.get(cs.id).AccountId)
                {
                    cs.AccountId.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Other_Type_Comments__c !=oldValcase.get(cs.id).Other_Type_Comments__c)
                {
                    cs.Other_Type_Comments__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Subject !=oldValcase.get(cs.id).Subject)
                {
                    cs.Subject.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Class__c !=oldValcase.get(cs.id).Case_Class__c)
                {
                    cs.Case_Class__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Lead__c !=oldValcase.get(cs.id).Lead__c)
                {
                    cs.Lead__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Type__c !=oldValcase.get(cs.id).Case_Type__c)
                {
                    cs.Case_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_SubType__c !=oldValcase.get(cs.id).Case_SubType__c)
                {
                    cs.Case_SubType__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_SubSubType__c !=oldValcase.get(cs.id).Case_SubSubType__c)
                {
                    cs.Case_SubSubType__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Situation__c !=oldValcase.get(cs.id).Case_Situation__c)
                {
                    cs.Case_Situation__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Department__c !=oldValcase.get(cs.id).Case_Department__c)
                {
                    cs.Case_Department__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Request__c !=oldValcase.get(cs.id).Customer_Request__c)
                {
                    cs.Customer_Request__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Response_Type__c !=oldValcase.get(cs.id).Response_Type__c)
                {
                    cs.Response_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Contactid !=oldValcase.get(cs.id).Contactid)
                {
                    cs.Contactid.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Requires_Dealer_Contact__c !=oldValcase.get(cs.id).Requires_Dealer_Contact__c)
                {
                    cs.Requires_Dealer_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Info_Source__c !=oldValcase.get(cs.id).Info_Source__c)
                {
                    cs.Info_Source__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Perferred_Contact_Email__c !=oldValcase.get(cs.id).Perferred_Contact_Email__c)
                {
                    cs.Perferred_Contact_Email__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Info_Subsource__c !=oldValcase.get(cs.id).Info_Subsource__c)
                {
                    cs.Info_Subsource__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Handling_Level__c !=oldValcase.get(cs.id).Handling_Level__c)
                {
                    cs.Handling_Level__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Cause__c !=oldValcase.get(cs.id). Cause__c)
                {
                    cs.Cause__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Status__c !=oldValcase.get(cs.id).Case_Status__c)
                {
                    cs.Case_Status__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.DeadLine__c !=oldValcase.get(cs.id).DeadLine__c)
                {
                    cs.DeadLine__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Data_Subsource__c !=oldValcase.get(cs.id).Data_Subsource__c)
                {
                    cs.Data_Subsource__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Approval_Submit_Date__c !=oldValcase.get(cs.id).Approval_Submit_Date__c)
                {
                    cs.Approval_Submit_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Escalate_Date_to_CO__c !=oldValcase.get(cs.id).Escalate_Date_to_CO__c)
                {
                    cs.Escalate_Date_to_CO__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Progress_Status__c !=oldValcase.get(cs.id).Progress_Status__c)
                {
                    cs.Progress_Status__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.MBK_Case_Class__c !=oldValcase.get(cs.id).MBK_Case_Class__c)
                {
                    cs.MBK_Case_Class__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.MBK_Case_Sub_Type__c !=oldValcase.get(cs.id).MBK_Case_Sub_Type__c)
                {
                    cs.MBK_Case_Sub_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.MBK_Case_Type__c !=oldValcase.get(cs.id).MBK_Case_Type__c)
                {
                    cs.MBK_Case_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Type__c !=oldValcase.get(cs.id).Customer_Type__c)
                {
                    cs.Customer_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Car_Type__c !=oldValcase.get(cs.id).Car_Type__c)
                {
                    cs.Car_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Dealer_Contact__c !=oldValcase.get(cs.id).Dealer_Contact__c)
                {
                    cs.Dealer_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Satisfaction__c !=oldValcase.get(cs.id).Customer_Satisfaction__c)
                {
                    cs.Customer_Satisfaction__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Call_Duration__c !=oldValcase.get(cs.id).Call_Duration__c)
                {
                    cs.Call_Duration__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.SendEmailToGateKeeper__c !=oldValcase.get(cs.id).SendEmailToGateKeeper__c)
                {
                    cs.SendEmailToGateKeeper__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Brand__c !=oldValcase.get(cs.id).Vehicle_Brand__c)
                {
                    cs.Vehicle_Brand__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.US_VIN__c !=oldValcase.get(cs.id).US_VIN__c)
                {
                    cs.US_VIN__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Car_Model__c !=oldValcase.get(cs.id).Car_Model__c)
                {
                    cs.Car_Model__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.EU_VIN__c !=oldValcase.get(cs.id).EU_VIN__c)
                {
                    cs.EU_VIN__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Model__c !=oldValcase.get(cs.id).Vehicle_Model__c)
                {
                    cs.Vehicle_Model__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Class__c !=oldValcase.get(cs.id).Vehicle_Class__c)
                {
                    cs.Vehicle_Class__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarBrandOne__c !=oldValcase.get(cs.id).CarBrandOne__c)
                {
                    cs.CarBrandOne__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Car_Remarks__c !=oldValcase.get(cs.id).Car_Remarks__c)
                {
                    cs.Car_Remarks__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarModelOne__c !=oldValcase.get(cs.id).CarModelOne__c)
                {
                    cs.CarModelOne__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarModelTwo__c !=oldValcase.get(cs.id).CarModelTwo__c)
                {
                    cs.CarModelTwo__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarModelThree__c !=oldValcase.get(cs.id).CarModelThree__c)
                {
                    cs.CarModelThree__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarClassOne__c !=oldValcase.get(cs.id).CarClassOne__c)
                {
                    cs.CarClassOne__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarClassTwo__c !=oldValcase.get(cs.id).CarClassTwo__c)
                {
                    cs.CarClassTwo__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.CarClassThree__c !=oldValcase.get(cs.id).CarClassThree__c)
                {
                    cs.CarClassThree__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
               
                if(oldValcase.get(cs.id).Parentid !=null && cs.Parentid !=oldValcase.get(cs.id).Parentid)
                {
                    cs.Parentid.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Risk_classification__c !=oldValcase.get(cs.id).Risk_classification__c)
                {
                    cs.Risk_classification__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Critical_Complaint__c !=oldValcase.get(cs.id).Critical_Complaint__c)
                {
                    cs.Critical_Complaint__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Related_Department__c !=oldValcase.get(cs.id).Related_Department__c)
                {
                    cs.Related_Department__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Number_of_Customer_Visits__c !=oldValcase.get(cs.id).Number_of_Customer_Visits__c)
                {
                    cs.Number_of_Customer_Visits__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Improvement_Department__c !=oldValcase.get(cs.id).Improvement_Department__c)
                {
                    cs.Improvement_Department__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Recall_ID__c !=oldValcase.get(cs.id).Recall_ID__c)
                {
                    cs.Recall_ID__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Dealer_User__c !=oldValcase.get(cs.id).Case_Dealer_User__c)
                {
                    cs.Case_Dealer_User__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_to_CAC_New__c !=oldValcase.get(cs.id).Feedback_to_CAC_New__c)
                {
                    cs.Feedback_to_CAC_New__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_Read__c !=oldValcase.get(cs.id).Feedback_Read__c)
                {
                    cs.Feedback_Read__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Dealer_Feedback__c !=oldValcase.get(cs.id).Dealer_Feedback__c)
                {
                    cs.Dealer_Feedback__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_Required__c !=oldValcase.get(cs.id).Feedback_Required__c)
                {
                    cs.Feedback_Required__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_Date__c !=oldValcase.get(cs.id).Feedback_Date__c)
                {
                    cs.Feedback_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.TL_Reviewed__c !=oldValcase.get(cs.id).TL_Reviewed__c)
                {
                    cs.TL_Reviewed__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Campaign__c !=oldValcase.get(cs.id).Campaign__c)
                {
                    cs.Campaign__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Submit_to_public_solutions__c !=oldValcase.get(cs.id).Submit_to_public_solutions__c)
                {
                    cs.Submit_to_public_solutions__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Knowledge_Complete_Flag__c !=oldValcase.get(cs.id).Knowledge_Complete_Flag__c)
                {
                    cs.Knowledge_Complete_Flag__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Care_Owner__c !=oldValcase.get(cs.id).Customer_Care_Owner__c)
                {
                    cs.Customer_Care_Owner__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Approver__c !=oldValcase.get(cs.id).Approver__c)
                {
                    cs.Approver__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Ref_No_Central__c !=oldValcase.get(cs.id).Ref_No_Central__c)
                {
                    cs.Ref_No_Central__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Statement__c !=oldValcase.get(cs.id).Customer_Statement__c)
                {
                    cs.Customer_Statement__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.MPC_Internal_Notes__c !=oldValcase.get(cs.id).MPC_Internal_Notes__c)
                {
                    cs.MPC_Internal_Notes__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Description !=oldValcase.get(cs.id).Description)
                {
                    cs.Description.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.PR_Comment_for_Dealer__c !=oldValcase.get(cs.id).PR_Comment_for_Dealer__c)
                {
                    cs.PR_Comment_for_Dealer__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.RecordTypeId !=oldValcase.get(cs.id).RecordTypeId)
                {
                    cs.RecordTypeId.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Origin !=oldValcase.get(cs.id).Origin)
                {
                    cs.Origin.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Data_Source__c !=oldValcase.get(cs.id).Data_Source__c)
                {
                    cs.Data_Source__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
              }
               if((rolename == 'Call Center Supervisor' || rolename == 'Manager' || profilename == 'MBK CCC Retail - Manager') && cs.Ownerid != userids && cs.MD__c=='KR' && (cs.RecordTypeId == caseMBRecordTypeId || cs.RecordTypeId == caseInqRecordTypeId))
              {
                if(cs.ContactId !=oldValcase.get(cs.id).ContactId || cs.AccountId !=oldValcase.get(cs.id).AccountId || cs.Case_Class__c !=oldValcase.get(cs.id).Case_Class__c || cs.Case_Type__c !=oldValcase.get(cs.id).Case_Type__c || cs.Case_SubType__c !=oldValcase.get(cs.id).Case_SubType__c || cs.Perferred_Contact_Email__c !=oldValcase.get(cs.id).Perferred_Contact_Email__c || cs.Product_Quality_Category__c !=oldValcase.get(cs.id).Product_Quality_Category__c ||
                cs.Priority !=oldValcase.get(cs.id).Priority || cs.Share_to_Regional_Office__c !=oldValcase.get(cs.id).Share_to_Regional_Office__c || cs.Handling_Level__c !=oldValcase.get(cs.id).Handling_Level__c || cs.Data_Source__c !=oldValcase.get(cs.id).Data_Source__c || cs.Data_Subsource__c !=oldValcase.get(cs.id).Data_Subsource__c || cs.Complaint_Creator_Department__c !=oldValcase.get(cs.id).Complaint_Creator_Department__c || cs.Subject !=oldValcase.get(cs.id).Subject ||
                cs.Description !=oldValcase.get(cs.id).Description || cs.DescriptionOne__c !=oldValcase.get(cs.id).DescriptionOne__c || cs.SendEmailToGateKeeper__c !=oldValcase.get(cs.id).SendEmailToGateKeeper__c || cs.Vehicle_Relationship__c !=oldValcase.get(cs.id).Vehicle_Relationship__c || cs.Vehicle_Brand__c !=oldValcase.get(cs.id).Vehicle_Brand__c || cs.Vehicle__c!=oldValcase.get(cs.id).Vehicle__c || cs.Vehicle_Class__c !=oldValcase.get(cs.id).Vehicle_Class__c || 
                cs.VIN_Code__c!=oldValcase.get(cs.id).VIN_Code__c || cs.Vehicle_Model__c!=oldValcase.get(cs.id).Vehicle_Model__c || cs.Vehicle_Source__c!=oldValcase.get(cs.id).Vehicle_Source__c || cs.Details_for_customer_owned_MB_vehicle__c!=oldValcase.get(cs.id).Details_for_customer_owned_MB_vehicle__c || cs.US_VIN__c!=oldValcase.get(cs.id).US_VIN__c || cs.EU_VIN__c!=oldValcase.get(cs.id).EU_VIN__c || 
                cs.Dealer_Contact__c!=oldValcase.get(cs.id).Dealer_Contact__c || cs.Feedback_Read__c!=oldValcase.get(cs.id).Feedback_Read__c || cs.Support_Dealer_1__c!=oldValcase.get(cs.id).Support_Dealer_1__c || cs.Support_Dealer_2__c!=oldValcase.get(cs.id).Support_Dealer_2__c || cs.Support_Dealer_3__c!=oldValcase.get(cs.id).Support_Dealer_3__c || cs.Dealer_Feedback__c!=oldValcase.get(cs.id).Dealer_Feedback__c || (oldValcase.get(cs.id).Parentid !=null && cs.Parentid!=oldValcase.get(cs.id).Parentid) || 
                cs.Case_RepeatCause__c!=oldValcase.get(cs.id).Case_RepeatCause__c || cs.SSI__c!=oldValcase.get(cs.id).SSI__c || cs.Results_Response__c!=oldValcase.get(cs.id).Results_Response__c || cs.Result__c!=oldValcase.get(cs.id).Result__c || cs.Final__c!=oldValcase.get(cs.id).Final__c || cs.On_Site_Manager_Confirmed__c!=oldValcase.get(cs.id).On_Site_Manager_Confirmed__c || cs.SuppliedEmail!=oldValcase.get(cs.id).SuppliedEmail || cs.Origin !=oldValcase.get(cs.id).Origin ||
                cs.Lead__c !=oldValcase.get(cs.id).Lead__c || cs.RecordTypeId!=oldValcase.get(cs.id).RecordTypeId || cs.Customer_Request__c !=oldValcase.get(cs.id).Customer_Request__c || cs.Other_Type_Comments__c !=oldValcase.get(cs.id).Other_Type_Comments__c || cs.Response_Type__c !=oldValcase.get(cs.id).Response_Type__c || cs.Requires_Dealer_Contact__c !=oldValcase.get(cs.id).Requires_Dealer_Contact__c || cs.DeadLine__c !=oldValcase.get(cs.id).DeadLine__c || cs.Escalate_Date_to_CO__c !=oldValcase.get(cs.id).Escalate_Date_to_CO__c ||
                cs.Progress_Status__c !=oldValcase.get(cs.id).Progress_Status__c || cs.Cause__c !=oldValcase.get(cs.id). Cause__c || cs.Car_Remarks__c !=oldValcase.get(cs.id).Car_Remarks__c || cs.Customer_Type__c !=oldValcase.get(cs.id).Customer_Type__c || cs.Call_Duration__c !=oldValcase.get(cs.id).Call_Duration__c ||cs.Recall_ID__c !=oldValcase.get(cs.id).Recall_ID__c || cs.Car_Type__c !=oldValcase.get(cs.id).Car_Type__c ||
                cs.Customer_Satisfaction__c !=oldValcase.get(cs.id).Customer_Satisfaction__c || cs.Case_Dealer_User__c !=oldValcase.get(cs.id).Case_Dealer_User__c || cs.Feedback_Required__c !=oldValcase.get(cs.id).Feedback_Required__c || cs.TL_Reviewed__c !=oldValcase.get(cs.id).TL_Reviewed__c || cs.Campaign__c !=oldValcase.get(cs.id).Campaign__c || cs.Submit_to_public_solutions__c !=oldValcase.get(cs.id).Submit_to_public_solutions__c || cs.Knowledge_Complete_Flag__c !=oldValcase.get(cs.id).Knowledge_Complete_Flag__c ||
                cs.Customer_Statement__c !=oldValcase.get(cs.id).Customer_Statement__c)
                {
                    cs.addError(system.label.Insufficient_access_to_update +'Owner,MBK Case Class,MBK Case Type,MBK Case SubType,Status,Priority,Resolved date,Overdue,Overdue Reason');
                }
                if(cs.ContactId !=oldValcase.get(cs.id).ContactId)
                {
                    cs.ContactId.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.AccountId !=oldValcase.get(cs.id).AccountId)
                {
                    cs.AccountId.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Class__c !=oldValcase.get(cs.id).Case_Class__c)
                {
                    cs.Case_Class__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Type__c !=oldValcase.get(cs.id).Case_Type__c)
                {
                    cs.Case_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_SubType__c !=oldValcase.get(cs.id).Case_SubType__c)
                {
                    cs.Case_SubType__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Perferred_Contact_Email__c !=oldValcase.get(cs.id).Perferred_Contact_Email__c)
                {
                    cs.Perferred_Contact_Email__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Lead__c !=oldValcase.get(cs.id).Lead__c)
                {
                    cs.Lead__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Product_Quality_Category__c !=oldValcase.get(cs.id).Product_Quality_Category__c)
                {
                    cs.Product_Quality_Category__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Priority !=oldValcase.get(cs.id).Priority)
                {
                    cs.Priority.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Share_to_Regional_Office__c !=oldValcase.get(cs.id).Share_to_Regional_Office__c)
                {
                    cs.Share_to_Regional_Office__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Handling_Level__c !=oldValcase.get(cs.id).Handling_Level__c)
                {
                    cs.Handling_Level__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Data_Source__c !=oldValcase.get(cs.id).Data_Source__c)
                {
                    cs.Data_Source__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Data_Subsource__c !=oldValcase.get(cs.id).Data_Subsource__c)
                {
                    cs.Data_Subsource__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Complaint_Creator_Department__c !=oldValcase.get(cs.id).Complaint_Creator_Department__c)
                {
                    cs.Complaint_Creator_Department__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Subject !=oldValcase.get(cs.id).Subject)
                {
                    cs.Subject.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Description !=oldValcase.get(cs.id).Description)
                {
                    cs.Description.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.DescriptionOne__c !=oldValcase.get(cs.id).DescriptionOne__c)
                {
                    cs.DescriptionOne__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.SendEmailToGateKeeper__c !=oldValcase.get(cs.id).SendEmailToGateKeeper__c)
                {
                    cs.SendEmailToGateKeeper__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Relationship__c !=oldValcase.get(cs.id).Vehicle_Relationship__c)
                {
                    cs.Vehicle_Relationship__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Brand__c !=oldValcase.get(cs.id).Vehicle_Brand__c)
                {
                    cs.Vehicle_Brand__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle__c!=oldValcase.get(cs.id).Vehicle__c)
                {
                    cs.Vehicle__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Class__c !=oldValcase.get(cs.id).Vehicle_Class__c)
                {
                    cs.Vehicle_Class__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.VIN_Code__c!=oldValcase.get(cs.id).VIN_Code__c)
                {
                    cs.VIN_Code__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Model__c!=oldValcase.get(cs.id).Vehicle_Model__c)
                {
                    cs.Vehicle_Model__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Vehicle_Source__c!=oldValcase.get(cs.id).Vehicle_Source__c)
                {
                    cs.Vehicle_Source__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Details_for_customer_owned_MB_vehicle__c!=oldValcase.get(cs.id).Details_for_customer_owned_MB_vehicle__c)
                {
                    cs.Details_for_customer_owned_MB_vehicle__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.US_VIN__c!=oldValcase.get(cs.id).US_VIN__c)
                {
                    cs.US_VIN__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.EU_VIN__c!=oldValcase.get(cs.id).EU_VIN__c)
                {
                    cs.EU_VIN__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Dealer_Contact__c!=oldValcase.get(cs.id).Dealer_Contact__c)
                {
                    cs.Dealer_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_Read__c!=oldValcase.get(cs.id).Feedback_Read__c)
                {
                    cs.Feedback_Read__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Support_Dealer_1__c!=oldValcase.get(cs.id).Support_Dealer_1__c)
                {
                    cs.Support_Dealer_1__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Support_Dealer_2__c!=oldValcase.get(cs.id).Support_Dealer_2__c)
                {
                    cs.Support_Dealer_2__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Support_Dealer_3__c!=oldValcase.get(cs.id).Support_Dealer_3__c)
                {
                    cs.Support_Dealer_3__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Dealer_Feedback__c!=oldValcase.get(cs.id).Dealer_Feedback__c)
                {
                    cs.Dealer_Feedback__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(oldValcase.get(cs.id).Parentid !=null && cs.Parentid!=oldValcase.get(cs.id).Parentid)
                {
                    cs.Parentid.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_RepeatCause__c!=oldValcase.get(cs.id).Case_RepeatCause__c)
                {
                    cs.Case_RepeatCause__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.SSI__c!=oldValcase.get(cs.id).SSI__c)
                {
                    cs.SSI__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Results_Response__c!=oldValcase.get(cs.id).Results_Response__c)
                {
                    cs.Results_Response__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Result__c!=oldValcase.get(cs.id).Result__c)
                {
                    cs.Result__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Final__c!=oldValcase.get(cs.id).Final__c)
                {
                    cs.Final__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.On_Site_Manager_Confirmed__c!=oldValcase.get(cs.id).On_Site_Manager_Confirmed__c)
                {
                    cs.On_Site_Manager_Confirmed__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.SuppliedEmail!=oldValcase.get(cs.id).SuppliedEmail)
                {
                    cs.SuppliedEmail.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Origin !=oldValcase.get(cs.id).Origin)
                {
                    cs.Origin.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.RecordTypeId!=oldValcase.get(cs.id).RecordTypeId)
                {
                    cs.RecordTypeId.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Request__c !=oldValcase.get(cs.id).Customer_Request__c)
                {
                    cs.Customer_Request__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Other_Type_Comments__c !=oldValcase.get(cs.id).Other_Type_Comments__c)
                {
                    cs.Other_Type_Comments__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Response_Type__c !=oldValcase.get(cs.id).Response_Type__c)
                {
                    cs.Response_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Requires_Dealer_Contact__c !=oldValcase.get(cs.id).Requires_Dealer_Contact__c)
                {
                    cs.Requires_Dealer_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.DeadLine__c !=oldValcase.get(cs.id).DeadLine__c)
                {
                    cs.DeadLine__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Escalate_Date_to_CO__c !=oldValcase.get(cs.id).Escalate_Date_to_CO__c)
                {
                    cs.Escalate_Date_to_CO__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Progress_Status__c !=oldValcase.get(cs.id).Progress_Status__c)
                {
                    cs.Progress_Status__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Cause__c !=oldValcase.get(cs.id). Cause__c)
                {
                    cs.Cause__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Car_Remarks__c !=oldValcase.get(cs.id).Car_Remarks__c)
                {
                    cs.Car_Remarks__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Type__c !=oldValcase.get(cs.id).Customer_Type__c)
                {
                    cs.Customer_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Call_Duration__c !=oldValcase.get(cs.id).Call_Duration__c)
                {
                    cs.Call_Duration__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Recall_ID__c !=oldValcase.get(cs.id).Recall_ID__c)
                {
                    cs.Recall_ID__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Car_Type__c !=oldValcase.get(cs.id).Car_Type__c)
                {
                    cs.Car_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Satisfaction__c !=oldValcase.get(cs.id).Customer_Satisfaction__c)
                {
                    cs.Customer_Satisfaction__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Case_Dealer_User__c !=oldValcase.get(cs.id).Case_Dealer_User__c)
                {
                    cs.Case_Dealer_User__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Feedback_Required__c !=oldValcase.get(cs.id).Feedback_Required__c)
                {
                    cs.Feedback_Required__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.TL_Reviewed__c !=oldValcase.get(cs.id).TL_Reviewed__c)
                {
                    cs.TL_Reviewed__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Campaign__c !=oldValcase.get(cs.id).Campaign__c)
                {
                    cs.Campaign__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Submit_to_public_solutions__c !=oldValcase.get(cs.id).Submit_to_public_solutions__c)
                {
                    cs.Submit_to_public_solutions__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Knowledge_Complete_Flag__c !=oldValcase.get(cs.id).Knowledge_Complete_Flag__c)
                {
                    cs.Knowledge_Complete_Flag__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
                if(cs.Customer_Statement__c !=oldValcase.get(cs.id).Customer_Statement__c)
                {
                    cs.Customer_Statement__c.addError(system.label.Insufficient_access_to_update_this_field);
                }
              }
            }
       }
       if(trigger.isBefore && trigger.isDelete)
           {
            for(case cs: LstnewCase)
                { 
                  if((rolename == 'Call Center Operator' || profilename == 'MBK CCC Retail - Manager' || rolename == 'Manager' ||rolename == 'Call Center Supervisor' || profilename == 'MBK CCC Retail Operator') && cs.Ownerid != userids && cs.MD__c=='KR' && (cs.RecordTypeId == caseMBRecordTypeId || cs.RecordTypeId == caseInqRecordTypeId))
                      {
                        cs.addError(system.label.You_cannot_delete_this_record);
                      }
                      }
           }
    }*/
    public static void updateCaseDeadLine(List<Case> LstnewCase, Map<Id,Case> oldValcase, string action){
          List<Id> caseIds = new List<Id>();
          Id caseMBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
           if(action == 'isUpdate')
        {
            for(case cs: LstnewCase)
            {
                
                if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.Priority!= oldValcase.get(cs.id).Priority && cs.RecordTypeId == caseMBRecordTypeId)
                {
                    caseIds.add(cs.id);                
                }
            }        
        }
        if(action == 'isInsert')
        {
            for(case cs: LstnewCase)
            {
                
                if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.RecordTypeId == caseMBRecordTypeId)
                {
                    caseIds.add(cs.id);                
                }
            }        
        }       
        
        if(caseIds.size()>0)
        {
            string caseJsonStr = JSON.serialize(caseIds);            
            system.debug('PSM caseJsonStr + caseIds '+'  '+caseJsonStr);
            updateCaseDeadLine.caseDeadLinesetter(caseJsonStr);
        }
	}
	
	//---------------------------- Case Share - SFDCKR-964 ----------------------------
    // Added By - Sreenivasareddy
  
    public static void casesharehierarchy(List<Case> LstnewCase) {
        list<id> ownerids = new list<id>();
        list<id> caseids= new list<id>();
        for(case c:LstnewCase) {
           if(c.MD__c=='KR') {
              ownerids.add(c.OwnerId);
              system.debug('*****Caseownerlist' +ownerids);
		   }	  
        }
        
        if(!Test.isRunningTest()){
        //before insert new casesharings need to delete old casesharings***...
        If(Trigger.IsUpdate){
           List<CaseShare> sharesToDelete = [Select UserOrGroupId,RowCause,id From CaseShare where RowCause='Ownershare' and CaseId in:caseids];
           if(!sharesToDelete.isEmpty()) {
              delete sharesToDelete;
           }
        }
        }
        
        Map<ID, User> usermap = new Map<ID, User>([Select Id,MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c  from User where id in: ownerids and Market__c = 'KR' and IsActive=true]);
        system.debug('Reporting Users' +usermap);
       
        List<CaseShare> caseShar = new List<CaseShare>();
        
        /* Sales Consultant Recors Sharing Process */
        
        for(case  cas : LstnewCase) {
            if(!usermap.containsKey(cas.ownerid))continue;
                user u = usermap.get(cas.ownerid);
            if(u.MBK_Partner_Roles__c == 'Sales Consultant') {
            system.debug('Team Leader' +u.MBK_Reporting_Partner_User__c);
                if(u.MBK_Reporting_Partner_User__c!=null || u.MBK_Reporting_Partner_User__c!='') {
                    CaseShare shareRec = new CaseShare();
                    shareRec.CaseId= cas.Id;
                    shareRec.UserOrGroupId  = u.MBK_Reporting_Partner_User__c;
                    shareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                    shareRec.CaseAccessLevel= 'Edit';
                    
                    caseShar.add(shareRec);
                }
                if(u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!=null || u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!='') {
                    CaseShare shareRec1 = new CaseShare();
                    shareRec1.CaseId= cas.Id;
                    shareRec1.UserOrGroupId  = u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c;
                    shareRec1.CaseAccessLevel= 'Edit';
                    shareRec1.RowCause = Schema.CaseShare.RowCause.Manual;
                    
                    caseShar.add(shareRec1);  
                }   
            }
        }

        /* Team Leader Recors Sharing Process */
        
        for(case  tlcas : LstnewCase) {
            if(!usermap.containsKey(tlcas.ownerid))continue;
                user tlu = usermap.get(tlcas.ownerid);
            if(tlu.MBK_Partner_Roles__c == 'Team Leader') {
            system.debug('Sales Manager' +tlu.MBK_Reporting_Partner_User__c);
                if(tlu.MBK_Reporting_Partner_User__c!=null || tlu.MBK_Reporting_Partner_User__c!='') {
                    CaseShare tlshareRec = new CaseShare();
                    tlshareRec.CaseId= tlcas.Id;
                    tlshareRec.UserOrGroupId  = tlu.MBK_Reporting_Partner_User__c;
                    tlshareRec.CaseAccessLevel= 'Edit';
                    tlshareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                    caseShar.add(tlshareRec);  
                }
            }
        }   
        If(caseShar != null & caseShar.size() > 0) {
            insert caseShar;
        }
    }
	//---------------------------- Case Owner Mail Send - SFDCKR-830 ----------------------------
    // Added By - Monalisa
  
    public static void sendEmailToQueue(List<Case> LstnewCase,string action) {
             list<Id> queueid = new list<Id>();
             list<GroupMember> ownerids = new list<GroupMember>();
             list<Id> userids= new list<Id>();
             list<Group> queueids = new list<Group>();
             list<String> queueName = new list<String>();
             boolean marketcheck=false;
             System.debug('*****Case List**' +LstnewCase);  
             for(case c:LstnewCase) {
               System.debug('c.owner.type---'+c.owner.type);
               if(c.MD__c=='KR' && String.valueof(c.ownerId).startsWith('00G')) {
              marketcheck=true;
              queueid .add(c.ownerId);
              system.debug('*****Queue Name**' +queueid );  
            }
            }
            queueids =[Select Id,Name,type from Group where type='Queue' and Id IN: queueid ];
            system.debug('*****Queue Name***' +queueids);         
           if(queueids.size()>0){
           for(Group gp:queueids){
              queueName.add(gp.Name);}}
            ownerids =[select UserOrGroupId,Group.Name from GroupMember where Group.Name IN: queueName];
              for(GroupMember gp:ownerids ){
              userids.add(gp.UserOrGroupId);      
        }
        system.debug('*****Queue Name' +queueids );  
           system.debug('*****Caseownerlist' +ownerids);
           system.debug('*****userids' +userids);
            system.debug('*****action Name***' +action);   
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        EmailTemplate e =[select id,name,Subject from EmailTemplate WHERE name = 'Case owner is updated' limit 1];
           message.setTemplateId(e.id);
          
           message.setSaveAsActivity(false);
            if(userids.size()>0){
                     message.setToAddresses(userids);
                      message.setTargetObjectId(userids[0]);
                 } 
          
              if(marketcheck){
                 Messaging.SendEmailResult[] m1=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
                 }
          
         system.debug('*****Message Sent');  
       
          }
}