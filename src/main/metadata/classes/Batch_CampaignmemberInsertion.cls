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
        return Database.getQueryLocator([Select Id,Name,Cross_point_month_and_year__c,Outstanding_Balance_amount__c,Proto_Market_Value_amount__c,Final_GAP_Amount__c,Evaluation_Result_P1_P2_Blank__c,OptOutContact_Reason__c,Postal_OptOut__c,Email_OptOut__c,Retail_Campaign_Id__c,Missing_Flag__c,Status__c,Preferred_Dealer__c,Contract__c,contact_Id__c,Address__c,Customer_Complete_Address__c,NextInspectionDate__c,NextServiceDate__c,LastInspectionDate__c,LastServiceDate__c,LastWorkDate__c,Service_Advisor__c,Sales_Consultant__c,Vehicle__c,Vehicle_Relationship__c,CUSTOMER_LABEL_NAME__C,Retail_Copy__c,Vehicle_ExternalLink__c From Campaign_Member__c Where Campaign_id__c =: campid ]);
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