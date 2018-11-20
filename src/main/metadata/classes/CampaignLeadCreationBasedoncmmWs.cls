/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.08.15
Company             :    NTT Data,Inc.
Usage               :     This Batch class will Cretae Whole sale and retail campaign leads based on campaign member records.
JIRA NO             :         SFDCJP-3453                                          
Bug JIRA NO         :     

MODIFICATION DETAILS:

1. Modified By      :    
Modifide Date    :    
************************************************************************************/
global class CampaignLeadCreationBasedoncmmWs implements Database.Batchable<sObject> ,Database.stateful  {

       private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
     global Database.QueryLocator start(Database.BatchableContext bc){
       
      return Database.getQueryLocator([Select id,Status__c,Campaign_ID__c,market__c,Campaign_ID__r.Segmentation_Base__c,Vehicle__c,Preferred_Dealer__r.Dealer_GC_Code__c,Contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign_ID__r.Execution_Start_Date__c,Campaign_ID__r.Parent.Campaign_Sub_Type__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Campaign_ID__c !=null and market__c='JP' and Contact_Id__c!=null and Campaign_ID__r.Execution_Start_Date__c=today and Market__c='JP' and (Campaign_ID__r.Execution_type__c !='My Mercedes' and Campaign_ID__r.Execution_type__c !='Lead' and Campaign_ID__r.Execution_type__c !='Survey') and (Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales' OR Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales and After Sales')]);
    }
     //execute method 
    global void execute(Database.BatchableContext bc,List<Campaign_Member__c> scope){
        Set<Id> Accid=new Set<Id>();
        List<Lead__c> ListLead=new List<Lead__c>();
        List<Campaign_Lead__c> insertcamlead=new List<Campaign_Lead__c>();
        Map<Id,Campaign_member__c> updatecammember=new Map<id,Campaign_member__c>();
        for(Campaign_Member__c cmm:scope)
        {
            if(cmm.Contact_Id__c !=null)
            {
                Accid.add(cmm.Contact_Id__c);
            }
        }
        if(Accid !=null)
        {
        ListLead=[Select id,MD__c ,AfterSales_Vehicle__c,Assigned_Dealer__r.Dealer_GC_Code__c,CAC_Lead_Status__c,Recordtypeid,Dealer_Lead_Status__c,contact__c from Lead__c where  Md__c='JP' and Recordtypeid=:salesRecordTypeId  and Contact__c !=null and Contact__c=:Accid and Dealer_Lead_Status__c !='Lost' and Dealer_Lead_Status__c !='Purchased(Only Non BDC)' and Dealer_Lead_Status__c !='Order Placed' and CAC_Lead_Status__c = 'Allocated'];    
        }
        
        if(ListLead !=null && ListLead.size()>0)
        {
            for(Campaign_Member__c cm:scope)
            {                
                    for(Lead__c le:ListLead)
                        {
                            if(le.contact__c == cm.Contact_Id__c)
                            {
                                Campaign_Lead__c newcamlead =new Campaign_Lead__c();
                                            newcamlead.lead__c=le.id;
                                             newcamlead.Campaign__c=cm.Campaign_ID__c;
                                             newcamlead.Campaign_Member__c=cm.Id;  
                                             insertcamlead.add(newcamlead);
                            }  
                            if(cm.Preferred_Dealer__r.Dealer_GC_Code__c == le.Assigned_Dealer__r.Dealer_GC_Code__c)
                            {
                                cm.Convert_To_Lead_Flag__c=true;
                                cm.Status__c='Responded';
                                updatecammember.put(cm.id,cm);
                            }
                            if(cm.Preferred_Dealer__r.Dealer_GC_Code__c != le.Assigned_Dealer__r.Dealer_GC_Code__c)
                            {
                                cm.Convert_To_Lead_Flag__c=true;
                                cm.Convert_By_Others__c=true;  
                                cm.Status__c='Responded'; 
                                 updatecammember.put(cm.id,cm);
                            }
                            
                        }                 
            }
            
        }
        if(insertcamlead !=null)
        {
            database.insert(insertcamlead);
        }
        if(updatecammember !=null)
        {
            Database.update(updatecammember.values(),false);
        }
    }
    
    global void finish(Database.BatchableContext bc){
    }
}