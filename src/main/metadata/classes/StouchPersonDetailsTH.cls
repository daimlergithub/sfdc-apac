/**  
* Class Name: StouchPersonDetailsTH
* Description : This class is for 'TH' (Thiland) Market Get Person details API for Stouch App called from StouchPersonDetails.
* Author : Narendra Nimmana
* Modification Log *
=============================================================== 
Ver     Date            Author              Modification --- ---- ------ -------------
C1.0    24/07/2018      Ashish Jadhav       Added the Fields to response:- Salesforce_Object : Account_Links__r.Id
                                                                           Language :Account_Link__c.Retail_Preferred_Language__c
                                                                           Foreign_Nationals : Address__c.Foreign_Nationals__c
                                                                           
C2.0    03/08/2018      Ashish Jadhav       Changes Related to Address : previously only one Address was sent now list of address will be sent                                                             
                                            Address_List
C2.1    16/08/2018      Ashish Jadhav       Added below fields 
                                            Booking :-
                                            BookingID : Booking_ID__c
                                            Booking Status : Booking_Status__c
                                            Booking Created Date : CreatedDate
                                            Booking Updated Date : LastModifiedDate
                                            BookingDateTimeFrom :BookingDateTimeFrom__c 
                                            Consent :- 
                                            Personal Agreement : Account_Link__c.Retail_Agreement__c
                                            Latest Consent Date : Account.Lastest_Consent_Date__c
                                            Updated Consent Date : Account_Link__c.Retail_Updated_Consent_Date__c
=============================================================== 
* */ 
public class StouchPersonDetailsTH {
    
    //public static final Id retailPersonId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    Public static Map<Id,User> users;
    
