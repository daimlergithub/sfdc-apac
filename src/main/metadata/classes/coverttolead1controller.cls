public  with sharing class coverttolead1controller
{

    private  String campaignMemberId = ApexPages.currentPage().getParameters().get('CampaignMemberId');
    public string recordtypevalue {set; get;}
      Public User usr{get;set;}
      
    public String leadRT {get; set;}
    public String interstmodel {get; set;}
    public String leadRT1 {get; set;}
    public List<Campaign_Member__c> campaignMembers {get; set;}
    private String leadRTId {get; set;}
    private String leadRTId1 {get; set;}
    List<Campaign_Member__c> camIdCamMemMap = new List<Campaign_Member__c>();
    List<Campaign_Member__c> CamMemMapToUpdate = new List<Campaign_Member__c>();
    @testvisible private String objectAPIName;
    public boolean displayPopup {get; set;} 
    Public static Boolean CampaingCheck = true ;  
    Public static Boolean RetailCheck = true ;  
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
     public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('--None--','--None--'));
        options.add(new SelectOption('Sales_Leads','Sales Leads'));
        options.add(new SelectOption('Aftersales_Leads','Aftersales Leads'));
        

        return options;
    }
    public coverttolead1controller() 
    {
      campaignMemberId = string.valueOf(campaignMemberId).replace('%27',' ');
      usr=[select market__c from user where id=:userinfo.getuserid()];
      system.debug('camemberid>>>>>'+campaignMemberId);
        leadRT = 'Sales Leads';
        leadRT1 ='Aftersales Leads';
        leadRTId = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT].id;
        leadRTId1 = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :leadRT1].id;
        if(String.isNotBlank(campaignMemberId)) 
        {
            objectAPIName = (Id.valueOf(campaignMemberId)).getSObjectType().getDescribe().getName();
            String query = 'SELECT  Id, Name,Contract_Number__c,Contact_Id__r.Name,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c,Campaign_ID__r.Name,Campaign_ID__r.OwnerId,UsVIN__c,Model__c,Vehicle__c,Campaign_ID__c ,Retail_Campaign_Id__c ,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Retail_Campaign_Id__r.OwnerId,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Contract__c,Preferred_Dealer__c,Contact_Id__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Finance_Product_Name__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c';
            query += ' FROM Campaign_Member__c WHERE Status__c = \'Responded\' AND Id =: campaignMemberId  AND Convert_To_Lead_Flag__c = false';
            List<Campaign_Member__c> campaignMemberList = Database.query(query);
            campaignMembers = new List<Campaign_Member__c>();
            for(Campaign_Member__c campaignMemberRec : campaignMemberList) 
            {
                campaignMembers.add(campaignMemberRec);
            }
            system.debug('cms<<<<'+campaignMembers);
        }
    }
    
    
    public PageReference cancel() 
    {
        return new PageReference('/' +campaignMemberId);
    }


    public PageReference convertToLead() 
    {
         List<Lead__c> leadList = new List<Lead__c>();
        List<Lead__c> leadListToInsert = new List<Lead__c>();
        id campaignid;
        
        List<Lead__c> existingLeadList;
        system.debug('++++Working++++++++++');
        for(Campaign_Member__c campaignMemberObj : campaignMembers)
        {
             if(campaignMemberObj.Campaign_ID__c != null)
             {
                 
                 existingLeadList = [Select Source_Campaign__c, Contact__c, Lead_Type__c, Lead_Sub_Type__c, Interested_Vehicle_Model__c 
                                        from Lead__c where Source_Campaign__c =: campaignMemberObj.Campaign_ID__c]; 
                  CampaingCheck =false;           
             }
             else if(campaignMemberObj.Retail_Campaign_Id__c != null)
             {
                 existingLeadList = [Select Source_Campaign__c, Contact__c, Lead_Type__c, Lead_Sub_Type__c, Interested_Vehicle_Model__c 
                                        from Lead__c where Source_Campaign__c =: campaignMemberObj.Retail_Campaign_Id__c];
               RetailCheck = false;
             }
        }
        for(Campaign_Member__c campaignMemberObj : campaignMembers) 
        {
           system.debug('++++Working++++++++++');
            Lead__c duplicateLeadRec = checkDuplicate(campaignMemberObj , existingLeadList);
            system.debug('duprecord'+duplicateLeadRec);
            if(duplicateLeadRec.Id == null)
            {
               
                if(campaignMemberObj.Campaign_ID__c != null && campaignMemberObj.Retail_Campaign_Id__c == null) 
                {
                        leadListToInsert.add(setLeadRecordFields(campaignMemberObj.Campaign_ID__c, campaignMemberObj));
                        camIdCamMemMap.add(campaignMemberObj);
                } else if(campaignMemberObj.Campaign_ID__c == null && campaignMemberObj.Retail_Campaign_Id__c != null) 
                {
                        leadListToInsert.add(setLeadRecordFields(campaignMemberObj.Retail_Campaign_Id__c, campaignMemberObj));
                        camIdCamMemMap.add(campaignMemberObj);
                }
            } else 
            {
                    leadList.add(duplicateLeadRec);
            }
               
           campaignMemberObj.Convert_To_Lead_Flag__c = true; 
           CamMemMapToUpdate.add(campaignMemberObj);
        }
         
         
         
         
         
         if((leadListToInsert.size()) > 0) 
         
        {
        
            system.debug('++++++++leadListToInsert+++++++++++++++++'+leadListToInsert);
                                 
            insert leadListToInsert;
            
            Update CamMemMapToUpdate;
            system.debug('leadListToInsert'+leadListToInsert);
            for(lead__c leadlst:leadListToInsert)
            {
                try
                {
                    system.debug('interstmodel--'+interstmodel);
                    VehiclePickerController.converttoleadMethod(leadlst.id,camIdCamMemMap.get(0).Interested_Model__c);
                    camIdCamMemMap.remove(0);
                }catch(Exception e){}
            }
             system.debug('afterrrrrrrrrrrrrrrrrrrrrrr');
            insertCampaignLeadRecords(leadListToInsert, leadList);
            
         }
            return new PageReference('/' +leadListToInsert[0].id );
        
    }
    
    
    private Lead__c checkDuplicate(Campaign_Member__c campaignMemberRec, List<Lead__c> existingLeadList) 
    {
        
        Lead__c duplicateLeadRec = new Lead__c();
        for(Lead__c leadRec : existingLeadList) 
        {
            if(String.isNotBlank(leadRec.Contact__c) && String.isNotBlank(leadRec.Lead_Type__c) && String.isNotBlank(leadRec.Lead_Sub_Type__c) &&  
                String.isNotBlank(leadRec.Interested_Vehicle_Model__c) && 
                campaignMemberRec.Contact_Id__c == leadRec.Contact__c && campaignMemberRec.Lead_Type__c == leadRec.Lead_Type__c &&
                campaignMemberRec.Lead_Sub_Type__c == leadRec.Lead_Sub_Type__c && campaignMemberRec.Interested_Model__c == leadRec.Interested_Vehicle_Model__c ) 
            {
                System.debug('inside<><><>');
                duplicateLeadRec = leadRec;
                break;
            }
        }
        return duplicateLeadRec;
    }
  
     private Lead__c setLeadRecordFields(String campaignId, Campaign_Member__c campaignMember) 
    {
    
        Lead__c leadRec = new Lead__c();
        
        leadRec.CAC_Lead_Status__c = 'Approved';
        if(campaignMember.Campaign_ID__c != null) 
        {
            leadRec.Source_Campaign__c = campaignMember.Campaign_ID__c;
            leadRec.OwnerId = campaignMember.Campaign_ID__r.OwnerId;
        } else if(campaignMember.Retail_Campaign_Id__c != null) 
        {
            leadRec.Retail_Campaign_Name__c = campaignMember.Retail_Campaign_Id__c;
           // leadRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
           leadRec.OwnerId = UserInfo.getUserId();
        } 
        
        If (userinfo.getUserType() != 'PowerPartner'){
         leadRec.CAC_Lead_Status__c = 'Approved';
         leadRec.Lead_DataSource__c='Campaign';
         } else {
        leadRec.CAC_Lead_Status__c = 'New';
       leadRec.Lead_DataSource__c='Dealer Outlet';
        }
       
        leadRec.Contact__c = campaignMember.Contact_Id__c;
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
        leadRec.Lead_DataSource__c='Campaign';
        leadRec.UsVIN__c=campaignMember.UsVIN__c;
        
        if(recordtypevalue!= null && recordtypevalue == 'Aftersales_leads') 
        {
            leadRec.RecordTypeId = leadRTId1;
            leadRec.AfterSales_Vehicle__c=campaignMember.Vehicle__c;
        }else if(recordtypevalue!= null && recordtypevalue == 'Sales_leads')
        {
            leadRec.RecordTypeId = leadRTId;
        }
        if(usr.market__c=='TH'&&campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c!=null){
        system.debug('***'+campaignMember.Campaign_ID__r.parent.Campaign_Type__c);
        leadRec.RecordTypeId=campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales'?leadRTId:campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'After Sales'?leadRTId1:leadRTId;
        leadRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
        system.debug('***rectype'+leadRec.RecordTypeId);
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
      private void insertCampaignLeadRecords(List<Lead__c> insertedLeadList, List<Lead__c> leadList) 
    {
        List<Campaign_Lead__c> cLeadList = new List<Campaign_Lead__c>();
        for(Lead__c leadRec : insertedLeadList)
        {
            cLeadList.add(setCampaignRec(leadRec));
        }  
        
        for(Lead__c leadRec : leadList)
        {
            cLeadList.add(setCampaignRec(leadRec));
        }
        
        if(cLeadList.size() > 0) 
        {
            insert cLeadList;
        }
    }
    @testvisible
    private Campaign_Lead__c setCampaignRec(Lead__c leadRec) 
    {
        Campaign_Lead__c cLeadRec = new Campaign_Lead__c(); 
        cLeadRec.Lead__c = leadRec.Id;
        if(CampaingCheck  == false) 
        {
            cLeadRec.Campaign__c = leadRec.Source_Campaign__c;
        } else if(RetailCheck  == false)
        {
        
               system.debug('++++++++Working retail+++++++');
            cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
        } 
        return cLeadRec;
    }
 }