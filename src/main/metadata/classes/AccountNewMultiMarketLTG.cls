/* Controller for Lightning component AccountNewMultiMarket
 * Handles the ability to allow a user to edit for more than
 * one market. First introduced for ANZ
 */
global with sharing class AccountNewMultiMarketLTG {
    /** Method to fetch Market Specific Address Fields to be displayed **/
    @AuraEnabled
    public static Map<String, List<String>> getFields(String market, String recordType, String componentName) {
        Map<String, List<String>> valresult = new Map<String, List<String>> ();
        try {
            // VERY FUNNY - WHY SUBMIT MARKET PARAMETER WHEN QUWERYING IT HERE?
            // SHoULD at BEST bes a check if user has market permissions
            //User user = [select id, Market__c, ContactId from User where id = :UserInfo.getUserId()];
            //market = user.Market__c;
            AddressSearchValidation valObj = AddressSearchValidationFactory.retrieveFieldSetValidate(market, recordType, componentName);
            valresult = valObj.retrieveFieldSet(null, componentName, recordType, market);
            return valresult;
        } catch(Exception e) {
            system.debug('message 3' + e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            throw auraExceptionObj;
        }
    }
    /** Method to get duplicate Accounts and show on form for Inputs entered **/
    @AuraEnabled
    public static Map<String, List<String>> onLineDedpulication(Account account, Address__c address, String filterName, String market) {
        Map<String, List<String>> valresultAccount = new Map<String, List<String>> ();
        List<sObject> sObjList = new List<sObject> ();
        try {
            sObjList.add(account);
            sObjList.add(address);
            system.debug(address.Country__c);
            String accountRecordType = RecordTypeAccessService.getRecordTypeName('Account', account.recordTypeId);
            AddressSearchValidation valObjAccount = AddressSearchValidationFactory.retrieveFieldSetValidate(market, accountRecordType, filterName);
            valresultAccount = valObjAccount.onLineDeduplication(sObjList, filterName);
        } catch(Exception e) {
            AuraHandledException auraExp = new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;
        }
        return valresultAccount;
    }
    /** Method to validate Inputs entered on the form **/
    @AuraEnabled
    public static Map<String, List<String>> submitForm(Account account, Address__c address, String filterName, String market) {
        Map<String, List<String>> valresultAccount = new Map<String, List<String>> ();
        List<sObject> sObjList = new List<sObject> ();
        try {
            sObjList.add(account);
            sObjList.add(address);
            String accountRecordType = RecordTypeAccessService.getRecordTypeName('Account', account.recordTypeId);
            AddressSearchValidation valObjAccount = AddressSearchValidationFactory.retrieveFieldSetValidate(market, accountRecordType, filterName);
            valresultAccount = valObjAccount.submitForm(sObjList, filterName);
            system.debug(valresultAccount);
        } catch(Exception e) {
            system.debug(e);
            AuraHandledException auraExp = new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;
        }
        return valresultAccount;
    }

    // TODO: START REFACTOR - fold into helper class with user info

    /** Method to fetch market of User **/
    @AuraEnabled
    public static User getUserMarket() {
        User user = new User();
        try {
            user = [select id, Market__c, ContactId from User where id = :UserInfo.getUserId()];
            system.debug(user.contactId);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return user;
    }

    /* Returns additional market permissions */
    @AuraEnabled
    public static String getUserAdditionalMarket() {
        
    	 return 'NZ';
        
    }

    
     @AuraEnabled
    public static String getCheckBoolean() {
        Boolean hasCustomPermission = FeatureManagement.checkPermission('ANZCrossMarket');

		if (hasCustomPermission) {
    	  return 'True';
        }
        else
        {
          return 'False';
        }
    }
    // END REFACTOR

    /** Method to fetch vfHostURL **/
    @AuraEnabled
    public static Map<String,String> getvfHostURL(){
        Map<String,String> urlReturn = new Map<String,String>();
        try{
            String hostURL='';
            String vfPage='';
            String isCommunity='';
            if(Site.getSiteID()!=null){
                isCommunity='true';
                vfHostAddressSearchValidations__c vfHst1 = vfHostAddressSearchValidations__c.getValues('hostURLCommunity');
                hostURL=vfHst1.Value__c;
                vfHostAddressSearchValidations__c vfHst2 = vfHostAddressSearchValidations__c.getValues('vfPageCommunity');
                vfPage=vfHst2.Value__c;
            }else{
                isCommunity='false';
                vfHostAddressSearchValidations__c vfHst3 = vfHostAddressSearchValidations__c.getValues('hostURL');
                hostURL=vfHst3.Value__c;
                vfHostAddressSearchValidations__c vfHst4 = vfHostAddressSearchValidations__c.getValues('vfPage');
                vfPage=vfHst4.Value__c;
            }
            urlReturn.put('hostURL',hostURL);
            urlReturn.put('vfPage',vfPage);
            urlReturn.put('isCommunity',isCommunity);
            urlReturn.put('comName',Site.getBaseURL());
            system.debug(urlReturn);
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return urlReturn;
    }
    /** Method to fetch recordTypeId of the recordType selected **/
    @AuraEnabled
    public static String getRecTypeId(String recordTypeLabel) {
        String recid = '';
        try {
            recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
            return recid;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /** Method to fetch columns for <lightning:DataTable/> **/
    @AuraEnabled
    public static List<LightningDataTableWrapper.DataTableColumns> getDataTableColumns(String strObjectName, String market, String recordType, String componentName) {
        // SAME HERE - MARKET PARAMETER EXISTS
        //User user = [select id, Market__c, ContactId from User where id = :UserInfo.getUserId()];
        //market = user.Market__c;
        List<String> fieldsToDisplay = new List<String> ();
        Factory_Fields__mdt fetchColumns = new Factory_Fields__mdt();
        fetchColumns = [select input_fields__c, buttons__c, table_Columns__c, Data_Table_Actions__c from Factory_Fields__mdt where market__c = :market and Record_Type__c = :recordType and sObject__c = null and Component_Name__c = :componentName];
        if (fetchColumns.table_Columns__c != null) {
            fieldsToDisplay = fetchColumns.table_Columns__c.split(',');
        }
        LightningDataTableWrapper ldt = new LightningDataTableWrapper();
        ldt.strObjectName = strObjectName;
        ldt.columnsToDisplay = fieldsToDisplay;
        ldt.buttonsToDispaly = fetchColumns.Data_Table_Actions__c.split(',');
        LightningDataTableWrapper.DataTableResponse resp = new LightningDataTableWrapper.DataTableResponse();
        try {
            resp = ldt.getSobjectList();
        } catch(Exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            throw auraExceptionObj;
        }
        return resp.lstDataTableColumns;
    }
}