/**
* Utility for Trigger on Account for TH(Thailand)
* Author: Mohammed Touseef Ahmed
* Created Date : 2017-01-23
*/

public class AccountHelperTH{

       /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are inserted.
    **  Created By: Mohammed Touseef Ahmed
    **  Date: 2017-20-02
    **/
        public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       public static Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert)
    {
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
        {
            for(Account Acc : listNewAccounts)
            {
                
                if(Acc.Mobile__c != Null && Acc.Mobile__c != '')
                {
                    Acc.SMS_Last_Modified_By__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c = System.now();
                }   
                
                if(Acc.Mobile2__c!= Null && Acc.Mobile2__c != '')
                {
                    Acc.SMS_Last_Modified_By2__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Individual_Home_Phone__c!= Null && Acc.Individual_Home_Phone__c != '')
                {
                    Acc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Home_Phone_2__c != Null && Acc.Home_Phone_2__c != '')
                {
                    Acc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Work_Phone__c!= Null && Acc.Work_Phone__c != '')
                {
                    Acc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Phone!= Null && Acc.Phone != '')
                {
                    Acc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Email__c!= Null && Acc.Email__c != '')
                {
                    Acc.Email_Last_Modified_By__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Email2__c!= Null && Acc.Email2__c != '')
                {
                    Acc.Email_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Email3__c!= Null && Acc.Email3__c != '')
                {
                    Acc.Email_Last_Modified_By3__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = System.now();
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
           if(acc.MD__c == Label.TH){
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
    for(Account acc: listNewAccounts)
    {
    for(Address__c add: addressList)
    if(acc.MD__c == Label.TH){
               if(acc.Postal_Opt_Out__c){
                   if(add.Opt_In_Hardcopy__c== true){ 
                        add.Opt_In_Hardcopy__c = false;
                        addressupdatelst.add(add);
                    }
                } 
                } 
                }
    
    update addressupdatelst;
    }
    
   
    /**
    * Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
    */
    public static void updateOnEmailOptout(list<Account> listNewAccounts){        
        for(Account acc: listNewAccounts){
            if(acc.MD__c == Label.TH){
                if(acc.PersonHasOptedOutOfEmail){
                    if(acc.Opt_In_Email__c){ acc.Opt_In_Email__c = FALSE;}
                    if(acc.Opt_In_Email2__c){ acc.Opt_In_Email2__c = FALSE;}
                    if(acc.Opt_In_Email3__c){ acc.Opt_In_Email3__c = FALSE;}
                }
            }
        }
    }
    
    /**
    * Calculate “Age Range” based on birthdate.
    */
    public static void updateAgeRange(list<Account> listNewAccounts){
        for(Account acc:  listNewAccounts){
            if(acc.PersonBirthdate != NULL){
                if(acc.MD__c == Label.TH){
                   Integer ageInt = (Integer.valueOf(System.today().year())-Integer.valueof(acc.PersonBirthdate.year()) );
                   acc.Age_Range__c = AccountHelperTH.calculateAgeRange(ageInt); 
                }
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
	public static void activeContracts(list<Account> listNewAccounts)
	{
		integer actContract=0;
		Set<Id> AccIdSet = new Set<Id>();
		for(Account acc : listNewAccounts)
		{                                  
			AccIdSet.add(acc.id);          
		}
		List<contract> lstCntrct=[select id,StartDate,EndDate,ContractTerm,Account.id 
										 from contract where Account.id in : AccIdSet];      

		for(Account acc : listNewAccounts)
		{                                  
				  for(contract cntrct: lstCntrct)
				  {
					  if(cntrct.EndDate.daysBetween(cntrct.StartDate)<cntrct.ContractTerm)
					  {
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
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate)
    {
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
        {
            for(Account Acc : listNewAccounts)
            {
                Account OldAcc = accountOldMap.get(Acc.id);
                if(Acc.Mobile__c != OldAcc.Mobile__c)
                {
                    Acc.SMS_Last_Modified_By__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date__c = System.now();
                }   
                
                if(Acc.Mobile2__c!= OldAcc.Mobile2__c )
                {
                    Acc.SMS_Last_Modified_By2__c = UserInfo.getName();
                    Acc.SMS_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Individual_Home_Phone__c!= OldAcc.Individual_Home_Phone__c)
                {
                    Acc.Home_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Home_Phone_2__c != OldAcc.Home_Phone_2__c)
                {
                    Acc.Home_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Home_Phone_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Work_Phone__c!= OldAcc.Work_Phone__c)
                {
                    Acc.Work_Phone_Last_Modified_By__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Phone!= OldAcc.Phone)
                {
                    Acc.Work_Phone_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Work_Phone_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Email__c!= OldAcc.Email__c)
                {
                    Acc.Email_Last_Modified_By__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Email2__c!= OldAcc.Email2__c)
                {
                    Acc.Email_Last_Modified_By2__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date2__c = System.now();
                }
                
                if(Acc.Email3__c!= OldAcc.Email3__c)
                {
                    Acc.Email_Last_Modified_By3__c = UserInfo.getName();
                    Acc.Email_Last_Modified_Date3__c = System.now();
                }
                
            }
            
        }
    }
    /** Upadte Primary address display field based on primary address reference lookup field.
** Created By: Mohammed touseef Ahmed
** Date: 2017-20-02
**/
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate)    
    {
        Map<Id,Address__c> addr;
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
        {
            string regexForNullValue ='null';
            string nullValue ='';
            set<id> addressid = new set<id>();                  
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            For(Account a:listNewAccounts)
            {      
                if(a.MD__c == Label.TH)
                {                    
                    addressid.add(a.Primary_Address_Reference__c);
                }
            }
            If(!addressid.isEmpty())
            {   
                addr = new map<id,Address__c>([select Customer__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c from Address__c where id In : addressid]);            
            }
            For(Account acc:listNewAccounts)
            {      
                if( acc.MD__c == Label.TH)
                {   
                    If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null)
                    {              
                        Address__c add = addr.get(acc.Primary_Address_Reference__c);
                        if(addtrmap1.containsKey(add.Province__c))
                        {
                            province = addtrmap1.get(add.Province__c);
                        }
                        acc.Primary_Address_Display__c = province+ add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;
                        acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);                        
                    }
                    else if(acc.Primary_Address_Reference__c ==Null)
                    {
                        acc.Primary_Address_Display__c ='';
                    }
                    
                }
            }     
            
            
        }    
    } 
    
    //Creates a retail copy of account on as account link
    //Mohammed Touseef
    //02/20/2017
      public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate)
    {
        User usr = [select id,Name,ContactId,contact.AccountId,Profile.UserLicense.Name,Contact.Account.Dealer_ND_Code__c from user where Id =: UserInfo.getUserId()];
        if(usr.Profile.UserLicense.Name == 'Partner Community')
        {
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
            UtilAddressTranslation.gettranslatedvalues('TH');
            for(Account acc : accLst)
            {
                system.debug('accountLanguage>>>' + acc.Preferred_Language__c);
                if(acc.MD__c == 'TH')
                {
                    accid.add(acc.Id);
                }
            }
            if(!accid.isEmpty() && accid != null)
            {
                addressList = [select id,Address_Type__c,City__c,District__c,Address_Line_1__c,Address_Line_2__c,Customer__c,Preferred__c,
                               ZipCode__c,Province__c,CreatedDate,LastModifiedDate from Address__c where Customer__c =:accid AND Preferred__c = true];   
              retailCopyList = [select id from Account_Link__c where toRole__c =:accid AND fromRole__c =:usr.Contact.AccountId AND (RecordtypeId =:retailPerson_RecordTypeId OR RecordtypeId =:retailCompany_RecordTypeId)];
            }
            if(retailCopyList.isEmpty())
            {
                for(Account retailacc: accLst)
                {
                    Account_Link__c acclnk = new Account_Link__c();
                    if(retailacc.RecordTypeId == accCompany_RecordTypeId)
                    {
                        acclnk.Retail_UCID__c = retailacc.UCID__c;
                        acclnk.RecordTypeId = retailCompany_RecordTypeId;
                        acclnk.fromRole__c = usr.Contact.AccountId;
                        acclnk.toRole__c = retailacc.Id;
                        acclnk.Retail_DMS_Customer_ID__c = retailacc.DMS_Customer_ID__c;                 
                        acclnk.Retail_Company_Name__c = retailacc.Company_Name__c;
                        acclnk.Retail_Email_OptOut__c = retailacc.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = retailacc.PersonHasOptedOutOfFax;
                        acclnk.Retail_Primary_Phone__c = retailacc.Primary_Phone_Display__c;
                        acclnk.Retail_Sales_Sanction__c = retailacc.Sales_Sanction__c;
                        acclnk.Retail_Phone_OptOut__c = retailacc.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = retailacc.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = retailacc.Visit_Opt_Out__c;
                        acclnk.Retail_Fax__c = retailacc.fax;                        
                        acclnk.Retail_Industry__c = retailacc.Industry;
                        acclnk.Retail_Commercial_Reg_No__c = retailacc.Commercial_Reg_No__c;
                        acclnk.Retail_Vat_No__c = retailacc.Vat_No__c;                        
                        acclnk.Retail_WebSite__c = retailacc.Website;
                        acclnk.Retail_Agreement__c = retailacc.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = retailacc.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = retailacc.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = retailacc.Agreement_to_commit_info_processing__c;
                        if(retailacc.Foundation_Date__c != null)
                        {
                            acclnk.Retail_Foundation_Month__c = String.ValueOf(retailacc.Foundation_Date__c.month())+String.valueOf(retailacc.Foundation_Date__c.year());
                        }
                    }
                    else if(retailacc.RecordTypeId == accPerson_RecordTypeId)
                    {
                        acclnk.RecordTypeId = retailPerson_RecordTypeId; 
                        acclnk.fromRole__c = usr.Contact.AccountId; 
                        acclnk.toRole__c = retailacc.Id;   
                        acclnk.Retail_DMS_Customer_ID__c = retailacc.DMS_Customer_ID__c;
                        acclnk.Retail_Full_Name__c = retailacc.Name;
                        acclnk.Retail_LastName__c =  retailacc.LastName;
                        acclnk.Retail_FirstName__c = retailacc.FirstName;                      
                        acclnk.Retail_Complaint_Amount__c = retailacc.Complaint_Amount__c;
                        acclnk.Retail_Sales_Sanction__c = retailacc.Sales_Sanction__c;
                        acclnk.Retail_UCID__c = retailacc.UCID__c;
                        acclnk.Retail_Allow_Data_Sharing__c = retailacc.Allow_Data_Sharing__c;
                        acclnk.Retail_Mobile__c = retailacc.PersonMobilePhone;
                        acclnk.Retail_Individual_Home_Phone__c = retailacc.Individual_Home_Phone__c;
                        acclnk.Retail_Work_Phone__c = retailacc.Work_Phone__c;
                        acclnk.Retail_Email__c = retailacc.PersonEmail;
                        acclnk.Retail_Fax__c =retailacc.Fax;
                        acclnk.Retail_Preferred_Contact_Method__c = retailacc.Preferred_Contact_Method__c;
                        acclnk.Retail_Email_OptOut__c = retailacc.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = retailacc.PersonHasOptedOutOfFax;
                        acclnk.Retail_Primary_Phone__c = retailacc.Primary_Phone_Display__c;
                        acclnk.Retail_Phone_OptOut__c = retailacc.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = retailacc.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = retailacc.Visit_Opt_Out__c;
                        acclnk.Retail_PersonBirthdate__c = retailacc.PersonBirthdate;                     
                        acclnk.Retail_Occupation__c = retailacc.Occupation__c;
                        acclnk.Retail_Position__c = retailacc.Job__c;
                        acclnk.Retail_Preferred_Language__c = 'Thai';
                        acclnk.Retail_Gender__c = retailacc.Gender__c;
                        acclnk.Retail_Industry__c = retailacc.industry;
                        acclnk.Retail_WebSite__c = retailacc.Website; 
                        acclnk.Retail_Company_Name_Native1__c = retailacc.Company_Name_Native_1__c; 
                        acclnk.Retail_Commercial_Reg_No__c = retailacc.Commercial_Reg_No__c;
                        acclnk.Retail_Company_Phone__c = retailacc.Individual_Home_Phone__c;
                        acclnk.Retail_Company_Other_Phone__c = retailacc.Work_Phone__c; 
                        acclnk.Retail_Agreement__c = retailacc.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = retailacc.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = retailacc.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = retailacc.Agreement_to_commit_info_processing__c;
                        acclnk.Retail_Vat_No__c = retailacc.Vat_No__c;
                        if(retailacc.Foundation_Date__c != null)
                        {
                            acclnk.Retail_Foundation_Month__c = String.ValueOf(retailacc.Foundation_Date__c.month())+String.valueOf(retailacc.Foundation_Date__c.year());
                        }
                    }
                    if(!addressList.isEmpty() && addressList != null)
                    {
                        for(Address__c add : addressList)
                        {
                            if(add.Customer__c == retailacc.Id)
                            {
                                acclnk.Retail_Address_Reference__c = add.Id;
                                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(add.CreatedDate);
                                acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(add.LastModifiedDate);
                                acclnk.Retail_Address_Type__c = add.Address_Type__c;
                                if(add.Address_Line_1__c != null && add.Address_Line_1__c != '')
                                {
                                    acclnk.Retail_Address_Line_1__c = add.Address_Line_1__c;
                                }
                                if(add.Address_Line_2__c != null && add.Address_Line_2__c != '')
                                {
                                    acclnk.Retail_Address_Line_1__c = add.Address_Line_2__c;
                                }
                                if(add.ZipCode__c != null && add.ZipCode__c != '')
                                {
                                    acclnk.Retail_ZipCode__c = add.ZipCode__c;
                                }
                                if(add.City__c != null && add.City__c != '')
                                {
                                    acclnk.Retail_City__c = add.City__c;
                                }
                                if(add.District__c != null && add.District__c != '')
                                {
                                    acclnk.Retail_Distinct__c = add.District__c;
                                }
                                if(addtrmap1.containsKey(add.Province__c))
                                {
                                    acclnk.Retail_Province__c = addtrmap1.get(add.Province__c);
                                }
                                acclnk.Retail_Province__c = acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                            }
                        }
                    }
                insertAcclnkList.add(acclnk);
            }
        }
            if(!insertAcclnkList.isEmpty() && insertAcclnkList != null)
            {
                insert insertAcclnkList;
            }
            
            if(usr != null)
            {
                dealergrpList = [select id ,DeveloperName ,Name ,Type from Group where Name =:usr.Contact.Account.Dealer_ND_Code__c];
            }
            system.debug('dealergrpList>>>>' + dealergrpList);
            if(!dealergrpList.isEmpty() && dealergrpList != null)
            {
                for(Group g : dealergrpList)
                {
                   dealerGroupMap.put(g.Name, g.Id);
                }
            }
            system.debug('dealerGroupMap>>>' + dealerGroupMap);
            for(Account shareacc : accLst)
            {
                if(!dealerGroupMap.isEmpty() && dealerGroupMap.get(usr.Contact.Account.Dealer_ND_Code__c) != null && shareacc.OwnerId != usr.Id)
                {
                    AccountShare accshr = new AccountShare();
                    accshr.AccountId = shareacc.Id;
                    accshr.AccountAccessLevel = 'Edit';
                    accshr.CaseAccessLevel = 'None';
                    accshr.OpportunityAccessLevel = 'None';
                    accshr.UserOrGroupId = dealerGroupMap.get(usr.Contact.Account.Dealer_ND_Code__c);
                    insertAccshList.add(accshr);
                }
            }
            system.debug('insertAccshList>>>>' + insertAccshList);
            if(!insertAccshList.isEmpty() && insertAccshList != null)
            {
                insert insertAccshList;
            }
        }
    }
     
        /*
        # Description:This method will update the retail copy when related Account(Account 1) is updated. 
        # Date: 02/20/2017
        # Author : Mohammed Touseef Ahmed
        */
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){        

        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        for(Account acc : accLst){
            if(isUpdate && acc.MD__c == label.MarketTH){ //Checking Market for updated account
                AccountIds.add(acc.id); //Adding accountId's to set        
            }
            
        }
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        List<Account_Link__c> Accountlinklist = [select id,Name,toRole__r.RecordType.Name, toRole__r.LastName, toRole__r.FirstName, toRole__r.Salutation__c, toRole__r.LastName_Native_1__c,
                                                toRole__r.FirstName_Native_1__c, toRole__r.Gender__c, toRole__r.PersonBirthdate, toRole__r.Occupation__c, toRole__r.Industry, 
                                                toRole__r.Preferred_Language__c, toRole__r.Primary_Phone__c, toRole__r.Special_Care__c, toRole__r.Special_Needs_Class__c,
                                                toRole__r.Allow_Data_Sharing2__c, toRole__r.Individual_Home_Phone__c, toRole__r.Work_Phone__c, toRole__r.Mobile__c, toRole__r.Fax,
                                                toRole__r.Email__c,toRole__r.Primary_Address_Reference__r.Address_Type__c, toRole__r.Primary_Address_Reference__r.Province__c,
                                                toRole__r.Primary_Address_Reference__r.City__c, toRole__r.Primary_Address_Reference__r.District__c, toRole__r.Primary_Address_Reference__r.Block__c,
                                                toRole__r.Primary_Address_Reference__r.Address_Line_1__c, toRole__r.Primary_Address_Reference__r.Address_Line_2__c, toRole__r.Primary_Address_Reference__r.ZipCode__c,
                                                toRole__r.Name, toRole__r.Company_Name_Native_1__c, toRole__r.Commercial_Reg_No__c, toRole__r.Vat_No__c, 
                                                toRole__r.Foundation_Date__c, toRole__r.Website, toRole__r.Primary_Address_Reference__r.CreatedDate,
                                                toRole__r.Primary_Address_Reference__r.LastModifiedDate,toRole__r.MBTH_Nationality__c,toRole__r.Preferred_Radio_Station__c,toRole__r.Personal_Agreement__c,toRole__r.MBTH_Mercede__c,
                                                toRole__r.First_Consent_Date__c,toRole__r.Updated_Consent_Date__c,toRole__r.First_Consent_User__c,toRole__r.Updated_Consent_User__c
                                                from Account_Link__c WHERE toRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany )];

        //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist ){
            if(acclnk.toRole__r.RecordType.Name == 'Person Account') {
                acclnk.Retail_LastName__c = acclnk.toRole__r.LastName;
                acclnk.Retail_FirstName__c = acclnk.toRole__r.FirstName;
                //acclnk.Retail_Salutation__c = acclnk.toRole__r.Salutation__c;
                acclnk.Retail_Full_Name__c = ((acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName:'') + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'')).left(25); 
                acclnk.Retail_Full_Name_Title__c = ((acclnk.toRole__r.Salutation__c!= null ? acclnk.toRole__r.Salutation__c: '')+(acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName:'') + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'')).left(140);
                acclnk.Retail_LastName_Native__c = acclnk.toRole__r.LastName_Native_1__c;
                acclnk.Retail_FirstName_Native__c = acclnk.toRole__r.FirstName_Native_1__c; 
                acclnk.Retail_Gender__c = acclnk.toRole__r.Gender__c;
                acclnk.Retail_PersonBirthdate__c = acclnk.toRole__r.PersonBirthdate;
                acclnk.Retail_Occupation__c = acclnk.toRole__r.Occupation__c;                
                acclnk.Retail_Preferred_Language__c = acclnk.toRole__r.Preferred_Language__c;
                acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone__c;
                acclnk.Retail_Special_Care__c = acclnk.toRole__r.Special_Care__c;
                acclnk.Retail_Special_Needs_Class__c = acclnk.toRole__r.Special_Needs_Class__c;
                acclnk.Retail_Allow_Data_Sharing__c = acclnk.toRole__r.Allow_Data_Sharing2__c;                
                acclnk.Retail_Work_Phone__c = acclnk.toRole__r.Work_Phone__c;
                acclnk.Retail_Mobile__c = acclnk.toRole__r.Mobile__c;                
                acclnk.Retail_Email__c = acclnk.toRole__r.Email__c;
                //acclnk.Position__c= acclnk.toRole__r.Position__c;
                acclnk.Retail_List_of_Events__c= acclnk.toRole__r.MBTH_Mercede__c;
                acclnk.Retail_Race__c= acclnk.toRole__r.MBTH_Nationality__c;
                acclnk.Retail_Prefered_Radiostation__c= acclnk.toRole__r.Preferred_Radio_Station__c;
                acclnk.Retail_Agreement__c= acclnk.toRole__r.Personal_Agreement__c;
                acclnk.Retail_First_Consent_Date__c= acclnk.toRole__r.First_Consent_Date__c;
                acclnk.Retail_Updated_Consent_Date__c= acclnk.toRole__r.Updated_Consent_Date__c;
                acclnk.Retail_First_Consent_User__c= acclnk.toRole__r.First_Consent_User__c;
                acclnk.Retail_Updated_Consent_User__c= acclnk.toRole__r.Updated_Consent_User__c;


                


            }
            //Checking the Company RecordType
            if(acclnk.toRole__r.RecordType.Name=='Company'){ 
                acclnk.Retail_Company_Name__c = acclnk.toRole__r.Name;
                acclnk.Retail_Company_Name_Native1__c = acclnk.toRole__r.Company_Name_Native_1__c;
                acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c;
                acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c;
                if(acclnk.toRole__r.Foundation_Date__c != null)
                    acclnk.Retail_Foundation_Month__c = string.valueOf(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());         
            }//End if for Company record type
            acclnk.Retail_Industry__c = acclnk.toRole__r.Industry; 
            acclnk.Retail_Website__c = acclnk.toRole__r.website;
            acclnk.Retail_Individual_Home_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
            acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
            
            //Checking Null for sales Address 
            if(acclnk.toRole__r.Primary_Address_Reference__c != null){ 
                    acclnk.Retail_Address_Type__c = acclnk.toRole__r.Primary_Address_Reference__r.Address_Type__c;
                    acclnk.Retail_Province__c = (acclnk.toRole__r.Primary_Address_Reference__r.Province__c !=null ?acclnk.toRole__r.Primary_Address_Reference__r.Province__c: '' );
                    acclnk.Retail_City__c = (acclnk.toRole__r.Primary_Address_Reference__r.City__c != null ? acclnk.toRole__r.Primary_Address_Reference__r.City__c:'').left(17);
                    acclnk.Retail_Distinct__c = ((acclnk.toRole__r.Primary_Address_Reference__r.District__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.District__c : '')+(acclnk.toRole__r.Primary_Address_Reference__r.Block__c!= null ?acclnk.toRole__r.Primary_Address_Reference__r.Block__c : '')).left(17);
                    acclnk.Retail_Address_Line_1__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclnk.Retail_Address_Line_2__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    acclnk.Retail_ZipCode__c = (acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c : '' );
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate);

                }//End if for Sales Address
            
            AccountlnkUpdate.add(acclnk); //Adding Account link to Lsit  
        }//End of for loop
        
        if(!AccountlnkUpdate.isEmpty())
            update AccountlnkUpdate;
    }//End of Method  
    
    
    /** To generate UCID value based on Record type.
    ** To Create Account link Record.
    ** Created By: Mohammed Touseef Ahmed
    ** Date: 12th Feb 2017 
    **/
        
    public static void createUCID(list<Account> TriggerNew,boolean isInsert)
    {
        try
        {
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
            Id accountinkIndividualCustomerExternalLinkId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
            for(Account acc : TriggerNew)
            {
                AccIds.add(acc.id);              
            }    
            if(!AccIds.isEmpty() && AccIds != Null)
            {
                accountlist = [select id,RecordTypeId,UCID__c,UCID_Sequence__c,MD__c from account where id in :AccIds];
                if(!accountlist.isEmpty() && accountlist != Null)
                {
                    for(Account acc : accountlist)
                    {                        
                        
                        if(acc.RecordTypeId == accPerson_RecordTypeId && acc.MD__c == Label.TH){
                            ucidsequence = 'THP' + acc.UCID_Sequence__c;                
                        }
                        else
                            if(acc.RecordTypeId == accCompany_RecordTypeId && acc.MD__c == Label.TH){
                                ucidsequence = 'THC' + acc.UCID_Sequence__c;                
                            }
                        
                        
                        if(ucidsequence != null && ucidsequence.length() > 0)
                        {
                            for (i=0; i < 14; i++)
                            { 
                                integer cp = ucidsequence.codePointAt(i); 
                                checksum += cp; 
                            }
                            
                            ucidsequence += checksumSet.substring(mod, mod+1);
                            acc.UCID__c = ucidsequence;
                            acclist.add(acc);
                        }
                        
                    }
                    update acclist;
                    map<id,Account> accountmap = new map<id,Account>([select Id,UCID__c,Name from Account where id In : AccIds]);
                    for(Account acc : accountlist)
                    {
                        Account account = accountmap.get(acc.Id);
                        Account_Link__c acclink = new Account_Link__c();
                        acclink.Primary__c = true;
                        acclink.Origin__c = account.Name;
                        acclink.toRole__c = account.Id;
                        acclink.System__c = 'UCID';
                        acclink.RecordTypeId = accountinkIndividualCustomerExternalLinkId ;
                        acclink.Name = account.UCID__c;                        
                        acclinklist.add(acclink);
                        
                    }
                    insert acclinklist;
                }
            }
        }
        catch(DMLException ex)
        {
            
            CustomLogUtil.DebugException(ex);
        }
        CustomLogUtil.DebugLogInsert();
        
    } 
    
   //implemented "MD__c" field as a parameter as well so that the same will be picked and sent dynamically to EP as part of webservice 21/09/2016 Sekhar
    @Future(callout=true)   
    public static void entityNotifyUpdate(string updateType,String sfdcId,String MarketDiscriminator,string serlializedObject)
    {
       string sfdcMarketDiscriminator = MarketDiscriminator;
       string orgId=UserInfo.getOrganizationId();       
       string sfdcTypeName='Account';
        if(!test.isrunningtest())            
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
        
        
    }
     
    
}