/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    Convert to lead functionality for Campaign Member Records
                          
JIRA NO             :    SFDCJP-1036 & 1041                                            
************************************************************************************/
public with sharing class ConvertToLeadController {
    
    private final String campaignId = ApexPages.currentPage().getParameters().get('CampaignId');
    public String leadRT {get; set;}
    public String interstmodel {get; set;}
    public String leadRT1 {get; set;}
    public List<CampaignMemberInfo> campaignMembers {get; set;}
    private String leadRTId {get; set;}
    private String leadRTId1 {get; set;}
    @testvisible private String objectAPIName;
    
    public ConvertToLeadController() {
        leadRT = 'Sales Leads';
        leadRT1 ='Aftersales Leads';
        leadRTId = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT].id;
        leadRTId1 = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT1].id;
        if(String.isNotBlank(campaignId)) {
            objectAPIName = (Id.valueOf(campaignId)).getSObjectType().getDescribe().getName();
            String query = 'SELECT Name, Campaign_ID__r.OwnerId,UsVIN__c,Model__c,Vehicle__c,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Retail_Campaign_Id__r.OwnerId,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Contract__c,Preferred_Dealer__c,Contact_Id__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND ';
            
            if(objectAPIName == 'Campaign') {
                query += ' Campaign_ID__c =: campaignId ';
            } else if(objectAPIName == 'Retail_Campaign__c') {
                query += ' Retail_Campaign_Id__c =: campaignId ';
            }
            
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<CampaignMemberInfo>();
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) {
                campaignMembers.add(new CampaignMemberInfo(campaignMemberRec));
            }
        }
    }
    
    
    public class CampaignMemberInfo {
        public Campaign_Member__c campaignMember { get; set; }
        public Boolean isSelected { get; set; }
        
        public CampaignMemberInfo(Campaign_Member__c campaignMemberRec) {
            this.campaignMember = campaignMemberRec;
            this.isSelected = false;
        }
    }
    
    public PageReference cancel() {
        return new PageReference('/' + campaignId);
    }
    
    public PageReference convertToLead() {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Lead__c> leadListToInsert = new List<Lead__c>();
        
        List<Lead__c> existingLeadList;
        if(objectAPIName == 'Campaign') {
            existingLeadList = [Select Source_Campaign__c, Contact__c, Lead_Type__c, Lead_Sub_Type__c, Interested_Vehicle_Model__c 
                                        from Lead__c where Source_Campaign__c =: campaignId];
        } else if(objectAPIName == 'Retail_Campaign__c') {
            existingLeadList = [Select Retail_Campaign_Name__c, Contact__c, Lead_Type__c, Lead_Sub_Type__c, Interested_Vehicle_Model__c 
                                        from Lead__c where Retail_Campaign_Name__c =: campaignId];
        }
        
        for(CampaignMemberInfo campaignMemberObj : campaignMembers) {
            if(campaignMemberObj.isSelected) {
                Lead__c duplicateLeadRec = checkDuplicate(campaignMemberObj.campaignMember, existingLeadList);
                if(duplicateLeadRec.Id == null){
                    if(objectAPIName == 'Campaign') {
                        leadListToInsert.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember));
                    } else if(objectAPIName == 'Retail_Campaign__c') {
                        leadListToInsert.add(setLeadRecordFields(campaignId, campaignMemberObj.campaignMember));
                    }
                } else {
                    leadList.add(duplicateLeadRec);
                }
            }
        }
        
        if(leadListToInsert.size() > 0) {
            insert leadListToInsert;
            system.debug('leadListToInsert'+leadListToInsert);
            
             VehiclePickerController.converttoleadMethod(leadListToInsert[0].id,interstmodel);
             
             system.debug('afterrrrrrrrrrrrrrrrrrrrrrr');
        }
        insertCampaignLeadRecords(leadListToInsert, leadList);
        return new PageReference('/' + campaignId);
    }
    @testvisible
    private Lead__c checkDuplicate(Campaign_Member__c campaignMemberRec, List<Lead__c> existingLeadList) {
        
        Lead__c duplicateLeadRec = new Lead__c();
        for(Lead__c leadRec : existingLeadList) {
            if(String.isNotBlank(leadRec.Contact__c) && String.isNotBlank(leadRec.Lead_Type__c) && String.isNotBlank(leadRec.Lead_Sub_Type__c) &&  
                String.isNotBlank(leadRec.Interested_Vehicle_Model__c) && 
                campaignMemberRec.Contact_Id__c == leadRec.Contact__c && campaignMemberRec.Lead_Type__c == leadRec.Lead_Type__c &&
                campaignMemberRec.Lead_Sub_Type__c == leadRec.Lead_Sub_Type__c && campaignMemberRec.Interested_Model__c == leadRec.Interested_Vehicle_Model__c ) {
                
                duplicateLeadRec = leadRec;
                break;
            }
        }
        return duplicateLeadRec;
    }
    @testvisible
    private Lead__c setLeadRecordFields(String campaignId, Campaign_Member__c campaignMember) {
    
        Lead__c leadRec = new Lead__c();
        system.debug('CM!11'+campaignMember.Campaign_ID__r.parent.Campaign_Type__c);
        leadRec.CAC_Lead_Status__c = 'New';
        if(objectAPIName == 'Campaign') {
            leadRec.Source_Campaign__c = campaignId;
            leadRec.OwnerId = campaignMember.Campaign_ID__r.OwnerId;
        } else if(objectAPIName == 'Retail_Campaign__c') {
            leadRec.Retail_Campaign_Name__c = campaignId;
            leadRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
        } 
       
        leadRec.Contact__c = campaignMember.Contact_Id__c;
        leadRec.Lead_Type__c = campaignMember.Lead_Type__c;
        leadRec.Lead_Sub_Type__c = campaignMember.Lead_Sub_Type__c;
        leadRec.Existing_Contract__c=campaignMember.Contract__c;
        leadRec.Interested_Vehicle_Model__c = campaignMember.Interested_Model__c;
        leadRec.Assigned_Dealer__c=campaignMember.Preferred_Dealer__c;
        leadRec.Finance_Product_Name__c=campaignMember.Finance_Product__c;
        leadRec.Finance_Contract_Term__c=campaignMember.Term__c;
        leadRec.Finance_Monthly_Payment__c=campaignMember.Monthly_Payment__c;
        leadRec.Finance_Interest_Rate__c=campaignMember.Interest_Rate__c;
        leadRec.Finance_RV_Ballon__c=campaignMember.RV_Ballon__c;
        leadRec.Finance_Total_V_Price_NoTax__c=campaignMember.Total_Vehicle_Price_without_tax__c;
        leadRec.Finance_Total_V_Price_Tax__c=campaignMember.Total_Vehicle_Price_with_tax__c;
        leadRec.Purchase_Time__c=campaignMember.Purchase_Timing__c;
        leadRec.Lead_Desired_Service__c=campaignMember.Lead_Desired_Service__c;
        leadRec.Cross_Point_Model__c=campaignMember.Cross_Point_Model__c;
        leadRec.Lead_DataSource__c='Campaign';
        leadRec.UsVIN__c=campaignMember.UsVIN__c;
        interstmodel=campaignMember.Interested_Model__c;
        if(leadRTId1 != null && ((campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales' && campaignMember.Campaign_ID__r.Execution_Type__c=='Lead') || (campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Finance' && campaignMember.Campaign_ID__r.Execution_Type__c=='Lead'))) {
            leadRec.RecordTypeId = leadRTId1;
            leadRec.AfterSales_Vehicle__c=campaignMember.Vehicle__c;
        }else if(leadRTId != null && campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' && campaignMember.Campaign_ID__r.Execution_Type__c=='Lead')
        {
            leadRec.RecordTypeId = leadRTId;
        }
        if(campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' && campaignMember.Campaign_ID__r.Segmentation_Base__c=='Contract')
        {
           leadRec.Trade_In_Vehicle__c=campaignMember.Vehicle__c;
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
        } 
        return cLeadRec;
    }
}