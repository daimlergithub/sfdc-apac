/**  
* Class Name: StouchCompanyDetailsMY
* Description : This class is for 'MY' (Malaysia) Market Get Company details API for Stouch App called from StouchPersonDetails.
* Author : Narendra Nimmana
* Modification Log *
=============================================================== 
Ver         Date            Author              Modification --- ---- ------ -------------
V1.0        24/07/2018      Ashish Jadhav       Initial Release
=============================================================== 
* */ 
public class StouchCompanyDetailsMY {
    
    Public static Map<Id,User> users;
    
    public static Map<String,Object> getCompanyDetailsMY(String ucid,String fromDate,String toDate,Id retailCompanyId){
        Map<String,Object>  companyDetails=new Map<String,Object>();
        Account acc=new Account();
        For(Account Objacc:[select id,Ucid__c,Data_Source__c,RecordTypeId,RecordType.Name,Status__c,(select id,fromRole__c,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c, 
                           Retail_Related_Company__c,Retail_Company_Name__c,toRole__r.Company_Legal_Form__c,Retail_Commercial_Reg_No__c,
                           OwnerID,Retail_Email__c,Retail_Fax__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,
                           toRole__r.Name,Retail_Mobile__c,toRole__r.Dealer_Rollout_Status__c,Retail_Preferred_Language__c,
                           toRole__r.Hobby__c,Retail_Race__c,Retail_Ucid__c from Account_Links__r where recordtypeid=:retailCompanyId),
                            //AddressList
                           (Select Id, Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Address_Type__c, Language__c,Country__c,
                           Province__c, Sub_District__c,District__c, ZipCode__c,Name,Foreign_Nationals__c, Preferred__c FROM Addresses__r),
                           MBK_Data_Source__c,(select id,Name,CAC_Lead_Status__c,CAC_Lost_Reason__c,Company_Account__c,Contact__c,
                           CreatedById,CreatedDate,Current_Vehicle_1__c,Current_Vehicle_2__c,Customer_Type__c,
                           Dealer_Lead_status__c,Dealer_Lost_Reason__c,Description__c,Interested_Vehicle__c,Interested_Vehicle_Note__c,
                           Interested_Vehicle__r.Car_Model__c,
                           Interested_Vehicle__r.Car_Model__r.Brand__c,
                           Interested_Vehicle__r.Car_Model__r.Series__c,
                           Lead__c.Interested_Vehicle__r.Car_Model__r.Name,                    
                           LastModifiedById,LastModifiedDate,Lead_DataSource__c,Lead_Desired_Service__c,Lead_Type__c,Order_Placed_Date_Time__c,
                           Preferred_Contact_Method__c,Purchased_Vehicle__c,
                           Sales_Consultant__c,Visited_Showroom_Date_Time__c,Lead_Latest_Phase__c,Source_Campaign__c,
                           Lead_Priority__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                           Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                           Purchase_Time__c,OwnerId,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                           Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Trade_in_Vehicle_Text2__c,Visited_Showroom_Date__c,contact__r.ucid__c 
                           from Leads__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate)))
                           from Account where ucid__c=:ucid limit 1]){
                                acc=Objacc;
                           }        
        if(acc!=Null){
        companyDetails.put('Company__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Related_Company__c))?' ':acc.Account_Links__r[0].Retail_Related_Company__c);
        companyDetails.put('Company_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Name__c))?' ':acc.Account_Links__r[0].Retail_Company_Name__c);
        //companyDetails.put('Company_Legal_Form__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Company_Legal_Form__c))?' ':acc.Account_Links__r[0].toRole__r.Company_Legal_Form__c);
        companyDetails.put('Data_Source__c', String.ISBlank(acc.Data_Source__c)?' ':acc.Data_Source__c);
        companyDetails.put('CompanyOtherPhone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Other_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Other_Phone__c);
        //companyDetails.put('Commercial_Reg_No__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Commercial_Reg_No__c))?' ':acc.Account_Links__r[0].Retail_Commercial_Reg_No__c);
        companyDetails.put('Email_c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Email__c))?' ':acc.Account_Links__r[0].Retail_Email__c);
        companyDetails.put('Fax', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Fax__c))?' ':acc.Account_Links__r[0].Retail_Fax__c);
        companyDetails.put('HomePhone', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Phone__c);
        companyDetails.put('Work_Phone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Other_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Other_Phone__c);
        companyDetails.put('Account_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Name))?' ':acc.Account_Links__r[0].toRole__r.Name);
        companyDetails.put('CompanyMobile', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Mobile__c))?' ':acc.Account_Links__r[0].Retail_Mobile__c);
        companyDetails.put('RetailerID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c))?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
        companyDetails.put('Company_UCID__c',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Ucid__c))?' ':acc.Account_Links__r[0].Retail_Ucid__c);
        companyDetails.put('Commercial_Register_Number',  (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Commercial_Reg_No__c))?' ':acc.Account_Links__r[0].Retail_Commercial_Reg_No__c);
        companyDetails.put('Owner', ' ');
        companyDetails.put('CompanyDMSID',' ');
        //PersonalDMSID ??
        companyDetails.put('RecordType',  (String.ISBlank(acc.RecordTypeId))?' ':acc.RecordType.Name);
        companyDetails.put('Status',  (String.ISBlank(acc.Status__c))?' ':acc.Status__c);
        companyDetails.put('Preferred_Language',  (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Preferred_Language__c))?' ':acc.Account_Links__r[0].Retail_Preferred_Language__c);
        companyDetails.put('Lifestyle_Preference',  (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Hobby__c))?' ':acc.Account_Links__r[0].toRole__r.Hobby__c);
        companyDetails.put('Race',  (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Race__c))?' ':acc.Account_Links__r[0].Retail_Race__c);
        
        
        if(acc.Account_Links__r.size()!=0) {
            User usr=[select id,federationIdentifier,name from User where id=:acc.Account_Links__r[0].OwnerId];
            companyDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
            companyDetails.put('CompanyDMSID',(acc.Account_Links__r.isEmpty() ||String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c))?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
        }
        
        List<Object> leadList=new List<Object>();
        List<Id> userIds=new List<Id>();
        for(Lead__c leads:acc.Leads__r){
            userIds.add(leads.OwnerId);
        }
        Users=New Map<Id,user>([select id,FederationIdentifier,Lastname from User where id=:userIds]);
        Map<Id,List<Booking__c>>leadIdAndListOfBookingsMap = new Map<Id,List<Booking__c>>();
        for(Lead__c objLead :[Select Id,(Select Id,Name,
                                         Booking_ID__c,BookingDateTimeFrom__c,
                                         Booking_Status__c,CreatedDate,
                                         LastModifiedDate 
                                         FROM Booking_Histories1__r order by CreatedDate DESC) 
                              FROM Lead__c WHERE Id IN : acc.Leads__r]) {
                                  
                                  leadIdAndListOfBookingsMap.put(objLead.Id, objLead.Booking_Histories1__r);
                              }
        if(acc.Leads__r.size()==0){
            leadList.add(leadDetails(null,null));
        }
        
        for(Lead__c leads:acc.Leads__r){
            leadList.add(leadDetails(leads,leadIdAndListOfBookingsMap.get(leads.Id)));
        }        
        companyDetails.put('leadList', leadList);        
        
        //Address list
        List<Object> Address_List=new List<Object>();
        if(acc.Addresses__r.size()==0){
            Address_List.add(addressDetails(null));
        }
        for(Address__c addres:acc.Addresses__r){
            Address_List.add(addressDetails(addres));
        }
        companyDetails.put('Address_List', Address_List);
        system.debug(companyDetails);
    }
        return companyDetails;
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
        leadMaps.put('OwnerId', (leads==null || String.ISBlank(Users.get(leads.OwnerId).FederationIdentifier))?' ':Users.get(leads.OwnerId).FederationIdentifier);
        leadMaps.put('Sales_Consultant__c', (leads==null || String.ISBlank(leads.Sales_Consultant__c))?' ':leads.Sales_Consultant__c);
        leadMaps.put('UCID__c', (leads==null || String.ISBlank(leads.contact__r.ucid__c))?' ':leads.contact__r.ucid__c);
        leadMaps.put('corporateLead', leads==null ?'No':'Yes');
        
        //dealer 
        leadMaps.put('Dealer_GS_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GS_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GS_Code__c);
        leadMaps.put('Dealer_GC_Code__c', (leads==null || leads.Assigned_dealer__c == null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GC_Code__c))?' ':leads.Assigned_dealer__r.Dealer_GC_Code__c);
        leadMaps.put('Lead__c_id', (leads==null || String.ISBlank(leads.Id))?' ':leads.Id);
        
        //Bookings
        leadMaps.put('BookingID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_ID__c))?' ':bookings[0].Booking_ID__c);
        leadMaps.put('Booking_Status',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_Status__c))?' ':bookings[0].Booking_Status__c);
        leadMaps.put('Booking_Created_Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].CreatedDate)))?' ':(Object)bookings[0].CreatedDate);
        leadMaps.put('Booking_Updated_Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].LastModifiedDate)))?' ':(Object)bookings[0].LastModifiedDate);
        leadMaps.put('BookingSfdcID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Id))?' ':bookings[0].Id);
        
        //interested vehicle car model details
        leadMaps.put('Interested_Brand', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Brand__c))?' ':leads.Interested_Vehicle__r.Car_Model__r.Brand__c);
        leadMaps.put('Interested_Class', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Series__c))?' ':leads.Interested_Vehicle__r.Car_Model__r.Series__c);
        leadMaps.put('Interested_Vehicle_Model', (leads==null || leads.Interested_Vehicle__c == null || leads.Interested_Vehicle__r.Car_Model__c == null || String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Name))?' ':leads.Interested_Vehicle__r.Car_Model__r.Name);
        
        
        return leadMaps;
    }
    
    public static Map<String,Object> addressDetails(Address__c Addres){
        Map<String,Object> AddressMaps=new Map<String,Object>();
        AddressMaps.put('Address_Line_1__c', (Addres==null || String.ISBlank(Addres.Address_Line_1__c))?' ':Addres.Address_Line_1__c);
        AddressMaps.put('Address_Line_2__c', (Addres==null || String.ISBlank(Addres.Address_Line_2__c))?' ':Addres.Address_Line_2__c);
        AddressMaps.put('Address_Line_3__c', (Addres==null || String.ISBlank(Addres.Address_Line_3__c))?' ':Addres.Address_Line_3__c);
        AddressMaps.put('Address_Type__c', (Addres==null || String.ISBlank(Addres.Address_Type__c))?' ':Addres.Address_Type__c);
        AddressMaps.put('State', (Addres==null || String.ISBlank(Addres.Province__c))?' ':Addres.Province__c);
        AddressMaps.put('City', (Addres==null || String.ISBlank(Addres.District__c))?' ':Addres.District__c);
        AddressMaps.put('Zip_c', (Addres==null || String.ISBlank(Addres.ZipCode__c))?' ':Addres.ZipCode__c);
        AddressMaps.put('Preferred', (Addres==null )?' ':Addres.Preferred__c? 'Yes' : 'No');
        AddressMaps.put('Address_ID', (Addres==null || String.ISBlank(Addres.Name))?' ':Addres.Name);
        AddressMaps.put('Address_SfdcID', (Addres==null || String.ISBlank(Addres.Id))?' ':Addres.Id);
        return AddressMaps;
    }
    
}