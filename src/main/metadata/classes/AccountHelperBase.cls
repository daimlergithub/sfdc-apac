/**
* Utility for Trigger on Account for all markets based on md
* Author: Mohammed Touseef Ahmed
* Created Date : 2017-01-23
*History:
Author                         Date                    Description
Mohd Touseef(MT20170913)    2017/09/13            //MT20170913- Added market Descrminator MY
Modified by Honey on 17th Oct
*/

public class AccountHelperBase{

    /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields
        when any contact information field(s) are inserted.
    **  Created By: Mohammed Touseef Ahmed
    **  Date: 2017-20-02
    **/
    public static Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    public static Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
    public static Id dealer_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    public static Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');
    public static boolean consentHistoryCodeCalled = true;
    
	
	/*
                //Created By : Mohammed Touseef Ahmed
                //Date: 01/09/2018
                //Description: Create Account Link record in CDM as Retail Copy
            
    */
    public static void DealerCommAccountlinkcreatecdm(list < Account > listNewAccounts, map < id, Account > accountOldMa) {
        Set <Id>userids = new set<Id>();
        Set < Id > accid = new set < Id > ();
        Set < Id > AcclinkId = new set < Id > ();
        List < Account_link__c > Acclink = new List < Account_Link__c > ();
        for(Account acc: listNewAccounts)
        {
            userids.add(acc.createdbyId);
        }
        Map<Id,User> usrmap = new Map<Id,user>([select id, Name, ContactId, contact.AccountId, Profile.UserLicense.Name, Contact.Account.Dealer_ND_Code__c from user where Id =: userids]);
        
        for (Account acc: listNewAccounts) {
            
            if ((acc.Ucid__c != '' || acc.Ucid__c!= null) && accountOldMa.containskey(acc.Id) && (accountOldMa.get(acc.Id).Ucid__c == null || accountOldMa.get(acc.Id).Ucid__c == '')&& usrmap.containskey(acc.createdbyId) && usrmap.get(acc.createdbyId).profile.UserLicense.Name == 'Partner Community')
                {accid.add(acc.Id);}
        }
        if (accid.size() > 0 && !accid.isEmpty())
            Acclink = [select name, Retail_DMS_Customer_ID__c, Retail_UCID__c, toRole__c from Account_link__c where toRole__c in: accid LIMIT 49999];
        if (Acclink.size() > 0 && !Acclink.isEmpty()) {
            for (Account_Link__c all: Acclink) {
                if ((all.Retail_DMS_Customer_ID__c == '' || all.Retail_DMS_Customer_ID__c == null) && (all.Retail_UCID__c == '' || all.Retail_UCID__c == null))
                    AcclinkId.add(all.Id);
            }
        }
        if (TriggerRecursiveCheck.run && AcclinkId.size() > 0) {
            TriggerRecursiveCheck.runOnce();
            CDMInformatica_Services.createAccountLink(AcclinkId, Label.MY, Label.InsertContext);
        }
    } 
	
    public static  String validate(string phonestring,integer num,String fields,integer len,integer digits){
        integer i;
        string phon='';
        for(i=num;i<phonestring.length();i++){
            if(phonestring.substring(i,i+1)=='0'){
                continue;
            }else{
                phon=phonestring.substring(i);
                break;
            }
        }
        //outside for loop
        //after removing zero's if phone size is less than 8 through error 
        if(phon.length()<len){
            return fields+ ' contain only Digits and '+ digits+'  Digits with format +66DDDDDDDD or it can be in the format of DDDDDDDD';
        }
        else if(fields=='Mobile'&&!Pattern.matches('[0-9]{9}',phon)){
            return fields+' Phone contain only Digits and '+ digits+' Digits with format +66DDDDDDDDD or it can be in the format of DDDDDDDDD';
        }
        else if(!Pattern.matches('[0-9]{8}',phon)&&fields!='Mobile'){
            return fields+' Phone contain only Digits and '+ digits+' Digits with format +66DDDDDDDD  or it can be in the format of DDDDDDDD';
        }
        else{
            return '+66'+phon;
        }

    }
    
