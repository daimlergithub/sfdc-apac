/*
Once Sales or After-Sales lead is approved (created as approved lead or updated to the approved status):
Update sharing rule so that Dealer User, who belongs to the company to which the Assigned Dealer outlet of lead, can view/edit that lead. 
Created by:Surya Varma
Date:1/12/2016
*/
public class LeadHelperKR
{  
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    
    public static void handleAfterInsertOrUpdate(list<lead__c> leadlist1,Map<Id,Lead__C> leadOldMap)
    {
        Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        list<lead__c> leadlist = new list<lead__c>();
        list<account> dealerAccountList =new list<account>();
        Map<String,account>accountMap=new Map<String,account>();
        // Map<id,account>aMap=new Map<id,account>();
        set<id>dealerAccountIds = new set<id>();
        set<String> GCCode = new set<String>();
        Set<String> DealerGScode = new Set<String>();
        set<id> leadIds = new set<id>();
        set<id> parentIds = new set<id>();
        Set<String> DealerNDCode= new Set<String>();
        list<Lead__share>  leadshare=new list<lead__share>();       
        map<string,id> assgroupMap = new map<string,id>();
        List<Group> grplist=new List<Group>();
        
        for(Lead__c lead:leadlist1)
        {
            if((lead.RecordTypeId ==salesRecordTypeId )||(lead.RecordTypeId ==afterSalesRecordTypeId))
            {
                if(lead.Assigned_Dealer__c!=null && (trigger.isinsert || (trigger.isupdate && lead.OwnerId != leadOldMap.get(lead.Id).OwnerId || lead.Assigned_Dealer__c!=leadOldMap.get(lead.id).Assigned_Dealer__c)))
                { 
                    leadIds.add(lead.id);         
                }
            }
        }
        if(!leadIds.isEmpty() && leadIds != null)
        {
            leadlist = [Select id,recordtypeId,Assigned_Dealer__r.ParentId,CAC_Lead_Status__c,
                        Assigned_Dealer__r.Dealer_ND_Code__c,Assigned_Dealer__r.Dealer_GC_Code__c,Assigned_Dealer__r.Dealer_Type__c,
                        Assigned_Dealer__r.Dealer_GS_Code__c,Assigned_Dealer__c from Lead__c where Id IN:leadIds];
        }
        if(!leadlist.isEmpty() && leadlist != null)
        {
            for(Lead__c leds : leadlist)
            {
                if(leds.Assigned_Dealer__r.ParentId != null && leds.Assigned_Dealer__r.Dealer_Type__c == 'Outlet')
                {
                    parentIds.add(leds.Assigned_Dealer__r.ParentId);
                }
            }
        }
        if(!parentIds.isEmpty() && parentIds != null)
        {
            dealerAccountList = [select id,Dealer_ND_Code__c from Account where id =:parentIds];
        }
        
        for(lead__c le:leadlist)
        {
            /*SFDCKR-1044
              if(le.Assigned_Dealer__c != null)
            {
                dealerAccountIds.add(le.Assigned_Dealer__c);
            }
            if(le.Assigned_Dealer__r.Dealer_GC_Code__c  !=null)
            {
                GCCode.add(le.Assigned_Dealer__r.Dealer_GC_Code__c );
            }                       
            if(le.Assigned_Dealer__r.Dealer_GS_Code__c!=null)
            {
                DealerGScode.add(le.Assigned_Dealer__r.Dealer_GS_Code__c );
            }
        }
        if(dealerAccountIds.size()>0)
        {
            dealerAccountList = [Select id,Dealer_GC_Code__c ,Dealer_ND_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and (Dealer_GC_Code__c=:GCCode OR Dealer_GS_Code__c =:DealerGScode)];
        }
        if(dealerAccountList.size()>0)
        {
            for(account a:dealerAccountList)
            {
                if(a.Dealer_ND_Code__c != null)
                {
                    DealerNDCode.add(a.Dealer_ND_Code__c);
                    
                }
            }*/
            //Changes by Monalisa SFDCKR-1727
			if(le.Assigned_Dealer__r.Dealer_Type__c == 'Company'|| le.Assigned_Dealer__r.Dealer_Type__c == 'Outlet')
            {
                if(le.Assigned_Dealer__r.Dealer_ND_Code__c != null && le.Assigned_Dealer__r.Dealer_ND_Code__c != '')
                {
                    DealerNDCode.add(le.Assigned_Dealer__r.Dealer_ND_Code__c);
                }
            }
            if(!dealerAccountList.isEmpty() && dealerAccountList != null)
            {
                for(Account parntacc: dealerAccountList)
                {
                    if(le.Assigned_Dealer__r.ParentId == parntacc.id && le.Assigned_Dealer__r.Dealer_Type__c == 'Outlet')
                    {
                        if(parntacc.Dealer_ND_Code__c != null && parntacc.Dealer_ND_Code__c != '')
                        {
                            DealerNDCode.add(parntacc.Dealer_ND_Code__c);
                        }
                    }
                }
            }
        }
        if(!DealerNDCode.isEmpty() && DealerNDCode != null)
        {
            grplist = [select id ,Name ,Type from Group where Name IN: DealerNDCode];
        }
        for(Group assg:grplist)
        {               
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);
        }
        
