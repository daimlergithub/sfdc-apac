/**************************************************************************************************************************************************************************** 
* File Name     : RetailCopyInfoDefault
* Description   : This Class is part of the Factory model and is the default class which is executed with out any Market specific logic
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with RetailCopyInfo,RetailCopyInfoFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public virtual class RetailCopyInfoDefault implements RetailCopyInfo{
    Factory_Fields__mdt rec;
    public Factory_Fields__mdt getMetaRec(){return this.rec;}      
    public void setMetaRec (Factory_Fields__mdt fRec){this.rec=fRec;}    
    //Method to retrun the factory fields for Card Table
    public RetailCopyInfoDefinition fetchCardTableFields(String recordId,User user){
        RetailCopyInfoDefinition recDataObj=new RetailCopyInfoDefinition();
        try{        
            if(rec.show_records__c && !user.IsPortalEnabled)
            {          
                if(rec.Output_Fields__c!=null && rec.Output_Fields__c!='')
                {    
                    recDataObj.addList= retrieveAddressList(recordId);
                    recDataObj.apiLabelMap=getFieldMap(rec.Output_Fields__c,rec);
                    recDataObj.showAddRecs=true; 
                }
                else
                {
                    AuraHandledException auraExceptionObj  = new AuraHandledException('Empty fields in MetaDataRecord');
                    auraExceptionObj.setMessage(Label.ErrorCheck_Lightning);
                    throw auraExceptionObj;
                }
            }     
        }catch(exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        return recDataObj; 
    }
    //Method to retrun the factory fields for Data Table
    public LightningDataTableWrapper.DataTableResponse fetchDataTableFields(String recordId,User user){
        LightningDataTableWrapper.DataTableResponse response = new LightningDataTableWrapper.DataTableResponse();
        try{
            system.debug('rec.show_records__c: ' +rec.show_records__c);
            if((rec.show_records__c && user.IsPortalEnabled == false))
            {
                if(rec.Output_Fields__c!=null && rec.Output_Fields__c!='' && rec.Buttons__c!=null && rec.Buttons__c!='' && rec.Display_Fields__c!=null && rec.Display_Fields__c!='')
                {
                    LightningDataTableWrapper ldt=new LightningDataTableWrapper();
                    ldt.strObjectName=rec.sObject__c;
                    ldt.columnsToDisplay=getFieldList(rec.Display_Fields__c);
                    ldt.dataToDisplay=retrieveAddressList(recordId);
                    ldt.buttonsToDispaly= getFieldList(rec.Buttons__c);
                    ldt.fieldsToDisplay=getFieldList(rec.Output_Fields__c);  
                    response=ldt.getSobjectList();  
                }
                else
                {
                    AuraHandledException auraExceptionObj  = new AuraHandledException('Empty fields in MetaDataRecord');
                    auraExceptionObj.setMessage(Label.ErrorCheck_Lightning);
                    throw auraExceptionObj;
                }
            }
            
        }  
        catch(exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        return response;
    }  
    //Method to retrun the Address records to the displayed
    public List<Address__c> retrieveAddressList(String recordId){
        
        List<Address__c> addList  = [SELECT  Name, Address_Type__c, Sub_District__c, ZipCode__c, Province__c, 
                                     Province_Native__c, City__c, City_Native__c, District__c, District_Native__c, Block__c, 
                                     Block_Native__c, Address_Line_1__c, Address_Line_1_Native__c, Address_Line_2__c, 
                                     Address_Line_2_Native__c, Company_Name__c, Company_Name_Native__c, TitleOfHonor__c, 
                                     Status__c, Temp_ZipCode__c, Temp_Address__c,Address_Line_3__c 
                                     FROM Address__c
                                     WHERE Customer__c=: recordId];
        return addList;
        
    }
    public Map<String,String> getFieldMap(String Field,Factory_Fields__mdt rec){
        Map<String,String> apiLabelMap = new Map<String,String>();
        Map<String, String> accFieldLabelMap = UtilLTG.retrieveFieldLables(rec.sObject__c);
        for (String fname :field.split(',') )
        {
            if (!accFieldLabelMap.isEmpty())
            {    
                apiLabelMap.put(fname,accFieldLabelMap.get(fname));
            }
        }
        return apiLabelMap;
    }
    public list<String> getFieldList(String recField){
        list<String> fieldList=new list<String>();
        for (String fname :recField.split(',') )
        {
            fieldList.add(fname);
        }
        return fieldList;
    }
    //Method to create Retail copy record with generic fields
    public String createLinkRecord(Id accountId,Address__c selectedAdd,User user,Id dealerId){
        return createLinkRecordDefaultFields(accountId,selectedAdd,user,dealerId);
    }    
    
    public String createLinkRecordDefaultFields(Id accountId,Address__c selectedAdd,User crrntuser,Id dealerId){
        String errorMsg = 'Success';
        Account retrievepersonAccount = new Account();
        Account retrievedealerAccount = new Account();
        Address__c retrieveSelectedAddress = new Address__c();
        Account_Link__c newAlk;
        Boolean hasContactId;
        List<Account_Link__c> Accountlinklist = new List<Account_Link__c>();
        Contact userContact =  new Contact();
        Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Id alkCompany_RecordTypeId =Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id accCompany_RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        //User loggedInUser=[Select id, Market__c from User where id=:UserInfo.getUserId()];
        try{
            if (accountId!=null){
                retrievepersonAccount = [Select Id, MD__c,market__c, LastModifiedDate,Social_ID__c, Foundation_Date__c, 
                                         ID_Type__c,ID_Number__c,Country__c,createdDate,Special_Care__c, Primary_Phone__c, 
                                         email__c, Salutation__c, Mobile__c,Postal_Opt_In__c, LastName_Native_1__c, 
                                         FirstName_Native_1__c,SMSOptOut__pc, Special_Needs_Class__c, Preferred_Language__c, 
                                         Allow_Data_Sharing2__c, Main_Dealer__c, RecordtypeId, UCID__c, DMS_Customer_ID__c, 
                                         Name, LastName, FirstName, Complaint_Amount__c, Sales_Sanction__c, 
                                         Allow_Data_Sharing__c, PersonMobilePhone, Individual_Home_Phone__c, Work_Phone__c, 
                                         PersonEmail, Fax, Preferred_Contact_Method__c, PersonHasOptedOutOfEmail, 
                                         PersonHasOptedOutOfFax, Primary_Phone_Display__c,Opt_In_Email__c, PersonDoNotCall, 
                                         Postal_Opt_Out__c, Visit_Opt_Out__c, PersonBirthdate, Occupation__c, Job__c, 
                                         Gender__c, industry, Website, Company_Name_Native_1__c, Commercial_Reg_No__c, 
                                         Personal_Agreement__c, Personal_Information_Third_Party_Release__c, 
                                         Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c, Vat_No__c,
                                         Opt_In_SMS__c,Updated_Consent_User__c, First_Consent_User__c,First_Consent_Date__c,
                                         Updated_Consent_Date__c,Company_Name__c,Race__c,Title__c, Retail_Work_Phone__c, Special_Mark_on_Account__c, Opt_In_Mail__c, Opt_In_Phone__c,Opt_In_SMS3__c,ACN__c,MB_Online_Id__c from account  
                                         WHERE id =: accountId];
            }
            if(dealerId!=null){
                retrievedealerAccount = [SELECT id, Main_Dealer__c 
                                         FROM account 
                                         WHERE id =: dealerId limit 1];
            }
            if(selectedAdd!=null && selectedAdd.Id!=null){
                retrieveSelectedAddress = [SELECT  id,Foreign_Nationals__c, createddate, lastmodifieddate, Name, Customer__c, Sub_District__c, Address_Type__c, ZipCode__c, 
                                           Province__c, Province_Native__c, Country__c, City__c, City_Native__c, District__c, District_Native__c, Block__c, 
                                           Block_Native__c, Address_Line_1__c, Address_Line_1_Native__c, Address_Line_2__c, Address_Line_2_Native__c, Company_Name__c, 
                                           Company_Name_Native__c, TitleOfHonor__c, Status__c, Temp_ZipCode__c, Temp_Address__c,Address_Line_3__c 
                                           FROM Address__c 
                                           WHERE id =: selectedAdd.Id Limit 1];
            }
            if(crrntuser!=null){
                if(crrntuser.ContactId != null){
                    User Usr = [SELECT Market__c, contactid, IsPortalEnabled, Id, contact.AccountId 
                                FROM User 
                                WHERE Id =: UserInfo.getUserId() 
                                AND User.Profile.UserLicense.Name = 'Partner Community'];
                    if (Usr.ContactId != null) {
                        userContact = [Select id, AccountId from Contact where id =: usr.ContactId];
                        If(userContact != null) {
                            dealerId = userContact.AccountId;
                        }
                    }
                    hasContactId=true;
                }else if(crrntuser.ContactId == null){
                    if (dealerId == null) {
                        errorMsg = 'SelectDealer';
                        AuraHandledException auraExceptionObj  = new AuraHandledException(Label.Please_Select_Dealer);
                        auraExceptionObj.setMessage(Label.Please_Select_Dealer);
                        throw auraExceptionObj;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Please_Select_Dealer));
                    }
                    hasContactId=false;
                }
                String recordTypeAccListQuery;
                if (retrievepersonAccount.RecordtypeId == accPerson_RecordTypeId) {
                    recordTypeAccListQuery = alkPerson_RecordTypeId;
                }else if(retrievepersonAccount.RecordtypeId == accCompany_RecordTypeId){
                    recordTypeAccListQuery = alkCompany_RecordTypeId;
                }
                if (recordTypeAccListQuery !=null){
                    Accountlinklist = [SELECT id, fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c 
                                       FROM Account_Link__c 
                                       WHERE fromRole__c =: dealerId 
                                       AND toRole__c =: accountId 
                                       AND RecordTypeID =: recordTypeAccListQuery
                                       AND Retail_Delete_Flag__c = false 
                                       AND Retail_Duplicate_Flag__c = false];
                }
                if (Accountlinklist.isempty()) {
                    if (retrievepersonAccount.RecordtypeId == accPerson_RecordTypeId) {
                        newAlk = new Account_Link__c();
                        newAlk.toRole__c = accountId;
                        if(selectedAdd!=null)
                            newAlk.Retail_Address_Reference__c = selectedAdd.Id;
                        newAlk.fromRole__c = dealerId;
                        newAlk.Market__c = retrievepersonAccount.market__c;
                        newAlk.RecordTypeId = alkPerson_RecordTypeId;
                        
                    }else if (retrievepersonAccount.RecordtypeId == accCompany_RecordTypeId) {                                
                        newAlk = new Account_Link__c();
                        newAlk.toRole__c = accountId;
                        if(selectedAdd!=null)
                            newAlk.Retail_Address_Reference__c = selectedAdd.Id;
                        newAlk.fromRole__c = dealerId;
                        newAlk.Market__c = retrievepersonAccount.market__c;
                        newAlk.RecordTypeId = alkCompany_RecordTypeId;
                    }
                    errorMsg=createLinkRecordAdditionalFields(retrievepersonAccount,newAlk,retrieveSelectedAddress,accPerson_RecordTypeId,accCompany_RecordTypeId,hasContactId);
                }else if(!Accountlinklist.isempty()) {
                    errorMsg = 'RetailCopyPresent';
                    AuraHandledException auraExceptionObj  = new AuraHandledException(Label.Retail_copy_is_already_present);
                    auraExceptionObj.setMessage(Label.Retail_copy_is_already_present);
                    throw auraExceptionObj;
                    //return errorMsg;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.Retail_copy_is_already_present));
                }
            }
        }
        catch(Exception e){
            AuraHandledException auraExceptionObj  = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        return errorMsg;
    }
    
    public virtual String createLinkRecordAdditionalFields(Account retrievepersonAccount,Account_Link__c newAlk,Address__c retrieveSelectedAddress,Id accPerson_RecordTypeId,Id accCompany_RecordTypeId,Boolean hasContactId){
        return null; 
    }
    
}