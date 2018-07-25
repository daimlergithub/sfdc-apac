public class StouchCompanyDetailsTH {
    
    Public static Map<Id,User> users;
    
    public static Map<String,Object> getCompanyDetailsTH(String ucid,String fromDate,String toDate,Id retailCompanyId){
        system.debug('#####'+retailCompanyId);
        system.debug('#####ucid'+ucid);
        Map<String,Object>  companyDetails=new Map<String,Object>();
        Account acc=[select id,Ucid__c,Data_Source__c,(select id,fromRole__c,fromRole__r.DMS_Retailer_ID__c,Retail_DMS_Customer_Id__c, 
                     Retail_Related_Company__c,Retail_Company_Name__c,toRole__r.Company_Legal_Form__c,Retail_Commercial_Reg_No__c,
                     OwnerID,Retail_Email__c,Retail_Fax__c,Retail_Company_Phone__c,Retail_Company_Other_Phone__c,
                     toRole__r.Name,Retail_Mobile__c,Retail_Address_Line_1__c,Retail_Address_Line_2__c,Retail_Address_Type__c,
                     Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_ZipCode__c,Retail_Ucid__c from Account_Links__r where recordtypeid=:retailCompanyId),
                     MBK_Data_Source__c,(select id,Name,CAC_Lead_Status__c,CAC_Lost_Reason__c,Company_Account__c,Contact__c,
                     CreatedById,CreatedDate,Current_Vehicle_1__c,Current_Vehicle_2__c,Customer_Type__c,
                     Dealer_Lead_status__c,Dealer_Lost_Reason__c,Description__c,Interested_Vehicle__c,Interested_Vehicle_Note__c,
                     LastModifiedById,LastModifiedDate,Lead_DataSource__c,Lead_Desired_Service__c,Lead_Type__c,Order_Placed_Date_Time__c,
                     Preferred_Contact_Method__c,Purchased_Vehicle__c,
                     Sales_Consultant__c,Visited_Showroom_Date_Time__c,Lead_Latest_Phase__c,Source_Campaign__c,
                     Lead_Priority__c,Re_visit__c,Preferred_Contact_Time__c,Preferred_Contact_Date__c,
                     Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Test_Drive_Date__c,Dealer_Comments__c,
                     Purchase_Time__c,OwnerId,Assigned_dealer__c,Assigned_dealer__r.Dealer_GC_Code__c,Assigned_dealer__r.Dealer_ND_Code__c,
                     Assigned_dealer__r.Dealer_GS_Code__c,MBK_Lead_DataSource__c,Trade_in_Vehicle_Text2__c,Visited_Showroom_Date__c,contact__r.ucid__c 
                     from Leads__r where CAC_Lead_Status__c != 'Lost(CAC)' or(Lost_CAC_Date_Time__c>=:date.valueOf(fromDate) and Lost_CAC_Date_Time__c<=:date.valueOf(toDate)))
                     from Account where ucid__c=:ucid limit 1];
        
        system.debug('@@@'+acc);
        //system.debug('@@@acc.Account_Links__r'+acc.Account_Links__r);
        companyDetails.put('Company__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Related_Company__c))?' ':acc.Account_Links__r[0].Retail_Related_Company__c);
        companyDetails.put('Company_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Name__c))?' ':acc.Account_Links__r[0].Retail_Company_Name__c);
        companyDetails.put('Company_Legal_Form__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Company_Legal_Form__c))?' ':acc.Account_Links__r[0].toRole__r.Company_Legal_Form__c);
        companyDetails.put('Data_Source__c', String.ISBlank(acc.Data_Source__c)?' ':acc.Data_Source__c);
        companyDetails.put('CompanyOtherPhone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Other_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Other_Phone__c);
        companyDetails.put('Commercial_Reg_No__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Commercial_Reg_No__c))?' ':acc.Account_Links__r[0].Retail_Commercial_Reg_No__c);
        companyDetails.put('Email__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Email__c))?' ':acc.Account_Links__r[0].Retail_Email__c);
        companyDetails.put('Fax', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Fax__c))?' ':acc.Account_Links__r[0].Retail_Fax__c);
        companyDetails.put('Individual_Home_Phone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Phone__c);
        companyDetails.put('Work_Phone__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Company_Other_Phone__c))?' ':acc.Account_Links__r[0].Retail_Company_Other_Phone__c);
        companyDetails.put('Account_Name__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].toRole__r.Name))?' ':acc.Account_Links__r[0].toRole__r.Name);
        companyDetails.put('Mobile__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Mobile__c))?' ':acc.Account_Links__r[0].Retail_Mobile__c);
        companyDetails.put('Address_Line_1__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_1__c))?' ':acc.Account_Links__r[0].Retail_Address_Line_1__c);
        companyDetails.put('Address_Line_2__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Line_2__c))?' ':acc.Account_Links__r[0].Retail_Address_Line_2__c);
        companyDetails.put('Address_Type__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Address_Type__c))?' ':acc.Account_Links__r[0].Retail_Address_Type__c);
        companyDetails.put('MBTH_Province__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Province__c))?' ':acc.Account_Links__r[0].Retail_Province__c);
        companyDetails.put('MBTH_SubDistrict__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_City__c))?' ':acc.Account_Links__r[0].Retail_City__c);
        companyDetails.put('MBTH_District__c', (acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Distinct__c))?' ':acc.Account_Links__r[0].Retail_Distinct__c);
        companyDetails.put('Zip_c', (acc.Account_Links__r.isEmpty() || String.ISBlank(String.valueof(acc.Account_Links__r[0].Retail_ZipCode__c)))?' ':(Object)acc.Account_Links__r[0].Retail_ZipCode__c);
        companyDetails.put('RetailerID',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c))?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
        companyDetails.put('Company_UCID__c',(acc.Account_Links__r.isEmpty() || String.ISBlank(acc.Account_Links__r[0].Retail_Ucid__c))?' ':acc.Account_Links__r[0].Retail_Ucid__c);
               
        companyDetails.put('Owner', ' ');
        //companyDetails.put('Retailer_ID',' ');
        companyDetails.put('CompanyDMSID',' ');
        if(acc.Account_Links__r.size()!=0){
            User usr=[select id,federationIdentifier,name from User where id=:acc.Account_Links__r[0].OwnerId];
            companyDetails.put('Owner', String.ISBlank(usr.federationIdentifier)?' ':usr.federationIdentifier);
            //companyDetails.put('OwnerName', String.ISBlank(usr.name)?' ':usr.name);
            //companyDetails.put('Retailer_ID',String.ISBlank(acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c)?' ':acc.Account_Links__r[0].fromRole__r.DMS_Retailer_ID__c);
            companyDetails.put('CompanyDMSID',(acc.Account_Links__r.isEmpty() ||String.ISBlank(acc.Account_Links__r[0].Retail_DMS_Customer_Id__c))?' ':acc.Account_Links__r[0].Retail_DMS_Customer_Id__c);
        }
        
        
        
        //companyDetails.put('CompanyMobile', String.ISBlank(acc.Mobile__c)?' ':acc.Mobile__c.remove('-'));
        //companyDetails.put('CompanyEmail', String.ISBlank(acc.Email__c)?' ':acc.Email__c);
        //companyDetails.put('Individual_Home_Phone__c', String.ISBlank(acc.Individual_Home_Phone__c)?' ':acc.Individual_Home_Phone__c.remove('-'));
        //companyDetails.put('Work_Phone__c', String.ISBlank(acc.Work_Phone__c)?' ':acc.Work_Phone__c.remove('-'));
        
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
        companyDetails.put('leadList', leadList);
        system.debug(companyDetails);        
        return companyDetails;
    }
    public static Map<String,Object> leadDetails(Lead__c leads){
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
        leadMaps.put('OwnerId', (leads==null || String.ISBlank(Users.get(leads.OwnerId).FederationIdentifier))?' ':Users.get(leads.OwnerId).FederationIdentifier);
        leadMaps.put('Preferred_Contact_Date__c', (leads==null || String.ISBlank(leads.Preferred_Contact_Date__c))?' ':leads.Preferred_Contact_Date__c);
        leadMaps.put('Preferred_Contact_Method__c',(leads==null || String.ISBlank(leads.Preferred_Contact_Method__c))?' ':leads.Preferred_Contact_Method__c);
        leadMaps.put('Preferred_Contact_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Preferred_Contact_Time__c)))?' ':(Object)leads.Preferred_Contact_Time__c);
        leadMaps.put('Purchased_Vehicle__c',(leads==null || String.ISBlank(leads.Purchased_Vehicle__c))?' ':leads.Purchased_Vehicle__c);
        leadMaps.put('Sales_Consultant__c', (leads==null || String.ISBlank(leads.Sales_Consultant__c))?' ':leads.Sales_Consultant__c);
        leadMaps.put('UCID__c', (leads==null || String.ISBlank(leads.contact__r.ucid__c))?' ':leads.contact__r.ucid__c);
        leadMaps.put('Visited_Showroom_Date_Time__c', (leads==null || String.ISBlank(String.valueOf(leads.Visited_Showroom_Date_Time__c)))?' ':(Object)leads.Visited_Showroom_Date_Time__c);
        leadMaps.put('LeadLatestPhase', (leads==null || String.ISBlank(leads.Lead_Latest_Phase__c))?' ':leads.Lead_Latest_Phase__c);
        return leadMaps;
    }
    
}