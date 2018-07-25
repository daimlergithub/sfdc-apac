public without sharing class UpdateRTwithWSAccountANZ implements Database.Batchable<sObject>, Database.Stateful 
{
    //Fetch all the Retail account created today for Retail person and Retail company account 
    
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static String AccountFieldList; 
    public static String AccountLinkFieldList; 
    public static String AddressFieldList; 
    String query;
    
    
    SET<ID> faileRecordsOfAccountLink = new SET<ID>();  
    List<ID> successRecordsOfAccountLink = new List<ID>();   
    SET<ID> accountLinkAll = new SET<ID>();
    /*
// Set of Ids for whom email alert is sent.
Set<ID> accountOwnerSetID = new Set<ID>();   
*/
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        
   /*     sObjectMappingUtility varMapUtil = new sObjectMappingUtility('AU', 'Create_RetailCopy');
        List<string> FieldList =  varMapUtil.GenerateQuery('toRole__r', '' );
        AccountFieldList = FieldList[0]; 
        AccountLinkFieldList = FieldList[1]; 
        
        sObjectMappingUtility varMapUtil1 = new sObjectMappingUtility('AU', 'Create_AddressRetailCopy');
        List<string> FieldList1 =  varMapUtil1.GenerateQuery('', '' );
        
        AddressFieldList= FieldList1 [0]; 
        AccountLinkFieldList = AccountLinkFieldList + ',' + FieldList1 [1]; 
        */
        
         map<String,String> mapUtil = new map<String,String>();
        mapUtil.put('sourceLookupReference','toRole__r');
        mapUtil.put('objectToQuery','Account_link__c');
        List<String> additionalFields = New List <String>();
additionalFields.add('RecordtypeId');
additionalFields.add('toRole__r.Md__c');
//Get address related fields 
    sObjectMappingUtility varMapUtil1 = new sObjectMappingUtility('AU', 'Create_AddressRetailCopy');
     map<String,String> MapSourceDest =  varMapUtil1.getFieldMappingList();
    for (String sourceField : MapSourceDest.keyset()) {
           additionalFields.add(MapSourceDest.get(sourceField));
        }
         sObjectMappingUtility varMapUtil = new sObjectMappingUtility('AU', 'Create_RetailCopy');
        string SelectQuery =  varMapUtil.generateSelectedQuery(true,additionalFields, mapUtil,new map<String,String>());
        system.debug('FieldList' + SelectQuery); 
         
        query =  SelectQuery  + ' WHERE ((RecordTypeID  =:alkCompany_RecordTypeId  AND Retail_Full_Name__c = null) OR (RecordTypeID  =: alkPerson_RecordTypeId AND Retail_FirstName__c = null))  AND  Market__c  IN (\'AU\', \'NZ\') AND CreatedDate  >= YESTERDAY';
        
        system.debug('Query string -->' + query );
        return Database.getQueryLocator(query);
    }
    
    //Execute method
    public void execute(Database.BatchableContext BC,List<Account_Link__c> ListAccountLink)
    {
        //Get list of account
        Set<ID> setAccId = new Set<ID>();
        List<Address__c> listAddressToCopy = new List<Address__c>();
        Map<Id,List<Address__c>> mapAccountWiseAddr = new Map<Id,List<Address__c>>();
        List <Account_Link__c > UpdateALNKList = New List<Account_Link__c>();
        
        for(Account_Link__c ALink: ListAccountLink)
        {
            if(ALink.toRole__r.id != null)
            {
                setAccId.add(ALink.toRole__r.id);
            }
        }   
        
        //Fetch address
        if(setAccId.size() > 0 )
        {
            
            List<Address__c> lstAddress = [ select Name,Country__c,CreatedDate,LastModifiedDate,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Address_Type__c,ZipCode__c,State_City__c,Suburb__c,Customer__r.id,Preferred__c from Address__c  where Customer__c =:setAccId AND Preferred__c = true ] ;
            
            for( Address__c Addr : lstAddress )
            {
                if(mapAccountWiseAddr.containsKey(Addr.id))
                {
                    List<Address__c> lstAddr = mapAccountWiseAddr.get(Addr.Customer__r.id);
                    lstAddr.add(Addr);
                }
                else
                {
                    List<Address__c> lstAddr = new List<Address__c>();
                    lstAddr.add(Addr);
                    mapAccountWiseAddr.put(Addr.Customer__r.id,lstAddr);
                }
            }
        }    
        
        
        // For all the Retail copy created fetch the details form account and populate in account link 
        
        for(Account_Link__c AccountLink: ListAccountLink)
        {
            system.debug('wholesale Id-->'+AccountLink.toRole__c);
            
            
            string operationMethod = '';
            
            if (AccountLink.RecordtypeId == alkPerson_RecordTypeId )
            {
                operationMethod = 'Create_RetailCopy_PersonAccount';
            }
            else if (AccountLink.RecordtypeId == alkCompany_RecordTypeId)
            {
                operationMethod = 'Create_RetailCopy_CompanyAccount';
                
            }
            sObjectMappingUtility varMapUtil = new sObjectMappingUtility(AccountLink.toRole__r.Md__c, operationMethod);
            varMapUtil.mapFieldValues(AccountLink.toRole__r, AccountLink);
            
            if(AccountLink.toRole__r.id != null && mapAccountWiseAddr.containsKey(AccountLink.toRole__r.id) )
            {
                List<Address__c> listaddr = mapAccountWiseAddr.get(AccountLink.toRole__r.id);
                for(Address__c SelectedAdd : listaddr)
                {
                    if (SelectedAdd.Preferred__c) // copy preferred address
                    {
                        sObjectMappingUtility varAddrMapUtil = new sObjectMappingUtility(AccountLink.toRole__r.Md__c,'Create_AddressRetailCopy');
                        varAddrMapUtil.mapFieldValues(SelectedAdd, AccountLink);
                        //Override the General mapping 
                        AccountLink.Retail_Address_Line_1__c = ((SelectedAdd.Address_Line_1__c)!=null?SelectedAdd.Address_Line_1__c:'').left(35);
                        AccountLink.Retail_Address_Line_2__c = ((SelectedAdd.Address_Line_2__c)!=null?SelectedAdd.Address_Line_2__c:'').left(35);
                        AccountLink.Retail_Address_Line_3__c = ((SelectedAdd.Address_Line_3__c)!=null?SelectedAdd.Address_Line_3__c:'').left(35);
                        AccountLink.Retail_Address_CreatedDate__c = Date.ValueOf(SelectedAdd.CreatedDate);
                        AccountLink.Retail_Address_LastModifiedDate__c = Date.ValueOf(SelectedAdd.LastModifiedDate);
                    }
                }
            }
            
            //ccreatelist of updated account link list 
            UpdateALNKList.add(AccountLink);
            accountLinkAll.add(AccountLink.Id);
            
        }         
        
        
        // DML statement
        
        Database.SaveResult[] srList = Database.update(UpdateALNKList, false);
        
        
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account Link ID: ' + sr.getId());
                successRecordsOfAccountLink.add(sr.getId());
                
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account Link fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        
        
        
        
    }   
    
    public void finish(Database.BatchableContext BC)
    {
     
        system.debug('inside finish method');
        
        faileRecordsOfAccountLink = accountLinkAll;
        
        faileRecordsOfAccountLink.removeAll(successRecordsOfAccountLink); // Holds the list of failed account List Id 
            
            
        //Get the job details 
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,     JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        //Create attachment for failed list
        String strBody = '';
    if (faileRecordsOfAccountLink != null && faileRecordsOfAccountLink.size() > 0) {
        strBody = '<html><body><table>';

        for (Id FailedId:faileRecordsOfAccountLink) {
            strBody += '<tr><td>ID</td><td>' + FailedId + '</td></tr>';
        }
        strBody += '</table></body></html>';
    }
        
         Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        if (strBody != '') // if attachement body is not null
        {
            attach.setFileName('BatchJobs.xls');
            attach.body = Blob.valueOf(strBody);
        }
        
        //Send mail with attachment 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            
        if (strBody != '') // attach only if attachment is present 
         {   mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); }
        
        mail.setSubject('Retail Account Link Update Batch ' + a.Status + 'for ' + date.today());
        mail.setPlainTextBody('Records processed ' + a.TotalJobItems +
                              ' with '+ a.NumberOfErrors + ' failures.');
        
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } 
        else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
        
    } 
}