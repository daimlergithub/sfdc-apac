/*
    Type:       Utility for Account trigger
    Purpose:    
                
    User Story: US-CP-010 , US-CP-016, US-CP-017
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Bing Bai Created on 2013-06-05
    2. Sinow Update on 2013-07-22 for US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
*/
public class AccountHelper {

    Private static Id dealerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    //Existing Au specific variables
    private static Set<String> newCompanyIds = new Set<String>();
    private static Set<String> personIds = new Set<String>();
    private static final String ONE_SPACE = ' ';
    public static final Set<Id> RECORD_TYPE_SET = new Set<Id>{
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId()
    };

    /**
       US-CP-010 error message
     */
    public static final String ERROR_MSG_CP_010 = Label.Dealer_Has_SR_Code_1;
    
    /**
       US-CP-016 error message
     */
    public static final String ERROR_MSG_CP_016 = Label.Account_Cann_t_be_Customer;
    
    /**
       get record counts from accout which Dealer_Default_Flag__c = true and "Dealer DMS SR Code 1" has a value
       return a Map Key is Dealer_DMS_SR_Code__c , 
       and value is boolean , if had records is false , if no is true
     */
    public static Map<String, boolean> getDealerCountInfo(List<String> dealerCodes){
        Map<String, boolean> cp010Map = new Map<String, boolean>();
        
        for(sObject obj : [select count(id) sumNum,Dealer_DMS_SR_Code__c from Account where RecordTypeId =: dealerRTId And Dealer_Default_Flag__c = true And Dealer_DMS_SR_Code__c in :dealerCodes group by Dealer_DMS_SR_Code__c ]){
            cp010Map.put(String.valueOf(obj.get('Dealer_DMS_SR_Code__c')), obj.get('sumNum')==0 ? true : false);
        }
        
        return cp010Map;
    }
    
    /**
       get record counts from Vehichle relationShip which Contact is current Acount.
       return a Map Key is Contact__c , 
       and value is boolean , if had records is false , if no is true
     */
    public static Set<Id> getVSCountInfo(List<id> ids){
        Set<Id> cp016Map = new Set<Id>();
        
        for(Vehicle_Relationship__c obj : [select Contact__c from Vehicle_Relationship__c where Contact__c in :ids ]){
            cp016Map.add(obj.Contact__c);
        }
        
        return cp016Map;
    }

    
    //US-DP-022, US-DP-023, when Allow Data Sharing changed to yes, update lead's owner.
    public static void updateLeads
        (Set<Id> contactIds) {
        List<Lead__c> leads = [select Id, Dealer_LMS__c, RecordTypeId, Need_Assign_To_Dealer__c, Assigned_Dealer__c from Lead__c where Contact__c in :contactIds and Need_Assign_To_Dealer__c = 'Need' and Assigned_Dealer__c != null];
        Set<Id> dealerIds = new Set<Id>();
        for(Lead__c lead : leads) {
            dealerIds.add(lead.Assigned_Dealer__c);
        }
        
        if(leads.size() > 0) {
            LeadHelper.UpdateLeadOwnerFromContact(dealerIds, leads);
        }
    }
    
