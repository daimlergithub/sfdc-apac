/**  
* Class Name    : StouchPersonDetailsMY
* Created Date  : 18-Sept-2018
* Description   : This class is for 'MY' (Malaysia) Market Get Person details API for Stouch App called from StouchPersonDetails.
* Author        : Vinod Kumar G
* Modification Log *
===============================================================
Ver     Date            Author              Modification
=============================================================== 
* */
public class StouchPersonDetailsMY {
    Public static Map<Id,User> users;
    public static Map<String,Object> getPersonDetailsMY(String ucid,String fromDate,String toDate,Id retailPersonId){
        
        Map<String,Object> personDetails=new Map<String,Object>();
        Account acc=new Account();
        For(Account Objacc:[Select id,Data_Source__c,Hobby__c,Lastest_Consent_Date__c, Status__c,(select id,Retail_UCID__c,Retail_FirstName__c,Retail_LastName__c,Retail_ID_Number__c,Retail_ID_Type__c,
                   			Retail_Mobile__c,Retail_Email__c,Retail_PersonBirthdate__c,Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Company_Name__c,Retail_Related_Company__r.Retail_Company_Name__c,
                            fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_ID__c,Retail_Agreement__c,Retail_Updated_Consent_Date__c,Retail_Salutation__c,toRole__r.Dealer_Rollout_Status__c,
                            Retail_Fax__c,Retail_Preferred_Language__c,toRole__r.Hobby__c,Retail_Race__c,Retail_Gender__c,RecordType.Name from Account_Links__r where recordtypeid=:retailPersonId),
                            (select id,Name,Preferred__c,Address_Line_1__c,Address_Line_2__c,Address_Type__c,ZipCode__c,Address_Line_3__c,City__c,State__c,District__c,Province__c  from Addresses__r),
                            (select id,Name,CAC_Lead_Status__c,CAC_Lost_Reason__c,Company_Account__c,Contact__c,CreatedById,CreatedDate,Dealer_Lost_Reason__c,LastModifiedById,
                            LastModifiedDate,Lead_DataSource__c,Lead_Type__c,OwnerId,Sales_Consultant__c,contact__r.ucid__c,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,
                            Assigned_dealer__r.Dealer_GS_Code__c,Interested_Vehicle__r.Car_Model__c,Interested_Vehicle__r.Car_Model__r.Series__c,Interested_Vehicle__r.Car_Model__r.Brand__c,
                            Interested_Vehicle__r.Car_Model__r.Name from Lead_Contact__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) 
                            and Lost_CAC_Date_Time__c<=:date.valueOf(toDate))) from Account where ucid__c=:ucid limit 1]){
                            	acc=Objacc;                                                                                                            
                            }
        if(acc!=null){
            personDetails.put('Data_Source__c', String.ISBlank(acc.Data_Source__c)?' ':acc.Data_Source__c);
            personDetails.put('Latest_Consent_Date', String.ISBlank(String.valueOf(acc.Lastest_Consent_Date__c))?' ':(Object)acc.Lastest_Consent_Date__c);
            personDetails.put('Status',(String.ISBlank(acc.Status__c) ?' ':acc.Status__c));
            if(acc.Account_Links__r.size()!=0){
                personDetails.put('Personal_UCID__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_UCID__c))?' ':acc.Account_Links__r[0].Retail_UCID__c);
                personDetails.put('FirstName', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_FirstName__c))?' ':acc.Account_Links__r[0].Retail_FirstName__c);
                personDetails.put('LastName', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_LastName__c))?' ':acc.Account_Links__r[0].Retail_LastName__c);            
                personDetails.put('ID_Number__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_ID_Number__c))?' ':acc.Account_Links__r[0].Retail_ID_Number__c);
                personDetails.put('ID_Type__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_ID_Type__c))?' ':acc.Account_Links__r[0].Retail_ID_Type__c);
                personDetails.put('PersonMobilePhone', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Mobile__c))?' ':acc.Account_Links__r[0].Retail_Mobile__c);
                personDetails.put('PersonEmail', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Email__c))?' ':acc.Account_Links__r[0].Retail_Email__c);
                personDetails.put('PersonBirthdate', (acc.Account_Links__r.isEmpty() || String.ISBlank(String.valueof(acc.Account_Links__r[0].Retail_PersonBirthdate__c)))?' ':(Object)acc.Account_Links__r[0].Retail_PersonBirthdate__c);
                personDetails.put('PersonHomePhone', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Individual_Home_Phone__c))?' ':acc.Account_Links__r[0].Retail_Individual_Home_Phone__c);
                personDetails.put('Work_Phone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Work_Phone__c))?' ':acc.Account_Links__r[0].Retail_Work_Phone__c);
                personDetails.put('Company_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Name__c))?' ':acc.Account_Links__r[0].Retail_Company_Name__c);
                personDetails.put('RetailerID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c))?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
                personDetails.put('PersonalDMSID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_ID__c))?' ':acc.Account_Links__r[0].Retail_DMS_Customer_ID__c);
                personDetails.put('Company_UCID__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Ucid__c))?' ':acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Ucid__c);
                personDetails.put('Salesforce_Object', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Id))?' ':acc.Account_Links__r[0].Id);
                personDetails.put('Personal_Agreement', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Agreement__c))?' ':acc.Account_Links__r[0].Retail_Agreement__c);
                personDetails.put('Updated_Consent_Date', (acc.Account_Links__r.isEmpty() || String.ISBlank(String.valueOf(acc.Account_Links__r[0].Retail_Updated_Consent_Date__c)))?' ':(Object)acc.Account_Links__r[0].Retail_Updated_Consent_Date__c);
                personDetails.put('Title', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Salutation__c))?' ':acc.Account_Links__r[0].Retail_Salutation__c);
                personDetails.put('Fax', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Fax__c))?' ':acc.Account_Links__r[0].Retail_Fax__c);
                personDetails.put('Preferred_Language', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Preferred_Language__c))?' ':acc.Account_Links__r[0].Retail_Preferred_Language__c);
                personDetails.put('Lifestyle_Preference',  (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Hobby__c))?' ':acc.Account_Links__r[0].toRole__r.Hobby__c);
                personDetails.put('Race', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Race__c))?' ':acc.Account_Links__r[0].Retail_Race__c);
                personDetails.put('Gender', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Gender__c))?' ':acc.Account_Links__r[0].Retail_Gender__c);
                personDetails.put('RecordType', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].RecordType.Name))?' ':acc.Account_Links__r[0].RecordType.Name);
            }
            
            List<Object> leadList=new List<Object>();
            List<Id> userIds=new List<Id>();
            for(Lead__c leads:acc.Lead_Contact__r){
                userIds.add(leads.OwnerId);
            }
            Users=New Map<Id,user>([select id,FederationIdentifier,Lastname from User where id=:userIds]);
            Map<Id,List<Booking__c>>leadIdAndListOfBookingsMap = new Map<Id,List<Booking__c>>();
            for(Lead__c objLead :[Select Id,(Select Id,Name,
                                             Booking_ID__c,BookingDateTimeFrom__c ,
                                             Booking_Status__c,CreatedDate,
                                             LastModifiedDate 
                                             FROM Booking_Histories1__r order by CreatedDate DESC) 
                                  FROM Lead__c WHERE Id IN : acc.Lead_Contact__r]) {
                                      leadIdAndListOfBookingsMap.put(objLead.Id, objLead.Booking_Histories1__r);          
                                  }
            if(acc.Lead_Contact__r.size()==0){
                leadList.add(leadDetails(null,null));
            }
            for(Lead__c leads:acc.Lead_Contact__r){
                leadList.add(leadDetails(leads,leadIdAndListOfBookingsMap.get(leads.Id)));
            }
            personDetails.put('leadList', leadList);
            
            //Address list
            List<Object> Address_List=new List<Object>();
            if(acc.Addresses__r.size()==0){
                Address_List.add(addressDetails(null));
            }
            for(Address__c addres:acc.Addresses__r){
                Address_List.add(addressDetails(addres));
            }
            personDetails.put('Address_List', Address_List);
            system.debug(personDetails);
        }
        return personDetails;        
    }
    
    public static Map<String,Object> leadDetails(Lead__c leads,List<Booking__c> bookings){
        Map<String,Object> leadMaps=new Map<String,Object>();
        leadMaps.put('Id', (leads==null || String.ISBlank(leads.Id))?' ':leads.Id);
        leadMaps.put('leadNo', (leads==null || String.ISBlank(leads.Name))?' ':leads.Name);
        leadMaps.put('CAC_Lead_Status__c', (leads==null || String.ISBlank(leads.CAC_Lead_Status__c))?' ':leads.CAC_Lead_Status__c);
        leadMaps.put('CAC_Lost_Reason__c', (leads==null || String.ISBlank(leads.CAC_Lost_Reason__c))?' ':leads.CAC_Lost_Reason__c);
        leadMaps.put('Company_Account__c', (leads==null || String.ISBlank(leads.Company_Account__c))?' ':leads.Company_Account__c);
        leadMaps.put('Contact__c', (leads==null || String.ISBlank(leads.Contact__c))?' ':leads.Contact__c);
        leadMaps.put('CreatedById',(leads==null || String.ISBlank(leads.CreatedById))?' ':leads.CreatedById);
        //leadMaps.put('CreatedDate', (leads==null || String.ISBlank(String.valueOf(leads.CreatedDate)))?' ':(Object)leads.CreatedDate);
        leadMaps.put('CreatedDate',' ');
        if(leads!=null)
            leadMaps.put('CreatedDate', leads.CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'','GMT'));
        leadMaps.put('Dealer_Lost_Reason__c',(leads==null || String.ISBlank(leads.Dealer_Lost_Reason__c))?' ':leads.Dealer_Lost_Reason__c);
        leadMaps.put('LastModifiedById', (leads==null || String.ISBlank(leads.LastModifiedById))?' ':leads.LastModifiedById);
        leadMaps.put('LastModifiedDate',' ');
        if(leads!=null)
            leadMaps.put('LastModifiedDate', leads.LastModifiedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'','GMT'));
        leadMaps.put('Lead_DataSource__c', (leads==null || String.ISBlank(leads.Lead_DataSource__c))?' ':leads.Lead_DataSource__c);
        leadMaps.put('Lead_Type__c', (leads==null || String.ISBlank(leads.Lead_Type__c))?' ':leads.Lead_Type__c);
        leadMaps.put('Owner', (leads==null || String.ISBlank(users.get(leads.OwnerId).FederationIdentifier))?' ':users.get(leads.OwnerId).FederationIdentifier);
        leadMaps.put('UCID__c', (leads==null || String.ISBlank(leads.contact__r.ucid__c))?' ':leads.contact__r.ucid__c);
        leadMaps.put('Lead__c_id', (leads==null || String.ISBlank(leads.Id))?' ':leads.Id);
        leadMaps.put('corporateLead', (leads==null || String.ISBlank(leads.Company_Account__c))?'No':'Yes');
        
        //dealer 
        leadMaps.put('Dealer_GS_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GS_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GS_Code__c);
        leadMaps.put('Dealer_GC_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GC_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GC_Code__c);
        leadMaps.put('Sales_Consultant__c', (leads==null || String.ISBlank(leads.Sales_Consultant__c))?' ':leads.Sales_Consultant__c);
        
        leadMaps.put('BookingID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_ID__c))?' ':bookings[0].Booking_ID__c);
        leadMaps.put('Booking_Status',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_Status__c))?' ':bookings[0].Booking_Status__c);
        leadMaps.put('Booking_Created_Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].CreatedDate)))?' ':(Object)bookings[0].CreatedDate);
        leadMaps.put('Booking_Updated_Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].LastModifiedDate)))?' ':(Object)bookings[0].LastModifiedDate);
        leadMaps.put('BookingSfdcID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Id))?' ':bookings[0].Id);
                        
        //interested vehicle car model details
        leadMaps.put('Interested_brand', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Brand__c))?' ':leads.Interested_Vehicle__r.Car_Model__r.Brand__c);
        leadMaps.put('Interestedmodelclass', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Series__c))?' ':leads.Interested_Vehicle__r.Car_Model__r.Series__c);
        leadMaps.put('Interestedmodel', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Name))?' ':leads.Interested_Vehicle__r.Car_Model__r.Name);
                       
        return leadMaps;
        
    }
    public static Map<String,Object> addressDetails(Address__c Addres){
        Map<String,Object> AddressMaps=new Map<String,Object>();
        AddressMaps.put('Preferred', (Addres==null )?' ':Addres.Preferred__c? 'Yes' : 'No');
        AddressMaps.put('Address_Line_1__c', (Addres==null || String.ISBlank(Addres.Address_Line_1__c))?' ':Addres.Address_Line_1__c);
        AddressMaps.put('Address_Line_2__c', (Addres==null || String.ISBlank(Addres.Address_Line_2__c))?' ':Addres.Address_Line_2__c);
        AddressMaps.put('Address_Type__c', (Addres==null || String.ISBlank(Addres.Address_Type__c))?' ':Addres.Address_Type__c);
        AddressMaps.put('Zip_c', (Addres==null || String.ISBlank(Addres.ZipCode__c))?' ':Addres.ZipCode__c);
        AddressMaps.put('Address_Line_3__c', (Addres==null || String.ISBlank(Addres.Address_Line_3__c))?' ':Addres.Address_Line_3__c);
        AddressMaps.put('City', (Addres==null || String.ISBlank(Addres.District__c))?' ':Addres.District__c);
        AddressMaps.put('State', (Addres==null || String.ISBlank(Addres.Province__c))?' ':Addres.Province__c);
        AddressMaps.put('Address_ID', (Addres==null || String.ISBlank(Addres.Name))?' ':Addres.Name);
        AddressMaps.put('Address_SfdcID', (Addres==null || String.ISBlank(Addres.Id))?' ':Addres.Id);
        return AddressMaps;
    }
}