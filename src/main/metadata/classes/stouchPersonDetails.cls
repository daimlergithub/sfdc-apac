@RestResource(urlMapping='/stouchPersonDetails/*')
global without sharing class stouchPersonDetails {
    public static final Id retailPersonId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static final Id contactToContactRecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    Public static Map<Id,User> users;
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
        leadMaps.put('Preferred_Contact_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Preferred_Contact_Time__c)))?' ':(Object)leads.Preferred_Contact_Time__c);
        leadMaps.put('Preferred_Contact_Date__c', (leads==null || String.ISBlank(leads.Preferred_Contact_Date__c))?' ':leads.Preferred_Contact_Date__c);
        leadMaps.put('Current_Vehicle_1_Text__c', (leads==null || String.ISBlank(leads.Current_Vehicle_1_Text__c))?' ':leads.Current_Vehicle_1_Text__c);
        leadMaps.put('Current_Vehicle_2_Text__c', (leads==null || String.ISBlank(leads.Current_Vehicle_2_Text__c))?' ':leads.Current_Vehicle_2_Text__c);
        leadMaps.put('Trade_in_Vehicle_Text2__c', (leads==null || String.ISBlank(leads.Trade_in_Vehicle_Text2__c))?' ':leads.Trade_in_Vehicle_Text2__c);
        leadMaps.put('Test_Drive_Date__c', (leads==null || String.ISBlank(String.valueOf(leads.Test_Drive_Date__c)))?' ':(Object)leads.Test_Drive_Date__c);
        leadMaps.put('Dealer_Comments__c', (leads==null || String.ISBlank(leads.Dealer_Comments__c))?' ':leads.Dealer_Comments__c);
        leadMaps.put('LastModifiedDate', (leads==null || String.ISBlank(String.valueOf(leads.LastModifiedDate)))?' ':(Object)leads.LastModifiedDate);
        leadMaps.put('Customer_Type__c',(leads==null || String.ISBlank(leads.Customer_Type__c))?' ':leads.Customer_Type__c);
        leadMaps.put('Purchase_Time__c',(leads==null || String.ISBlank(leads.Purchase_Time__c))?' ':leads.Purchase_Time__c);
        leadMaps.put('Owner', (leads==null || String.ISBlank(Users.get(leads.OwnerId).FederationIdentifier))?' ':Users.get(leads.OwnerId).FederationIdentifier);
        leadMaps.put('OwnerName', (leads==null || String.ISBlank(Users.get(leads.OwnerId).Lastname))?' ':Users.get(leads.OwnerId).Lastname);
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
        //Map<String,Object> data=(Map<String,Object>)cObjMap.get('In_Data');
        //Map<String,Object> data=(Map<String,Object>)obj[0];
        String ucid=(String)cObjMap.get('Personal_UCID__c');
        String fromDate=(String)cObjMap.get('fromDate');
        String toDate=(String)cObjMap.get('toDate');
        Map<String,Object> personDetails=new Map<String,Object>();
        Account acc=[select id,Ucid__c,LastName,Mobile__c,Email__c,PersonBirthdate,Individual_Home_Phone__c,
                     Work_Phone__c,(select id,Address_Line_1__c,City__c,Zipcode__c,Province__c,District__c,
                     Address_Line_2__c,Address_Type__c from Addresses__r order by LastModifiedDate limit 1), 
                     Personal_Information_Third_Party_Release__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,
                     Agreement_to_commit_info_processing__c,DMS_Retailer_ID__c,DMS_Customer_ID__c,
                     (select id,fromRole__c,OwnerId,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c from Account_Links__r where recordtypeid=:retailPersonId),
                     MBK_Data_Source__c,(select id,Name,Dealer_Lead_status__c,Lead_Type__c,Source_Campaign__c,
                     Lead_Priority__c,Interested_Vehicle_Note__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                     Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                     LastModifiedDate,Customer_Type__c,Purchase_Time__c,OwnerId,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                     Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Trade_in_Vehicle_Text2__c from Lead_Contact__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate))) 
                     from Account where ucid__c=:ucid limit 1];
        Account acc2=[select id,(select id,fromRole__r.Company_Name__c,fromRole__r.Ucid__c from Account_Links__r where RecordTypeid=:contactToContactRecordTypeId order by lastmodifieddate desc limit 1) from Account where ucid__c=:ucid limit 1];
        
        personDetails.put('Personal_UCID__c', String.ISBlank(acc.Ucid__c)?' ':acc.Ucid__c);
        personDetails.put('LastName', String.ISBlank(acc.LastName)?' ':acc.LastName);
        personDetails.put('PersonMobilePhone', String.ISBlank(acc.Mobile__c)?' ':acc.Mobile__c.remove('-'));
        personDetails.put('PersonEmail', String.ISBlank(acc.Email__c)?' ':acc.Email__c);
        personDetails.put('PersonBirthdate', String.ISBlank(String.valueof(acc.PersonBirthdate))?' ':(Object)acc.PersonBirthdate);
        personDetails.put('PersonHomePhone', String.ISBlank(acc.Individual_Home_Phone__c)?' ':acc.Individual_Home_Phone__c.remove('-'));
        personDetails.put('Work_Phone__c', String.ISBlank(acc.Work_Phone__c)?' ':acc.Work_Phone__c.remove('-'));
        personDetails.put('MBK_Data_Source__c', String.ISBlank(acc.MBK_Data_Source__c)?' ':acc.MBK_Data_Source__c);
        
        personDetails.put('PersonMailingPostalCode', ' ');
        personDetails.put('PersonMailingState', ' ');
        personDetails.put('PersonMailingCity', ' ');
        personDetails.put('PersonMailingAddress', ' ');
        personDetails.put('Town', ' ');
        personDetails.put('Address_Type__c', ' ');
        personDetails.put('PersonMailingAddressline2', ' ');
        if(acc.Addresses__r.size()!=0){
            personDetails.put('PersonMailingPostalCode', String.ISBlank(acc.Addresses__r[0].Zipcode__c)?' ':acc.Addresses__r[0].Zipcode__c);
            personDetails.put('PersonMailingState', String.ISBlank(acc.Addresses__r[0].Province__c)?' ':acc.Addresses__r[0].Province__c);
            personDetails.put('PersonMailingCity', String.ISBlank(acc.Addresses__r[0].City__c)?' ':acc.Addresses__r[0].City__c);
            personDetails.put('PersonMailingAddress', String.ISBlank(acc.Addresses__r[0].Address_Line_1__c)?' ':acc.Addresses__r[0].Address_Line_1__c);
            personDetails.put('Town', String.ISBlank(acc.Addresses__r[0].District__c)?' ':acc.Addresses__r[0].District__c);
            personDetails.put('Address_Type__c', String.ISBlank(acc.Addresses__r[0].Address_Type__c)?' ':acc.Addresses__r[0].Address_Type__c);
            personDetails.put('PersonMailingAddressline2', String.ISBlank(acc.Addresses__r[0].Address_Line_2__c)?' ':acc.Addresses__r[0].Address_Line_2__c);
        }
        personDetails.put('Personal_Information_Third_Party_Release__c',String.ISBlank(acc.Personal_Information_Third_Party_Release__c)?' ':acc.Personal_Information_Third_Party_Release__c);
        personDetails.put('Personal_Agreement__c', String.ISBlank(acc.Personal_Agreement__c)?' ':acc.Personal_Agreement__c);
        personDetails.put('Personal_Abroad_Agreement__c', String.ISBlank(acc.Personal_Abroad_Agreement__c)?' ':acc.Personal_Abroad_Agreement__c);
        personDetails.put('Personal_Agreement_commit__c', String.ISBlank(acc.Agreement_to_commit_info_processing__c)?' ':acc.Agreement_to_commit_info_processing__c);
        
        personDetails.put('Owner', ' ');
        personDetails.put('RetailerID',' ');
        personDetails.put('PersonalDMSID',' ');
        personDetails.put('Salesforce_Object', ' ');
        if(acc.Account_Links__r.size()!=0){
            User usr=[select id,federationIdentifier from User where id=:acc.Account_Links__r[0].OwnerId];
            personDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
        	personDetails.put('RetailerID',String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c)?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
        	personDetails.put('PersonalDMSID',String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c)?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
            personDetails.put('Salesforce_Object', String.ISBlank(acc.Account_Links__r[0].Id)?' ':acc.Account_Links__r[0].Id);
        }
        
        personDetails.put('CompanyName__c', ' ');
        personDetails.put('Company_UCID__c', ' ');
        system.debug('acc.Account_Links1__r.size()'+acc2.Account_Links__r.size());
        if(acc2.Account_Links__r.size()!=0){
            personDetails.put('CompanyName__c', String.ISBlank(acc2.Account_Links__r[0].fromRole__r.Company_Name__c)?' ':acc2.Account_Links__r[0].fromRole__r.Company_Name__c);
        	personDetails.put('Company_UCID__c', String.ISBlank(acc2.Account_Links__r[0].fromRole__r.Ucid__c)?' ':acc2.Account_Links__r[0].fromRole__r.Ucid__c);
        }
        
        List<Object> leadList=new List<Object>();
        List<Id> userIds=new List<Id>();
        for(Lead__c leads:acc.Lead_Contact__r){
            userIds.add(leads.OwnerId);
        }
        Users=New Map<Id,user>([select id,FederationIdentifier,Lastname from User where id=:userIds]);
        if(acc.Lead_Contact__r.size()==0){
            leadList.add(leadDetails(null));
        }
        for(Lead__c leads:acc.Lead_Contact__r){
            leadList.add(leadDetails(leads));
        }
        personDetails.put('leadList', leadList);
        system.debug(personDetails);
        stouchPersonDetailsClass spdc= new stouchPersonDetailsClass();
        spdc.customerDetails=personDetails;
        return spdc;
    }
}