/**
* Utility for Trigger on Account for KR(Korea)
* Author: Chethan A
* Created Date : 2016-08-05
*/

public class AccountHelperKR
{
    
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static boolean persongroup1 = false;
    public static boolean persongroup2 = false;
    public static boolean persongroup3 = false;
    public static boolean persongroup4 = false;
    public static boolean persongroup5 = false;
    public static boolean persongroup6= false;
    public static boolean persongroup7=false;
    public static boolean persongroup8 = false;
    public static boolean persongroup9 = false;
    public static boolean persongroup10 = false;
    public static boolean companygroup1 = false;
    public static boolean companygroup2=false;
    /**
* Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are inserted. 
*/
    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert)
    {   
        AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,Trigger.isInsert);
    }
    
    /**
* Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are updated. 
*/    
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate)
    {
        AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
    }
    
    /**
* Update primary address details from the associated preferred address records.
*/
    /*   
public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate)
{
    //AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
    Map<Id,Address__c> addr;
    If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
    {
        string regexForNullValue ='null';
        string nullValue ='';
        set<id> addressid = new set<id>();                  
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('KR');
    For(Account a:listNewAccounts)
    {      
        if(a.MD__c == 'KR')
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
    	if(acc.MD__c == 'KR')
    	{   
            If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null)
            {              
        		Address__c add = addr.get(acc.Primary_Address_Reference__c);
        		if(addtrmap1.containsKey(add.Province__c))
        		{
                	province = addtrmap1.get(add.Province__c);
                }
        acc.Primary_Address_Display__c = province+ add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + add.Address_Line_2__c ;
        acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
        system.debug(')&)^%$%&&*(**^^^^'+acc.Primary_Address_Display__c);
        	}
        		else if(acc.Primary_Address_Reference__c ==Null)
        		{
        			acc.Primary_Address_Display__c ='';
        		}
        
        	}
    	}     
    
    }            
}
*/
    /**
* Implement Do Not Call(PersonDoNotCall) to automate opt-out for all channels which means that selecting this flag opts out the customer from 
*  being contacted via all Phone numbers (Ex: Home Phone, Mobile, Work Phone).   
*/
    public static void updateOnDoNotCall(list<Account> listNewAccounts)
    {
        // Opt_In_Home_Phone__c , Opt_In_Home_Phone2__c , Opt_In_Work_Phone__c , Opt_In_Work_Phone2__c
        
        for(Account acc : listNewAccounts)
        {
            if(acc.MD__c == 'KR')
            {
                if(acc.PersonDoNotCall)
                {
                    if(acc.Opt_In_Home_Phone__c)
                    { 
                        acc.Opt_In_Home_Phone__c = FALSE;
                    }
                    if(acc.Opt_In_Home_Phone2__c)
                    {
                        acc.Opt_In_Home_Phone2__c = FALSE;
                    }
                    if(acc.Opt_In_Work_Phone__c )
                    {
                        acc.Opt_In_Work_Phone__c = FALSE;
                    }
                    if(acc.Opt_In_Work_Phone2__c)
                    {
                        acc.Opt_In_Work_Phone2__c = FALSE;
                    }
                    if(acc.Preferred_Mobile_1__c)
                    {
                        acc.Preferred_Mobile_1__c = FALSE;
                    }
                    if(acc.Preferred_Mobile_2__c)
                    {
                        acc.Preferred_Mobile_2__c = FALSE;
                    }
                }
            } 
        }
    }
    
    /*
* Implement Postal_Opt_Out__c to automate opt-out for all addresses which means that selecting this flag opts out the customer from being contacted 
*   via Addresses (Ex: Home Address, Office Address, etc.).
*/
    public static void updateOnPostalOptout(list<Account> listNewAccounts)
    {
        system.debug('@@@@@@ listNewAccounts'+listNewAccounts);
        List<Address__c> addressupdatelst = new list<Address__c>();
        List<Address__c> addressList = new list<Address__c>();
        Set<Id> Accid=new Set<Id>();
        Set<Id> Addd=new Set<Id>();
        for(Account acc: listNewAccounts)
        {
            Accid.add(acc.id);
            Addd.add(acc.Primary_Address_Reference__c);
            
            
            // NEED INPUTS FOR IMPLEMENTATION
        }
        system.debug('@@@@@@ Addd'+Addd);
        addressList =[select id,Opt_In_Hardcopy__c from Address__c where id=:Addd];
        for(Account acc: listNewAccounts)
        {
            for(Address__c add: addressList)
                if(acc.MD__c == 'KR')
            {
                if(acc.Postal_Opt_Out__c)
                {
                    if(add.Opt_In_Hardcopy__c== true)
                    { 
                        add.Opt_In_Hardcopy__c = false;
                        addressupdatelst.add(add);
                    }
                } 
            } 
        }
        
        update addressupdatelst;
        system.debug('@@@@@@ addressupdatelst'+addressupdatelst);
    }
    
    
    /**
* Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
*/
    public static void updateOnEmailOptout(list<Account> listNewAccounts)
    {
        // PersonHasOptedOutOfEmail  , Opt_In_Email__c , Opt_In_Email2__c   , Opt_In_Email3__c
        for(Account acc: listNewAccounts)
        {
            if(acc.MD__c == 'KR')
            {
                if(acc.PersonHasOptedOutOfEmail)
                {
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
    public static void updateAgeRange(list<Account> listNewAccounts)
    {
        // PersonBirthdate
        for(Account acc:  listNewAccounts)
        {
            if(acc.PersonBirthdate != NULL)
            {
                if(acc.MD__c == 'KR')
                {
                    Integer ageInt = (Integer.valueOf(System.today().year())-Integer.valueof(acc.PersonBirthdate.year()) );
                    acc.Age_Range__c = AccountHelperKR.calculateAgeRange(ageInt); 
                }
            }
        }
    }
    
    public static String calculateAgeRange(Integer ageInt)
    {
        if(17 <= ageInt && ageInt <= 25)
        {
            return '17-25';   
        }
        else if(26 <= ageInt && ageInt <= 35)
        {
            return '26-35';
        }
        else if( 36 <= ageInt && ageInt <= 45)
        {
            return '36-45';
        }
        else if( 46 <= ageInt && ageInt <= 55)
        {
            return '46-55';
        }
        else if(56 <= ageInt && ageInt <= 65)
        {
            return '56-65';
        }
        else if( 65 < ageInt)
        {
            return '65+';
        }
        else 
        {
            return 'Unknown';
        }
    }
    //Creating Retail copy from dealer #SFDCKR-696
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
            UtilAddressTranslation.gettranslatedvalues('KR');
            for(Account acc : accLst)
            {
                system.debug('accountLanguage>>>' + acc.Preferred_Language__c);
                if(acc.MD__c == 'KR')
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
                        acclnk.Retail_Occupation__c = retailacc.MBK_Occupation__c;
                        acclnk.Retail_Position__c = retailacc.Job__c;
                        acclnk.Retail_Preferred_Language__c = 'Korean';
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
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst , Map<Id,Account>oldAccountmap)
    {
        system.debug('------>Method is called');
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        //if(pilotdealer.Dealer_Rollout_Status__c =='Done'){
        for(Account acc : accLst)
        {
            if(isUpdate && acc.MD__c == 'KR')
            { //Checking Market for updated account
                if(oldAccountmap.get(Acc.id).LastName !=  acc.LastName || oldAccountmap.get(Acc.id).FirstName != acc.FirstName || oldAccountmap.get(Acc.id).LastName_Native_1__c != acc.LastName_Native_1__c || oldAccountmap.get(Acc.id).FirstName_Native_1__c != acc.FirstName_Native_1__c)
                {
                    AccountIds.add(acc.id); //Adding accountId's to set
                    persongroup1 = true;
                }
                if(oldAccountmap.get(Acc.id).Gender__c != acc.Gender__c || oldAccountmap.get(Acc.id).PersonBirthdate != acc.PersonBirthdate || oldAccountmap.get(Acc.id).MBK_Occupation__c != Acc.MBK_Occupation__c || oldAccountmap.get(Acc.id).Industry != acc.Industry || oldAccountmap.get(Acc.id).Preferred_Language__c != acc.Preferred_Language__c
                   ||oldAccountmap.get(Acc.id).Special_Care__c != acc.Special_Care__c || oldAccountmap.get(Acc.id).Special_Needs_Class__c != Acc.Special_Needs_Class__c)
                {
                    AccountIds.add(acc.id);
                    persongroup2 = true;
                }
                if(oldAccountmap.get(acc.id).Allow_Data_Sharing2__c != acc.Allow_Data_Sharing2__c)
                {
                    AccountIds.add(acc.id);
                    persongroup3 = true;
                }
                if(oldAccountmap.get(acc.id).Individual_Home_Phone__c != acc.Individual_Home_Phone__c)
                {
                    AccountIds.add(acc.id); 
                    persongroup4 = true;
                }
                if(oldAccountmap.get(acc.id).Work_Phone__c != acc.Work_Phone__c)
                {
                    AccountIds.add(acc.id);
                    persongroup5 = true;
                }
                if(oldAccountmap.get(acc.id).Mobile__c != acc.Mobile__c)
                {
                    AccountIds.add(acc.id);
                    persongroup6 = true;
                }
                if(oldAccountmap.get(acc.id).Fax != acc.Fax)
                {
                    AccountIds.add(acc.id); 
                    persongroup7= true;
                }
                if(oldAccountmap.get(acc.id).Email__c != acc.Email__c)
                {
                    AccountIds.add(acc.id);
                    persongroup8 = true;
                } 
                if(oldAccountmap.get(acc.id).Primary_Phone__c != acc.Primary_Phone__c)
                {
                    AccountIds.add(acc.id); 
                    persongroup10 = true;
                }  
                if(oldAccountmap.get(acc.id).Primary_Address_Reference__c  != acc.Primary_Address_Reference__c || oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Type__c != acc.Primary_Address_Reference__r.Address_Type__c
                   || oldAccountmap.get(acc.id).Primary_Address_Reference__r.Province__c != acc.Primary_Address_Reference__r.Province__c ||
                   oldAccountmap.get(acc.id).Primary_Address_Reference__r.City__c  != acc.Primary_Address_Reference__r.City__c  ||
                   oldAccountmap.get(acc.id).Primary_Address_Reference__r.District__c  != acc.Primary_Address_Reference__r.District__c ||
                   oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Line_1__c  != acc.Primary_Address_Reference__r.Address_Line_1__c ||
                   oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Line_2__c  != acc.Primary_Address_Reference__r.Address_Line_2__c ||
                   oldAccountmap.get(acc.id).Primary_Address_Reference__r.ZipCode__c  != acc.Primary_Address_Reference__r.ZipCode__c)
                {
                    AccountIds.add(acc.id); 
                    persongroup9 = true;
                }
                if(oldAccountmap.get(acc.id).Name != acc.Name || oldAccountmap.get(acc.id).Company_Name_Native_1__c != acc.Company_Name_Native_1__c || oldAccountmap.get(acc.id).Company_Name__c != acc.Company_Name__c)
                {
                    AccountIds.add(acc.id);
                    companygroup1 = true;
                }
                if((oldAccountmap.get(acc.id).Commercial_Reg_No__c != acc.Commercial_Reg_No__c || oldAccountmap.get(acc.id).Vat_No__c != acc.Vat_No__c || oldAccountmap.get(acc.id).Foundation_Date__c != acc.Foundation_Date__c
                    || oldAccountmap.get(acc.id).Industry != acc.Industry || oldAccountmap.get(acc.id).website != acc.website)&& acc.RecordTypeID == accCompany_RecordTypeId)
                {
                    AccountIds.add(acc.id);
                    companygroup2 = true;
                }
            }            
        }
        string regexForNullValue ='null';
        string nullValue ='';                            
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('KR');
        
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        List<Account_Link__c> Accountlinklist = [select id,Name,toRole__r.RecordType.Name,RecordTypeId,toRole__r.LastName, toRole__r.FirstName, toRole__r.Salutation__c, toRole__r.LastName_Native_1__c,
                                                 toRole__r.FirstName_Native_1__c, toRole__r.Gender__c, toRole__r.PersonBirthdate, toRole__r.Occupation__c,toRole__r.MBK_Occupation__c,toRole__r.Industry, 
                                                 toRole__r.Preferred_Language__c, toRole__r.Primary_Phone__c, toRole__r.Special_Care__c, toRole__r.Special_Needs_Class__c,toRole__r.Allow_Data_Sharing__c,
                                                 toRole__r.Allow_Data_Sharing2__c, toRole__r.Individual_Home_Phone__c, toRole__r.Work_Phone__c, toRole__r.Mobile__c, toRole__r.Fax,toRole__r.PersonEmail,
                                                 toRole__r.Email__c,toRole__r.Primary_Address_Reference__r.Address_Type__c, toRole__r.Primary_Address_Reference__r.Province__c,
                                                 toRole__r.Primary_Address_Reference__r.City__c, toRole__r.Primary_Address_Reference__r.District__c, toRole__r.Primary_Address_Reference__r.Block__c,
                                                 toRole__r.Primary_Address_Reference__r.Address_Line_1__c, toRole__r.Primary_Address_Reference__r.Address_Line_2__c, toRole__r.Primary_Address_Reference__r.ZipCode__c,
                                                 toRole__r.Name, toRole__r.Company_Name_Native_1__c, toRole__r.Commercial_Reg_No__c, toRole__r.Vat_No__c, 
                                                 toRole__r.Foundation_Date__c, toRole__r.Website, toRole__r.Primary_Address_Reference__r.CreatedDate,
                                                 toRole__r.Primary_Address_Reference__r.LastModifiedDate,toRole__r.UCID__c,toRole__r.Postal_Opt_Out__c,
                                                 toRole__r.DMS_Customer_ID__c,toRole__r.PersonHasOptedOutOfEmail,toRole__r.PersonHasOptedOutOfFax,toRole__r.Primary_Phone_Display__c,
                                                 toRole__r.Sales_Sanction__c,toRole__r.PersonDoNotCall,toRole__r.Visit_Opt_Out__c,toRole__r.Personal_Agreement__c,
                                                 toRole__r.Personal_Information_Third_Party_Release__c,toRole__r.Personal_Abroad_Agreement__c,toRole__r.Agreement_to_commit_info_processing__c,
                                                 toRole__r.Complaint_Amount__c,toRole__r.Preferred_Contact_Method__c,toRole__r.Job__c,toRole__r.Company_Name__c,toRole__r.PersonMobilePhone,
                                                 toRole__r.Primary_Address_Reference__c,fromRole__r.Dealer_Rollout_Status__c
                                                 from Account_Link__c WHERE toRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany )];
        
        System.debug('Accountlinklist------>'+Accountlinklist  );
        Account_Link__c retailCompanyupdate = new Account_Link__c();
        try{
            retailCompanyupdate = [select id,Name from Account_Link__c where RecordType.Name = 'Retail Company' and toRole__c In : AccountIds];
        }
        catch(Exception e){}    
        system.debug('retailCompanyupdate :'+retailCompanyupdate);
        //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist )
        {
            if(acclnk.toRole__r.RecordType.Name == 'Person Account' && acclnk.fromRole__r.Dealer_Rollout_Status__c == 'Done') 
            {
                //if(persongroup1 == true){
                acclnk.Retail_LastName__c = acclnk.toRole__r.LastName;
                acclnk.Retail_FirstName__c = acclnk.toRole__r.FirstName;
                acclnk.Retail_Full_Name__c = (acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName :'') + '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'').left(25); 
                acclnk.Retail_Full_Name_Title__c = ((acclnk.toRole__r.Salutation__c!= null ? acclnk.toRole__r.Salutation__c: '')+ '  '+(acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName:'')+ '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'')).left(140);
                acclnk.Retail_LastName_Native__c = acclnk.toRole__r.LastName_Native_1__c;
                acclnk.Retail_FirstName_Native__c = acclnk.toRole__r.FirstName_Native_1__c; 
                acclnk.Retail_Full_Name_Native__c = ((acclnk.toRole__r.LastName_Native_1__c!=null ? acclnk.toRole__r.LastName_Native_1__c : '')+ ' ' +(acclnk.toRole__r.FirstName_Native_1__c!=null ? acclnk.toRole__r.FirstName_Native_1__c:'')).left(50);
                //}
                //if(persongroup2 == true){
                acclnk.Retail_Gender__c = acclnk.toRole__r.Gender__c;
                acclnk.Retail_PersonBirthdate__c = acclnk.toRole__r.PersonBirthdate;
                acclnk.Retail_Occupation__c = acclnk.toRole__r.MBK_Occupation__c;                
                acclnk.Retail_Preferred_Language__c = 'Korean';
                acclnk.Retail_Industry__c = acclnk.toRole__r.Industry;                  
                acclnk.Retail_Special_Care__c = acclnk.toRole__r.Special_Care__c;
                acclnk.Retail_Special_Needs_Class__c = acclnk.toRole__r.Special_Needs_Class__c;
                //}
                //if(persongroup3 == true){
                acclnk.Retail_Allow_Data_Sharing__c = acclnk.toRole__r.Allow_Data_Sharing__c;  
                //}   
                //if(persongroup4 == true){
                acclnk.Retail_Individual_Home_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                //}
                //if(persongroup5 == true){
                acclnk.Retail_Work_Phone__c = acclnk.toRole__r.Work_Phone__c;
                //}
                //if(persongroup6 == true){
                acclnk.Retail_Mobile__c = acclnk.toRole__r.PersonMobilePhone;   
                //}   
                //if(persongroup8 == true){   
                acclnk.Retail_Email__c = acclnk.toRole__r.PersonEmail;
                //}
                //if(persongroup10 == true){  
                acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone_Display__c;
                //}
                acclnk.Retail_DMS_Customer_ID__c    = acclnk.toRole__r.DMS_Customer_ID__c;
                acclnk.Retail_Complaint_Amount__c = acclnk.toRole__r.Complaint_Amount__c;
                acclnk.Retail_Sales_Sanction__c = acclnk.toRole__r.Sales_Sanction__c;                
                acclnk.Retail_Preferred_Contact_Method__c = acclnk.toRole__r.Preferred_Contact_Method__c;
                acclnk.Retail_Email_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfEmail;
                acclnk.Retail_Fax_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfFax;
                acclnk.Retail_Phone_OptOut__c = acclnk.toRole__r.PersonDoNotCall;
                acclnk.Retail_Visit_OptOut__c = acclnk.toRole__r.Visit_Opt_Out__c;
                acclnk.Retail_Position__c = acclnk.toRole__r.Job__c;
                acclnk.Retail_WebSite__c = acclnk.toRole__r.Website;
                //acclnk.Retail_Company_Name__c = acclnk.toRole__r.Company_Name__c;
                acclnk.Retail_Company_Name_Native1__c = acclnk.toRole__r.Company_Name_Native_1__c; 
                acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c; 
                acclnk.Retail_Company_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                acclnk.Retail_Company_Other_Phone__c = acclnk.toRole__r.Work_Phone__c;
                acclnk.Retail_Agreement__c = acclnk.toRole__r.Personal_Agreement__c;
                acclnk.Retail_Information_Third_Party_Release__c = acclnk.toRole__r.Personal_Information_Third_Party_Release__c;
                acclnk.Retail_Abroad_Agreement__c = acclnk.toRole__r.Personal_Abroad_Agreement__c;
                acclnk.Retail_Agreement_Info_Processing__c = acclnk.toRole__r.Agreement_to_commit_info_processing__c;
                acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c ;
                acclnk.Retail_Postal_OptOut__c= acclnk.toRole__r.Postal_Opt_Out__c ;
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate);
                system.debug('acc Id :'+acclnk.id);
                system.debug('acc Id R:'+acclnk.RecordTypeId);
                if(retailCompanyupdate != Null && acclnk.RecordTypeId != RetailCompany){
                    system.debug('acc Id >> :'+acclnk.id);
                    acclnk.Retail_Related_Company__c = retailCompanyupdate .id;
                }           
            }
            //Checking the Company RecordType
            if(acclnk.toRole__r.RecordType.Name=='Company' && acclnk.fromRole__r.Dealer_Rollout_Status__c == 'Done')
            { 
                acclnk.Retail_Company_Name__c = acclnk.toRole__r.Company_Name__c;
                acclnk.Retail_Company_Name_Native1__c = acclnk.toRole__r.Company_Name_Native_1__c;
                
                acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c;
                acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c;
                if(acclnk.toRole__r.Foundation_Date__c != null)
                {
                    Integer FoundationDate = acclnk.toRole__r.Foundation_Date__c.month();
                    if(FoundationDate <= 9)
                    {
                        acclnk.Retail_Foundation_Month__c = '0'+String.valueof(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());
                    }
                    else 
                    {
                        acclnk.Retail_Foundation_Month__c = String.valueof(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());         
                    }
                }
                acclnk.Retail_Industry__c = acclnk.toRole__r.Industry; 
                acclnk.Retail_Website__c = acclnk.toRole__r.website;
                
                
                acclnk.Retail_Company_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                
                acclnk.Retail_Company_Other_Phone__c = acclnk.toRole__r.Work_Phone__c;
                
                acclnk.Retail_DMS_Customer_ID__c = acclnk.toRole__r.DMS_Customer_ID__c;      
                acclnk.Retail_Email_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfEmail;
                acclnk.Retail_Fax_OptOut__c = acclnk.toRole__r.PersonHasOptedOutOfFax;
                acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone_Display__c;
                acclnk.Retail_Sales_Sanction__c = acclnk.toRole__r.Sales_Sanction__c;
                acclnk.Retail_Phone_OptOut__c = acclnk.toRole__r.PersonDoNotCall;
                acclnk.Retail_Visit_OptOut__c = acclnk.toRole__r.Visit_Opt_Out__c;
                acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;
                acclnk.Retail_Postal_OptOut__c= acclnk.toRole__r.Postal_Opt_Out__c ;
                acclnk.Retail_Agreement__c = acclnk.toRole__r.Personal_Agreement__c;
                acclnk.Retail_Information_Third_Party_Release__c = acclnk.toRole__r.Personal_Information_Third_Party_Release__c;
                acclnk.Retail_Abroad_Agreement__c = acclnk.toRole__r.Personal_Abroad_Agreement__c;
                acclnk.Retail_Agreement_Info_Processing__c = acclnk.toRole__r.Agreement_to_commit_info_processing__c;
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate); 
            
            //End if for Company record type
            acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
            //}         
            //acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;   
            //Checking Null for sales Address 
                if(acclnk.toRole__r.Primary_Address_Reference__c != null )
                { 
                    acclnk.Retail_Address_Type__c = acclnk.toRole__r.Primary_Address_Reference__r.Address_Type__c;
                    if(addtrmap1.containsKey(acclnk.toRole__r.Primary_Address_Reference__r.Province__c) )
                    {
                        province = addtrmap1.get(acclnk.toRole__r.Primary_Address_Reference__r.Province__c);
                    } 
                    acclnk.Retail_Province__c = province ;   
                    acclnk.Retail_Province__c  =acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue); 
                    //acclnk.Retail_Province__c = (acclnk.toRole__r.Primary_Address_Reference__r.Province__c !=null ?acclnk.toRole__r.Primary_Address_Reference__r.Province__c: '' );
                    acclnk.Retail_City__c = (acclnk.toRole__r.Primary_Address_Reference__r.City__c != null ? acclnk.toRole__r.Primary_Address_Reference__r.City__c:'').left(17);
                    acclnk.Retail_Distinct__c = ((acclnk.toRole__r.Primary_Address_Reference__r.District__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.District__c : '')+(acclnk.toRole__r.Primary_Address_Reference__r.Block__c!= null ?acclnk.toRole__r.Primary_Address_Reference__r.Block__c : '')).left(17);
                    acclnk.Retail_Address_Line_1__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclnk.Retail_Address_Line_2__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    acclnk.Retail_ZipCode__c = (acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c : '' );
                }
            }
            //End if for Sales Address
            AccountlnkUpdate.add(acclnk); 
            system.debug('AccountlnkUpdate--->'+AccountlnkUpdate);
        }        
        if(!AccountlnkUpdate.isEmpty()){
            update AccountlnkUpdate;
        }
        //}
    } 
    
    
    
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    Public static void createSharingRecord (map<id,Account> dealerAccList1) 
    {
        user usr = [select id,name,contactId,contact.AccountId from user where Id =: UserInfo.getUserId()];
        system.debug('>>>> account:'+usr.contact.AccountId);
        //Set<Id> dealerAccId = new Set<Id>();
        //for(user u : usr){
        //dealerAccId.add(u.contact.AccountId);
        //}//
        List<Account> dealerAccList = [select Id,Name , Dealer_GC_Code__c,Dealer_ND_Code__c  from Account where Id =: usr.contact.AccountId AND 
                                       RecordType.DeveloperName = 'Dealer'];
        
        if(usr.contactId != Null)
        {
            Set<String> dealerAccNameSet = new Set<String>();
            Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
            for(Account dealerRec : dealerAccList)
            {
                dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
                accNameToAccIdMap.put(dealerRec.Dealer_ND_Code__c, dealerRec.Id);
            }
            
            system.debug('dealerAccList acc  >> :'+dealerAccList);
            Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
            for(Account accRec : dealerAccList)
            {
                if(String.isNotBlank(accRec.Dealer_GC_Code__c)) 
                {
                    gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);                    
                }
            }
            system.debug('gcCodeToDealerAccIdMap  account' + gcCodeToDealerAccIdMap + '\n\n' + gcCodeToDealerAccIdMap.keySet());
            Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
            
            
            List<Account> similarGCCodeDealerAccountList = [select Id,Name, Dealer_GC_Code__c,Dealer_ND_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet() AND RecordtypeId =: Dealer_RecordTypeId];
            system.debug('similarGCCodeDealerAccountList account:'+similarGCCodeDealerAccountList);
            Set<String> dealerAccNameSet1 = new Set<String>();
            for(Account dealerRec : similarGCCodeDealerAccountList ) 
            {
                dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
            }
            system.debug('dealerAccNameSet :'+dealerAccNameSet);
            List<AccountShare> AccountShareList = new  List<AccountShare>();
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet])
            {
                system.debug('groupRec account:'+groupRec.Name);
                for(Account dealerRec : dealerAccList1.values()) 
                {
                    system.debug('dealerRec account:'+dealerRec.Name);
                    AccountShare AccountShareRecord = new AccountShare();
                    AccountShareRecord.AccountId= dealerRec.id;
                    AccountShareRecord.UserOrGroupId= groupRec.Id;
                    AccountShareRecord.AccountAccessLevel= 'Read';
                    AccountShareRecord.OpportunityAccessLevel= 'Edit';   
                    AccountShareRecord.RowCause='Manual';
                    AccountShareList.add(AccountShareRecord);
                }            
            }
            system.debug('AccountShareList account:'+AccountShareList);
            if(AccountShareList.size() > 0){
                Database.insert(AccountShareList, false);
            }
        }
    }

    /****************************************8
    public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate)
{
        user usr = [select id,Name,ContactId from user where Id =: UserInfo.getUserId()];
        if(usr.ContactId != Null){
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        Set<String> OwnerIds = new set<String>();//Set initialization to add Owner Id's \
        Set<String> UsrAccountIds = new set<String>();   
        for(Account acc : accLst){
            if(isInsert && acc.MD__c == 'KR'){ //Checking Market for updated account
                AccountIds.add(acc.id); //Adding accountId's to set
                OwnerIds.add(acc.Ownerid);//Adding Owner Id's to set
                System.debug('AccountID--->'+acc.id);        
            }
        }
        String origin = ApexPages.currentPage().getParameters().get('CLNID');
        string regexForNullValue ='null';
        string nullValue ='';                            
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('KR');
           
        Map<ID,User> ownermap = new Map<ID,User>([select id , name , ContactId , Contact.AccountId from user where id IN : OwnerIds]);
        List<Account> AccList = [select Id, LastName, FirstName,LastName_Native_1__c, 
                                FirstName_Native_1__c, PersonBirthdate, Special_Care__c, Individual_Home_Phone__c, Work_Phone__c,
                                Mobile__c, Fax, Email__c, Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c,
                                Primary_Address_Reference__r.Block__c, Primary_Address_Reference__r.Address_Line_1__c,
                                Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,                                 
                                gender__c, Occupation__c,MBK_Occupation__c,Industry,Preferred_Language__c,
                                Special_Needs_Class__c, Allow_Data_Sharing2__c, Primary_Address_Reference__r.Address_Type__c, 
                                Primary_Address_Reference__r.Province__c, Preferred_Contact_Method__c,MD__c,
                                UCID__c, RecordtypeId, Name, Company_Name_Native_1__c,Foundation_Date__c,ownerid,Commercial_Reg_No__c,
                                Website,Vat_No__c                                                 
                                from Account WHERE id IN : AccountIds];
            List<Account_Link__c> acckLst = new List<Account_Link__c>();                             
            Map<String,Id> recordTypes = new Map<String,Id>();
            for(RecordType rt : [select id,DeveloperName from RecordType WHERE DeveloperName IN ( 'ContactSector' ,'Retail_Company', 'Retail_Person' ) ] ){
                 recordTypes.put(rt.DeveloperName,rt.Id) ;
            }
            Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Id AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        
        for(Account led : AccList){            
            if(ownermap.containskey(led.ownerid) ){
                Account_Link__c acclnk = new Account_Link__c();
                if(led.RecordTypeId == PersonRecordTypeId){
                    acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Person'), fromRole__c = ownermap.get(led.ownerid).Contact.AccountId, toRole__c = led.Id,                                                                         
                                                                        Retail_Full_Name__c = ((led.LastName!=null ? led.LastName : '') + ' ' + (led.FirstName != null ? led.FirstName : '')).left(25) ,
                                                                        Retail_PersonBirthdate__c = led.PersonBirthdate, Retail_Special_Care__c = led.Special_Care__c, Retail_Individual_Home_Phone__c = led.Individual_Home_Phone__c,
                                                                        Retail_Work_Phone__c = led.Work_Phone__c, Retail_Mobile__c = led.Mobile__c, Retail_Email__c = led.Email__c,                                                                       
                                                                        Retail_Gender__c = led.Gender__c, Retail_Occupation__c = led.MBK_Occupation__c,
                                                                        Retail_Preferred_Language__c = led.Preferred_Language__c,
                                                                        Retail_Preferred_Contact_Method__c = led.Preferred_Contact_Method__c,
                                                                        Retail_Special_Needs_Class__c = led.Special_Needs_Class__c, Retail_Allow_Data_Sharing__c = led.Allow_Data_Sharing2__c,
                                                                        Retail_Full_Name_Native__c = ((led.LastName_Native_1__c != null ? led.LastName_Native_1__c: '') + (led.FirstName_Native_1__c != null ?led.FirstName_Native_1__c :'' )).left(50),
                                                                        
                                                                        Retail_LastName__c = led.LastName, Retail_FirstName__c = led.FirstName, 
                                                                        Retail_Full_Name_Title__c = ((led.LastName!=null ? led.LastName : '') + '  ' + (led.FirstName != null ? led.FirstName : '') + '  ' + (led.FirstName!= null ? led.FirstName : '')),
                                                                        Retail_LastName_Native__c = led.LastName_Native_1__c, Retail_FirstName_Native__c = led.FirstName_Native_1__c,
                                                                        Retail_UCID__c = led.UCID__c);
                }
                else if(led.RecordTypeId == AccountCompanyId){
                      acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Company'), fromRole__c = ownermap.get(led.ownerid).Contact.AccountId, toRole__c = led.Id,          
                                                     Retail_Company_Name__c = led.Name, Retail_Company_Name_Native1__c = led.Company_Name_Native_1__c, 
                                                     Retail_Commercial_Reg_No__c = led.Commercial_Reg_No__c, Retail_Website__c = led.website,Retail_Company_Phone__c = led.Individual_Home_Phone__c,
                                                     Retail_Company_Other_Phone__c = led.Work_Phone__c, Retail_Vat_No__c = led.Vat_No__c,
                                                     Retail_UCID__c = led.UCID__c); 
                        if(led.Foundation_Date__c != null){
                           acclnk.Retail_Foundation_Month__c = String.ValueOf(led.Foundation_Date__c.month())+String.valueOf(led.Foundation_Date__c.year());
                        }
                }
                acclnk.Name = led.UCID__c;
                acclnk.Retail_Fax__c = led.Fax;
                acclnk.MD__c = led.MD__c;
                acclnk.Retail_Industry__c = led.Industry;
                if(origin != null){
                    acclnk.CorrelationID__c = origin;
                }
                if(led.MD__c == Label.MarketKR){
                    acclnk.Retail_Country__c = 'Korea';   
                }
                else if(led.MD__c == Label.MarketJP){
                    acclnk.Retail_Country__c = 'Japan';
                }          
                if(led.Primary_Address_Reference__c != null){
                    acclnk.Retail_Address_Type__c = (led.Primary_Address_Reference__r.Address_Type__c!=null ?led.Primary_Address_Reference__r.Address_Type__c : '' );
                    acclnk.Retail_Address_Line_1__c = (led.Primary_Address_Reference__r.Address_Line_1__c != null ? led.Primary_Address_Reference__r.Address_Line_1__c: '' ).left(17);
                    acclnk.Retail_Address_Line_2__c  = (led.Primary_Address_Reference__r.Address_Line_2__c!= null ? led.Primary_Address_Reference__r.Address_Line_2__c : '' ).left(17);
                    acclnk.Retail_ZipCode__c= (led.Primary_Address_Reference__r.ZipCode__c!=null ? led.Primary_Address_Reference__r.ZipCode__c : '');
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(led.Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(led.Primary_Address_Reference__r.LastModifiedDate);
                    if(addtrmap1.containsKey(acclnk.Retail_Address_Reference__r.Province__c) )
                    {
                        province = addtrmap1.get(acclnk.Retail_Address_Reference__r.Province__c);
                    } 
                    acclnk.Retail_Province__c = province ; 
                    acclnk.Retail_Province__c  =acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                    //acclnk.Retail_Province__c = (led.Primary_Address_Reference__r.Province__c!= null ? led.Primary_Address_Reference__r.Province__c : '');
                    acclnk.Retail_City__c = (led.Primary_Address_Reference__r.City__c != null ? led.Primary_Address_Reference__r.City__c : '').left(17);
                    acclnk.Retail_Distinct__c = ((led.Primary_Address_Reference__r.District__c != null ? led.Primary_Address_Reference__r.District__c : '') + ' ' + (led.Primary_Address_Reference__r.Block__c != null ? led.Primary_Address_Reference__r.Block__c : '' )).left(17);
                }
                acckLst.add(acclnk);
            }
        }    
        if(!accLst.isEmpty()){
            insert acckLst;
        }
        }
    }
    
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst , Map<Id,Account>oldAccountmap)
{
        system.debug('------>Method is called');
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        //#SFDCKR-1098 0 Only Pilot dealer can update the retail copy
        user usr = [select id,Name,Contact.AccountId from user where Id =:userinfo.getuserid()];
        account pilotdealer = new account ();
        try{
            pilotdealer = [select id,Name,Dealer_Rollout_Status__c from account where id =: usr.Contact.AccountId];
        }
        catch(Exception e){}
        if(pilotdealer.Dealer_Rollout_Status__c =='Done' || pilotdealer.Dealer_Rollout_Status__c !='Done'){
        for(Account acc : accLst){
            if(isUpdate && acc.MD__c == 'KR'){ //Checking Market for updated account
                if(oldAccountmap.get(Acc.id).LastName !=  acc.LastName || oldAccountmap.get(Acc.id).FirstName != acc.FirstName || oldAccountmap.get(Acc.id).LastName_Native_1__c != acc.LastName_Native_1__c || oldAccountmap.get(Acc.id).FirstName_Native_1__c != acc.FirstName_Native_1__c){
                     AccountIds.add(acc.id); //Adding accountId's to set
                       System.debug('AccountID--->'+acc.id);  
                        persongroup1 = true;
                }
                if(oldAccountmap.get(Acc.id).Gender__c != acc.Gender__c || oldAccountmap.get(Acc.id).PersonBirthdate != acc.PersonBirthdate || oldAccountmap.get(Acc.id).MBK_Occupation__c != Acc.MBK_Occupation__c || oldAccountmap.get(Acc.id).Industry != acc.Industry || oldAccountmap.get(Acc.id).Preferred_Language__c != acc.Preferred_Language__c
                    ||oldAccountmap.get(Acc.id).Special_Care__c != acc.Special_Care__c || oldAccountmap.get(Acc.id).Special_Needs_Class__c != Acc.Special_Needs_Class__c){
                         AccountIds.add(acc.id);
                        persongroup2 = true;
                }
                if(oldAccountmap.get(acc.id).Allow_Data_Sharing2__c != acc.Allow_Data_Sharing2__c){
                        AccountIds.add(acc.id);
                        persongroup3 = true;
                }
                if(oldAccountmap.get(acc.id).Individual_Home_Phone__c != acc.Individual_Home_Phone__c){
                        AccountIds.add(acc.id); 
                        persongroup4 = true;
                }
                if(oldAccountmap.get(acc.id).Work_Phone__c != acc.Work_Phone__c){
                        AccountIds.add(acc.id);
                        persongroup5 = true;
                }
                if(oldAccountmap.get(acc.id).Mobile__c != acc.Mobile__c){
                        AccountIds.add(acc.id);
                        persongroup6 = true;
                }
                if(oldAccountmap.get(acc.id).Fax != acc.Fax){
                        AccountIds.add(acc.id); 
                        persongroup7= true;
                }
                if(oldAccountmap.get(acc.id).Email__c != acc.Email__c){
                        AccountIds.add(acc.id);
                        persongroup8 = true;
                } 
                if(oldAccountmap.get(acc.id).Primary_Phone__c != acc.Primary_Phone__c){
                        AccountIds.add(acc.id); 
                        persongroup10 = true;
                }  
                if(oldAccountmap.get(acc.id).Primary_Address_Reference__c  != acc.Primary_Address_Reference__c || oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Type__c != acc.Primary_Address_Reference__r.Address_Type__c
                    || oldAccountmap.get(acc.id).Primary_Address_Reference__r.Province__c != acc.Primary_Address_Reference__r.Province__c ||
                        oldAccountmap.get(acc.id).Primary_Address_Reference__r.City__c  != acc.Primary_Address_Reference__r.City__c  ||
                        oldAccountmap.get(acc.id).Primary_Address_Reference__r.District__c  != acc.Primary_Address_Reference__r.District__c ||
                        oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Line_1__c  != acc.Primary_Address_Reference__r.Address_Line_1__c ||
                        oldAccountmap.get(acc.id).Primary_Address_Reference__r.Address_Line_2__c  != acc.Primary_Address_Reference__r.Address_Line_2__c ||
                        oldAccountmap.get(acc.id).Primary_Address_Reference__r.ZipCode__c  != acc.Primary_Address_Reference__r.ZipCode__c){
                        AccountIds.add(acc.id); 
                        persongroup9 = true;
                }
                if(oldAccountmap.get(acc.id).Name != acc.Name || oldAccountmap.get(acc.id).Company_Name_Native_1__c != acc.Company_Name_Native_1__c){
                        AccountIds.add(acc.id);
                        companygroup1 = true;
                }
                if((oldAccountmap.get(acc.id).Commercial_Reg_No__c != acc.Commercial_Reg_No__c || oldAccountmap.get(acc.id).Vat_No__c != acc.Vat_No__c || oldAccountmap.get(acc.id).Foundation_Date__c != acc.Foundation_Date__c
                   || oldAccountmap.get(acc.id).Industry != acc.Industry || oldAccountmap.get(acc.id).website != acc.website)&& acc.RecordTypeID == accCompany_RecordTypeId){
                        AccountIds.add(acc.id);
                        companygroup2 = true;
                }
            }            
        }   
        string regexForNullValue ='null';
        string nullValue ='';                            
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('KR');
              
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        List<Account_Link__c> Accountlinklist = [select id,Name,toRole__r.RecordType.Name, toRole__r.LastName, toRole__r.FirstName, toRole__r.Salutation__c, toRole__r.LastName_Native_1__c,
                                                    toRole__r.FirstName_Native_1__c, toRole__r.Gender__c, toRole__r.PersonBirthdate, toRole__r.Occupation__c,toRole__r.MBK_Occupation__c, toRole__r.Industry, 
                                                toRole__r.Preferred_Language__c, toRole__r.Primary_Phone__c, toRole__r.Special_Care__c, toRole__r.Special_Needs_Class__c,
                                                toRole__r.Allow_Data_Sharing2__c, toRole__r.Individual_Home_Phone__c, toRole__r.Work_Phone__c, toRole__r.Mobile__c, toRole__r.Fax,
                                                toRole__r.Email__c,toRole__r.Primary_Address_Reference__r.Address_Type__c, toRole__r.Primary_Address_Reference__r.Province__c,
                                                toRole__r.Primary_Address_Reference__r.City__c, toRole__r.Primary_Address_Reference__r.District__c, toRole__r.Primary_Address_Reference__r.Block__c,
                                                toRole__r.Primary_Address_Reference__r.Address_Line_1__c, toRole__r.Primary_Address_Reference__r.Address_Line_2__c, toRole__r.Primary_Address_Reference__r.ZipCode__c,
                                                toRole__r.Name, toRole__r.Company_Name_Native_1__c, toRole__r.Commercial_Reg_No__c, toRole__r.Vat_No__c, 
                                                toRole__r.Foundation_Date__c, toRole__r.Website, toRole__r.Primary_Address_Reference__r.CreatedDate,
                                                toRole__r.Primary_Address_Reference__r.LastModifiedDate,toRole__r.UCID__c
                                                    from Account_Link__c WHERE toRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany )];
        System.debug('Accountlinklist------>'+Accountlinklist  );
            
        //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist ){
            if(acclnk.toRole__r.RecordType.Name == 'Person Account') {
                if(persongroup1 == true){
                    acclnk.Retail_LastName__c = acclnk.toRole__r.LastName;
                    acclnk.Retail_FirstName__c = acclnk.toRole__r.FirstName;
                    acclnk.Retail_Full_Name__c = (acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName :'') + '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'').left(25); 
                    acclnk.Retail_Full_Name_Title__c = ((acclnk.toRole__r.Salutation__c!= null ? acclnk.toRole__r.Salutation__c: '')+ '  '+(acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName:'')+ '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'')).left(140);
                    acclnk.Retail_LastName_Native__c = acclnk.toRole__r.LastName_Native_1__c;
                    acclnk.Retail_FirstName_Native__c = acclnk.toRole__r.FirstName_Native_1__c; 
                    acclnk.Retail_Full_Name_Native__c = ((acclnk.toRole__r.LastName_Native_1__c!=null ? acclnk.toRole__r.LastName_Native_1__c : '')+ ' ' +(acclnk.toRole__r.FirstName_Native_1__c!=null ? acclnk.toRole__r.FirstName_Native_1__c:'')).left(50);
                }
                if(persongroup2 == true){
                    acclnk.Retail_Gender__c = acclnk.toRole__r.Gender__c;
                    acclnk.Retail_PersonBirthdate__c = acclnk.toRole__r.PersonBirthdate;
                    acclnk.Retail_Occupation__c = acclnk.toRole__r.MBK_Occupation__c;                
                    acclnk.Retail_Preferred_Language__c = acclnk.toRole__r.Preferred_Language__c;
                    acclnk.Retail_Industry__c = acclnk.toRole__r.Industry;                  
                    acclnk.Retail_Special_Care__c = acclnk.toRole__r.Special_Care__c;
                    acclnk.Retail_Special_Needs_Class__c = acclnk.toRole__r.Special_Needs_Class__c;
                }
                if(persongroup3 == true){
                    acclnk.Retail_Allow_Data_Sharing__c = acclnk.toRole__r.Allow_Data_Sharing2__c;  
                }   
                if(persongroup4 == true){
                    acclnk.Retail_Individual_Home_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                }
                if(persongroup5 == true){
                    acclnk.Retail_Work_Phone__c = acclnk.toRole__r.Work_Phone__c;
                }
                if(persongroup6 == true){
                    acclnk.Retail_Mobile__c = acclnk.toRole__r.Mobile__c;   
                }   
                if(persongroup8 == true){   
                    acclnk.Retail_Email__c = acclnk.toRole__r.Email__c;
                }
                if(persongroup10 == true){  
                    acclnk.Retail_Primary_Phone__c = acclnk.toRole__r.Primary_Phone__c;
                }               
            }
            //Checking the Company RecordType
            if(acclnk.toRole__r.RecordType.Name=='Company'){ 
                if(companygroup1 == true){
                    acclnk.Retail_Company_Name__c = acclnk.toRole__r.Name;
                    acclnk.Retail_Company_Name_Native1__c = acclnk.toRole__r.Company_Name_Native_1__c;
                }
                if(companygroup2 == true){
                    acclnk.Retail_Commercial_Reg_No__c = acclnk.toRole__r.Commercial_Reg_No__c;
                    acclnk.Retail_Vat_No__c = acclnk.toRole__r.Vat_No__c;
                    if(acclnk.toRole__r.Foundation_Date__c != null){
                        Integer FoundationDate = acclnk.toRole__r.Foundation_Date__c.month();
                        if(FoundationDate <= 9){
                            acclnk.Retail_Foundation_Month__c =  '0'+String.valueof(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());
                        }
                        else {
                            acclnk.Retail_Foundation_Month__c = String.valueof(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());         
                        }
                    }
                    acclnk.Retail_Industry__c = acclnk.toRole__r.Industry; 
                    acclnk.Retail_Website__c = acclnk.toRole__r.website;
                }                
                if(persongroup4 == true){
                    acclnk.Retail_Company_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
                }               
                if(persongroup4 == true){
                    acclnk.Retail_Company_Other_Phone__c = acclnk.toRole__r.Work_Phone__c;
                }                                  
            }
            //End if for Company record type
            if(persongroup7 == true){
                acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
            }  
                
            //acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;   
            //Checking Null for sales Address 
            if(acclnk.toRole__r.Primary_Address_Reference__c != null && persongroup9 == True){ 
                acclnk.Retail_Address_Type__c = acclnk.toRole__r.Primary_Address_Reference__r.Address_Type__c;
                if(addtrmap1.containsKey(acclnk.toRole__r.Primary_Address_Reference__r.Province__c) ){
                    province = addtrmap1.get(acclnk.toRole__r.Primary_Address_Reference__r.Province__c);
                } 
                acclnk.Retail_Province__c = province ;   
                acclnk.Retail_Province__c  =acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue); 
                //acclnk.Retail_Province__c = (acclnk.toRole__r.Primary_Address_Reference__r.Province__c !=null ?acclnk.toRole__r.Primary_Address_Reference__r.Province__c: '' );
                acclnk.Retail_City__c = (acclnk.toRole__r.Primary_Address_Reference__r.City__c != null ? acclnk.toRole__r.Primary_Address_Reference__r.City__c:'').left(17);
                acclnk.Retail_Distinct__c = ((acclnk.toRole__r.Primary_Address_Reference__r.District__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.District__c : '')+(acclnk.toRole__r.Primary_Address_Reference__r.Block__c!= null ?acclnk.toRole__r.Primary_Address_Reference__r.Block__c : '')).left(17);
                acclnk.Retail_Address_Line_1__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                acclnk.Retail_Address_Line_2__c = ((acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c)!=null?acclnk.toRole__r.Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                acclnk.Retail_ZipCode__c = (acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c!=null ? acclnk.toRole__r.Primary_Address_Reference__r.ZipCode__c : '' );
                //acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                //acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate);
            }
            //End if for Sales Address
            AccountlnkUpdate.add(acclnk); 
            system.debug('AccountlnkUpdate--->'+AccountlnkUpdate);
        }
        
            if(!AccountlnkUpdate.isEmpty())
            {
                update AccountlnkUpdate;
            }
        }
    } 
    ********************************/   
}