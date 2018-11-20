/**
* Handler for Trigger on Case for TR(Turkey)
* Author:Hildaa
* Created Date : 27-02-2018
* Utility for helperon Account_Link for TR(Turkey)
* It will validate the duplicate
*/
public class AccountlinkhelperTR{
  
  public  Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public  Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    Public  List<Account_link__C> Acclink;
    Public  List<Account_Link__Share> accshare=new List<Account_Link__Share>();
    Public   MAP<Account_link__C,String> AcclinkMap=new MAP<Account_link__C,String>();
     public static boolean recursioncheck = true;
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.TR,isinsert,isupdate,oldmapAL );
    }
    //Added by Hildaa for Data of Consent Information
    public static void updateOnPostalOptout(list<Account_link__C> listNewAccounts){
       for(Account_link__C acclnk: listNewAccounts){
            if(!acclnk.Retail_Postal_OptIn__c){
                //acclnk.Retail_Postal_OptIn__c = false;
                acclnk.Retail_Address_Line_1__c = '';
                acclnk.Retail_Address_Line_2__c = '';
            }
       }
    }

    /**
    * Use Email Opt Out (Retail_Email_OptOut__c) to automate opt-out from email options.
    */
    public static void updateOnEmailOptout(list<Account_link__C> listNewAccounts){        
        for(Account_link__C acc: listNewAccounts){
            if(!acc.Retail_Email_OptIn__c){
                //acc.Retail_Email_OptIn__c = false;
                acc.Retail_Email__c = '';
            }
        }
    }
    
    public static void updateOnPhoneSMSoptout(list<Account_link__C> listNewAccounts){
        for(Account_link__C acc: listNewAccounts){
            if(!acc.Retail_Phone_OptIn__c && !acc.Retail_SMS_OptIn__c){
                acc.Retail_Mobile__c = '';
        acc.Retail_Individual_Home_Phone__c = '';
        acc.Retail_Work_Phone__c = '';
            }
            else if(!acc.Retail_Phone_OptIn__c && acc.Retail_SMS_OptIn__c)
            {
                acc.Retail_Individual_Home_Phone__c = '';
                
            }
            /*if(acc.Retail_Phone_OptOut__c ){
                acc.Retail_Phone_OptIn__c = false;
            }
            if(acc.Retail_SMS_OptOut__c ){
                acc.Retail_SMS_OptIn__c = false;
            }*/
            
        }
    }
  
  public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        Acclink=[select id,fromRole__r.Dealer_GC_Code__c,fromRole__r.Market__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where fromRole__c!=null and id=:acclinklist AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)];
        for(Account_link__c acclinkrec:Acclink){
        if(acclinkrec.fromRole__r.Dealer_GC_Code__c !=null){
            string grpName= acclinkrec.fromRole__r.Market__c+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                //AcclinkMap.put(acclinkrec,acclinkrec.fromRole__r.Dealer_nd_Code__c);
        AcclinkMap.put(acclinkrec,grpName);
                
            }
            
        }
        if(AcclinkMap.size()>0){
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: AcclinkMap.values()]){
            for(Account_link__c alk:Acclink){
                if(alk.Retail_Delete_Flag__c==false){
                    Account_Link__Share alshare=new Account_Link__Share ();
                    alshare.AccessLevel='EDIT';
                    alshare.RowCause = Schema.Account_link__Share.RowCause.Manual;
                    alshare.ParentId = alk.id;
                    alshare.UserOrGroupId=groupRec.id;
                    accshare.add(alshare);        
                }
            }
         }    
        }
        if(accshare.size()>0){
            Database.insert(accshare, false);

            }
        }
        //Update Email2__c field for Reatil DOC notification
        public void updateEmailField(List<Account_link__C> acclinklist,Map<id,Account_link__C> oldacclinklist,boolean isUpdate){
            for(Account_link__C acc:acclinklist){
                if(isUpdate && acc.Retail_Email__c != oldacclinklist.get(acc.Id).Retail_Email__c)
                    acc.Email2__c = acc.Retail_Email__c;
                else if(!isUpdate)
                    acc.Email2__c = acc.Retail_Email__c;
            }
        }
        
        
        //code to update Retail DOC across Dealer RCs
        public void updateRetailDOCforDealers(List<Account_link__C> acclinklist,Map<id,Account_link__C> oldacclinklist){
            Acclink=[select id,torole__c,Retail_Email_OptIn__c,Market__c,Retail_Phone_OptIn__c,Retail_Postal_OptIn__c,Retail_SMS_OptIn__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Market__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where fromRole__c!=null and id IN :acclinklist AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)];
            Map<String,Account_link__C> AcclinkReference = new Map<String,Account_link__C>(); 
            set<String> GCCodes = new set<String>();
            set<Id> toRoles = new set<Id>();
            list<Account_link__C> AccLinktoUpdate = new list<Account_link__C>();
            for(Account_link__C al : Acclink){
                if(((al.Retail_Email_OptIn__c != oldacclinklist.get(al.Id).Retail_Email_OptIn__c) || 
                (al.Retail_Phone_OptIn__c != oldacclinklist.get(al.Id).Retail_Phone_OptIn__c) ||
                (al.Retail_Postal_OptIn__c != oldacclinklist.get(al.Id).Retail_Postal_OptIn__c)|| 
                al.Retail_SMS_OptIn__c != oldacclinklist.get(al.Id).Retail_SMS_OptIn__c) && al.Market__c == Label.TR && recursioncheck){
                    AcclinkReference.put(al.torole__c+al.fromRole__r.Dealer_GC_Code__c,al);
                    GCCodes.add(al.fromRole__r.Dealer_GC_Code__c);
                    toRoles.add(al.torole__c);
                }
            }
            //Update Account Links of same dealership
            for(Account_link__C al : [select id,Retail_Email_OptIn__c ,Retail_Postal_OptIn__c,Retail_Phone_OptIn__c ,Retail_SMS_OptIn__c   ,torole__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Market__c,Retail_Delete_Flag__c,fromRole__r.Dealer_nd_Code__c,fromRole__r.MD__c from Account_link__c  where fromRole__c!=null and id NOT IN :acclinklist AND torole__c IN :toRoles AND fromRole__r.Dealer_GC_Code__c IN :GCCodes AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId)]){
                if(AcclinkReference != null && AcclinkReference.containskey(al.torole__c+al.fromRole__r.Dealer_GC_Code__c) && AcclinkReference.get(al.torole__c+al.fromRole__r.Dealer_GC_Code__c) != null){
                    al.Retail_Email_OptIn__c = AcclinkReference.get(al.torole__c+al.fromRole__r.Dealer_GC_Code__c).Retail_Email_OptIn__c;
                    al.Retail_Phone_OptIn__c = AcclinkReference.get(al.torole__c+al.fromRole__r.Dealer_GC_Code__c).Retail_Phone_OptIn__c;
                    al.Retail_Postal_OptIn__c = AcclinkReference.get(al.torole__c+al.fromRole__r.Dealer_GC_Code__c).Retail_Postal_OptIn__c;
                    al.Retail_SMS_OptIn__c = AcclinkReference.get(al.torole__c+al.fromRole__r.Dealer_GC_Code__c).Retail_SMS_OptIn__c;
                    AccLinktoUpdate.add(al);
                }
            }
             recursioncheck = false;
            if(!AccLinktoUpdate.isEmpty())
                update AccLinktoUpdate;
           
        }
         public  void updateretailcopy(List<Account_link__C> accLst){
             Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        Map<String,string> countryMap = new map<string,string>(); //to fetch the country translations for turkey
        Map<Id,Account> AcctMap = new map<Id,Account>();
         for(CountryTranslation__mdt cmdt: [select id, Country__c,Country_Translation__c,Market__c from CountryTranslation__mdt where Market__c=:Label.TR])
         {
             countryMap.put(cmdt.Country__c,cmdt.Country_Translation__c);
         }
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        for(Account_link__c acc : accLst){
            AccountIds.add(acc.toRole__c); //Adding accountId's to set        
        }
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        for(Account ac : [select id,Agreement_to_commit_info_processing__c,Personal_Information_Third_Party_Release__c,UCID__c,CDM_UCID__c,Personal_Abroad_Agreement__c,DMS_Retailer_ID__c,Name,RecordType.Name, LastName, FirstName, Salutation__c, LastName_Native_1__c,
        FirstName_Native_1__c, Gender__c, race__c,PersonBirthdate, Occupation__c, Industry,createdDate, 
        Preferred_Language__c, Primary_Phone__c, Special_Care__c, Special_Needs_Class__c,LastModifiedDate ,
        Allow_Data_Sharing2__c,Individual_Home_Phone__c, Work_Phone__c, Mobile__c, Fax,ID_Type__c,ID_Number__c,
        Email__c,Primary_Address_Reference__r.Address_Type__c, Primary_Address_Reference__r.Province__c,country__c, Primary_Address_Reference__r.Preferred__c,
        Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c, Primary_Address_Reference__r.Block__c,
        Primary_Address_Reference__r.Address_Line_1__c, Primary_Address_Reference__r.Address_Line_3__c,Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,
         Company_Name_Native_1__c, Commercial_Reg_No__c, Vat_No__c, Job__c,Sales_Sanction__c,Allow_Data_Sharing__c,
        Foundation_Date__c, Website, Primary_Address_Reference__r.CreatedDate,Title__c,Preferred_Contact_Method__c,
        Primary_Address_Reference__r.LastModifiedDate,MBTH_Nationality__c,Preferred_Radio_Station__c,Personal_Agreement__c,
        First_Consent_Date__c,Updated_Consent_Date__c,First_Consent_User__c,Updated_Consent_User__c,PersonHasOptedOutOfEmail,
                                                 MD__c,Primary_Address_Reference__r.Country__c, Hobby__c,Marital_Status__c,Age_Range__c,Gov_Background__c,Contact_Background__c,
        PersonHasOptedOutOfFax,PersonDoNotCall,Postal_Opt_Out__c,
        Visit_Opt_Out__c,Complaint_Amount__c,Opt_In_Email__c,Opt_In_SMS__c,SMSOptOut__pc,
        Postal_Opt_In__c,Market__c,social_id__c, Company_Name__c , DMS_Customer_ID__c, Retail_Work_Phone__c, Special_Mark_on_Account__c, Opt_In_Mail__c , Opt_In_Phone__c , Opt_In_SMS3__c,     
        MB_Online_Id__c,Primary_Address_Reference__r.Foreign_Nationals__c, Primary_Address_Reference__r.State_City__c,Primary_Address_Reference__r.Suburb__c  from Account WHERE Id IN :AccountIds ]){
            AcctMap.put(ac.Id,ac);
        }
        
        //Account link iteration
        for(Account_Link__c acclnk : accLst ){
            //Checking the Person Account RecordType            
            if(AcctMap != null && AcctMap.containskey(acclnk.torole__c) && AcctMap.get(acclnk.torole__c).RecordType.Name == 'Person Account' ) {                 

                acclnk.Retail_Salutation__c = acctMap.get(acclnk.torole__c).Title__c;
                if(acctMap.get(acclnk.torole__c).Market__c != 'TR')
                    acclnk.Retail_Country__c = acctMap.get(acclnk.torole__c).country__c;
                acclnk.Retail_ID_Type__c = acctMap.get(acclnk.torole__c).ID_Type__c;
                acclnk.Retail_ID_Number__c = acctMap.get(acclnk.torole__c).ID_Number__c;
                acclnk.LastModifiedDate__c = acctMap.get(acclnk.torole__c).LastmodifiedDate;
                acclnk.createddate__c = acctMap.get(acclnk.torole__c).createdDate;
                acclnk.Retail_Race__c=acctMap.get(acclnk.torole__c).Race__c;
                acclnk.Retail_Special_Care__c = acctMap.get(acclnk.torole__c).Special_Care__c;
                acclnk.Retail_LastName_Native__c = acctMap.get(acclnk.torole__c).LastName_Native_1__c;
                acclnk.Retail_FirstName_Native__c = acctMap.get(acclnk.torole__c).FirstName_Native_1__c;
                acclnk.Retail_Primary_Phone__c = acctMap.get(acclnk.torole__c).Primary_Phone__c;
                acclnk.Retail_Full_Name__c = acctMap.get(acclnk.torole__c).FirstName + ' ' + acctMap.get(acclnk.torole__c).LastName ;
                acclnk.Retail_Full_Name_Title__c = ((acctMap.get(acclnk.torole__c).Title__c!= null ?acctMap.get(acclnk.torole__c).Title__c:'')  + ' ' + (acctMap.get(acclnk.torole__c).FirstName!= null ?acctMap.get(acclnk.torole__c).FirstName:'') + ' ' +(acctMap.get(acclnk.torole__c).LastName!= null ?acctMap.get(acclnk.torole__c).LastName:'')).left(140) ;
                acclnk.Retail_LastName__c = acctMap.get(acclnk.torole__c).LastName;
                acclnk.Retail_FirstName__c = acctMap.get(acclnk.torole__c).FirstName;
                //acclnk.Retail_Complaint_Amount__c = acctMap.get(acclnk.torole__c).Complaint_Amount__c;
                acclnk.Retail_Sales_Sanction__c = acctMap.get(acclnk.torole__c).Sales_Sanction__c;
                acclnk.Retail_UCID__c = acctMap.get(acclnk.torole__c).UCID__c;
                acclnk.Retail_Allow_Data_Sharing__c = acctMap.get(acclnk.torole__c).Allow_Data_Sharing__c;
                acclnk.Retail_Mobile__c = acctMap.get(acclnk.torole__c).Mobile__c;
                acclnk.Retail_Individual_Home_Phone__c = acctMap.get(acclnk.torole__c).Individual_Home_Phone__c;
                acclnk.Retail_Work_Phone__c = acctMap.get(acclnk.torole__c).Work_Phone__c;
                acclnk.Retail_Email__c = acctMap.get(acclnk.torole__c).email__c;
                acclnk.Retail_Fax__c = acctMap.get(acclnk.torole__c).Fax;
                acclnk.Retail_Preferred_Contact_Method__c = acctMap.get(acclnk.torole__c).Preferred_Contact_Method__c;
                acclnk.Retail_Email_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfEmail;
                acclnk.Retail_Fax_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfFax;                                                                                                
                acclnk.Retail_Phone_OptOut__c = acctMap.get(acclnk.torole__c).PersonDoNotCall;
                acclnk.Retail_Postal_OptOut__c = acctMap.get(acclnk.torole__c).Postal_Opt_Out__c;
                acclnk.Retail_Visit_OptOut__c = acctMap.get(acclnk.torole__c).Visit_Opt_Out__c;
                acclnk.Retail_PersonBirthdate__c = acctMap.get(acclnk.torole__c).PersonBirthdate;
                acclnk.Retail_Occupation__c = acctMap.get(acclnk.torole__c).Occupation__c;
                acclnk.Retail_Position__c = acctMap.get(acclnk.torole__c).Job__c;
                acclnk.Retail_Preferred_Language__c = acctMap.get(acclnk.torole__c).Preferred_Language__c;
                acclnk.Retail_Gender__c = acctMap.get(acclnk.torole__c).Gender__c;
                acclnk.Retail_Industry__c = acctMap.get(acclnk.torole__c).industry;
                acclnk.Retail_WebSite__c = acctMap.get(acclnk.torole__c).Website;
                acclnk.Retail_Commercial_Reg_No__c = acctMap.get(acclnk.torole__c).Commercial_Reg_No__c;
                acclnk.Retail_Agreement__c = acctMap.get(acclnk.torole__c).Personal_Agreement__c;
                acclnk.Retail_Information_Third_Party_Release__c = acctMap.get(acclnk.torole__c).Personal_Information_Third_Party_Release__c;
                acclnk.Retail_Abroad_Agreement__c = acctMap.get(acclnk.torole__c).Personal_Abroad_Agreement__c;
                acclnk.Retail_Agreement_Info_Processing__c = acctMap.get(acclnk.torole__c).Agreement_to_commit_info_processing__c;
                acclnk.Retail_Vat_No__c = acctMap.get(acclnk.torole__c).Vat_No__c;
                if(acctMap.get(acclnk.torole__c).Foundation_Date__c != null){
                    acclnk.Retail_Foundation_Month__c = String.valueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.year()) + (String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month())) :String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month())) + (String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day())) :String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day()));
                }   
                
                //Sada 2018/July/3 added as part of MBANZ-124
                if(acctMap.get(acclnk.torole__c).Market__c == 'AU' || acctMap.get(acclnk.torole__c).Market__c == 'NZ'){
                    sObjectMappingUtility varMapUtil = new sObjectMappingUtility(acctMap.get(acclnk.torole__c).Market__c,'Create_RetailCopy_PersonAccount');
                    varMapUtil.mapFieldValues(acctMap.get(acclnk.torole__c), acclnk);
                }
            
                
                //additions for TR Market may 9 2018
                if(acctMap.get(acclnk.torole__c).Market__c == 'TR') {
                    acclnk.Retail_Vat_No__c = acctMap.get(acclnk.torole__c).Vat_No__c;
                    acclnk.Retail_Complaint_Amount__c = acctMap.get(acclnk.torole__c).Complaint_Amount__c;
                    acclnk.createddate__c = acctMap.get(acclnk.torole__c).createdDate;
                    acclnk.Retail_Mobile__c = acctMap.get(acclnk.torole__c).Mobile__c; 
                    acclnk.Retail_Preferred_Contact_Method__c = acctMap.get(acclnk.torole__c).Preferred_Contact_Method__c;
                    acclnk.Retail_Postal_OptOut__c = acctMap.get(acclnk.torole__c).Postal_Opt_Out__c;  
                    acclnk.Retail_Visit_OptOut__c =  acctMap.get(acclnk.torole__c).Visit_Opt_Out__c;    
                    acclnk.Retail_Email_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfEmail;
                    acclnk.Retail_Phone_OptOut__c = acctMap.get(acclnk.torole__c).PersonDoNotCall;
                    acclnk.Retail_Commercial_Reg_No__c ='';
                    acclnk.Retail_Preferred_Language__c='';
                    acclnk.Retail_Individual_Home_Phone__c=acctMap.get(acclnk.torole__c).Individual_Home_Phone__c;
                    //Fix for MT - 32
                    acclnk.Retail_Social_ID__c=acctMap.get(acclnk.torole__c).Social_Id__c;
                    
                    
                    //acclnk.Retail_Email_OptIn__c = acctMap.get(acclnk.torole__c).Opt_In_Email__c;
                    acclnk.Retail_Email__c = acctMap.get(acclnk.torole__c).Email__c;
                    
                    //acclnk.Retail_SMS_OptIn__c = acctMap.get(acclnk.torole__c).Opt_In_SMS__c;
                    //acclnk.Retail_SMS_OptOut__c = acctMap.get(acclnk.torole__c).SMSOptOut__pc;
                    
                    //acclnk.Retail_Postal_OptIn__c = acctMap.get(acclnk.torole__c).Postal_Opt_In__c;
                    
                }
            }
            //Checking the Company RecordType
            system.debug(acclnk.toRole__r.RecordType.Name+';;;;;'+acclnk.fromRole__r.Dealer_Rollout_Status__c+'[[[[['+acctMap.get(acclnk.torole__c).Market__c);
            if(AcctMap.get(acclnk.torole__c).RecordType.Name=='Company'){ 
                    acclnk.Retail_UCID__c = acctMap.get(acclnk.torole__c).UCID__c;
                    if(acctMap.get(acclnk.torole__c).Market__c != 'TR')
                        acclnk.Retail_Country__c = acctMap.get(acclnk.torole__c).country__c;
                    acclnk.LastModifiedDate__c = acctMap.get(acclnk.torole__c).LastmodifiedDate;
                    acclnk.createddate__c = acctMap.get(acclnk.torole__c).createdDate;
                    acclnk.Retail_Company_Name_Native1__c = acctMap.get(acclnk.torole__c).Company_Name_Native_1__c;
                    acclnk.Retail_Company_Name__c = acctMap.get(acclnk.torole__c).name;
                    acclnk.Retail_Mobile__c = acctMap.get(acclnk.torole__c).Mobile__c;
                    acclnk.Retail_Company_Phone__c = acctMap.get(acclnk.torole__c).Individual_Home_Phone__c;
                    acclnk.Retail_Company_Other_Phone__c = acctMap.get(acclnk.torole__c).Work_Phone__c;
                    acclnk.Retail_Email__c = acctMap.get(acclnk.torole__c).email__c;
                    acclnk.Retail_Email_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfEmail;
                    acclnk.Retail_Fax_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfFax;
                    acclnk.Retail_Primary_Phone__c = acctMap.get(acclnk.torole__c).Primary_Phone__c;
                    acclnk.Retail_Sales_Sanction__c = acctMap.get(acclnk.torole__c).Sales_Sanction__c;
                    acclnk.Retail_Phone_OptOut__c = acctMap.get(acclnk.torole__c).PersonDoNotCall;
                    acclnk.Retail_Postal_OptOut__c = acctMap.get(acclnk.torole__c).Postal_Opt_Out__c;
                    acclnk.Retail_Visit_OptOut__c = acctMap.get(acclnk.torole__c).Visit_Opt_Out__c;
                    acclnk.Retail_Fax__c = acctMap.get(acclnk.torole__c).fax;
                    acclnk.Retail_Position__c=acctMap.get(acclnk.torole__c).Job__c;
                    acclnk.Retail_Preferred_Language__c = acctMap.get(acclnk.torole__c).Preferred_Language__c;
                    acclnk.Retail_Industry__c = acctMap.get(acclnk.torole__c).Industry;
                    acclnk.Retail_Commercial_Reg_No__c = acctMap.get(acclnk.torole__c).Commercial_Reg_No__c;
                    acclnk.Retail_Vat_No__c = acctMap.get(acclnk.torole__c).Vat_No__c;
                    acclnk.Retail_WebSite__c = acctMap.get(acclnk.torole__c).Website;
                    acclnk.Retail_Agreement__c = acctMap.get(acclnk.torole__c).Personal_Agreement__c;
                    acclnk.Retail_Information_Third_Party_Release__c = acctMap.get(acclnk.torole__c).Personal_Information_Third_Party_Release__c;
                    acclnk.Retail_Abroad_Agreement__c = acctMap.get(acclnk.torole__c).Personal_Abroad_Agreement__c;
                    acclnk.Retail_Agreement_Info_Processing__c = acctMap.get(acclnk.torole__c).Agreement_to_commit_info_processing__c;
                    if(acctMap.get(acclnk.torole__c).Foundation_Date__c != null){
                         acclnk.Retail_Foundation_Month__c = String.valueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.year()) + (String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month())) :String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.month())) + (String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day()).length() == 1 ? ('0' + String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day())) :String.ValueOf(acctMap.get(acclnk.torole__c).Foundation_Date__c.day()));
                    }           
                    
                    //Sada 2018/July/3 added as part of MBANZ-124
                    if(acctMap.get(acclnk.torole__c).Market__c == 'AU' || acctMap.get(acclnk.torole__c).Market__c == 'NZ'){
                        sObjectMappingUtility varMapUtil = new sObjectMappingUtility(acctMap.get(acclnk.torole__c).Market__c,'Create_RetailCopy_CompanyAccount');
                        varMapUtil.mapFieldValues(acctMap.get(acclnk.torole__c), acclnk);
                    }                           
                
                    //Added for TR Market
                    if(acctMap.get(acclnk.torole__c).Market__c == 'TR') {
                        acclnk.createddate__c = acctMap.get(acclnk.torole__c).createdDate;
                        acclnk.Retail_Email__c = acctMap.get(acclnk.torole__c).email__c;
                    acclnk.Retail_Commercial_Reg_No__c ='';
                    acclnk.Retail_Preferred_Language__c='';
                        acclnk.Retail_Mobile__c = acctMap.get(acclnk.torole__c).mobile__c;  
                    acclnk.Retail_Industry__c=acctMap.get(acclnk.torole__c).Industry;
                        acclnk.Retail_Preferred_Contact_Method__c = acctMap.get(acclnk.torole__c).Preferred_Contact_Method__c;
                        //fix for MT - 32
                       // acclnk.Retail_Company_Other_Phone__c = acctMap.get(acclnk.torole__c).Work_Phone__c;
                        acclnk.Retail_Individual_Home_Phone__c=acctMap.get(acclnk.torole__c).Individual_Home_Phone__c;
                        acclnk.Retail_UCID__c=acctMap.get(acclnk.torole__c).UCID__c;  
                        acclnk.Retail_Agreement__c= acctMap.get(acclnk.torole__c).Personal_Agreement__c;
                        acclnk.Retail_First_Consent_Date__c= acctMap.get(acclnk.torole__c).First_Consent_Date__c;
                        acclnk.Retail_Updated_Consent_Date__c= acctMap.get(acclnk.torole__c).Updated_Consent_Date__c;
                        acclnk.Retail_First_Consent_User__c= acctMap.get(acclnk.torole__c).First_Consent_User__c;
                        acclnk.Retail_Updated_Consent_User__c= acctMap.get(acclnk.torole__c).Updated_Consent_User__c;
                        acclnk.Retail_Postal_OptOut__c = acctMap.get(acclnk.torole__c).Postal_Opt_Out__c;  
                        acclnk.Retail_Visit_OptOut__c =  acctMap.get(acclnk.torole__c).Visit_Opt_Out__c;  
                        acclnk.Retail_Email_OptOut__c = acctMap.get(acclnk.torole__c).PersonHasOptedOutOfEmail;
                        acclnk.Retail_Phone_OptOut__c = acctMap.get(acclnk.torole__c).PersonDoNotCall;
                    acclnk.Retail_Work_Phone__c=acctMap.get(acclnk.torole__c).Work_Phone__c;
                    //acclnk.Retail_SMS_OptIn__c = acctMap.get(acclnk.torole__c).Opt_In_SMS__c;
                    //acclnk.Retail_SMS_OptOut__c = acctMap.get(acclnk.torole__c).SMSOptOut__pc;
                    
                    //acclnk.Retail_Postal_OptIn__c = acctMap.get(acclnk.torole__c).Postal_Opt_In__c;
                }
                acclnk.Retail_Company_Phone__c = acctMap.get(acclnk.torole__c).Individual_Home_Phone__c;
            }//End if for Company record type
            
            //mapping fields common for both recordtypes
            acclnk.Retail_Industry__c = acctMap.get(acclnk.torole__c).Industry;                        
            acclnk.Retail_Fax__c = acctMap.get(acclnk.torole__c).Fax;
            acclnk.Retail_Allow_Data_Sharing__c = acctMap.get(acclnk.torole__c).Allow_Data_Sharing2__c;
            acclnk.Retail_UCID__c=acctMap.get(acclnk.torole__c).UCID__c;  
            system.debug(acctMap.get(acclnk.torole__c).Primary_Address_Reference__c+'--'+string.isnotblank(acclnk.Retail_Address_Reference__c)+'--'+acclnk.Retail_Address_Reference__c+'-'+TriggerRecursiveCheck.ALAddressCheck+'---');
            
            //Checking Null for sales Address 
            if((acctMap.get(acclnk.torole__c).Primary_Address_Reference__c != null &&  string.isnotblank(acclnk.Retail_Address_Reference__c) && acctMap.get(acclnk.torole__c).Primary_Address_Reference__c ==acclnk.Retail_Address_Reference__c) || ((!TriggerRecursiveCheck.ALAddressCheck) && acctMap.get(acclnk.torole__c).Primary_Address_Reference__c != null  &&  string.isblank(acclnk.Retail_Address_Reference__c)) || (acctMap.get(acclnk.torole__c).Primary_Address_Reference__c != null && acctMap.get(acclnk.torole__c).Market__c == 'TR' && acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Preferred__c==true)){
                               
                acclnk.Retail_Address_Reference__c=acctMap.get(acclnk.torole__c).Primary_Address_Reference__c;
                acclnk.Retail_Address_Type__c = acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Type__c;
                acclnk.Retail_Province__c = (acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Province__c !=null ?acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Province__c: '' );
                acclnk.Retail_Distinct__c = ((acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.District__c!=null ? acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.District__c : '')+' '+(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Block__c!= null ?acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Block__c : '')).left(17);
                acclnk.Retail_Address_Line_3__c = ((acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_3__c)!=null?acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_3__c:'').left(35);
                acclnk.Retail_ZipCode__c = (acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.ZipCode__c!=null ? acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.ZipCode__c : '' );
      if(acctMap.get(acclnk.torole__c).Market__c == 'TR')
              {
                    acclnk.Retail_City__c = (acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.City__c != null ? acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.City__c:'').left(17);
                    acclnk.Retail_Address_Line_1__c = ((acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_1__c)!=null?acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclnk.Retail_Address_Line_2__c = ((acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_2__c)!=null?acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    if(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Country__c != null && countryMap != null && countryMap.containskey(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Country__c))
                        acclnk.Retail_Country__c = countryMap.get(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.Country__c);
                    else
                        acclnk.Retail_Country__c = acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.country__c;
                }
        
                acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.CreatedDate);
                acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acctMap.get(acclnk.torole__c).Primary_Address_Reference__r.LastModifiedDate);
            }//End if for Sales Address
           // AccountlnkUpdate.add(acclnk); //Adding Account link to Lsit  
        }//End of for loop
        //if(!AccountlnkUpdate.isEmpty())
          //  DMLManagerService.updateAsSystem(AccountlnkUpdate);
    }//End of Method  

                 
         
         
        public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
        List<AccountShare> AccountShareList = new  List<AccountShare>();
        Set<String> ndCode=new Set<String>();
        List<id> acctoshare=new List<id>();
        List<Account_Link__c> Acclink=[select id,toRole__c,fromRole__r.Market__c,fromRole__r.Dealer_ND_Code__c,fromRole__r.MD__c from Account_link__c  where toRole__c!=null and fromRole__c!=null and id=:acclinklist];
        for(Account_Link__c acclinkrec:Acclink){
            acctoshare.add(acclinkrec.fromRole__c);
            acctoshare.add(acclinkrec.toRole__c);
            if(acclinkrec.fromRole__r.Dealer_ND_Code__c!=null){
              string grpName= acclinkrec.fromRole__r.Market__c+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                    //AcclinkMap.put(acclinkrec,acclinkrec.fromRole__r.Dealer_nd_Code__c);
              AcclinkMap.put(acclinkrec,grpName);
                    //ndCode.add(acclinkrec.fromRole__r.Dealer_nd_Code__c);
              ndCode.add(grpName);
            }
        }
        if(ndCode.size()>0){
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: ndCode]){
                for(ID acct:acctoshare){
                    AccountShare thisAccountShare = new AccountShare(); //a new empty AccountShare object
                    thisAccountShare.userorgroupid = groupRec.id;
                    thisAccountShare.accountid = acct;
                    thisAccountShare.accountaccesslevel = 'Edit';
                    thisAccountShare.RowCause = Schema.AccountShare.RowCause.Manual;
                    thisAccountShare.OpportunityAccessLevel='None';
                    AccountShareList.add(thisAccountShare);
                }
            }
            if(AccountShareList.size()>0){
                Database.insert(AccountShareList, false);

        }
    }
            
 }
    
   
    //END
}
