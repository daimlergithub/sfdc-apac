/*
  1.New Account Link record will create when assigned dealer is populated.
  Created By: Kiran
  Date: 2016-9-23
*/
public class LeadHelperAccountLinkCreateJP {
    private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    private static final String alkContactSectorRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    private static final String PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static final String AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    //static user usr = [select id,profileId,profile.Name from User WHERE Id =: userInfo.getUserId()];   
    public static void leadAccountDetails(list < Lead__c > leadlst, map < id, Lead__c > leadOldMap, boolean isInsert, boolean isUpdate) {

        if (leadutil.leadAccountDetails) {

            set < String > contactId = new set < String > ();
            set < Id > OldDealerID = new set < Id > ();
            set < Id > NewDealerID = new set < Id > ();


            for (Lead__c le: leadlst) {
                if (le.MD__c == label.MarketJP) {
                    if (le.Assigned_Dealer__c != null && ((le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated' && leadOldMap.get(le.id).CAC_Lead_Status__c == 'Approved')) ||
                            (le.CAC_Lead_Status__c == 'Approved' || le.CAC_Lead_Status__c == 'Allocated' && (le.Assigned_Dealer__c != null || leadOldMap.get(le.id).Assigned_Dealer__c != le.Assigned_Dealer__c)))) {
                        if (isInsert || ((isUpdate && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c) || (isUpdate && leadOldMap.get(le.id).Assigned_Dealer__c != le.Assigned_Dealer__c || leadOldMap.get(le.id).Contact__c != le.Contact__c))) {
                            System.debug('Is Insert OR Update called -----:::::');
                            contactId.add(le.id);
                            if (isInsert || (isUpdate && leadOldMap.get(le.id).Assigned_Dealer__c != le.Assigned_Dealer__c || leadOldMap.get(le.id).Contact__c != le.Contact__c)) {
                                System.debug('^&^&^&^&&^ l');
                                contactId.add(le.id);
                            }
                        }
                    }
                    if (le.Assigned_Dealer__c != null && isUpdate && ((le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated')) || (le.CAC_Lead_Status__c == 'Approved' || (le.CAC_Lead_Status__c == 'Allocated') && (leadOldMap.get(le.id).Assigned_Dealer__c != le.Assigned_Dealer__c) || leadOldMap.get(le.id).Contact__c != le.Contact__c)) && (userinfo.getusertype() == 'Powerpartner')) {
                        contactId.add(le.id);

                        if (leadOldMap.get(le.id).Assigned_Dealer__c != le.Assigned_Dealer__c || leadOldMap.get(le.id).Contact__c != le.Contact__c) {
                            contactId.add(le.id);
                        }
                    }
                } else if (le.Assigned_Dealer__c != null && le.MD__c == Label.MarketKR) {
                    if (isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)) {
                        System.debug('Is Insert OR Update called -----:::::');
                        contactId.add(le.id);
                    }
                }

            }
            System.debug('^&^&^&^&&^ contactId' + contactId);
            if (!contactId.isEmpty()) {
                createAccountLinkRecord(contactId);
            }
        }
        //if(usr.profile.Name.contains('Japan Dealer'))    
        //leadutil.leadAccountDetails = false;  
    }


    public static void createAccountLinkRecord(set < String > contactId) {
        //LeadUtil.leadAccountlnktrigger = false;
        set < String > actlnkids = new set < String > ();
        set < String > dealerId = new set < String > ();
        set < String > AcclinkContactId = new set < String > ();
		set < String > AcclinkCompanyAccountId = new set < String > ();
        set < String > CompanyId = new set < String > ();
		List<Address__c> ListAddress=new List<Address__c>();
        Map < Id, Lead__c > leadupdate = new Map < Id, Lead__C > ();
        List < Lead__c > leadLst = [select Id, Retail_Contact__c, Company_Account__c, Contact__c, Assigned_Dealer__c, Contact__r.LastName, Contact__r.FirstName, Contact__r.LastName_Native_1__c,Contact__r.ID_Type__c,Contact__r.ID_Number__c,contact__r.country__c,
            Contact__r.FirstName_Native_1__c, Contact__r.PersonBirthdate, Contact__r.Special_Care__c, Contact__r.Individual_Home_Phone__c, Contact__r.Work_Phone__c, Contact__r.Primary_Address_Reference__r.Sub_District__c,
            Contact__r.Mobile__c, Contact__r.Fax, Contact__r.Email__c, Contact__r.Primary_Address_Reference__r.City__c, Contact__r.Primary_Address_Reference__r.District__c,Contact__r.createdDate,Contact__r.lastmodifieddate,
            Contact__r.Primary_Address_Reference__r.Block__c, Contact__r.Primary_Address_Reference__r.Address_Line_1__c,
            Contact__r.Primary_Address_Reference__r.Address_Line_2__c, Contact__r.Primary_Address_Reference__r.ZipCode__c,
            Contact__r.Primary_Address_Reference__r.CreatedDate, Contact__r.Primary_Address_Reference__r.LastModifiedDate,
            Contact__r.gender__c, contact__r.Occupation__c,Contact__r.Primary_Phone__c, Contact__r.Industry, Contact__r.Preferred_Language__c,
            Contact__r.Special_Needs_Class__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.Primary_Address_Reference__r.Address_Type__c,
            Contact__r.Primary_Address_Reference__r.Province__c, Contact__r.Preferred_Contact_Method__c, MD__c,
            Contact__r.UCID__c,Contact__r.Salutation__c, Contact__r.RecordtypeId, Contact__r.Name, Contact__r.Company_Name_Native_1__c, Contact__r.Foundation_Date__c,Contact__r.Primary_Address_Reference__r.Foreign_Nationals__c,
            Contact__r.Website, Contact__r.Vat_No__c, Contact__r.DMS_Customer_ID__c, Contact__r.Complaint_Amount__c, Contact__r.Sales_Sanction__c, Contact__r.Allow_Data_Sharing__c, Contact__r.PersonEmail, Contact__r.PersonHasOptedOutOfEmail, Contact__r.PersonHasOptedOutOfFax, Contact__r.Primary_Phone_Display__c, Contact__r.PersonDoNotCall, Contact__r.Postal_Opt_Out__c, Contact__r.Job__c, Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c, Contact__r.Commercial_Reg_No__c, Contact__r.Company_Name__c, Contact__r.Visit_Opt_Out__c,Company_Account__r.RecordTypeId,Company_Account__r.UCID__c
            from Lead__c WHERE id IN: contactId
        ];
        List < Account_Link__c > accLst = new List < Account_Link__c > ();

        for (Lead__c dealerLead: leadLst) {
            if (dealerLead.Assigned_Dealer__c != null)
                dealerId.add(dealerLead.Assigned_Dealer__c);
            if (dealerLead.Contact__c != null)
                AcclinkContactId.add(dealerLead.Contact__c);
			if (dealerLead.Company_Account__c != null)
                AcclinkCompanyAccountId.add(dealerLead.Company_Account__c);	

        }

        System.debug('@#$%%%%%% AcclinkContactId' + AcclinkContactId);
        System.debug('@#$%%%%%% CompanyId' + CompanyId);
        System.debug('@#$%%%%%% leadLst' + leadLst);
        List < Account_Link__c > dealercount = [select id from Account_Link__c WHERE fromRole__c IN: dealerId AND(toRole__c IN: AcclinkContactId OR toRole__c IN: CompanyId) AND(RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        system.debug('########' + dealercount);
		List < Account_Link__c > retailcompanycopy = [select id from Account_Link__c WHERE fromRole__c IN: dealerId AND toRole__c IN: AcclinkCompanyAccountId AND RecordTypeId =: alkCompanyRecordTypeId AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];
        system.debug('########retailcompanycopy' + retailcompanycopy);
        for (Lead__c led: leadlst) {
            if (led.Assigned_Dealer__c != null && ((dealercount.isEmpty() || dealercount == null || dealercount.size() == 0)||(retailcompanycopy.isEmpty() || retailcompanycopy== null || retailcompanycopy.size() == 0))) {
               // Account_Link__c acclnk = new Account_Link__c(RecordTypeId = alkContactSectorRecordTypeId, toRole__c = //led.Contact__c, fromRole__c = led.Assigned_Dealer__c); 
				Account_Link__c acclnk = new Account_Link__c(); 
                //accLst.add(acclnk); 
                if (led.Contact__r.RecordTypeId == PersonRecordTypeId && (dealercount.isEmpty() || dealercount == null || dealercount.size() == 0)) {

                    acclnk = new Account_Link__c(RecordTypeId = alkpersonRecordTypeId, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                    /*if (led.MD__c == 'TH') {
                        if (led.Contact__r.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Contact__r.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Contact__r.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Contact__r.Primary_Address_Reference__r.District__c;
                            
                                
                            acclnk.Retail_Address_Line_1__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Contact__r.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());

                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                            System.debug('**prprpr*'+acclnk.Retail_Address_CreatedDate__c + acclnk.Retail_Address_LastModifiedDate__c + date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day()));
                        }
                        acclnk.Retail_Country__c = led.contact__r.country__c;
                        acclnk.Retail_Full_Name_Title__c = (led.contact__r.Salutation__c + ' ' + led.Contact__r.FirstName+' '+led.Contact__r.LastName).left(140) ;
                        acclnk.Retail_Salutation__c=led.Contact__r.Salutation__c;
                        acclnk.Retail_Special_Care__c=led.Contact__r.Special_Care__c;
                        acclnk.createddate__c = led.Contact__r.createdDate;
                        acclnk.Retail_ID_Type__c = led.Contact__r.ID_Type__c;
                        acclnk.Retail_ID_Number__c = led.Contact__r.ID_Number__c;
                        acclnk.LastModifiedDate__c = led.Contact__r.LastmodifiedDate;
                        acclnk.Retail_LastName_Native__c=led.Contact__r.LastName_Native_1__c;
                        acclnk.Retail_FirstName_Native__c = led.Contact__r.FirstName_Native_1__c;
                        acclnk.Retail_Primary_Phone__c =led.Contact__r.Primary_Phone__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Contact__r.DMS_Customer_ID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Contact__r.DMS_Customer_ID__c;
                        acclnk.Retail_Full_Name__c =  led.Contact__r.FirstName +' '+ led.Contact__r.LastName ;
                        acclnk.Retail_LastName__c = led.Contact__r.LastName;
                        acclnk.Retail_FirstName__c = led.Contact__r.FirstName;
                        acclnk.Retail_Complaint_Amount__c = led.Contact__r.Complaint_Amount__c;
                        acclnk.Retail_Sales_Sanction__c = led.Contact__r.Sales_Sanction__c;
                        acclnk.Retail_UCID__c = led.Contact__r.UCID__c;
                        acclnk.Retail_Allow_Data_Sharing__c = led.Contact__r.Allow_Data_Sharing__c;
                        acclnk.Retail_Mobile__c = led.Contact__r.Mobile__c;
                        acclnk.Retail_Individual_Home_Phone__c = led.Contact__r.Individual_Home_Phone__c;
                        acclnk.Retail_Work_Phone__c = led.Contact__r.Work_Phone__c;
                        acclnk.Retail_Email__c = led.Contact__r.PersonEmail;
                        acclnk.Retail_Fax__c = led.Contact__r.Fax;
                        acclnk.Retail_Preferred_Contact_Method__c = led.Contact__r.Preferred_Contact_Method__c;
                        acclnk.Retail_Email_OptOut__c = led.Contact__r.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Contact__r.PersonHasOptedOutOfFax;
                        //acclnk.Retail_Primary_Phone__c = led.Contact__r.Primary_Phone_Display__c;
                        acclnk.Retail_Phone_OptOut__c = led.Contact__r.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Contact__r.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Contact__r.Visit_Opt_Out__c;
                        acclnk.Retail_PersonBirthdate__c = led.Contact__r.PersonBirthdate;
                        acclnk.Retail_Occupation__c = led.Contact__r.Occupation__c;
                        acclnk.Retail_Position__c = led.Contact__r.Job__c;
                        acclnk.Retail_Preferred_Language__c = 'Thai';
                        acclnk.Retail_Gender__c = led.Contact__r.Gender__c;
                        acclnk.Retail_Industry__c = led.Contact__r.industry;
                        acclnk.Retail_WebSite__c = led.Contact__r.Website;
                        acclnk.Retail_Company_Name_Native1__c = led.Contact__r.Company_Name_Native_1__c;
                        acclnk.Retail_Commercial_Reg_No__c = led.Contact__r.Commercial_Reg_No__c;
                        
                        acclnk.Retail_Agreement__c = led.Contact__r.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Contact__r.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Contact__r.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Contact__r.Agreement_to_commit_info_processing__c;
                        acclnk.Retail_Vat_No__c = led.Contact__r.Vat_No__c;
						if(led.Contact__r.Foundation_Date__c != null)
						 acclnk.Retail_Foundation_Month__c = String.valueOf(led.Contact__r.Foundation_Date__c.year()) + (String.ValueOf(led.Contact__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.month())) :String.ValueOf(led.Contact__r.Foundation_Date__c.month()))  +(String.ValueOf(led.Contact__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.day())) :String.ValueOf(led.Contact__r.Foundation_Date__c.day()));
                    }*/
					 accLst.add(acclnk);
                } else if (led.Contact__r.RecordTypeId == AccountCompanyId) {

                    acclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, Name = led.Contact__r.UCID__c, toRole__c = led.Contact__c, fromRole__c = led.Assigned_Dealer__c);
                    /*if (led.MD__c == 'TH') {
                        if (led.Contact__r.Primary_Address_Reference__c != null) {
                            acclnk.Retail_Province__c = led.Contact__r.Primary_Address_Reference__r.Province__c;
                            acclnk.Retail_City__c = led.Contact__r.Primary_Address_Reference__r.Sub_District__c;
                            acclnk.Retail_Distinct__c = led.Contact__r.Primary_Address_Reference__r.District__c;
                            acclnk.Retail_Address_Line_1__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c;
                            acclnk.Retail_Address_Line_2__c = led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c;
                            acclnk.Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c;
                            acclnk.Retail_ZipCode__c = led.Contact__r.Primary_Address_Reference__r.ZipCode__c;
                            acclnk.Retail_Address_CreatedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day());
                            //System.debug(date.newinstance(led.Contact__r.Primary_Address_Reference__r.CreatedDate.year(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.month(), led.Contact__r.Primary_Address_Reference__r.CreatedDate.day()));
                            acclnk.Retail_Address_LastModifiedDate__c = date.newinstance(led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.year(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.month(), led.Contact__r.Primary_Address_Reference__r.Lastmodifieddate.day());
                        }
						acclnk.Retail_Country__c = led.contact__r.country__c;
                        acclnk.Retail_UCID__c = led.Contact__r.UCID__c;
                        acclnk.Retail_DMS_Customer_ID__c = led.Contact__r.DMS_Customer_ID__c;
                        acclnk.Retail_Company_Name__c = led.Contact__r.name;
                        acclnk.createddate__c = led.Contact__r.createdDate;
                        acclnk.LastModifiedDate__c = led.Contact__r.LastmodifiedDate;
                        acclnk.Retail_Company_Phone__c = led.Contact__r.Individual_Home_Phone__c;
                        acclnk.Retail_Company_Other_Phone__c = led.Contact__r.Work_Phone__c;
                        acclnk.Retail_Mobile__c = led.Contact__r.Mobile__c;
                        acclnk.Retail_Email_OptOut__c = led.Contact__r.PersonHasOptedOutOfEmail;
                        acclnk.Retail_Fax_OptOut__c = led.Contact__r.PersonHasOptedOutOfFax;
                        acclnk.Retail_Primary_Phone__c = led.Contact__r.Primary_Phone__c;
                        acclnk.Retail_Sales_Sanction__c = led.Contact__r.Sales_Sanction__c;
                        acclnk.Retail_Phone_OptOut__c = led.Contact__r.PersonDoNotCall;
                        acclnk.Retail_Postal_OptOut__c = led.Contact__r.Postal_Opt_Out__c;
                        acclnk.Retail_Visit_OptOut__c = led.Contact__r.Visit_Opt_Out__c;
                        acclnk.Retail_Fax__c = led.Contact__r.fax;
                        acclnk.Retail_Industry__c = led.Contact__r.Industry;
                        acclnk.Retail_Commercial_Reg_No__c = led.Contact__r.Commercial_Reg_No__c;
                        acclnk.Retail_Vat_No__c = led.Contact__r.Vat_No__c;
                        acclnk.Retail_WebSite__c = led.Contact__r.Website;
                        acclnk.Retail_Agreement__c = led.Contact__r.Personal_Agreement__c;
                        acclnk.Retail_Information_Third_Party_Release__c = led.Contact__r.Personal_Information_Third_Party_Release__c;
                        acclnk.Retail_Abroad_Agreement__c = led.Contact__r.Personal_Abroad_Agreement__c;
                        acclnk.Retail_Agreement_Info_Processing__c = led.Contact__r.Agreement_to_commit_info_processing__c;
						if(led.Contact__r.Foundation_Date__c != null)
						 acclnk.Retail_Foundation_Month__c = String.valueOf(led.Contact__r.Foundation_Date__c.year()) + (String.ValueOf(led.Contact__r.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.month())) :String.ValueOf(led.Contact__r.Foundation_Date__c.month()))  +(String.ValueOf(led.Contact__r.Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(led.Contact__r.Foundation_Date__c.day())) :String.ValueOf(led.Contact__r.Foundation_Date__c.day()));
                    }*/

                }
				 if (led.Company_Account__r.RecordTypeId == AccountCompanyId && led.MD__c =='KR' && (retailcompanycopy.isEmpty() || retailcompanycopy== null || retailcompanycopy.size() == 0)) {

                    acclnk = new Account_Link__c(RecordTypeId = alkCompanyRecordTypeId, toRole__c = led.Company_Account__c, fromRole__c = led.Assigned_Dealer__c);
					ListAddress= [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City__c,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c, Preferred__c  FROM  Address__c where Preferred__c=true and Customer__c =:led.Company_Account__c limit 1];
                     if(ListAddress.size() >0){
					 acclnk.Retail_Address_Reference__c = ListAddress.size()>0 ? ListAddress[0].id:'';
                     acclnk.Retail_Address_Type__c = ListAddress.size()>0 ? ListAddress[0].Address_Type__c:'';
                     acclnk.Retail_ZipCode__c = ListAddress.size()>0 ? ListAddress[0].ZipCode__c:'';
                     acclnk.Retail_Province__c = ListAddress.size()>0 ? ListAddress[0].Province__c:'';
                     acclnk.Retail_City__c = ListAddress.size()>0 ? ListAddress[0].City__c:'';
                     acclnk.Retail_Distinct__c = ListAddress.size()>0 ? ListAddress[0].District__c:'';
                     acclnk.Retail_Address_Line_1__c = ListAddress.size()>0 ? ListAddress[0].Address_Line_1__c:'';
                     acclnk.Retail_Address_Line_2__c = ListAddress.size()>0 ? ListAddress[0].Address_Line_2__c:'';
					 }
                     accLst.add(acclnk);
                }
                if (led.MD__c == Label.MarketKR) {
                    acclnk.Retail_Country__c = 'Korea';
                } else if (led.MD__c == Label.MarketJP) {
                    acclnk.Retail_Country__c = 'Japan';
											   
													  

                }
                if (led.Contact__r.Primary_Address_Reference__c != null) {
                    acclnk.Retail_Address_Reference__c = led.Contact__r.Primary_Address_Reference__c;

                }
                 if( accLst.isEmpty()){
                   accLst.add(acclnk);
               }
            }
        }
        system.debug('$%%$%$%$$$%' + accLst);
        if (!accLst.isEmpty()) {
            //insert accLst;

            Database.SaveResult[] srList = Database.insert(accLst, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {
                    {
                        actlnkids.add(sr.getid());
                    }

                }
            }

            Account_link__c acclink = new Account_link__c();
            if (!actlnkids.isEmpty()) {
                system.debug('%%^%^%^%contactId^%' + actlnkids);
                system.debug('%%^%^%contactId^%^%' + contactId);
                if (contactId != null && actlnkids != null) {
                    // acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: actlnkids  AND (RecordTypeId=:alkCompanyRecordTypeId  OR RecordTypeId =:alkpersonRecordTypeId ) limit 1];
                    //if(acclink !=null)
                    //{
                    for (Account_link__c al: accLst) {
                        for (Lead__c ld: leadLst) {
                            ld.Retail_Contact__c = al.id;
                            leadupdate.put(ld.id, ld);
                        }
                    }
                }
            }
        }

        Set < string > leadrecId = new set < string > ();
        Set < string > accountlnkid = new set < string > ();
        for (Lead__c leds: leadlst) {
            if (leds.Assigned_Dealer__c != null && dealercount.size() == 1) {
                for (Account_Link__c alk: dealercount) {
                    accountlnkid.add(alk.id);
                    leadrecId.add(leds.id);
                    if (accountlnkid != null && leadrecId != null) {
                        leds.Retail_Contact__c = alk.id;
                        leadupdate.put(leds.id, leds);
                    }
                }
            }
        }
        system.debug('#$%^  LeadUtil.createAccountLinkRecord' + LeadUtil.createAccountLinkRecord);

        if (LeadUtil.createAccountLinkRecord) {
            System.debug('^&^&^&&^&^&^&^& leadupdate.Values()' + leadupdate.Values());
            if (leadupdate != null && leadupdate.Size() > 0) {
                LeadUtil.createAccountLinkRecord = false;
                Update leadupdate.Values();

                //LeadHelperAccountLinkCreateJP.updatingleadAccountDetails(leadrecId, accountlnkid);
                System.debug('^&^&^&&^&^&^&^ venky& leadupdate.Values()' + leadupdate.Values());
            }
            System.debug('^&^&^&&^&^&^&^& outside leadupdate.Values()' + leadupdate.Values());

        }

        system.debug('#$%^  LeadUtil.createAccountLinkRecord' + LeadUtil.createAccountLinkRecord);
    }
    /*Update Retail_Contact__c with the record Id of retail copy of the corresponding Account linked to the Leads record that belongs to the assigned dealer
     *SFDCJP-994
     *Sivaram
     *Japan 2.0
     */
    /*  public static void updatingleadAccountDetails(set<String> leadrecId, set<string> accountlnkid){
    
     if(LeadUtil.updatingleadAccountDetails)
     {
  list<lead__c> leadupdate = new list<lead__c>();
  Account_Link__c acclink=new Account_Link__c ();
  list<Lead__c> leadlistrecords= new list<lead__c>();
  if(leadrecId !=null)
  {
        leadlistrecords = [select id, Name from Lead__c WHERE ID IN : leadrecId];
      } 
      if(accountlnkid !=null )
      {
      system.debug('alkCompanyRecordTypeId'+alkCompanyRecordTypeId);
       system.debug('alkpersonRecordTypeId'+alkpersonRecordTypeId);
      acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: accountlnkid  AND(RecordTypeId=:alkCompanyRecordTypeId  OR RecordTypeId =:alkpersonRecordTypeId ) limit 1];
      
      }
      if(leadlistrecords!=null)
      {
      for(Lead__c ld : leadlistrecords ){
          ld.Retail_Contact__c = acclink.id;
          leadupdate.add(ld);          
      }
      }
      if(leadupdate!=null)
      {
      update leadupdate;
      }
      }
      LeadUtil.updatingleadAccountDetails=false;
  }
  public static void updatingleadcontactDetails(list<Lead__c> leadlst,boolean isInsert, boolean isUpdate ){
  set<String> contctid = new set<string>();
  set<String> AssignedDealer = new set<string>();
  list<lead__c> leadupdate = new list<lead__c>();
  List<Account_Link__c> acclink = new List<Account_Link__c>();
  for(Lead__C led : leadlst){
      if(led.Assigned_Dealer__c != null){
          AssignedDealer.add(led.Assigned_Dealer__c);
          contctid.add(led.contact__c);
      }    
  }
  //if(!contctid.isempty()){
   acclink = [select id,Name, RecordType.DeveloperName,fromRole__c ,Torole__c from Account_Link__c WHERE fromRole__c IN: AssignedDealer and Torole__c=:contctid and  (RecordType.DeveloperName = 'Retail_Company' OR RecordType.DeveloperName = 'Retail_Person') limit 1];
  
  for(Lead__C led : leadlst){
      if(!acclink.isEmpty())
          led.Retail_Contact__c = acclink[0].id;
      //leadupdate.add(led);
  }
 // update leadupdate;
  //}
  
 // list<Lead__c> leadlistrecords = [select id, Name from Lead__c WHERE ID IN : contactId]; 
 }*/
    public Static boolean isCreated = false;
    public Static void populateRetailCompany(List < Lead__c > LeadLst, Map < Id, Lead__c > oldLeadmap, boolean isInsert, boolean isUpdate) {
        System.debug('########Dealers');
        Id CompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        List < Account_Link__c > AccounliunkUpdate = new List < Account_Link__c > ();
        List < Account_Link__c > AccounliunkRetailUpdate = new List < Account_Link__c > ();
        set < string > companyId = new set < string > ();
        set < string > AssignedDealerId = new set < string > ();
        set < String > retailconctId = new set < String > ();
        for (Lead__C led: LeadLst) {
            if (isInsert || (isUpdate && (led.Company_Account__c != oldLeadmap.get(led.id).Company_Account__c || led.Contact__c != oldLeadmap.get(led.id).Contact__c || led.CAC_Lead_Status__c != oldLeadmap.get(led.id).CAC_Lead_Status__c || led.Retail_Contact__c != oldLeadmap.get(led.id).Retail_Contact__c))) {
                system.debug('Conditions are saisfied11111111' + led.Retail_Contact__c);
                if (led.Contact__c != null && led.Company_Account__c != null && (led.RecordtypeId == salesRecordTypeId || led.RecordtypeId == afterSalesRecordTypeId)) { //&& led.CAC_Lead_Status__c == 'Allocated'
                    //&& (RecordType.DeveloperName == 'Sales_Leads' || RecordType.DeveloperName == 'Aftersales_Leads') && led.Company_Account__c != null

                    system.debug('Recordype.developerName' + led.Recordtype.Developername);
                    companyId.add(led.Company_Account__c);
                    AssignedDealerId.add(led.Assigned_Dealer__c);
                    system.debug('Conditions are saisfied222222' + led.Retail_Contact__c);
                    if (led.Retail_Contact__c != null) {
                        system.debug('retail  contzct' + led.Retail_Contact__c);
                        retailconctId.add(led.Retail_Contact__c);
                        isCreated = true;
                    }
                }
            }
        }
        List < Account_Link__C > AccountLink = [select Id, toRole__c, fromRole__c, Retail_Delete_Flag__c, Retail_Duplicate_Flag__c from Account_Link__c WHERE toRole__c IN: companyId AND fromRole__c IN: AssignedDealerId AND Retail_Delete_Flag__c = False AND Retail_Duplicate_Flag__c = False AND Recordtype.DeveloperName = 'Retail_Company'];
        List < Account_Link__C > AcclkLst = [select id, Retail_Related_Company__c from Account_Link__C WHERE id IN: retailconctId];
        System.debug('######$$$ K' + AccountLink);
        if (AccountLink.size() > 0) {
            for (Account_Link__c acc: AcclkLst) {
                acc.Retail_Related_Company__c = AccountLink[0].id;
                AccounliunkRetailUpdate.add(acc);
                System.debug('######$$$' + AccounliunkRetailUpdate);
                isCreated = false;
            }
        }
        system.debug('LeadLst>>>>' + LeadLst);
        if (AccountLink.isEmpty()) {
            for (Lead__C led: LeadLst) {
                //Account_Link__C acclnk = new Account_Link__C(RecordtypeId = CompanyRecordTypeId, toRole__c = (led.Company_Account__c!=null?led.Company_Account__c : ''), fromRole__c = (led.Assigned_Dealer__c!=null?led.Assigned_Dealer__c : ''), Retail_Address_Reference__c =  (led.Company_Account__r.Primary_Address_Reference__c!= null ? led.Company_Account__r.Primary_Address_Reference__c : '') 
                //);
                if (isCreated == true) {
                    Account_Link__C acclnk = new Account_Link__C(RecordtypeId = CompanyRecordTypeId, toRole__c = led.Company_Account__c, fromRole__c = led.Assigned_Dealer__c, Retail_Address_Reference__c = led.Company_Account__r.Primary_Address_Reference__c);
                    AccounliunkUpdate.add(acclnk);
                    isCreated = false;

                }

            }
            if (!AccounliunkUpdate.isEmpty()) {
                insert AccounliunkUpdate;

                for (Account_Link__c acc1: AcclkLst) {
                    system.debug('updared_______>');
                    acc1.Retail_Related_Company__c = AccounliunkUpdate[0].id;
                    AccounliunkRetailUpdate.add(acc1);
                }
            }

        }
        update AccounliunkRetailUpdate;
    }
}