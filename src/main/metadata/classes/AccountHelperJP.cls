/**
** Utility for Account trigger for Japan 
** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are updated. 
** Upadte Primary address display field based on primary address reference lookup field.
** Upadte Primary contact information based on corresponding picklist values.
** Created By: Sudhir 

** Date: 2015-12-22
** Modified By : 
** Modified date :
**/
public class AccountHelperJP
{
    /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are inserted.
**  Created By: Sudhir 
**  Date: 2015-12-22
**/
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
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
    /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are updated.
**  Created By: Sudhir 
**  Date: 2015-12-22
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
** Created By: Sudhir 
** Date: 2015-12-22
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
            UtilAddressTranslation.gettranslatedvalues('JP');
            For(Account a:listNewAccounts)
            {      
                if(a.MD__c == 'JP'|| a.MD__c == 'KR')
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
                if(acc.MD__c == 'JP' || acc.MD__c == 'KR')
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
    
    /** Upadte Primary contact information based on corresponding picklist values.
** Created By: Sudhir 
** Date: 2015-12-23 
**/
    public static void updatePrimaryContactInformationBeforeInsert(list<Account> listNewAccounts,boolean isInsert)
    {
        try
        {
            CustomLogUtil.CustomLoggingEntry(' Account Helper Class updatePrimaryContactInformationBeforeInsert method '+'listNewAccounts= ' + listNewAccounts.size());
            If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
            {
                for(Account Acc : listNewAccounts)
                {
                    if((acc.Primary_Fax__c != Null && acc.Primary_Fax__c != '' ) && acc.Primary_Fax__c == 'FAX1')
                    {
                        acc.Primary_Fax_Display__c = acc.Fax;
                    }
                    else if ((acc.Primary_Fax__c != Null && acc.Primary_Fax__c != '' ) && acc.Primary_Fax__c == 'FAX2')
                    {
                        acc.Primary_Fax_Display__c = acc.Fax2__c;
                    }
                    if((acc.Primary_Email__c != Null && acc.Primary_Email__c != '' ) && acc.Primary_Email__c == 'E-mail1')
                    {
                        acc.Primary_Email_Display__c = acc.Email__c;
                    }
                    else if((acc.Primary_Email__c != Null && acc.Primary_Email__c != '' ) && acc.Primary_Email__c == 'E-mail2')
                    {
                        acc.Primary_Email_Display__c = acc.Email2__c;
                    }
                    else if((acc.Primary_Email__c != Null && acc.Primary_Email__c != '') && acc.Primary_Email__c == 'E-mail3')
                    {
                        acc.Primary_Email_Display__c = acc.Email3__c;
                    }
                    if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '') && acc.Primary_Phone__c =='Mobile')
                    {
                        acc.Primary_Phone_Display__c = acc.Mobile__c;
                    }
                    else if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '' ) && acc.Primary_Phone__c =='Home Phone')
                    {
                        acc.Primary_Phone_Display__c = acc.Individual_Home_Phone__c;
                    }
                    else if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '' ) && acc.Primary_Phone__c =='Work Mobile')
                    {
                        acc.Primary_Phone_Display__c = acc.Mobile2__c;
                    }
                    else if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '' ) && acc.Primary_Phone__c =='Other1')
                    {
                        acc.Primary_Phone_Display__c = acc.Home_Phone_2__c;
                    }
                    else if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '' ) && acc.Primary_Phone__c =='Work Phone')
                    {
                        acc.Primary_Phone_Display__c = acc.Work_Phone__c;
                    }
                    else if((acc.Primary_Phone__c != Null && acc.Primary_Phone__c != '' ) && acc.Primary_Phone__c =='Other2')
                    {
                        acc.Primary_Phone_Display__c = acc.Phone;
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
    
    /** Upadte Primary contact information based on corresponding picklist values.
** Created By: Sudhir 
** Date: 2015-12-23 
**/
    public static void updatePrimaryContactInformationBeforeUpdate(list<Account> listNewAccounts,map<id,Account> OldMap,boolean isUpdate)
    {
        try
        {
            CustomLogUtil.CustomLoggingEntry(' Account Helper Class updatePrimaryContactInformationBeforeUpdate method '+'listNewAccounts= ' + listNewAccounts.size());
            If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
            {
                for(Account Acc : listNewAccounts)
                {
                    Account OldAcc = OldMap.get(Acc.id);
                    
                    if((acc.Primary_Fax__c == 'FAX1') && ((acc.Primary_Fax__c != OldAcc.Primary_Fax__c) || (acc.Fax != OldAcc.Fax)))
                    {
                        acc.Primary_Fax_Display__c = acc.Fax;
                    }
                    else if ((acc.Primary_Fax__c == 'FAX2') && ((acc.Primary_Fax__c != OldAcc.Primary_Fax__c) || (acc.Fax2__c != OldAcc.Fax2__c)))
                    {
                        acc.Primary_Fax_Display__c = acc.Fax2__c;
                    }
                    if((acc.Primary_Email__c == 'E-mail1') && ((acc.Primary_Email__c != OldAcc.Primary_Email__c) || (acc.Email__c != OldAcc.Email__c))) 
                    {
                        acc.Primary_Email_Display__c = acc.Email__c;
                    }
                    else if((acc.Primary_Email__c == 'E-mail2') && ((acc.Primary_Email__c != OldAcc.Primary_Email__c) || (acc.Email2__c != OldAcc.Email2__c))) 
                    {
                        acc.Primary_Email_Display__c = acc.Email2__c;
                    }   
                    else if((acc.Primary_Email__c == 'E-mail3') && ((acc.Primary_Email__c != OldAcc.Primary_Email__c) || (acc.Email3__c != OldAcc.Email3__c)))
                    {
                        acc.Primary_Email_Display__c = acc.Email3__c;
                    }
                    if((acc.Primary_Phone__c =='Mobile') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Mobile__c != OldAcc.Mobile__c)))
                    {
                        acc.Primary_Phone_Display__c = acc.Mobile__c;
                    }
                    else if((acc.Primary_Phone__c =='Home Phone') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Individual_Home_Phone__c != OldAcc.Individual_Home_Phone__c)))
                    {
                        acc.Primary_Phone_Display__c = acc.Individual_Home_Phone__c;
                    }
                    else if((acc.Primary_Phone__c =='Work Mobile') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Mobile2__c != OldAcc.Mobile2__c)))
                    {
                        acc.Primary_Phone_Display__c = acc.Mobile2__c;
                    }
                    else if((acc.Primary_Phone__c =='Other1') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Home_Phone_2__c != OldAcc.Home_Phone_2__c)))
                    {
                        acc.Primary_Phone_Display__c = acc.Home_Phone_2__c;
                    }
                    else if((acc.Primary_Phone__c =='Work Phone') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Work_Phone__c != OldAcc.Work_Phone__c)))
                    {
                        acc.Primary_Phone_Display__c = acc.Work_Phone__c;
                    }
                    
                    else if((acc.Primary_Phone__c =='Other2') && ((acc.Primary_Phone__c != OldAcc.Primary_Phone__c) || (acc.Phone != OldAcc.Phone)))
                    {
                        acc.Primary_Phone_Display__c = acc.Phone;
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
    /** To generate UCID value based on Record type.
** To Create Account link Record.
** Created By: Sreeram
** Date: 2016-01-10 
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
            String checksumSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
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
                accountlist = [select id,RecordTypeId,UCID__c,UCID_Sequence__c from account where id in :AccIds];
                if(!accountlist.isEmpty() && accountlist != Null)
                {
                    for(Account acc : accountlist)
                    {                        
                        
                        if(acc.RecordTypeId == accPerson_RecordTypeId){
                            ucidsequence = 'JSP' + acc.UCID_Sequence__c;                
                        }
                        else
                            if(acc.RecordTypeId == accCompany_RecordTypeId){
                                ucidsequence = 'JSC' + acc.UCID_Sequence__c;                
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
        
        System.debug('@@@ orgId'+ orgId +'@@@@@@ sfdcTypeName'+ sfdcTypeName +'@@ updateType'+updateType +'### sfdcId'+sfdcId +'$$$$$$ serlializedObject'+serlializedObject+'@@@@ sfdcMarketDiscriminator'+sfdcMarketDiscriminator);
    }
    
        /*
        # Description:This method will update the retail copy when related Account(Account 1) is updated. 
        # SFDCJP-669
        # Release : JP-2.0
        # Date: 02/12/2016
        # Author : Kiran
        */
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){
        system.debug('------>Method is called');
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        for(Account acc : accLst){
            if(isUpdate && acc.MD__c == label.MarketJp){ //Checking Market for updated account
                AccountIds.add(acc.id); //Adding accountId's to set
                System.debug('AccountID--->'+acc.id);        
            }
            
        }
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        List<Account_Link__c> Accountlinklist = [select id,Name,fromRole__r.RecordType.Name, fromRole__r.LastName, fromRole__r.FirstName, fromRole__r.Salutation__c, fromRole__r.LastName_Native_1__c,
                                                fromRole__r.FirstName_Native_1__c, fromRole__r.Gender__c, fromRole__r.PersonBirthdate, fromRole__r.Occupation__c, fromRole__r.Industry, 
                                                fromRole__r.Preferred_Language__c, fromRole__r.Primary_Phone__c, fromRole__r.Special_Care__c, fromRole__r.Special_Needs_Class__c,
                                                fromRole__r.Allow_Data_Sharing2__c, fromRole__r.Individual_Home_Phone__c, fromRole__r.Work_Phone__c, fromRole__r.Mobile__c, fromRole__r.Fax,
                                                fromRole__r.Email__c,fromRole__r.Primary_Address_Reference__r.Address_Type__c, fromRole__r.Primary_Address_Reference__r.Province__c,
                                                fromRole__r.Primary_Address_Reference__r.City__c, fromRole__r.Primary_Address_Reference__r.District__c, fromRole__r.Primary_Address_Reference__r.Block__c,
                                                fromRole__r.Primary_Address_Reference__r.Address_Line_1__c, fromRole__r.Primary_Address_Reference__r.Address_Line_2__c, fromRole__r.Primary_Address_Reference__r.ZipCode__c,
                                                fromRole__r.Name, fromRole__r.Company_Name_Native_1__c, fromRole__r.Commercial_Reg_No__c, fromRole__r.Vat_No__c, 
                                                fromRole__r.Foundation_Date__c, fromRole__r.Website, fromRole__r.Primary_Address_Reference__r.CreatedDate,
                                                fromRole__r.Primary_Address_Reference__r.LastModifiedDate
                                                from Account_Link__c WHERE fromRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany )];
        System.debug('Accountlinklist------>'+Accountlinklist  );
        //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist ){
            if(acclnk.fromRole__r.RecordType.Name == 'Person Account') {
                acclnk.Retail_LastName__c = acclnk.fromRole__r.LastName;
                acclnk.Retail_FirstName__c = acclnk.fromRole__r.FirstName;
                //acclnk.Retail_Salutation__c = acclnk.fromRole__r.Salutation__c;
                acclnk.Retail_Full_Name__c = ((acclnk.fromRole__r.LastName != null ? acclnk.fromRole__r.LastName:'') + (acclnk.fromRole__r.FirstName != null ? acclnk.fromRole__r.FirstName:'')).left(25); 
                acclnk.Retail_Full_Name_Title__c = ((acclnk.fromRole__r.Salutation__c!= null ? acclnk.fromRole__r.Salutation__c: '')+(acclnk.fromRole__r.LastName != null ? acclnk.fromRole__r.LastName:'') + (acclnk.fromRole__r.FirstName != null ? acclnk.fromRole__r.FirstName:'')).left(140);
                acclnk.Retail_LastName_Native__c = acclnk.fromRole__r.LastName_Native_1__c;
                acclnk.Retail_FirstName_Native__c = acclnk.fromRole__r.FirstName_Native_1__c; 
                acclnk.Retail_Gender__c = acclnk.fromRole__r.Gender__c;
                acclnk.Retail_PersonBirthdate__c = acclnk.fromRole__r.PersonBirthdate;
                acclnk.Retail_Occupation__c = acclnk.fromRole__r.Occupation__c;                
                acclnk.Retail_Preferred_Language__c = acclnk.fromRole__r.Preferred_Language__c;
                acclnk.Retail_Primary_Phone__c = acclnk.fromRole__r.Primary_Phone__c;
                acclnk.Retail_Special_Care__c = acclnk.fromRole__r.Special_Care__c;
                acclnk.Retail_Special_Needs_Class__c = acclnk.fromRole__r.Special_Needs_Class__c;
                acclnk.Retail_Allow_Data_Sharing__c = acclnk.fromRole__r.Allow_Data_Sharing2__c;                
                acclnk.Retail_Work_Phone__c = acclnk.fromRole__r.Work_Phone__c;
                acclnk.Retail_Mobile__c = acclnk.fromRole__r.Mobile__c;                
                acclnk.Retail_Email__c = acclnk.fromRole__r.Email__c;
            }
            //Checking the Company RecordType
            if(acclnk.fromRole__r.RecordType.Name=='Company'){ 
                acclnk.Retail_Company_Name__c = acclnk.fromRole__r.Name;
                acclnk.Retail_Company_Name_Native1__c = acclnk.fromRole__r.Company_Name_Native_1__c;
                acclnk.Retail_Commercial_Reg_No__c = acclnk.fromRole__r.Commercial_Reg_No__c;
                acclnk.Retail_Vat_No__c = acclnk.fromRole__r.Vat_No__c;
                if(acclnk.fromRole__r.Foundation_Date__c != null)
                    acclnk.Retail_Foundation_Month__c = string.valueOf(acclnk.fromRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.fromRole__r.Foundation_Date__c.Year());         
            }//End if for Company record type
            acclnk.Retail_Industry__c = acclnk.fromRole__r.Industry; 
            acclnk.Retail_Website__c = acclnk.fromRole__r.website;
            acclnk.Retail_Individual_Home_Phone__c = acclnk.fromRole__r.Individual_Home_Phone__c;
            acclnk.Retail_Fax__c = acclnk.fromRole__r.Fax;
            
            //Checking Null for sales Address 
            if(acclnk.fromRole__r.Primary_Address_Reference__c != null){ 
                    acclnk.Retail_Address_Type__c = acclnk.fromRole__r.Primary_Address_Reference__r.Address_Type__c;
                    acclnk.Retail_Province__c = acclnk.fromRole__r.Primary_Address_Reference__r.Province__c;
                    acclnk.Retail_City__c = acclnk.fromRole__r.Primary_Address_Reference__r.City__c;
                    acclnk.Retail_Distinct__c = ((acclnk.fromRole__r.Primary_Address_Reference__r.District__c!=null ? acclnk.fromRole__r.Primary_Address_Reference__r.District__c : '')+(acclnk.fromRole__r.Primary_Address_Reference__r.Block__c!= null ?acclnk.fromRole__r.Primary_Address_Reference__r.Block__c : '')).left(17);
                    acclnk.Retail_Address_Line_1__c = ((acclnk.fromRole__r.Primary_Address_Reference__r.Address_Line_1__c)!=null?acclnk.fromRole__r.Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclnk.Retail_Address_Line_2__c = ((acclnk.fromRole__r.Primary_Address_Reference__r.Address_Line_2__c)!=null?acclnk.fromRole__r.Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    acclnk.Retail_ZipCode__c = acclnk.fromRole__r.Primary_Address_Reference__r.ZipCode__c;
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.fromRole__r.Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acclnk.fromRole__r.Primary_Address_Reference__r.LastModifiedDate);

                }//End if for Sales Address
            
            AccountlnkUpdate.add(acclnk); //Adding Account link to Lsit  
        }//End of for loop
        
        if(!AccountlnkUpdate.isEmpty())
            update AccountlnkUpdate;
    }//End of Method
}