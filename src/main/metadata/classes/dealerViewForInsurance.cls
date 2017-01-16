public class dealerViewForInsurance
{
public Retail_Task__c retail{get;set;}
public Retail_Task__c displayRetail{get;set;}
public User us1;
public String alkID{get;set;}
public dealerViewForInsurance(ApexPages.StandardController controller) 
{
     retail=new Retail_Task__c ();
     displayRetail=new Retail_Task__c ();
     alkID=ApexPages.currentPage().getParameters().get('id');
     if(alkID!=null)
     {
        retail = [select id,Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Contractor_Name__c,Contractor_Name_Native__c,Condition_Change_Date__c,Insurance_Company__c,Insured_Name_Native__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Non_MB_Insurance__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c,Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
     }
        us1 = [select id, Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
   
    if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF') && (retail.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && retail!=null)
        {
           retail=[select Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Contractor_Name__c,Contractor_Name_Native__c,Condition_Change_Date__c,Insurance_Company__c,Insured_Name_Native__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Non_MB_Insurance__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Vehicle_Registration_No__c,Contractor_ZipCode1__c from Retail_Task__c where recordtype.Name='Insurance Contract'];
        }    
}
}