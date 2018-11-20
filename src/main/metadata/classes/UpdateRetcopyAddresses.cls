global class UpdateRetcopyAddresses implements 
        Database.Batchable<sObject>, Database.Stateful {
      global List<Account_Link__C>RetcopyList = new list<Account_Link__C>();
       
        global Database.QueryLocator start(Database.BatchableContext bc) {
            return Database.getQueryLocator([Select id, Name, RETAIL_ZIPCODE__C, RETAIL_PROVINCE__C, RETAIL_CITY__C, RETAIL_ADDRESS_LINE_1__C, RETAIL_DEALER_COMPANYCODE__C, RETAIL_ADDRESS_LINE_2__C, RETAIL_EMAIL__C, RETAIL_INDIVIDUAL_HOME_PHONE__C, RETAIL_MOBILE__C,RecordType.DeveloperName, RETAIL_WORK_PHONE__C, RETAIL_FAX__C, Retail_Address_Reference__r.ZipCode__c, Retail_Address_Reference__r.Province__c, Retail_Address_Reference__r.CITY__C, Retail_Address_Reference__r.ADDRESS_LINE_1__C,Retail_Address_Reference__r.ADDRESS_LINE_2__C,toRole__r.EMAIL__C , toRole__r.Individual_Home_Phone__c, toRole__r.MOBILE__C, toRole__r.WORK_PHONE__C, toRole__r.FAX from Account_Link__C WHERE RETAIL_DEALER_COMPANYCODE__C != 'GC0002665' AND (RecordType.DeveloperName = 'Retail_Company' OR RecordType.DeveloperName= 'Retail_Person') AND MD__c = 'JP' AND Retail_Address_Reference__c !=null]);
        }
        global void execute(Database.BatchableContext bc, List<Account_link__C> scope){
         
            system.debug('Scope------>'+scope);
            String AccountLinklst = '';
                For (Account_link__C ALK:Scope){
                    if(ALK.Retail_Address_Reference__c != null){
                        ALK.RETAIL_ZIPCODE__C = ALK.Retail_Address_Reference__r.ZipCode__c;
                        ALK.RETAIL_PROVINCE__C = ALK.Retail_Address_Reference__r.PROVINCE__C;
                        ALK.RETAIL_CITY__C = ALK.Retail_Address_Reference__r.CITY__C;
                        ALK.RETAIL_ADDRESS_LINE_1__C = ALK.Retail_Address_Reference__r.ADDRESS_LINE_1__C;
                        ALK.RETAIL_ADDRESS_LINE_2__C = ALK.Retail_Address_Reference__r.ADDRESS_LINE_2__C;
                    }
                    if(ALK.toRole__c != null){
                        ALK.RETAIL_FAX__C = ALK.toRole__r.FAX;
                        System.debug('ALK.RecordType.DeveloperName---->'+ALK.RecordType.DeveloperName);
                        If (ALK.RecordType.DeveloperName== 'Retail_Person'){
                            System.debug('ALK.RETAIL_EMAIL__C ---->'+ALK.RETAIL_EMAIL__C );
                            System.debug('RETAIL_INDIVIDUAL_HOME_PHONE__C ---->'+ALK.RETAIL_INDIVIDUAL_HOME_PHONE__C );
                            System.debug('ALK.RETAIL_MOBILE__C ---->'+ALK.RETAIL_MOBILE__C );
                            System.debug('RETAIL_WORK_PHONE__C ---->'+ALK.RETAIL_WORK_PHONE__C );
                            ALK.RETAIL_EMAIL__C =  ALK.toRole__r.EMAIL__C;
                            ALK.RETAIL_INDIVIDUAL_HOME_PHONE__C = ALK.toRole__r.INDIVIDUAL_HOME_PHONE__C;
                            ALK.RETAIL_MOBILE__C=  ALK.toRole__r.MOBILE__C;
                            ALK.RETAIL_WORK_PHONE__C = ALK.toRole__r.WORK_PHONE__C;
                    }
                        }
                   RetcopyList.add(ALK);
                   system.debug('ListofRetCopies'+ ALK);
                }  
                
                    
                 //update RetcopyList;    
                 List<Database.SaveResult> sverel = Database.Update(RetcopyList,false);
                 String ErrorMsg = '';
                 for(Database.SaveResult res : sverel){  
                 
                     if(!res.isSuccess()){
                        ErrorMsg =    ErrorMsg + res.getErrors()[0].getMessage(); 
                     }               
                    AccountLinklst = AccountLinklst+res.id+',' + ErrorMsg + '\n';                    
                 }
                  
                 Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    Blob csvBlob = Blob.Valueof(AccountLinklst);
                    efa.setFileName('UpdateccountLinklist.csv');
                    efa.setBody(csvBlob);                    
                    
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
            email.setSubject( 'AccountLinks Update' );
            email.setToAddresses( (new String[] {'shiva.sai@nttdata.com','kiran.pedinenikalva@nttdata.com','dasepalle.abhishekh@nttdata.com'} ));
            email.setPlainTextBody( 'Please find the attached list of Account records are updated' );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                    
                }
                
                
                
        
         
         global void finish(Database.BatchableContext BC) 
         {
            
          }
          
        global void execute(SchedulableContext s){
            Database.executeBatch(this);        
        }
        
}
