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
    public static Id profileId = userinfo.getProfileId();
    public static String profileName = [Select Id,Name from Profile where Id=:profileId].Name;   
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
    try
       {      
         if(listAccounts !=null && !listAccounts.isEmpty())   
        {        
        CustomLogUtil.CustomLoggingEntry('Account helper class auBefore_Insert_Update_Events method = ' +listAccounts.size() );
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
    }
    
    // US-CD-004 Flag the primary person account: the lastest inserted contact or updated contact is primary.
    newCompanyIds.remove(null);
    if(!newCompanyIds.isEmpty()){
        cancelPrimaryContact(newCompanyIds, personIds);
    }
    }
    catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    
     //US-CD-001 #7. update field "Display Name"
    public static Account updateDisplayName(Account acc){
          try
       {
          CustomLogUtil.CustomLoggingEntry('Account Helper Class updateDisplayName Method'+'Account Lastname=' + acc.LastName + 'Account Partner Surname ='+ acc.Partner_Surname__c );
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
        }
         catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
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
    try
       {
         
    //Id profileId = userinfo.getProfileId();
    //String profileName = [Select Id,Name from Profile where Id=:profileId].Name;

   Map<Id, GroupMember> groupMemberMap = new Map<Id, GroupMember>([Select GroupId, UserOrGroupId From GroupMember  Where Group.DeveloperName =: 'MB_Financial_Services' AND UserOrGroupId =: userinfo.getUserID()]);
   System.debug('@@@@ groupMap '+groupMemberMap);
 CustomLogUtil.CustomLoggingEntry('Account Helper Class trackUpdatHistoryForFsInfo Method'+'profileName = ' + profileName + ' groupMember Name = '+ groupMemberMap.size());
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
        
        /************* SHRINIVAS **************/


        if(groupMemberMap!=null && !groupMemberMap.isEmpty())
        {
        
            if(updateAcc.Mobile__c != oldAcc.Mobile__c){
            updateAcc.FS_SMS_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_SMS_Last_Modified_Date__c = System.now();
            }
            
            if(updateAcc.Mobile2__c != oldAcc.Mobile2__c){
            updateAcc.FS_SMS_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_SMS_Last_Modified_Date2__c = System.now();
            }
            if(updateAcc.Individual_Home_Phone__c != oldAcc.Individual_Home_Phone__c){
            updateAcc.FS_Home_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Home_Phone_Last_Modified_Date__c = System.now();
            }
            if(updateAcc.Home_Phone_2__c != oldAcc.Home_Phone_2__c){
            updateAcc.FS_Home_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Home_Phone_Last_Modified_Date2__c = System.now();
            }
             if(updateAcc.Work_Phone__c != oldAcc.Work_Phone__c){
            updateAcc.FS_Work_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Work_Phone_Last_Modified_Date__c = System.now();
            }
             if(updateAcc.Phone != oldAcc.Phone){
            updateAcc.FS_Work_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Work_Phone_Last_Modified_Date2__c = System.now();
            }
            if(updateAcc.Email__c != oldAcc.Email__c){
            updateAcc.FS_Email_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Email_Last_Modified_Date__c = System.now();
            }
            if(updateAcc.Email2__c != oldAcc.Email2__c){
            updateAcc.FS_Email_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Email_Last_Modified_Date2__c = System.now();
            }
        }
       
        else
        {
           if(updateAcc.Mobile__c != oldAcc.Mobile__c){
            updateAcc.SMS_Last_Modified_By__c= UserInfo.getName();
            updateAcc.SMS_Last_Modified_Date__c= System.now();
            }
            
            if(updateAcc.Mobile2__c != oldAcc.Mobile2__c){
            updateAcc.SMS_Last_Modified_By2__c= UserInfo.getName();
            updateAcc.SMS_Last_Modified_Date2__c= System.now();
            }
            if(updateAcc.Individual_Home_Phone__c != oldAcc.Individual_Home_Phone__c){
            updateAcc.Home_Phone_Last_Modified_By__c= UserInfo.getName();
            updateAcc.Home_Phone_Last_Modified_Date__c= System.now();
            }
            if(updateAcc.Home_Phone_2__c != oldAcc.Home_Phone_2__c){
            updateAcc.Home_Phone_Last_Modified_By2__c= UserInfo.getName();
            updateAcc.Home_Phone_Last_Modified_Date2__c= System.now();
            }
             if(updateAcc.Work_Phone__c != oldAcc.Work_Phone__c){
            updateAcc.Work_Phone_Last_Modified_By__c= UserInfo.getName();
            updateAcc.Work_Phone_Last_Modified_Date__c= System.now();
            }
             if(updateAcc.Phone != oldAcc.Phone){
            updateAcc.Work_Phone_Last_Modified_By2__c= UserInfo.getName();
            updateAcc.Work_Phone_Last_Modified_Date2__c= System.now();
            }
            if(updateAcc.Email__c != oldAcc.Email__c){
            updateAcc.Email_Last_Modified_By__c= UserInfo.getName();
            updateAcc.Email_Last_Modified_Date__c= System.now();
            }
            if(updateAcc.Email2__c != oldAcc.Email2__c){
            updateAcc.Email_Last_Modified_By2__c= UserInfo.getName();
            updateAcc.Email_Last_Modified_Date2__c= System.now();
            }
        }
        
        if(updateAcc.FS_Opt_In_SMS2__c != oldAcc.FS_Opt_In_SMS2__c){
            updateAcc.FS_SMS_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_SMS_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.FS_Opt_In_Home_Phone__c != oldAcc.FS_Opt_In_Home_Phone__c){
            updateAcc.FS_Home_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Home_Phone_Last_Modified_Date__c = System.now();
        }
        
        if(updateAcc.FS_Opt_In_Home_Phone2__c != oldAcc.FS_Opt_In_Home_Phone2__c){
            updateAcc.FS_Home_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Home_Phone_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.FS_Opt_In_Work_Phone__c != oldAcc.FS_Opt_In_Work_Phone__c){
            updateAcc.FS_Work_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.FS_Work_Phone_Last_Modified_Date__c = System.now();
        }
        
        if(updateAcc.FS_Opt_In_Work_Phone2__c != oldAcc.FS_Opt_In_Work_Phone2__c){
            updateAcc.FS_Work_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Work_Phone_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.FS_Opt_In_Email2__c != oldAcc.FS_Opt_In_Email2__c){
            updateAcc.FS_Email_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.FS_Email_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.Opt_In_SMS2__c != oldAcc.Opt_In_SMS2__c){
            updateAcc.SMS_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.SMS_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.Opt_In_Home_Phone__c != oldAcc.Opt_In_Home_Phone__c){
            updateAcc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.Home_Phone_Last_Modified_Date__c = System.now();
        }
        
        if(updateAcc.Opt_In_Home_Phone2__c != oldAcc.Opt_In_Home_Phone2__c){
            updateAcc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.Home_Phone_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.Opt_In_Work_Phone__c != oldAcc.Opt_In_Work_Phone__c){
            updateAcc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
            updateAcc.Work_Phone_Last_Modified_Date__c = System.now();
        }
        
        if(updateAcc.Opt_In_Work_Phone2__c != oldAcc.Opt_In_Work_Phone2__c){
            updateAcc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
            updateAcc.Work_Phone_Last_Modified_Date2__c = System.now();
        }
        
        if(updateAcc.Opt_In_Email2__c != oldAcc.Opt_In_Email2__c){
            updateAcc.Email_Last_Modified_By2__c = UserInfo.getName();
           updateAcc.Email_Last_Modified_Date2__c = System.now();
        }
        /************* SHRINIVAS **************/
        
        
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
    catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    
    // US_AU-CD-004: cancel the primary contact.
    public static void cancelPrimaryContact(Set<String> newCompanyId, Set<String> personId){
        try
       {
          
        Account[] cancelPrimaryAccounts = [select Primary__pc from Account 
                                           where Company__c in :newCompanyId 
                                           and Primary__pc = true
                                           and Id not in :personId];
                                           CustomLogUtil.CustomLoggingEntry('Account Helper class cancelPrimaryContact Method '+ ' cancelPrimaryAccounts = '+cancelPrimaryAccounts.size());
        if(cancelPrimaryAccounts.size() > 0){
            for(Account item : cancelPrimaryAccounts){
                item.Primary__pc = false;
            }
            update cancelPrimaryAccounts;
        }
        }  catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    
    public static void auAfter_Insert_Update_Delete_Events(map<id,Account> accountNewMap,map<id,Account> accountOldMap,list<Account> listNewAccounts,list<Account> listOldAccounts,boolean isInsert,boolean isDelete,boolean isUpdate)
    {
    try
       {      
          list<Account> updateContacts = new list<Account>();
        Set<String> companyIds = new Set<String>();
        Set<Id> dealerIds = new Set<Id>();
        List<AccountContactRole> AccountContactRoles = new List<AccountContactRole>();
        Set<Id> personAccountIds = new Set<Id>();
        Map<Id, Id> personAccountIdcontactId = new Map<Id, Id>();
        AccountContactRole temp;
          
        if(isDelete || isUpdate && listOldAccounts!=null && !listOldAccounts.isEmpty()) {        
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
        
        if(isInsert && listNewAccounts!=null && !listNewAccounts.isEmpty()) {
        
            for(Account item : listNewAccounts){
             if(item.isPersonAccount && item.Company__c != null){
                    personAccountIds.add(item.Id);
                }
                
                if(item.isPersonAccount && item.Company__c != null && personAccountIdcontactId.containsKey(item.Id)){
                    temp = new AccountContactRole();
                    temp.AccountId = item.Company__c;
                    temp.ContactId = personAccountIdcontactId.get(item.Id);
                    temp.Role = item.Job__c;
                    AccountContactRoles.add(temp);
                }
            }
        }
        
        if(!personAccountIds.IsEmpty()) {
            for(Contact con : [select Id, AccountId from Contact where AccountId in :personAccountIds]) {
                personAccountIdcontactId.put(con.AccountId, con.Id);
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
         if(isUpdate){
           for (Account acc:accountNewMap.values()){
               if(accountOldMap.get(acc.id).Business_Unit__c!=acc.Business_Unit__c){
                   updateContacts.add(acc);
               }
               
           }
           
        if((updateContacts!=null && !updateContacts.isEmpty()))
        {
        CustomLogUtil.CustomLoggingEntry('Account Helper class auAfter_Insert_Update_Delete_Events Method'+  'listNewAccounts'+ updateContacts.size()); 
        ContactHelper.UpdateBusinessUnit(updateContacts);
        }
       }
        
        }
    
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    
     // US_AU-CD-004: flag the primary contact.
    public static void flagPrimaryContact(Set<String> companyIds){
         try
       {
          
   
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
 CustomLogUtil.CustomLoggingEntry('Account Helper class flagPrimaryContact'+ ' primaryContacts = ' + primaryContacts.size());
        if(!primaryContacts.IsEmpty()){
            update primaryContacts.values();
        }
        }
    
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
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
            CustomLogUtil.CustomLoggingEntry('Account Heler Class deleteDealerLocators Method'+'dealerLocators = ' + dealerLocators.size());
            
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
            CustomLogUtil.DebugException(ex);
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
    Public Static Map<Id, Map<String,Integer>> Vehiclecount {get;set;} 
    Public Static Map<Id, Map<String,Integer>> Vehicletenure {get;set;} 
   //Method to update PC Status,CV Status,VAN Status to customer when address record and vehicle relation is associated to customer
    public static void auAfter_Update_UpdatePc_Status_Values(list<Account> listNewAccounts)
    {
    try
       {
          CustomLogUtil.CustomLoggingEntry('Account Helper Class auAfter_Update_UpdatePc_Status_Values'+'listNewAccounts = ' + listNewAccounts.size());
          System.debug('listNewAccounts => '+listNewAccounts);

        Set<Id> vehicleIds = new Set<Id>();
        Set<Id> vehicleRelationIds = new Set<Id>();
        Set<Id> customerIds = new Set<Id>();
        set<id> setAccId= new set<Id>();
        Map<String,Integer> tempcount = new Map<String,Integer>();
        Map<String,Integer> counttenure = new Map<String,Integer>();       
        List<Vehicle_Relationship__c> insertCvrs = new List<Vehicle_Relationship__c>(); 
        for(Account objAcc : listNewAccounts)
        {  
            if(!UtilConstant.Recursivefire)
                customerIds.add(objAcc.Id);
        }
        System.debug('customerIds => '+customerIds);
        if(customerIds!=null && !customerIds.isEmpty())
        {   
        Vehiclecount=new Map<Id, Map<String,Integer>>();
        Vehicletenure =new Map<Id, Map<String,Integer>>();
            list<Account> lstCustomers=[select id,(select id,Customer__c from Addresses__r),(Select id,Vehicle_ID__c,Car_Relation__c, Purchase_Date__c,Contact__c,Vehicle_ID__r.Car_Model__r.Vehicle_Group__c,Vehicle_ID__r.Vehicle_Group__c from Vehicle_Relationships2__r) from Account where id In:customerIds];
            System.debug('lstCustomers => '+lstCustomers);

            if(lstCustomers!=null && !lstCustomers.isEmpty())
            {   
                for(Account objAcc:lstCustomers)
                {   
                    Integer PcCount=0;Integer CvCount=0;Integer VanCount=0;
                    Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                    List<integer> Vanvalues=new List<integer>(); 
                    integer vanmaxDate;
                    List<integer> PCValues=new List<integer>(); 
                    integer PCmaxDate;
                    List<integer> CVValues=new List<integer>(); 
                    integer CVmaxDate;
                    System.debug('objAcc.Vehicle_Relationships2__r => '+objAcc.Vehicle_Relationships2__r);
                    if(objAcc.Vehicle_Relationships2__r!=null && !objAcc.Vehicle_Relationships2__r.isEmpty())
                    {   
                        for(Vehicle_Relationship__c objVR:objAcc.Vehicle_Relationships2__r)
                        {
                            if(objAcc.id==objVR.Contact__c && objVR.Car_Relation__c =='Owner'){
                                System.debug('objVR.Vehicle_ID__r.Vehicle_Group__c PC=> '+objVR.Vehicle_ID__r.Vehicle_Group__c);
                                if(objVR.Vehicle_ID__r.Vehicle_Group__c == 'PC' || (objVR.Vehicle_ID__r.Vehicle_Group__c ==null && objVR.Vehicle_ID__r.Car_Model__r.Vehicle_Group__c == 'PC')){
                                    PcCount++;
                                    if(objVR.Purchase_Date__c !=null){
                                    PcTenure = objVR.Purchase_Date__c.monthsBetween(Date.today())/12;
                                    PCValues.add(PcTenure);
                                    PCValues.sort();
                                    }
                                   
                                }
                                if(objVR.Vehicle_ID__r.Vehicle_Group__c == 'CV' || (objVR.Vehicle_ID__r.Vehicle_Group__c ==null && objVR.Vehicle_ID__r.Car_Model__r.Vehicle_Group__c == 'CV')){
                                    CvCount++;
                                    if(objVR.Purchase_Date__c !=null){
                                    CvTenure= objVR.Purchase_Date__c.monthsBetween(Date.today())/12;
                                     CVValues.add(CvTenure);
                                     CVValues.sort();
                                    }
                                }
                                
                                if(objVR.Vehicle_ID__r.Vehicle_Group__c == 'Van' || (objVR.Vehicle_ID__r.Vehicle_Group__c ==null && objVR.Vehicle_ID__r.Car_Model__r.Vehicle_Group__c == 'Van')){
                                    VanCount++;
                                    if(objVR.Purchase_Date__c !=null){                                    
                                    VanTenure= objVR.Purchase_Date__c.monthsBetween(Date.today())/12;                                 
                                    Vanvalues.add(VanTenure);
                                    Vanvalues.sort();
                            
                                    }
                                     
                                }
                                System.debug('PCValues=> '+PCValues);
                                vehicleRelationIds.add(objVR.Id);
                                vehicleIds.add(objVR.Vehicle_ID__c);
                                insertCvrs.add(objVR);
                            }
                        }
                                  if(!Vanvalues.isEmpty())
                                  {
                                  vanmaxDate = Vanvalues.get(Vanvalues.size()-1);
                                  }
                                  if(!PCValues.isEmpty())
                                  {
                                  PCmaxDate=PCValues.get(PCValues.size()-1);
                                  }
                                  System.debug('PCmaxDate=> '+PCmaxDate);
                                  if(!CVValues.isEmpty())
                                  {
                                  CVmaxDate=CVValues.get(CVValues.size()-1);
                                 }
                    }
                    if(objAcc.Addresses__r!=null && !objAcc.Addresses__r.isEmpty())
                    {
                        for(Address__c objAddr:objAcc.Addresses__r)
                        {
                            setAccId.add(objAddr.Customer__c);
                        }
                    }
                  tempcount.put('PC',PcCount);

                  if(CvCount !=null && (CvCount > 99 || CvCount < -99))
                  {
                  tempcount.put('CV',99);
                  }
                  else
                  {
                  tempcount.put('CV',CvCount); 
                  }
                  if(VanCount !=null && (VanCount > 99 || VanCount < -99))
                  {
                   tempcount.put('Van',99);
                  }
                  else
                  { 
                  tempcount.put('Van',VanCount);
                  }
                 System.debug('tempcount=> '+tempcount);
                 
                 if(PCmaxDate !=null && (PCmaxDate > 99 || PCmaxDate < -99))
                  {
                  counttenure.put('PC',99);
                  }
                  else
                  {
                  counttenure.put('PC',PCmaxDate);
                  }
                  if(CVmaxDate !=null && (CVmaxDate > 99 || CVmaxDate < -99))
                  {
                  counttenure.put('CV',99);
                  }
                  else
                  {
                  counttenure.put('CV',CVmaxDate);
                  }
                  if(vanmaxDate !=null && (vanmaxDate > 99 || vanmaxDate < -99))
                  {
                  counttenure.put('Van',99);
                  }
                  else
                  {
                  counttenure.put('Van',vanmaxDate);
                  }
                  System.debug('counttenure=> '+counttenure);
                  if(tempcount !=null && !tempcount.isEmpty())
                  {
                  Vehiclecount.put(objAcc.id,tempcount);
                  }
                  System.debug('Vehiclecount=> '+Vehiclecount);
                  if(counttenure!=null && !counttenure.isEmpty())
                  {
                   Vehicletenure.put(objAcc.id,counttenure);
                   }
                   System.debug('Vehicletenure=> '+Vehicletenure);
                }
                
                if(insertCvrs!=null && !insertCvrs.isEmpty() && vehicleIds!=null && !vehicleIds.isEmpty()  && customerIds!=null && !customerIds.isEmpty() && setAccId!=null && !setAccId.isEmpty() && Vehiclecount!=null && !Vehiclecount.isEmpty() && Vehicletenure!=null && !Vehicletenure.isEmpty()){
                    updataWhenCreateCVR(vehicleIds, customerIds, insertCvrs,setAccId,Vehiclecount,Vehicletenure);
                    
                }
            }
        }
        }
    
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
      CustomLogUtil.DebugLogInsert();
    }
    
    
    //When PA gets a Vehicle-Relationship
    public static void updataWhenCreateCVR(Set<Id> vehicleIds, Set<Id> customerIds, list<Vehicle_Relationship__c> cvrs,set<id> setAccId,Map<Id, Map<String,Integer>> tempcount,Map<Id, Map<String,Integer>> tenure) {
         try
       {
          CustomLogUtil.CustomLoggingEntry('Account Helper Class updataWhenCreateCVR Method'+ 'vehicleIds= ' + vehicleIds.size() + 'customerIds= ' + customerIds.size() + 'Vehicle Relationship= ' + cvrs.size() + 'AccId=' + setAccId.size() + 'tempcount=' + tempcount.size()+ 'tenure=' + tenure.size());
      
        Map<id,Account> accounts = new Map<id,Account>();
        Map<String, Map<String,Date>> exsisedRecord = new Map<String, Map<String,Date>>();
        //get pc first date records
        Map<String,Date>  preRecordsPc = getExsitedInfos(customerIds,'PC');
        //get cv first date records 
        Map<String,Date>  preRecordsCv = getExsitedInfos(customerIds,'CV');
        //get cv first date records 
        Map<String,Date>  preRecordsVAN = getExsitedInfos(customerIds,'Van');
        exsisedRecord.put('PC', preRecordsPc);
        exsisedRecord.put('CV', preRecordsCv);
        exsisedRecord.put('Van', preRecordsVAN);
        
        Map<id,Account> accs = getCustomerInfos(customerIds);
        Map<id,Vehicle__c> vehichles = getVehichles(vehicleIds);
        
        System.debug('accs=> '+accs);
        System.debug('vehichles=> '+vehichles);

        System.debug('cvrs=> '+cvrs);
        for(Vehicle_Relationship__c curCvr : cvrs){       
        Account acc = new Account();    
              if(curCvr != null && curCvr.Contact__c != null)
              {
                if(accounts != null && !accounts.isEmpty() && accounts.containsKey(curCvr.Contact__c))
                {
                    acc = accounts.get(curCvr.Contact__c);
                }
                else
                {
                    acc = accs.get(curCvr.Contact__c);
                }
            }
            if(curCvr != null && curCvr.Vehicle_ID__c != null && vehichles != null  && acc!=null && acc.Id!=null) 
            {
            if(vehichles!=null && !vehichles.isEmpty() && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c!=null && tempcount !=null && !tempcount.isEmpty() && tenure!=null && !tenure.isEmpty())
            {
                acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c, exsisedRecord,(setAccId!= null && !setAccId.isEmpty() && setAccId.contains(acc.id)),tempcount,tenure);
            }
            else if(vehichles!=null && !vehichles.isEmpty() && vehichles.get(curCvr.Vehicle_ID__c).Car_Model__c!=null && vehichles.get(curCvr.Vehicle_ID__c).Car_Model__r.Vehicle_Group__c!=null && tempcount !=null && !tempcount.isEmpty() && tenure!=null && !tenure.isEmpty())
            {
                acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Car_Model__r.Vehicle_Group__c, exsisedRecord,(setAccId!= null && !setAccId.isEmpty() && setAccId.contains(acc.id)),tempcount,tenure); 
            } 
            if(acc != null && acc.id != null)
            {
                accounts.put(acc.id,acc); 
            }         
            }           
            
        }
         
          if(accounts.values()!=null && !accounts.values().isEmpty() && System.IsBatch() == false && System.isFuture() == false)   
          { 
            UtilConstant.Recursivefire=true;
            //UtilDB.updateSobjects(accounts.values());
            String JSONString = JSON.serialize(accounts.values());
            updateaccounts(JSONString);
          }
          }
    
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
         
         
    }
    @future
    public static void updateaccounts(String str)
    {
        System.debug('str=> '+str);
        List<Account> webList=(List<Account>)JSON.deserialize(str,List<Account>.class);
        UtilDB.updateSobjects(webList);
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
         'Van'=> new List<String>{'VAN_Status__c','VAN_No_Brand_Purchases__c','VAN_Tenure__c'}
        };
      
          //update PC CV VAN tenure
    @testvisible private static Account updatePCCVField(Account userInfo ,String vehicleGroup, Map<String ,Map<String,Date>> preRecords,boolean isCustomer,Map<Id, Map<String,Integer>> tempcount,Map<Id, Map<String,Integer>> tenureVehicle){    
       try
       {
          CustomLogUtil.CustomLoggingEntry('Account Helper Class updatePCCVField Method'+ 'tempcount=' + tempcount.size()+ 'tenureVehicle=' + tenureVehicle.size());
       
         if(!String.isblank(vehicleGroup) && colsMap != null && colsMap.get(vehicleGroup) != null && preRecords!= null && preRecords.get(vehicleGroup) != null){
            Map<String,Date> preRecord = preRecords.get(vehicleGroup);

            List<String> cols = colsMap.get(vehicleGroup);
            if(userInfo.id!=null && cols != null && !cols.isEmpty()){

            if(isCustomer && userInfo.get(cols[0])!=null)
                userInfo.put(cols[0], 'Customer');
           
           if((cols[1])!=null && tempcount!=null && !tempcount.isEmpty())
                    {
                        if(tempcount.get(userInfo.id)!=null && tempcount.get(userInfo.id).get('PC')!=null )
                        {
                        userInfo.put('Buy_Cycle__c',tempcount.get(userInfo.id).get('PC'));
                        }
                        if(tempcount.get(userInfo.id)!=null && tempcount.get(userInfo.id).get('CV')!=null )
                        {
                        userInfo.put('CV_No_Brand_Purchases__c',tempcount.get(userInfo.id).get('CV'));
                        }
                        if(tempcount.get(userInfo.id)!=null && tempcount.get(userInfo.id).get('Van')!=null )
                        {
                        userInfo.put('VAN_No_Brand_Purchases__c',tempcount.get(userInfo.id).get('Van'));
                        }
                    } 
                    
                    if((cols[2])!=null && tenureVehicle!=null && !tenureVehicle.isEmpty())
                    {
                        if(tenureVehicle.get(userInfo.id)!=null && tenureVehicle.get(userInfo.id).get('PC')!=null)
                        {
                        userInfo.put('PC_Tenure__c',tenureVehicle.get(userInfo.id).get('PC'));
                        }
                        if(tenureVehicle.get(userInfo.id)!=null && tenureVehicle.get(userInfo.id).get('CV')!=null)
                        {
                        userInfo.put('CV_Tenure__c',tenureVehicle.get(userInfo.id).get('CV'));
                        }
                        if(tenureVehicle.get(userInfo.id)!=null && tenureVehicle.get(userInfo.id).get('Van')!=null)
                        {
                        userInfo.put('VAN_Tenure__c',tenureVehicle.get(userInfo.id).get('Van'));
                        }
                    }           
                    
           /* integer tenure = 0;
            if(preRecord.get(userInfo.id) != null){
                tenure = preRecord.get(userInfo.id).monthsBetween(Date.today())/12;
            }
            if(userInfo.get(cols[2])!=null)
                userInfo.put(cols[2] , Decimal.valueOf(tenure)); */

            return userInfo;    
            }
        }
        }
        catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
         return null;       
    }  
    
    public static void auBeforeUpdateCheckRequiredPhoneFields(List<Account> lstNewAccouts)
    {
     try
       {
          CustomLogUtil.CustomLoggingEntry('Account helper class auBeforeUpdateCheckRequiredPhoneFields Method'+'lstNewAccouts= ' + lstNewAccouts.size() );
        set<Id> setAAcId= new set<Id>();
        List<Address__c> lstAddress = new List<Address__c>();
        for(Account objAcc:lstNewAccouts)
        {
            setAAcId.add(objAcc.id);
        }
        
        //Id profileId=userinfo.getProfileId();
        //String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
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
      catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    //SFDCAU-267
    public static void auBeforeInsertUpdateTrimPhoneFileds(List<Account> lstNewAccouts)
    {
    try
       {
         CustomLogUtil.CustomLoggingEntry('Account Helper Class auBeforeInsertUpdateTrimPhoneFileds'+'lstNewAccouts= ' + lstNewAccouts.size());
          
        for(Account objAcc:lstNewAccouts)
        {
            objAcc.Batch_No__c='';
            //Mobile
            if(string.valueof(objAcc.Mobile__c)!=null && string.valueof(objAcc.Mobile__c)!='')
                objAcc.Batch_No__c=trimPhoneNumbersUtil(objAcc.Mobile__c);
            //mobile2
            if(string.valueof(objAcc.Mobile2__c)!=null && string.valueof(objAcc.Mobile2__c)!='')
                objAcc.Batch_No__c+=' '+trimPhoneNumbersUtil(objAcc.Mobile2__c);
            //home hone1    
            if(string.valueof(objAcc.Individual_Home_Phone__c)!=null && string.valueof(objAcc.Individual_Home_Phone__c)!='')
                objAcc.Batch_No__c+=' '+trimPhoneNumbersUtil(objAcc.Individual_Home_Phone__c);
            //home phone2       
            if(string.valueof(objAcc.Home_Phone_2__c)!=null && string.valueof(objAcc.Home_Phone_2__c)!='')
                objAcc.Batch_No__c+=' '+trimPhoneNumbersUtil(objAcc.Home_Phone_2__c);
            //work phone1   
            if(string.valueof(objAcc.Work_Phone__c)!=null && string.valueof(objAcc.Work_Phone__c)!='')
                objAcc.Batch_No__c+=' '+trimPhoneNumbersUtil(objAcc.Work_Phone__c);
            //workphone2    
            if(string.valueof(objAcc.Phone)!=null && string.valueof(objAcc.Phone)!='')
                objAcc.Batch_No__c+=' '+trimPhoneNumbersUtil(objAcc.Phone);
        }
        }
      catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
    }
    
    private static string trimPhoneNumbersUtil(string fieldAPiName)
    {
    try
       {
          CustomLogUtil.CustomLoggingEntry('Account Helper Class trimPhoneNumbersUtil Method '+'fieldAPiName = ' + fieldAPiName);
    
        //Mobile & Landline
        if(string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '').length()==12)
            fieldAPiName='0'+string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '').substring(3,12);
        //1800 number or 1300 number
        if(string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '').length()==10)
            fieldAPiName=string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '');
        //13 number
        if(string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '').length()==6)
            fieldAPiName=string.valueof(fieldAPiName).trim().replaceAll('(\\s+)', '');
            }
      catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
        return fieldAPiName;    
    }
    
    public static void auBeforeInsert_Update_Phonenum_validation(List<Account> lstNewAccouts)
    {
    try
       {
          CustomLogUtil.CustomLoggingEntry(' Account Helper Class auBeforeInsert_Update_Phonenum_validation method '+'lstNewAccouts= ' + lstNewAccouts.size());
    
        //Id profileId = userinfo.getProfileId();
        //String profileName = [Select Id,Name from Profile where Id=:profileId].Name; 
        for(Account objAcc:lstNewAccouts)
        {
            if(profileName != 'IntegrationAPI')
            {
                if (string.valueof(objAcc.Mobile__c) != null && string.valueof(objAcc.Mobile__c)!='')
                {
                    if(!(string.valueof(objAcc.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('+614') || string.valueof(objAcc.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('+615')  ||string.valueof(objAcc.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('04') || string.valueof(objAcc.Mobile__c).trim().replaceAll('(\\s+)', '').startsWith('05')))
                    { objAcc.Mobile__c.addError('Mobile number should begin with any one of these values +614, 04, +615, 05');}
                   
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Mobile__c));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
                
                if (string.valueof(objAcc.Mobile2__c) != null && string.valueof(objAcc.Mobile2__c)!='')
                {
                    if(!(string.valueof(objAcc.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('+614') || string.valueof(objAcc.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('+615')  ||string.valueof(objAcc.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('04') || string.valueof(objAcc.Mobile2__c).trim().replaceAll('(\\s+)', '').startsWith('05')))
                    {    objAcc.addError('Mobile number should begin with any one of these values +614, 04, +615, 05');}
                    
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Mobile2__c));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
                 if (string.valueof(objAcc.Individual_Home_Phone__c) != null && string.valueof(objAcc.Individual_Home_Phone__c)!='')
                {
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Individual_Home_Phone__c));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
                if (string.valueof(objAcc.Home_Phone_2__c) != null && string.valueof(objAcc.Home_Phone_2__c)!='')
                {
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Home_Phone_2__c));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
                if (string.valueof(objAcc.Work_Phone__c) != null && string.valueof(objAcc.Work_Phone__c)!='')
                {
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Work_Phone__c));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
                if (string.valueof(objAcc.Phone) != null && string.valueof(objAcc.Phone)!='')
                {
                      String errorMsg = validatePhoneNumberFields(string.valueof(objAcc.Phone));                         
                           if(errorMsg != null)
                               objAcc.addError(errorMsg);
                }
            }    
        }
        }
      catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
      CustomLogUtil.DebugLogInsert();
    }
    
    public static String ValidatePhoneNumberFields(String PhoneNum)
    {
        if((string.valueof(PhoneNum).startsWith('0') && (string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() > 10 || string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() < 8 ) ))
        {
            return 'Number of digits in Phone Number should be more than 8 or less than 10 if it starts with 0';
        }
       else if(string.valueof(PhoneNum).startsWith('+61') && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 12)
       {
            return 'The phone Number record needs to have only 12 digits if it starts with +61';
       }
       else if((string.valueof(PhoneNum).startsWith('1300') || string.valueof(PhoneNum).startsWith('1800')) && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 10 )
       {
            return 'The The phone Number record needs to have only 10 digits if it starts with 1800 or 1300';
       }
       else if((string.valueof(PhoneNum).startsWith('13') && !string.valueof(PhoneNum).startsWith('1300')) && string.valueof(PhoneNum).trim().replaceAll('(\\s+)', '').length() != 6)
       {
            return 'The Phone Number record needs to have only 6 digits if it starts with 13';
       }
       else 
        return null; 
    }
    
    @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
        string sfdcMarketDiscriminator='AU';
       string orgId=UserInfo.getOrganizationId();
          string sfdcTypeName='Account';
          if(!test.isrunningtest())
          
               UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
               
               System.debug('@@@ orgId'+ orgId +'@@@@@@ sfdcTypeName'+ sfdcTypeName +'@@ updateType'+updateType +'### sfdcId'+sfdcId +'$$$$$$ serlializedObject'+serlializedObject+'@@@@ sfdcMarketDiscriminator'+sfdcMarketDiscriminator);
    }
    //Existing AU related functionality ends here   
}