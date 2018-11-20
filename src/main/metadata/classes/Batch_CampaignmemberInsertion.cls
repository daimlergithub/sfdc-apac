global class Batch_CampaignmemberInsertion implements Database.Batchable<sObject> ,Database.stateful{
  global final set<id> campid; 
  public set<id> retCampid=new set<Id>(); 
  public set<id> retCampids=new set<Id>(); 
  global final Map<id,Retail_campaign__c> Maplist; 
   global final List<Retail_Campaign__c> retCampList; 
   global list<Retail_Campaign__c> listret=new List<Retail_Campaign__c>();
   global  Campaign camprec=new  Campaign();
   global Map<Id, String> errorMap {get; set;}
   global Map<Id, String> successMap {get; set;}
     global list<Id> successlist=new list<ID>();
   global Map<Id, SObject> IdToSObjectMap {get; set;}
    
    global Batch_CampaignmemberInsertion( Map<id,Retail_Campaign__c> newmaplist,Set<id> campeid,List<Retail_Campaign__c> retCampList,Set<id> retCampid){
    
    System.debug('$$$$$$$$$$$$$$$$$$$$ retCampList'+retCampList);
    System.debug('$$$$$$$$$$$$$$$$$$$$ campeid'+campeid);
    System.debug('$$$$$$$$$$$$$$$$$$$$ newmaplist'+newmaplist);
     system.debug('@@@@retCampList@@@@'+retCampid);
      campid = campeid;
      Maplist = newmaplist;
      retCampList=retCampList;
      this.retCampid=retCampid;
        system.debug('@@@@retCampList@@@@'+retCampid);
         errorMap = new Map<Id, String>();
        successMap= new Map<Id, String>();
        IdToSObjectMap = new Map<Id, SObject>();
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,Name,Cross_point_month_and_year__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c,Final_GAP_Amount__c,Evaluation_Result_P1_P2_Blank__c,OptOutContact_Reason__c,Postal_OptOut__c,Email_OptOut__c,Retail_Campaign_Id__c,Missing_Flag__c,Status__c,Preferred_Dealer__c,Contract__c,contact_Id__c,Address__c,Customer_Complete_Address__c,NextInspectionDate__c,NextServiceDate__c,LastInspectionDate__c,LastServiceDate__c,LastWorkDate__c,Service_Advisor__c,Sales_Consultant__c,Vehicle__c,Vehicle_Relationship__c,CUSTOMER_LABEL_NAME__C,Retail_Copy__c,Vehicle_ExternalLink__c,Whole_Sale_Campaign_Member__c,Participate_Date__c,My_Mercedes_ID__c,Sending_Date__c,RespondedDate__c,Account_information_updates__c,Source_of_CM_Response__c,Recipient_changes__c,Status_Change_Date__c,Lead_Type__c,Interested_Model__c,Lead_Desired_Service__c,Purchase_Timing__c,Lead_Sub_Type__c,Cross_Point_Model__c,Term__c,Total_Vehicle_Price_with_tax__c,Customer_Interest_Rate__c,Total_Vehicle_Price_without_tax__c,Monthly_Payment_amount_with_Tax__c,Finance_Product_Name__c,Monthly_Payment__c,RV_Ballon__c,Contract_Phone1_1__c,Finance_Product__c,Contract_Phone2_2__c,Contract_Status__c,Finance_Address__c,Payment_Start_Date__c,Payment_End_Date__c,Gaurantor_1_Name__c,Finance_Vehicle__c,Gaurantor2_Name__c,Mileage__c,Gaurantor3_Name__c,No_of_Payments__c,Fine_Rate__c,Monthly_Payment_amount__c,Interest_Rate__c,Bonus_Month1__c,Bonus_Amount1__c,Bonus_Month2__c,Bonus_Amount2__c,Lease_Loan_Flag__c,Indemnity_Amount__c,Deferred_Payment_loan__c,Contract_Start_date_Lease__c,Shinpan__c,Contract_End_date_Lease__c,Delinquency_Flag__c,MBF_Anti_Social_flag__c,Re_Lease_Extension_Date__c,Special_flag_to_Exclude__c,Re_Lease_Prohibit_Flag__c,Special_Flag_to_Include__c,Payment_Suspended_Flag__c,Offer_Prohibit_Flag__c From Campaign_Member__c Where Campaign_id__c =: campid ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Member__c> scope){
    //List<Campaign_Member__c > retailMem = New List<Campaign_Member__c >();
    Map<id,Campaign_Member__c > retailMem = New Map<id,Campaign_Member__c >();
    Map<id,id> MapMainList = New Map<Id,id>();
     System.debug('$%$%$%$%$%$%$%$%$ retCampid'+retCampid);
     if(retCampid !=null)
     {
    listret=[Select Id,Parent_Campaign__c,RecordTypeId  From Retail_Campaign__c where id=:retCampid];
    }
    System.debug('$%$%$%$%$%$%$%$%$ listret'+listret);
    if(listret !=null)
    {
    for(Retail_Campaign__c rts:listret)
    {
    retCampids.add(rts.id);
    }
    
    }
    System.debug('$%$%$%$%$%$%$%$%$ retCampids'+retCampids);
    List<Retail_Campaign__c> rett = [Select id,Dealer_Name__c,Parent_Campaign__c From Retail_Campaign__c Where Parent_Campaign__c =: Campid];
    
    For(Retail_Campaign__c retmain : rett){
    
    
   MapMainList.put(retmain.Dealer_Name__c , retmain.id);
    
    }
    For(Campaign_Member__c camo : scope){
    
    if(camo.Status__c !='Removed'){ 
                 system.debug('++++++++++++++++'+Maplist.size());
                 Campaign_Member__c newCamRetail = new Campaign_Member__c();
                if(MapMainList.get(camo.Preferred_Dealer__c) != null){
                 newCamRetail.Retail_Campaign_Id__c =MapMainList.get(camo.Preferred_Dealer__c);
                 }
                 
                 system.debug('++++++++++===='+MapMainList.get(camo.Preferred_Dealer__c));
                 newCamRetail.Status__c = camo.Status__c;
                 newCamRetail.Preferred_Dealer__c = camo.Preferred_Dealer__c;
                 newCamRetail.contact_Id__c = camo.contact_Id__c;
                 
                 if(camo.Address__c !=null)
                 {
                  newCamRetail.Address__c = camo.Address__c;
                 }
                 if(camo.Customer_Complete_Address__c !=null)
                 {
                  newCamRetail.Customer_Complete_Address__c = camo.Customer_Complete_Address__c;
                 }
                  
                  if(camo.NextInspectionDate__c !=null)
                 {
                   newCamRetail.NextInspectionDate__c = camo.NextInspectionDate__c;
                 }
                  if(camo.NextServiceDate__c !=null)
                 {
                  newCamRetail.NextServiceDate__c = camo.NextServiceDate__c;
                 }
                  if(camo.LastInspectionDate__c !=null)
                 {
                  newCamRetail.LastInspectionDate__c = camo.LastInspectionDate__c;
                 }
                  if(camo.LastServiceDate__c !=null)
                 {
                 newCamRetail.LastServiceDate__c = camo.LastServiceDate__c;
                 }
                  if(camo.LastWorkDate__c !=null)
                 {
                  newCamRetail.LastWorkDate__c = camo.LastWorkDate__c;
                 }
                 if(camo.Service_Advisor__c !=null)
                 {
                  newCamRetail.Service_Advisor__c = camo.Service_Advisor__c;
                 } 
                 if(camo.Sales_Consultant__c !=null)
                 {
                 newCamRetail.Sales_Consultant__c = camo.Sales_Consultant__c;
                 }
                 if(camo.Vehicle__c !=null)
                 {
                newCamRetail.Vehicle__c = camo.Vehicle__c;
                 }
                 if(camo.Vehicle_Relationship__c !=null)
                 {
                newCamRetail.Vehicle_Relationship__c = camo.Vehicle_Relationship__c;
                 }
                 if(camo.CUSTOMER_LABEL_NAME__C !=null)
                 {
                  newCamRetail.CUSTOMER_LABEL_NAME__C = camo.CUSTOMER_LABEL_NAME__C;
                 }
                 if(camo.Retail_Copy__c !=null)
                 {
                newCamRetail.Retail_Copy__c = camo.Retail_Copy__c;
                 }
                 if(camo.Vehicle_ExternalLink__c !=null)
                 {
                  newCamRetail.Vehicle_ExternalLink__c = camo.Vehicle_ExternalLink__c;
                 }
                  if(camo.Contract__c !=null)
                 {
                  newCamRetail.Contract__c = camo.Contract__c;
                 }
                 
                  if(camo.OptOutContact_Reason__c!=null)
                 {
                  newCamRetail.OptOutContact_Reason__c= camo.OptOutContact_Reason__c;
                 }
                 if(camo.Postal_OptOut__c!=null)
                 {
                  newCamRetail.Postal_OptOut__c= camo.Postal_OptOut__c;
                 }
                 if(camo.Email_OptOut__c !=null)
                 {
                  newCamRetail.Email_OptOut__c= camo.Email_OptOut__c;
                 }
                if(camo.Missing_Flag__c!=null)
                 {
                  newCamRetail.Missing_Flag__c= camo.Missing_Flag__c;
                 }
                 if(camo.Cross_point_month_and_year__c !=null)
                 {
                  newCamRetail.Cross_point_month_and_year__c= camo.Cross_point_month_and_year__c;
                 }
                 if(camo.Outstanding_Balance_amount__c !=null)
                 {
                  newCamRetail.Outstanding_Balance_amount__c= camo.Outstanding_Balance_amount__c;
                 }
                 if(camo.Proto_Market_Value_amount__c !=null)
                 {
                  newCamRetail.Proto_Market_Value_amount__c= camo.Proto_Market_Value_amount__c;
                 }
                 if(camo.Final_GAP_Amount__c !=null)
                 {
                  newCamRetail.Final_GAP_Amount__c= camo.Final_GAP_Amount__c;
                 }
                 if(camo.Evaluation_Result_P1_P2_Blank__c !=null)
                 {
                  newCamRetail.Evaluation_Result_P1_P2_Blank__c= camo.Evaluation_Result_P1_P2_Blank__c;
                 }
				 if(camo.Participate_Date__c !=null)
                 {
                  newCamRetail.Participate_Date__c = camo.Participate_Date__c;
                 }
                 if(camo.My_Mercedes_ID__c !=null)
                 {
                  newCamRetail.My_Mercedes_ID__c = camo.My_Mercedes_ID__c;
                 }
                 if(camo.Sending_Date__c !=null)
                 {
                   newCamRetail.Sending_Date__c = camo.Sending_Date__c;
                 }
                  if(camo.RespondedDate__c !=null)
                 {
                  newCamRetail.RespondedDate__c = camo.RespondedDate__c;
                 }
                  if(camo.Account_information_updates__c !=null)
                 {
                  newCamRetail.Account_information_updates__c = camo.Account_information_updates__c;
                 }
                  if(camo.Source_of_CM_Response__c !=null)
                 {
                 newCamRetail.Source_of_CM_Response__c = camo.Source_of_CM_Response__c;
                 }
                  if(camo.Recipient_changes__c !=null)
                 {
                  newCamRetail.Recipient_changes__c = camo.Recipient_changes__c;
                 }
                 if(camo.Status_Change_Date__c !=null)
                 {
                  newCamRetail.Status_Change_Date__c = camo.Status_Change_Date__c;
                 } 
                 if(camo.Lead_Type__c !=null)
                 {
                 newCamRetail.Lead_Type__c = camo.Lead_Type__c;
                 }
                 if(camo.Interested_Model__c !=null)
                 {
                newCamRetail.Interested_Model__c = camo.Interested_Model__c;
                 }
                 if(camo.Lead_Desired_Service__c !=null)
                 {
                newCamRetail.Lead_Desired_Service__c = camo.Lead_Desired_Service__c;
                 }
                 if(camo.Purchase_Timing__c !=null)
                 {
                  newCamRetail.Purchase_Timing__c = camo.Purchase_Timing__c;
                 }
                 if(camo.Lead_Sub_Type__c !=null)
                 {
                newCamRetail.Lead_Sub_Type__c = camo.Lead_Sub_Type__c;
                 }
                 if(camo.Cross_Point_Model__c !=null)
                 {
                  newCamRetail.Cross_Point_Model__c = camo.Cross_Point_Model__c;
                 }
                  if(camo.Term__c !=null)
                 {
                  newCamRetail.Term__c = camo.Term__c;
                 }
                 if(camo.Total_Vehicle_Price_with_tax__c!=null)
                 {
                  newCamRetail.Total_Vehicle_Price_with_tax__c= camo.Total_Vehicle_Price_with_tax__c;
                 }
                 if(camo.Customer_Interest_Rate__c!=null)
                 {
                  newCamRetail.Customer_Interest_Rate__c= camo.Customer_Interest_Rate__c;
                 }
                 if(camo.Total_Vehicle_Price_without_tax__c !=null)
                 {
                  newCamRetail.Total_Vehicle_Price_without_tax__c= camo.Total_Vehicle_Price_without_tax__c;
                 }
                if(camo.Monthly_Payment_amount_with_Tax__c!=null)
                 {
                  newCamRetail.Monthly_Payment_amount_with_Tax__c= camo.Monthly_Payment_amount_with_Tax__c;
                 }
                 if(camo.Finance_Product_Name__c !=null)
                 {
                  newCamRetail.Finance_Product_Name__c= camo.Finance_Product_Name__c;
                 }
                 if(camo.Monthly_Payment__c !=null)
                 {
                  newCamRetail.Monthly_Payment__c= camo.Monthly_Payment__c;
                 }
                 if(camo.RV_Ballon__c !=null)
                 {
                  newCamRetail.RV_Ballon__c= camo.RV_Ballon__c;
                 }
                 if(camo.Contract_Phone1_1__c !=null)
                 {
                  newCamRetail.Contract_Phone1_1__c= camo.Contract_Phone1_1__c;
                 }
                 if(camo.Finance_Product__c !=null)
                 {
                  newCamRetail.Finance_Product__c= camo.Finance_Product__c;
                 }
                 if(camo.Contract_Phone2_2__c !=null)
                 {
                newCamRetail.Contract_Phone2_2__c = camo.Contract_Phone2_2__c;
                 }
                 if(camo.Contract_Status__c !=null)
                 {
                  newCamRetail.Contract_Status__c = camo.Contract_Status__c;
                 }
                  if(camo.Finance_Address__c !=null)
                 {
                  newCamRetail.Finance_Address__c = camo.Finance_Address__c;
                 }
                 if(camo.Payment_Start_Date__c!=null)
                 {
                  newCamRetail.Payment_Start_Date__c= camo.Payment_Start_Date__c;
                 }
                 if(camo.Payment_End_Date__c!=null)
                 {
                  newCamRetail.Payment_End_Date__c= camo.Payment_End_Date__c;
                 }
                 if(camo.Gaurantor_1_Name__c !=null)
                 {
                  newCamRetail.Gaurantor_1_Name__c= camo.Gaurantor_1_Name__c;
                 }
                if(camo.Finance_Vehicle__c!=null)
                 {
                  newCamRetail.Finance_Vehicle__c= camo.Finance_Vehicle__c;
                 }
                 if(camo.Gaurantor2_Name__c !=null)
                 {
                  newCamRetail.Gaurantor2_Name__c= camo.Gaurantor2_Name__c;
                 }
                 if(camo.Mileage__c !=null)
                 {
                  newCamRetail.Mileage__c= camo.Mileage__c;
                 }
                 if(camo.Gaurantor3_Name__c !=null)
                 {
                  newCamRetail.Gaurantor3_Name__c= camo.Gaurantor3_Name__c;
                 }
                 if(camo.No_of_Payments__c !=null)
                 {
                  newCamRetail.No_of_Payments__c= camo.No_of_Payments__c;
                 }
                 if(camo.Fine_Rate__c !=null)
                 {
                  newCamRetail.Fine_Rate__c= camo.Fine_Rate__c;
                 }
                  if(camo.Monthly_Payment_amount__c!=null)
                 {
                  newCamRetail.Monthly_Payment_amount__c= camo.Monthly_Payment_amount__c;
                 }
                 if(camo.Interest_Rate__c!=null)
                 {
                  newCamRetail.Interest_Rate__c= camo.Interest_Rate__c;
                 }
                 if(camo.Bonus_Month1__c !=null)
                 {
                  newCamRetail.Bonus_Month1__c= camo.Bonus_Month1__c;
                 }
                if(camo.Bonus_Amount1__c!=null)
                 {
                  newCamRetail.Bonus_Amount1__c= camo.Bonus_Amount1__c;
                 }
                 if(camo.Bonus_Month2__c !=null)
                 {
                  newCamRetail.Bonus_Month2__c= camo.Bonus_Month2__c;
                 }
                 if(camo.Bonus_Amount2__c !=null)
                 {
                  newCamRetail.Bonus_Amount2__c= camo.Bonus_Amount2__c;
                 }
                 if(camo.Lease_Loan_Flag__c !=null)
                 {
                  newCamRetail.Lease_Loan_Flag__c= camo.Lease_Loan_Flag__c;
                 }
                 if(camo.Indemnity_Amount__c !=null)
                 {
                  newCamRetail.Indemnity_Amount__c= camo.Indemnity_Amount__c;
                 }
                 if(camo.Deferred_Payment_loan__c !=null)
                 {
                  newCamRetail.Deferred_Payment_loan__c= camo.Deferred_Payment_loan__c;
                 }
                  if(camo.Contract_Start_date_Lease__c!=null)
                 {
                  newCamRetail.Contract_Start_date_Lease__c= camo.Contract_Start_date_Lease__c;
                 }
                 if(camo.Shinpan__c!=null)
                 {
                  newCamRetail.Shinpan__c= camo.Shinpan__c;
                 }
                 if(camo.Contract_End_date_Lease__c !=null)
                 {
                  newCamRetail.Contract_End_date_Lease__c= camo.Contract_End_date_Lease__c;
                 }
                if(camo.Delinquency_Flag__c!=null)
                 {
                  newCamRetail.Delinquency_Flag__c= camo.Delinquency_Flag__c;
                 }
                 if(camo.MBF_Anti_Social_flag__c !=null)
                 {
                  newCamRetail.MBF_Anti_Social_flag__c= camo.MBF_Anti_Social_flag__c;
                 }
                 if(camo.Re_Lease_Extension_Date__c !=null)
                 {
                  newCamRetail.Re_Lease_Extension_Date__c= camo.Re_Lease_Extension_Date__c;
                 }
                 if(camo.Special_flag_to_Exclude__c !=null)
                 {
                  newCamRetail.Special_flag_to_Exclude__c= camo.Special_flag_to_Exclude__c;
                 }
                 if(camo.Re_Lease_Prohibit_Flag__c !=null)
                 {
                  newCamRetail.Re_Lease_Prohibit_Flag__c= camo.Re_Lease_Prohibit_Flag__c;
                 }
                 if(camo.Special_Flag_to_Include__c !=null)
                 {
                  newCamRetail.Special_Flag_to_Include__c= camo.Special_Flag_to_Include__c;
                 }
                 if(camo.Payment_Suspended_Flag__c !=null)
                 {
                  newCamRetail.Payment_Suspended_Flag__c= camo.Payment_Suspended_Flag__c;
                 }
                 if(camo.Offer_Prohibit_Flag__c !=null)
                 {
                  newCamRetail.Offer_Prohibit_Flag__c= camo.Offer_Prohibit_Flag__c;
                 }
                 if(camo.id !=null)
                 {
                 newCamRetail.Whole_Sale_Campaign_Member__c=camo.id;
                 }
                
                                 
                 // retailMem.add(newCamRetail); 
                  retailMem.put(camo.id,newCamRetail);   
     
     }
     }
     //Database.Insert(retailMem.Values(),false);
    // insert retailMem;
    
    if(retailMem.size()>0)
    {
        List<Database.SaveResult> dsrs = Database.Insert(retailMem.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: retailMem.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, retailMem.values());                        
                    }
                    
                }
                index++;
            }
    }
    
        
    
    }
    
    global void finish(Database.BatchableContext BC){
    system.debug('@@@@retCampList@@@@'+retCampid);
     if(!errorMap.isEmpty() || !successlist.isempty())
     {
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
         camprec=[Select id,name from campaign where id=:campid Limit 1];
         String body = 'Your batch job '
             + 'Batch_CampaignmemberInsertion '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Id, Name, Error \n';
            String subject = 'Campaign member Insertion for'+camprec.Name+' - Apex Batch Error List';
            String attName = 'Campaign member Insertion.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                Campaign_Member__c acct = (Campaign_Member__c) IdToSObjectMap.get(id);
                string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
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
            email.setToAddresses( new String[] {'NTT_Daimler_SO_Team@nttdata.com'} );
            email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
 
     }
     system.debug('@@@@retCampLisretCampidst@@@@'+retCampids);
    if(retCampid!=null)
   {
      Batch_RetailCampaignNotification    batcher = new Batch_RetailCampaignNotification(retCampids);
            Database.executeBatch(batcher,1);  
         }
    }

}