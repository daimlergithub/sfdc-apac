/***********************************************************************************
Created By          :    Venky    
Created Date        :    22.10.2016
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class Select dealer and Address then click save it will create retail copy for selected dealer.
                         Business Conditions :
                          * In case of MBJ User select Dealer and Address record.
                          *For Dealer User only select address.
                          * On click of create ratil copy button one retail copy will be created .  
                          
Jira Number         :SFDCJP-634
MODIFICATION DETAILS:


1. Modified By      :    Venky
   Modifide Date    :    30.01.2017
   JIRA Number      :    SFDCJP-1134
************************************************************************************/
public without sharing class AddressSelectionforExistingCustomer {

    public Account account {
        get;
        set;
    }
    public Account accList {
        get;
        set;
    }
    Public static String AccId {
        get;
        set;
    }
    public List < Address__c > ListAddress {
        set;
        get;
    }
    public List < Address__c > SelectedAdd {
        set;
        get;
    }
    public Id addId {
        get;
        set;
    }
    public Id did {
        get;
        set;
    }
    public Boolean ShowHideError {
        set;
        get;
    }
    public List < Account_Link__c > Accountlinklist {
        get;
        set;
    }
    Public User Usr {
        get;
        set;
    }
    public List < Account > accc {
        set;
        get;
    }
    Public Id DealeAccId {
        get;
        set;
    }
    public List < Contact > contactList {
        get;
        set;
    }
    public Account_Link__c newAlk;
    public List < Account_Link__c > InsertAlk;
    public Account DealerID {
        get;
        set;
    }
    public User CurrentUsr {
        set;
        get;
    }
    public String selectAll {
        set;
        get;
    }
    public List < Account > Dealeracc {
        set;
        get;
    }
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();

    // Constructor
    public AddressSelectionforExistingCustomer() {
        AccId = ApexPages.currentPage().getParameters().get('id');
        ListAddress = new List < Address__c > ();
        SelectedAdd = new List < Address__c > ();
        InsertAlk = new List < Account_Link__c > ();
        account = new Account();
        ShowHideError = false;
        CurrentUsr = [SELECT Market__c, DMS_UserID__c, LanguageLocaleKey, IsPortalEnabled, contactid, Id FROM User WHERE Id =: UserInfo.getUserId()];
        //  account = (Account)controller.getRecord();
        if (CurrentUsr.LanguageLocaleKey == 'en_US') {
            selectAll = label.select;
        } else
            selectAll = '';
        if (AccId != null) {
            ListAddress = [select id, Name, Customer__c, Address_Type__c, ZipCode__c, Province__c, Province_Native__c, City__c, City_Native__c, District__c, District_Native__c, Block__c, Block_Native__c, Address_Line_1__c, Address_Line_1_Native__c, Address_Line_2__c, Address_Line_2_Native__c, Company_Name__c, Company_Name_Native__c, TitleOfHonor__c, Status__c, Temp_ZipCode__c, Temp_Address__c, LastModifiedDate,address_line_3__c FROM Address__c where Customer__c =: AccId];
        }

        system.debug('+++++++++++++' + account);
        system.debug('++++++++++++++' + AccId);

    } // Constructor  end


    //Method to selected Address  record Id
    public pageReference getSelectedAddress() {

        addId = ApexPages.currentPage().getParameters().get('idselected');

        system.debug('+++++++++' + addId);


        return null;

    }

    //Method to get selected dealer ID
    public void getDealer() {
        Dealeracc = new List < Account > ();
        AccId = ApexPages.currentPage().getParameters().get('id');
        // DealerID=ApexPages.currentPage().getParameters().get('DealerID');  
        accc = [Select id from account where id =: account.Main_Dealer__c];
        System.debug('^&^&^&^&^&^&^&^ accc' + accc);
        System.debug('^&^&^&^&^&^&^&^ AccId ' + AccId);
        System.debug('^&^&^ DealerID.Main_Dealer__c ' + account.Main_Dealer__c);
    } //Method end

    // Method to Create retail copy
    Public void CreateRetailCopy() {

        AccId = ApexPages.currentPage().getParameters().get('id');

        accList = [Select Id, MD__c, LastModifiedDate, Foundation_Date__c, ID_Type__c, ID_Number__c, Country__c, createdDate, Special_Care__c, Primary_Phone__c, email__c, Salutation__c, Mobile__c, LastName_Native_1__c, FirstName_Native_1__c, Special_Needs_Class__c, Preferred_Language__c, Allow_Data_Sharing2__c, Main_Dealer__c, RecordtypeId, UCID__c, DMS_Customer_ID__c, Name, LastName, FirstName, Complaint_Amount__c, Sales_Sanction__c, Allow_Data_Sharing__c, PersonMobilePhone, Individual_Home_Phone__c, Work_Phone__c, PersonEmail, Fax, Preferred_Contact_Method__c, PersonHasOptedOutOfEmail, PersonHasOptedOutOfFax, Primary_Phone_Display__c, PersonDoNotCall, Postal_Opt_Out__c, Visit_Opt_Out__c, PersonBirthdate, Occupation__c, Job__c, Gender__c, industry, Website, Company_Name_Native_1__c, Commercial_Reg_No__c, Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c, Vat_No__c, Company_Name__c,Race__c,title__c from account where id =: AccId];
        accc = [Select id, Main_Dealer__c from account where id =: account.Main_Dealer__c limit 1];
        system.debug('+++++++++' + addId);
        System.debug('##################' + accc);
        System.debug('#################' + AccId);
        if (addId != null) {
            SelectedAdd = [select id, Foreign_Nationals__c, createddate, lastmodifieddate, Name, Customer__c, Sub_District__c, Address_Type__c, ZipCode__c, Province__c, Province_Native__c, Country__c, City__c, City_Native__c, District__c, District_Native__c, Block__c, Block_Native__c, Address_Line_1__c, Address_Line_1_Native__c, Address_Line_2__c, Address_Line_2_Native__c, Company_Name__c, Company_Name_Native__c, TitleOfHonor__c, Status__c, Temp_ZipCode__c, Temp_Address__c,Address_Line_3__c FROM Address__c where id =: addId Limit 1];
        }
        CurrentUsr = [SELECT Market__c, DMS_UserID__c, IsPortalEnabled, contactid, Id FROM User WHERE Id =: UserInfo.getUserId()];


        // For Dealer User Creating retail copy
        if (CurrentUsr.ContactId != null) {
            Usr = [SELECT Market__c, contactid, IsPortalEnabled, Id, contact.AccountId FROM User WHERE Id =: UserInfo.getUserId() and User.Profile.UserLicense.Name = 'Partner Community'];


            if (Usr.ContactId != null) {
                contactList = [Select id, AccountId from Contact where id =: usr.ContactId];

                If(contactList != null) {
                    for (Contact con: contactList) {
                        DealeAccId = con.AccountId;
                    }
                }
                if (accList.RecordtypeId == accPerson_RecordTypeId) {
                    Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false and Retail_Duplicate_Flag__c = false];
                }
                if (accList.RecordtypeId == accCompany_RecordTypeId) {
                    Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false and Retail_Duplicate_Flag__c = false];
                }


                if (Accountlinklist == null || Accountlinklist.isempty()) {

                    if (accList.RecordtypeId == accPerson_RecordTypeId) {

                        newAlk = new Account_Link__c();
                        newAlk.toRole__c = AccId;
                        newAlk.Retail_Address_Reference__c = addId;
                        newAlk.fromRole__c = DealeAccId;
                        newAlk.RecordTypeId = alkPerson_RecordTypeId;
                        if (accList.MD__c == 'TH') {
                            if (!SelectedAdd.isEmpty() && SelectedAdd[0] != null) {
                                newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].Sub_District__c;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                            }
                            newAlk.Retail_Salutation__c = acclist.Salutation__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.Retail_ID_Type__c = acclist.ID_Type__c;
                            newAlk.Retail_ID_Number__c = acclist.ID_Number__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
                            newAlk.Retail_Special_Care__c = acclist.Special_Care__c;
                            newAlk.Retail_LastName_Native__c = accList.LastName_Native_1__c;
                            newAlk.Retail_FirstName_Native__c = accList.FirstName_Native_1__c;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_DMS_Customer_ID__c = accList.DMS_Customer_ID__c;
                            newAlk.Retail_Full_Name__c = accList.FirstName + ' ' + accList.LastName;
                            newAlk.Retail_Full_Name_Title__c = ((acclist.Salutation__c != null ? acclist.Salutation__c : '') + ' ' + (accList.FirstName != null ? accList.FirstName : '') + ' ' + (accList.LastName != null ? accList.LastName : '')).left(140);
                            newAlk.Retail_LastName__c = accList.LastName;
                            newAlk.Retail_FirstName__c = accList.FirstName;
                            newAlk.Retail_Complaint_Amount__c = accList.Complaint_Amount__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Allow_Data_Sharing__c = accList.Allow_Data_Sharing__c;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Individual_Home_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Work_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.PersonEmail;
                            newAlk.Retail_Fax__c = accList.Fax;
                            newAlk.Retail_Preferred_Contact_Method__c = accList.Preferred_Contact_Method__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;

                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_PersonBirthdate__c = accList.PersonBirthdate;
                            newAlk.Retail_Occupation__c = accList.Occupation__c;
                            newAlk.Retail_Position__c = accList.Job__c;
                            newAlk.Retail_Preferred_Language__c = 'Thai';
                            newAlk.Retail_Gender__c = accList.Gender__c;
                            newAlk.Retail_Industry__c = accList.industry;
                            newAlk.Retail_WebSite__c = accList.Website;
                            //newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;

                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            if (accList.Foundation_Date__c != null) {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) : String.ValueOf(accList.Foundation_Date__c.month())) + (String.ValueOf(accList.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.day())) : String.ValueOf(accList.Foundation_Date__c.day()));
                            
							}
                        }
                        // if market is MY
                        if (accList.MD__c == 'MY') {
                            if (SelectedAdd[0] != null) {
                                newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].District__c ;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c+' '+SelectedAdd[0].Block__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
								newAlk.Retail_Address_Line_3__c = SelectedAdd[0].Address_Line_3__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Country__c = SelectedAdd[0].Country__c;
								newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                           
                            }
                             newAlk.Retail_Salutation__c = acclist.Title__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.Retail_ID_Type__c = acclist.ID_Type__c;
                            newAlk.Retail_ID_Number__c = acclist.ID_Number__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
							newAlk.Retail_Race__c=acclist.Race__c;
                            newAlk.Retail_Special_Care__c = acclist.Special_Care__c;
                            newAlk.Retail_LastName_Native__c = accList.LastName_Native_1__c;
                            newAlk.Retail_FirstName_Native__c = accList.FirstName_Native_1__c;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_Full_Name__c = accList.FirstName + ' ' + accList.LastName ;
                            newAlk.Retail_Full_Name_Title__c = ((acclist.Title__c!= null ?acclist.Title__c:'')  + ' ' + (accList.FirstName!= null ?accList.FirstName:'') + ' ' +(accList.LastName!= null ?accList.LastName:'')).left(140) ;
                            newAlk.Retail_LastName__c = accList.LastName;
                            newAlk.Retail_FirstName__c = accList.FirstName;
                            newAlk.Retail_Complaint_Amount__c = accList.Complaint_Amount__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Allow_Data_Sharing__c = accList.Allow_Data_Sharing__c;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Individual_Home_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Work_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.PersonEmail;
                            newAlk.Retail_Fax__c = accList.Fax;
                            newAlk.Retail_Preferred_Contact_Method__c = accList.Preferred_Contact_Method__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                                                                                                
                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_PersonBirthdate__c = accList.PersonBirthdate;
                            newAlk.Retail_Occupation__c = accList.Occupation__c;
                            newAlk.Retail_Position__c = accList.Job__c;
                            newAlk.Retail_Preferred_Language__c = accList.Preferred_Language__c;
                            newAlk.Retail_Gender__c = accList.Gender__c;
                            newAlk.Retail_Industry__c = accList.industry;
                            newAlk.Retail_WebSite__c = accList.Website;
                            //newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;

                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            if(accList.Foundation_Date__c != null)
                            {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) :String.ValueOf(accList.Foundation_Date__c.month())) ;
                            }
                        }
                        InsertAlk.add(newAlk);

                    }
                    if (accList.RecordtypeId == accCompany_RecordTypeId) {


                        newAlk = new Account_Link__c();
                        newAlk.toRole__c = AccId;
                        newAlk.Retail_Address_Reference__c = addId;
                        newAlk.fromRole__c = DealeAccId;
                        newAlk.RecordTypeId = alkCompany_RecordTypeId;
                        if (accList.MD__c == 'TH') {
                            if (!SelectedAdd.isEmpty() && SelectedAdd[0] != null) {
                                newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].Sub_District__c;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                            }
                            newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
                            newAlk.Retail_DMS_Customer_ID__c = accList.DMS_Customer_ID__c;
                            newAlk.Retail_Company_Name__c = accList.name;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Company_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Company_Other_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.email__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_Fax__c = accList.fax;
                            newAlk.Retail_Preferred_Language__c = 'Thai';
                            newAlk.Retail_Industry__c = accList.Industry;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            newAlk.Retail_WebSite__c = accList.Website;
                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            if (accList.Foundation_Date__c != null) {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) : String.ValueOf(accList.Foundation_Date__c.month())) + (String.ValueOf(accList.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.day())) : String.ValueOf(accList.Foundation_Date__c.day()));
                            }

                        }
                        //if market is MY
                        if (accList.MD__c == 'MY') {
                            if (SelectedAdd[0] != null) {
                                newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].District__c ;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c+' '+SelectedAdd[0].Block__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
								newAlk.Retail_Address_Line_3__c = SelectedAdd[0].Address_Line_3__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Country__c = SelectedAdd[0].Country__c;
								newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                           
                            }
                            newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
							newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                            newAlk.Retail_Company_Name__c = accList.name;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Company_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Company_Other_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.email__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_Fax__c = accList.fax;
							newAlk.Retail_Position__c=acclist.Job__c;
                            newAlk.Retail_Preferred_Language__c = accList.Preferred_Language__c;
                            newAlk.Retail_Industry__c = accList.Industry;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            newAlk.Retail_WebSite__c = accList.Website;
                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            if(accList.Foundation_Date__c != null)
                            {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) :String.ValueOf(accList.Foundation_Date__c.month()));
                            }
                        }
                        InsertAlk.add(newAlk);
                        System.debug('newAlk newAlk%%%%%%%' + newAlk);

                    }
                } else if (Accountlinklist != null) {
                    ShowHideError = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.Retail_copy_is_already_present));
                }


            }
        }


        // For MBJ User Creating retail copy
        if (CurrentUsr.ContactId == null) {
            //For MBJ User if user not selected  Dealer Outlet display error message
            if (account.Main_Dealer__c == null && account.Main_Dealer__c == null) {
                ShowHideError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Please_Select_Dealer));
            }
            System.debug('CurrentUsr %%%%%%%' + CurrentUsr);
            if (accList.RecordtypeId == accPerson_RecordTypeId) {
                Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false and Retail_Duplicate_Flag__c = false];
            }
            if (accList.RecordtypeId == accCompany_RecordTypeId) {
                Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Duplicate_Flag__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false and Retail_Duplicate_Flag__c = false];
            }

            System.debug('#$#$#$####$' + account.Main_Dealer__c);


            if (Accountlinklist == null || Accountlinklist.isempty() && account.Main_Dealer__c != null) {

                if (accList.RecordtypeId == accPerson_RecordTypeId) {

                    newAlk = new Account_Link__c();
                    newAlk.toRole__c = AccId;
                    newAlk.Retail_Address_Reference__c = addId;
                    newAlk.fromRole__c = account.Main_Dealer__c;
                    newAlk.RecordTypeId = alkPerson_RecordTypeId;
                    if (accList.MD__c == 'TH') {
                        if (!SelectedAdd.isEmpty() && SelectedAdd[0] != null) {
                            newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                            newAlk.Retail_City__c = SelectedAdd[0].Sub_District__c;
                            newAlk.Retail_Distinct__c = SelectedAdd[0].District__c;
                            newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                            newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
                            newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                            newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                            newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                            newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                        }
                        newAlk.Retail_Salutation__c = acclist.Salutation__c;
                        newAlk.Retail_Country__c = acclist.country__c;
                        newAlk.Retail_ID_Type__c = acclist.ID_Type__c;
                        newAlk.Retail_ID_Number__c = acclist.ID_Number__c;
                        newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                        newAlk.createddate__c = accList.createdDate;
                        newAlk.Retail_Special_Care__c = acclist.Special_Care__c;
                        newAlk.Retail_LastName_Native__c = accList.LastName_Native_1__c;
                        newAlk.Retail_FirstName_Native__c = accList.FirstName_Native_1__c;
                        newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                        newAlk.Retail_DMS_Customer_ID__c = accList.DMS_Customer_ID__c;
                        newAlk.Retail_Full_Name__c = accList.FirstName + ' ' + accList.LastName;
                        newAlk.Retail_LastName__c = accList.LastName;
                        newAlk.Retail_FirstName__c = accList.FirstName;
                        newAlk.Retail_Full_Name_Title__c = ((acclist.Salutation__c != null ? acclist.Salutation__c : '') + ' ' + (accList.FirstName != null ? accList.FirstName : '') + ' ' + (accList.LastName != null ? accList.LastName : '')).left(140);
                        newAlk.Retail_Complaint_Amount__c = accList.Complaint_Amount__c;
                        newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                        newAlk.Retail_UCID__c = accList.UCID__c;
                        newAlk.Retail_Allow_Data_Sharing__c = accList.Allow_Data_Sharing__c;
                        newAlk.Retail_Mobile__c = accList.Mobile__c;
                        newAlk.Retail_Individual_Home_Phone__c = accList.Individual_Home_Phone__c;
                        newAlk.Retail_Work_Phone__c = accList.Work_Phone__c;
                        newAlk.Retail_Email__c = accList.PersonEmail;
                        newAlk.Retail_Fax__c = accList.Fax;
                        newAlk.Retail_Preferred_Contact_Method__c = accList.Preferred_Contact_Method__c;
                        newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                        newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;

                        newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                        newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                        newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                        newAlk.Retail_PersonBirthdate__c = accList.PersonBirthdate;
                        newAlk.Retail_Occupation__c = accList.Occupation__c;
                        newAlk.Retail_Position__c = accList.Job__c;
                        newAlk.Retail_Preferred_Language__c = 'Thai';
                        newAlk.Retail_Gender__c = accList.Gender__c;
                        newAlk.Retail_Industry__c = accList.industry;
                        newAlk.Retail_WebSite__c = accList.Website;
                        //newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                        newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;

                        newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                        newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                        newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                        newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                        newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                        if (accList.Foundation_Date__c != null) {
                            newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) : String.ValueOf(accList.Foundation_Date__c.month())) + (String.ValueOf(accList.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.day())) : String.ValueOf(accList.Foundation_Date__c.day()));
                        }
                    }
                    // if market is MY
                    if (accList.MD__c == 'MY') {
                        if (SelectedAdd[0] != null) {
                            newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].District__c ;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c+' '+SelectedAdd[0].Block__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
								newAlk.Retail_Address_Line_3__c = SelectedAdd[0].Address_Line_3__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Country__c = SelectedAdd[0].Country__c;
								newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                         
                        }
                         newAlk.Retail_Salutation__c = acclist.Title__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.Retail_ID_Type__c = acclist.ID_Type__c;
                            newAlk.Retail_ID_Number__c = acclist.ID_Number__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
							newAlk.Retail_Race__c=acclist.Race__c;
                            newAlk.Retail_Special_Care__c = acclist.Special_Care__c;
                            newAlk.Retail_LastName_Native__c = accList.LastName_Native_1__c;
                            newAlk.Retail_FirstName_Native__c = accList.FirstName_Native_1__c;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_Full_Name__c = accList.FirstName + ' ' + accList.LastName ;
                            newAlk.Retail_Full_Name_Title__c = ((acclist.Title__c!= null ?acclist.Title__c:'')  + ' ' + (accList.FirstName!= null ?accList.FirstName:'') + ' ' +(accList.LastName!= null ?accList.LastName:'')).left(140) ;
                            newAlk.Retail_LastName__c = accList.LastName;
                            newAlk.Retail_FirstName__c = accList.FirstName;
                            newAlk.Retail_Complaint_Amount__c = accList.Complaint_Amount__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Allow_Data_Sharing__c = accList.Allow_Data_Sharing__c;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Individual_Home_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Work_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.PersonEmail;
                            newAlk.Retail_Fax__c = accList.Fax;
                            newAlk.Retail_Preferred_Contact_Method__c = accList.Preferred_Contact_Method__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                                                                                                
                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_PersonBirthdate__c = accList.PersonBirthdate;
                            newAlk.Retail_Occupation__c = accList.Occupation__c;
                            newAlk.Retail_Position__c = accList.Job__c;
                            newAlk.Retail_Preferred_Language__c = accList.Preferred_Language__c;
                            newAlk.Retail_Gender__c = accList.Gender__c;
                            newAlk.Retail_Industry__c = accList.industry;
                            newAlk.Retail_WebSite__c = accList.Website;
                            //newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;

                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            if(accList.Foundation_Date__c != null)
                            {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) :String.ValueOf(accList.Foundation_Date__c.month())) ;
                            }
                    }
                    InsertAlk.add(newAlk);

                }
                if (accList.RecordtypeId == accCompany_RecordTypeId) {


                    newAlk = new Account_Link__c();
                    newAlk.toRole__c = AccId;
                    newAlk.Retail_Address_Reference__c = addId;
                    newAlk.fromRole__c = account.Main_Dealer__c;
                    newAlk.RecordTypeId = alkCompany_RecordTypeId;
                    if (accList.MD__c == 'TH') {
                        if (!SelectedAdd.isEmpty() && SelectedAdd[0] != null) {
                            newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                            newAlk.Retail_City__c = SelectedAdd[0].Sub_District__c;
                            newAlk.Retail_Distinct__c = SelectedAdd[0].District__c;
                            newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                            newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
                            newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                            newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                            newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                            newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                        }
                        newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                        newAlk.createddate__c = accList.createdDate;
                        newAlk.Retail_Country__c = acclist.country__c;
                        newAlk.Retail_Email__c = accList.email__c;
                        newAlk.Retail_UCID__c = accList.UCID__c;
                        newAlk.Retail_DMS_Customer_ID__c = accList.DMS_Customer_ID__c;
                        newAlk.Retail_Company_Name__c = accList.name;
                        newAlk.Retail_Mobile__c = accList.Mobile__c;
                        newAlk.Retail_Preferred_Language__c = 'Thai';
                        newAlk.Retail_Company_Phone__c = accList.Individual_Home_Phone__c;
                        newAlk.Retail_Company_Other_Phone__c = accList.Work_Phone__c;
                        newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                        newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                        newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                        newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                        newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                        newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                        newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                        newAlk.Retail_Fax__c = accList.fax;
                        newAlk.Retail_Industry__c = accList.Industry;
                        newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;
                        newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                        newAlk.Retail_WebSite__c = accList.Website;
                        newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                        newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                        newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                        newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                        if (accList.Foundation_Date__c != null) {
                            newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) : String.ValueOf(accList.Foundation_Date__c.month())) + (String.ValueOf(accList.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.day())) : String.ValueOf(accList.Foundation_Date__c.day()));
                        }

                        //newAlk.Retail_Foundation_Month__c=    acclist.Foundation_Date__c ;
                    }
                    // if market is MY
                    if (accList.MD__c == 'MY') {
                        if (SelectedAdd[0] != null) {
                            newAlk.Retail_Province__c = SelectedAdd[0].Province__c;
                                newAlk.Retail_City__c = SelectedAdd[0].District__c ;
                                newAlk.Retail_Distinct__c = SelectedAdd[0].District__c+' '+SelectedAdd[0].Block__c;
                                newAlk.Retail_Address_Line_1__c = SelectedAdd[0].Address_Line_1__c;
                                newAlk.Retail_Address_Line_2__c = SelectedAdd[0].Address_Line_2__c;
								newAlk.Retail_Address_Line_3__c = SelectedAdd[0].Address_Line_3__c;
                                newAlk.Retail_Address_Type__c = SelectedAdd[0].Address_Type__c;
                                newAlk.Retail_ZipCode__c = SelectedAdd[0].ZipCode__c;
                                newAlk.Retail_Country__c = SelectedAdd[0].Country__c;
								newAlk.Retail_Address_CreatedDate__c = date.newinstance(SelectedAdd[0].CreatedDate.year(), SelectedAdd[0].CreatedDate.month(), SelectedAdd[0].CreatedDate.day());
                                newAlk.Retail_Address_LastModifiedDate__c = date.newinstance(SelectedAdd[0].LastModifiedDate.year(), SelectedAdd[0].LastModifiedDate.month(), SelectedAdd[0].LastModifiedDate.day());
                         
                        }
                       newAlk.Retail_UCID__c = accList.UCID__c;
                            newAlk.Retail_Country__c = acclist.country__c;
                            newAlk.LastModifiedDate__c = accList.LastmodifiedDate;
                            newAlk.createddate__c = accList.createdDate;
							newAlk.Retail_Company_Name_Native1__c = accList.Company_Name_Native_1__c;
                            newAlk.Retail_Company_Name__c = accList.name;
                            newAlk.Retail_Mobile__c = accList.Mobile__c;
                            newAlk.Retail_Company_Phone__c = accList.Individual_Home_Phone__c;
                            newAlk.Retail_Company_Other_Phone__c = accList.Work_Phone__c;
                            newAlk.Retail_Email__c = accList.email__c;
                            newAlk.Retail_Email_OptOut__c = accList.PersonHasOptedOutOfEmail;
                            newAlk.Retail_Fax_OptOut__c = accList.PersonHasOptedOutOfFax;
                            newAlk.Retail_Primary_Phone__c = accList.Primary_Phone__c;
                            newAlk.Retail_Sales_Sanction__c = accList.Sales_Sanction__c;
                            newAlk.Retail_Phone_OptOut__c = accList.PersonDoNotCall;
                            newAlk.Retail_Postal_OptOut__c = accList.Postal_Opt_Out__c;
                            newAlk.Retail_Visit_OptOut__c = accList.Visit_Opt_Out__c;
                            newAlk.Retail_Fax__c = accList.fax;
							newAlk.Retail_Position__c=acclist.Job__c;
                            newAlk.Retail_Preferred_Language__c = accList.Preferred_Language__c;
                            newAlk.Retail_Industry__c = accList.Industry;
                            newAlk.Retail_Commercial_Reg_No__c = accList.Commercial_Reg_No__c;
                            newAlk.Retail_Vat_No__c = accList.Vat_No__c;
                            newAlk.Retail_WebSite__c = accList.Website;
                            newAlk.Retail_Agreement__c = accList.Personal_Agreement__c;
                            newAlk.Retail_Information_Third_Party_Release__c = accList.Personal_Information_Third_Party_Release__c;
                            newAlk.Retail_Abroad_Agreement__c = accList.Personal_Abroad_Agreement__c;
                            newAlk.Retail_Agreement_Info_Processing__c = accList.Agreement_to_commit_info_processing__c;
                            if(accList.Foundation_Date__c != null)
                            {
                                newAlk.Retail_Foundation_Month__c = String.valueOf(accList.Foundation_Date__c.year()) + (String.ValueOf(accList.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(accList.Foundation_Date__c.month())) :String.ValueOf(accList.Foundation_Date__c.month())) ;
                            }
                    }
                    InsertAlk.add(newAlk);
                    System.debug('newAlk newAlk%%%%%%%' + newAlk);

                }
            } else if (Accountlinklist != null && account.Main_Dealer__c != null) {
                ShowHideError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.Retail_copy_is_already_present));
            }

        }
        if (InsertAlk != null && InsertAlk.size() > 0) {
            insert InsertAlk;
        }

    }

    public PageReference cancel() {
        /* PageReference page = new PageReference('{!URLFOR($Site.Prefix)}/'+AccId);
           page.setRedirect(true);
           return page; */
        PageReference pageRef;
        pageRef = new PageReference('/001/o');
        return PageRef;
        //return new PageReference('{!URLFOR($Site.Prefix)}'+AccId);
    }

}