@RestResource(urlMapping='/stouchCompanyDetails/*')
global class stouchCompanyDetails {
	public static final Id retailCompanyId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    Public static Map<Id,User> users;
	global interface stouchPersonDetailsInterface {
    }

    private class stouchPersonDetailsClass implements stouchPersonDetailsInterface {
        public Object companyDetails;
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
        leadMaps.put('Visited_Showroom_Date__c', (leads==null || String.ISBlank(String.valueOf(leads.Visited_Showroom_Date__c)))?' ':(Object)leads.Visited_Showroom_Date__c);
        leadMaps.put('Dealer_Comments__c', (leads==null || String.ISBlank(leads.Dealer_Comments__c))?' ':leads.Dealer_Comments__c);
        leadMaps.put('LastModifiedDate',' ');
        if(leads!=null)
            leadMaps.put('LastModifiedDate', leads.LastModifiedDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT'));
        leadMaps.put('Customer_Type__c',(leads==null || String.ISBlank(leads.Customer_Type__c))?' ':leads.Customer_Type__c);
        leadMaps.put('Purchase_Time__c',(leads==null || String.ISBlank(leads.Purchase_Time__c))?' ':leads.Purchase_Time__c);
        leadMaps.put('DealerID', (leads==null || String.ISBlank(leads.Assigned_dealer__r.Dealer_ND_Code__c))?' ':leads.Assigned_dealer__r.Dealer_ND_Code__c);
        leadMaps.put('Dealer_GC_Code__c', (leads==null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GC_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GC_Code__c);
        leadMaps.put('Dealer_GS_Code__c', (leads==null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GS_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GS_Code__c);
        leadMaps.put('MBK_Lead_Data_Source', (leads==null || String.ISBlank(leads.MBK_Lead_DataSource__c))?' ':leads.MBK_Lead_DataSource__c);
        return leadMaps;
    }
    @HttpPost
    global static stouchPersonDetailsInterface getPersonDetails(){
        String jsonText = RestContext.request.requestBody.toString();
        Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(jsonText);
        String ucid=(String)cObjMap.get('Company_UCID__c');
        String fromDate=(String)cObjMap.get('fromDate');
        String toDate=(String)cObjMap.get('toDate');
        Map<String,Object> personDetails=new Map<String,Object>();
        Account acc=[select id,Ucid__c,LastName,Mobile__c,Email__c,PersonBirthdate,Individual_Home_Phone__c,
                     Work_Phone__c,(select id,Address_Line_1__c,City__c,Zipcode__c,Province__c,District__c,
                     Address_Line_2__c,Address_Type__c from Addresses__r order by LastModifiedDate limit 1), 
                     Personal_Information_Third_Party_Release__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,
                     Agreement_to_commit_info_processing__c,DMS_Retailer_ID__c,DMS_Customer_ID__c,
                     (select id,fromRole__c,OwnerId,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c from Account_Links__r where recordtypeid=:retailCompanyId),
                     MBK_Data_Source__c,(select id,Name,Dealer_Lead_status__c,Lead_Type__c,Source_Campaign__c,
                     Lead_Priority__c,Interested_Vehicle_Note__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                     Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                     LastModifiedDate,Customer_Type__c,Purchase_Time__c,OwnerId,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                     Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Trade_in_Vehicle_Text2__c,Visited_Showroom_Date__c from Leads__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate))),
                     Company__c,Company_Name__c,Company_Legal_Form__c,Commercial_Reg_No__c,Vat_No__c
                     from Account where ucid__c=:ucid limit 1];
        
        personDetails.put('Company__c', String.ISBlank(acc.Company__c)?' ':acc.Company__c);
        personDetails.put('Company_Name__c', String.ISBlank(acc.Company_Name__c)?' ':acc.Company_Name__c);
        personDetails.put('Company_Legal_Form__c', String.ISBlank(acc.Company_Legal_Form__c)?' ':acc.Company_Legal_Form__c);
        personDetails.put('MBK_Data_Source__c', String.ISBlank(acc.MBK_Data_Source__c)?' ':acc.MBK_Data_Source__c);
        personDetails.put('Commercial_Reg_No__c', String.ISBlank(acc.Commercial_Reg_No__c)?' ':acc.Commercial_Reg_No__c);
        personDetails.put('Vat_No__c', String.ISBlank(acc.Vat_No__c)?' ':acc.Vat_No__c);
        
        personDetails.put('CompanyPostCode', ' ');
        personDetails.put('CompanyMailingState', ' ');
        personDetails.put('CompanyMailingCity', ' ');
        personDetails.put('CompanyMailingAddress', ' ');
        personDetails.put('CompanyTown', ' ');
        personDetails.put('Address_Type__c', ' ');
        if(acc.Addresses__r.size()!=0){
            Map<String,String> prefectureValues=new Map<String,String>{'Hokkaido' =>'Incheon','Aomori' =>'Gyeongsangnam-do','Iwate' =>'Chungcheongnam-do','Akita' =>'Gyeonggi-do',
            														'Fukushima' =>'Busan','Ibaraki' =>'Jeollabuk-do','Gunma' =>'Sejong-si','Chiba' =>'Gyeongsangbuk-do',
            														'Ishikawa' =>'Jeju-do','Fukui' =>'Daegu','Gifu' =>'Seoul','Aichi' =>'Gangwon-do','Hyogo' =>'Jeollanam-do',
            														'Hiroshima' =>'Ulsan','Kagawa' =>'Chungcheongbuk-do','Ehime' =>'Gwangju','Fukuoka' =>'Daejeon'};
            personDetails.put('CompanyPostCode', String.ISBlank(acc.Addresses__r[0].Zipcode__c)?' ':acc.Addresses__r[0].Zipcode__c);
            personDetails.put('CompanyMailingState', String.ISBlank(acc.Addresses__r[0].Province__c)?' ':prefectureValues.get(acc.Addresses__r[0].Province__c));
            personDetails.put('CompanyMailingCity', String.ISBlank(acc.Addresses__r[0].City__c)?' ':acc.Addresses__r[0].City__c);
            personDetails.put('CompanyMailingAddress', String.ISBlank(acc.Addresses__r[0].Address_Line_1__c)?' ':acc.Addresses__r[0].Address_Line_1__c);
            personDetails.put('CompanyTown', String.ISBlank(acc.Addresses__r[0].District__c)?' ':acc.Addresses__r[0].District__c);
            personDetails.put('Address_Type__c', String.ISBlank(acc.Addresses__r[0].Address_Type__c)?' ':acc.Addresses__r[0].Address_Type__c);
        }
        personDetails.put('Company_UCID__c', String.ISBlank(acc.Ucid__c)?' ':acc.Ucid__c);
        
        personDetails.put('Owner', ' ');
        personDetails.put('Retailer_ID',' ');
        personDetails.put('CompanyDMSID',' ');
        if(acc.Account_Links__r.size()!=0){
            User usr=[select id,federationIdentifier from User where id=:acc.Account_Links__r[0].OwnerId];
            personDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
        	personDetails.put('Retailer_ID',String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c)?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
        	personDetails.put('CompanyDMSID',String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c)?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
        }
        
        personDetails.put('Personal_Information_Third_Party_Release__c',String.ISBlank(acc.Personal_Information_Third_Party_Release__c)?' ':acc.Personal_Information_Third_Party_Release__c);
        personDetails.put('Personal_Agreement__c', String.ISBlank(acc.Personal_Agreement__c)?' ':acc.Personal_Agreement__c);
        personDetails.put('Personal_Abroad_Agreement__c', String.ISBlank(acc.Personal_Abroad_Agreement__c)?' ':acc.Personal_Abroad_Agreement__c);
        personDetails.put('Personal_Agreement_commit__c', String.ISBlank(acc.Agreement_to_commit_info_processing__c)?' ':acc.Agreement_to_commit_info_processing__c);
        
        personDetails.put('CompanyMobile', String.ISBlank(acc.Mobile__c)?' ':acc.Mobile__c.remove('-'));
        personDetails.put('CompanyEmail', String.ISBlank(acc.Email__c)?' ':acc.Email__c);
        personDetails.put('Individual_Home_Phone__c', String.ISBlank(acc.Individual_Home_Phone__c)?' ':acc.Individual_Home_Phone__c.remove('-'));
        personDetails.put('Work_Phone__c', String.ISBlank(acc.Work_Phone__c)?' ':acc.Work_Phone__c.remove('-'));
        
        List<Object> leadList=new List<Object>();
        List<Id> userIds=new List<Id>();
        for(Lead__c leads:acc.Leads__r){
            userIds.add(leads.OwnerId);
        }
        Users=New Map<Id,user>([select id,FederationIdentifier,Lastname from User where id=:userIds]);
        if(acc.Leads__r.size()==0){
            leadList.add(leadDetails(null));
        }
        for(Lead__c leads:acc.Leads__r){
            leadList.add(leadDetails(leads));
        }
        personDetails.put('leadList', leadList);
        system.debug(personDetails);
        stouchPersonDetailsClass spdc= new stouchPersonDetailsClass();
        spdc.companyDetails=personDetails;
        return spdc;
    }
}