     //added by Honey for Marketing Cloud
    public static void updateMarketingFields(list<Account> listNewAccounts){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts ){
                 if(Acc.Email__c!= null && acc.recordtypeid==accPerson_RecordTypeId){
                    Acc.PersonEmail = Acc.Email__c;
                }
            }
        }
    }

    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts){
                if(Acc.Mobile__c != Null && Acc.Mobile__c != ''){
                    Acc.SMS_Last_Modified_By__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c = System.now();
                }   
                if(Acc.Mobile2__c!= Null && Acc.Mobile2__c != ''){
                    Acc.SMS_Last_Modified_By2__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Individual_Home_Phone__c!= Null && Acc.Individual_Home_Phone__c != ''){
                    Acc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = System.now();
                }
                if(Acc.Home_Phone_2__c != Null && Acc.Home_Phone_2__c != ''){
                    Acc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Work_Phone__c!= Null && Acc.Work_Phone__c != ''){
                    Acc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c = System.now();
                }
                if(Acc.Phone!= Null && Acc.Phone != ''){
                    Acc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Email__c!= Null && Acc.Email__c != ''){
                    Acc.Email_Last_Modified_By__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date__c = System.now();
                }
                if(Acc.Email2__c!= Null && Acc.Email2__c != ''){
                    Acc.Email_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Email3__c!= Null && Acc.Email3__c != ''){
                    Acc.Email_Last_Modified_By3__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = System.now();
                }
				//Sada 2018/April/17 added as per Defect DF18
                if(Acc.Opt_In_Email__c!= Null ){
                    Acc.Email_Opt_IN_Last_Update_date__c = System.now();
                }
                if(Acc.Opt_In_Phone__c!= Null ){
                    Acc.Phone_Opt_IN_Last_Update_date__c = System.now();
                }
                if(Acc.Opt_In_SMS3__c!= Null ){
                    Acc.SMS_Opt_IN_Last_Update_date__c = System.now();
                }
                if(Acc.Opt_In_Mail__c!= Null){
                    Acc.Mail_Opt_IN_Last_Update_date__c = System.now();
                }
               
              
            }
        }
    }
    
    public static void updateAccountFieldsBeforeInsertInt(list<Account> listNewAccounts,boolean isInsert){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts){
                if(Acc.Mobile__c != Null && Acc.Mobile__c != ''){
                    Acc.SMS_Last_Modified_By__c = string.isnotblank(Acc.SMS_Last_Modified_By__c)?Acc.SMS_Last_Modified_By__c:UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c =Acc.SMS_Last_Modified_Date__c!=null?Acc.SMS_Last_Modified_Date__c:System.now();
                }   
                if(Acc.Mobile2__c!= Null && Acc.Mobile2__c != ''){
                    Acc.SMS_Last_Modified_By2__c = string.isnotblank(Acc.SMS_Last_Modified_By2__c)?Acc.SMS_Last_Modified_By2__c:UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = Acc.SMS_Last_Modified_Date2__c!=null?Acc.SMS_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Individual_Home_Phone__c!= Null && Acc.Individual_Home_Phone__c != ''){
                    Acc.Home_Phone_Last_Modified_By__c = string.isnotblank(Acc.Home_Phone_Last_Modified_By__c)?Acc.Home_Phone_Last_Modified_By__c:UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = Acc.Home_Phone_Last_Modified_Date__c!=null?Acc.Home_Phone_Last_Modified_Date__c:System.now();
                }
                if(Acc.Home_Phone_2__c != Null && Acc.Home_Phone_2__c != ''){
                    Acc.Home_Phone_Last_Modified_By2__c = string.isnotblank(Acc.Home_Phone_Last_Modified_By2__c)?Acc.Home_Phone_Last_Modified_By2__c:UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = Acc.Home_Phone_Last_Modified_Date2__c!=null?Acc.Home_Phone_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Work_Phone__c!= Null && Acc.Work_Phone__c != ''){
                    Acc.Work_Phone_Last_Modified_By__c = string.isnotblank(Acc.Work_Phone_Last_Modified_By__c)?Acc.Work_Phone_Last_Modified_By__c:UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c = Acc.Work_Phone_Last_Modified_Date__c!=null?Acc.Work_Phone_Last_Modified_Date__c:System.now();
                }
                if(Acc.Phone!= Null && Acc.Phone != ''){
                    Acc.Work_Phone_Last_Modified_By2__c = string.isnotblank(Acc.Work_Phone_Last_Modified_By2__c)?Acc.Work_Phone_Last_Modified_By2__c:UserInfo.getName();
                   Acc.Work_Phone_Last_Modified_Date2__c = Acc.Work_Phone_Last_Modified_Date2__c!=null?Acc.Work_Phone_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Email__c!= Null && Acc.Email__c != ''){
                    Acc.Email_Last_Modified_By__c = string.isnotblank(Acc.Email_Last_Modified_By__c)?Acc.Email_Last_Modified_By__c:UserInfo.getName();
                   Acc.Email_Last_Modified_Date__c = Acc.Email_Last_Modified_Date__c!=null?Acc.Email_Last_Modified_Date__c:System.now();
                }
                if(Acc.Email2__c!= Null && Acc.Email2__c != ''){
                    Acc.Email_Last_Modified_By2__c = string.isnotblank(Acc.Email_Last_Modified_By2__c)?Acc.Email_Last_Modified_By2__c:UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = Acc.Email_Last_Modified_Date2__c!=null?Acc.Email_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Email3__c!= Null && Acc.Email3__c != ''){
                    Acc.Email_Last_Modified_By3__c = string.isnotblank(Acc.Email_Last_Modified_By3__c)?Acc.Email_Last_Modified_By3__c:UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = Acc.Email_Last_Modified_Date3__c!=null?Acc.Email_Last_Modified_Date3__c:System.now();
                }
				//Sada 2018/April/17 added as per Defect DF18
                if(Acc.Opt_In_Email__c!= Null ){
                    Acc.Email_Opt_IN_Last_Update_date__c = Acc.Email_Opt_IN_Last_Update_date__c!=null?Acc.Email_Opt_IN_Last_Update_date__c:System.now();
                }
                if(Acc.Opt_In_Phone__c!= Null ){
                    Acc.Phone_Opt_IN_Last_Update_date__c = Acc.Phone_Opt_IN_Last_Update_date__c!=null?Acc.Phone_Opt_IN_Last_Update_date__c:System.now();
                }
                if(Acc.Opt_In_SMS3__c!= Null ){
                    Acc.SMS_Opt_IN_Last_Update_date__c = Acc.SMS_Opt_IN_Last_Update_date__c!=null?Acc.SMS_Opt_IN_Last_Update_date__c:System.now();                  
                }
                if(Acc.Opt_In_Mail__c!= Null ){
                Acc.Mail_Opt_IN_Last_Update_date__c = Acc.Mail_Opt_IN_Last_Update_date__c!=null?Acc.Mail_Opt_IN_Last_Update_date__c:System.now();                   
                }  
               
              
            }
        }
    }
     public static void updateAccountFieldsBeforeIntUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts){
                Account OldAcc = accountOldMap.get(Acc.id);
                if(Acc.Individual_Home_Phone__c!= OldAcc.Individual_Home_Phone__c){
                    Acc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = Acc.Home_Phone_Last_Modified_Date__c!=null?Acc.Home_Phone_Last_Modified_Date__c:System.now();
                }
                if(Acc.Home_Phone_2__c != OldAcc.Home_Phone_2__c){
                    Acc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = Acc.Home_Phone_Last_Modified_Date2__c!=null?Acc.Home_Phone_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Work_Phone__c!= OldAcc.Work_Phone__c){
                    Acc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c =Acc.Work_Phone_Last_Modified_Date__c!=null?Acc.Work_Phone_Last_Modified_Date__c:System.now();
                }
                if(Acc.Phone!= OldAcc.Phone){
                    Acc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date2__c = Acc.Work_Phone_Last_Modified_Date2__c!=null?Acc.Work_Phone_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Email__c!= OldAcc.Email__c){
                    
                    Acc.Email_Last_Modified_By__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date__c = Acc.Email_Last_Modified_Date__c!=null?Acc.Email_Last_Modified_Date__c:System.now();
                }
                if(Acc.Email2__c!= OldAcc.Email2__c){
                    Acc.Email_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = Acc.Email_Last_Modified_Date2__c!=null?Acc.Email_Last_Modified_Date2__c:System.now();
                }
                if(Acc.Email3__c!= OldAcc.Email3__c){
                    Acc.Email_Last_Modified_By3__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = Acc.Email_Last_Modified_Date3__c!=null?Acc.Email_Last_Modified_Date3__c:System.now();
                }
                if(Acc.Mobile__c != OldAcc.Mobile__c){
                    Acc.SMS_Last_Modified_By__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c = Acc.SMS_Last_Modified_Date__c!=null?Acc.SMS_Last_Modified_Date__c:System.now();
                }   
                if(Acc.Mobile2__c!= OldAcc.Mobile2__c ){
                    Acc.SMS_Last_Modified_By2__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = Acc.SMS_Last_Modified_Date2__c!=null?Acc.SMS_Last_Modified_Date2__c:System.now();
                }
				//Sada 2018/April/17 added as per Defect DF18
               if(Acc.Opt_In_Email__c != OldAcc.Opt_In_Email__c){
                    Acc.Email_Opt_IN_Last_Update_date__c = Acc.Email_Opt_IN_Last_Update_date__c!=null?Acc.Email_Opt_IN_Last_Update_date__c:System.now();
                }                
                if(Acc.Opt_In_Phone__c != OldAcc.Opt_In_Phone__c){
                    Acc.Phone_Opt_IN_Last_Update_date__c = Acc.Phone_Opt_IN_Last_Update_date__c!=null?Acc.Phone_Opt_IN_Last_Update_date__c:System.now();
                }
                if(Acc.Opt_In_SMS3__c != OldAcc.Opt_In_SMS3__c){
                    Acc.SMS_Opt_IN_Last_Update_date__c = Acc.SMS_Opt_IN_Last_Update_date__c!=null?Acc.SMS_Opt_IN_Last_Update_date__c:System.now();                  
                }
                if(Acc.Opt_In_Mail__c != OldAcc.Opt_In_Mail__c){
                   Acc.Mail_Opt_IN_Last_Update_date__c = Acc.Mail_Opt_IN_Last_Update_date__c!=null?Acc.Mail_Opt_IN_Last_Update_date__c:System.now();                    
                } 
            }
        }
    }
    
    
    
    
    //Added by dhanamjaya to validate the National Id before Update
    public static void ValidateNationalid(List<account> ListAccount){
        for(Account acc:ListAccount){
            if(acc.ID_Type__c=='National ID'){
                if(String.isBlank(acc.ID_Number__c)){
                    acc.ID_Number__c.addError('ID Number: If ID Type is National ID, ID Number must not be empty, and 13 characters, containing only number');
                }
                else{
                    Pattern p = Pattern.compile('[0-9]{13}');
                    Matcher m = p.matcher(acc.ID_Number__c);
                    if(!m.matches()){
                        acc.ID_Number__c.addError('ID Number: If ID Type is National ID, ID Number must not be empty, and 13 characters, containing only number');  
                    }
                    else{
                        integer sum=0;
                        Integer Remainder;
                        for(integer i=0;i<acc.ID_Number__c.length()-1;i++){
                            sum=sum+(integer.valueOf(acc.ID_Number__c.substring(i, i+1)))*(13-i);
                        }
                        remainder=11-(math.mod(sum,11));
                        if(remainder!=integer.valueOf(acc.ID_Number__c.substring(12,13))){
                            acc.ID_Number__c.addError('ID Number: Invalid National id');
                        }
                    }
                }
            }
        }
    }

    /**
    * Implement Do Not Call(PersonDoNotCall) to automate opt-out for all channels which means that selecting this flag opts out the customer from 
    * being contacted via all Phone numbers (Ex: Home Phone, Mobile, Work Phone).   
    */
    public static void updateOnDoNotCall(list<Account> listNewAccounts){        
        for(Account acc : listNewAccounts){
        //MT20170913- Added market Descrminator MY      
            if(acc.PersonDoNotCall){
                if(acc.Opt_In_Home_Phone__c){ acc.Opt_In_Home_Phone__c = FALSE;}
                if(acc.Opt_In_Home_Phone2__c){ acc.Opt_In_Home_Phone2__c = FALSE;}
                if(acc.Opt_In_Work_Phone__c ){ acc.Opt_In_Work_Phone__c = FALSE;}
                if(acc.Opt_In_Work_Phone2__c){ acc.Opt_In_Work_Phone2__c = FALSE;}
                if(acc.Preferred_Mobile_1__c){ acc.Preferred_Mobile_1__c = FALSE;}
                if(acc.Preferred_Mobile_2__c){ acc.Preferred_Mobile_2__c = FALSE;}              
            }
        }
    }

    /*
    * Implement Postal_Opt_Out__c to automate opt-out for all addresses which means that selecting this flag opts out the customer from being contacted 
    * via Addresses (Ex: Home Address, Office Address, etc.).
    */
    public static void updateOnPostalOptout(list<Account> listNewAccounts){
        List<Address__c> addressupdatelst = new list<Address__c>();
        List<Address__c> addressList = new list<Address__c>();
        Set<Id> Accid=new Set<Id>();
        Set<Id> Addd=new Set<Id>();
        for(Account acc: listNewAccounts){
            Accid.add(acc.id);
            Addd.add(acc.Primary_Address_Reference__c);
            // NEED INPUTS FOR IMPLEMENTATION
        }
        addressList =[select id,Opt_In_Hardcopy__c from Address__c where id=:Addd];
        for(Account acc: listNewAccounts){
            //MT20170913- Added market Descrminator MY
            for(Address__c add: addressList)
                if(acc.Postal_Opt_Out__c){
                    if(add.Opt_In_Hardcopy__c== true){ 
                        add.Opt_In_Hardcopy__c = false;
                        addressupdatelst.add(add);
                    }
                } 
            }
            DMLManagerService.updateAsSystem(addressupdatelst);
    }

    /**
    * Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
    */
    public static void updateOnEmailOptout(list<Account> listNewAccounts){        
        for(Account acc: listNewAccounts){
            //MT20170913- Added market Descrminator MY
            if(acc.PersonHasOptedOutOfEmail){
                if(acc.Opt_In_Email__c){ acc.Opt_In_Email__c = FALSE;}
                if(acc.Opt_In_Email2__c){ acc.Opt_In_Email2__c = FALSE;}
                if(acc.Opt_In_Email3__c){ acc.Opt_In_Email3__c = FALSE;}
            }
        }
    }

    /**
    * Calculate “Age Range” based on birthdate.
    */
    public static void updateAgeRange(list<Account> listNewAccounts){
        for(Account acc:  listNewAccounts){
            if(acc.PersonBirthdate != NULL){
                Integer ageInt = (Integer.valueOf(System.today().year())-Integer.valueof(acc.PersonBirthdate.year()) );
                acc.Age_Range__c = AccountHelperBase.calculateAgeRange(ageInt); 
            }
        }
    }

    public static String calculateAgeRange(Integer ageInt){
        if(17 <= ageInt && ageInt <= 25){
            return '17-25';   
        }else if(26 <= ageInt && ageInt <= 35){
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

    //Gets the List of Active Contracts and set the value to the Active Contracts field.
    //Created By:Mohammed Touseef Ahmed
    //Date:12th Feb 2017
    public static void activeContracts(list<Account> listNewAccounts){
        integer actContract=0;
        Set<Id> AccIdSet = new Set<Id>();
        for(Account acc : listNewAccounts){       
            AccIdSet.add(acc.id);          
        }
        List<contract> lstCntrct=[select id,StartDate,EndDate,ContractTerm,Account.id 
                                    from contract where Account.id in : AccIdSet];      
        for(Account acc : listNewAccounts){                                  
            for(contract cntrct: lstCntrct){
                if(cntrct.EndDate.daysBetween(cntrct.StartDate)<cntrct.ContractTerm){
                    actContract=actContract+1;                   
                }
            }                                     
            acc.Active_Contracts__c=actContract;           
        }
    }

    /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are updated.
    **  Created By: Mohammed Touseef Ahmed
    **  Date: 2017-20-02
    **/
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts){
                Account OldAcc = accountOldMap.get(Acc.id);
                if(Acc.Individual_Home_Phone__c!= OldAcc.Individual_Home_Phone__c){
                    Acc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = System.now();
                }
                if(Acc.Home_Phone_2__c != OldAcc.Home_Phone_2__c){
                    Acc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Work_Phone__c!= OldAcc.Work_Phone__c){
                    Acc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c = System.now();
                }
                if(Acc.Phone!= OldAcc.Phone){
                    Acc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Email__c!= OldAcc.Email__c){
                    //Acc.PersonEmail = Acc.Email__c;
                    Acc.Email_Last_Modified_By__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date__c = System.now();
                }
                //if(Acc.Email__c != OldAcc.Email__c && Acc.Email__c == null)
                    //Acc.PersonEmail = Null;
                if(Acc.Email2__c!= OldAcc.Email2__c){
                    Acc.Email_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = System.now();
                }
                if(Acc.Email3__c!= OldAcc.Email3__c){
                    Acc.Email_Last_Modified_By3__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = System.now();
                }
                if(Acc.Mobile__c != OldAcc.Mobile__c){
                    Acc.SMS_Last_Modified_By__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c = System.now();
                }   
                if(Acc.Mobile2__c!= OldAcc.Mobile2__c ){
                    Acc.SMS_Last_Modified_By2__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = System.now();
                }
				//Sada 2018/April/17 added as per Defect DF18
                if(Acc.Opt_In_Email__c != OldAcc.Opt_In_Email__c){
                    Acc.Email_Opt_IN_Last_Update_date__c= System.now();
                }                
                if(Acc.Opt_In_Phone__c != OldAcc.Opt_In_Phone__c){
                    Acc.Phone_Opt_IN_Last_Update_date__c= System.now();
                }
                if(Acc.Opt_In_SMS3__c != OldAcc.Opt_In_SMS3__c){
                    Acc.SMS_Opt_IN_Last_Update_date__c= System.now();
                }
                if(Acc.Opt_In_Mail__c != OldAcc.Opt_In_Mail__c){
                    Acc.Mail_Opt_IN_Last_Update_date__c= System.now();
                }
            }
        }
    }
    /** Upadte Primary address display field based on primary address reference lookup field.
    ** Created By: Mohammed touseef Ahmed
    ** Date: 2017-20-02
    **/
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate,Map<Id,Account>accountOldMap){
        Map<Id,Address__c> addr;
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
                addr = new map<id,Address__c>([select Customer__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Sub_District__c,ZipCode__c from Address__c where id In : addressid]);            
            }
            For(Account acc:listNewAccounts){      //MT20170913- Added market Descrminator MY
                If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null){              
                    Address__c add = addr.get(acc.Primary_Address_Reference__c);
                    if(addtrmap1.containsKey(add.Province__c)){
                        province = addtrmap1.get(add.Province__c);
                    }
                    acc.Primary_Address_Display__c = add.Address_Line_1__c + ' ' + add.Address_Line_2__c+' ' +' '+add.Address_Line_3__c+' '+add.Sub_District__c+' '+add.District__c+' '+add.Province__c+' '+add.ZipCode__c;  // SFDCTH-277
                    acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);                        
                }
                else if(acc.Primary_Address_Reference__c ==Null){
                    acc.Primary_Address_Display__c ='';
                }
            }     
        }    
    } 

    //Creates a retail copy of account on as account link
    //Sushma Bharti
    //SB2017
    //26/12/2017
    public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate){
        User usr = new user(); 
        if(userInfo.getUserType() == 'PowerPartner'){
		usr=[select id,Name,ContactId,contact.AccountId,Profile.UserLicense.Name,Contact.Account.Dealer_ND_Code__c,contact.Account.Dealer_Rollout_Status__c,Market__c from user where Id =: UserInfo.getUserId()];
            List<group> dealergrpList = new List<group>();
            set<id> accid = new set<id>();
            List<AccountShare> insertAccshList = new List<AccountShare>();
            List<Address__c> addressList = new List<Address__c>();
            List<Account_Link__c> retailCopyList = new List<Account_Link__c>();
            List<Account_Link__c> insertAcclnkList = new List<Account_Link__c>();
            map<string,id> dealerGroupMap = new map<string,id>();
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            string regexForNullValue ='null';
            string nullValue ='';           
            for(Account acc : accLst){
                accid.add(acc.Id);
            }
            if(!accid.isEmpty() && accid != null){
                //addressList = [select id,Address_Type__c,City__c,District__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Customer__c,Preferred__c,
               // ZipCode__c,Province__c,CreatedDate,LastModifiedDate from Address__c where Customer__c =:accid AND Preferred__c = true];   
                retailCopyList = [select id from Account_Link__c where toRole__c =:accid AND fromRole__c =:usr.Contact.AccountId AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            }
            if(retailCopyList.isEmpty()){
                for(Account retailacc: accLst){
					if(String.isnotblank(usr.contact.Account.Dealer_Rollout_Status__c)?(usr.contact.Account.Dealer_Rollout_Status__c=='Done'):false){
                    Account_Link__c acclnk = new Account_Link__c();
                    //mapping fields for Company recordtype
                    if(retailacc.RecordTypeId == accCompany_RecordTypeId){                       
							acclnk.RecordTypeId = retailCompany_RecordTypeId;
							acclnk.fromRole__c = usr.Contact.AccountId;
							acclnk.toRole__c = retailacc.Id;							
					        acclnk.Retail_UCID__c = retailacc.UCID__c;
                            acclnk.Retail_Country__c = retailacc.country__c;
                            acclnk.LastModifiedDate__c = retailacc.LastmodifiedDate;
                            acclnk.createddate__c = retailacc.createdDate;
							acclnk.Retail_Company_Name_Native1__c = retailacc.Company_Name_Native_1__c;
                            acclnk.Retail_Company_Name__c = retailacc.name;
                            acclnk.Retail_Mobile__c = retailacc.Mobile__c;
                            acclnk.Retail_Company_Phone__c = retailacc.Individual_Home_Phone__c;
                            acclnk.Retail_Company_Other_Phone__c = retailacc.Work_Phone__c;
                            acclnk.Retail_Email__c = retailacc.email__c;
                            acclnk.Retail_Email_OptOut__c = retailacc.PersonHasOptedOutOfEmail;
                            acclnk.Retail_Fax_OptOut__c = retailacc.PersonHasOptedOutOfFax;
                            acclnk.Retail_Primary_Phone__c = retailacc.Primary_Phone__c;
                            acclnk.Retail_Sales_Sanction__c = retailacc.Sales_Sanction__c;
                            acclnk.Retail_Phone_OptOut__c = retailacc.PersonDoNotCall;
                            acclnk.Retail_Postal_OptOut__c = retailacc.Postal_Opt_Out__c;
                            acclnk.Retail_Visit_OptOut__c = retailacc.Visit_Opt_Out__c;
                            acclnk.Retail_Fax__c = retailacc.fax;
							acclnk.Retail_Position__c=retailacc.Job__c;
                            acclnk.Retail_Preferred_Language__c = retailacc.Preferred_Language__c;
                            acclnk.Retail_Industry__c = retailacc.Industry;
                            acclnk.Retail_Commercial_Reg_No__c = retailacc.Commercial_Reg_No__c;
                            acclnk.Retail_Vat_No__c = retailacc.Vat_No__c;
                            acclnk.Retail_WebSite__c = retailacc.Website;
                            acclnk.Retail_Agreement__c = retailacc.Personal_Agreement__c;
                            acclnk.Retail_Information_Third_Party_Release__c = retailacc.Personal_Information_Third_Party_Release__c;
                            acclnk.Retail_Abroad_Agreement__c = retailacc.Personal_Abroad_Agreement__c;
                            acclnk.Retail_Agreement_Info_Processing__c = retailacc.Agreement_to_commit_info_processing__c;
							
						
							if(retailacc.Foundation_Date__c != null){
								//acclnk.Retail_Foundation_Month__c = String.ValueOf(retailacc.Foundation_Date__c.month())+String.valueOf(retailacc.Foundation_Date__c.year());
								acclnk.Retail_Foundation_Month__c =	String.valueOf(retailacc.Foundation_Date__c.year()) + (String.ValueOf(retailacc.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(retailacc.Foundation_Date__c.month())) :String.ValueOf(retailacc.Foundation_Date__c.month())) + (String.ValueOf(retailacc.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(retailacc.Foundation_Date__c.day())) :String.ValueOf(retailacc.Foundation_Date__c.day()));
							}

                    }
                    //mapping fields for Person Account recordtype
                    else if(retailacc.RecordTypeId == accPerson_RecordTypeId){
                        acclnk.RecordTypeId = retailPerson_RecordTypeId; 
                        acclnk.fromRole__c = usr.Contact.AccountId; 
                        acclnk.toRole__c = retailacc.Id;   
                        
							acclnk.Retail_Salutation__c = retailacc.Title__c;
                            acclnk.Retail_Country__c = retailacc.country__c;
                            acclnk.Retail_ID_Type__c = retailacc.ID_Type__c;
                            acclnk.Retail_ID_Number__c = retailacc.ID_Number__c;
                            acclnk.LastModifiedDate__c = retailacc.LastmodifiedDate;
                            acclnk.createddate__c = retailacc.createdDate;
							acclnk.Retail_Race__c=retailacc.Race__c;
                            acclnk.Retail_Special_Care__c = retailacc.Special_Care__c;
                            acclnk.Retail_LastName_Native__c = retailacc.LastName_Native_1__c;
                            acclnk.Retail_FirstName_Native__c = retailacc.FirstName_Native_1__c;
                            acclnk.Retail_Primary_Phone__c = retailacc.Primary_Phone__c;
                            acclnk.Retail_Full_Name__c = retailacc.FirstName + ' ' + retailacc.LastName ;
                            acclnk.Retail_Full_Name_Title__c = ((retailacc.Title__c!= null ?retailacc.Title__c:'')  + ' ' + (retailacc.FirstName!= null ?retailacc.FirstName:'') + ' ' +(retailacc.LastName!= null ?retailacc.LastName:'')).left(140) ;
                            acclnk.Retail_LastName__c = retailacc.LastName;
                            acclnk.Retail_FirstName__c = retailacc.FirstName;
                            acclnk.Retail_Complaint_Amount__c = retailacc.Complaint_Amount__c;
                            acclnk.Retail_Sales_Sanction__c = retailacc.Sales_Sanction__c;
                            acclnk.Retail_UCID__c = retailacc.UCID__c;
                            acclnk.Retail_Allow_Data_Sharing__c = retailacc.Allow_Data_Sharing__c;
                            acclnk.Retail_Mobile__c = retailacc.Mobile__c;
                            acclnk.Retail_Individual_Home_Phone__c = retailacc.Individual_Home_Phone__c;
                            acclnk.Retail_Work_Phone__c = retailacc.Work_Phone__c;
                            acclnk.Retail_Email__c = retailacc.PersonEmail;
                            acclnk.Retail_Fax__c = retailacc.Fax;
                            acclnk.Retail_Preferred_Contact_Method__c = retailacc.Preferred_Contact_Method__c;
                            acclnk.Retail_Email_OptOut__c = retailacc.PersonHasOptedOutOfEmail;
                            acclnk.Retail_Fax_OptOut__c = retailacc.PersonHasOptedOutOfFax;                                                                                                
                            acclnk.Retail_Phone_OptOut__c = retailacc.PersonDoNotCall;
                            acclnk.Retail_Postal_OptOut__c = retailacc.Postal_Opt_Out__c;
                            acclnk.Retail_Visit_OptOut__c = retailacc.Visit_Opt_Out__c;
                            acclnk.Retail_PersonBirthdate__c = retailacc.PersonBirthdate;
                            acclnk.Retail_Occupation__c = retailacc.Occupation__c;
                            acclnk.Retail_Position__c = retailacc.Job__c;
                            acclnk.Retail_Preferred_Language__c = retailacc.Preferred_Language__c;
                            acclnk.Retail_Gender__c = retailacc.Gender__c;
                            acclnk.Retail_Industry__c = retailacc.industry;
                            acclnk.Retail_WebSite__c = retailacc.Website;
                            acclnk.Retail_Commercial_Reg_No__c = retailacc.Commercial_Reg_No__c;

                            acclnk.Retail_Agreement__c = retailacc.Personal_Agreement__c;
                            acclnk.Retail_Information_Third_Party_Release__c = retailacc.Personal_Information_Third_Party_Release__c;
                            acclnk.Retail_Abroad_Agreement__c = retailacc.Personal_Abroad_Agreement__c;
                            acclnk.Retail_Agreement_Info_Processing__c = retailacc.Agreement_to_commit_info_processing__c;
                            acclnk.Retail_Vat_No__c = retailacc.Vat_No__c;
                            if(retailacc.Foundation_Date__c != null)
                            {
                                acclnk.Retail_Foundation_Month__c =	String.valueOf(retailacc.Foundation_Date__c.year()) + (String.ValueOf(retailacc.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(retailacc.Foundation_Date__c.month())) :String.ValueOf(retailacc.Foundation_Date__c.month())) + (String.ValueOf(retailacc.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(retailacc.Foundation_Date__c.day())) :String.ValueOf(retailacc.Foundation_Date__c.day()));
							}	

                      
                    }
                    //mapping fields common for both recordtypes
                    acclnk.Retail_Allow_Data_Sharing__c = retailacc.Allow_Data_Sharing2__c;
                    acclnk.Retail_Industry__c = retailacc.industry; 
                    acclnk.Retail_Fax__c = retailacc.fax; 
                    acclnk.Retail_UCID__c = retailacc.UCID__c;
                    
                    //mapping the address fields
                    if(!addressList.isEmpty() && addressList != null){
                        for(Address__c add : addressList){
                            if(add.Customer__c == retailacc.Id){
                                acclnk.Retail_Address_Reference__c = add.Id;
                                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(add.CreatedDate);
                                acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(add.LastModifiedDate);
                                acclnk.Retail_Address_Type__c = add.Address_Type__c;
                                if(add.Address_Line_1__c != null && add.Address_Line_1__c != ''){
                                    acclnk.Retail_Address_Line_1__c = add.Address_Line_1__c;
                                }
                                if(add.Address_Line_2__c != null && add.Address_Line_2__c != ''){
                                    acclnk.Retail_Address_Line_2__c = add.Address_Line_2__c;
                                }
								if(add.Address_Line_3__c != null && add.Address_Line_3__c != ''){
                                    acclnk.Retail_Address_Line_3__c = add.Address_Line_3__c;
                                }
                                if(add.ZipCode__c != null && add.ZipCode__c != ''){
                                    acclnk.Retail_ZipCode__c = add.ZipCode__c;
                                }
                                if(add.City__c != null && add.City__c != ''){
                                    acclnk.Retail_City__c = add.District__c;
                                }
                                if(add.District__c != null && add.District__c != ''){
                                    acclnk.Retail_Distinct__c = add.District__c+' '+add.Block__c;
                                }
                                if(add.Country__c != null && add.Country__c != ''){
                                    acclnk.Retail_Country__c = add.Country__c;
                                }
                                if(addtrmap1.containsKey(add.Province__c)){
                                    acclnk.Retail_Province__c = addtrmap1.get(add.Province__c);
                                }
                                acclnk.Retail_Province__c = acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                            }
                        }
                    }
					
                    insertAcclnkList.add(acclnk);
					}
                }
            }
            if(!insertAcclnkList.isEmpty() && insertAcclnkList != null){
                DMLManagerService.InsertAsSystem(insertAcclnkList);
            }
            if(usr != null){
				string grpName= usr.Market__c+usr.Contact.Account.Dealer_ND_Code__c;
                //dealergrpList = [select id ,DeveloperName ,Name ,Type from Group where Name =:usr.Contact.Account.Dealer_ND_Code__c];
				dealergrpList = [select id ,DeveloperName ,Name ,Type from Group where Name =:grpName];
            }
            if(!dealergrpList.isEmpty() && dealergrpList != null){
                for(Group g : dealergrpList){
                    dealerGroupMap.put(g.Name, g.Id);
                }
            }
            for(Account shareacc : accLst){
				string grpName= usr.Market__c+usr.Contact.Account.Dealer_ND_Code__c;
                //if(!dealerGroupMap.isEmpty() && dealerGroupMap.get(usr.Contact.Account.Dealer_ND_Code__c) != null && shareacc.OwnerId != usr.Id){
				if(!dealerGroupMap.isEmpty() && dealerGroupMap.get(grpName) != null && shareacc.OwnerId != usr.Id){
                    AccountShare accshr = new AccountShare();
                    accshr.AccountId = shareacc.Id;
                    accshr.AccountAccessLevel = 'Edit';
                    accshr.CaseAccessLevel = 'None';
                    accshr.OpportunityAccessLevel = 'None';
                    //accshr.UserOrGroupId = dealerGroupMap.get(usr.Contact.Account.Dealer_ND_Code__c);
					accshr.UserOrGroupId = dealerGroupMap.get(grpName);
                    insertAccshList.add(accshr);
                }
            }
            if(!insertAccshList.isEmpty() && insertAccshList != null){
                DMLManagerService.InsertAsSystem(insertAccshList);
            }
        }
    }

    /*
    # Description:This method will update the retail copy when related Account(Account 1) is updated. 
    //Sushma Bharti
    //SB2017
    //26/12/2017
    */
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){        
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        for(Account acc : accLst){
            AccountIds.add(acc.id); //Adding accountId's to set        
        }
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        List<Account_Link__c> Accountlinklist = [select id,toRole__r.Agreement_to_commit_info_processing__c,toRole__r.Personal_Information_Third_Party_Release__c,toRole__r.UCID__c,toRole__r.CDM_UCID__c,toRole__r.Personal_Abroad_Agreement__c,toRole__r.DMS_Retailer_ID__c,Name,toRole__r.RecordType.Name, toRole__r.LastName, toRole__r.FirstName, toRole__r.Salutation__c, toRole__r.LastName_Native_1__c,
        toRole__r.FirstName_Native_1__c, toRole__r.Gender__c, toRole__r.race__c,toRole__r.PersonBirthdate, toRole__r.Occupation__c, toRole__r.Industry,toRole__r.createdDate, 
        toRole__r.Preferred_Language__c, toRole__r.Primary_Phone__c, toRole__r.Special_Care__c, toRole__r.Special_Needs_Class__c,torole__r.LastModifiedDate ,
        toRole__r.Allow_Data_Sharing2__c,toRole__r.Individual_Home_Phone__c, toRole__r.Work_Phone__c, toRole__r.Mobile__c, toRole__r.Fax,torole__r.ID_Type__c,torole__r.ID_Number__c,
        toRole__r.Email__c,toRole__r.Primary_Address_Reference__r.Address_Type__c, toRole__r.Primary_Address_Reference__r.Province__c,toRole__r.country__c,
        toRole__r.Primary_Address_Reference__r.City__c, toRole__r.Primary_Address_Reference__r.District__c, toRole__r.Primary_Address_Reference__r.Block__c,
        toRole__r.Primary_Address_Reference__r.Address_Line_1__c, toRole__r.Primary_Address_Reference__r.Address_Line_3__c,toRole__r.Primary_Address_Reference__r.Address_Line_2__c, toRole__r.Primary_Address_Reference__r.ZipCode__c,
        toRole__r.Name, toRole__r.Company_Name_Native_1__c, toRole__r.Commercial_Reg_No__c, toRole__r.Vat_No__c, toRole__r.Job__c,toRole__r.Sales_Sanction__c,toRole__r.Allow_Data_Sharing__c,
        toRole__r.Foundation_Date__c, toRole__r.Website, toRole__r.Primary_Address_Reference__r.CreatedDate,toRole__r.Title__c,toRole__r.Preferred_Contact_Method__c,
        toRole__r.Primary_Address_Reference__r.LastModifiedDate,toRole__r.MBTH_Nationality__c,toRole__r.Preferred_Radio_Station__c,toRole__r.Personal_Agreement__c,/*toRole__r.MBTH_Mercede__c,*/
        toRole__r.First_Consent_Date__c,toRole__r.Updated_Consent_Date__c,toRole__r.First_Consent_User__c,toRole__r.Updated_Consent_User__c,toRole__r.PersonHasOptedOutOfEmail,
		torole__r.PersonHasOptedOutOfFax,torole__r.PersonDoNotCall,torole__r.Postal_Opt_Out__c,Retail_Address_Reference__c,
        torole__r.Visit_Opt_Out__c,fromRole__r.Dealer_Rollout_Status__c	
        from Account_Link__c WHERE toRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany ) and fromRole__r.Dealer_Rollout_Status__c='Done' ];
        
        //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist ){
            //Checking the Person Account RecordType            
            if(acclnk.toRole__r.RecordType.Name == 'Person Account' && (string.isnotblank(acclnk.fromRole__r.Dealer_Rollout_Status__c)?(acclnk.fromRole__r.Dealer_Rollout_Status__c=='Done'):false)) {                 

				acclnk.Retail_Salutation__c = acclnk.toRole__r.Title__c;
                acclnk.Retail_Country__c = acclnk.toRole__r.country__c;
                acclnk.Retail_ID_Type__c = acclnk.toRole__r.ID_Type__c;
                acclnk.Retail_ID_Number__c = acclnk.toRole__r.ID_Number__c;
                acclnk.LastModifiedDate__c = acclnk.toRole__r.LastmodifiedDate;
                acclnk.createddate__c = acclnk.toRole__r.createdDate;
				acclnk.Retail_Race__c=acclnk.toRole__r.Race__c;
                acclnk.Retail_Special_Care__c = acclnk.toRole__r.Special_Care__c;
                acclnk.Retail_LastName_Native__c = acclnk.toRole__r.LastName_Native_1__c;
                acclnk.Retail_FirstName_Native__c = acclnk.toRole__r.FirstName_Native_1__c;
                acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone__c;
                acclnk.Retail_Full_Name__c = acclnk.toRole__r.FirstName + ' ' + acclnk.toRole__r.LastName ;
                acclnk.Retail_Full_Name_Title__c = ((acclnk.toRole__r.Title__c!= null ?acclnk.toRole__r.Title__c:'')  + ' ' + (acclnk.toRole__r.FirstName!= null ?acclnk.toRole__r.FirstName:'') + ' ' +(acclnk.toRole__r.LastName!= null ?acclnk.toRole__r.LastName:'')).left(140) ;
                acclnk.Retail_LastName__c = acclnk.toRole__r.LastName;
                acclnk.Retail_FirstName__c = acclnk.toRole__r.FirstName;
                //acclnk.Retail_Complaint_Amount__c = acclnk.toRole__r.Complaint_Amount__c;
                acclnk.Retail_Sales_Sanction__c = acclnk.toRole__r.Sales_Sanction__c;
                acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;
                acclnk.Retail_Allow_Data_Sharing__c = acclnk.toRole__r.Allow_Data_Sharing__c;
                acclnk.Retail_Mobile__c = acclnk.toRole__r.Mobile__c;
                acclnk.Retail_Individual_Home_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                acclnk.Retail_Work_Phone__c = acclnk.toRole__r.Work_Phone__c;
                acclnk.Retail_Email__c = acclnk.toRole__r.email__c;
                acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
                acclnk.Retail_Preferred_Contact_Method__c = acclnk.toRole__r.Preferred_Contact_Method__c;
                acclnk.Retail_Email_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfEmail;
                acclnk.Retail_Fax_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfFax;                                                                                                
                acclnk.Retail_Phone_OptOut__c = acclnk.toRole__r.PersonDoNotCall;
                acclnk.Retail_Postal_OptOut__c = acclnk.toRole__r.Postal_Opt_Out__c;
                acclnk.Retail_Visit_OptOut__c = acclnk.toRole__r.Visit_Opt_Out__c;
                acclnk.Retail_PersonBirthdate__c = acclnk.toRole__r.PersonBirthdate;
                acclnk.Retail_Occupation__c = acclnk.toRole__r.Occupation__c;
                acclnk.Retail_Position__c = acclnk.toRole__r.Job__c;
                acclnk.Retail_Preferred_Language__c = acclnk.toRole__r.Preferred_Language__c;
                acclnk.Retail_Gender__c = acclnk.toRole__r.Gender__c;
                acclnk.Retail_Industry__c = acclnk.toRole__r.industry;
                acclnk.Retail_WebSite__c = acclnk.toRole__r.Website;
                acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c;
                acclnk.Retail_Agreement__c = acclnk.toRole__r.Personal_Agreement__c;
                acclnk.Retail_Information_Third_Party_Release__c = acclnk.toRole__r.Personal_Information_Third_Party_Release__c;
                acclnk.Retail_Abroad_Agreement__c = acclnk.toRole__r.Personal_Abroad_Agreement__c;
                acclnk.Retail_Agreement_Info_Processing__c = acclnk.toRole__r.Agreement_to_commit_info_processing__c;
                acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c;
                if(acclnk.toRole__r.Foundation_Date__c != null){
                    acclnk.Retail_Foundation_Month__c = String.valueOf(acclnk.toRole__r.Foundation_Date__c.year()) + (String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month())) :String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month())) + (String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day())) :String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day()));
                }	

            }
            //Checking the Company RecordType
            if(acclnk.toRole__r.RecordType.Name=='Company' && (string.isnotblank(acclnk.fromRole__r.Dealer_Rollout_Status__c)?(acclnk.fromRole__r.Dealer_Rollout_Status__c=='Done'):false)){ 
					acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;
                    acclnk.Retail_Country__c = acclnk.toRole__r.country__c;
                    acclnk.LastModifiedDate__c = acclnk.toRole__r.LastmodifiedDate;
                    acclnk.createddate__c = acclnk.toRole__r.createdDate;
					acclnk.Retail_Company_Name_Native1__c = acclnk.toRole__r.Company_Name_Native_1__c;
                    acclnk.Retail_Company_Name__c = acclnk.toRole__r.name;
                    acclnk.Retail_Mobile__c = acclnk.toRole__r.Mobile__c;
                    acclnk.Retail_Company_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                    acclnk.Retail_Company_Other_Phone__c = acclnk.toRole__r.Work_Phone__c;
                    acclnk.Retail_Email__c = acclnk.toRole__r.email__c;
                    acclnk.Retail_Email_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfEmail;
                    acclnk.Retail_Fax_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfFax;
                    acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone__c;
                    acclnk.Retail_Sales_Sanction__c = acclnk.toRole__r.Sales_Sanction__c;
                    acclnk.Retail_Phone_OptOut__c = acclnk.toRole__r.PersonDoNotCall;
                    acclnk.Retail_Postal_OptOut__c = acclnk.toRole__r.Postal_Opt_Out__c;
                    acclnk.Retail_Visit_OptOut__c = acclnk.toRole__r.Visit_Opt_Out__c;
                    acclnk.Retail_Fax__c = acclnk.toRole__r.fax;
					acclnk.Retail_Position__c=acclnk.toRole__r.Job__c;
                    acclnk.Retail_Preferred_Language__c = acclnk.toRole__r.Preferred_Language__c;
                    acclnk.Retail_Industry__c = acclnk.toRole__r.Industry;
                    acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c;
                    acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c;
                    acclnk.Retail_WebSite__c = acclnk.toRole__r.Website;
                    acclnk.Retail_Agreement__c = acclnk.toRole__r.Personal_Agreement__c;
                    acclnk.Retail_Information_Third_Party_Release__c = acclnk.toRole__r.Personal_Information_Third_Party_Release__c;
                    acclnk.Retail_Abroad_Agreement__c = acclnk.toRole__r.Personal_Abroad_Agreement__c;
                    acclnk.Retail_Agreement_Info_Processing__c = acclnk.toRole__r.Agreement_to_commit_info_processing__c;
					if(acclnk.toRole__r.Foundation_Date__c != null){
						 acclnk.Retail_Foundation_Month__c = String.valueOf(acclnk.toRole__r.Foundation_Date__c.year()) + (String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month())) :String.ValueOf(acclnk.toRole__r.Foundation_Date__c.month())) + (String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day())) :String.ValueOf(acclnk.toRole__r.Foundation_Date__c.day()));
					}			
	
            }//End if for Company record type
            
            //mapping fields common for both recordtypes
            acclnk.Retail_Industry__c = acclnk.toRole__r.Industry;                        
            acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
            acclnk.Retail_Allow_Data_Sharing__c = acclnk.toRole__r.Allow_Data_Sharing2__c;
            acclnk.Retail_UCID__c=acclnk.toRole__r.UCID__c;  
            system.debug(acclnk.toRole__r.Primary_Address_Reference__c+'--'+string.isnotblank(acclnk.Retail_Address_Reference__c)+'--'+acclnk.Retail_Address_Reference__c+'-'+TriggerRecursiveCheck.ALAddressCheck+'---');
            
            //Checking Null for sales Address 
            if((acclnk.toRole__r.Primary_Address_Reference__c != null &&  string.isnotblank(acclnk.Retail_Address_Reference__c) && acclnk.toRole__r.Primary_Address_Reference__c ==acclnk.Retail_Address_Reference__c) || ((!TriggerRecursiveCheck.ALAddressCheck) && acclnk.toRole__r.Primary_Address_Reference__c != null  &&  string.isblank(acclnk.Retail_Address_Reference__c))){
				acclnk.Retail_Address_Reference__c=acclnk.toRole__r.Primary_Address_Reference__c;
                acclnk.Retail_Address_Type__c = acclnk.toRole__r.Primary_Address_Reference__r.Address_Type__c;
                acclnk.Retail_Province__c = (acclnk.toRole__r.Primary_Address_Reference__r.Province__c !=null ?acclnk.toRole__r.Primary_Address_Reference__r.Province__c: '' );
                acclnk.Retail_City__c = (acclnk.toRole__r.Primary_Address_Reference__r.District__c != null ? acclnk.toRole__r.Primary_Address_Reference__r.District__c:'').left(35);
                acclnk.Retail_Distinct__c = ((acclnk.toRole__r.Primary_Address_Reference__r.District__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.District__c : '')+' '+(acclnk.toRole__r.Primary_Address_Reference__r.Block__c!= null ?acclnk.toRole__r.Primary_Address_Reference__r.Block__c : '')).left(17);
                acclnk.Retail_Address_Line_1__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c:'').left(35);
                acclnk.Retail_Address_Line_2__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c:'').left(35);
				acclnk.Retail_Address_Line_3__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_3__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_3__c:'').left(35);
                acclnk.Retail_ZipCode__c = (acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c : '' );
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate);
            }//End if for Sales Address
            AccountlnkUpdate.add(acclnk); //Adding Account link to Lsit  
        }//End of for loop
        if(!AccountlnkUpdate.isEmpty())
            DMLManagerService.updateAsSystem(AccountlnkUpdate);
    }//End of Method  

    /** To generate UCID value based on Record type.
    ** To Create Account link Record.
    ** Created By: Mohammed Touseef Ahmed
    ** Date: 12th Feb 2017 
    **/
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
                        acclink.RecordTypeId = accountinkIndividualCustomerExternalLinkId ;
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

    /**Implemented as part of the ticket SFDCTH-509 by Suresh Panduga**/
    public Static void UpdateConsentHistory(Map<Id,Account> oldAccountMap, List<Account> newAccountList){
        List<Account_Field_History_Tracker__c> consentHistoryList = new List<Account_Field_History_Tracker__c>();
        for(Account acc : newAccountList){
            if(!String.isBlank(oldAccountMap.get(acc.Id).Personal_Agreement__c) || oldAccountMap.get(acc.Id).Lastest_Consent_Date__c != null){
                if(acc.Personal_Agreement__c != oldAccountMap.get(acc.Id).Personal_Agreement__c || acc.Lastest_Consent_Date__c != oldAccountMap.get(acc.Id).Lastest_Consent_Date__c){
                    Account_Field_History_Tracker__c consentHistory = new Account_Field_History_Tracker__c();
                    consentHistory.Account_Record_Id__c = acc.Id;
                    consentHistory.Personal_Agreement__c = oldAccountMap.get(acc.Id).Personal_Agreement__c;
                    consentHistory.System_Data_Source__c = oldAccountMap.get(acc.Id).System_Data_Source__c;
                    consentHistory.Updated_Consent_Date__c = oldAccountMap.get(acc.Id).Updated_Consent_Date__c;
                    consentHistory.Updated_Consent_User__c = oldAccountMap.get(acc.Id).Updated_Consent_User__c;
                    consentHistory.User_Organization__c = oldAccountMap.get(acc.Id).User_Organization__c;
                    consentHistory.Lastest_Consent_Date__c = oldAccountMap.get(acc.Id).Lastest_Consent_Date__c;
                    consentHistoryList.add(consentHistory);
                }
            }
        }
        if(!consentHistoryList.isEmpty()){
            DMLManagerService.InsertAsSystem(consentHistoryList);
        }
    }

    //implemented "MD__c" field as a parameter as well so that the same will be picked and sent dynamically to EP as part of webservice 21/09/2016 Sekhar
    @Future(callout=true)   
    public static void entityNotifyUpdate(string updateType,String sfdcId,String MarketDiscriminator,string serlializedObject){
        string sfdcMarketDiscriminator = MarketDiscriminator;
        string orgId=UserInfo.getOrganizationId();       
        string sfdcTypeName='Account';
        if(!test.isrunningtest())            
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
    }
    
    /*
    SN20170929- Added code for create and update of data for ucid.
    */
    public static void createUpdateCDMUCID(string updateType, string MarketDiscriminator, list <account> accountlist){
        try{
            set<ID> accids=new set<ID>();
            for(Account accrec : accountlist){
                if(accrec.RecordTypeID == accPerson_RecordTypeId || accrec.RecordTypeID == accCompany_RecordTypeId){
                    accids.add(accrec.id);
                    }
            }
            if(accids.size()>0){
                CDMInformatica_Services.createCustomerCDM(accids,MarketDiscriminator,updateType);
            }
        }Catch(exception e){
            CustomLogUtil.CustomLoggingEntry(' AccountHelper th Exception Occurred '+e+'-'+e.getlinenumber());
        }
    }
	
	// Added by Laqshay Arora as a part of jira ticket - SM1-389
    public static void updatePrimaryAddressDetailsOnALK(List<Account> newAcc, Map<ID, Account> oldAccMap){
	Map<ID, Account> mAccount = new Map<ID, Account>();
	Map<id, List<Account_link__c>> mAccToALK = new Map<id, List<Account_link__c>>();
	
	for(Account acc: newAcc){
		if(acc.primary_address_reference__c != null && acc.primary_address_reference__c != oldAccMap.get(acc.id).primary_address_reference__c){
			mAccount.put(acc.ID, acc);
		}
	}
	List<Account_link__c> lALK = new List<Account_link__c>([Select id, toRole__c, Retail_Address_Reference__c from Account_link__c where toRole__c in : mAccount.values()]);
	if(lALK.size() > 0){
            for(Account_link__c alk : lALK){
                alk.Retail_Address_Reference__c = mAccount.get(alk.toRole__c).primary_address_reference__c;
            }
            try{
                update lALK;
            }
            catch(Exception e){
                System.debug('Not able to update the related retail copies ' + e.getMessage());
            }
		}
	}
	
    /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List<Account> accList){        
        for(Account acc : accList){
            if(Test.isRunningTest()){
                acc.isTestRunning__c=true;
            }
            if(acc.Market__c =='' || acc.Market__c==NULL){
                acc.Market__c=acc.MD__c;
            }  
        }       
    }
    
    
    public static void updateAccountStatusFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null){
            for(Account Acc : listNewAccounts){
                Account OldAcc = accountOldMap.get(Acc.id);
                
                
                if(Acc.Email__c!= OldAcc.Email__c){
                    //Acc.PersonEmail = Acc.Email__c;
                    Acc.Email_Status__c = '';
                }

                if(Acc.Mobile__c != OldAcc.Mobile__c){
                    Acc.Mobile_Status__c = '';
                    
                }   
                
            }
        }
    }
}