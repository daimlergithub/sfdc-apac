@RestResource(urlMapping='/stouchPersonDetails/*')
global without sharing class stouchPersonDetails {
    public static final Id retailPersonId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static final Id contactToContactRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    Public static Map<String,User> UserMap;
    global interface stouchPersonDetailsInterface {
    }

    private class stouchPersonDetailsClass implements stouchPersonDetailsInterface {
        public Object customerDetails;
    }
    public static Map<String,Object> leadDetails(Lead__c leads){
        Map<String,Object> leadMaps=new Map<String,Object>();
        leadMaps.put('leadNo', (leads==null || String.ISBlank(leads.Name))?' ':leads.Name);
        leadMaps.put('Dealer_Lead_status_c', (leads==null || String.ISBlank(leads.Dealer_Lead_status__c))?' ':leads.Dealer_Lead_status__c);
        leadMaps.put('Lead_Type_c',(leads==null || String.ISBlank(leads.Lead_Type__c))?' ':leads.Lead_Type__c);
        leadMaps.put('Lead__c_id', (leads==null || String.ISBlank(leads.Id))?' ':leads.Id);
        leadMaps.put('Source_Campaign__c',(leads==null || String.ISBlank(leads.Source_Campaign__c))?' ':leads.Source_Campaign__c);
        leadMaps.put('LeadPriority', (leads==null || String.ISBlank(leads.Lead_Priority__c))?' ':leads.Lead_Priority__c);
        leadMaps.put('Interested_Vehicle_Note__c', (leads==null || String.ISBlank(leads.Interested_Vehicle_Note__c))?' ':leads.Interested_Vehicle_Note__c);
        leadMaps.put('Re_visit__c', (leads==null || String.ISBlank(String.valueOf(leads.Re_visit__c)))?' ':(Object)leads.Re_visit__c);
        leadMaps.put('Preferred_Contact_Time__c',' ');
        if(leads!=null && leads.Preferred_Contact_Time__c!=null)
            leadMaps.put('Preferred_Contact_Time__c', leads.Preferred_Contact_Time__c.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT'));
        leadMaps.put('Preferred_Contact_Date__c', (leads==null || String.ISBlank(leads.Preferred_Contact_Date__c))?' ':leads.Preferred_Contact_Date__c);
        leadMaps.put('Current_Vehicle_1_Text__c', (leads==null || String.ISBlank(leads.Current_Vehicle_1_Text__c))?' ':leads.Current_Vehicle_1_Text__c);
        leadMaps.put('Current_Vehicle_2_Text__c', (leads==null || String.ISBlank(leads.Current_Vehicle_2_Text__c))?' ':leads.Current_Vehicle_2_Text__c);
        leadMaps.put('Trade_in_Vehicle_Text2__c', (leads==null || String.ISBlank(leads.Trade_in_Vehicle_Text2__c))?' ':leads.Trade_in_Vehicle_Text2__c);
        leadMaps.put('Test_Drive_Date__c', (leads==null || String.ISBlank(String.valueOf(leads.Test_Drive_Date__c)))?' ':(Object)leads.Test_Drive_Date__c);
        leadMaps.put('Dealer_Comments__c', (leads==null || String.ISBlank(leads.Dealer_Comments__c))?' ':leads.Dealer_Comments__c);
        leadMaps.put('LastModifiedDate',' ');
        if(leads!=null)
            leadMaps.put('LastModifiedDate', leads.LastModifiedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT'));
        leadMaps.put('Customer_Type__c',(leads==null || String.ISBlank(leads.Customer_Type__c))?' ':leads.Customer_Type__c);
        leadMaps.put('Purchase_Time__c',(leads==null || String.ISBlank(leads.Purchase_Time__c))?' ':leads.Purchase_Time__c);
        //leadMaps.put('Owner', (leads==null || String.ISBlank(UserMap.get(leads.OwnerId).FederationIdentifier))?' ':UserMap.get(leads.OwnerId).FederationIdentifier);
        //leadMaps.put('OwnerName', (leads==null || String.ISBlank(UserMap.get(leads.OwnerId).Lastname))?' ':UserMap.get(leads.OwnerId).Lastname);
        
        leadMaps.put('Owner',leads==null ? ' ':(leads.Owner.Type == 'User'? (( UserMap == null || UserMap.isEmpty() || !UserMap.containsKey(leads.OwnerId) || UserMap.get(leads.OwnerId).FederationIdentifier == null ) ? ' ': UserMap.get(leads.OwnerId).FederationIdentifier): ((leads.Assigned_dealer__c == null || leads.Assigned_dealer__r.Dealer_ND_Code__c == null || UserMap == null || UserMap.isEmpty() || !UserMap.containsKey(leads.Assigned_dealer__r.Dealer_ND_Code__c) || String.ISBlank(UserMap.get(leads.Assigned_dealer__r.Dealer_ND_Code__c).FederationIdentifier))? ' ': UserMap.get(leads.Assigned_dealer__r.Dealer_ND_Code__c).FederationIdentifier)));
        leadMaps.put('OwnerName',leads==null ? ' ':(leads.Owner.Type == 'User'? ((UserMap == null || UserMap.isEmpty() || !UserMap.containsKey(leads.OwnerId) || String.ISBlank(UserMap.get(leads.OwnerId).Lastname)) ? ' ': UserMap.get(leads.OwnerId).Lastname): ((leads.Assigned_dealer__c == null || leads.Assigned_dealer__r.Dealer_ND_Code__c == null || UserMap == null || UserMap.isEmpty() || !UserMap.containsKey(leads.Assigned_dealer__r.Dealer_ND_Code__c) || String.ISBlank(UserMap.get(leads.Assigned_dealer__r.Dealer_ND_Code__c).Lastname))? ' ': UserMap.get(leads.Assigned_dealer__r.Dealer_ND_Code__c).Lastname)));
        leadMaps.put('DealerID', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_ND_Code__c))?' ':leads.Assigned_dealer__r.Dealer_ND_Code__c);
        leadMaps.put('Dealer_GC_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GC_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GC_Code__c);
        leadMaps.put('Dealer_GS_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GS_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GS_Code__c);
        leadMaps.put('MBK_Lead_Data_Source', (leads==null || String.ISBlank(leads.MBK_Lead_DataSource__c))?' ':leads.MBK_Lead_DataSource__c);
        leadMaps.put('corporateLead', (leads==null || String.ISBlank(leads.Company_Account__c))?'No':'Yes');
        leadMaps.put('Lost_Reason', (leads==null || String.ISBlank(leads.Dealer_Lost_Reason__c))?' ':leads.Dealer_Lost_Reason__c);
        return leadMaps;
    }
    @HttpPost
    global static stouchPersonDetailsInterface getPersonDetails(){
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        //Map<String,Object> data=(Map<String,Object>)cObjMap.get('In_Data');
        //Map<String,Object> data=(Map<String,Object>)obj[0];
        String ucid=(String)cObjMap.get('Personal_UCID__c');
        String fromDate=(String)cObjMap.get('fromDate');
        String toDate=(String)cObjMap.get('toDate');
        String market=(String)cObjMap.get('MD__c');
        Map<String,Object> personDetails=new Map<String,Object>();
        if(String.isBlank(market)){
        Account acc=[select id,Ucid__c,LastName,Mobile__c,Email__c,PersonBirthdate,Individual_Home_Phone__c,
                     Work_Phone__c,(select id,Address_Line_1__c,City__c,Zipcode__c,Province__c,District__c,
                     Address_Line_2__c,Address_Type__c from Addresses__r order by LastModifiedDate limit 1), DMS_Retailer_ID__c,DMS_Customer_ID__c,
                     (select id,fromRole__c,OwnerId,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c,retail_mobile__c,Retail_Individual_Home_Phone__c,
                     Retail_Work_Phone__c,retail_email__c,Retail_LastName__c,Retail_ZipCode__c,Retail_Province__c,Retail_City__c,
                     Retail_Address_Line_1__c,Retail_Distinct__c,Retail_Address_Line_2__c from Account_Links__r where recordtypeid=:retailPersonId),
                     MBK_Data_Source__c,(select id,Name,Dealer_Lead_status__c,Lead_Type__c,Source_Campaign__c,
                     Lead_Priority__c,Interested_Vehicle_Note__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                     Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                     LastModifiedDate,Customer_Type__c,Purchase_Time__c,OwnerId,Owner.Type,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                     Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Dealer_Lost_Reason__c,Trade_in_Vehicle_Text2__c,Company_Account__c from Lead_Contact__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate))) 
                     ,Agreement_Date_for_Marketing_Consent__c,Withdrawal_Date_for_Marketing_Consent__c,General_Personal_Info_Mandatory__c,
                     Person_Agree_Test_Driving_Optional__c,Person_Info_Custom_Service_Optional__c,Targeted_Advert_Info_Optional_STCCC__c,Gender__c,
                     General_Personal_Information_Mandatory__c,General_Personal_Information_Optional__c,Unique_Identification_Info_Mandatory__c,
                     General_Personal_InfoThirdParty_Optional__c,Unique_Identity_Info_ThirdParty_Optional__c,Targeted_Advertising_Info_Optional__c
                     from Account where ucid__c=:ucid limit 1];
        Account acc2=[select id,(select id,fromRole__r.Company_Name__c,fromRole__r.Ucid__c from Account_Links__r where RecordTypeid=:contactToContactRecordTypeId order by lastmodifieddate desc limit 1) from Account where ucid__c=:ucid limit 1];
        
        personDetails.put('Personal_UCID__c', String.ISBlank(acc.Ucid__c)?' ':acc.Ucid__c);
        //personDetails.put('LastName', String.ISBlank(acc.LastName)?' ':acc.Retail_LastName__c);
        //personDetails.put('PersonMobilePhone', String.ISBlank(acc.Mobile__c)?' ':acc.Mobile__c);
        //personDetails.put('PersonEmail', String.ISBlank(acc.Email__c)?' ':acc.Email__c);
        personDetails.put('PersonBirthdate', String.ISBlank(String.valueof(acc.PersonBirthdate))?' ':(Object)acc.PersonBirthdate);
        //personDetails.put('PersonHomePhone', String.ISBlank(acc.Individual_Home_Phone__c)?' ':acc.Individual_Home_Phone__c);
        //personDetails.put('Work_Phone__c', String.ISBlank(acc.Work_Phone__c)?' ':acc.Work_Phone__c);
        personDetails.put('MBK_Data_Source__c', String.ISBlank(acc.MBK_Data_Source__c)?' ':acc.MBK_Data_Source__c);
        
        personDetails.put('Address_Type__c', ' ');
        if(acc.Addresses__r.size()!=0){
            personDetails.put('Address_Type__c', String.ISBlank(acc.Addresses__r[0].Address_Type__c)?' ':acc.Addresses__r[0].Address_Type__c);
        }
        //personDetails.put('Personal_Information_Third_Party_Release__c',String.ISBlank(acc.Personal_Information_Third_Party_Release__c)?' ':acc.Personal_Information_Third_Party_Release__c);
        //personDetails.put('Personal_Agreement__c', String.ISBlank(acc.Personal_Agreement__c)?' ':acc.Personal_Agreement__c);
        //personDetails.put('Personal_Abroad_Agreement__c', String.ISBlank(acc.Personal_Abroad_Agreement__c)?' ':acc.Personal_Abroad_Agreement__c);
        //personDetails.put('Personal_Agreement_commit__c', String.ISBlank(acc.Agreement_to_commit_info_processing__c)?' ':acc.Agreement_to_commit_info_processing__c);
        personDetails.put('Agreement_Date_for_Marketing_Consent__c',acc.Agreement_Date_for_Marketing_Consent__c==null?' ':string.valueOf(acc.Agreement_Date_for_Marketing_Consent__c));
        personDetails.put('Withdrawal_Date_for_Marketing_Consent__c',acc.Withdrawal_Date_for_Marketing_Consent__c==null?' ':string.valueOf(acc.Withdrawal_Date_for_Marketing_Consent__c));
        personDetails.put('General_Personal_Info_Mandatory__c',String.ISBlank(acc.General_Personal_Info_Mandatory__c)?' ':acc.General_Personal_Info_Mandatory__c);
        personDetails.put('Person_Agree_Test_Driving_Optional__c',String.ISBlank(acc.Person_Agree_Test_Driving_Optional__c)?' ':acc.Person_Agree_Test_Driving_Optional__c);
        personDetails.put('Person_Info_Custom_Service_Optional__c',String.ISBlank(acc.Person_Info_Custom_Service_Optional__c)?' ':acc.Person_Info_Custom_Service_Optional__c);
        personDetails.put('Targeted_Advert_Info_Optional_STCCC__c',String.ISBlank(acc.Targeted_Advert_Info_Optional_STCCC__c)?' ':acc.Targeted_Advert_Info_Optional_STCCC__c);
        personDetails.put('Gender__c',String.ISBlank(acc.Gender__c)?' ':acc.Gender__c);
        
        personDetails.put('General_Personal_Information_Mandatory__c',acc.General_Personal_Information_Mandatory__c==null?' ':string.valueOf(acc.General_Personal_Information_Mandatory__c));
        personDetails.put('General_Personal_Information_Optional__c',acc.General_Personal_Information_Optional__c==null?' ':string.valueOf(acc.General_Personal_Information_Optional__c));
        personDetails.put('Unique_Identification_Info_Mandatory__c',acc.Unique_Identification_Info_Mandatory__c==null?' ':string.valueOf(acc.Unique_Identification_Info_Mandatory__c));
        personDetails.put('General_Personal_InfoThirdParty_Optional__c',acc.General_Personal_InfoThirdParty_Optional__c==null?' ':string.valueOf(acc.General_Personal_InfoThirdParty_Optional__c));
        personDetails.put('Unique_Identity_Info_ThirdParty_Optional__c',acc.Unique_Identity_Info_ThirdParty_Optional__c==null?' ':string.valueOf(acc.Unique_Identity_Info_ThirdParty_Optional__c));
        personDetails.put('Targeted_Advertising_Info_Optional__c',acc.Targeted_Advertising_Info_Optional__c==null?' ':string.valueOf(acc.Targeted_Advertising_Info_Optional__c));
        
            
        personDetails.put('Owner', ' ');
        personDetails.put('RetailerID',' ');
        personDetails.put('PersonalDMSID',' ');
        personDetails.put('Salesforce_Object', ' ');
        personDetails.put('PersonMobilePhone', ' ');
        personDetails.put('PersonEmail', ' ');
        personDetails.put('PersonHomePhone', ' ');
        personDetails.put('Work_Phone__c', ' ');
        personDetails.put('LastName', ' ');
        personDetails.put('PersonMailingPostalCode', ' ');
        personDetails.put('PersonMailingState', ' ');
        personDetails.put('PersonMailingCity', ' ');
        personDetails.put('PersonMailingAddress', ' ');
        personDetails.put('Town', '');
        personDetails.put('PersonMailingAddressline2', ' ');
        if(acc.Account_Links__r.size()!=0){
            Map<String,String> prefectureValues=new Map<String,String>{'Hokkaido' =>'Incheon','Aomori' =>'Gyeongsangnam-do','Iwate' =>'Chungcheongnam-do','Akita' =>'Gyeonggi-do',
                                                                    'Fukushima' =>'Busan','Ibaraki' =>'Jeollabuk-do','Gunma' =>'Sejong-si','Chiba' =>'Gyeongsangbuk-do',
                                                                    'Ishikawa' =>'Jeju-do','Fukui' =>'Daegu','Gifu' =>'Seoul','Aichi' =>'Gangwon-do','Hyogo' =>'Jeollanam-do',
                                                                    'Hiroshima' =>'Ulsan','Kagawa' =>'Chungcheongbuk-do','Ehime' =>'Gwangju','Fukuoka' =>'Daejeon'};
            User usr=[select id,federationIdentifier from User where id=:acc.Account_Links__r[0].OwnerId];
            personDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
            personDetails.put('RetailerID',String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c)?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
            personDetails.put('PersonalDMSID',String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c)?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
            personDetails.put('Salesforce_Object', String.ISBlank(acc.Account_Links__r[0].Id)?' ':acc.Account_Links__r[0].Id);
            personDetails.put('PersonMobilePhone', String.ISBlank(acc.Account_Links__r[0].Retail_Mobile__c)?' ':acc.Account_Links__r[0].Retail_Mobile__c);
            personDetails.put('PersonEmail', String.ISBlank(acc.Account_Links__r[0].Retail_Email__c)?' ':acc.Account_Links__r[0].Retail_Email__c);
            personDetails.put('PersonHomePhone', String.ISBlank(acc.Account_Links__r[0].Retail_Individual_Home_Phone__c)?' ':acc.Account_Links__r[0].Retail_Individual_Home_Phone__c);
            personDetails.put('Work_Phone__c', String.ISBlank(acc.Account_Links__r[0].Retail_Work_Phone__c)?' ':acc.Account_Links__r[0].Retail_Work_Phone__c);
            personDetails.put('LastName', String.ISBlank(acc.Account_Links__r[0].Retail_LastName__c)?' ':acc.Account_Links__r[0].Retail_LastName__c);
            
            personDetails.put('PersonMailingPostalCode', String.ISBlank(acc.Account_Links__r[0].Retail_Zipcode__c)?' ':acc.Account_Links__r[0].Retail_Zipcode__c);
            personDetails.put('PersonMailingState', String.ISBlank(acc.Account_Links__r[0].Retail_Province__c)?' ':prefectureValues.get(acc.Account_Links__r[0].Retail_Province__c));
            personDetails.put('PersonMailingCity', String.ISBlank(acc.Account_Links__r[0].Retail_City__c)?' ':acc.Account_Links__r[0].Retail_City__c);
            personDetails.put('PersonMailingAddress', String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_1__c)?' ':acc.Account_Links__r[0].Retail_Address_Line_1__c);
            personDetails.put('Town', String.ISBlank(acc.Account_Links__r[0].Retail_Distinct__c)?' ':acc.Account_Links__r[0].Retail_Distinct__c);
            personDetails.put('PersonMailingAddressline2', String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_2__c)?' ':acc.Account_Links__r[0].Retail_Address_Line_2__c);
        }
        
        personDetails.put('CompanyName__c', ' ');
        personDetails.put('Company_UCID__c', ' ');
        system.debug('acc.Account_Links1__r.size()'+acc2.Account_Links__r.size());
        if(acc2.Account_Links__r.size()!=0){
            personDetails.put('CompanyName__c', String.ISBlank(acc2.Account_Links__r[0].fromRole__r.Company_Name__c)?' ':acc2.Account_Links__r[0].fromRole__r.Company_Name__c);
            personDetails.put('Company_UCID__c', String.ISBlank(acc2.Account_Links__r[0].fromRole__r.Ucid__c)?' ':acc2.Account_Links__r[0].fromRole__r.Ucid__c);
        }
        
        List<Object> leadList=new List<Object>();
        Set<String> userIds=new Set<String> ();
        for(Lead__c leads:acc.Lead_Contact__r){
            if(leads.Owner.Type == 'User'){
                userIds.add(leads.OwnerId);    
            }
            else if (leads.Assigned_dealer__c !=null && leads.Assigned_dealer__r.Dealer_ND_Code__c != null){
                userIds.add(leads.Assigned_dealer__r.Dealer_ND_Code__c);
            }    
        }
        
        system.debug('***userIds*****'+userIds);
        UserMap =New Map<String,User>();
        for (User usr : [select id,FederationIdentifier,Lastname,Dealer_ND_Code__c from User where id IN : userIds OR (Dealer_ND_Code__c IN: userIds AND contact.Dealer_Lead_Gate_Keeper__c = true)]){
            UserMap.put(usr.Id,usr);
            if(usr.Dealer_ND_Code__c != null)
                UserMap.put(usr.Dealer_ND_Code__c,usr);
        }
        system.debug('***UserMap*****'+UserMap);
        if(acc.Lead_Contact__r.size()==0){
            system.debug('***null***');
            leadList.add(leadDetails(null));
            
        }
        for(Lead__c leads:acc.Lead_Contact__r){
            system.debug('***NOT NULL***');
            leadList.add(leadDetails(leads));
        }
        personDetails.put('leadList', leadList);
        system.debug(personDetails);
            }
        else if(market=='TH'){
            personDetails=StouchPersonDetailsTH.getPersonDetailsTH(ucid,fromDate,toDate,contactToContactRecordTypeId,retailPersonId);
        }
        else if(market=='MY'){
            personDetails=StouchPersonDetailsMY.getPersonDetailsMY(ucid,fromDate,toDate,retailPersonId);
        }
        stouchPersonDetailsClass spdc= new stouchPersonDetailsClass();
        spdc.customerDetails=personDetails;
        return spdc;
    }
}