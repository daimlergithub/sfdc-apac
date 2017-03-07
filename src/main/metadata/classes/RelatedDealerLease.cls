public class RelatedDealerLease {
    public Retail_Task__c rettsk{set;get;}
 id recid=ApexPages.CurrentPage().getparameters().get('id');
   public Retail_Task__c retailtask=[select id,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c where id=:recid ];
   public string dealercode=retailtask.Related_Dealer__r.Dealer_GC_Code__c;
   public string supportdealercode=retailtask.Supporting_Dealer__r.Dealer_GC_Code__c;
   public List<Retail_Task__c> lstrettsk=[select id,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode ]; 
    public user currentuser=[select id,name,Dealer_GC_Code__c from user where id=:userinfo.getUserId() AND Market__c=:'JP'];
       Id profileId=userinfo.getProfileId();
      Profile currentuserprofile=[Select Id,Name from Profile where Id=:profileId];
       
    public List<profile> japanprofiles=[select id,UserLicense.Name,name from profile where UserLicense.Name=:'Partner Community'];
    
    public RelatedDealerLease(ApexPages.StandardController controller){
    
     
       Map<string,string> profilemap=new Map<string,string>();
        for(profile p:japanprofiles){
            profilemap.put(p.name,p.name);
        }
            
        if(profilemap.containsKey(currentuserprofile.name)){
            
           
           rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Phone1__c,Guarantor3_Address_Native__c,Guarantor1_ZipCode__c,Contractor_Name_Native__c,Delinquency__c,Branch_Name__c,Branch_Name_Native__c,Voluntary_Insurance_Premium_Dealer__c,Guarantor3_ZipCode__c,Guarantor3_Address__c,Guarantor3_Company_Name__c,Guarantor3_Company_Name_Native__c,Guarantor3_Fax__c,Guarantor3_BirthDate__c,Guarantor3_Gender__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor2_Phone__c,Guarantor3_Name__c,Guarantor3_Name_Native__c,Guarantor2_Gender__c,Guarantor2_Company_Name__c,Guarantor2_Company_Name_Native__c,Guarantor2_MobilePhone__c,Guarantor2_Fax__c,Guarantor2_BirthDate__c,Guarantor1_Fax__c,Guarantor1_Company_Name_Native__c,Guarantor2_Name__c,Guarantor1_Company_Name__c,Guarantor1_BirthDate__c,Guarantor1_Gender__c,Central_Customer_Number__c,Guarantor1_Name__c,Guarantor1_Name_Native__c,Guarantor1_Phone__c,Contractor_Company_Name__c,Contractor_Company_Established_Date__c,Number_Of_Employees__c,Occupation_Type__c,Annual_Income__c,Industry_Code__c,Family_Members_Others__c,Family_Members_Total__c,Family_Members_Children__c,Contractor_Marital_Status__c,Contractor_BirthDate__c,Contractor_Gender__c,Contractor_Fax3__c,Contractor_Mail__c,Contractor_Phone3__c,Contractor_MobilePhone3__c,Contractor_ZipCode2__c,Contractor_Address3__c,Contractor_Address3_Native__c,Contractor_ZipCode3__c,Contractor_Fax2__c,Contractor_MobilePhone2__c,Contractor_Address2__c,Contractor_Address2_Native__c,Contractor_Fax1__c,Contractor_MobilePhone1__c,Lease_Remaining_Balance_With_RV__c,Bank_Account_Type__c,Lease_Remaining_Balance_Without_RV__c,Bank_Account_Number__c,Guarantor1_Address__c,Guarantor1_Address_Native__c,Contractor_Address1__c,Guarantor1_MobilePhone__c,Bonus_Month1__c,Bank_Name__c,Bank_Account_Name__c,Branch_Code__c,Voluntary_Insurance_Premium__c,Indemnity_Amount__c,Guarantor2_ZipCode__c,Guarantor2_Address__c,Campaign_Description__c,Sales_Type__c,Monthly_Repayment__c,Bank_Code__c,Fine_Rate__c,Bonus_Amount2__c,Interest_Rate__c,Down_Payment__c,Balloon_RV_Amount__c,Contact_Date__c,Monthly_Repayment_Tax__c,Bonus_Amount1__c,Bank_Account_Name_Native__c,Amount_Financed__c,Service_Mileage__c,Bank_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode limit 1]; 
        }
        
    Map<string ,string> profilestrmap=new Map<string,string>();
    for(Retail_Task__c r:lstrettsk){
    if(r.Related_Dealer__r.Dealer_GC_Code__c!=null )
       profilestrmap.put(r.Related_Dealer__r.Dealer_GC_Code__c,r.Related_Dealer__r.Dealer_GC_Code__c); 
        
    }
        if(profilestrmap.containsKey(currentuser.Dealer_GC_Code__c))
        {
           
          rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Guarantor3_Address__c,Guarantor3_Address_Native__c,Guarantor1_ZipCode__c,Contractor_Name_Native__c,Contractor_Phone1__c,Contractor_Address1__c,Delinquency__c,Branch_Name__c,Branch_Name_Native__c,Guarantor3_ZipCode__c,Guarantor3_Company_Name__c,Voluntary_Insurance_Premium_Dealer__c,Guarantor3_Company_Name_Native__c,Guarantor3_Fax__c,Guarantor3_BirthDate__c,Guarantor3_Gender__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor2_Phone__c,Guarantor3_Name__c,Guarantor3_Name_Native__c,Guarantor2_Gender__c,Guarantor2_Company_Name__c,Guarantor2_Company_Name_Native__c,Guarantor2_MobilePhone__c,Guarantor2_Fax__c,Guarantor2_BirthDate__c,Guarantor1_Fax__c,Guarantor1_Company_Name_Native__c,Guarantor2_Name__c,Guarantor1_Company_Name__c,Guarantor1_BirthDate__c,Guarantor1_Gender__c,Central_Customer_Number__c,Guarantor1_Name__c,Guarantor1_Name_Native__c,Guarantor1_Phone__c,Contractor_Company_Name__c,Contractor_Company_Established_Date__c,Number_Of_Employees__c,Occupation_Type__c,Annual_Income__c,Industry_Code__c,Family_Members_Others__c,Family_Members_Total__c,Family_Members_Children__c,Contractor_Marital_Status__c,Contractor_BirthDate__c,Contractor_Gender__c,Contractor_Fax3__c,Contractor_Mail__c,Contractor_Phone3__c,Contractor_MobilePhone3__c,Contractor_ZipCode2__c,Contractor_Address3__c,Contractor_Address3_Native__c,Contractor_ZipCode3__c,Contractor_Fax2__c,Contractor_MobilePhone2__c,Contractor_Address2__c,Contractor_Address2_Native__c,Contractor_Fax1__c,Contractor_MobilePhone1__c,Lease_Remaining_Balance_With_RV__c,Bank_Account_Type__c,Lease_Remaining_Balance_Without_RV__c,Bank_Account_Number__c,Guarantor1_Address__c,Guarantor1_Address_Native__c,Guarantor1_MobilePhone__c,Bonus_Month1__c,Bank_Name__c,Bank_Account_Name__c,Branch_Code__c,Voluntary_Insurance_Premium__c,Indemnity_Amount__c,Guarantor2_ZipCode__c,Guarantor2_Address__c,Campaign_Description__c,Sales_Type__c,Monthly_Repayment__c,Bank_Code__c,Fine_Rate__c,Bonus_Amount2__c,Interest_Rate__c,Down_Payment__c,Balloon_RV_Amount__c,Contact_Date__c,Monthly_Repayment_Tax__c,Bonus_Amount1__c,Bank_Account_Name_Native__c,Amount_Financed__c,Service_Mileage__c,Bank_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode limit 1]; 
 
       
              
             }
         Map<string ,string> profstrmap=new Map<string,string>();
    for(Retail_Task__c r:lstrettsk){
    if(r.Supporting_Dealer__r.Dealer_GC_Code__c!=null )
    profstrmap.put(r.Supporting_Dealer__r.Dealer_GC_Code__c,r.Supporting_Dealer__r.Dealer_GC_Code__c); 
        
    }   
    
    
    if(profstrmap.containsKey(currentuser.Dealer_GC_Code__c))
            {
                         
       rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Guarantor3_Address_Native__c,Guarantor1_ZipCode__c,Guarantor3_Address__c,Contractor_Address1__c,Contractor_Phone1__c,Guarantor3_ZipCode__c,Branch_Name__c,Branch_Name_Native__c,Delinquency__c,Voluntary_Insurance_Premium_Dealer__c,Guarantor3_Company_Name__c,Guarantor3_Company_Name_Native__c,Guarantor3_Fax__c,Guarantor3_BirthDate__c,Guarantor3_Gender__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor2_Phone__c,Guarantor3_Name__c,Guarantor3_Name_Native__c,Guarantor2_Gender__c,Guarantor2_Company_Name__c,Guarantor2_Company_Name_Native__c,Guarantor2_MobilePhone__c,Guarantor2_Fax__c,Guarantor2_BirthDate__c,Guarantor1_Fax__c,Guarantor1_Company_Name_Native__c,Guarantor2_Name__c,Guarantor1_Company_Name__c,Guarantor1_BirthDate__c,Guarantor1_Gender__c,Central_Customer_Number__c,Guarantor1_Name__c,Guarantor1_Name_Native__c,Guarantor1_Phone__c,Contractor_Company_Name__c,Contractor_Company_Established_Date__c,Number_Of_Employees__c,Occupation_Type__c,Annual_Income__c,Industry_Code__c,Family_Members_Others__c,Family_Members_Total__c,Family_Members_Children__c,Contractor_Marital_Status__c,Contractor_BirthDate__c,Contractor_Gender__c,Contractor_Fax3__c,Contractor_Mail__c,Contractor_Phone3__c,Contractor_MobilePhone3__c,Contractor_ZipCode2__c,Contractor_Address3__c,Contractor_Address3_Native__c,Contractor_ZipCode3__c,Contractor_Fax2__c,Contractor_MobilePhone2__c,Contractor_Address2__c,Contractor_Address2_Native__c,Contractor_Fax1__c,Contractor_MobilePhone1__c,Lease_Remaining_Balance_With_RV__c,Bank_Account_Type__c,Lease_Remaining_Balance_Without_RV__c,Bank_Account_Number__c,Guarantor1_Address__c,Guarantor1_Address_Native__c,Guarantor1_MobilePhone__c,Bonus_Month1__c,Bank_Name__c,Bank_Account_Name__c,Branch_Code__c,Voluntary_Insurance_Premium__c,Indemnity_Amount__c,Guarantor2_ZipCode__c,Guarantor2_Address__c,Campaign_Description__c,Sales_Type__c,Monthly_Repayment__c,Bank_Code__c,Fine_Rate__c,Bonus_Amount2__c,Interest_Rate__c,Down_Payment__c,Balloon_RV_Amount__c,Contact_Date__c,Monthly_Repayment_Tax__c,Bonus_Amount1__c,Bank_Account_Name_Native__c,Amount_Financed__c,Service_Mileage__c,Bank_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode limit 1]; 
               
            } 
            
            
            
        }

        
        
    
}