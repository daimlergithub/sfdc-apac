/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.08.06
Company             :    NTT Data,Inc.
Usage               :     This Batch class will send an email to the user, if any campaign members are created with proper relation ship.
                          Campaign members records are getting created from Retail campaign CSV file,
                          in the file we are not sure either they have provided proper lookup fields values id, 
                        using this batch get those incorrect campaign memberes records and send an email to the user to correct.
JIRA NO             :                                                  
Bug JIRA NO         :     

MODIFICATION DETAILS:

1. Modified By      :    
Modifide Date    :    
************************************************************************************/
global class CorrectCampaignMemberDataCSV implements Database.Batchable<sObject> ,Database.stateful{
        
    global Map<id,String> cmmidmessage=new Map<id,String>();
    global Map<id,List<string>> erromessage=new Map<id,List<string>>();
    global List<string> liststr=new List<string>();
   // global Set<id> retailcmpid=new Set<id>();
    global id retailcmpid;
    global Retail_Campaign__c ret=new Retail_Campaign__c();
    global Map<Id,Campaign_Member__c> updateCampignMem=new Map<Id,Campaign_Member__c>();
     
    global CorrectCampaignMemberDataCSV(id retailcmpid)
    {
        this.retailcmpid=retailcmpid;
    }
     global Database.QueryLocator start(Database.BatchableContext bc){
       
      return Database.getQueryLocator([select Id,Name,Contact_Id__c,Retail_Campaign_Id__r.Segmentation_Base__c,Invalid_campaign_Member__c,Csv_Parser_Number__c,Vehicle__c,Vehicle_Relationship__c,Retail_Task__c,Contract__c,Preferred_Dealer__c,Retail_Campaign_Id__c,Status__c,Created_By_CSV__c,Market__c  from Campaign_Member__c where Created_By_CSV__c=true and createddate=today and Market__c='JP' and Retail_Campaign_Id__c=:retailcmpid]);
    }
     //execute method 
    global void execute(Database.BatchableContext bc,List<Campaign_Member__c> scope){
        Set<Id> accId=new Set<Id>();
        Set<Id> vehicleid=new Set<Id>();
        Set<Id> VrId=new Set<Id>();
        Set<Id> retailtaskID=new Set<Id>(); 
        Set<Id> PreferredDealer=new Set<Id>();
        
        List<Vehicle_Relationship__c> listVr=new List<Vehicle_Relationship__c>();
        List<Retail_Task__c> listrt=new List<Retail_Task__c>();
        
        for(Campaign_Member__c cm:scope)
        {
            if((cm.Contact_Id__c!=null))
            {
                accId.add(cm.Contact_Id__c);
            }
            if(cm.Retail_Campaign_Id__c !=null)
            {
               // retailcmpid.add(cm.Retail_Campaign_Id__c);
            }
            if(cm.Vehicle_Relationship__c !=null)
            {
                VrId.add(cm.Vehicle_Relationship__c);
            }
            if(cm.Contract__c !=null)
            {
                retailtaskID.add(cm.Contract__c);
            }
        }
     /*  Retail_Campaign__c  retc=new Retail_Campaign__c ();
       if(retailcmpid !=null)
       {
       retc=[Select id,name from Retail_Campaign__c where id=:retailcmpid]; 
       }*/
      
        if(VrId !=null)
        {
            listVr=[Select id,Contact__c, Vehicle_ID__c from Vehicle_Relationship__c where id=:VrId];
        }
        if(retailtaskID !=null)
        {
            listrt=[Select id,Account__c from Retail_Task__c where id=:retailtaskID];
        }
        
        for(Campaign_Member__c cmms:scope)
        {
            if(accId!=null)
            {
            System.debug('--------------> listVr'+listVr);
                if(listVr !=null)
                    {
                         for(Vehicle_Relationship__c vr:listVr)
                        {
                             
                            if(vr.contact__c != cmms.Contact_Id__c && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Vehicle')
                            {
                              //  liststr.add('Customer is not matched with VR customer');
                                cmms.Invalid_campaign_Member__c=true;
                                 updateCampignMem.put(cmms.Id,cmms);
                               cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.Customer_not_matched_with_VR_customer);
                            } 
                            if(vr.Vehicle_ID__c != cmms.Vehicle__c && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Vehicle')
                            {
                               //  liststr.add('Vehicle is not matched with VR Vehicle');
                                 cmms.Invalid_campaign_Member__c=true;
                                 updateCampignMem.put(cmms.Id,cmms);
                                cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.Vehicle_not_matched_with_VR_Vehicle);
                            }
                             if(vr.Vehicle_ID__c ==null && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Vehicle')
                            {
                               //  liststr.add('Vehicle is not matched with VR Vehicle');
                                 cmms.Invalid_campaign_Member__c=true;
                                 updateCampignMem.put(cmms.Id,cmms);
                                cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.Vehicle_missing_for_this_campaign_member);
                            }
                        }
                    
                    }
                     System.debug('--------------> listVr'+listVr.size());
                     System.debug('--------------> listVr'+listVr);
                     System.debug('------------cmms.Retail_Campaign_Id__r.Segmentation_Base__c--> listVr'+cmms.Retail_Campaign_Id__r.Segmentation_Base__c);
                    if(cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Vehicle' && (listVr.size()==0 || listVr ==null || listVr.isempty() ))
                    {
                     cmms.Invalid_campaign_Member__c=true;
                                 updateCampignMem.put(cmms.Id,cmms);
                               cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.VR_mandatory_for_Vehicle_base_segmentation);
                    }
                
            }
            if((accId == null || accId.isempty() || cmms.Contact_Id__c==null)  && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Customer' )
            {
            cmms.Invalid_campaign_Member__c=true;
                                 updateCampignMem.put(cmms.Id,cmms);
                               cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.Customer_mandatory_For_Retailcampaign);
            }
        
           
            if(listrt !=null)
            {
                 for(Retail_Task__c ret:listrt)
                {
                    
                    if(ret.Account__c != cmms.Contact_Id__c && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Contract')
                    {
                      //  liststr.add('Retail contract is not matched with customer');
                      cmms.Invalid_campaign_Member__c=true;
                         updateCampignMem.put(cmms.Id,cmms);
                         cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.RC_matched_with_customer);
                    }
                    if(cmms.Contract__c ==null && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Contract')
                    {
                      //  liststr.add('Retail contract is not matched with customer');
                      cmms.Invalid_campaign_Member__c=true;
                         updateCampignMem.put(cmms.Id,cmms);
                         cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+'Retail contract is mandatory');
                    }
                    
                }
                
            }
            if((listrt ==null || listrt.isempty()) && cmms.Retail_Campaign_Id__r.Segmentation_Base__c=='Contract')
            {
             cmms.Invalid_campaign_Member__c=true;
                         updateCampignMem.put(cmms.Id,cmms);
                         cmmidmessage.put(cmms.Id,cmms.Csv_Parser_Number__c+','+cmms.Name+','+label.RC_mandatory_for_Contract_RC);
            }
           
            if(liststr !=null)
            {
              //  cmms.Invalid_campaign_Member__c=true;
               // updateCampignMem.put(cmms.Id,cmms);
                 erromessage.put(cmms.Id,liststr);
            }
           
        }
        if(updateCampignMem !=null)
        {
            database.update(updateCampignMem.values(),false);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
          AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
      if(retailcmpid!=null)
      {
        ret=[Select id,name from Retail_Campaign__c where id=:retailcmpid limit 1];
        }
        String body = 'Your batch job '
             + 'CorrectCampaignMemberDataCSV  '
             + 'has finished. and' 
             + 'There were '
             +updateCampignMem.size() 
             +'records have issue ' 
             + ' Please find the error list attached to the Case.';
         // Creating the CSV file
            String finalstr = 'RowNumber, Name, Error \n';
            String subject = 'Campaign member Insertion for'+ret.Name+' - Apex Batch Error List';
         String attName = 'Campaign member Insertion.csv';
        List<Campaign_Member__c> listcampaignmember=new List<Campaign_Member__c>();
        listcampaignmember=[Select id, Name,Csv_Parser_Number__c from Campaign_Member__c where id=:cmmidmessage.keySet()];
        system.debug('@@@@@@-------------->>>>>listcampaignmember'+listcampaignmember);
        system.debug('@@@@@@-------------->>>>>'+cmmidmessage);
         system.debug('@@@@@@-------------->>>>>'+cmmidmessage.size());
       
             
              for(Id id  : cmmidmessage.keySet()){
               //  List<string> err=cmmidmessage.get(id);
                string err = cmmidmessage.get(id);
                 system.debug('@@@@@@-------------->>>>>'+err);
                string recordString = err+'"\n';
                finalstr = finalstr +recordString;
              
            } 
        System.debug('@@@@@@@@@@@@@@@@@@@@'+finalstr);
        Attachment att=new attachment();
        att.Body=Blob.valueOf(finalstr);
        att.ParentId=ret.id;
        att.Name='Incorrect data file.csv';
        att.ContentType='application/vnd.ms-excel';
        insert att;
         // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
 
            // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {'NTT_Daimler_SO_Team@nttdata.com'} );
            email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
                
                 if(retailcmpid !=null)
                {
                 if(!test.isrunningtest())
                {
                DeleteInvalidCSVCampaignMembers db=new DeleteInvalidCSVCampaignMembers(retailcmpid);
                database.executebatch(db,200);
                }
                }
        
    }
    

}