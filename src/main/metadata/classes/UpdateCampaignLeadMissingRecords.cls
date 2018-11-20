/***********************************************************************************
Created By          :    venky    
Created Date        :    03.10.2018
Company             :    NTT Data,Inc.
Usage               :    Add/Update Campaign_Lead__c based on Lead__c.
Business Conditions :
*   
JIRA NO             :      

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/
global class UpdateCampaignLeadMissingRecords implements Database.Batchable<sObject> ,Database.stateful{
 
    
      private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    global List<Lead__c> listLead=new List<Lead__c>();
    global List<Campaign_member__c> listcmm=new List<Campaign_member__c>();
    global Map<Id,Lead__c> leadsid=new Map<Id,Lead__c>();
    global list<Id> successlist=new list<ID>();
    global Set<id> MissingLeads=new Set<Id>();
    global List<Campaign_Lead__c> totalcamlead=new List<Campaign_Lead__c>();
     global Database.QueryLocator start(Database.BatchableContext BC){
         String dupnumber=label.Campaign_Member_Lead;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup);
        
        return Database.getQueryLocator([Select id,MD__c ,AfterSales_Vehicle__c,Assigned_Dealer__r.Dealer_GC_Code__c,CAC_Lead_Status__c,Recordtypeid,Dealer_Lead_Status__c,contact__c from Lead__c where createddate >=:lastmodifedDupNum and Md__c='JP' and (Recordtypeid=:salesRecordTypeId) and Contact__c !=null and Dealer_Lead_Status__c !='Lost' and CAC_Lead_Status__c ='Allocated']);

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
             
            
             List<Campaign_member__c> listCamMember=new List<Campaign_member__c>();
             List<Campaign_member__c> listRetCamMember=new List<Campaign_member__c>();
             List<Campaign_Lead__c> listcamlead=new List<Campaign_Lead__c>();
             List<Campaign_Lead__c> Cmlistcamlead=new List<Campaign_Lead__c>();
            
            
            for(Lead__c le:scope)
             {
                 if(le.contact__c !=null && le.Dealer_Lead_Status__c !='Lost' && le.CAC_Lead_Status__c =='Allocated' )
                 {
                     AccId.add(le.Contact__c);
                     LeadId.add(le.Id);
                     if(le.RecordTypeId ==salesRecordTypeId)
                     {
                        salesLeadRecId.add(le.RecordTypeId); 
                        leadsid.put(le.id,le);
                          
                     }                                        
                     
                     DealerGccode.add(le.Assigned_Dealer__r.Dealer_GC_Code__c);
                 }
             }
            if(AccId !=null)
             {
                 listCamMember=[Select id,Status__c,Campaign_ID__c,Campaign_ID__r.Segmentation_Base__c,Vehicle__c,Preferred_Dealer__r.Dealer_GC_Code__c,Contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign_ID__r.Parent.Campaign_Sub_Type__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Campaign_ID__c !=null and Contact_Id__c=:AccId and (Campaign_ID__r.Child_Campaign_Status__c='Execution' or Campaign_ID__r.Child_Campaign_Status__c='Response collection') and (Campaign_ID__r.Execution_type__c !='My Mercedes' and Campaign_ID__r.Execution_type__c !='Lead' and Campaign_ID__r.Execution_type__c !='Survey') and (Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales' OR Campaign_ID__r.Parent.Campaign_Sub_Type__c='Sales and After Sales') ];
                 listRetCamMember=[Select id,Status__c,Retail_Campaign_Id__c,Retail_Campaign_Id__r.Segmentation_Base__c,Vehicle__c,Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c,Retail_Campaign_Id__r.Parent_Campaign__c,Preferred_Dealer__r.Dealer_GC_Code__c ,Retail_Campaign_Id__r.Child_Campaign_Status__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Sub_Type__c,contact_Id__c,Campaign_ID__r.Child_Campaign_Status__c,Campaign_ID__r.Execution_type__c ,Campaign__c,Campaign__r.Parent.Campaign_Sub_Type__c from Campaign_member__c where Retail_Campaign_Id__c !=null and Contact_Id__c=:AccId  and Retail_Campaign_Id__r.Parent_Campaign__c !=null and(Retail_Campaign_Id__r.Child_Campaign_Status__c='Execution' or Retail_Campaign_Id__r.Child_Campaign_Status__c='Response collection') and (Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='Sales' Or Retail_Campaign_Id__r.Parent_Campaign__r.Parent.Campaign_Sub_Type__c='sales and After Sales')];
                                
             }
              if(listCamMember!=null)
             {
                 for(Campaign_member__c cmember:listCamMember)
                 {
                     cmemberCamId.add(cmember.Campaign_ID__c);
                     camMemberId.add(cmember.id);
                 }
                if(cmemberCamId !=null && LeadId !=null)
                {
                   listcamlead=[Select Lead__c,Campaign__c,Campaign_Member__c from Campaign_Lead__c where Campaign__c=:cmemberCamId and Lead__c=:LeadId and (Campaign_Member__c=:camMemberId)];  
                }
                 
                 if(listcamlead ==null || listcamlead.size()==0 && (listCamMember !=null || listCamMember.size()>0 ))
                 {
                     for(Lead__c l:scope)
                     {
                         for(Campaign_member__c cms:listCamMember)
                         {
                             if(cms.Contact_Id__c == l.contact__c)
                             {
                                 MissingLeads.add(l.id);
                             }
                         }
                     }
                 }
             }
            
            if(listRetCamMember!=null)
             {
                 for(Campaign_member__c cmember:listRetCamMember)
                 {
                     RetcamMemberId.add(cmember.Retail_Campaign_Id__c);
                     cmemberRetailCamId.add(cmember.id);
                 }
                if(RetcamMemberId !=null && LeadId !=null)
                {
                   Cmlistcamlead=[Select Lead__c,Campaign__c,Retail_Campaign__c,Campaign_Member__c from Campaign_Lead__c where Retail_Campaign__c=:RetcamMemberId and Lead__c=:LeadId and (Campaign_Member__c=:cmemberRetailCamId)];  
                }
                 
                 if(Cmlistcamlead ==null || listcamlead.size()==0 && (listRetCamMember !=null || listRetCamMember.size()>0 ))
                 {
                     for(Lead__c l:scope)
                     {
                         for(Campaign_member__c cms:listRetCamMember)
                         {
                             if(cms.Contact_Id__c == l.contact__c)
                             {
                                 MissingLeads.add(l.id);
                             }
                         }
                     }
                 }
             }
            
            
        }
         global void finish(Database.BatchableContext BC){
             
             List<Lead__c> camLead=new List<Lead__c>();
             camLead=[Select id,Name from lead__c Where id=:MissingLeads];
             
             String attName = 'UpdateCampaignLeadBatch.csv';
             String body = 'Your batch job '
             + 'UpdateCampaignLeadBatch'
             + 'has finished.'
             +'Campaign lead records are not created for'+camLead.size()+'Lead Records ';
             String finalstr = 'Id, Name, Error \n';
             String subject = 'UpdateCampaignLeadBatch'+'Execution is completed on '+System.today();
             if(camLead !=null)
             {  
             for(lead__c le:camLead)
             {
             string recordString = '"'+le.id+'","'+le.Name+'","'+ +'"\n';
                finalstr = finalstr +recordString;
             }
             
              // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
 
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {'ayyavari.venkateswarlu@nttdata.com'} );
           // email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
             
             }
             
            if(MissingLeads !=null)
            {
                CreateMissingCampaignLead db=new CreateMissingCampaignLead(MissingLeads);
                database.executeBatch(db,1);
            }
             
         }
    
}