/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    Convert to lead functionality for Campaign Member Records
                          
JIRA NO             :    SFDCJP-1036 & 1041                                            
************************************************************************************/
public class ConvertToLeadController 
{
    
    private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignId');
    public String recordtypevalue {set; get;}
    public String leadRT {get; set;}
    public String interstmodel {get; set;}
    public String leadRT1 {get; set;}
    public List<CampaignMemberInfo> campaignMembers {get; set;}
    private String leadRTId {get; set;}
    private String leadRTId1 {get; set;}
    List<Campaign_Member__c> camIdCamMemMap = new List<Campaign_Member__c>();
    List<Campaign_Member__c> camListToUpdate = new List<Campaign_Member__c>();
    Public Static Boolean Campaigncheck = true;
    Public Static Boolean RetailCampaignid = true;
    public string url;
    public user u{set;get;}
    @testvisible private String objectAPIName;
     public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;   
        url=ApexPages.currentPage().getUrl();
        system.debug('urlllllllll'+url);
    }
    
    public ConvertToLeadController() 
    {
         u=[select id,market__c from user where id =:userinfo.getUserId()];
       System.debug('HIIII');
        leadRT = 'Sales Leads';
        leadRT1 ='Aftersales Leads';
        leadRTId = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT].id;
        leadRTId1 = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT1].id;
        System.debug('cid<<<<<'+campaignId);
        if(String.isNotBlank(campaignId)) 
        {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
            String query = 'SELECT Name,Contract_Number__c,Contact_Id__r.Name,Cross_point_month_and_year__c,Evaluation_Result_P1_P2_Blank__c,Final_GAP_Amount__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c,Contract__r.Finance_Contractor__r.RecordType.Name,Retail_Campaign_Id__r.Child_Campaign_Status__c,Campaign__r.Child_Campaign_Status__c,Campaign_ID__r.Name,Retail_Campaign_Id__c, Campaign_ID__r.OwnerId,UsVIN__c,Contact_Id__r.OwnerId,Model__c,Source_of_CM_Response__c,Vehicle__c,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Retail_Campaign_Id__r.OwnerId,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Contract__c,Preferred_Dealer__c,Contact_Id__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Finance_Product_Name__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND Convert_To_Lead_Flag__c = false AND';
            
            if(objectAPIName == 'Campaign') {
                query += ' (Campaign_Id__c =: campaignId) and Campaign_Id__r.Child_Campaign_Status__c != \'Completed\'';
            } else if(objectAPIName == 'Retail_Campaign__c') {
                query += ' Retail_Campaign_Id__c =: campaignId and Retail_Campaign_Id__r.Child_Campaign_Status__c !=\'Completed\'';
            }else if(objectAPIName == 'Account') {
                query += ' (Contact_Id__c =: campaignId) and ( (Campaign_Id__c !=null and Campaign_Id__r.Child_Campaign_Status__c != \'Completed\')OR (Retail_Campaign_Id__c !=null and Retail_Campaign_Id__r.Child_Campaign_Status__c !=\'Completed\')) ';
            }
            
            
            
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            System.debug('clist<<<<'+campaignMemberList);
            campaignMembers = new List<CampaignMemberInfo>();
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) {
                System.debug('crec>>>>'+campaignMemberRec);
                campaignMembers.add(new CampaignMemberInfo(campaignMemberRec));
                
            }
        }
    }
    
    
    public class CampaignMemberInfo 
    {
        public Campaign_Member__c campaignMember { get; set; }
        public Boolean isSelected { get; set; }
        public CampaignMemberInfo(Campaign_Member__c campaignMemberRec) {
            this.campaignMember = campaignMemberRec;
            this.isSelected = false;
        }
    }
    public PageReference CancelPop() {
    return new PageReference('/' + campaignId);
        }
    public PageReference cancel() {
        return new PageReference('/' + campaignId);
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Sales_Leads','Sales Leads'));
        options.add(new SelectOption('Aftersales_Leads','Aftersales Leads'));
        

        return options;
    }
    
    public PageReference convertToLead() 
    {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Lead__c> leadListToInsert = new List<Lead__c>();
        
        List<Lead__c> existingLeadList;
        if(objectAPIName == 'Campaign') {
            existingLeadList = [Select Source_Campaign__c, Contact__c,Cross_point_month_and_year__c,Evaluation_Result_P1_P2_Blank__c,Final_GAP_Amount__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c  from Lead__c where Source_Campaign__c =: campaignId];
        } else if(objectAPIName == 'Retail_Campaign__c') {
            existingLeadList = [Select Retail_Campaign_Name__c, Contact__c,Cross_point_month_and_year__c,Evaluation_Result_P1_P2_Blank__c,Final_GAP_Amount__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c from Lead__c where Retail_Campaign_Name__c =: campaignId];
        } else if(objectAPIName == 'Account') {
            existingLeadList = [Select Retail_Campaign_Name__c,Source_Campaign__c, Contact__c,Cross_point_month_and_year__c,Evaluation_Result_P1_P2_Blank__c,Final_GAP_Amount__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c from Lead__c where Contact__c =: campaignId];
            
             
            
        }

        
        for(CampaignMemberInfo campaignMemberObj : campaignMembers) 
        {
            if(campaignMemberObj.isSelected)
            {
                Lead__c duplicateLeadRec = checkDuplicate(campaignMemberObj.campaignMember, existingLeadList);
                System.debug('duprec'+duplicateLeadRec.Id);
                if(duplicateLeadRec.Id == null)
                {
                    
                    if(objectAPIName == 'Campaign') {
                        leadListToInsert.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember));
                        if(leadListToInsert.size()>0)
                        {
                           Campaign_Member__c cMember = new Campaign_Member__c();
                                 cMember.id=campaignMemberObj.campaignMember.id;
                                 cMember.Convert_To_Lead_Flag__c = true;
                                 camListToUpdate.add(cMember);
                        }
                        camIdCamMemMap.add(campaignMemberObj.campaignMember);
                    } else if(objectAPIName == 'Retail_Campaign__c') {
                        leadListToInsert.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember));
                        if(leadListToInsert.size()>0)
                        {
                           Campaign_Member__c cMember = new Campaign_Member__c();
                                 cMember.id=campaignMemberObj.campaignMember.id;
                                 cMember.Convert_To_Lead_Flag__c = true;
                                 camListToUpdate.add(cMember);
                        }
                        camIdCamMemMap.add(campaignMemberObj.campaignMember);
                    } else if(objectAPIName == 'Account') {
                        leadListToInsert.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember));
                        if(leadListToInsert.size()>0)
                        {
                           Campaign_Member__c cMember = new Campaign_Member__c();
                                 cMember.id=campaignMemberObj.campaignMember.id;
                                 cMember.Convert_To_Lead_Flag__c = true;
                                 camListToUpdate.add(cMember);
                        }
                        camIdCamMemMap.add(campaignMemberObj.campaignMember);
                    }
                } 
                else 
                {
                    leadList.add(duplicateLeadRec);
                }
               
            }
        }
        
        if(leadListToInsert.size() > 0) {
            insert leadListToInsert;
            update camListToUpdate;
            system.debug('leadListToInsert'+leadListToInsert);
            for(lead__c leadlst:leadListToInsert){
            try{
            system.debug('interstmodel--'+interstmodel);
             VehiclePickerController.converttoleadMethod(leadlst.id,camIdCamMemMap.get(0).Interested_Model__c);
             camIdCamMemMap.remove(0);
             }catch(Exception e){}
             }
             
        }
        insertCampaignLeadRecords(leadListToInsert, leadList);
        return new PageReference('/' + campaignId);
    }
    @testvisible
    private Lead__c checkDuplicate(Campaign_Member__c campaignMemberRec, List<Lead__c> existingLeadList) 
    {
        
        Lead__c duplicateLeadRec = new Lead__c();
        for(Lead__c leadRec : existingLeadList) 
        {
              if(objectAPIName == 'Campaign') 
              {
        
                   if(String.isNotBlank(leadRec.Contact__c)  &&  campaignMemberRec.Contact_Id__c == leadRec.Contact__c &&  String.isNotBlank(leadRec.Source_Campaign__c) && campaignMemberRec.Campaign_ID__c == leadRec.Source_Campaign__c)
                   {
                       duplicateLeadRec = leadRec;
                       break;
                   }
              }
              else if(objectAPIName == 'Retail_Campaign__c')
              {     
                   
                    if(String.isNotBlank(leadRec.Contact__c)  &&  campaignMemberRec.Contact_Id__c == leadRec.Contact__c &&  String.isNotBlank(leadRec.Retail_Campaign_Name__c) && campaignMemberRec.Retail_Campaign_Id__c == leadRec.Retail_Campaign_Name__c)
                   {
                       duplicateLeadRec = leadRec;
                       break;
                   }
              }
                   
              else if(objectAPIName == 'Account')
              {  
                    if(String.isNotBlank(leadRec.Contact__c)  &&  campaignMemberRec.Contact_Id__c == leadRec.Contact__c &&  String.isNotBlank(leadRec.Source_Campaign__c) && campaignMemberRec.Campaign_ID__c == leadRec.Source_Campaign__c)
                   {
                       System.debug('LIN><><><><>'); 
                       duplicateLeadRec = leadRec;
                       break;
                   }
              }
         }
         return duplicateLeadRec;
     }
        
    
    @testvisible
    private Lead__c setLeadRecordFields(String campaignId, Campaign_Member__c campaignMember) {
    
        Lead__c leadRec = new Lead__c();
        system.debug('CM!11'+campaignMember.Campaign_ID__r.parent.Campaign_Type__c);
        //leadRec.CAC_Lead_Status__c = 'Approved';
        if(objectAPIName == 'Campaign') {
            leadRec.Source_Campaign__c = campaignId;
           // leadRec.OwnerId = campaignMember.Campaign_ID__r.OwnerId;  Commented as part of 0043627773
			leadRec.OwnerId = UserInfo.getUserId();                
        } else if(objectAPIName == 'Retail_Campaign__c') {
            leadRec.Retail_Campaign_Name__c = campaignId;
            //leadRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
            leadRec.OwnerId = UserInfo.getUserId();
        } else if(objectAPIName == 'Account') {
            leadRec.Contact__c = campaignId;
            leadRec.OwnerId = campaignMember.Contact_Id__r.OwnerId;
            leadRec.Retail_Campaign_Name__c = campaignMember.Retail_Campaign_Id__c;
            leadRec.Source_Campaign__c = campaignMember.Campaign_ID__c;
            
        } 
        
        If (userinfo.getUserType() != 'PowerPartner'){
         leadRec.CAC_Lead_Status__c = 'Approved';
         leadRec.Lead_DataSource__c='Campaign';
         } else {
        leadRec.CAC_Lead_Status__c = 'New';
       leadRec.Lead_DataSource__c='Dealer Outlet';
        }

        if(u.market__c=='TH'){
         leadRec.campaignmember__c=campaignMember.Name;
        }
        leadRec.Contact__c = campaignMember.Contact_Id__c;
        leadRec.Cross_point_month_and_year__c= campaignMember.Cross_point_month_and_year__c;
       leadRec.Evaluation_Result_P1_P2_Blank__c = campaignMember.Evaluation_Result_P1_P2_Blank__c;
       leadRec.Final_GAP_Amount__c = campaignMember.Final_GAP_Amount__c;
       leadRec.Outstanding_Balance_amount__c = campaignMember.Outstanding_Balance_amount__c;
       leadRec.Proto_Market_Value_amount__c = campaignMember.Proto_Market_Value_amount__c;
        leadRec.Lead_Type__c = campaignMember.Lead_Type__c;
        leadRec.Lead_Sub_Type__c = campaignMember.Lead_Sub_Type__c;
        leadRec.Existing_Contract__c=campaignMember.Contract__c;
        leadRec.Interested_Vehicle_Model__c = campaignMember.Interested_Model__c;
        leadRec.Assigned_Dealer__c=campaignMember.Preferred_Dealer__c;
        leadRec.Finance_Product_Name__c=campaignMember.Finance_Product_Name__c;
        leadRec.Finance_Contract_Term__c=campaignMember.Term__c;
        leadRec.Finance_Monthly_Payment__c=campaignMember.Monthly_Payment__c;
        leadRec.Finance_Interest_Rate__c=campaignMember.Interest_Rate__c;
        leadRec.Finance_RV_Ballon__c=campaignMember.RV_Ballon__c;
        leadRec.Finance_Total_V_Price_NoTax__c=campaignMember.Total_Vehicle_Price_without_tax__c;
        leadRec.Finance_Total_V_Price_Tax__c=campaignMember.Total_Vehicle_Price_with_tax__c;
        leadRec.Purchase_Time__c=campaignMember.Purchase_Timing__c;
        leadRec.Lead_Desired_Service__c=campaignMember.Lead_Desired_Service__c;
        if(campaignMember.Contract__c !=null && campaignMember.Contract__r.Finance_Contractor__r.RecordType.Name =='Company')
        {
         leadRec.Company_Account__c = campaignMember.Contract__r.Finance_Contractor__c;
        }
        //leadRec.Lead_DataSource__c='Campaign';
        leadRec.UsVIN__c=campaignMember.UsVIN__c;
        System.debug('rval<><>'+recordtypevalue);
        if(recordtypevalue!= null && recordtypevalue == 'Aftersales_leads' ) {
            leadRec.RecordTypeId = leadRTId1;
            leadRec.AfterSales_Vehicle__c=campaignMember.Vehicle__c;
        }else if(recordtypevalue!= null && recordtypevalue == 'Sales_leads')
        {
           leadRec.RecordTypeId = leadRTId ;
        } 
        if(campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Finance')
        {
           leadRec.Trade_In_Vehicle__c=campaignMember.Vehicle__c;
        }
        if(campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Finance')
        {
          leadRec.Cross_Point_Model__c=campaignMember.Cross_Point_Model__c;
          interstmodel=campaignMember.Interested_Model__c;
          system.debug('interstmodecccccl---'+interstmodel);
        }
        return leadRec;
    }
    @testvisible
    private void insertCampaignLeadRecords(List<Lead__c> insertedLeadList, List<Lead__c> leadList) {
        List<Campaign_Lead__c> cLeadList = new List<Campaign_Lead__c>();
        for(Lead__c leadRec : insertedLeadList){
            cLeadList.add(setCampaignRec(leadRec));
        }
        
        for(Lead__c leadRec : leadList){
            cLeadList.add(setCampaignRec(leadRec));
        }
        
        if(cLeadList.size() > 0) {
            insert cLeadList;
        }
    }
    @testvisible
    private Campaign_Lead__c setCampaignRec(Lead__c leadRec) {
        Campaign_Lead__c cLeadRec = new Campaign_Lead__c(); 
        cLeadRec.Lead__c = leadRec.Id;
        if(objectAPIName == 'Campaign') {
            cLeadRec.Campaign__c = leadRec.Source_Campaign__c;
        } else if(objectAPIName == 'Retail_Campaign__c') {
            cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
        } else if(objectAPIName == 'Account') {
             system.debug('++++In Loop One+++++++++');
            cLeadRec.Contact__c = leadRec.Contact__c;
            if(leadRec.Source_Campaign__c != null){
             cLeadRec.Campaign__c = leadRec.Source_Campaign__c;
            }else if (leadRec.Retail_Campaign_Name__c != null){
               system.debug('++++In Loop+++++++++');
               system.debug('++++In Loop+++++++++'+leadRec.Retail_Campaign_Name__c);
            cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
            }
        }
         
        return cLeadRec;
    }    
}