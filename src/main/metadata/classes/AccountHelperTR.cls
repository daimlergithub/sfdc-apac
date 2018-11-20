/**
* Utility for Trigger on Account for TR(Turkey)
* Author: Hildaa
* Created Date : 2018-02-28

*/

public class AccountHelperTR{
    
    static Profile ProfileMarketing = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    public static String MyProfileName = ProfileMarketing.Name;
    public  static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public  static Id Account_PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id Account_CompanyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert){
        AccountHelperBase.updateAccountFieldsBeforeInsert(listNewAccounts,isInsert);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
    
    public static void updateAccountFieldsBeforeInsertInt(list<Account> listNewAccounts,boolean isInsert){
        AccountHelperBase.updateAccountFieldsBeforeInsertInt(listNewAccounts,isInsert);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
    
    
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperBase.updateAccountFieldsBeforeUpdate(listNewAccounts,accountOldMap,isUpdate);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
    
    public static void updateAccountFieldsBeforeIntUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperBase.updateAccountFieldsBeforeIntUpdate(listNewAccounts,accountOldMap,isUpdate);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
    
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate,map<id,Account> accountOldMap){
        Map<String,string> countryMap = new map<string,string>();
         Map<Id,Address__c> addr;
         for(CountryTranslation__mdt cmdt: [select id, Country__c,Country_Translation__c,Market__c from CountryTranslation__mdt where Market__c=:Label.TR])
         {
             countryMap.put(cmdt.Country__c,cmdt.Country_Translation__c);
         }
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            string regexForNullValue ='null';
            string nullValue ='';
            set<id> addressid = new set<id>();                  
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            For(Account a:listNewAccounts){    
                Account OldAcc = accountOldMap.get(a.id);
               if(string.isnotblank(a.Primary_Address_Reference__c) && (a.Primary_Address_Reference__c!=OldAcc.Primary_Address_Reference__c)) addressid.add(a.Primary_Address_Reference__c);
            }
            
            If(addressid.size()>0){   
                addr = new map<id,Address__c>([select Customer__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Sub_District__c,ZipCode__c,Country__c from Address__c where id In : addressid]);            
            }
            For(Account acc:listNewAccounts){      //MT20170913- Added market Descrminator MY
                If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null){              
                    Address__c add = addr.get(acc.Primary_Address_Reference__c);
                    if(addtrmap1.containsKey(add.Province__c)){
                        province = addtrmap1.get(add.Province__c);
                    }
                    //Added for TR Market May 9 2018
                    if(add.Country__c != null && countryMap != null && countryMap.containskey(add.Country__c))
                        acc.Primary_Address_Display__c = add.Address_Line_1__c + ' ' + add.Address_Line_2__c+' '+add.City__c+' '+add.Province__c + ' ' +add.District__c+' '+add.Zipcode__c+' '+countryMap.get(add.Country__c);  
                    else
                        acc.Primary_Address_Display__c = add.Address_Line_1__c + ' ' + add.Address_Line_2__c+' '+add.City__c+' '+add.Province__c + ' ' +add.District__c+' '+add.Zipcode__c+' ' +add.Country__c;  
                   
                    acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);                        
                }
                else if(acc.Primary_Address_Reference__c ==Null){
                    acc.Primary_Address_Display__c ='';
                }
            }     
        }    
    } 
    
    public static void updateOnDoNotCall(list<Account> listNewAccounts){
        AccountHelperBase.updateOnDoNotCall(listNewAccounts);
    }
    
    public static void updateOnPostalOptout(list<Account> listNewAccounts){
        AccountHelperBase.updateOnPostalOptout(listNewAccounts);
    }
    
    public static void updateOnEmailOptout(list<Account> listNewAccounts){
     String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
       for(Account acc: listNewAccounts){
           if(acc.recordtypeId == PersonAccountRecordTypeID ){
            if(acc.PersonHasOptedOutOfEmail){
                if(acc.Opt_In_Email__c){ acc.Opt_In_Email__c = FALSE;}
                if(acc.Opt_In_Email2__c){ acc.Opt_In_Email2__c = FALSE;}
                if(acc.Opt_In_Email3__c){ acc.Opt_In_Email3__c = FALSE;}
                /*if(acc.Market__c == Label.TR)
                  acc.Email__c='';*/
            }
            //added for TR market
            /*if(!acc.Opt_In_Email__c && acc.Market__c == Label.TR){
                acc.Email__c='';
          }*/
        }
       }
    }
    
    //Validate Province and City codes
    public static void validateProvinceCodes(list<Account> listNewAccounts){
        set<string> codes = new set<string>();
        for(PhoneAreaCode__c pc: [select id,name,Country_Code__c,Phone_Area_Code__c from PhoneAreaCode__c where Country_Code__c=:Label.TRPhoneCountryCode])
        {
            codes.add(pc.Phone_Area_Code__c);
        }
        for(account ac :listNewAccounts)
        {
            //system.debug(ac.Individual_Home_Phone__c+';'+ac.Individual_Home_Phone__c.substring(3,6) +' --->');
            if(!string.isblank(ac.Individual_Home_Phone__c) && ac.Individual_Home_Phone__c.startswith(Label.TRPhoneCountryCode) && !codes.contains(ac.Individual_Home_Phone__c.substring(3,6)))
            {   
                ac.addError(Label.Invalid_City_Code);
            }
            /*else if(!string.isblank(ac.Mobile__c) && ac.Mobile__c.startswith(Label.TRPhoneCountryCode) && !codes.contains(ac.Mobile__c.substring(3,3)))
            {   
                ac.addError(Label.Invalid_City_Code);
            }*/
            else if(!string.isblank(ac.Work_Phone__c) && ac.Work_Phone__c.startswith(Label.TRPhoneCountryCode) && !codes.contains(ac.Work_Phone__c.substring(3,6)) && ac.Work_Phone__c.substring(3,4) != '5')
            {   
                ac.addError(Label.Invalid_City_Code);
            }
            else if ((!string.isblank(ac.Individual_Home_Phone__c) && !Pattern.Matches('^\\+[0-9]*$',ac.Individual_Home_Phone__c) && ac.Individual_Home_Phone__c.substring(0,3) != '+90') || 
            (!string.isblank(ac.Mobile__c) && !Pattern.Matches('^\\+[0-9]*$',ac.Mobile__c) && ac.Mobile__c.substring(0,3) != '+90') || 
            (!string.isblank(ac.Work_Phone__c) && !Pattern.Matches('^\\+[0-9]*$',ac.Work_Phone__c) && ac.Work_Phone__c.substring(0,3) != '+90')){
                    ac.addError(Label.NumericContact);
                    
            }
            
        }
        
    }
    
    // Updating sms opt in value when sms opt out checkbox is selected.
    public static void updateOnSMSoptout(list<Account> listNewAccounts){
        
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        for(Account acc: listNewAccounts){
        if(acc.recordtypeId == PersonAccountRecordTypeID ){
            if(acc.SMSOptOut__pc){
                if(acc.Opt_In_SMS__c){ acc.Opt_In_SMS__c = FALSE;}
                /*if(!acc.opt_in_mobile__c){ acc.Mobile__c='';}*/
            }
            /*if(!acc.Opt_In_SMS__c){
                 if(!acc.opt_in_mobile__c){
                     acc.Mobile__c='';
                 }
            }*/
        }
      }
    }
    
    // Ashwin: Updating mobile opt in value when mobile opt out checkbox is selected.
    public static void updateOnPhoneoptout(list<Account> listNewAccounts){
    String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        for(Account acc: listNewAccounts){
          if(acc.recordtypeId == PersonAccountRecordTypeID ){
            /*if(acc.opt_out_phone__c){
                if(acc.opt_in_mobile__c){ acc.opt_in_mobile__c = FALSE;}
                   if(!acc.opt_in_sms__c){
                        acc.Mobile__c='';
                    }
                    acc.Individual_Home_Phone__c='';
                    acc.Work_Phone__c='';
                
            }
             if(!acc.opt_in_mobile__c){
                 if(!acc.opt_in_sms__c){
                        acc.Mobile__c='';
                    }
                    acc.Individual_Home_Phone__c='';
                    acc.Work_Phone__c='';

        }*/
    }
    }
    }
    //Hildaa: Throw error message for DoC permissions MT 41 / 43
    public static void errorOnDOCPermissions(list<Account> listNewAccounts,boolean isUpdate){
    String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
    Boolean EmailOptIn = false, PostalOptIn = false, MobileOptIn = false, SMSOptIn = false;
    set<id> accId = new set<Id>();
    if(isUpdate){
        for(Account a : listNewAccounts){
            accId.add(a.Id);
        }
    }
    system.debug('acc ids '+ accId);
    if(!isUpdate || (isUpdate && userInfo.getUserType() != 'PowerPartner')){
        for(Account_link__c  Acclink : [select id,torole__c,Retail_Email_OptIn__c,Market__c,Retail_Phone_OptIn__c,Retail_Postal_OptIn__c,Retail_SMS_OptIn__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Market__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where toRole__c!=null and Market__c='TR' and torole__r.Id IN :accId AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId) limit 10000])
          {
            if(!EmailOptIn && Acclink.Retail_Email_OptIn__c)
                EmailOptIn = true;
            if(!PostalOptIn && Acclink.Retail_Postal_OptIn__c)
                PostalOptIn = true;
            if(!MobileOptIn && Acclink.Retail_Phone_OptIn__c)
                MobileOptIn = true;
            if(!SMSOptIn && Acclink.Retail_SMS_OptIn__c)
                SMSOptIn = true;
          }
        for(Account acc: listNewAccounts){
          if(acc.recordtypeId == PersonAccountRecordTypeID ){
            if(!string.isBlank(acc.Email__c) && acc.personal_agreement__c != 'Yes' && !acc.Opt_In_Email__c && !EmailOptIn && MyProfileName != 'Marketing Administrator')
                acc.addError(Label.TRSMS);
            else if((!string.isBlank(acc.Mobile__c) || !string.isBlank(acc.Individual_Home_Phone__c) || !string.isBlank(acc.Work_Phone__c)) && acc.personal_agreement__c != 'Yes' && (!acc.Opt_In_Mobile__c && !acc.Opt_In_SMS__c && !MobileOptIn && !SMSOptIn))
                acc.addError(Label.TRPhone);
            else if (!acc.Opt_In_Email__c && !acc.Opt_In_Mobile__c && !acc.opt_in_sms__c && !acc.Postal_Opt_In__c && !EmailOptIn && !PostalOptIn && !MobileOptIn && !SMSOptIn && acc.personal_agreement__c != 'Yes')
                acc.addError(Label.Email_Mobile_Mandatory);
            }
        }
      }
      else if(userInfo.getUserType() == 'PowerPartner' && isUpdate) {
          User usr=[select id,Name,ContactId,contact.AccountId,Profile.UserLicense.Name,Contact.Account.Dealer_ND_Code__c,contact.Account.Dealer_Rollout_Status__c,Market__c from user where Id =: UserInfo.getUserId()];
          Map<Id,Account_link__c> accLinkMap = new map<Id,Account_link__c>();
          for(Account_link__c  Acclink : [select id,torole__c,Retail_Email_OptIn__c,Market__c,Retail_Phone_OptIn__c,Retail_Postal_OptIn__c,Retail_SMS_OptIn__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Market__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where fromRole__c!=null and fromrole__c = :usr.contact.AccountId AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)])
          {
            accLinkMap.put(AccLink.torole__c,AccLink);  
          }
          for(Account acc: listNewAccounts){
          if(acc.recordtypeId == PersonAccountRecordTypeID ){
            if(!string.isBlank(acc.Email__c) && acc.personal_agreement__c != 'Yes' && !acc.Opt_In_Email__c && accLinkMap != null && accLinkMap.containskey(acc.Id) && !accLinkMap.get(acc.Id).Retail_Email_OptIn__c)
                acc.addError(Label.TRSMS);
            else if((!string.isBlank(acc.Mobile__c) || !string.isBlank(acc.Individual_Home_Phone__c) || !string.isBlank(acc.Work_Phone__c)) && acc.personal_agreement__c != 'Yes' && (!acc.Opt_In_Mobile__c && !acc.Opt_In_SMS__c && accLinkMap != null && accLinkMap.containskey(acc.Id) && !accLinkMap.get(acc.Id).Retail_Phone_OptIn__c && !accLinkMap.get(acc.Id).Retail_SMS_OptIn__c))
                acc.addError(Label.TRPhone);
            else if (!acc.Opt_In_Email__c && !acc.Opt_In_Mobile__c && !acc.opt_in_sms__c && !acc.Postal_Opt_In__c && acc.personal_agreement__c != 'Yes' && accLinkMap != null && accLinkMap.containskey(acc.Id) && !accLinkMap.get(acc.Id).Retail_Phone_OptIn__c && !accLinkMap.get(acc.Id).Retail_SMS_OptIn__c && !accLinkMap.get(acc.Id).Retail_Email_OptIn__c && !accLinkMap.get(acc.Id).Retail_Postal_OptIn__c)
                acc.addError(Label.Email_Mobile_Mandatory);
            }
        }
       
      }
    }
    public static void updateAgeRange(list<Account> listNewAccounts){
        updateAgeRangeAllAccounts(listNewAccounts);
        /*for(account acc : listNewAccounts ){
            if(string.isnotblank(acc.Age_Range__c)?acc.Age_Range__c=='Unknown':False)
                acc.Age_Range__c = '0-16';
            
        }*/
    }
     public static void updateAgeRangeAllAccounts(list<Account> listNewAccounts){
        for(Account acc:  listNewAccounts){
            if(acc.PersonBirthdate != NULL){
                Integer ageInt = (Integer.valueOf(System.today().year())-Integer.valueof(acc.PersonBirthdate.year()) );
                acc.Age_Range__c = calculateAgeRange(ageInt); 
            }
        }
    }

    public static String calculateAgeRange(Integer ageInt){
        if(16 <= ageInt && ageInt <= 25){
            return '16-25';   
        }
        else if(26 <= ageInt && ageInt <= 35){
            return '26-35';
        }else if( 36 <= ageInt && ageInt <= 45){
            return '36-45';
        }else if( 46 <= ageInt && ageInt <= 55){
            return '46-55';
        }else if(56 <= ageInt && ageInt <= 65){
            return '56-65';
        }else if( 65 < ageInt){
            return '65+';
        }else {
            return 'Unknown';
        }
    }
    
    
    public static void createUCID(list<Account> TriggerNew,boolean isInsert){
        try{
            CustomLogUtil.CustomLoggingEntry(' Account Helper Class createUCID method '+'TriggerNew= ' + TriggerNew.size());
            boolean accountflag;
            string ucidsequence;            
            integer checksum=0;
            integer i;
            String checksumSet = Label.checkSum;
            integer mod = Math.mod(checksum, checksumSet.length());
            list<Account> accountlist = new list<Account>();
            list<Account> acclist = new list<Account>();
            list<Account_Link__c> acclinklist = new list<Account_Link__c>();
            set<id> AccIds = new set<id>();
            Id accountinkIndividualCustomerExternalLinkId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Individual Customer External Link');
            Id accountinkCompanyCustomerExternalLinkId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Company Customer External Link');
            for(Account acc : TriggerNew){
                 AccIds.add(acc.id);
                 accountlist.add(acc);
            }    
            if(!AccIds.isEmpty() && AccIds != Null){
              
                    for(Account acc : accountlist){
                        Account account = acc;
                        Account_Link__c acclink = new Account_Link__c();
                        acclink.Primary__c = true;
                        acclink.Origin__c = account.Name;
                        acclink.toRole__c = account.Id;
                        acclink.System__c = 'UCID';
                        if(acc.recordtypeId == Account_PersonRecordTypeId)
                            acclink.RecordTypeId = accountinkIndividualCustomerExternalLinkId ;
                        else if(acc.recordtypeId == Account_CompanyRecordTypeId)
                            acclink.RecordTypeId = accountinkCompanyCustomerExternalLinkId ;
                        acclink.Name = account.UCID__c;                        
                        acclinklist.add(acclink);
                    }
                    DMLManagerService.InsertAsSystem(acclinklist);
                }
            }
        catch(DMLException ex){
            CustomLogUtil.DebugException(ex);
        }
        CustomLogUtil.DebugLogInsert();  
    }
    
    public static void createUpdateCDMUCID(string updateType, string MarketDiscriminator, list <account> accountlist){
        AccountHelperBase.createUpdateCDMUCID(updateType,MarketDiscriminator,accountlist);    
    }
    
    public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate){
        AccountHelperBase.CreateRetailCopy(accLst,isInsert,isUpdate);    
    }
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){
        AccountHelperBase.updateRetailCopy(isUpdate,isinsert,isafter,accLst);    
    } 
    
    @future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,String MarketDiscriminator,string serlializedObject){
        AccountHelperBase.entityNotifyUpdate(updateType,sfdcId,MarketDiscriminator,serlializedObject);    
    }
    //Added by Hildaa to update the KVK fields based on Personal Agreement
    public static void UpdateKVKFields(list<Account> accLst){
        for(Account acc : accLst){
               if(acc.Market__c == 'TR' && acc.Personal_Agreement__c != 'Yes' && acc.status__c != 'Customer') {
                    if(
                    acc.Gender__c != null ||
                    acc.PersonBirthdate != null||
                    acc.Hobby__c != null||
                    (acc.Marital_Status__c != 'Unknown' &&
		    acc.Marital_Status__c != null) ||
                    acc.Age_Range__c != null||
                    acc.Gov_Background__c != false||
                    acc.Contact_Background__c != null||
                    acc.Education__c != null||
                    acc.Behavioural_Group__c != null||
                    acc.Allmakes_Offered_Service__c != null||
                    acc.Newspaper__c != null||
                    acc.job__c != null||
                    acc.Alliance_Offered_Service__c != null||
                    acc.Agreement_to_commit_info_processing__c != null||
                    acc.Fuso_Offered_Service__c != null||
                    acc.Working_Status__c != null||
                    acc.Occupation_TR__c != null||
                    acc.Industry__c != null||
                    acc.Vacation_Preference__c != null||
                    acc.Average_car_usage_period__c != null)
                        acc.addError(Label.PersonalInfo);
                
                }
                        
            }
    }
    
    //Added by Ashwin to update the contact and address opt in fields depending on email,mobile and address.
   /* public static void updateOptInFields(list<Account> accLst){
        for(Account acc : accLst){
            if(acc.Market__c == 'TR' && acc.Email__c != null && acc.Email__c != '' && acc.Opt_In_Email__c ==false) {
                acc.Opt_In_Email__c = true;
            }
            
            if(acc.Market__c == 'TR' && acc.Mobile__c != null && acc.Mobile__c != '' && acc.Opt_In_SMS__c ==false) {
                acc.Opt_In_SMS__c = true;
            }
            
            if(acc.Market__c == 'TR' && acc.Mobile__c != null && acc.Mobile__c != '' && acc.Opt_In_Mobile__c ==false) {
                acc.Opt_In_Mobile__c = true;
            }
        }
    }*/
    //Made changes on May 8 2018
    //Added by Veena for Social ID and VAT number validation after edit
    public static boolean validateSocialIdTR(Account acc,String val) {
        list<Account> accountlist = new list<Account>();
        boolean flag=false;
        Integer x1 = 0, x2 = 0, x3 = 0, x4 = 0, x5 = 0, x6 = 0, x7 = 0, x8 = 0, x9 = 0, x10 = 0, x11 = 0;
        If( acc != Null){
            String socId;
            if(val =='SocId')
                socId = String.valueof(acc.social_id__c);
            else
                socId = String.valueof(acc.vat_no__c);
                if (socId != null && socId != '' && string.valueof(socId).length() == 11 && string.valueof(socId).isNumeric()) {
                    x1 = Integer.valueOf(socId.mid(0, 1));
                    x2 = Integer.valueOf(socId.mid(1, 1));
                    x3 = Integer.valueOf(socId.mid(2, 1));
                    x4 = Integer.valueOf(socId.mid(3, 1));
                    x5 = Integer.valueOf(socId.mid(4, 1));
                    x6 = Integer.valueOf(socId.mid(5, 1));
                    x7 = Integer.valueOf(socId.mid(6, 1));
                    x8 = Integer.valueOf(socId.mid(7, 1));
                    x9 = Integer.valueOf(socId.mid(8, 1));
                    x10 = Integer.valueOf(socId.mid(9, 1));
                    x11 = Integer.valueOf(socId.mid(10, 1));
                    Integer temp1 = ((x1 + x3 + x5 + x7 + x9) * 7) - (x2 + x4 + x6 + x8);
                    Integer temp2 = math.mod(temp1, 10);
                    Integer temp3 = (x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10);
                    Integer temp4 = math.mod(temp3, 10);
                    if (x10 == temp2 && x11 == temp4) {
                       // accountlist.add(acc);
                        flag= true;
                    } 
                    else 
                        flag= false;
                }else
                flag= false;
                          
            
        }
       /* if(accountlist.size()>0){
            DMLManagerService.updateAsSystem(accountlist);
        }*/
        return flag;
    }
    
    public static void updateUcidRetailCopy(List<Account> accs)
    {
        Map<id,String> accId = new Map<Id,String>();
        list<Account_link__c> accLinktoUpdate = new list<Account_Link__c>();
        for(account ac :accs)
        {
            if(ac.UCID__c != null && ac.UCID__c != '')
                accId.put(ac.Id,ac.UCID__c);
        }
        for(Account_link__c aclink : [select id,torole__c,retail_ucid__c from account_link__c where torole__c in :accId.keyset() and createdby.Alias =: Label.FormAssembly])
        {
            if(aclink.retail_ucid__c == null && accId.get(aclink.torole__c) != null){
                aclink.retail_ucid__c = accId.get(aclink.torole__c);
                accLinktoUpdate.add(aclink);
            }
        }
        system.debug('to update ----> '+accLinktoUpdate);
        if(!accLinktoUpdate.isEmpty())
            update accLinktoUpdate;
    }
    
    //VAT No Validation for Turkey Market
    Public static boolean validateVATNoTR(Account acc) {
        Integer x1 = 0, x2 = 0, x3 = 0, x4 = 0, x5 = 0, x6 = 0, x7 = 0, x8 = 0, x9 = 0;
        Integer x11 = 0, x22 = 0, x33 = 0, x44 = 0, x55 = 0, x66 = 0, x77 = 0, x88 = 0, x99 = 0,V_Last_Digit = 0, toplam = 0;
        String socId = String.valueof(acc.Vat_No__c);
        if (acc.Vat_No__c != null && socId != '' && string.valueof(acc.Vat_No__c).length() == 10 && string.valueof(acc.Vat_No__c).isNumeric()) {
            x1 = Math.Mod((Integer.valueOf(socId.mid(0, 1))+9),10);
            x2 = Math.Mod((Integer.valueOf(socId.mid(1, 1))+8),10);
            x3 = Math.Mod((Integer.valueOf(socId.mid(2, 1))+7),10);
            x4 = Math.Mod((Integer.valueOf(socId.mid(3, 1))+6),10);
            x5 = Math.Mod((Integer.valueOf(socId.mid(4, 1))+5),10);
            x6 = Math.Mod((Integer.valueOf(socId.mid(5, 1))+4),10);
            x7 = Math.Mod((Integer.valueOf(socId.mid(6, 1))+3),10);
            x8 = Math.Mod((Integer.valueOf(socId.mid(7, 1))+2),10);
            x9 = Math.Mod((Integer.valueOf(socId.mid(8, 1))+1),10);
            V_Last_Digit = Integer.valueOf(socId.mid(9, 1));
            x11 = Math.Mod((x1*512),9);
            x22 = Math.Mod((x2*256),9);
            x33 = Math.Mod((x3*128),9);
            x44 = Math.Mod((x4*64),9);
            x55 = Math.Mod((x5*32),9);
            x66 = Math.Mod((x6*16),9);
            x77 = Math.Mod((x7*8),9);
            x88 = Math.Mod((x8*4),9);
            x99 = Math.Mod((x9*2),9);
            if(x1 != 0 &&  x11 == 0) x11 = 9;
            if(x2 != 0 &&  x22 == 0) x22 = 9;
            if(x3 != 0 &&  x33 == 0) x33 = 9;
            if(x4 != 0 &&  x44 == 0) x44 = 9;
            if(x5 != 0 &&  x55 == 0) x55 = 9;
            if(x6 != 0 &&  x66 == 0) x66 = 9;
            if(x7 != 0 &&  x77 == 0) x77 = 9;
            if(x8 != 0 &&  x88 == 0) x88 = 9;
            if(x9 != 0 &&  x99 == 0) x99 = 9;
            toplam = x11 + x22 + x33 + x44 + x55 + x66 + x77 + x88 + x99;
            
            if (Math.mod(toplam,10) == 0)  toplam = 0;
            else toplam = (10 - Math.mod(toplam,10));
            if(toplam == V_Last_Digit) 
                return true;
            else 
                return false;
        } else
            return false;
    }
    //end of social id and VAT validation
}