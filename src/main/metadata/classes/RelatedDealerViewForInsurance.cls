public class RelatedDealerViewForInsurance
{
public Retail_Task__c Insurance{get;set;}
public Retail_Task__c displayInsurance{get;set;}
public User us1;
public String alkID{get;set;}
public RelatedDealerViewForInsurance(ApexPages.StandardController controller) 
{
     Insurance=new Retail_Task__c ();
     displayInsurance=new Retail_Task__c ();
     alkID=ApexPages.currentPage().getParameters().get('id');
     if(alkID!=null)
     {
        Insurance= [select id,Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Common_Comments__c,Source_System__c,Contractor_Name_Native__c,Insurance_Company__c,Non_MB_Insurance__c,Insured_Name_Native__c,Condition_Change_Date__c,Contractor_ZipCode1__c,Vehicle_Registration_No__c,Balance_Update_Date__c,Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
     }
        us1 = [select id, Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
   
    if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF') && (Insurance.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && Insurance!=null)
        {
           displayInsurance=[select Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Contractor_Name__c,Common_Comments__c,Contractor_Name_Native__c,Insurance_Company__c,Non_MB_Insurance__c,Insured_Name_Native__c,Condition_Change_Date__c,Contractor_ZipCode1__c,Vehicle_Registration_No__c,Source_System__c,Balance_Update_Date__c from Retail_Task__c where ID = :alkID and Recordtype.name='Insurance Contract'];
        }    
}
}