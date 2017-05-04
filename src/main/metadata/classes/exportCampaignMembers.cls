/****************************************************************
CreatedBy : Lokesh M
Desc 	  : Export button - campaign_Member__c
            When user click on export button it will save the campaign members which is related to The current page campaign Or retail campaing in 'csv format'
createdDate : 31-Jan-2017
lastmodified: 4-apr-2017
Campaign Management - Phase 1
*****************************************************************/

public class exportCampaignMembers{
    public List<Campaign_Member__c> campaignMemberList{get;set;}
    Public Id curRecId{get;set;}
    Public Campaign curCampaign{get;set;}
    Public Retail_Campaign__C curRetailCampaign{get;set;}
    List<Campaign_member__C> cmpList{get;set;}
    Public Integer campaignCount;
    Public Integer retailCampaignCount;
      
    public exportCampaignMembers(){
        curRecId  = ApexPages.CurrentPage().getparameters().get('id');
        campaignCount = [SELECT COUNT() FROM Campaign WHERE ID =: curRecId];
        IF(campaignCount > 0){
            curCampaign = [SELECT Id,Status FROM Campaign WHERE ID =: curRecId];
            wholesaleCampaign();
        }
        retailCampaignCount = [SELECT COUNT() FROM Retail_Campaign__C WHERE ID =: curRecId];
        IF(retailCampaignCount > 0){
            curRetailCampaign = [SELECT Id,Status__c FROM Retail_Campaign__C WHERE ID =: curRecId ];
            wholesaleCampaign();
        }
    } 
    
    public void changeStatus(){
        if(curCampaign != null){
            curCampaign.Child_Campaign_Status__c = 'Execution';
            update curCampaign;
            cmpList = [SELECT Status__c FROM Campaign_member__C  WHERE Campaign_ID__c =: curCampaign.Id];
            for(Campaign_member__C cmp: cmpList){
                cmp.status__c='Executed';
            }
        }
        if(curRetailCampaign != null){
            curRetailCampaign.Child_Campaign_Status__c= 'Execution';
            update curRetailCampaign;
            cmpList = [SELECT Status__c FROM Campaign_member__C  WHERE Retail_Campaign_Id__c=: curRetailCampaign.Id];
            for(Campaign_member__C rmp: cmpList){
                rmp.status__c='Executed';
            }
        }
        update cmpList;
    }
    
    public List<Campaign_member__C> wholesaleCampaign(){
        String extension;
        if(curCampaign != NUll){
            extension = 'campaign_Id__C =\'' + curCampaign.id + '\' ';
        }
        else if(curRetailCampaign != NULL){
            extension = 'Retail_Campaign_Id__c=\'' + curRetailCampaign.id + '\' ';
        }
       
        String query = 'SELECT Id,Campaign_ID__c,Name,Status__c, Retail_Campaign_Id__c,Contact_Id__c,List_Maitenence_Retail_CM_Flag__c, Campaign_Execution_Type__c,Participate_Date__c,FirstName__c,LastName__c,Company_Name__c,Customer_Label_Name__c,Contractor_Company_Name__c,Contractor_Individual_Name__c,Source_of_CM_Response__c,Address__c,Customer_Complete_Address__c,Address_Flag__c,Finance_Address__c,Zip_Code__c,Zip_Code_Finance__c,Contract__c,Contract_Number__c,Contract_Phone_1__c,Contract_Phone_2__c, Contract_Status__c,Preferred_Dealer__c,DM_Template__c,Customer_Email__c,Response_Email__c,My_Mercedes_Email__c, My_Mercedes_ID__c,Sending_Date__c,RespondedDate__c,Account_information_updates__c,Recipient_changes__c, Status_Change_Date__c,Auto_creation_of_leads__c,Auto_creation_of_tasks__c,Auto_creation_of_DM_requests__c, Add_Sales_Staff__c,Add_Service_Staff__c,Add_Campaign_Member_ID__c,Vehicle__c,Vehicle_Relationship__c, UsVIN__c,Registration_Date__c,Model__c,Registration_Number__c,Next_Inspection_Date__c,Next_MOT_Date__c,First_Registration_Date__c, Sales_Representative__c, Service_Representative__c, Contract_Responsible_Person__c, Gaurantor_1_Name__c, Gaurantor2_Name__c, Gaurantor3_Name__c, Dealer_ND_Code__c, Finance_Vehicle__c, Finance_Product__c, Contract_Start_date_Lease__c, Contract_End_date_Lease__c, Monthly_Payment_amount__c, Residual_amount_Lease__c, Deferred_Payment_loan__c, Payment_Start_Date__c, Payment_End_Date__c, Bonus_Amount1__c, Bonus_Month1__c, Bonus_Amount2__c, Bonus_Month2__c,Shinpan__c, No_of_Payments__c, Delinquency_Flag__c, Re_Lease_Prohibit_Flag__c,Re_Lease_Extension_Date__c,Lease_Loan_Flag__c, Special_flag_to_Exclude__c,MBF_Anti_Social_flag__c,Offer_Prohibit_Flag__c, Special_Flag_to_Include__c, Payment_Suspended_Flag__c, Mileage__c, Indemnity_Amount__c, Fine_Rate__c, Customer_Interest_Rate__c, Monthly_Payment_amount_with_Tax__c, Term__c, Monthly_Payment__c, Interest_Rate__c, RV_Ballon__c,Cross_Point_Model__c, Total_Vehicle_Price_without_tax__c,Total_Vehicle_Price_with_tax__c,Lead_Type__c,Lead_Sub_Type__c, Purchase_Timing__c, Lead_Desired_Service__c, Interested_Model__c FROM Campaign_Member__c WHERE ' + extension;
        campaignMemberList = Database.query(query);     
        System.debug('campaign member list'+campaignmemberlist);
        if(campaignMemberList != NULL && !campaignMemberList.isEmpty())
            return campaignMemberList;                             
        else 
            return null;
    }
}