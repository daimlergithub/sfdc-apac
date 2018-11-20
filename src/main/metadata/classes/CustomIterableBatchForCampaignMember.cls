/***********************************************************************************
Created By          :    Venky  
Created Date        :    2018.07.31
Company             :    NTT Data,Inc.
Usage               :     Parse CSV file from attachment and create child campaign records.
JIRA NO             :                                                  
Bug JIRA NO         :     

MODIFICATION DETAILS:

1. Modified By      :    
Modifide Date    :    
************************************************************************************/

global class CustomIterableBatchForCampaignMember implements Database.Batchable<sObject> ,Database.stateful{ 
    
    public String CSVFile;
    public id retcampid;
    global Map<Id, String> errorMap=new Map<Id, String>();
    global Map<Id, String> successMap =new  Map<Id, String>();
    global list<Id> successlist=new list<ID>();
    global  Map<Id,Campaign_Member__c> insertCmm=new Map<Id,Campaign_Member__c>();
    global Map<Id, SObject> IdToSObjectMap=new Map<Id, SObject>();
    public string nameFile{get;set;}
    String[] filelines = new String[]{};
    global String[] errors = new String[] {};
    global integer linenumber;
    global integer numb;
    public Blob contentFile{get;set;}
    global  Retail_Campaign__c camprec=new  Retail_Campaign__c();
    //Constructor to hold the uploaded CSV file
    global CustomIterableBatchForCampaignMember(Id retcampid){
     this.retcampid= retcampid;
    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select id, Body,BodyLength,ContentType,Description,IsPrivate,Name,OwnerId,ParentId from Attachment where createddate = today and ParentId=:retcampid]);
     // return null;
    }
    //execute method 
    global void execute(Database.BatchableContext bc,List<Attachment> scope){
     List<Campaign_Member__c> CampignMember= new List<Campaign_Member__c>();
       
        List<Retail_Campaign__c> retcamlist=new list<Retail_Campaign__c>();
        retcamlist=[Select id,Segmentation_Base__c from Retail_Campaign__c where id=:retcampid limit 1];
    try{
    for(Retail_Campaign__c re:retcamlist)
    {
    
    
    for(Attachment at:scope)
    {
    contentFile=at.body;
      //Convert the uploaded file which is in BLOB format into a string
                nameFile =blobToString( contentFile,'ISO-8859-1');
                system.debug('@#@##@@@@@@@@@ nameFile '+nameFile );
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                for (Integer i=1;i<filelines.size();i++)
                {
                    String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                    
                  
                     Campaign_Member__c cm=new Campaign_Member__c();
              if(inputvalues[0] !=null)
                {
               cm.Csv_Parser_Number__c=inputvalues[0];
                }
                if(String.isNotEmpty(inputvalues[1]) || string.isNotBlank(inputvalues[1]))
                { 
                  cm.Contact_Id__c=inputvalues[1];
                }
                
                if(String.isNotEmpty(inputvalues[2]) || string.isNotBlank(inputvalues[2]))
                { 
                 cm.Vehicle__c=inputvalues[2];
                }
                
                if(String.isNotEmpty(inputvalues[3]) || string.isNotBlank(inputvalues[3]))
                { 
                cm.Vehicle_Relationship__c=inputvalues[3];
                }
                if(String.isNotEmpty(inputvalues[4]) || string.isNotBlank(inputvalues[4]))
                {
                cm.Contract__c=inputvalues[4];
                }
              if(  String.isNotEmpty(inputvalues[5]) || string.isNotBlank(inputvalues[5]))
                { 
                 cm.Preferred_Dealer__c=inputvalues[5];
                }
                /*   if(  String.isNotEmpty(inputvalues[6]) || string.isNotBlank(inputvalues[6]))
                { 
                 cm.Status__c=inputvalues[6];
                }*/
               
                    cm.Retail_Campaign_Id__c=re.Id;                                     
                    cm.Status__c='Ready';  
                    cm.Created_By_CSV__c=true;
                     
                 //Adding to list
                CampignMember.add(cm);
                    //insertCmm.put(cm.id,cm);
                }
    }
    }
    if(CampignMember.size()>0)
                {
                  List<Database.SaveResult> dsrs = Database.Insert(CampignMember, false);
                    insertCmm.putAll(CampignMember);
                      system.debug('########insertCmm####---------------->'+insertCmm);
                       system.debug('########insertCmm####---------------->'+insertCmm.size());
                    
                  
                     Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: insertCmm.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, insertCmm.values());                        
                    }
                    
                }
                index++;
            }
            system.debug('########insertCmm####--successlist-------------->'+successlist.size());
                 system.debug('########insertCmm####--successlist-------------->'+successlist);
                  system.debug('########insertCmm####--successlist-------------->'+errorMap);
                   system.debug('########insertCmm####--successlist-------------->'+IdToSObjectMap);
             
                }
   }catch(Exception e){      
       errors.add(e.getMessage());   
       linenumber=e.getLineNumber();      
  }
    
    
       
    }
    
    global void finish(Database.BatchableContext bc){
        
       //  if(!errorMap.isEmpty() || !successlist.isempty())
     //{
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
         camprec=[Select id,name from Retail_Campaign__c where id=:retcampid Limit 1];
         system.debug('########insertCmm####--successlist-------------->'+successlist.size());
         if(retcampid !=null && successlist !=null)
               {
               if(!test.isrunningtest())
                {
             CorrectCampaignMemberDataCSV db=new CorrectCampaignMemberDataCSV(retcampid);
    database.executeBatch(db,1); 
                }
               }
         String body = 'Your batch job '
             + 'Batch_CampaignmemberInsertion '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Column Number,id,Name, Error \n';
            String subject = 'CSV Cm insert for'+camprec.Name+' - Apex Batch Error List';
            String attName = 'Campaign member Insertion.csv';
            
             system.debug('######## errorMap insertCmm####--successlist----finalstr ---------->'+errorMap);                
         system.debug('######## errorMap insertCmm####--successlist----finalstr ---------->'+errorMap.keySet());                
          system.debug('######## IdToSObjectMap insertCmm####--successlist----finalstr ---------->'+IdToSObjectMap);                
        
        if(errorMap.keySet() !=null &&errorMap.size()>=0 && !errorMap.keySet().isempty())
        {
        
       
        
        for(Id id  : errorMap.keySet()){
        
                string err = errorMap.get(id);
              //  Campaign_Member__c acct;
                if(IdToSObjectMap !=null)                
                {
              Campaign_Member__c   acct = (Campaign_Member__c) IdToSObjectMap.get(id);
               
                if(acct !=null){
                string recordString = '"'+acct.Csv_Parser_Number__c+'","'+id+'","'+acct.Name+'","'+err+'"\n';
                finalstr = finalstr +recordString;
                }
                
                 }
            } 
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
                 
               
                
               
 
     //}
    }
     public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }  
}