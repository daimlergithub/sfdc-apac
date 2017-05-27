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
    static User usr = [Select id, LanguageLocaleKey,Market__c,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()]; 
    /** Update "Last Modified By" and "Last Modified Date" fields associated with each contact information fields,when any contact information field(s) are inserted.
**  Created By: Sudhir 
**  Date: 2015-12-22
**/
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
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
    public static boolean persongroup11 = false;
    public static boolean companygroup1 = false;
    public static boolean companygroup2=false;
    
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
				if(Acc.Fax != Null && Acc.Fax != '')
                {                    
					Acc.Fax_Last_Modified_By__c = UserInfo.getName();
                    Acc.Fax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Fax2__c != Null && Acc.Fax2__c != '')
                {     
					Acc.Work_Fax_Last_Modified_By__c = UserInfo.getName();				
                    Acc.Fax2_Last_Modified_Date__c = System.now();
                }
				if(Acc.Primary_Phone__c != Null && Acc.Primary_Phone__c != '')
                {                    
                    Acc.Primary_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Email__c != Null && Acc.Primary_Email__c != '')
                {                    
                    Acc.Primary_Email_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Fax__c != Null && Acc.Primary_Fax__c != '')
                {                    
                    Acc.Primary_Fax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Address__c != Null && Acc.Primary_Address__c != '')
                {                    
                    Acc.Primary_Address_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Sales_Sanction__c != Null && Acc.Sales_Sanction__c != '')
                {                    
                    Acc.Sales_Sanction_Last_Modified_Date__c = System.now();
                }
				if(Acc.PersonDoNotCall == true)
                {                    
                    Acc.PersonDoNotCall_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Visit_Opt_Out__c == true)
                {                    
                    Acc.Visit_Opt_Out_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Postal_Opt_Out__c == true)
                {                    
                    Acc.Postal_Opt_Out_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.PersonHasOptedOutOfEmail == true)
                {                    
                    Acc.OptedOutOfEmail_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.PersonHasOptedOutOfFax == true)
                {                    
                    Acc.OptedOutOfFax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.MB_Customer_Info_Remove__c == true)
                {                    
                    Acc.MB_CIR_Last_Modified_Date__c = System.now();
                }
                                
                if(Acc.Data_Source__c != Null && Acc.Data_Source__c != '')
                {                    
                    Acc.Data_Source_Last_Modified_Date__c = System.now();
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
                
                if(Acc.Fax != Null && Acc.Fax != '')
                {                    
					Acc.Fax_Last_Modified_By__c = UserInfo.getName();
                    Acc.Fax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Fax2__c != Null && Acc.Fax2__c != '')
                {     
					Acc.Work_Fax_Last_Modified_By__c = UserInfo.getName();				
                    Acc.Fax2_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Phone__c != Null && Acc.Primary_Phone__c != '')
                {                    
                    Acc.Primary_Phone_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Email__c != Null && Acc.Primary_Email__c != '')
                {                    
                    Acc.Primary_Email_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Fax__c != Null && Acc.Primary_Fax__c != '')
                {                    
                    Acc.Primary_Fax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Primary_Address__c != Null && Acc.Primary_Address__c != '')
                {                    
                    Acc.Primary_Address_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Sales_Sanction__c != Null && Acc.Sales_Sanction__c != '')
                {                    
                    Acc.Sales_Sanction_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.PersonDoNotCall != accountOldMap.get(acc.Id).PersonDoNotCall)
                {                    
                    Acc.PersonDoNotCall_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Visit_Opt_Out__c != accountOldMap.get(acc.Id).Visit_Opt_Out__c)
                {                    
                    Acc.Visit_Opt_Out_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.Postal_Opt_Out__c != accountOldMap.get(acc.Id).Postal_Opt_Out__c)
                {                    
                    Acc.Postal_Opt_Out_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.PersonHasOptedOutOfEmail != accountOldMap.get(acc.Id).PersonHasOptedOutOfEmail)
                {                    
                    Acc.OptedOutOfEmail_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.PersonHasOptedOutOfFax != accountOldMap.get(acc.Id).PersonHasOptedOutOfFax)
                {                    
                    Acc.OptedOutOfFax_Last_Modified_Date__c = System.now();
                }
                
                if(Acc.MB_Customer_Info_Remove__c != accountOldMap.get(acc.Id).MB_Customer_Info_Remove__c)
                {                    
                    Acc.MB_CIR_Last_Modified_Date__c = System.now();
                }
                                
                if(Acc.Data_Source__c != Null && Acc.Data_Source__c != '')
                {                    
                    Acc.Data_Source_Last_Modified_Date__c = System.now();
                }
            }
            
        }
    }
    /** Upadte Primary address display field based on primary address reference lookup field.
** Created By: Sudhir 
** Date: 2015-12-22
**/
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,Map<Id,Account> oldMap,boolean isUpdate)
    {

        Map<Id,Address__c> addr;
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
        {
            string regexForNullValue ='null';
            string nullValue ='';
            set<id> addressid = new set<id>();                  
            String province;
			String market;

            //User usr = [SELECT Id,Market__c, Profile.Name FROM User WHERE Id=:UserInfo.getUserId()] ;

        	market = usr.Market__c;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
			if(!test.isrunningtest() && usr.Profile.Name != 'IntegrationAPI')
            {
				UtilAddressTranslation.gettranslatedvalues(market);
			}
            For(Account a:listNewAccounts)
            {      
                if((a.MD__c == 'JP'|| a.MD__c == 'KR') && (a.Primary_Address_Reference__c != oldMap.get(a.id).Primary_Address_Reference__c))
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
                    If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null && (acc.Primary_Address_Reference__c !=oldMap.get(acc.id).Primary_Address_Reference__c))
                    {   
                        system.debug('acc.Primary_Address_Reference__c'+acc.Primary_Address_Reference__c);
                        system.debug('oldMap.get(acc.id)'+oldMap.get(acc.id).Primary_Address_Reference__c);
                        system.debug('*************Account*********'+acc);

                        system.debug('*************Primary Address Reference__c*********'+acc.Primary_Address_Reference__c); 
                        Address__c add = addr.get(acc.Primary_Address_Reference__c);
                        if(addtrmap1.containsKey(add.Province__c) && add.Customer__c==acc.id)
                        {
                            province = addtrmap1.get(add.Province__c);
                        }
                        acc.Primary_Address_Display__c = province+ add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;
                        acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        system.debug(')&)^%$%&&*(**^^^^'+acc.Primary_Address_Display__c);
                    }
                    else If(acc.Primary_Address_Reference__c ==Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null)
                    {   
                        system.debug('acc.Primary_Address_Reference__c'+acc.Primary_Address_Reference__c);
                        system.debug('oldMap.get(acc.id)'+oldMap.get(acc.id).Primary_Address_Reference__c);
                        system.debug('*************Account 2222*********'+acc);
                        system.debug('*************Primary Address Reference__c*********'+acc.Primary_Address_Reference__c); 

                        Address__c add = addr.get(acc.Primary_Address_Reference__c);
                        if(addtrmap1.containsKey(add.Province__c) && add.Customer__c==acc.id)
                        {
                            province = addtrmap1.get(add.Province__c);
                        }
                        acc.Primary_Address_Display__c = province+ add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + ' ' + add.Address_Line_2__c ;
                        acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        system.debug(')&)^%$%&&*(**^^^^'+acc.Primary_Address_Display__c);
                    }
                    //Code commented by Srinivas Pendli for #SFDCKR-620
                    /*
                    else if(acc.Primary_Address_Reference__c ==Null)
                    {
                        acc.Primary_Address_Display__c ='';
                    }
                    */
                    
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
			 //Below condition is added as part of SFDCJP-2279
            /* Added By Venky @5/10/2017.
                If the value in ""Allow Data Sharing(Allow_Data_Sharing2__c"" is changed from ""Yes"" to ""No"" in Person Account record type, the value which is stored in below field should be deleted.
                
                - Acquisition Objective & Method(Acquisition_Objdective_Method__c)""
                - Details of The Acquisition(Details_of_Acquisition__c)
                - Acquisition Record Date (Acquisition_Record_Date__c)
                "
                
            */
            If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
               {
                     for(Account a:listNewAccounts)
                       {
					   
					    //Changes as part of SFDCJP-2404
                       if((a.MD__c == 'JP') &&(accPerson_RecordTypeId ==a.RecordTypeId)  && a.Allow_Data_Sharing2__c=='Yes'  && a.Acquisition_Record_Date__c ==null )
                       { 
                       a.Acquisition_Record_Date__c =System.today(); 
                       }
					   
                           if((a.MD__c == 'JP') &&(accPerson_RecordTypeId ==a.RecordTypeId)  && (a.Allow_Data_Sharing2__c!= oldMap.get(a.id).Allow_Data_Sharing2__c && a.Allow_Data_Sharing2__c=='No'))
                           {
                           a.Acquisition_Objective_Method__c='';
                           a.Details_of_Acquisition__c='';
                           a.Acquisition_Record_Date__c=null;
                           
                           } 
                       }
               
               }
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
                accountlist = [select id,RecordTypeId,UCID__c,UCID_Sequence__c,MD__c from account where id in :AccIds];
                if(!accountlist.isEmpty() && accountlist != Null)
                {
                    for(Account acc : accountlist)
                    {                        
                        
                        if(acc.RecordTypeId == accPerson_RecordTypeId && acc.MD__c == 'JP'){
                            ucidsequence = 'JSP' + acc.UCID_Sequence__c;                
                        }
                        else
                            if(acc.RecordTypeId == accCompany_RecordTypeId && acc.MD__c == 'JP'){
                                ucidsequence = 'JSC' + acc.UCID_Sequence__c;                
                            }
                        else
                        if(acc.RecordTypeId == accPerson_RecordTypeId && acc.MD__c == 'KR'){
                            System.debug('###############################-->createUCID---Person Account---KR');
                            ucidsequence = 'KSP' + acc.UCID_Sequence__c;                
                        }
                        else
                        if(acc.RecordTypeId == accCompany_RecordTypeId && acc.MD__c == 'KR'){
                            System.debug('###############################-->createUCID---Company Account---KR');
                            ucidsequence = 'KSC' + acc.UCID_Sequence__c;                
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
                    system.debug('accountmap>>>>>' + accountmap);
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
                    system.debug('MArket>>>>' + usr.Market__c);
                    system.debug('UserType>>>>' + Userinfo.getUserType());
                    if(usr.Market__c == 'KR' && Userinfo.getUserType() == 'PowerPartner')
                    {
                        system.debug('Insert>>>>Entered');
                        AccountHelperKR.CreateRetailCopy(accountlist, true, true);
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
    
      public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst , Map<Id,Account>oldAccountmap){
        
        system.debug('------>Method is called');
Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
if(usr.Profile.Name != 'IntegrationAPI'){
  for(Account acc : accLst){
    if(isUpdate && acc.MD__c == label.MarketJp ){ //Checking Market for updated account
            if(oldAccountmap.get(Acc.id).LastName !=  acc.LastName || oldAccountmap.get(Acc.id).FirstName != acc.FirstName || oldAccountmap.get(Acc.id).LastName_Native_1__c != acc.LastName_Native_1__c || oldAccountmap.get(Acc.id).FirstName_Native_1__c != acc.FirstName_Native_1__c){
                 AccountIds.add(acc.id); //Adding accountId's to set
                   System.debug('AccountID--->'+acc.id);  
                    persongroup1 = true;
            }
            if(oldAccountmap.get(Acc.id).Gender__c != acc.Gender__c || oldAccountmap.get(Acc.id).PersonBirthdate != acc.PersonBirthdate || oldAccountmap.get(Acc.id).Occupation__c != Acc.Occupation__c || oldAccountmap.get(Acc.id).Industry != acc.Industry || oldAccountmap.get(Acc.id).Preferred_Language__c != acc.Preferred_Language__c
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
            if(oldAccountmap.get(acc.id).Complaint_Amount__c != acc.Complaint_Amount__c){
                    AccountIds.add(acc.id); 
                    persongroup11 = true;
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
       UtilAddressTranslation.gettranslatedvalues('JP');
            
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
                                                toRole__r.Primary_Address_Reference__r.LastModifiedDate,toRole__r.UCID__c,toRole__r.Complaint_Amount__c, fromRole__r.Dealer_Rollout_Status__c
                                                from Account_Link__c WHERE toRole__c IN :AccountIds AND (RecordTypeID =: RetailPerson OR RecordTypeID =: RetailCompany )];
        System.debug('Accountlinklist------>'+Accountlinklist  );
        
      //Account link iteration
        for(Account_Link__c acclnk : Accountlinklist ){
    if(acclnk.fromRole__r.Dealer_Rollout_Status__c == 'Done'){
            if(acclnk.toRole__r.RecordType.Name == 'Person Account') {
                if(persongroup1 == true){
                    acclnk.Retail_LastName__c = acclnk.toRole__r.LastName;
                    acclnk.Retail_FirstName__c = acclnk.toRole__r.FirstName;
                    //acclnk.Retail_Salutation__c = acclnk.toRole__r.Salutation__c;
                    acclnk.Retail_Full_Name__c = (acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName :'') + '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'').left(25); 
                    acclnk.Retail_Full_Name_Title__c = ((acclnk.toRole__r.Salutation__c!= null ? acclnk.toRole__r.Salutation__c: '')+ '  '+(acclnk.toRole__r.LastName != null ? acclnk.toRole__r.LastName:'')+ '  ' + (acclnk.toRole__r.FirstName != null ? acclnk.toRole__r.FirstName:'')).left(140);
                    acclnk.Retail_LastName_Native__c = acclnk.toRole__r.LastName_Native_1__c;
                    acclnk.Retail_FirstName_Native__c = acclnk.toRole__r.FirstName_Native_1__c; 
                    acclnk.Retail_Full_Name_Native__c = ((acclnk.toRole__r.LastName_Native_1__c!=null ? acclnk.toRole__r.LastName_Native_1__c : '')+ ' ' +(acclnk.toRole__r.FirstName_Native_1__c!=null ? acclnk.toRole__r.FirstName_Native_1__c:'')).left(50);
                }
                if(persongroup2 == true){
                    acclnk.Retail_Gender__c = acclnk.toRole__r.Gender__c;
                    acclnk.Retail_PersonBirthdate__c = acclnk.toRole__r.PersonBirthdate;
                    acclnk.Retail_Occupation__c = acclnk.toRole__r.Occupation__c;                
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
                if(persongroup11 == true){  
                    acclnk.Retail_Complaint_Amount__c = acclnk.toRole__r.Complaint_Amount__c ;
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
                        }else {
                        acclnk.Retail_Foundation_Month__c = String.valueof(acclnk.toRole__r.Foundation_Date__c.month())+String.valueOf(acclnk.toRole__r.Foundation_Date__c.Year());         
                    }
                }
				else{
					acclnk.Retail_Foundation_Month__c = '';
				}
                acclnk.Retail_Industry__c = acclnk.toRole__r.Industry; 
                acclnk.Retail_Website__c = acclnk.toRole__r.website;
            }
                
            if(persongroup4 == true){
                acclnk.Retail_Company_Phone__c = acclnk.toRole__r.Individual_Home_Phone__c;
            }               
            if(persongroup5 == true){
                acclnk.Retail_Company_Other_Phone__c = acclnk.toRole__r.Work_Phone__c;
            }                                  
            }//End if for Company record type
            if(persongroup7 == true){
                    acclnk.Retail_Fax__c = acclnk.toRole__r.Fax;
             }  
            
                       
            //acclnk.Retail_UCID__c = acclnk.toRole__r.UCID__c;   
              //Checking Null for sales Address 
            if(acclnk.toRole__r.Primary_Address_Reference__c != null && persongroup9 == True){ 
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
                    //acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.CreatedDate);
                    //acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(acclnk.toRole__r.Primary_Address_Reference__r.LastModifiedDate);

                }//End if for Sales Address
            
            AccountlnkUpdate.add(acclnk); //Adding Account link to List  
            system.debug('AccountlnkUpdate--->'+AccountlnkUpdate);
        }
    }//End of for loop
        
        if(!AccountlnkUpdate.isEmpty())
            update AccountlnkUpdate;
			}
    }//End of Method
    //*created by :Suryavarma
    // sharing account to dealer user
    //SFDCJP(2.0)-578 
 public static void handleAfterInsertEvent(list<Account>listDealerAccounts)
    {
     Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        set<String> GCCode = new set<String>();
        list<String> AccountNAme = new List<String>();
        list<account>aclist=new list<account>();
                        if(listDealerAccounts!=null && !listDealerAccounts.isempty())
                {
        aclist=[select id,name,recordtypeId,Dealer_GC_Code__c from account where id IN :listDealerAccounts];
        for(account a:aclist){
            GCCode.add(a.Dealer_GC_Code__c);
        
        }
    }
    list<account>accounts=[select id, Name, RecordTypeId,Dealer_GC_Code__c from Account WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeid=:Dealer_RecordTypeId ];
        list<accountshare>aslist=new list<accountshare>();
        map<string,id> assgroupMap = new map<string,id>();  
      for(Account acc :accounts){
           system.debug('acc.Name'+acc.Name);
           AccountNAme.add(acc.Name);   
       }
        Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
                                if( aclist!=null && !aclist.isempty())
                                {
        for(account a:aclist)
        {
                                                 if(a.recordtypeid==rpa)
            {
              for(Group assg:[select id ,Name ,Type from Group where Name=:a.name OR Name IN: AccountNAme])
               {
               
                assgroupMap.put(assg.Name, assg.id);
                system.debug('Inserting');

               }
            }
             if(AccountNAme.size()>0)
                 {
                    for(id m:assgroupMap.values())
                    {
                       Accountshare acs=new Accountshare();
                         acs.Accountid=a.id;
                         acs.UserOrGroupId = m;
                         acs.AccountAccessLevel='read';
                         acs.OpportunityAccessLevel ='read';
                         acs.RowCause = Schema.Accountshare.RowCause.Manual;
                         aslist.add(acs);
                    }
                    
                 }
                                                
          else if(assgroupMap!=null && assgroupMap.containskey(a.name))
            {
            
                Accountshare acs=new Accountshare();
                acs.Accountid=a.id;
                acs.UserOrGroupId = assgroupMap.get(a.name);
                acs.AccountAccessLevel='read';
                acs.OpportunityAccessLevel ='read';
                acs.RowCause = Schema.Accountshare.RowCause.Manual;
                aslist.add(acs);
            }
        }
                                }
            if(aslist!=null)
            {
             insert aslist;
            }

    
    }

 public static void handleAfterInsertUpdateEvent(list<Account>listDealerAccounts,Map<Id,Account>OldMap)
    {
        list<account>aclist=[select id,name,recordtypeId from account where id IN :listDealerAccounts];
        list<accountshare>aslist=new list<accountshare>();
        map<string,id> assgroupMap = new map<string,id>();  

        Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
        for(account a:aclist)
        {
            if(a.recordtypeid==rpa && a.recordtypeid!=OldMap.get(a.id).recordtypeId)
            {
              for(Group assg:[select id ,Name ,Type from Group where Name=:a.name])
               {
               
                assgroupMap.put(assg.Name, assg.id);

               }
            }
            if(assgroupMap!=null && assgroupMap.containskey(a.name))
            {
            
                Accountshare acs=new Accountshare();
                acs.Accountid=a.id;
                acs.UserOrGroupId = assgroupMap.get(a.name);
                acs.AccountAccessLevel='read';
                acs.OpportunityAccessLevel ='read';
                acs.RowCause = Schema.Accountshare.RowCause.Manual;
                aslist.add(acs);
            }
        }
            if(aslist!=null)
            {
             insert aslist;
            }
    
    }
    /*Concatenate full Company Name into Account Name field when Company Account is created/updated.
    sivaram(2.0)SFDCJP-474
    */
    public static void updateCompanyAccountNameBeforeInsert(list<Account> listAccounts){
        try{
          System.debug('inserting>>>>>>>>>>>>>');
           // user usr = [select id, LanguageLocaleKey from user WHERE ID = : userInfo.getUserId()];
            system.debug('LanguageLocaleKey ---->'+usr.LanguageLocaleKey );
            List<Account> accList = new List<Account>();
			if(usr.Profile.Name != 'IntegrationAPI'){
           Map<String,String> TranslateMap= UtilAddressTranslation.gettranslatedAccName('JP');
           ID RDType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            for(Account acc : listAccounts){
                if(acc.Company_Name__c != NUll && acc.recordtypeid == RDType){
                   String Company_Legal_Form;

                   if (acc.Company_Legal_form__c != NULL )
                    {
                     Company_Legal_Form= acc.Company_Legal_form__c;
                     }
                     else if (acc.Company_Legal_Form_text__c !=NULL)
                     {
                       Company_Legal_Form= acc.Company_Legal_form_Text__c;
                        }
                                    
                                    if(acc.Legal_Form_Position__c== NULL )
                                    {
                                        
                                           acc.name =  (acc.Company_Name__c!=null ?acc.Company_Name__c : '' );
                                    }
                                    else if(acc.Legal_Form_Position__c == 'Pre') {
                                        if(usr.LanguageLocaleKey == 'ja')
                                            acc.name = (TranslateMap.get(Company_Legal_Form)!= null ? TranslateMap.get(Company_Legal_Form): '')  + (acc.Company_Name__c!= null ? acc.Company_Name__c : '');
                                        else
                                           acc.name = (Company_Legal_Form != null?Company_Legal_Form:'' ) + (acc.Company_Name__c != null ?acc.Company_Name__c : '' );     
                                    }
                                    else if(acc.Legal_Form_Position__c == 'Post'){
                                        if(usr.LanguageLocaleKey == 'ja')
                                            acc.name = (acc.Company_Name__c!= null ?acc.Company_Name__c : '' ) + (TranslateMap.get(Company_Legal_Form)!= null ? TranslateMap.get(Company_Legal_Form):'');
                                        else
                                            acc.name = (acc.Company_Name__c != null ? acc.Company_Name__c : '') + (Company_Legal_Form != null ? Company_Legal_Form:'');    
                                    }
                                
                }
            }
			}
        }
        catch(Exception e){
            System.debug('Error'+e.getMessage());
            System.debug('Cause'+e.getCause());
            System.debug('Line Numer'+e.getLineNumber());
        }
    }
    public static void UpdateVRonAccount(list<Account> accMainList)
    {
        Set<Id> sid = New Set<Id>();
        
        list<Account> updateacclist = new list<Account>(); 
        List<Vehicle_Relationship__c> Updateli = new List<Vehicle_Relationship__c> (); 
                
             if(LeadUtil.Acctrigger )
            {    
                for(Account abc: accMainList)
                
                {
                     sid.add(abc.Id);   
                }
                
            }    
                
                

       List<Account> accList =  [select id,Individual_Home_Phone__c,Primary_Address_Reference__c,Work_Phone__c,Home_Phone_2__c,FAX,Fax2__c,Email__c,Email2__c,Email3__c,(select id,vehicle_address__c,vehicle_fax__c,vehicle_mail__c,Vehicle_Phone__c,vehicle_address_picklist__c ,vehicle_fax_picklist__c,vehicle_mail_picklist__c,End_Date__c,Vehicle_Phone_picklist__c from Vehicle_Relationships2__r  where End_Date__c =null) From Account where id =:sid ];
       
        system.debug('++++++++++++++'+accList);
       for(Account acc : accList){
       
       for(Vehicle_Relationship__c Velti : acc.Vehicle_Relationships2__r){
       
                   system.debug('+++++++++++++'+ acc.Vehicle_Relationships2__r);
                   
                   if (Velti.Vehicle_address_picklist__c == '--None--')
                    {
                            Velti.Vehicle_mail__c = acc.Primary_Address_Reference__c;
                             
                    } 
                   
                   if (Velti.Vehicle_Phone_picklist__c == 'Home Phone')
                    {
                            Velti.Vehicle_Phone__c = acc.Individual_Home_Phone__c;
                            system.debug('++++++++++++++'+ 'IM Too WORKING BRO'); 
                    } 
                    else if (Velti.Vehicle_Phone_picklist__c == 'Work Phone')
                    {
                            Velti.Vehicle_Phone__c = acc.Work_Phone__c;
                            system.debug('++++++++++++++'+ 'IM Too WORKING BRO');
                    }
                    else if (Velti.Vehicle_Phone_picklist__c ==  'Home Phone 2')
                    {
                            Velti.Vehicle_Phone__c = acc.Home_Phone_2__c;
                    }
                    
                   
       
       
                       if (Velti.vehicle_fax_picklist__c == 'FAX ')
                     {
                        Velti.vehicle_fax__c = acc.Fax;
                     }
                    else  if (Velti.vehicle_fax_picklist__c == 'Work FAX' ) {
                     
                        Velti.vehicle_fax__c = acc.Fax2__c;
                     system.debug('++++++++++++++'+ 'IM WORKING BRO'); 
                     }
                     
                     if (Velti.vehicle_mail_picklist__c == 'Email Home')
                    {
                        Velti.vehicle_mail__c =  acc.Email__c;
                    }
                    else if (Velti.vehicle_mail_picklist__c == 'Email Work')
                    {
                        Velti.vehicle_mail__c = acc.Email2__c;
                        system.debug('++++++++++++++'+ 'IM Three WORKING BRO'); 
                        system.debug('+++++++++++'+Velti.vehicle_mail__c );
                    }
                    else if (Velti.vehicle_mail_picklist__c == 'MyMercedes Email')
                    {
                        Velti.vehicle_mail__c = acc.Email3__c;
                    }
                   
                  
                                  
       
           Updateli.add(Velti ); 
       }
       }
     Update Updateli ;
    LeadUtil.Acctrigger = false; 
}

 public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate){
 if(userinfo.getUserType()=='PowerPartner')
 {
    Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
    Set<String> OwnerIds = new set<String>();//Set initialization to add Owner Id's \
     Set<String> UsrAccountIds = new set<String>();   
    for(Account acc : accLst){
                if(isInsert && acc.MD__c == label.MarketJp){ //Checking Market for updated account
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
            UtilAddressTranslation.gettranslatedvalues('JP');
       
    Map<ID,User> ownermap = new Map<ID,User>([select id , name , ContactId , Contact.AccountId from user where id IN : OwnerIds]);
    
    /*for(User ur : ownermap.values()){
        UsrAccountIds.add(ur.Contact.AccountId);        
    }*/
        
        List<Account> AccList = [select Id, LastName, FirstName,LastName_Native_1__c, 
                                 FirstName_Native_1__c, PersonBirthdate, Special_Care__c, Individual_Home_Phone__c, Work_Phone__c,
                                 Mobile__c, Fax, Email__c, Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c,
                                 Primary_Address_Reference__r.Block__c, Primary_Address_Reference__r.Address_Line_1__c,
                                 Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,                                 
                                 gender__c, Occupation__c, Industry,Preferred_Language__c,
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
    //Integer dealercount = [select count() from Account_Link__c WHERE toRole__c IN : AccountIds AND fromRole__c IN : UsrAccountIds AND (RecordTypeId = :recordTypes.get('Retail_Company') OR RecordTypeId = :recordTypes.get('Retail_Person'))];    
    for(Account led : AccList){            
            if(ownermap.containskey(led.ownerid) ){// && dealercount == 0){
                 Account_Link__c acclnk = new Account_Link__c();
                 /*acclnk.RecordTypeId = recordTypes.get('ContactSector');
                 acclnk.Name = led.UCID__c;
                 acclnk.fromRole__c = led.Id;               
                  acclnk.toRole__c = ownermap.get(led.ownerid).Contact.AccountId;
                  acclnk.CorrelationID__c = origin ;
                 acckLst.add(acclnk);*/
                 if(led.RecordTypeId == PersonRecordTypeId){
                 acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Person'), fromRole__c = ownermap.get(led.ownerid).Contact.AccountId, toRole__c = led.Id,                                                                         
                                                                        Retail_Full_Name__c = ((led.LastName!=null ? led.LastName : '') + '  ' + (led.FirstName != null ? led.FirstName : '')).left(25) ,
                                                                        Retail_PersonBirthdate__c = led.PersonBirthdate, Retail_Special_Care__c = led.Special_Care__c, Retail_Individual_Home_Phone__c = led.Individual_Home_Phone__c,
                                                                        Retail_Work_Phone__c = led.Work_Phone__c, Retail_Mobile__c = led.Mobile__c, Retail_Email__c = led.Email__c,                                                                       
                                                                        Retail_Gender__c = led.Gender__c, Retail_Occupation__c = led.Occupation__c,
                                                                        Retail_Preferred_Language__c = led.Preferred_Language__c,
                                                                        Retail_Preferred_Contact_Method__c = led.Preferred_Contact_Method__c,
                                                                        Retail_Special_Needs_Class__c = led.Special_Needs_Class__c, Retail_Allow_Data_Sharing__c = led.Allow_Data_Sharing2__c,
                                                                        Retail_Full_Name_Native__c = ((led.LastName_Native_1__c != null ? led.LastName_Native_1__c: '') + ' ' + (led.FirstName_Native_1__c != null ?led.FirstName_Native_1__c :'' )).left(50),
                                                                        
                                                                        Retail_LastName__c = led.LastName, Retail_FirstName__c = led.FirstName, 
                                                                        Retail_Full_Name_Title__c = ((led.LastName!=null ? led.LastName : '') + '  ' + (led.FirstName != null ? led.FirstName : '')),//+ '  ' + (led.FirstName!= null ? led.FirstName : '')
                                                                        Retail_LastName_Native__c = led.LastName_Native_1__c, Retail_FirstName_Native__c = led.FirstName_Native_1__c,
                                                                        Retail_UCID__c = led.UCID__c);
                  }else if(led.RecordTypeId == AccountCompanyId){
                      acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Company'), fromRole__c = ownermap.get(led.ownerid).Contact.AccountId, toRole__c = led.Id,          
                                                     Retail_Company_Name__c = led.Name, Retail_Company_Name_Native1__c = led.Company_Name_Native_1__c, 
                                                     Retail_Commercial_Reg_No__c = led.Commercial_Reg_No__c, Retail_Website__c = led.website,Retail_Company_Phone__c = led.Individual_Home_Phone__c,
                                                     Retail_Company_Other_Phone__c = led.Work_Phone__c, Retail_Vat_No__c = led.Vat_No__c,
                                                     Retail_UCID__c = led.UCID__c); 
                       if(led.Foundation_Date__c != null){
                           acclnk.Retail_Foundation_Month__c = String.ValueOf(led.Foundation_Date__c.month())+String.valueOf(led.Foundation_Date__c.year());
                       }
                  }
                  acclnk.Retail_Fax__c = led.Fax;
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
                   } else {
                   
                   
                   }   
                   acckLst.add(acclnk);
            }
         }    
         if(!accLst.isEmpty()){
           insert acckLst;
           
         }
     }   
 }
}