    //Existing AU related functionality starts from here
     // The following variables are for US-CD-004
    // Flag the primary person account: the lastest inserted contact or updated contact is primary.
    // For the new company with inserting or updating.
    public static void auBefore_Insert_Update_Events(List<Account> listAccounts,map<Id,Account> oldAccountMap, boolean isInsert,boolean isUpdate)
    {
        for(Account acc : listAccounts){
        //US_AU-CD-001 No.7, US_AU-002
        if (RECORD_TYPE_SET.contains(acc.RecordTypeId)){
            acc = updateDisplayName(acc);
            //set field PC & CV Status with defalut value 
            if (isInsert) {
                acc = setDefaultValue(acc);
            }
        }
        
        // US-CD-004 Flag the primary person account.
        if(acc.isPersonAccount && acc.Company__c != null){
            if(!isUpdate || acc.Company__c != oldAccountMap.get(acc.Id).Company__c){
                // Sets the contact to primary and cancels the original contact in this company.
                acc.Primary__pc = true;
                newCompanyIds.add(acc.Company__c);
                if(isUpdate){
                    personIds.add(acc.Id);
                }
            }
        }
        
        // US_AU-CD-001.6 Track the updating history for FS fields.
        if(isUpdate){
            trackUpdatHistoryForFsInfo(acc, oldAccountMap.get(acc.Id));
        }
        //TODO-Commented due to field dependencies...
        // US_AU-DD-002  Copy Postal Address 2 Street Address 
        /*if(acc.Copy_Postal_Address_2_Street_Address__c) {
            acc.Dealer_Street_Address_Address_Line_1__c = acc.Dealer_Postal_Address_Address_Line_1__c;
            acc.Dealer_Street_Address_Address_Line_2__c = acc.Dealer_Postal_Address_Address_Line_2__c;
            acc.Dealer_Street_Address_Post_Code__c = acc.Dealer_Postal_Address_Post_Code__c;
            acc.Dealer_Street_Address_Suburb__c = acc.Dealer_Postal_Address_Suburb__c;
            acc.Dealer_Street_Address_State__c = acc.Dealer_Postal_Address_State__c;
            acc.Dealer_Street_Address_Country__c = acc.Dealer_Postal_Address_Country__c;        
        }*/
    }
    
    // US-CD-004 Flag the primary person account: the lastest inserted contact or updated contact is primary.
    newCompanyIds.remove(null);
    if(!newCompanyIds.isEmpty()){
        cancelPrimaryContact(newCompanyIds, personIds);
    }
    }
    
     //US-CD-001 #7. update field "Display Name"
    public static Account updateDisplayName(Account acc){
        
        if (String.isblank(acc.Partner_Surname__c)) {
            //if no partner information available than <Customer Title> < First Name> <Surname> <Suffix>
            acc.Display_Name__c = 
                (String.isblank(acc.Salutation)?'': acc.Salutation + ONE_SPACE) + 
                (String.isblank(acc.FirstName)?'': acc.FirstName + ONE_SPACE) + 
                (String.isblank(acc.LastName)?'': acc.LastName + ONE_SPACE) + 
                (String.isblank(acc.Suffix__c)?'': acc.Suffix__c);
        }else{
            //if the surname of Customer and Partner is equal then <Title Customer> and <Title Partner> <Surname Customer>
            if (acc.LastName == acc.Partner_Surname__c){
                    string cTitle='';
                    if(!String.isblank(acc.Salutation) && acc.Salutation!='Unknown')
                	   cTitle=acc.Salutation;
                    string pTitle='';
                    if(!String.isblank(acc.Partner_Title__c) && acc.Partner_Title__c!='Unknown')
                		pTitle=acc.Partner_Title__c;
                	if(cTitle!='' && pTitle!='')		
                		acc.Display_Name__c=acc.Salutation+ONE_SPACE+'and'+ONE_SPACE+acc.Partner_Title__c+ONE_SPACE+acc.FirstName+ONE_SPACE+'and'+ONE_SPACE+acc.Partner_First_Name__c+ONE_SPACE+acc.LastName;
                    if(cTitle=='' && pTitle=='')
                    	acc.Display_Name__c=acc.FirstName+ONE_SPACE+'and'+ONE_SPACE+acc.Partner_First_Name__c+ONE_SPACE+acc.LastName;
                    if(cTitle!='' && pTitle=='')
                    	acc.Display_Name__c=acc.Salutation+ONE_SPACE+acc.FirstName+ONE_SPACE+'and'+ONE_SPACE+acc.Partner_First_Name__c+ONE_SPACE+acc.LastName;
                    if(cTitle=='' && pTitle!='')
                    	acc.Display_Name__c=acc.FirstName+ONE_SPACE+'and'+ONE_SPACE+acc.Partner_Title__c+ONE_SPACE+acc.Partner_First_Name__c+ONE_SPACE+acc.LastName; 		
                    
            }else{
               //If the surname is unequal the <Title Customer> <First Name Surname Customer> and <Title Partner> <First Name Surname Partner>
              acc.Display_Name__c =  (String.isblank(acc.Salutation)?'': (acc.Salutation=='Unknown'?'': acc.Salutation) + ONE_SPACE) +   
              					     (String.isblank(acc.FirstName)?'': acc.FirstName + ONE_SPACE) +
              					     (String.isblank(acc.LastName)?'': acc.LastName + ONE_SPACE+'and ') +
              					     (String.isblank(acc.Partner_Title__c)?'': (acc.Partner_Title__c=='Unknown'?'': acc.Partner_Title__c) + ONE_SPACE)+
              					     (String.isblank(acc.Partner_First_Name__c)?'': acc.Partner_First_Name__c + ONE_SPACE) +
              					     (String.isblank(acc.Partner_Surname__c)?'': acc.Partner_Surname__c);
            }
        }
        return acc;
    }
    
