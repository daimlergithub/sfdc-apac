/**
* Utility for Trigger on Account for TR(Turkey)
* Author: Hildaa
* Created Date : 2018-02-28


*/

public class AccountHelperTR{
    
    static Profile ProfileMarketing = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    public static String MyProfileName = ProfileMarketing.Name;
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
        AccountHelperBase.updatePrimaryAddressdisplay(listNewAccounts,isUpdate,accountOldMap);
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
            else if(!string.isblank(ac.Work_Phone__c) && ac.Work_Phone__c.startswith(Label.TRPhoneCountryCode) && !codes.contains(ac.Work_Phone__c.substring(3,6)))
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
    public static void errorOnDOCPermissions(list<Account> listNewAccounts){
    String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        for(Account acc: listNewAccounts){
          if(acc.recordtypeId == PersonAccountRecordTypeID ){
            if(!string.isBlank(acc.Email__c) && acc.personal_agreement__c != 'Yes' && !acc.Opt_In_Email__c && MyProfileName != 'Marketing Administrator')
                acc.addError(Label.TRSMS);
            else if((!string.isBlank(acc.Mobile__c) || !string.isBlank(acc.Individual_Home_Phone__c) || !string.isBlank(acc.Work_Phone__c)) && acc.personal_agreement__c != 'Yes' && (!acc.Opt_In_Mobile__c && !acc.Opt_In_SMS__c))
                acc.addError(Label.TRPhone);
            else if (string.isBlank(acc.Mobile__c) && string.isBlank(acc.Email__c))
                acc.addError(Label.Email_Mobile_Mandatory);
            }
        }
    }
    public static void updateAgeRange(list<Account> listNewAccounts){
        AccountHelperBase.updateAgeRange(listNewAccounts);
        for(account acc : listNewAccounts ){
            if(string.isnotblank(acc.Age_Range__c)?acc.Age_Range__c=='Unknown':False)
                acc.Age_Range__c = '0-17';
            
        }
    }
    
    
    
    public static void createUCID(list<Account> TriggerNew,boolean isInsert){
        AccountHelperBase.createUCID(TriggerNew,isInsert);    
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