        for(Lead__c lead:leadlist)  
        {        
            for(id m:assgroupMap.values())
            {                       
                Lead__share l=new Lead__share();
                l.ParentId=lead.id;
                l.UserOrGroupId = m;                   
                l.AccessLevel='edit';
                leadshare.add(l);
            }           
        }              
        Database.SaveResult[] lsr = Database.insert(leadshare,false); 
    }
     /* public static void roleRestrictionForCCC(List<Lead__c> Lstnewlead,Map<Id,Lead__c> oldVallead,Boolean isUpdate,Boolean isDelete)
    {
        
        Id userids=userinfo.getUserId();
        Id roleId=userinfo.getUserRoleId();
        Id profileId=userinfo.getProfileId();
        //String rolename=[Select Id,Name from UserRole where Id=:roleId].Name;
        String profilename=[Select Id,Name from Profile where Id=:profileId].Name;
         if(trigger.isBefore && trigger.isUpdate)
           {
             for(Lead__c ld : Lstnewlead)
                { 
                  if(profilename == 'MBK CCC Retail - Manager' && ld.Ownerid != userids && ld.MD__c=='KR' && (ld.RecordTypeId == salesRecordTypeId || ld.RecordTypeId == afterSalesRecordTypeId))
                      {
                        if(ld.Customer_Type__c!=oldVallead.get(ld.id).Customer_Type__c || ld.Contact__c!=oldVallead.get(ld.id).Contact__c || ld.Fax__c!=oldVallead.get(ld.id).Fax__c || ld.Company_Account__c!=oldVallead.get(ld.id).Company_Account__c || ld.Phone__c!=oldVallead.get(ld.id).Phone__c || ld.Source_Campaign__c!=oldVallead.get(ld.id).Source_Campaign__c || ld.Vehicle_Need__c!=oldVallead.get(ld.id).Vehicle_Need__c || ld.Vehicle_Need_Text__c!=oldVallead.get(ld.id).Vehicle_Need_Text__c || ld.Dealer_Comments__c!=oldVallead.get(ld.id).Dealer_Comments__c || ld.Case__c!=oldVallead.get(ld.id).Case__c || ld.VehicleRel_No__c!=oldVallead.get(ld.id).VehicleRel_No__c || ld.RecordTypeId!=oldVallead.get(ld.id).RecordTypeId ||
                           ld.CAC_Lead_Status__c!=oldVallead.get(ld.id).CAC_Lead_Status__c || ld.Lead_Latest_Phase__c!=oldVallead.get(ld.id).Lead_Latest_Phase__c || ld.Next_Contact_Customer_Date__c!=oldVallead.get(ld.id).Next_Contact_Customer_Date__c || ld.Lead_Priority__c!=oldVallead.get(ld.id).Lead_Priority__c || ld.MBK_Lead_DataSource__c!=oldVallead.get(ld.id).MBK_Lead_DataSource__c || ld.Re_visit__c!=oldVallead.get(ld.id).Re_visit__c || ld.Team__c!=oldVallead.get(ld.id).Team__c || ld.Next_Contact__c!=oldVallead.get(ld.id).Next_Contact__c || ld.Visited_Showroom_Date__c!=oldVallead.get(ld.id).Visited_Showroom_Date__c || ld.Order_Placed_Date__c!=oldVallead.get(ld.id).Order_Placed_Date__c || ld.Qualified_Date_Time__c!=oldVallead.get(ld.id).Qualified_Date_Time__c ||
                           ld.Invoice_Date__c!=oldVallead.get(ld.id).Invoice_Date__c || ld.Handover_Date__c!=oldVallead.get(ld.id).Handover_Date__c || ld.Quotation_Number__c!=oldVallead.get(ld.id).Quotation_Number__c || ld.Quotation_Date__c!=oldVallead.get(ld.id).Quotation_Date__c || ld.Quotation_Amount__c!=oldVallead.get(ld.id).Quotation_Amount__c || ld.Order_No__c!=oldVallead.get(ld.id).Order_No__c || ld.Order_Confirmation_Date__c!=oldVallead.get(ld.id).Order_Confirmation_Date__c || ld.Contact_Failed_For_3_Days_Date__c!=oldVallead.get(ld.id).Contact_Failed_For_3_Days_Date__c || ld.First_Contact_Customer_Date__c!=oldVallead.get(ld.id).First_Contact_Customer_Date__c || ld.Test_Drive_Date__c!=oldVallead.get(ld.id).Test_Drive_Date__c || ld.Registration_Number__c!=oldVallead.get(ld.id).Registration_Number__c || ld.Network_Registration_Date__c!=oldVallead.get(ld.id).Network_Registration_Date__c ||
                           ld.Invoice_Amount__c!=oldVallead.get(ld.id).Invoice_Amount__c || ld.Invoice_Number__c!=oldVallead.get(ld.id).Invoice_Number__c || ld.Order_Placed_Date_Time__c!=oldVallead.get(ld.id).Order_Placed_Date_Time__c || ld.Appointment_DateTime__c!=oldVallead.get(ld.id).Appointment_DateTime__c || ld.MBK_Lead_Desired_Service__c!=oldVallead.get(ld.id).MBK_Lead_Desired_Service__c || ld.Price_Range__c!=oldVallead.get(ld.id).Price_Range__c || ld.Payment_Mode__c!=oldVallead.get(ld.id).Payment_Mode__c || ld.Preferred_Contact_Method__c!=oldVallead.get(ld.id).Preferred_Contact_Method__c || ld.Preferred_Contact_Time__c!=oldVallead.get(ld.id).Preferred_Contact_Time__c || ld.Purchase_Time__c!=oldVallead.get(ld.id).Purchase_Time__c || ld.Purchased_CAC_Date_Time__c!=oldVallead.get(ld.id).Purchased_CAC_Date_Time__c || ld.Payment_Condition__c!=oldVallead.get(ld.id).Payment_Condition__c || ld.Contact_Timing__c!=oldVallead.get(ld.id).Contact_Timing__c || 
                           ld.Test_Drive_Detail__c!=oldVallead.get(ld.id).Test_Drive_Detail__c || ld.Preferred_Contact_Date__c!=oldVallead.get(ld.id).Preferred_Contact_Date__c || ld.Interested_Vehicle_Note__c!=oldVallead.get(ld.id).Interested_Vehicle_Note__c || ld.Interested_Competitor_Vehicle_Text__c!=oldVallead.get(ld.id).Interested_Competitor_Vehicle_Text__c || ld.Collectioner_Notes__c!=oldVallead.get(ld.id).Collectioner_Notes__c || ld.Dealer_Lost_Reason__c!=oldVallead.get(ld.id).Dealer_Lost_Reason__c || ld.MBK_Lost_Situation__c!=oldVallead.get(ld.id).MBK_Lost_Situation__c || ld.Lost_Comment__c!=oldVallead.get(ld.id).Lost_Comment__c || ld.Lost_Dealer_Date__c!=oldVallead.get(ld.id).Lost_Dealer_Date__c || ld.Lost_To__c!=oldVallead.get(ld.id).Lost_To__c || ld.Assigned_Dealer_by_Rule__c!=oldVallead.get(ld.id).Assigned_Dealer_by_Rule__c || ld.Recommended_Dealer__c!=oldVallead.get(ld.id).Recommended_Dealer__c || ld.X72H_Untouched__c!=oldVallead.get(ld.id).X72H_Untouched__c || 
                           ld.Customer_Preferred_Rep__c!=oldVallead.get(ld.id).Customer_Preferred_Rep__c || ld.Sales_Consultant__c!=oldVallead.get(ld.id).Sales_Consultant__c || ld.Drop_off_Time__c!=oldVallead.get(ld.id).Drop_off_Time__c || ld.Assigned_Date_Time__c!=oldVallead.get(ld.id).Assigned_Date_Time__c || ld.Service_Advisor__c!=oldVallead.get(ld.id).Service_Advisor__c || ld.Quotation_Print_Date__c!=oldVallead.get(ld.id).Quotation_Print_Date__c || ld.AfterSales_Vehicle__c!=oldVallead.get(ld.id).AfterSales_Vehicle__c || ld.Lost_Dealer_Date_Time__c!=oldVallead.get(ld.id).Lost_Dealer_Date_Time__c || ld.Requested_Service_DateTime1__c!=oldVallead.get(ld.id).Requested_Service_DateTime1__c || ld.Requested_Service_DateTime2__c!=oldVallead.get(ld.id).Requested_Service_DateTime2__c || ld.Next_Contact_Customer_Date__c!=oldVallead.get(ld.id).Next_Contact_Customer_Date__c || ld.Service_Date__c!=oldVallead.get(ld.id).Service_Date__c || ld.WIP_Number__c!=oldVallead.get(ld.id).WIP_Number__c || 
                           ld.Lead_Additional_Service__c!=oldVallead.get(ld.id).Lead_Additional_Service__c || ld.WIP_Created_Date__c!=oldVallead.get(ld.id).WIP_Created_Date__c || ld.Job_Card_Number__c!=oldVallead.get(ld.id).Job_Card_Number__c || ld.Job_Card_Date__c!=oldVallead.get(ld.id).Job_Card_Date__c || ld.Check_In_Date__c!=oldVallead.get(ld.id).Check_In_Date__c || ld.Check_Out_Date__c!=oldVallead.get(ld.id).Check_Out_Date__c) 
                            {
                                ld.addError(system.label.Insufficient_access_to_update +'Owner,Dealer Lead Status,Assigned Dealer,Lead Type,Lead SubType');
                            }
                                if(ld.Customer_Type__c !=oldVallead.get(ld.id).Customer_Type__c)
                                {
                                    ld.Customer_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact__c !=oldVallead.get(ld.id).Contact__c)
                                {
                                    ld.Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Fax__c !=oldVallead.get(ld.id).Fax__c)
                                {
                                    ld.Fax__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Company_Account__c !=oldVallead.get(ld.id).Company_Account__c)
                                {
                                    ld.Company_Account__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Phone__c !=oldVallead.get(ld.id).Phone__c)
                                {
                                    ld.Phone__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Source_Campaign__c !=oldVallead.get(ld.id).Source_Campaign__c)
                                {
                                    ld.Source_Campaign__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Vehicle_Need__c !=oldVallead.get(ld.id).Vehicle_Need__c)
                                {
                                    ld.Vehicle_Need__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Vehicle_Need_Text__c !=oldVallead.get(ld.id).Vehicle_Need_Text__c)
                                {
                                    ld.Vehicle_Need_Text__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Dealer_Comments__c !=oldVallead.get(ld.id).Dealer_Comments__c)
                                {
                                    ld.Dealer_Comments__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Case__c !=oldVallead.get(ld.id).Case__c)
                                {
                                    ld.Case__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.VehicleRel_No__c !=oldVallead.get(ld.id).VehicleRel_No__c)
                                {
                                    ld.VehicleRel_No__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.RecordTypeId !=oldVallead.get(ld.id).RecordTypeId)
                                {
                                    ld.RecordTypeId.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.CAC_Lead_Status__c !=oldVallead.get(ld.id).CAC_Lead_Status__c)
                                {
                                    ld.CAC_Lead_Status__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Latest_Phase__c !=oldVallead.get(ld.id).Lead_Latest_Phase__c)
                                {
                                    ld.Lead_Latest_Phase__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact_Customer_Date__c !=oldVallead.get(ld.id).Next_Contact_Customer_Date__c)
                                {
                                    ld.Next_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Priority__c !=oldVallead.get(ld.id).Lead_Priority__c)
                                {
                                    ld.Lead_Priority__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lead_DataSource__c !=oldVallead.get(ld.id).MBK_Lead_DataSource__c)
                                {
                                    ld.MBK_Lead_DataSource__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Re_visit__c !=oldVallead.get(ld.id).Re_visit__c)
                                {
                                    ld.Re_visit__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Team__c !=oldVallead.get(ld.id).Team__c)
                                {
                                    ld.Team__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact__c !=oldVallead.get(ld.id).Next_Contact__c)
                                {
                                    ld.Next_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Visited_Showroom_Date__c !=oldVallead.get(ld.id).Visited_Showroom_Date__c)
                                {
                                    ld.Visited_Showroom_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Placed_Date__c !=oldVallead.get(ld.id).Order_Placed_Date__c)
                                {
                                    ld.Order_Placed_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Qualified_Date_Time__c !=oldVallead.get(ld.id).Qualified_Date_Time__c)
                                {
                                    ld.Qualified_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Date__c !=oldVallead.get(ld.id).Invoice_Date__c)
                                {
                                    ld.Invoice_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Handover_Date__c !=oldVallead.get(ld.id).Handover_Date__c)
                                {
                                    ld.Handover_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Number__c !=oldVallead.get(ld.id).Quotation_Number__c)
                                {
                                    ld.Quotation_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Date__c !=oldVallead.get(ld.id).Quotation_Date__c)
                                {
                                    ld.Quotation_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Amount__c !=oldVallead.get(ld.id).Quotation_Amount__c)
                                {
                                    ld.Quotation_Amount__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_No__c !=oldVallead.get(ld.id).Order_No__c)
                                {
                                    ld.Order_No__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Confirmation_Date__c !=oldVallead.get(ld.id).Order_Confirmation_Date__c)
                                {
                                    ld.Order_Confirmation_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact_Failed_For_3_Days_Date__c !=oldVallead.get(ld.id).Contact_Failed_For_3_Days_Date__c)
                                {
                                    ld.Contact_Failed_For_3_Days_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.First_Contact_Customer_Date__c !=oldVallead.get(ld.id).First_Contact_Customer_Date__c)
                                {
                                    ld.First_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Test_Drive_Date__c !=oldVallead.get(ld.id).Test_Drive_Date__c)
                                {
                                    ld.Test_Drive_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Registration_Number__c !=oldVallead.get(ld.id).Registration_Number__c)
                                {
                                    ld.Registration_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Network_Registration_Date__c !=oldVallead.get(ld.id).Network_Registration_Date__c)
                                {
                                    ld.Network_Registration_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Amount__c !=oldVallead.get(ld.id).Invoice_Amount__c)
                                {
                                    ld.Invoice_Amount__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Number__c !=oldVallead.get(ld.id).Invoice_Number__c)
                                {
                                    ld.Invoice_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Placed_Date_Time__c !=oldVallead.get(ld.id).Order_Placed_Date_Time__c)
                                {
                                    ld.Order_Placed_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Appointment_DateTime__c !=oldVallead.get(ld.id).Appointment_DateTime__c)
                                {
                                    ld.Appointment_DateTime__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lead_Desired_Service__c !=oldVallead.get(ld.id).MBK_Lead_Desired_Service__c)
                                {
                                    ld.MBK_Lead_Desired_Service__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Price_Range__c !=oldVallead.get(ld.id).Price_Range__c)
                                {
                                    ld.Price_Range__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Payment_Mode__c !=oldVallead.get(ld.id).Payment_Mode__c)
                                {
                                    ld.Payment_Mode__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Method__c !=oldVallead.get(ld.id).Preferred_Contact_Method__c)
                                {
                                    ld.Preferred_Contact_Method__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Time__c !=oldVallead.get(ld.id).Preferred_Contact_Time__c)
                                {
                                    ld.Preferred_Contact_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Purchase_Time__c !=oldVallead.get(ld.id).Purchase_Time__c)
                                {
                                    ld.Purchase_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Purchased_CAC_Date_Time__c !=oldVallead.get(ld.id).Purchased_CAC_Date_Time__c)
                                {
                                    ld.Purchased_CAC_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Payment_Condition__c !=oldVallead.get(ld.id).Payment_Condition__c)
                                {
                                    ld.Payment_Condition__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact_Timing__c !=oldVallead.get(ld.id).Contact_Timing__c)
                                {
                                    ld.Contact_Timing__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Test_Drive_Detail__c !=oldVallead.get(ld.id).Test_Drive_Detail__c)
                                {
                                    ld.Test_Drive_Detail__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Date__c !=oldVallead.get(ld.id).Preferred_Contact_Date__c)
                                {
                                    ld.Preferred_Contact_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Interested_Vehicle_Note__c !=oldVallead.get(ld.id).Interested_Vehicle_Note__c)
                                {
                                    ld.Interested_Vehicle_Note__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Interested_Competitor_Vehicle_Text__c !=oldVallead.get(ld.id).Interested_Competitor_Vehicle_Text__c)
                                {
                                    ld.Interested_Competitor_Vehicle_Text__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Collectioner_Notes__c !=oldVallead.get(ld.id).Collectioner_Notes__c)
                                {
                                    ld.Collectioner_Notes__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Dealer_Lost_Reason__c !=oldVallead.get(ld.id).Dealer_Lost_Reason__c)
                                {
                                    ld.Dealer_Lost_Reason__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lost_Situation__c !=oldVallead.get(ld.id).MBK_Lost_Situation__c)
                                {
                                    ld.MBK_Lost_Situation__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Comment__c !=oldVallead.get(ld.id).Lost_Comment__c)
                                {
                                    ld.Lost_Comment__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Dealer_Date__c !=oldVallead.get(ld.id).Lost_Dealer_Date__c)
                                {
                                    ld.Lost_Dealer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_To__c !=oldVallead.get(ld.id).Lost_To__c)
                                {
                                    ld.Lost_To__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Assigned_Dealer_by_Rule__c !=oldVallead.get(ld.id).Assigned_Dealer_by_Rule__c)
                                {
                                    ld.Assigned_Dealer_by_Rule__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Recommended_Dealer__c !=oldVallead.get(ld.id).Recommended_Dealer__c)
                                {
                                    ld.Recommended_Dealer__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.X72H_Untouched__c !=oldVallead.get(ld.id).X72H_Untouched__c)
                                {
                                    ld.X72H_Untouched__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Customer_Preferred_Rep__c !=oldVallead.get(ld.id).Customer_Preferred_Rep__c)
                                {
                                    ld.Customer_Preferred_Rep__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Sales_Consultant__c !=oldVallead.get(ld.id).Sales_Consultant__c)
                                {
                                    ld.Sales_Consultant__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Drop_off_Time__c !=oldVallead.get(ld.id).Drop_off_Time__c)
                                {
                                    ld.Drop_off_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Assigned_Date_Time__c !=oldVallead.get(ld.id).Assigned_Date_Time__c)
                                {
                                    ld.Assigned_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Service_Advisor__c !=oldVallead.get(ld.id).Service_Advisor__c)
                                {
                                    ld.Service_Advisor__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Print_Date__c !=oldVallead.get(ld.id).Quotation_Print_Date__c)
                                {
                                    ld.Quotation_Print_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.AfterSales_Vehicle__c !=oldVallead.get(ld.id).AfterSales_Vehicle__c)
                                {
                                    ld.AfterSales_Vehicle__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Dealer_Date_Time__c !=oldVallead.get(ld.id).Lost_Dealer_Date_Time__c)
                                {
                                    ld.Lost_Dealer_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Requested_Service_DateTime1__c !=oldVallead.get(ld.id).Requested_Service_DateTime1__c)
                                {
                                    ld.Requested_Service_DateTime1__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Requested_Service_DateTime2__c !=oldVallead.get(ld.id).Requested_Service_DateTime2__c)
                                {
                                    ld.Requested_Service_DateTime2__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact_Customer_Date__c !=oldVallead.get(ld.id).Next_Contact_Customer_Date__c)
                                {
                                    ld.Next_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Service_Date__c !=oldVallead.get(ld.id).Service_Date__c)
                                {
                                    ld.Service_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.WIP_Number__c !=oldVallead.get(ld.id).WIP_Number__c)
                                {
                                    ld.WIP_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Additional_Service__c !=oldVallead.get(ld.id).Lead_Additional_Service__c)
                                {
                                    ld.Lead_Additional_Service__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.WIP_Created_Date__c !=oldVallead.get(ld.id).WIP_Created_Date__c)
                                {
                                    ld.WIP_Created_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Job_Card_Number__c !=oldVallead.get(ld.id).Job_Card_Number__c)
                                {
                                    ld.Job_Card_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Job_Card_Date__c !=oldVallead.get(ld.id).Job_Card_Date__c)
                                {
                                    ld.Job_Card_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Check_In_Date__c !=oldVallead.get(ld.id).Check_In_Date__c)
                                {
                                    ld.Check_In_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Check_Out_Date__c !=oldVallead.get(ld.id).Check_Out_Date__c)
                                {
                                    ld.Check_Out_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                
                      }
                  if(profilename == 'MBK CCC Retail Operator' && ld.Ownerid != userids && ld.MD__c=='KR' && (ld.RecordTypeId == salesRecordTypeId || ld.RecordTypeId == afterSalesRecordTypeId))
                      {
                        if(ld.Customer_Type__c!=oldVallead.get(ld.id).Customer_Type__c || ld.Contact__c!=oldVallead.get(ld.id).Contact__c || ld.Fax__c!=oldVallead.get(ld.id).Fax__c || ld.Company_Account__c!=oldVallead.get(ld.id).Company_Account__c || ld.Phone__c!=oldVallead.get(ld.id).Phone__c || ld.Source_Campaign__c!=oldVallead.get(ld.id).Source_Campaign__c || ld.Vehicle_Need__c!=oldVallead.get(ld.id).Vehicle_Need__c || ld.Vehicle_Need_Text__c!=oldVallead.get(ld.id).Vehicle_Need_Text__c || ld.Dealer_Comments__c!=oldVallead.get(ld.id).Dealer_Comments__c || ld.Case__c!=oldVallead.get(ld.id).Case__c || ld.VehicleRel_No__c!=oldVallead.get(ld.id).VehicleRel_No__c || ld.RecordTypeId!=oldVallead.get(ld.id).RecordTypeId ||
                           ld.CAC_Lead_Status__c!=oldVallead.get(ld.id).CAC_Lead_Status__c || ld.Lead_Latest_Phase__c!=oldVallead.get(ld.id).Lead_Latest_Phase__c || ld.Next_Contact_Customer_Date__c!=oldVallead.get(ld.id).Next_Contact_Customer_Date__c || ld.Lead_Priority__c!=oldVallead.get(ld.id).Lead_Priority__c || ld.MBK_Lead_DataSource__c!=oldVallead.get(ld.id).MBK_Lead_DataSource__c || ld.Re_visit__c!=oldVallead.get(ld.id).Re_visit__c || ld.Team__c!=oldVallead.get(ld.id).Team__c || ld.Next_Contact__c!=oldVallead.get(ld.id).Next_Contact__c || ld.Visited_Showroom_Date__c!=oldVallead.get(ld.id).Visited_Showroom_Date__c || ld.Order_Placed_Date__c!=oldVallead.get(ld.id).Order_Placed_Date__c || ld.Qualified_Date_Time__c!=oldVallead.get(ld.id).Qualified_Date_Time__c ||
                           ld.Invoice_Date__c!=oldVallead.get(ld.id).Invoice_Date__c || ld.Handover_Date__c!=oldVallead.get(ld.id).Handover_Date__c || ld.Quotation_Number__c!=oldVallead.get(ld.id).Quotation_Number__c || ld.Quotation_Date__c!=oldVallead.get(ld.id).Quotation_Date__c || ld.Quotation_Amount__c!=oldVallead.get(ld.id).Quotation_Amount__c || ld.Order_No__c!=oldVallead.get(ld.id).Order_No__c || ld.Order_Confirmation_Date__c!=oldVallead.get(ld.id).Order_Confirmation_Date__c || ld.Contact_Failed_For_3_Days_Date__c!=oldVallead.get(ld.id).Contact_Failed_For_3_Days_Date__c || ld.First_Contact_Customer_Date__c!=oldVallead.get(ld.id).First_Contact_Customer_Date__c || ld.Test_Drive_Date__c!=oldVallead.get(ld.id).Test_Drive_Date__c || ld.Registration_Number__c!=oldVallead.get(ld.id).Registration_Number__c || ld.Network_Registration_Date__c!=oldVallead.get(ld.id).Network_Registration_Date__c ||
                           ld.Invoice_Amount__c!=oldVallead.get(ld.id).Invoice_Amount__c || ld.Invoice_Number__c!=oldVallead.get(ld.id).Invoice_Number__c || ld.Order_Placed_Date_Time__c!=oldVallead.get(ld.id).Order_Placed_Date_Time__c || ld.Appointment_DateTime__c!=oldVallead.get(ld.id).Appointment_DateTime__c || ld.MBK_Lead_Desired_Service__c!=oldVallead.get(ld.id).MBK_Lead_Desired_Service__c || ld.Price_Range__c!=oldVallead.get(ld.id).Price_Range__c || ld.Payment_Mode__c!=oldVallead.get(ld.id).Payment_Mode__c || ld.Preferred_Contact_Method__c!=oldVallead.get(ld.id).Preferred_Contact_Method__c || ld.Preferred_Contact_Time__c!=oldVallead.get(ld.id).Preferred_Contact_Time__c || ld.Purchase_Time__c!=oldVallead.get(ld.id).Purchase_Time__c || ld.Purchased_CAC_Date_Time__c!=oldVallead.get(ld.id).Purchased_CAC_Date_Time__c || ld.Payment_Condition__c!=oldVallead.get(ld.id).Payment_Condition__c || ld.Contact_Timing__c!=oldVallead.get(ld.id).Contact_Timing__c || 
                           ld.Test_Drive_Detail__c!=oldVallead.get(ld.id).Test_Drive_Detail__c || ld.Preferred_Contact_Date__c!=oldVallead.get(ld.id).Preferred_Contact_Date__c || ld.Interested_Vehicle_Note__c!=oldVallead.get(ld.id).Interested_Vehicle_Note__c || ld.Interested_Competitor_Vehicle_Text__c!=oldVallead.get(ld.id).Interested_Competitor_Vehicle_Text__c || ld.Collectioner_Notes__c!=oldVallead.get(ld.id).Collectioner_Notes__c || ld.Dealer_Lost_Reason__c!=oldVallead.get(ld.id).Dealer_Lost_Reason__c || ld.MBK_Lost_Situation__c!=oldVallead.get(ld.id).MBK_Lost_Situation__c || ld.Lost_Comment__c!=oldVallead.get(ld.id).Lost_Comment__c || ld.Lost_Dealer_Date__c!=oldVallead.get(ld.id).Lost_Dealer_Date__c || ld.Lost_To__c!=oldVallead.get(ld.id).Lost_To__c || ld.Assigned_Dealer_by_Rule__c!=oldVallead.get(ld.id).Assigned_Dealer_by_Rule__c || ld.Recommended_Dealer__c!=oldVallead.get(ld.id).Recommended_Dealer__c || ld.X72H_Untouched__c!=oldVallead.get(ld.id).X72H_Untouched__c || 
                           ld.Customer_Preferred_Rep__c!=oldVallead.get(ld.id).Customer_Preferred_Rep__c || ld.Sales_Consultant__c!=oldVallead.get(ld.id).Sales_Consultant__c || ld.Drop_off_Time__c!=oldVallead.get(ld.id).Drop_off_Time__c || ld.Assigned_Date_Time__c!=oldVallead.get(ld.id).Assigned_Date_Time__c || ld.Service_Advisor__c!=oldVallead.get(ld.id).Service_Advisor__c || ld.Quotation_Print_Date__c!=oldVallead.get(ld.id).Quotation_Print_Date__c || ld.AfterSales_Vehicle__c!=oldVallead.get(ld.id).AfterSales_Vehicle__c || ld.Lost_Dealer_Date_Time__c!=oldVallead.get(ld.id).Lost_Dealer_Date_Time__c || ld.Requested_Service_DateTime1__c!=oldVallead.get(ld.id).Requested_Service_DateTime1__c || ld.Requested_Service_DateTime2__c!=oldVallead.get(ld.id).Requested_Service_DateTime2__c || ld.Next_Contact_Customer_Date__c!=oldVallead.get(ld.id).Next_Contact_Customer_Date__c || ld.Service_Date__c!=oldVallead.get(ld.id).Service_Date__c || ld.WIP_Number__c!=oldVallead.get(ld.id).WIP_Number__c || 
                           ld.Lead_Type__c!=oldVallead.get(ld.id).Lead_Type__c ||ld.Lead_Sub_Type__c!=oldVallead.get(ld.id).Lead_Sub_Type__c ||ld.Lead_Additional_Service__c!=oldVallead.get(ld.id).Lead_Additional_Service__c || ld.WIP_Created_Date__c!=oldVallead.get(ld.id).WIP_Created_Date__c || ld.Job_Card_Number__c!=oldVallead.get(ld.id).Job_Card_Number__c || ld.Job_Card_Date__c!=oldVallead.get(ld.id).Job_Card_Date__c || ld.Check_In_Date__c!=oldVallead.get(ld.id).Check_In_Date__c || ld.Check_Out_Date__c!=oldVallead.get(ld.id).Check_Out_Date__c)
                             {
                                ld.addError(system.label.Insufficient_access_to_update +'Owner,Dealer Lead Status,Assigned Dealer');
                             }
                                if(ld.Customer_Type__c !=oldVallead.get(ld.id).Customer_Type__c)
                                {
                                    ld.Customer_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact__c !=oldVallead.get(ld.id).Contact__c)
                                {
                                    ld.Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Fax__c !=oldVallead.get(ld.id).Fax__c)
                                {
                                    ld.Fax__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Company_Account__c !=oldVallead.get(ld.id).Company_Account__c)
                                {
                                    ld.Company_Account__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Phone__c !=oldVallead.get(ld.id).Phone__c)
                                {
                                    ld.Phone__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Type__c !=oldVallead.get(ld.id).Lead_Type__c)
                                {
                                    ld.Lead_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Source_Campaign__c !=oldVallead.get(ld.id).Source_Campaign__c)
                                {
                                    ld.Source_Campaign__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Vehicle_Need__c !=oldVallead.get(ld.id).Vehicle_Need__c)
                                {
                                    ld.Vehicle_Need__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Vehicle_Need_Text__c !=oldVallead.get(ld.id).Vehicle_Need_Text__c)
                                {
                                    ld.Vehicle_Need_Text__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Dealer_Comments__c !=oldVallead.get(ld.id).Dealer_Comments__c)
                                {
                                    ld.Dealer_Comments__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Case__c !=oldVallead.get(ld.id).Case__c)
                                {
                                    ld.Case__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.VehicleRel_No__c !=oldVallead.get(ld.id).VehicleRel_No__c)
                                {
                                    ld.VehicleRel_No__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.RecordTypeId !=oldVallead.get(ld.id).RecordTypeId)
                                {
                                    ld.RecordTypeId.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.CAC_Lead_Status__c !=oldVallead.get(ld.id).CAC_Lead_Status__c)
                                {
                                    ld.CAC_Lead_Status__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Latest_Phase__c !=oldVallead.get(ld.id).Lead_Latest_Phase__c)
                                {
                                    ld.Lead_Latest_Phase__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact_Customer_Date__c !=oldVallead.get(ld.id).Next_Contact_Customer_Date__c)
                                {
                                    ld.Next_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Priority__c !=oldVallead.get(ld.id).Lead_Priority__c)
                                {
                                    ld.Lead_Priority__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Sub_Type__c !=oldVallead.get(ld.id).Lead_Sub_Type__c)
                                {
                                    ld.Lead_Sub_Type__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lead_DataSource__c !=oldVallead.get(ld.id).MBK_Lead_DataSource__c)
                                {
                                    ld.MBK_Lead_DataSource__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Re_visit__c !=oldVallead.get(ld.id).Re_visit__c)
                                {
                                    ld.Re_visit__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Team__c !=oldVallead.get(ld.id).Team__c)
                                {
                                    ld.Team__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact__c !=oldVallead.get(ld.id).Next_Contact__c)
                                {
                                    ld.Next_Contact__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Visited_Showroom_Date__c !=oldVallead.get(ld.id).Visited_Showroom_Date__c)
                                {
                                    ld.Visited_Showroom_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Placed_Date__c !=oldVallead.get(ld.id).Order_Placed_Date__c)
                                {
                                    ld.Order_Placed_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Qualified_Date_Time__c !=oldVallead.get(ld.id).Qualified_Date_Time__c)
                                {
                                    ld.Qualified_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Date__c !=oldVallead.get(ld.id).Invoice_Date__c)
                                {
                                    ld.Invoice_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Handover_Date__c !=oldVallead.get(ld.id).Handover_Date__c)
                                {
                                    ld.Handover_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Number__c !=oldVallead.get(ld.id).Quotation_Number__c)
                                {
                                    ld.Quotation_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Date__c !=oldVallead.get(ld.id).Quotation_Date__c)
                                {
                                    ld.Quotation_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Amount__c !=oldVallead.get(ld.id).Quotation_Amount__c)
                                {
                                    ld.Quotation_Amount__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_No__c !=oldVallead.get(ld.id).Order_No__c)
                                {
                                    ld.Order_No__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Confirmation_Date__c !=oldVallead.get(ld.id).Order_Confirmation_Date__c)
                                {
                                    ld.Order_Confirmation_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact_Failed_For_3_Days_Date__c !=oldVallead.get(ld.id).Contact_Failed_For_3_Days_Date__c)
                                {
                                    ld.Contact_Failed_For_3_Days_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.First_Contact_Customer_Date__c !=oldVallead.get(ld.id).First_Contact_Customer_Date__c)
                                {
                                    ld.First_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Test_Drive_Date__c !=oldVallead.get(ld.id).Test_Drive_Date__c)
                                {
                                    ld.Test_Drive_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Registration_Number__c !=oldVallead.get(ld.id).Registration_Number__c)
                                {
                                    ld.Registration_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Network_Registration_Date__c !=oldVallead.get(ld.id).Network_Registration_Date__c)
                                {
                                    ld.Network_Registration_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Amount__c !=oldVallead.get(ld.id).Invoice_Amount__c)
                                {
                                    ld.Invoice_Amount__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Invoice_Number__c !=oldVallead.get(ld.id).Invoice_Number__c)
                                {
                                    ld.Invoice_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Order_Placed_Date_Time__c !=oldVallead.get(ld.id).Order_Placed_Date_Time__c)
                                {
                                    ld.Order_Placed_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Appointment_DateTime__c !=oldVallead.get(ld.id).Appointment_DateTime__c)
                                {
                                    ld.Appointment_DateTime__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lead_Desired_Service__c !=oldVallead.get(ld.id).MBK_Lead_Desired_Service__c)
                                {
                                    ld.MBK_Lead_Desired_Service__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Price_Range__c !=oldVallead.get(ld.id).Price_Range__c)
                                {
                                    ld.Price_Range__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Payment_Mode__c !=oldVallead.get(ld.id).Payment_Mode__c)
                                {
                                    ld.Payment_Mode__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Method__c !=oldVallead.get(ld.id).Preferred_Contact_Method__c)
                                {
                                    ld.Preferred_Contact_Method__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Time__c !=oldVallead.get(ld.id).Preferred_Contact_Time__c)
                                {
                                    ld.Preferred_Contact_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Purchase_Time__c !=oldVallead.get(ld.id).Purchase_Time__c)
                                {
                                    ld.Purchase_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Purchased_CAC_Date_Time__c !=oldVallead.get(ld.id).Purchased_CAC_Date_Time__c)
                                {
                                    ld.Purchased_CAC_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Payment_Condition__c !=oldVallead.get(ld.id).Payment_Condition__c)
                                {
                                    ld.Payment_Condition__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Contact_Timing__c !=oldVallead.get(ld.id).Contact_Timing__c)
                                {
                                    ld.Contact_Timing__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Test_Drive_Detail__c !=oldVallead.get(ld.id).Test_Drive_Detail__c)
                                {
                                    ld.Test_Drive_Detail__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Preferred_Contact_Date__c !=oldVallead.get(ld.id).Preferred_Contact_Date__c)
                                {
                                    ld.Preferred_Contact_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Interested_Vehicle_Note__c !=oldVallead.get(ld.id).Interested_Vehicle_Note__c)
                                {
                                    ld.Interested_Vehicle_Note__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Interested_Competitor_Vehicle_Text__c !=oldVallead.get(ld.id).Interested_Competitor_Vehicle_Text__c)
                                {
                                    ld.Interested_Competitor_Vehicle_Text__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Collectioner_Notes__c !=oldVallead.get(ld.id).Collectioner_Notes__c)
                                {
                                    ld.Collectioner_Notes__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Dealer_Lost_Reason__c !=oldVallead.get(ld.id).Dealer_Lost_Reason__c)
                                {
                                    ld.Dealer_Lost_Reason__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.MBK_Lost_Situation__c !=oldVallead.get(ld.id).MBK_Lost_Situation__c)
                                {
                                    ld.MBK_Lost_Situation__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Comment__c !=oldVallead.get(ld.id).Lost_Comment__c)
                                {
                                    ld.Lost_Comment__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Dealer_Date__c !=oldVallead.get(ld.id).Lost_Dealer_Date__c)
                                {
                                    ld.Lost_Dealer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_To__c !=oldVallead.get(ld.id).Lost_To__c)
                                {
                                    ld.Lost_To__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Assigned_Dealer_by_Rule__c !=oldVallead.get(ld.id).Assigned_Dealer_by_Rule__c)
                                {
                                    ld.Assigned_Dealer_by_Rule__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Recommended_Dealer__c !=oldVallead.get(ld.id).Recommended_Dealer__c)
                                {
                                    ld.Recommended_Dealer__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.X72H_Untouched__c !=oldVallead.get(ld.id).X72H_Untouched__c)
                                {
                                    ld.X72H_Untouched__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Customer_Preferred_Rep__c !=oldVallead.get(ld.id).Customer_Preferred_Rep__c)
                                {
                                    ld.Customer_Preferred_Rep__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Sales_Consultant__c !=oldVallead.get(ld.id).Sales_Consultant__c)
                                {
                                    ld.Sales_Consultant__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Drop_off_Time__c !=oldVallead.get(ld.id).Drop_off_Time__c)
                                {
                                    ld.Drop_off_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Assigned_Date_Time__c !=oldVallead.get(ld.id).Assigned_Date_Time__c)
                                {
                                    ld.Assigned_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Service_Advisor__c !=oldVallead.get(ld.id).Service_Advisor__c)
                                {
                                    ld.Service_Advisor__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Quotation_Print_Date__c !=oldVallead.get(ld.id).Quotation_Print_Date__c)
                                {
                                    ld.Quotation_Print_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.AfterSales_Vehicle__c !=oldVallead.get(ld.id).AfterSales_Vehicle__c)
                                {
                                    ld.AfterSales_Vehicle__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lost_Dealer_Date_Time__c !=oldVallead.get(ld.id).Lost_Dealer_Date_Time__c)
                                {
                                    ld.Lost_Dealer_Date_Time__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Requested_Service_DateTime1__c !=oldVallead.get(ld.id).Requested_Service_DateTime1__c)
                                {
                                    ld.Requested_Service_DateTime1__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Requested_Service_DateTime2__c !=oldVallead.get(ld.id).Requested_Service_DateTime2__c)
                                {
                                    ld.Requested_Service_DateTime2__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Next_Contact_Customer_Date__c !=oldVallead.get(ld.id).Next_Contact_Customer_Date__c)
                                {
                                    ld.Next_Contact_Customer_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Service_Date__c !=oldVallead.get(ld.id).Service_Date__c)
                                {
                                    ld.Service_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.WIP_Number__c !=oldVallead.get(ld.id).WIP_Number__c)
                                {
                                    ld.WIP_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Lead_Additional_Service__c !=oldVallead.get(ld.id).Lead_Additional_Service__c)
                                {
                                    ld.Lead_Additional_Service__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.WIP_Created_Date__c !=oldVallead.get(ld.id).WIP_Created_Date__c)
                                {
                                    ld.WIP_Created_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Job_Card_Number__c !=oldVallead.get(ld.id).Job_Card_Number__c)
                                {
                                    ld.Job_Card_Number__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Job_Card_Date__c !=oldVallead.get(ld.id).Job_Card_Date__c)
                                {
                                    ld.Job_Card_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Check_In_Date__c !=oldVallead.get(ld.id).Check_In_Date__c)
                                {
                                    ld.Check_In_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                                if(ld.Check_Out_Date__c !=oldVallead.get(ld.id).Check_Out_Date__c)
                                {
                                    ld.Check_Out_Date__c.addError(system.label.Insufficient_access_to_update_this_field);
                                }
                      }
                }
           }
           if(trigger.isBefore && trigger.isDelete)
           {
            for(Lead__c ld : Lstnewlead)
                { 
                  if((profilename == 'MBK CCC Retail - Manager' || profilename == 'MBK CCC Retail Operator') && ld.Ownerid != userids && ld.MD__c=='KR' && (ld.RecordTypeId == salesRecordTypeId || ld.RecordTypeId == afterSalesRecordTypeId))
                      {
                        ld.addError(system.label.You_cannot_delete_this_record);
                      }
                      }
           }
    }*/
	
	//---------------------------- Lead Share - SFDCKR-964 ----------------------------
    // Added By - Sreenivasareddy
    
    public static void leadsharehierarchy(List<lead__c> Lstnewlead) {
       list<id> ownerids = new list<id>();
       list<id> leadids= new list<id>();
       
       for(lead__c l:Lstnewlead) {
          if(l.MD__c=='KR') {
             ownerids.add(l.OwnerId);
             system.debug('*****leadownerlist' +ownerids);
		  }	 
       }
       if(!Test.isRunningTest()){
       //before insert new casesharings need to delete old Leadsharings***...
       If(Trigger.IsUpdate){
          List<Lead__Share> sharesToDelete = [Select UserOrGroupId,RowCause,id From Lead__Share where RowCause='Ownershare' and parentId in:leadids];
          if(!sharesToDelete.isEmpty()) {
             delete sharesToDelete;
          }
       }
       }
        
       Map<ID, User> usermap = new Map<ID, User>([Select Id,MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c  from User where id in: ownerids and Market__c = 'KR' and IsActive=true]);
       system.debug('Reporting Users' +usermap);
       
       List<Lead__Share> leadShar = new List<Lead__Share>();
        
       /* Sales Consultant Share Process */
        
       for(lead__c  led : Lstnewlead) {
          if(!usermap.containsKey(led.ownerid))continue;
             user u = usermap.get(led.ownerid);
          if(u.MBK_Partner_Roles__c == 'Sales Consultant') {
             system.debug('Team Leader' +u.MBK_Reporting_Partner_User__c);
             if(u.MBK_Reporting_Partner_User__c!=null || u.MBK_Reporting_Partner_User__c!='') {
                Lead__Share shareRec = new Lead__Share();
                shareRec.ParentId = led.Id;
                shareRec.UserOrGroupId  = u.MBK_Reporting_Partner_User__c;
                shareRec.AccessLevel = 'edit';
                leadShar.add(shareRec);
             }
             if(u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!=null || u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!='') {
                Lead__Share shareRec1 = new Lead__Share();
                shareRec1.ParentId = led.Id;
                shareRec1.UserOrGroupId  = u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c;
                shareRec1.AccessLevel = 'edit';
                leadShar.add(shareRec1);  
             }   
          }
       }
        
       /* Team Leader Share Process */
        
       for(lead__c  tlled : Lstnewlead) {
          if(!usermap.containsKey(tlled.ownerid))continue;
             user tlu = usermap.get(tlled.ownerid);
          if(tlu.MBK_Partner_Roles__c == 'Team Leader') {
             system.debug('Sales Manager' +tlu.MBK_Reporting_Partner_User__c);
             if(tlu.MBK_Reporting_Partner_User__c!=null || tlu.MBK_Reporting_Partner_User__c!='') {
                Lead__Share tlshareRec = new Lead__Share();
                tlshareRec.ParentId = tlled.Id;
                tlshareRec.UserOrGroupId  = tlu.MBK_Reporting_Partner_User__c;
                tlshareRec.AccessLevel = 'edit';
                leadShar.add(tlshareRec);  
             }
          }
       }   
       
       If(leadShar != null & leadShar.size() > 0) {
          insert leadShar;
       }
    }
	 @future
     public static void sendEmailToQueue(map<string,string> leadOwnerIds) 
     {
     system.debug('Entered Email Notification Method'+leadOwnerIds.keySet());
    if(LeadUtil.recurssionchecksendmaillead== true){
    System.debug('Already Processed');
     
          List<Messaging.Email> sendEmailList = new List<Messaging.Email>();
          set<Id> groupId = new set<Id>();
          set<Id> oldgroupId = new set<Id>();
          list<GroupMember> ownerids = new list<GroupMember>();
          if(leadOwnerIds != null && !leadOwnerIds.isEmpty())
          {
              for(string ownrled : leadOwnerIds.keySet())
              {
                  groupId.add(leadOwnerIds.get(ownrled));
                  
                  system.debug('*&*&*&*& groupId  ' + groupId);
                  // system.debug('*&*&*&*& oldgroupId  ' + oldgroupId);
              }
          if(groupId != null && !groupId.isEmpty())
          {
              ownerids =[select Id,UserOrGroupId,Group.Id from GroupMember where Group.Id in: groupId];
              system.debug('*&*&*&*& ownerids ' + ownerids);
          }
          
          EmailTemplate templateId  =[select id,name,Subject from EmailTemplate WHERE name = 'Lead owner is updated to Queue'];
          Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
           List<Id> ccDeatils=new List<Id>();
		   List<Id> updatedCcDeatils=new List<Id>();
           for(string leadOwnrId: leadOwnerIds.keySet())
          {   
              for(GroupMember grmMbr: ownerids)
              {
                  system.debug(grmMbr.Group.Id + '   **$$***$$***$$**   ' + grmMbr.UserOrGroupId + '   *&*&* Entered For Loop for email *&*&*&   ' + leadOwnerIds.get(leadOwnrId));
                  
                  //message.setToAddresses(leadOwnerIds);
                  if(grmMbr.Group.Id == leadOwnerIds.get(leadOwnrId)&& String.ValueOf(grmMbr.UserOrGroupId).startsWith('005'))
                  {
                      message.setWhatId(leadOwnrId);
                      ccDeatils.add(grmMbr.UserOrGroupId);
                  }              
              }
          }
				  System.debug('ccDeatils----'+ccDeatils);
                  List<User> activeUser=[select Id from User where id in:ccDeatils and isActive=TRUE];
                  System.debug('activeUser----'+activeUser);
                  for(User u:activeUser){
                  message.setTargetObjectId(u.Id);
                  updatedCcDeatils.add(u.Id);
                  }
                  System.debug('Updated ccDeatils----'+updatedCcDeatils);
                  message.setToAddresses(updatedCcDeatils);
                  message.setTemplateId(templateId.id);
                  message.setSaveAsActivity(false);
          try
            {   
              if(!ownerids.isEmpty() && ownerids!= null)
              {
                
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});
                  if (results[0].success) 
                  {                
                      System.debug('The Lead Queue email was sent successfully.');
                  } 
              }               
            }    
            catch(Exception e)
            {
                system.debug('Lead Queue Email Notification Failure Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
            } 
          }
        }
        LeadUtil.recurssionchecksendmaillead = false;
        }
}