    public static Map<String,Object> getPersonDetailsTH(String ucid,String fromDate,String toDate,Id contactToContactRecordTypeId,Id retailPersonId){
        Map<String,Object> personDetails=new Map<String,Object>();        
        Account acc=[select id,Data_Source__c,Lastest_Consent_Date__c,(select id,Retail_UCID__c,Retail_FirstName__c,Retail_LastName__c,
                     Retail_ID_Number__c,Retail_ID_Type__c,Retail_Salutation__c,Retail_Full_Name__c,
                     //Retail copy level address details has been commented
                     /*Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_Address_Type__c,
                     Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_ZipCode__c,
                     */
                     Retail_Mobile__c,Retail_Email__c,Retail_Agreement__c,Retail_Updated_Consent_Date__c,
                     Retail_PersonBirthdate__c, Retail_Individual_Home_Phone__c,Retail_Work_Phone__c,Retail_Company_Name__c,
                     fromRole__c,OwnerId,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c,
                     Retail_Related_Company__r.Retail_Company_Name__c,
                     /*Retail_Address_Reference__c, 
                     Retail_Preferred_Language__c,Retail_Address_Reference__r.Foreign_Nationals__c,*/
                     Retail_Related_Company__r.Retail_Ucid__c from Account_Links__r where recordtypeid=:retailPersonId),
                     (select id,Name,CAC_Lead_Status__c,CAC_Lost_Reason__c,Company_Account__c,Contact__c,Dealer_Lead_status__c,Dealer_Lost_Reason__c,Source_Campaign__c,
                     CreatedById,CreatedDate,Current_Vehicle_1__c,Current_Vehicle_2__c,Description__c,Interested_Vehicle__c,
                     //Added below fields in query as per changes recommended bt FE team approved by Shini   BY:Ashish Jadhav date:20th July 2018.
                     Interested_Vehicle__r.Car_Model__c,
                     Interested_Vehicle__r.Car_Model__r.Series__c,
                     Interested_Vehicle__r.Car_Model__r.Brand__c,
                     Interested_Vehicle__r.Car_Model__r.Name,
                     LastModifiedById,LastModifiedDate,Lead_DataSource__c,Lead_Desired_Service__c,Lead_Type__c,Order_Placed_Date_Time__c,OwnerId,Preferred_Contact_Method__c,
                     Purchased_Vehicle__c,Sales_Consultant__c,Visited_Showroom_Date_Time__c,Lead_Latest_Phase__c,
                     Lead_Priority__c,Interested_Vehicle_Note__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                     Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                     Customer_Type__c,Purchase_Time__c,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                     Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Trade_in_Vehicle_Text2__c,contact__r.ucid__c from Lead_Contact__r 
                     where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate))),
                    //Address list
                    (Select Id, Address_Line_1__c,Address_Line_2__c,
                            Address_Type__c, Language__c,
                            Province__c, Sub_District__c,
                            District__c, ZipCode__c,Name,
                            Foreign_Nationals__c, Preferred__c  
                            FROM Addresses__r)
                     ,Agreement_Date_for_Marketing_Consent__c,Withdrawal_Date_for_Marketing_Consent__c,General_Personal_Info_Mandatory__c,
                     Person_Agree_Test_Driving_Optional__c,Person_Info_Custom_Service_Optional__c,Targeted_Advert_Info_Optional_STCCC__c,Gender__c
                     from Account where ucid__c=:ucid limit 1];
        
        //Account acc2=[select id,(select id,fromRole__r.Company_Name__c,fromRole__r.Ucid__c from Account_Links__r where RecordTypeid=:contactToContactRecordTypeId order by lastmodifieddate desc limit 1) from Account where ucid__c=:ucid limit 1];
        
        personDetails.put('Data_Source__c', String.ISBlank(acc.Data_Source__c)?' ':acc.Data_Source__c);
        personDetails.put('Latest Consent Date', String.ISBlank(String.valueOf(acc.Lastest_Consent_Date__c))?' ':(Object)acc.Lastest_Consent_Date__c);
        
        if(acc.Account_Links__r.size()!=0){            
            personDetails.put('Personal_UCID__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_UCID__c))?' ':acc.Account_Links__r[0].Retail_UCID__c);
            personDetails.put('FirstName', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_FirstName__c))?' ':acc.Account_Links__r[0].Retail_FirstName__c);
            personDetails.put('LastName', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_LastName__c))?' ':acc.Account_Links__r[0].Retail_LastName__c);            
            personDetails.put('ID_Number__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_ID_Number__c))?' ':acc.Account_Links__r[0].Retail_ID_Number__c);
            personDetails.put('ID_Type__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_ID_Type__c))?' ':acc.Account_Links__r[0].Retail_ID_Type__c);
            personDetails.put('Salutation', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Salutation__c))?' ':acc.Account_Links__r[0].Retail_Salutation__c);
            personDetails.put('Account_Name_c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Full_Name__c))?' ':acc.Account_Links__r[0].Retail_Full_Name__c);
            //Retail copy level address details has been commented 
            /*personDetails.put('Address_Line_1__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_1__c))?' ':acc.Account_Links__r[0].Retail_Address_Line_1__c);
            personDetails.put('Address_Line_2__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_2__c))?' ':acc.Account_Links__r[0].Retail_Address_Line_2__c);
            personDetails.put('Address_Type__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Type__c))?' ':acc.Account_Links__r[0].Retail_Address_Type__c);
            personDetails.put('MBTH_Province__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Province__c))?' ':acc.Account_Links__r[0].Retail_Province__c);
            personDetails.put('MBTH_SubDistrict__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_City__c))?' ':acc.Account_Links__r[0].Retail_City__c);
            personDetails.put('MBTH_District__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Distinct__c))?' ':acc.Account_Links__r[0].Retail_Distinct__c);
            personDetails.put('Zip_c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_ZipCode__c))?' ':acc.Account_Links__r[0].Retail_ZipCode__c);
            */
            personDetails.put('PersonMobilePhone', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Mobile__c))?' ':acc.Account_Links__r[0].Retail_Mobile__c);
            personDetails.put('PersonEmail', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Email__c))?' ':acc.Account_Links__r[0].Retail_Email__c);
            personDetails.put('PersonBirthdate', (acc.Account_Links__r.isEmpty() || String.ISBlank(String.valueof(acc.Account_Links__r[0].Retail_PersonBirthdate__c)))?' ':(Object)acc.Account_Links__r[0].Retail_PersonBirthdate__c);
            personDetails.put('PersonHomePhone', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Individual_Home_Phone__c))?' ':acc.Account_Links__r[0].Retail_Individual_Home_Phone__c.remove('-'));
            personDetails.put('Work_Phone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Work_Phone__c))?' ':acc.Account_Links__r[0].Retail_Work_Phone__c.remove('-'));
            //personDetails.put('Company_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Name__c))?' ':acc.Account_Links__r[0].Retail_Company_Name__c);
            personDetails.put('RetailerID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c))?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
            personDetails.put('PersonalDMSID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_ID__c))?' ':acc.Account_Links__r[0].Retail_DMS_Customer_ID__c);
            personDetails.put('Company_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Company_Name__c))?' ':acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Company_Name__c);
            personDetails.put('Company_UCID__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Ucid__c))?' ':acc.Account_Links__r[0].Retail_Related_Company__r.Retail_Ucid__c);
            personDetails.put('Salesforce_Object', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Id))?' ':acc.Account_Links__r[0].Id);
            personDetails.put('Personal Agreement', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Agreement__c))?' ':acc.Account_Links__r[0].Retail_Agreement__c);
            personDetails.put('Updated Consent Date', (acc.Account_Links__r.isEmpty() || String.ISBlank(String.valueOf(acc.Account_Links__r[0].Retail_Updated_Consent_Date__c)))?' ':(Object)acc.Account_Links__r[0].Retail_Updated_Consent_Date__c);
            //personDetails.put('Language', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Preferred_Language__c))?' ':acc.Account_Links__r[0].Retail_Preferred_Language__c);
            /*if(!acc.Account_Links__r.isEmpty() && !String.ISBlank(acc.Account_Links__r[0].Retail_Address_Reference__c)){
                personDetails.put('Foreign_Nationals', acc.Account_Links__r[0].Retail_Address_Reference__r.Foreign_Nationals__c == true ?'true':'false');
            }
            else{
                personDetails.put('Foreign_Nationals', ' ');
            }*/
                
        }
        
        
        personDetails.put('Owner', ' ');
        //personDetails.put('PersonalDMSID',' ');
        if(acc.Account_Links__r.size()!=0){
            User usr=[select id,federationIdentifier from User where id=:acc.Account_Links__r[0].OwnerId];
            personDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
            //personDetails.put('PersonalDMSID',String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c)?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
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
        leadMaps.put('Current_Vehicle_1__c',(leads==null || String.ISBlank(leads.Current_Vehicle_1__c))?' ':leads.Current_Vehicle_1__c);
        leadMaps.put('Current_Vehicle_2__c', (leads==null || String.ISBlank(leads.Current_Vehicle_2__c))?' ':leads.Current_Vehicle_2__c);
        leadMaps.put('Customer_Type__c', (leads==null || String.ISBlank(leads.Customer_Type__c))?' ':leads.Customer_Type__c);
        leadMaps.put('Dealer_Comments__c', (leads==null || String.ISBlank(leads.Dealer_Comments__c))?' ':leads.Dealer_Comments__c);
        leadMaps.put('Dealer_Lead_Status__c', (leads==null || String.ISBlank(leads.Dealer_Lead_Status__c))?' ':leads.Dealer_Lead_Status__c);
        leadMaps.put('Dealer_Lost_Reason__c',(leads==null || String.ISBlank(leads.Dealer_Lost_Reason__c))?' ':leads.Dealer_Lost_Reason__c);
        leadMaps.put('Description__c', (leads==null || String.ISBlank(leads.Description__c))?' ':leads.Description__c);
        leadMaps.put('Interested_Vehicle__c',(leads==null || String.ISBlank(leads.Interested_Vehicle__c))?' ':leads.Interested_Vehicle__c);
        leadMaps.put('Interested_Vehicle_Note__c', (leads==null || String.ISBlank(leads.Interested_Vehicle_Note__c))?' ':leads.Interested_Vehicle_Note__c);
        leadMaps.put('LastModifiedById', (leads==null || String.ISBlank(leads.LastModifiedById))?' ':leads.LastModifiedById);
        //leadMaps.put('LastModifiedDate', (leads==null || String.ISBlank(String.valueOf(leads.LastModifiedDate)))?' ':(Object)leads.LastModifiedDate);
        leadMaps.put('LastModifiedDate',' ');
        if(leads!=null)
            leadMaps.put('LastModifiedDate', leads.LastModifiedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'','GMT'));
        leadMaps.put('Lead_DataSource__c', (leads==null || String.ISBlank(leads.Lead_DataSource__c))?' ':leads.Lead_DataSource__c);
        leadMaps.put('Lead_Desired_Service__c', (leads==null || String.ISBlank(leads.Lead_Desired_Service__c))?' ':leads.Lead_Desired_Service__c);
        leadMaps.put('Lead_Type__c', (leads==null || String.ISBlank(leads.Lead_Type__c))?' ':leads.Lead_Type__c);
        //leadMaps.put('Order_Placed_Date_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Order_Placed_Date_Time__c)))?' ':(Object)leads.Order_Placed_Date_Time__c);
        leadMaps.put('Order_Placed_Date_Time__c',' ');
        if(leads!=null && leads.Order_Placed_Date_Time__c!=null)
            leadMaps.put('Order_Placed_Date_Time__c', leads.Order_Placed_Date_Time__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'','GMT'));
        //leadMaps.put('OwnerId', (leads==null || String.ISBlank(Users.get(leads.OwnerId).FederationIdentifier))?' ':Users.get(leads.OwnerId).FederationIdentifier);
        /*Added below fields as per change request by market.  Date: 18th july 2018 by Ashish Jadhav*/
        leadMaps.put('Owner', (leads==null || String.ISBlank(Users.get(leads.OwnerId).FederationIdentifier))?' ':Users.get(leads.OwnerId).FederationIdentifier);
        leadMaps.put('OwnerName', (leads==null || String.ISBlank(Users.get(leads.OwnerId).Lastname))?' ':Users.get(leads.OwnerId).Lastname);
        leadMaps.put('Lead__c_id', (leads==null || String.ISBlank(leads.Id))?' ':leads.Id);
        if(leads!=null && leads.Assigned_dealer__r !=null ) {
            leadMaps.put('Dealer_GC_Code__c', (leads==null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GC_Code__c)?' ':leads.Assigned_dealer__r.Dealer_GC_Code__c));
            leadMaps.put('Dealer_GS_Code__c', (leads==null || String.ISBlank(leads.Assigned_dealer__r.Dealer_GS_Code__c)?' ':leads.Assigned_dealer__r.Dealer_GS_Code__c));
        }
        leadMaps.put('Preferred_Contact_Date__c', (leads==null || String.ISBlank(leads.Preferred_Contact_Date__c))?' ':leads.Preferred_Contact_Date__c);
        leadMaps.put('Preferred_Contact_Method__c',(leads==null || String.ISBlank(leads.Preferred_Contact_Method__c))?' ':leads.Preferred_Contact_Method__c);
        leadMaps.put('Preferred_Contact_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Preferred_Contact_Time__c)))?' ':(Object)leads.Preferred_Contact_Time__c);
        leadMaps.put('Purchased_Vehicle__c',(leads==null || String.ISBlank(leads.Purchased_Vehicle__c))?' ':leads.Purchased_Vehicle__c);
        leadMaps.put('Sales_Consultant__c', (leads==null || String.ISBlank(leads.Sales_Consultant__c))?' ':leads.Sales_Consultant__c);
        leadMaps.put('UCID__c', (leads==null || String.ISBlank(leads.contact__r.ucid__c))?' ':leads.contact__r.ucid__c);
        leadMaps.put('Visited_Showroom_Date_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Visited_Showroom_Date_Time__c)))?' ':(Object)leads.Visited_Showroom_Date_Time__c);
        leadMaps.put('LeadLatestPhase', (leads==null || String.ISBlank(leads.Lead_Latest_Phase__c))?' ':leads.Lead_Latest_Phase__c);
        //Added below fields in query as per changes recommended bt FE team approved by Shini   BY:Ashish Jadhav date:20th July 2018
        
        if(leads!=null && leads.Interested_Vehicle__c !=null && leads.Interested_Vehicle__r.Car_Model__c != null) {
            leadMaps.put('Interested_brand',String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Brand__c)?' ':leads.Interested_Vehicle__r.Car_Model__r.Brand__c);
            leadMaps.put('Interestedmodelclass',String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Series__c)?' ':leads.Interested_Vehicle__r.Car_Model__r.Series__c);
            leadMaps.put('Interestedmodel',String.ISBlank(leads.Interested_Vehicle__r.Car_Model__r.Name)?' ':leads.Interested_Vehicle__r.Car_Model__r.Name);
        }
        else{
            leadMaps.put('Interested_brand',' ');
            leadMaps.put('Interestedmodelclass',' ');
            leadMaps.put('Interestedmodel',' ');
        }
        //Bookings
        leadMaps.put('BookingID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_ID__c))?' ':bookings[0].Booking_ID__c);
        leadMaps.put('Booking Status',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Booking_Status__c))?' ':bookings[0].Booking_Status__c);
        leadMaps.put('Booking Created Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].CreatedDate)))?' ':(Object)bookings[0].CreatedDate);
        leadMaps.put('Booking Updated Date',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].LastModifiedDate)))?' ':(Object)bookings[0].LastModifiedDate);
        leadMaps.put('BookingDateTimeFrom',(bookings == null || bookings.isEmpty() || String.ISBlank(String.valueOf(bookings[0].BookingDateTimeFrom__c )))?' ':(Object)bookings[0].BookingDateTimeFrom__c);
        leadMaps.put('BookingSfdcID',(bookings == null || bookings.isEmpty() || String.ISBlank(bookings[0].Id))?' ':bookings[0].Id);
        
        return leadMaps;
    }
    
    public static Map<String,Object> addressDetails(Address__c Addres){
        Map<String,Object> AddressMaps=new Map<String,Object>();
        AddressMaps.put('Address_Line_1__c', (Addres==null || String.ISBlank(Addres.Address_Line_1__c))?' ':Addres.Address_Line_1__c);
        AddressMaps.put('Address_Line_2__c', (Addres==null || String.ISBlank(Addres.Address_Line_2__c))?' ':Addres.Address_Line_2__c);
        AddressMaps.put('Address_Type__c', (Addres==null || String.ISBlank(Addres.Address_Type__c))?' ':Addres.Address_Type__c);
        AddressMaps.put('Language__c', (Addres==null || String.ISBlank(Addres.Language__c))?' ':Addres.Language__c);
        AddressMaps.put('MBTH_Province__c', (Addres==null || String.ISBlank(Addres.Province__c))?' ':Addres.Province__c);
        AddressMaps.put('MBTH_SubDistrict__c', (Addres==null || String.ISBlank(Addres.Sub_District__c))?' ':Addres.Sub_District__c);
        AddressMaps.put('MBTH_District__c', (Addres==null || String.ISBlank(Addres.District__c))?' ':Addres.District__c);
        AddressMaps.put('Zip_c', (Addres==null || String.ISBlank(Addres.ZipCode__c))?' ':Addres.ZipCode__c);
        AddressMaps.put('Foreign_Nationals', (Addres==null )?' ': Addres.Foreign_Nationals__c ? 'Yes' : 'No');
        AddressMaps.put('Preferred', (Addres==null )?' ':Addres.Preferred__c? 'Yes' : 'No');
        AddressMaps.put('Address_ID', (Addres==null || String.ISBlank(Addres.Name))?' ':Addres.Name);
        AddressMaps.put('Address_SfdcID', (Addres==null || String.ISBlank(Addres.Id))?' ':Addres.Id);
        return AddressMaps;
    }

}