/**
** Utility class for Create and Update Retail Copies from Account Link and Account.
** Created By: Sudhir
** Date: 2017-06-14
** Modified By : 
** Modified date :
**/

public class createUpdateRetailCopy 
{
    public static Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_VehicleExternalRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static string province;
    public static string regexForNullValue ='null';
    public static string nullValue ='';
    public static Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
    
    public static void updateRetailCopyFromAccount(set<Id> accountIds ,List<Account_Link__c> acclnkList)
    {
        List<Account> accountList = new List<Account>();
        Map<id,Account> accountMap = new Map<id,Account>();
        
        UtilAddressTranslation.gettranslatedvalues('JP');
        
        if(!accountIds.isEmpty() && accountIds != null)
        {
            accountList = [select id,Name,RecordType.Name, LastName, FirstName, Salutation__c, LastName_Native_1__c,
                           FirstName_Native_1__c, Gender__c, PersonBirthdate, Occupation__c, Industry, 
                           Preferred_Language__c, Primary_Phone__c, Special_Care__c, Special_Needs_Class__c,
                           Allow_Data_Sharing2__c, Individual_Home_Phone__c, Work_Phone__c, Mobile__c, Fax,
                           Email__c,Primary_Address_Reference__r.Address_Type__c, Primary_Address_Reference__r.Province__c,
                           Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c, Primary_Address_Reference__r.Block__c,
                           Primary_Address_Reference__r.Address_Line_1__c, Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,
                           Company_Name_Native_1__c, Commercial_Reg_No__c, Vat_No__c, 
                           Foundation_Date__c, Website, Primary_Address_Reference__r.CreatedDate,UCID__c,
                           Primary_Address_Reference__r.LastModifiedDate
                           from Account WHERE Id IN :AccountIds];
        }
        if(!accountList.isEmpty() && accountList!= null)
        {
            accountMap.putAll(accountList);
        }
        if(!acclnkList.isEmpty() && acclnkList != null)
        {
            for(Account_Link__c acclink : acclnkList)
            {
                if(!accountMap.isEmpty() && accountMap != null && accountMap.get(acclink.toRole__c) != null)
                {
                    if(accountMap.get(acclink.toRole__c).RecordType.Name == 'Person Account')
                    {
                        acclink.Retail_LastName__c = accountMap.get(acclink.toRole__c).LastName;
                        acclink.Retail_FirstName__c = accountMap.get(acclink.toRole__c).FirstName;
                        acclink.Retail_Full_Name__c = ((accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'')+ '  ' + (accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(25);
                        acclink.Retail_Full_Name_Title__c = ((accountMap.get(acclink.toRole__c).Salutation__c!= null ? accountMap.get(acclink.toRole__c).Salutation__c: '')+ '  '+(accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'') + '  '+(accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(140);
                        acclink.Retail_LastName_Native__c = accountMap.get(acclink.toRole__c).LastName_Native_1__c;
                        acclink.Retail_FirstName_Native__c = accountMap.get(acclink.toRole__c).FirstName_Native_1__c; 
                        acclink.Retail_Full_Name_Native__c = ((accountMap.get(acclink.toRole__c).LastName_Native_1__c != null ? accountMap.get(acclink.toRole__c).LastName_Native_1__c:'')+ ' ' +(accountMap.get(acclink.toRole__c).FirstName_Native_1__c != null ? accountMap.get(acclink.toRole__c).FirstName_Native_1__c:'')).left(50); 
                        acclink.Retail_Gender__c = accountMap.get(acclink.toRole__c).Gender__c;
                        acclink.Retail_PersonBirthdate__c = accountMap.get(acclink.toRole__c).PersonBirthdate;
                        acclink.Retail_Occupation__c = accountMap.get(acclink.toRole__c).Occupation__c;                
                        acclink.Retail_Preferred_Language__c = accountMap.get(acclink.toRole__c).Preferred_Language__c;
                        acclink.Retail_Primary_Phone__c = accountMap.get(acclink.toRole__c).Primary_Phone__c;
                        acclink.Retail_Special_Care__c = accountMap.get(acclink.toRole__c).Special_Care__c;
                        acclink.Retail_Special_Needs_Class__c = accountMap.get(acclink.toRole__c).Special_Needs_Class__c;
                        acclink.Retail_Allow_Data_Sharing__c = accountMap.get(acclink.toRole__c).Allow_Data_Sharing2__c;                
                        acclink.Retail_Work_Phone__c = accountMap.get(acclink.toRole__c).Work_Phone__c;
                        acclink.Retail_Mobile__c = accountMap.get(acclink.toRole__c).Mobile__c;                
                        acclink.Retail_Email__c = accountMap.get(acclink.toRole__c).Email__c;
                        acclink.Retail_Individual_Home_Phone__c = accountMap.get(acclink.toRole__c).Individual_Home_Phone__c;
                    }
                    
                    if(accountMap.get(acclink.toRole__c).RecordType.Name=='Company')
                    { 
                        acclink.Retail_Company_Name__c = accountMap.get(acclink.toRole__c).Name;
                        acclink.Retail_Company_Name_Native1__c = accountMap.get(acclink.toRole__c).Company_Name_Native_1__c;
                        acclink.Retail_Commercial_Reg_No__c = accountMap.get(acclink.toRole__c).Commercial_Reg_No__c;
                        acclink.Retail_Vat_No__c = accountMap.get(acclink.toRole__c).Vat_No__c;
                        if(accountMap.get(acclink.toRole__c).Foundation_Date__c != null)
                        {
                            Integer FoundationDate = accountMap.get(acclink.toRole__c).Foundation_Date__c.month();
                            if(FoundationDate <= 9)
                            {
                                acclink.Retail_Foundation_Month__c = '0'+String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.Year());      
                            }
                            else 
                            {                    
                                acclink.Retail_Foundation_Month__c = String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.Year());
                            }
                        }
                        acclink.Retail_Company_Phone__c = accountMap.get(acclink.toRole__c).Individual_Home_Phone__c;
                        acclink.Retail_Company_Other_Phone__c =  accountMap.get(acclink.toRole__c).Work_Phone__c;
                    }
                    acclink.Retail_Industry__c = accountMap.get(acclink.toRole__c).Industry; 
                    acclink.Retail_Website__c = accountMap.get(acclink.toRole__c).website;
                    acclink.Retail_Fax__c = accountMap.get(acclink.toRole__c).Fax;
                    acclink.Retail_UCID__c = accountMap.get(acclink.toRole__c).UCID__c;
                    
                    if(accountMap.get(acclink.toRole__c).Primary_Address_Reference__c != null)
                    { 
                        acclink.Retail_Address_Type__c = accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Type__c; 
                        if(addtrmap1.containsKey(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c) )
                        {
                            province = addtrmap1.get(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c);
                        } 
                        acclink.Retail_Province__c = province ;  
                        if(province ==null && province == '')
                        {
                            acclink.Retail_Province__c  =acclink.Retail_Province__c.replaceAll(regexForNullValue,nullValue); 
                        }
                        acclink.Retail_City__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.City__c != null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.City__c:'').left(17);
                        acclink.Retail_Distinct__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.District__c!=null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.District__c : '')+(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Block__c!= null ?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Block__c : '')).left(17);
                        acclink.Retail_Address_Line_1__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_1__c)!=null?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                        acclink.Retail_Address_Line_2__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_2__c)!=null?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                        acclink.Retail_ZipCode__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.ZipCode__c!=null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.ZipCode__c : '' );
                        acclink.Retail_Address_CreatedDate__c = Date.ValueOf(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.CreatedDate);
                        acclink.Retail_Address_LastModifiedDate__c = Date.ValueOf(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.LastModifiedDate);
                        
                    }//End if for Sales Address
                }
            }
        }
    }
    public static void updateRetailCopyFromAccountLinkbeforeInsert(set<Id> accountlinkIds ,List<Account_Link__c> acclkList)
    {
        List<Account_Link__c> accountLinkList = new List<Account_Link__c>();
        map<id,Account_Link__c> accountLinkMap = new map<id,Account_Link__c>();
        map<id,Account_Link__c> accountLinkUpdateMap = new map<id,Account_Link__c>();
        system.debug('accountlinkIds>>>>' + accountlinkIds);
        if(!accountlinkIds.isEmpty() && accountlinkIds != null)
        {
            accountLinkList = [select id,torole__c,Vehicle__c,CurrentMileage__c,RecordType.Name,Retail_LastName__c,Retail_FirstName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,
                               Retail_LastName_Native__c,Retail_FirstName_Native__c ,Retail_Full_Name_Native__c ,
                               Retail_Gender__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Preferred_Language__c,
                               Retail_Primary_Phone__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_Allow_Data_Sharing__c,
                               Retail_Work_Phone__c,Retail_Mobile__c,Retail_Email__c,Retail_Individual_Home_Phone__c ,Retail_Company_Name__c,
                               Retail_Company_Name_Native1__c,Retail_Commercial_Reg_No__c,Retail_Vat_No__c,Retail_Foundation_Month__c ,Retail_Company_Phone__c,
                               Retail_Company_Other_Phone__c,Retail_Industry__c ,Retail_Website__c,Retail_Fax__c,Retail_UCID__c,Retail_Address_Type__c,
                               Retail_Province__c ,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,
                               Retail_Address_CreatedDate__c,Retail_Address_Reference__c,Retail_Address_LastModifiedDate__c from Account_Link__c where id =:accountlinkIds Order BY CreatedDate ASC limit 1];
        }
        system.debug('accountLinkList>>>>' + accountLinkList);
        if(!accountLinkList.isEmpty() && accountLinkList != null)
        {
            for(Account_Link__c acclk : accountLinkList)
            {
                if(acclk.toRole__c != null && (acclk.RecordTypeId == AccountLink_RetailPersonRecordTypeId || acclk.RecordTypeId == AccountLink_RetailCompanyRecordTypeId))
                {
                    system.debug('INSSKSKSKS');
                    accountLinkMap.put(acclk.toRole__c, acclk);
                }
                if(acclk.Vehicle__c != null && acclk.RecordTypeId == AccountLink_VehicleExternalRecordTypeId)
                {
                    accountLinkMap.put(acclk.Vehicle__c, acclk);
                }
            }
        }
        system.debug('accountLinkMap>>>>' + accountLinkMap);
        if(!acclkList.isEmpty() && acclkList != null)
        {
            for(Account_Link__c aclnk : acclkList)
            {
                system.debug('aclnk>>>>>>' + aclnk.Retail_Individual_Home_Phone__c);
                if(!accountLinkList.isEmpty() && accountLinkList != null)
                {
                    for(Account_Link__c accnk : accountLinkList)
                    {
                        system.debug('Enterededsdsd');
                        accnk.Retail_Individual_Home_Phone__c = aclnk.Retail_Individual_Home_Phone__c;
                    }
                }
                if(aclnk.toRole__c != null)
                {
                    if(!accountLinkMap.isEmpty() && accountLinkMap != null && accountLinkMap.get(aclnk.toRole__c) != null)
                    {
                        system.debug('INSertsadasd>>>>>');
                        aclnk.Retail_Industry__c = accountLinkMap.get(aclnk.toRole__c).Retail_Industry__c;
                        aclnk.Retail_Address_Reference__c = accountLinkMap.get(aclnk.toRole__c).Retail_Address_Reference__c;
                        aclnk.Retail_Website__c = accountLinkMap.get(aclnk.toRole__c).Retail_Website__c;
                        aclnk.Retail_Fax__c = accountLinkMap.get(aclnk.toRole__c).Retail_Fax__c;
                        aclnk.Retail_UCID__c = accountLinkMap.get(aclnk.toRole__c).Retail_UCID__c;
                        aclnk.Retail_Address_Type__c = accountLinkMap.get(aclnk.toRole__c).Retail_Address_Type__c;
                        aclnk.Retail_Province__c = accountLinkMap.get(aclnk.toRole__c).Retail_Province__c;
                        aclnk.Retail_City__c = accountLinkMap.get(aclnk.toRole__c).Retail_City__c;
                        aclnk.Retail_Distinct__c = accountLinkMap.get(aclnk.toRole__c).Retail_Distinct__c;
                        aclnk.Retail_Address_Line_1__c = accountLinkMap.get(aclnk.toRole__c).Retail_Address_Line_1__c;
                        aclnk.Retail_Address_Line_2__c = accountLinkMap.get(aclnk.toRole__c).Retail_Address_Line_2__c;
                        aclnk.Retail_ZipCode__c = accountLinkMap.get(aclnk.toRole__c).Retail_ZipCode__c;
                        aclnk.Retail_Address_CreatedDate__c = accountLinkMap.get(aclnk.toRole__c).Retail_Address_CreatedDate__c;
                        aclnk.Retail_Address_LastModifiedDate__c =accountLinkMap.get(aclnk.toRole__c).Retail_Address_LastModifiedDate__c;
                        
                        if(accountLinkMap.get(aclnk.toRole__c).RecordType.Name == 'Retail Person')
                        {
                            aclnk.Retail_LastName__c = accountLinkMap.get(aclnk.toRole__c).Retail_LastName__c;
                            aclnk.Retail_FirstName__c = accountLinkMap.get(aclnk.toRole__c).Retail_FirstName__c;
                            aclnk.Retail_Full_Name__c = accountLinkMap.get(aclnk.toRole__c).Retail_Full_Name__c;
                            aclnk.Retail_Full_Name_Title__c = accountLinkMap.get(aclnk.toRole__c).Retail_Full_Name_Title__c;
                            aclnk.Retail_LastName_Native__c = accountLinkMap.get(aclnk.toRole__c).Retail_LastName_Native__c;
                            aclnk.Retail_FirstName_Native__c = accountLinkMap.get(aclnk.toRole__c).Retail_FirstName_Native__c; 
                            aclnk.Retail_Full_Name_Native__c =  accountLinkMap.get(aclnk.toRole__c).Retail_Full_Name_Native__c;
                            aclnk.Retail_Gender__c = accountLinkMap.get(aclnk.toRole__c).Retail_Gender__c;
                            aclnk.Retail_PersonBirthdate__c = accountLinkMap.get(aclnk.toRole__c).Retail_PersonBirthdate__c;
                            aclnk.Retail_Occupation__c = accountLinkMap.get(aclnk.toRole__c).Retail_Occupation__c;                
                            aclnk.Retail_Preferred_Language__c = accountLinkMap.get(aclnk.toRole__c).Retail_Preferred_Language__c;
                            aclnk.Retail_Primary_Phone__c = accountLinkMap.get(aclnk.toRole__c).Retail_Primary_Phone__c;
                            aclnk.Retail_Special_Care__c = accountLinkMap.get(aclnk.toRole__c).Retail_Special_Care__c;
                            aclnk.Retail_Special_Needs_Class__c = accountLinkMap.get(aclnk.toRole__c).Retail_Special_Needs_Class__c;
                            aclnk.Retail_Allow_Data_Sharing__c = accountLinkMap.get(aclnk.toRole__c).Retail_Allow_Data_Sharing__c;                
                            aclnk.Retail_Work_Phone__c = accountLinkMap.get(aclnk.toRole__c).Retail_Work_Phone__c;
                            aclnk.Retail_Mobile__c = accountLinkMap.get(aclnk.toRole__c).Retail_Mobile__c;                
                            aclnk.Retail_Email__c = accountLinkMap.get(aclnk.toRole__c).Retail_Email__c;
                            aclnk.Retail_Individual_Home_Phone__c = accountLinkMap.get(aclnk.toRole__c).Retail_Individual_Home_Phone__c;
                        }
                        if(accountLinkMap.get(aclnk.toRole__c).RecordType.Name == 'Retail Company')
                        { 
                            aclnk.Retail_Company_Name__c = accountLinkMap.get(aclnk.toRole__c).Retail_Company_Name__c;
                            aclnk.Retail_Company_Name_Native1__c = accountLinkMap.get(aclnk.toRole__c).Retail_Company_Name_Native1__c;
                            aclnk.Retail_Commercial_Reg_No__c = accountLinkMap.get(aclnk.toRole__c).Retail_Commercial_Reg_No__c;
                            aclnk.Retail_Vat_No__c = accountLinkMap.get(aclnk.toRole__c).Retail_Vat_No__c;
                            aclnk.Retail_Foundation_Month__c = accountLinkMap.get(aclnk.toRole__c).Retail_Foundation_Month__c;
                            aclnk.Retail_Company_Phone__c = accountLinkMap.get(aclnk.toRole__c).Retail_Company_Phone__c;
                            aclnk.Retail_Company_Other_Phone__c =  accountLinkMap.get(aclnk.toRole__c).Retail_Company_Other_Phone__c;
                        }
                    }
                }
            }
        }
    }
    public static void updateRetailCopyFromAccountLinkafterUpdate(set<Id> accountIds ,set<id> dealerIds,set<string> dealergcCodeset,List<Account_Link__c> acclkList)
    {
        List<Account_Link__c> existaccLinkList = new List<Account_Link__c>();
        List<Account_Link__c> updateacclnkList = new List<Account_Link__c>();
        map<string,Account_Link__c> updatedacclnkMap = new map<string,Account_Link__c>();
        if(!accountIds.isEmpty() && accountIds != null)
        {
            existaccLinkList = [select id,torole__c,Retail_Sales_Sanction_Comment__c,Vehicle__c,CurrentMileage__c,RecordType.Name,Retail_LastName__c,Retail_FirstName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,
                                Retail_LastName_Native__c,Retail_Dealer_CompanyCode__c,Retail_FirstName_Native__c ,Retail_Full_Name_Native__c ,
                                Retail_Gender__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Preferred_Language__c,
                                Retail_Primary_Phone__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_Allow_Data_Sharing__c,
                                Retail_Work_Phone__c,Retail_Mobile__c,Retail_Email__c,Retail_Individual_Home_Phone__c ,Retail_Company_Name__c,
                                Retail_Company_Name_Native1__c,Retail_Commercial_Reg_No__c,Retail_Vat_No__c,Retail_Foundation_Month__c ,Retail_Company_Phone__c,
                                Retail_Company_Other_Phone__c,Retail_Industry__c ,Retail_Website__c,Retail_Fax__c,Retail_UCID__c,Retail_Address_Type__c,
                                Retail_Province__c ,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,
                                Retail_Address_CreatedDate__c,Retail_Address_Reference__c,Retail_Address_LastModifiedDate__c from Account_Link__c where (torole__c =:accountIds OR Vehicle__c =:accountIds) AND Retail_Dealer_CompanyCode__c =:dealergcCodeset AND fromrole__r.Dealer_Rollout_Status__c = 'Done'];
        }
        for(Account_Link__c acl : acclkList)
        {
            if((acl.toRole__c !=null || acl.Vehicle__c != null) && acl.fromRole__c != null && acl.RecordTypeId == AccountLink_RetailPersonRecordTypeId ||
              acl.RecordTypeId == AccountLink_RetailCompanyRecordTypeId || acl.RecordTypeId == AccountLink_VehicleExternalRecordTypeId)
            {
                updatedacclnkMap.put(acl.Retail_Dealer_CompanyCode__c, acl);
            }
        }
        system.debug('acclkList<<<<<<<<' + acclkList);
        system.debug('existaccLinkList<<<<<<<' + existaccLinkList);
        system.debug('existaccLinkList Size<<<<<<<' + existaccLinkList.size());
        system.debug('updatedacclnkMap<<<<<<<<' + updatedacclnkMap);
        for(Account_Link__c aclnk : existaccLinkList)
        {
            if(aclnk.RecordTypeId == AccountLink_RetailPersonRecordTypeId
               || aclnk.RecordTypeId == AccountLink_RetailCompanyRecordTypeId && updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Id != aclnk.Id)
            {
                aclnk.Retail_Industry__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Industry__c;
                aclnk.Retail_Website__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Website__c;
                aclnk.Retail_Fax__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Fax__c;
                aclnk.Retail_UCID__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_UCID__c;
                
                system.debug('ENTERE%^$^%$^$%');
                if(updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).RecordTypeId == AccountLink_RetailPersonRecordTypeId)
                {
                    system.debug('accountLinkId>>>>' + aclnk.Id);
                    system.debug('INS%$%$%$%$%$');
                    aclnk.Retail_LastName__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_LastName__c;
                    aclnk.Retail_FirstName__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_FirstName__c;
                    aclnk.Retail_Full_Name__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Full_Name__c;
                    aclnk.Retail_Full_Name_Title__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Full_Name_Title__c;
                    aclnk.Retail_LastName_Native__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_LastName_Native__c;
                    aclnk.Retail_FirstName_Native__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_FirstName_Native__c; 
                    aclnk.Retail_Full_Name_Native__c =  updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Full_Name_Native__c;
                    aclnk.Retail_Gender__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Gender__c;
                    aclnk.Retail_PersonBirthdate__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_PersonBirthdate__c;
                    //aclnk.Retail_Occupation__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Occupation__c;                
                    aclnk.Retail_Preferred_Language__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Preferred_Language__c;
                    aclnk.Retail_Primary_Phone__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Primary_Phone__c;
                    aclnk.Retail_Special_Care__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Special_Care__c;
                    aclnk.Retail_Special_Needs_Class__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Special_Needs_Class__c;
                    aclnk.Retail_Allow_Data_Sharing__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Allow_Data_Sharing__c;                
                    aclnk.Retail_Work_Phone__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Work_Phone__c;
                    aclnk.Retail_Mobile__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Mobile__c;                
                    aclnk.Retail_Email__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Email__c;
                    aclnk.Retail_Individual_Home_Phone__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Individual_Home_Phone__c;
                    aclnk.Retail_Sales_Sanction_Comment__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Sales_Sanction_Comment__c;
                }
                if(updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).RecordTypeId == AccountLink_RetailCompanyRecordTypeId)
                { 
                    aclnk.Retail_Company_Name__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Company_Name__c;
                    aclnk.Retail_Company_Name_Native1__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Company_Name_Native1__c;
                    aclnk.Retail_Commercial_Reg_No__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Commercial_Reg_No__c;
                    aclnk.Retail_Vat_No__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Vat_No__c;
                    aclnk.Retail_Foundation_Month__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Foundation_Month__c;
                    aclnk.Retail_Company_Phone__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Company_Phone__c;
                    aclnk.Retail_Company_Other_Phone__c =  updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Retail_Company_Other_Phone__c;
                }
            }
            if(updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Vehicle__c != null && updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).RecordTypeId == AccountLink_VehicleExternalRecordTypeId)
            {
                aclnk.LastServiceDate__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).LastServiceDate__c;
                aclnk.Service_Dealer__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Service_Dealer__c;
                aclnk.LastServiceMileage__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).LastServiceMileage__c;
                aclnk.NextInspectionDate__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).NextInspectionDate__c;
                aclnk.NextServiceDate__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).NextServiceDate__c;
                aclnk.NextMileage__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).NextMileage__c;
                aclnk.Responsible_Dealer__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Responsible_Dealer__c;
                aclnk.Sales_Representative__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Sales_Representative__c;
                aclnk.Selling_Dealer__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Selling_Dealer__c;
                aclnk.Service_Advisor__c = updatedacclnkMap.get(aclnk.Retail_Dealer_CompanyCode__c).Service_Advisor__c;
            }
            updateacclnkList.add(aclnk);
        }
        
        system.debug('updateacclnkList<><><><><' + updateacclnkList);
        if(!updateacclnkList.isEmpty() && updateacclnkList != null)
        {
            update updateacclnkList;
        }
    }
    public static void createUpdateRetailCopyAccountCreation(set<Id> accIds)
    {
        List<Account> accList = new List<Account>();
        List<Account_Link__c> accLinkList = new List<Account_Link__c>();
        List<Account_Link__c> existAccLinkList = new List<Account_Link__c>();
        //string corelationID = ApexPages.currentPage().getParameters().get('CLNID');
        
        if(!accIds.isEmpty() && accIds != null)
        {
            accList = [select Id, LastName, FirstName,LastName_Native_1__c, 
                       FirstName_Native_1__c, PersonBirthdate, Special_Care__c, Individual_Home_Phone__c, Work_Phone__c,
                       Mobile__c, Fax, Email__c, Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c,
                       Primary_Address_Reference__r.Block__c, Primary_Address_Reference__r.Address_Line_1__c,
                       Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,                        
                       gender__c, Occupation__c, Industry,Preferred_Language__c,Special_Needs_Class__c,Primary_Address_Reference__r.LastModifiedDate,
                       Allow_Data_Sharing2__c, Primary_Address_Reference__r.Address_Type__c,Preferred_Contact_Method__c, 
                       Primary_Address_Reference__r.Province__c,MD__c,owner.Contact.AccountId,Primary_Address_Reference__r.CreatedDate,
                       UCID__c, RecordtypeId, Name, Company_Name_Native_1__c,Foundation_Date__c,ownerid,Commercial_Reg_No__c,
                       Website,Vat_No__c from Account WHERE id IN : accIds];
            
            existAccLinkList = [select id,torole__c,RecordType.Name,Retail_LastName__c,Retail_FirstName__c,Retail_Full_Name__c,Retail_Full_Name_Title__c,
                                Retail_LastName_Native__c,Retail_FirstName_Native__c ,Retail_Full_Name_Native__c ,
                                Retail_Gender__c,Retail_PersonBirthdate__c,Retail_Occupation__c,Retail_Preferred_Language__c,
                                Retail_Primary_Phone__c,Retail_Special_Care__c,Retail_Special_Needs_Class__c,Retail_Allow_Data_Sharing__c,
                                Retail_Work_Phone__c,Retail_Mobile__c,Retail_Email__c,Retail_Individual_Home_Phone__c ,Retail_Company_Name__c,
                                Retail_Company_Name_Native1__c,Retail_Commercial_Reg_No__c,Retail_Vat_No__c,Retail_Foundation_Month__c ,Retail_Company_Phone__c,
                                Retail_Company_Other_Phone__c,Retail_Industry__c ,Retail_Website__c,Retail_Fax__c,Retail_UCID__c,Retail_Address_Type__c,
                                Retail_Province__c ,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_ZipCode__c,
                                Retail_Address_CreatedDate__c,Retail_Address_LastModifiedDate__c from Account_Link__c where torole__c =:accIds AND fromrole__r.Dealer_Rollout_Status__c = 'Done' AND
                                (RecordtypeId =:AccountLink_RetailPersonRecordTypeId OR RecordtypeId =:AccountLink_RetailCompanyRecordTypeId)];
        }
        system.debug('existAccLinkList<><><>' + existAccLinkList);
        for(Account acc : accList)
        {
            Account_Link__c acclnk = new Account_Link__c();
            if(!existAccLinkList.isEmpty() && existAccLinkList != null)
            {
                for(Account_Link__c exstacclnk : existAccLinkList)
                {
                    if(acc.RecordTypeId == PersonRecordTypeId)
                    {                                                                       
                        exstacclnk.Retail_Full_Name__c = ((acc.LastName!=null ? acc.LastName : '') + '  ' + (acc.FirstName != null ? acc.FirstName : '')).left(25);
                        exstacclnk.Retail_PersonBirthdate__c = acc.PersonBirthdate;
                        exstacclnk.Retail_Special_Care__c = acc.Special_Care__c;
                        exstacclnk.Retail_Individual_Home_Phone__c = acc.Individual_Home_Phone__c;
                        exstacclnk.Retail_Work_Phone__c = acc.Work_Phone__c;
                        exstacclnk.Retail_Mobile__c = acc.Mobile__c;
                        exstacclnk.Retail_Email__c = acc.Email__c;                                                                      
                        exstacclnk.Retail_Gender__c = acc.Gender__c;
                        exstacclnk.Retail_Occupation__c = acc.Occupation__c;
                        exstacclnk.Retail_Preferred_Language__c = acc.Preferred_Language__c;
                        exstacclnk.Retail_Preferred_Contact_Method__c = acc.Preferred_Contact_Method__c;
                        exstacclnk.Retail_Special_Needs_Class__c = acc.Special_Needs_Class__c;
                        exstacclnk.Retail_Allow_Data_Sharing__c = acc.Allow_Data_Sharing2__c;
                        exstacclnk.Retail_Full_Name_Native__c = ((acc.LastName_Native_1__c != null ? acc.LastName_Native_1__c: '') + ' ' + (acc.FirstName_Native_1__c != null ?acc.FirstName_Native_1__c :'' )).left(50);
                        exstacclnk.Retail_LastName__c = acc.LastName;
                        exstacclnk.Retail_FirstName__c = acc.FirstName; 
                        exstacclnk.Retail_Full_Name_Title__c = ((acc.LastName!=null ? acc.LastName : '') + '  ' + (acc.FirstName != null ? acc.FirstName : ''));//+ '  ' + (acc.FirstName!= null ? acc.FirstName : '')
                        exstacclnk.Retail_LastName_Native__c = acc.LastName_Native_1__c;
                        exstacclnk.Retail_FirstName_Native__c = acc.FirstName_Native_1__c;
                        exstacclnk.Retail_UCID__c = acc.UCID__c;
                    }
                    else if(acc.RecordTypeId == AccountCompanyId)
                    {          
                        exstacclnk.Retail_Company_Name__c = acc.Name;
                        exstacclnk.Retail_Company_Name_Native1__c = acc.Company_Name_Native_1__c; 
                        exstacclnk.Retail_Commercial_Reg_No__c = acc.Commercial_Reg_No__c;
                        exstacclnk.Retail_Website__c = acc.website;
                        exstacclnk.Retail_Company_Phone__c = acc.Individual_Home_Phone__c;
                        exstacclnk.Retail_Company_Other_Phone__c = acc.Work_Phone__c;
                        exstacclnk.Retail_Vat_No__c = acc.Vat_No__c;
                        exstacclnk.Retail_UCID__c = acc.UCID__c;
                    }
                    if(acc.Foundation_Date__c != null)
                    {
                        exstacclnk.Retail_Foundation_Month__c = String.ValueOf(acc.Foundation_Date__c.month())+String.valueOf(acc.Foundation_Date__c.year());
                    }
                    
                    exstacclnk.Retail_Fax__c = acc.Fax;
                    exstacclnk.Retail_Industry__c = acc.Industry;
                    
                    /*if(corelationID != null && corelationID != '')
                    {
                        exstacclnk.CorrelationID__c = corelationID;
                    }*/
                    if(acc.MD__c == Label.MarketKR)
                    {
                        exstacclnk.Retail_Country__c = 'Korea';   
                    }
                    else if(acc.MD__c == Label.MarketJP)
                    {
                        exstacclnk.Retail_Country__c = 'Japan';
                    }
                    if(acc.Primary_Address_Reference__c != null)
                    {
                        exstacclnk.Retail_Address_Type__c = (acc.Primary_Address_Reference__r.Address_Type__c!=null ?acc.Primary_Address_Reference__r.Address_Type__c : '' );
                        exstacclnk.Retail_Address_Line_1__c = (acc.Primary_Address_Reference__r.Address_Line_1__c != null ? acc.Primary_Address_Reference__r.Address_Line_1__c: '' ).left(17);
                        exstacclnk.Retail_Address_Line_2__c  = (acc.Primary_Address_Reference__r.Address_Line_2__c!= null ? acc.Primary_Address_Reference__r.Address_Line_2__c : '' ).left(17);
                        exstacclnk.Retail_ZipCode__c= (acc.Primary_Address_Reference__r.ZipCode__c!=null ? acc.Primary_Address_Reference__r.ZipCode__c : '');
                        exstacclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acc.Primary_Address_Reference__r.CreatedDate);
                        exstacclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(acc.Primary_Address_Reference__r.LastModifiedDate);
                        if(addtrmap1.containsKey(exstacclnk.Retail_Address_Reference__r.Province__c) )
                        {
                            province = addtrmap1.get(exstacclnk.Retail_Address_Reference__r.Province__c);
                        } 
                        exstacclnk.Retail_Province__c = province ;
                        if(province ==null && province == '')
                        {
                            exstacclnk.Retail_Province__c =exstacclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue); 
                        }
                        exstacclnk.Retail_City__c = (acc.Primary_Address_Reference__r.City__c != null ? acc.Primary_Address_Reference__r.City__c : '').left(17);
                        exstacclnk.Retail_Distinct__c = ((acc.Primary_Address_Reference__r.District__c != null ? acc.Primary_Address_Reference__r.District__c : '') + ' ' + (acc.Primary_Address_Reference__r.Block__c != null ? acc.Primary_Address_Reference__r.Block__c : '' )).left(17);
                    }
                    accLinkList.add(exstacclnk);
                }
            }
            else
            {
                if(acc.RecordTypeId == PersonRecordTypeId)
                {
                    acclnk.RecordTypeId = AccountLink_RetailPersonRecordTypeId;
                    acclnk.fromRole__c = acc.owner.Contact.AccountId; 
                    acclnk.toRole__c = acc.Id;                                                                         
                    acclnk.Retail_Full_Name__c = ((acc.LastName!=null ? acc.LastName : '') + '  ' + (acc.FirstName != null ? acc.FirstName : '')).left(25);
                    acclnk.Retail_PersonBirthdate__c = acc.PersonBirthdate;
                    acclnk.Retail_Special_Care__c = acc.Special_Care__c;
                    acclnk.Retail_Individual_Home_Phone__c = acc.Individual_Home_Phone__c;
                    acclnk.Retail_Work_Phone__c = acc.Work_Phone__c;
                    acclnk.Retail_Mobile__c = acc.Mobile__c;
                    acclnk.Retail_Email__c = acc.Email__c;                                                                      
                    acclnk.Retail_Gender__c = acc.Gender__c;
                    acclnk.Retail_Occupation__c = acc.Occupation__c;
                    acclnk.Retail_Preferred_Language__c = acc.Preferred_Language__c;
                    acclnk.Retail_Preferred_Contact_Method__c = acc.Preferred_Contact_Method__c;
                    acclnk.Retail_Special_Needs_Class__c = acc.Special_Needs_Class__c;
                    acclnk.Retail_Allow_Data_Sharing__c = acc.Allow_Data_Sharing2__c;
                    acclnk.Retail_Full_Name_Native__c = ((acc.LastName_Native_1__c != null ? acc.LastName_Native_1__c: '') + ' ' + (acc.FirstName_Native_1__c != null ?acc.FirstName_Native_1__c :'' )).left(50);
                    acclnk.Retail_LastName__c = acc.LastName;
                    acclnk.Retail_FirstName__c = acc.FirstName; 
                    acclnk.Retail_Full_Name_Title__c = ((acc.LastName!=null ? acc.LastName : '') + '  ' + (acc.FirstName != null ? acc.FirstName : ''));//+ '  ' + (acc.FirstName!= null ? acc.FirstName : '')
                    acclnk.Retail_LastName_Native__c = acc.LastName_Native_1__c;
                    acclnk.Retail_FirstName_Native__c = acc.FirstName_Native_1__c;
                    acclnk.Retail_UCID__c = acc.UCID__c;
                }
                else if(acc.RecordTypeId == AccountCompanyId)
                {
                    acclnk.RecordTypeId = AccountLink_RetailCompanyRecordTypeId;
                    acclnk.fromRole__c = acc.owner.Contact.AccountId;
                    acclnk.toRole__c = acc.Id;          
                    acclnk.Retail_Company_Name__c = acc.Name;
                    acclnk.Retail_Company_Name_Native1__c = acc.Company_Name_Native_1__c; 
                    acclnk.Retail_Commercial_Reg_No__c = acc.Commercial_Reg_No__c;
                    acclnk.Retail_Website__c = acc.website;
                    acclnk.Retail_Company_Phone__c = acc.Individual_Home_Phone__c;
                    acclnk.Retail_Company_Other_Phone__c = acc.Work_Phone__c;
                    acclnk.Retail_Vat_No__c = acc.Vat_No__c;
                    acclnk.Retail_UCID__c = acc.UCID__c;
                }
                if(acc.Foundation_Date__c != null)
                {
                    acclnk.Retail_Foundation_Month__c = String.ValueOf(acc.Foundation_Date__c.month())+String.valueOf(acc.Foundation_Date__c.year());
                }
                
                acclnk.Retail_Fax__c = acc.Fax;
                acclnk.Retail_Industry__c = acc.Industry;
                
                /*if(corelationID != null && corelationID != '')
                {
                    acclnk.CorrelationID__c = corelationID;
                }*/
                if(acc.MD__c == Label.MarketKR)
                {
                    acclnk.Retail_Country__c = 'Korea';   
                }
                else if(acc.MD__c == Label.MarketJP)
                {
                    acclnk.Retail_Country__c = 'Japan';
                }
                if(acc.Primary_Address_Reference__c != null)
                {
                    acclnk.Retail_Address_Type__c = (acc.Primary_Address_Reference__r.Address_Type__c!=null ?acc.Primary_Address_Reference__r.Address_Type__c : '' );
                    acclnk.Retail_Address_Line_1__c = (acc.Primary_Address_Reference__r.Address_Line_1__c != null ? acc.Primary_Address_Reference__r.Address_Line_1__c: '' ).left(17);
                    acclnk.Retail_Address_Line_2__c  = (acc.Primary_Address_Reference__r.Address_Line_2__c!= null ? acc.Primary_Address_Reference__r.Address_Line_2__c : '' ).left(17);
                    acclnk.Retail_ZipCode__c= (acc.Primary_Address_Reference__r.ZipCode__c!=null ? acc.Primary_Address_Reference__r.ZipCode__c : '');
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(acc.Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(acc.Primary_Address_Reference__r.LastModifiedDate);
                    if(addtrmap1.containsKey(acclnk.Retail_Address_Reference__r.Province__c) )
                    {
                        province = addtrmap1.get(acclnk.Retail_Address_Reference__r.Province__c);
                    } 
                    acclnk.Retail_Province__c = province ; 
                    acclnk.Retail_Province__c  =acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                    acclnk.Retail_City__c = (acc.Primary_Address_Reference__r.City__c != null ? acc.Primary_Address_Reference__r.City__c : '').left(17);
                    acclnk.Retail_Distinct__c = ((acc.Primary_Address_Reference__r.District__c != null ? acc.Primary_Address_Reference__r.District__c : '') + ' ' + (acc.Primary_Address_Reference__r.Block__c != null ? acc.Primary_Address_Reference__r.Block__c : '' )).left(17);
                }
                accLinkList.add(acclnk);
            }
        }
        system.debug('accLinkList>>' + accLinkList);
        if(!accLinkList.isEmpty() && accLinkList != null)
        {
            upsert accLinkList;
        }
    }
}