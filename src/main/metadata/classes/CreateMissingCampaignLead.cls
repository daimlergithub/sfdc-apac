/***********************************************************************************
Created By          :    venky    
Created Date        :    04.10.2018
Company             :    NTT Data,Inc.
Usage               :    Add/Update Campaign_Lead__c based on Lead__c.
Business Conditions :
*   
JIRA NO             :     

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class CreateMissingCampaignLead implements Database.Batchable<sObject> ,Database.stateful{ 
  global Set<id> leadsid=new set<id>();
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    
    global CreateMissingCampaignLead(Set<id> leadids)
    {
        this.leadsid=leadids;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
         String dupnumber=label.Campaign_Member_Lead;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
       return Database.getQueryLocator([Select id,MD__c ,AfterSales_Vehicle__c,Assigned_Dealer__r.Dealer_GC_Code__c,CAC_Lead_Status__c,Recordtypeid,Dealer_Lead_Status__c,contact__c from Lead__c where createddate >=:lastmodifedDupNum and Md__c='JP' and (Recordtypeid=:salesRecordTypeId) and Contact__c !=null and Dealer_Lead_Status__c !='Lost' and CAC_Lead_Status__c ='Allocated' and id=:leadsid]);
    }
     global void execute(Database.BatchableContext BC, List<Lead__c> scope){
         
           Set<id> AccId=new Set<Id>();
              Set<String> DealerGccode=new Set<String>();
              Set<id> LeadId=new Set<Id>();
             Set<id> salesLeadRecId=new Set<id>();
             Set<id> aftersalesLeadRecId=new Set<id>();
             Set<id> vehicleId=new Set<Id>(); 
             Set<id> cmemberCamId=new Set<Id>();
             Set<id> camMemberId=new Set<Id>();
             Set<id> RetcamMemberId=new Set<Id>();
              Set<id> cmemberRetailCamId=new Set<Id>();
             boolean aftersaleslead=false;
             boolean Recsaleslead=false;
              //Set<id> LeadId=new Set<Id>();
             Map<Id,Campaign_Lead__c> updatecamlead=new Map<id,Campaign_Lead__c>();
             Map<Id,Campaign_member__c> updatecammember=new Map<id,Campaign_member__c>();
             List<Campaign_member__c> listCamMember=new List<Campaign_member__c>();
              List<Campaign_member__c> listRetCamMember=new List<Campaign_member__c>();
             List<Campaign_Lead__c> listcamlead=new List<Campaign_Lead__c>();
             List<Campaign_Lead__c> Cmlistcamlead=new List<Campaign_Lead__c>();
              List<Campaign_Lead__c> listRetcamlead=new List<Campaign_Lead__c>();
              List<Campaign_Lead__c> CmlistRetcamlead=new List<Campaign_Lead__c>();
             List<Campaign_Lead__c> insertcamlead=new List<Campaign_Lead__c>(); 
              
             for(Lead__c le:scope)
             {
                 if(le.contact__c !=null && le.Dealer_Lead_Status__c !='Lost' && le.CAC_Lead_Status__c =='Allocated' )
                 {
                     AccId.add(le.Contact__c);
                     LeadId.add(le.Id);
                     if(le.RecordTypeId ==salesRecordTypeId)
                     {
                        salesLeadRecId.add(le.RecordTypeId); 
                         Recsaleslead=true;
                     }
                     
                     
                     
                     DealerGccode.add(le.Assigned_Dealer__r.Dealer_GC_Code__c);
                 }
             }
             if(AccId !=null && Recsaleslead==true)
             {
                 listCamMember=[Select id,Status__c,Campaign_ID__c,Campaign_ID__r.Segmentation_Base__c,Vehicle__c,Preferred_Dealer__r.Dealer_GC_Code__c,Contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign_ID__r.Parent.Campaign_Sub_Type__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Campaign_ID__c !=null and Contact_Id__c=:AccId and (Campaign_ID__r.Child_Campaign_Status__c='Execution' or Campaign_ID__r.Child_Campaign_Status__c='Response collection') and (Campaign_ID__r.Execution_type__c !='My Mercedes' and Campaign_ID__r.Execution_type__c !='Lead' and Campaign_ID__r.Execution_type__c !='Survey') and (Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales' OR Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales and After Sales') ];
                 listRetCamMember=[Select id,Status__c,Retail_Campaign_Id__c,Retail_Campaign_Id__r.Segmentation_Base__c,Vehicle__c,Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c,Retail_Campaign_Id__r.Parent_Campaign__c,Preferred_Dealer__r.Dealer_GC_Code__c ,Retail_Campaign_Id__r.Child_Campaign_Status__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Sub_Type__c,contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Retail_Campaign_Id__c !=null and Contact_Id__c=:AccId  and Retail_Campaign_Id__r.Parent_Campaign__c !=null and(Retail_Campaign_Id__r.Child_Campaign_Status__c='Execution' or Retail_Campaign_Id__r.Child_Campaign_Status__c='Response collection') and (Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='Sales' Or Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='sales and After Sales')];
                                
             }
             
              
             // Campaign related functionality 
             if(listCamMember!=null)
             {
                 for(Campaign_member__c cmember:listCamMember)
                 {
                     cmemberCamId.add(cmember.Campaign_ID__c);
                     camMemberId.add(cmember.id);
                 }
            if(cmemberCamId !=null && LeadId !=null)
            {
               listcamlead=[Select Lead__c,Campaign__c,Campaign_Member__c from Campaign_Lead__c where Campaign__c=:cmemberCamId and Lead__c=:LeadId and (Campaign_Member__c=:camMemberId OR Campaign_Member__c =null)];  
            }
            if(listcamlead !=null)
            {
                database.delete(listcamlead);
            }
        
           /*  if(listcamlead !=null && listcamlead.size()>0)
             {
                 
                 for(Campaign_Lead__c camLead:listcamlead)
                 {
                     for(Campaign_member__c member:listCamMember )
                     {
                         if(camLead.Campaign__c == member.Campaign_ID__c)
                         {
                             camlead.Campaign_Member__c =member.Id;
                             updatecamlead.put(camLead.Id, camLead);
                         }
                     }
                 }
             }*/
                 
                 
              
                
                 for(Lead__c led:scope)
                 {
                     // newcamlead=new Campaign_Lead__c(); 
                                    if(listCamMember !=null)
                                    {
                                        for(Campaign_member__c oldmember:listCamMember )
                                         {
                                             Campaign_Lead__c newcamlead =new Campaign_Lead__c();
                                            newcamlead.lead__c=led.id;
                                             newcamlead.Campaign__c=oldmember.Campaign_ID__c;
                                             newcamlead.Campaign_Member__c=oldmember.Id;  
                                             insertcamlead.add(newcamlead);
                                         }   
                                        
                                    }
                                                    
                 }              
             
             for(Lead__c leds:scope)
                 {
                     for(Campaign_member__c oldmembers:listCamMember )
                         {
                             if(oldmembers.Preferred_Dealer__r.Dealer_GC_Code__c == leds.Assigned_Dealer__r.Dealer_GC_Code__c)
                             {
                                 oldmembers.Convert_To_Lead_Flag__c=true;
                                 oldmembers.Status__c='Responded';
                                 updatecammember.put(oldmembers.id,oldmembers);
                             }
                             if(oldmembers.Preferred_Dealer__r.Dealer_GC_Code__c != leds.Assigned_Dealer__r.Dealer_GC_Code__c)
                             {
                                  oldmembers.Convert_To_Lead_Flag__c=true;
                                 oldmembers.Convert_By_Others__c=true;
                                 oldmembers.Status__c='Responded';
                                 updatecammember.put(oldmembers.id,oldmembers);
                             }
                         }
                 } 
             

         }
             
             // Retail Campaign related functionality 
             if(listRetCamMember !=null)
             {
                 for(Campaign_member__c retail:listRetCamMember)
                 {
                     if(retail.Retail_Campaign_Id__c !=null)
                     {
                         cmemberRetailCamId.add(retail.Retail_Campaign_Id__c);
                         RetcamMemberId.add(retail.id);
                     }
                     
                 }
                 if(cmemberRetailCamId !=null)
                 {
                     listRetcamlead=[Select Lead__c,Campaign__c,Retail_Campaign__c,Campaign_Member__c from Campaign_Lead__c where Retail_Campaign__c=:cmemberRetailCamId and Lead__c=:LeadId and (Campaign_Member__c=:RetcamMemberId OR Campaign_Member__c =null)];
                 }
                  if(listRetcamlead !=null)
                    {
                        database.delete(listRetcamlead);
                    }
                /* if(listRetcamlead !=null && listRetcamlead.size()>0 )
                 {
                     for(Campaign_Lead__c camLeads:listRetcamlead)
                     {
                         for(Campaign_member__c member:listRetCamMember )
                         {
                             
                                 camleads.Campaign_Member__c =member.Id;
                                 updatecamlead.put(camLeads.Id, camLeads); 
                         }
                     }
                     
                 }*/
                  
                    
                 for(Lead__c rtled:scope)
                 {
                      if(listRetCamMember !=null)
                      {
                           for(Campaign_member__c oldmemberetr:listRetCamMember )
                             {
                                 Campaign_Lead__c newrtcamlead=new Campaign_Lead__c();
                                 newrtcamlead.lead__c=rtled.id;
                                 newrtcamlead.Retail_Campaign__c=oldmemberetr.Retail_Campaign_Id__c;
                                 newrtcamlead.Campaign_Member__c=oldmemberetr.Id;  
                                 insertcamlead.add(newrtcamlead);  
                             }
                          
                      }
                        
                      
                 }  
                 
                 for(Lead__c ledsrt:scope)
                 {
                     for(Campaign_member__c oldmembersrt:listRetCamMember )
                         {
                             if(oldmembersrt.Preferred_Dealer__r.Dealer_GC_Code__c == ledsrt.Assigned_Dealer__r.Dealer_GC_Code__c)
                             {
                                 oldmembersrt.Convert_To_Lead_Flag__c=true;
                                 oldmembersrt.Status__c='Responded';
                                 updatecammember.put(oldmembersrt.id,oldmembersrt);
                             }
                             if(oldmembersrt.Preferred_Dealer__r.Dealer_GC_Code__c != ledsrt.Assigned_Dealer__r.Dealer_GC_Code__c)
                             {
                                 oldmembersrt.Convert_By_Others__c=true;
                                 updatecammember.put(oldmembersrt.id,oldmembersrt);
                             }
                         }
                 } 
             
             }
             
             
              if(updatecamlead !=null)
             {
                // database.update(updatecamlead.values(),false);
             }
             if(insertcamlead !=null)
             {
                 Database.insert(insertcamlead,false);
             }           
             if(updatecammember !=null)
             {
                 database.update(updatecammember.values(),false);
             }
     }
     global void finish(Database.BatchableContext BC){
         
     }

}