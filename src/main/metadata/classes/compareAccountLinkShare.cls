/***********************************************************************************
Created By          :    venky    
Created Date        :    05.10.2018
Company             :    NTT Data,Inc.
Usage               :   Check Either Account Link Shared to correct dealer or any other dealers, in case if its shared to other dealers send an email with the list to investigate.
Business Conditions :
*   
JIRA NO             :      

MODIFICATION DETAILS:

1. Modified By      :     
Modifide Date    :   
************************************************************************************/

global class compareAccountLinkShare implements Database.Batchable<sObject> ,Database.stateful { 
    
      public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    Global Set<Id> ExtraShare = new Set<Id>(); 
     Global  List<Account_Link__Share>  DeleteAlkShare=new List<Account_Link__Share>();
     global Database.QueryLocator start(Database.BatchableContext BC){
        String dupnumber=label.Alk_Last_Modified_Date;
         String lastmodalias=label.Alk_Last_Modified_By_Alias;
        Integer dup=Integer.valueOf(dupnumber);
        Date todaydate=system.today();
        Date lastmodifedDupNum=todaydate.adddays(-dup); 
        
        return Database.getQueryLocator([Select id,Market__c,Md__c ,Retail_Delete_Flag__c,fromRole__c,toRole__c,RecordtypeID from  Account_Link__c where (Market__c='JP' OR Md__c='JP') and (recordtypeID=:AccountLink_RetailPersonRecordTypeId OR recordtypeID=:AccountLink_RetailCompanyRecordTypeId) and fromRole__c !=null and toRole__c!=null and (Lastmodifieddate >=:lastmodifedDupNum or LastModifiedBy.alias=:lastmodalias)]); 
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account_Link__c> scope){
        
         List<Account_Link__c>  listalk=new List<Account_Link__c>();
        List<Account_Link__Share>  listalkshare=new List<Account_Link__Share>();
         
        List<Account> dealerAccList=new List<Account>();
        Map<Id,Account_Link__Share> existinggroupid=new Map<Id,Account_Link__Share>();
         Map<Id,Group> GcCodeGroupid=new Map<Id,Group>();
          Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        List<Group> groupList=new  List<Group>();
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        List<Account_Link__Share> InsertSharingRecord = new List<Account_Link__Share>();
        Set<Id> accIdSet = new Set<Id>();
        
        Set<Id> AlkId=new Set<Id>();
        Set<Id> DealerId=new Set<Id>();
        Set<Id> Accid=new Set<Id>();
          
            for(Account_Link__c alk:scope)
        {
            if((alk.Market__c =='JP' || alk.Md__c=='JP') && alk.fromRole__c !=null && alk.toRole__c !=null &&  (alk.RecordTypeId==AccountLink_RetailPersonRecordTypeId || alk.RecordTypeId==AccountLink_RetailCompanyRecordTypeId ))
            {
                AlkId.add(alk.id);
                DealerId.add(alk.fromRole__c);
                Accid.add(alk.toRole__c);
            }
        }
            if(AlkId !=null)
        {
            listalkshare=[SELECT Id,ParentId,RowCause,UserOrGroupId FROM Account_Link__Share where parentid=:AlkId and RowCause='Manual'];
            
            if(listalkshare !=null && listalkshare.size()>0)
            {
                for(Account_Link__Share alkshare:listalkshare)
                {
                    existinggroupid.put(alkshare.UserOrGroupId,alkshare);
                }
            }
        }
          System.debug('-------------->>>>>>>>>>>>>>..'+existinggroupid);
           if(DealerId !=null)
         {
             dealerAccList = [select Id,Market__c,Md__c, Dealer_GC_Code__c from Account where (Market__c='JP' or md__c='JP') and Id =: DealerId AND RecordType.DeveloperName = 'Dealer'];
         
          System.debug('-------------->>>>>>>>>>>>>>..'+dealerAccList );    
            if(dealerAccList !=null)
            {
                
                for(Account accRec : dealerAccList) {
                    if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                        gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                        accIdSet.add(accRec.Id);
                    }
                }         
         }
             
               List<Account> similarGCCodeDealerAccountList = [select Id,Market__c,Md__c,Name, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
         
                                                                    AND RecordtypeId =: Dealer_RecordTypeId and (Market__c='JP' or md__c='JP') ];
          System.debug('-------------->>>>>>>>>>>>>>..'+similarGCCodeDealerAccountList );    
             if(similarGCCodeDealerAccountList !=null)
                {
                     for(Account dealerRec : similarGCCodeDealerAccountList) 
                     {
                          dealerAccNameSet.add(dealerRec.Name);
                    accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
                     }
                   
                    if(dealerAccNameSet !=null)
                    {
                          groupList=[select Id, Name, Type from Group where Name IN: dealerAccNameSet];
                    }
                    if(groupList !=null)
                    {
                        for(Group gp:groupList)
                        {
                            GcCodeGroupid.put(gp.id,gp);
                        }
                        
                       System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+existinggroupid.Keyset());
                       System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+existinggroupid.values());
                        System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+GcCodeGroupid);
                        System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+GcCodeGroupid.keyset());
                        
                  /*  for(ID alkshare:existinggroupid.Keyset())
                   // for(Account_Link__Share  alkshare: existinggroupid.values()) 
                    {
                        if(!GcCodeGroupid.containskey(alkshare))
                        {
                        //System.debug('Inside puku');
                            ExtraShare.add(alkshare);
                        }
                    }*/
                    
                    for(Account_Link__Share  alkshare: existinggroupid.values())
                    {
                    if(!GcCodeGroupid.containskey(alkshare.UserOrGroupId))
                        {
                         ExtraShare.add(alkshare.id);
                        }
                    
                    }
                        
                    }
                    
                    
                }
         }
         System.debug('@@@@@@@@@@@@ ExtraShare  ExtraShare '+ExtraShare);
         
         
          
         
        
    }
    
    global void finish(Database.BatchableContext BC){
    
    if(ExtraShare !=null )
                    {
                        DeleteAlkShare=[SELECT Id,ParentId,RowCause,UserOrGroupId FROM Account_Link__Share where id=:ExtraShare and RowCause='Manual'];
                        AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
                       
                       String body = 'Your batch job '
             + 'compareAccountLinkShare'
             + 'has finished. and' 
             + 'There were '
             +DeleteAlkShare.size() 
             +'have wrong sharing data . Please find the list of account link details in attached.';
             
             String finalstr = 'Account Link Id, User/Group Id, Row Cause\n';
             String subject = ' Account Link Share batch class is executed at'+system.today();
            String attName = 'compareAccountLinkShare.csv';
            
            for(Account_Link__Share  alk:DeleteAlkShare)
            {
             string recordString = '"'+alk.ParentId+'","'+alk.UserOrGroupId+'","'+alk.RowCause+'"\n';
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
          // email.setToAddresses( new String[] {'ayyavari.venkateswarlu@nttdata.com'} );
          email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
                    }
     }

}