     //US-CD-001, US-CD-002 set field default value when object created
    public static Account setDefaultValue(Account acc){
        if (RECORD_TYPE_SET.contains(acc.RecordTypeId)){
            acc.PC_Status__c = 'Prospect';
            acc.CV_Status__c = 'Prospect';
            acc.VAN_Status__c = 'Prospect';
        }
        return acc;
    }
    
    // US_AU-CD-001.6 Track the updating history for FS fields
    public static void trackUpdatHistoryForFsInfo(Account updateAcc, Account oldAcc){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName!= 'IntegrationAPI'){

        if(updateAcc.FS_Opt_In_Email__c != oldAcc.FS_Opt_In_Email__c){
            updateAcc.FS_Email_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Email_Last_Modified_Date__c = System.now();
        }
        //TODO
        /*if(updateAcc.FS_Opt_In_Hardcopy__c != oldAcc.FS_Opt_In_Hardcopy__c){
            updateAcc.FS_Hardcopy_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Hardcopy_Last_Modified_Date__c = System.now();
        }
        if(updateAcc.FS_Opt_In_Phone__c != oldAcc.FS_Opt_In_Phone__c){
            updateAcc.FS_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Phone_Last_Modified_Date__c = System.now();
        }*/
        
        if(updateAcc.FS_Opt_In_SMS__c != oldAcc.FS_Opt_In_SMS__c){
            updateAcc.FS_SMS_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_SMS_Last_Modified_Date__c = System.now();
        }
        if(updateAcc.Opt_In_Email__c != oldAcc.Opt_In_Email__c){
            updateAcc.Email_Last_Modified_By__c = UserInfo.getName();
            updateAcc.Email_Last_Modified_Date__c = System.now();
        }
        //TODO
        /*if(updateAcc.Opt_In_Hardcopy__c != oldAcc.Opt_In_Hardcopy__c){
            updateAcc.Hardcopy_Last_Modified_By__c = UserInfo.getName();
            updateAcc.Hardcopy_Last_Modified_Date__c = System.now();
        }*/
        
        /*if(updateAcc.Opt_In_Phone__c != oldAcc.Opt_In_Phone__c){
            updateAcc.Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.Phone_Last_Modified_Date__c = System.now();
        }*/
        
        if(updateAcc.Opt_In_SMS__c != oldAcc.Opt_In_SMS__c){
            updateAcc.SMS_Last_Modified_By__c = UserInfo.getName();
            updateAcc.SMS_Last_Modified_Date__c = System.now();
        }
	  }
    }
    
    // US_AU-CD-004: cancel the primary contact.
    public static void cancelPrimaryContact(Set<String> newCompanyId, Set<String> personId){
        
        Account[] cancelPrimaryAccounts = [select Primary__pc from Account 
                                           where Company__c in :newCompanyId 
                                           and Primary__pc = true
                                           and Id not in :personId];
        if(cancelPrimaryAccounts.size() > 0){
            for(Account item : cancelPrimaryAccounts){
                item.Primary__pc = false;
            }
            update cancelPrimaryAccounts;
        }
    }
    
    public static void auAfter_Insert_Update_Delete_Events(map<id,Account> accountNewMap,map<id,Account> accountOldMap,list<Account> listNewAccounts,list<Account> listOldAccounts,boolean isInsert,boolean isDelete,boolean isUpdate)
    {
        Set<String> companyIds = new Set<String>();
        Set<Id> dealerIds = new Set<Id>();
        List<AccountContactRole> AccountContactRoles = new List<AccountContactRole>();
        Set<Id> personAccountIds = new Set<Id>();
        Map<Id, Id> personAccountIdcontactId = new Map<Id, Id>();
        AccountContactRole temp;
        
        if(isDelete || isUpdate) {
            for(Account item : listOldAccounts){
                  if(item.isPersonAccount && item.Primary__pc && item.Company__c != null){
                    if(isDelete){
                        companyIds.add(item.Company__c);
                    }
                    if(isUpdate && item.Company__c != accountNewMap.get(item.Id).Company__c){
                        companyIds.add(item.Company__c);
                    }
                }
            }
        }
        
        if(isInsert) {
            for(Account item : listNewAccounts){
                if(item.isPersonAccount && item.Company__c != null){
                    personAccountIds.add(item.Id);
                }
            }
        }
        
        if(!personAccountIds.IsEmpty()) {
            for(Contact con : [select Id, AccountId from Contact where AccountId in :personAccountIds]) {
                personAccountIdcontactId.put(con.AccountId, con.Id);
            }
        }
        
        if(isInsert) {
            for(Account item : listNewAccounts){
                if(item.isPersonAccount && item.Company__c != null && personAccountIdcontactId.containsKey(item.Id)){
                    temp = new AccountContactRole();
                    temp.AccountId = item.Company__c;
                    temp.ContactId = personAccountIdcontactId.get(item.Id);
                    temp.Role = item.Job__c;
                    AccountContactRoles.add(temp);
                }
            }
        }
    
        if(isUpdate){
            String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            for(Account item : listNewAccounts){
                if(item.RecordTypeId == dealerRecordTypeId && !item.Dealer_Active__c && accountOldMap.get(item.Id).Dealer_Active__c) {
                    dealerIds.add(item.Id);
                }
            }
        }
        
        if(!companyIds.IsEmpty()){
            flagPrimaryContact(companyIds);
        }
        
        if(!dealerIds.IsEmpty()){
            deleteDealerLocators(dealerIds);
        }
        
        if(!AccountContactRoles.IsEmpty()) {
            insert AccountContactRoles;
        }
    }
    
     // US_AU-CD-004: flag the primary contact.
    public static void flagPrimaryContact(Set<String> companyIds){
        
        Map<String, Account> primaryContacts = new Map<String, Account>();
        Map<String, List<Account>> contacts = new Map<String, List<Account>>();
        
        for(Account item : [select Primary__pc, Company__c from Account where Company__c in :companyIds order by CreatedDate desc]){
            if(contacts.containsKey(item.Company__c)){
                contacts.get(item.Company__c).add(item);
            }
            else{
                contacts.put(item.Company__c, new List<Account>{item});
            }
        }

        for(String companyId : companyIds){
            List<Account> cons = contacts.get(companyId);
            if(cons != null && cons.size() > 0){
                cons[0].Primary__pc = true;
                primaryContacts.put(cons[0].Id, cons[0]);
            }
        }

        if(!primaryContacts.IsEmpty()){
            update primaryContacts.values();
        }
    }
    
    //Delete Dealer locators   US_AU-DD-004
    public static void deleteDealerLocators(Set<Id> dealerIds) {
      
        try {
          //   CR-000213 start
            List<Dealer_Locator__c> dealerLocators = [select Id from Dealer_Locator__c where Dealer_Name__c in :dealerIds];
            for (Dealer_Locator__c dl : dealerLocators){
                 dl.Inactive__c = true;
            }
            update dealerLocators;
            //TODO: Inactive__c doesn't exist in Retail_Task__c
            /*List<Retail_Task__c> contacts = [select id from Retail_Task__c where Account__c in :dealerIds];
            for (Retail_Task__c con : contacts){
                 con.Inactive__c = true;
            }
            update contacts;*/
            //   CR-000213 end
        }
        catch(Exception ex) {
            trigger.new[0].addError('inactivate Dealer Locator Error, please contact administrator');
        }
    }
    
    //US-CD-001, US-CD-002 Get pc status and cv status by customerIds
    public static Map<id,Account> getCustomerInfos(set<Id> ids){
        //TODO
        return new Map<id,Account>([
               select id,
                       PC_Status__c,
                       CV_Status__c,
                       PC_Tenure__c,
                       CV_Tenure__c,
                       Buy_Cycle__c,
                       CV_No_Brand_Purchases__c,
                       VAN_Status__c,
                       VAN_Tenure__c,
                       VAN_No_Brand_Purchases__c
                from Account
                where Id in :ids]);
    }
    
    //Method to update PC Status,CV Status,VAN Status to customer when address record and vehicle relation is associated to customer
    public static void auAfter_Update_UpdatePc_Status_Values(list<Account> listNewAccounts)
    {
    	Set<Id> vehicleIds = new Set<Id>();
    	Set<Id> vehicleRelationIds = new Set<Id>();
	    Set<Id> customerIds = new Set<Id>();
	    set<id> setAccId= new set<Id>();
	    List<Vehicle_Relationship__c> insertCvrs = new List<Vehicle_Relationship__c>(); 
	    for(Account objAcc : listNewAccounts)
	    {  
	    	if(!UtilConstant.Recursivefire)
	    		customerIds.add(objAcc.Id);
	    }
	    if(customerIds!=null && !customerIds.isEmpty())
	    {
	    	list<Account> lstCustomers=[select id,(select id,Customer__c from Addresses__r),(Select id,Vehicle_ID__c,Contact__c,Vehicle_ID__r.Vehicle_Group__c from Vehicle_Relationships2__r) from Account where id In:customerIds];
	    	if(lstCustomers!=null && !lstCustomers.isEmpty())
	    	{
	    		for(Account objAcc:lstCustomers)
	    		{
	    			if(objAcc.Vehicle_Relationships2__r!=null && !objAcc.Vehicle_Relationships2__r.isEmpty())
	    			{
	    				for(Vehicle_Relationship__c objVR:objAcc.Vehicle_Relationships2__r)
	    				{
	    					if(objAcc.id==objVR.Contact__c){
		    					vehicleRelationIds.add(objVR.Id);
		    					vehicleIds.add(objVR.Vehicle_ID__c);
		    					insertCvrs.add(objVR);
	    					}
	    				}
	    			}
	    			if(objAcc.Addresses__r!=null && !objAcc.Addresses__r.isEmpty())
	    			{
	    				for(Address__c objAddr:objAcc.Addresses__r)
	    				{
    						setAccId.add(objAddr.Customer__c);
	    				}
	    			}
	    		}
	    		
	    		if(insertCvrs!=null && !insertCvrs.isEmpty() && vehicleIds!=null && !vehicleIds.isEmpty()){
	    			updataWhenCreateCVR(vehicleIds, customerIds, insertCvrs,setAccId);

	    		}
	    	}
	    }
    }
    
    //When PA gets a Vehicle-Relationship
    public static void updataWhenCreateCVR(Set<Id> vehicleIds, Set<Id> customerIds, list<Vehicle_Relationship__c> cvrs,set<id> setAccId) {
        Map<id,Account> accounts = new Map<id,Account>();
        Map<String, Map<String,Date>> exsisedRecord = new Map<String, Map<String,Date>>();
        //get pc first date records
        Map<String,Date>  preRecordsPc = getExsitedInfos(customerIds,'PC');
        //get cv first date records 
        Map<String,Date>  preRecordsCv = getExsitedInfos(customerIds,'CV');
        //get cv first date records 
        Map<String,Date>  preRecordsVAN = getExsitedInfos(customerIds,'VAN');
        exsisedRecord.put('PC', preRecordsPc);
        exsisedRecord.put('CV', preRecordsCv);
        exsisedRecord.put('VAN', preRecordsVAN);
        
        Map<id,Account> accs = getCustomerInfos(customerIds);
        Map<id,Vehicle__c> vehichles = getVehichles(vehicleIds);
        for(Vehicle_Relationship__c curCvr : cvrs){
            Account acc = new Account();
            if(accounts.containsKey(curCvr.Contact__c)){
                acc = accounts.get(curCvr.Contact__c);
            }else{
                acc = accs.get(curCvr.Contact__c);
            }
            if(acc!=null &&  vehichles!=null && !vehichles.isEmpty() && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c!=null)
            	acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c, exsisedRecord,(setAccId!= null && !setAccId.isEmpty() && setAccId.contains(acc.id)));
            else if(acc!=null && vehichles!=null && !vehichles.isEmpty() && vehichles.get(curCvr.Vehicle_ID__c).Car_Model__c!=null && vehichles.get(curCvr.Vehicle_ID__c).Car_Model__r.Vehicle_Group__c!=null)
            	acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Car_Model__r.Vehicle_Group__c, exsisedRecord,(setAccId!= null && !setAccId.isEmpty() && setAccId.contains(acc.id)));	
            accounts.put(acc.id,acc);
        }
          if(accounts.values()!=null && !accounts.values().isEmpty())	
          { 
          	UtilConstant.Recursivefire=true;
          	UtilDB.updateSobjects(accounts.values());
          }
    }
    
    //Get vehiches Vehicle_Group__c by vehicle id
    public static Map<id,Vehicle__c> getVehichles(set<Id> ids){
        return new Map<id,Vehicle__c>(
        [select id,
               Vehicle_Group__c,Car_Model__c,Car_Model__r.Vehicle_Group__c
        from Vehicle__c 
        where Id in :ids]);
       
    }
   //get the lastest record
    public static Map<String,Date> getExsitedInfos(Set<Id> customerIds , String vehicleGroup){
        Map<String,Date>  recordsInfo = new Map <String,Date>();
        for (sObject obj:[select Contact__c, min(Purchase_Date__c) Purchase_Date__c from Vehicle_Relationship__c where Vehicle_ID__r.Vehicle_Group__c = :vehicleGroup and Contact__c in :customerIds group by Contact__c]){
            recordsInfo.put(String.valueOf(obj.get('Contact__c')),Date.valueOf(obj.get('Purchase_Date__c')));
        }
        
        return  recordsInfo;
    }
    private static Map<String, List<String>> colsMap = new Map<String,List<String>>
        {'PC'=> new List<String>{'PC_Status__c','Buy_Cycle__c','PC_Tenure__c'},
         'CV'=> new List<String>{'CV_Status__c','CV_No_Brand_Purchases__c','CV_Tenure__c'},
         'VAN'=> new List<String>{'VAN_Status__c','VAN_No_Brand_Purchases__c','VAN_Tenure__c'}
        };
          //update PC CV VAN tenure
    @testVisible private static Account updatePCCVField(Account userInfo ,String vehicleGroup, Map<String ,Map<String,Date>> preRecords,boolean isCustomer){

        if(!String.isblank(vehicleGroup)){
            Map<String,Date> preRecord = preRecords.get(vehicleGroup);

            List<String> cols = colsMap.get(vehicleGroup);
            if(userInfo!=null && cols != null && !cols.isEmpty()){

            if(isCustomer && userInfo.get(cols[0])!=null)
            	userInfo.put(cols[0], 'Customer');
            integer numberofP = 1;
            if(userInfo.get(cols[1])!=null){
                numberofP = integer.valueOf(userInfo.get(cols[1]))+1;
            }
            if(userInfo.get(cols[1])!=null)
            	userInfo.put(cols[1], Decimal.valueOf(numberofP));
            integer tenure = 0;
            if(preRecord.get(userInfo.id) != null){
                tenure = preRecord.get(userInfo.id).monthsBetween(Date.today())/12;
            }
            if(userInfo.get(cols[2])!=null)
            	userInfo.put(cols[2] , Decimal.valueOf(tenure));
            }
        }
        return userInfo;        
    }  
    
    public static void auBeforeUpdateCheckRequiredPhoneFields(List<Account> lstNewAccouts)
    {
    	set<Id> setAAcId= new set<Id>();
    	List<Address__c> lstAddress = new List<Address__c>();
    	for(Account objAcc:lstNewAccouts)
    	{
    		setAAcId.add(objAcc.id);
    	}
    	
    	Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    	
    	if(setAAcId!=null && !setAAcId.isempty() &&  profileName != 'IntegrationAPI')
    	{
    		lstAddress=[Select id, Customer__c from Address__c where Customer__c In:setAAcId];
    		if(lstAddress!=null && !lstAddress.isEmpty())
    		{
	    		for(Account objAcc:lstNewAccouts)
	    		{
	    			for(Address__c objAddr:lstAddress)
	    			{
		    			if(objAcc.Individual_Home_Phone__c==null && objAcc.Phone == null && objAcc.Mobile__c==null && objAcc.Home_Phone_2__c==null
		    			&& objAcc.Work_Phone__c==null && objAcc.Mobile2__c==null && objAcc.Email__c==null && objAcc.Email2__c==null && 
		    			(RECORD_TYPE_SET.contains(objAcc.RecordTypeId)) && objAcc.id==objAddr.Customer__c &&
		    			objAcc.PC_Status__c!=null && objAcc.PC_Status__c.equalsIgnoreCase('Customer') && objAcc.CV_Status__c!=null && objAcc.CV_Status__c.equalsIgnoreCase('Customer') &&
		    			objAcc.VAN_Status__c!=null && objAcc.VAN_Status__c.equalsIgnoreCase('Customer'))
		    			{
		    				objAcc.addError('The record needs to have at least one phone number field filled (Home Phone, Work Phone or Mobile) OR an email address.');
		    			}
	    			}
	    		}
    		}
    	}
    }
    //Existing AU related functionality ends here   
}