public class RelatedDealerViewForInsurance
{
    public Retail_Task__c Insurance{get;set;}
    public Retail_Task__c displayInsurance{get;set;}
    public User us1;
    public String alkID{get;set;}
    public String AddressActual{get;set;}
    public String BonusMonth{get;set;}
    public String ChangeofContractCondition{get;set;}
    public Decimal Changeofpremium{get;set;}
    public String CompanyName{get;set;}
    public string ContractorBirthdate{get;set;}
    public Decimal Netpremium{get;set;}
    public Decimal Netpremium2nd{get;set;}
    public Decimal Netpremium3rd{get;set;}
    public String OutletName{get;set;}
    //public String ContractorNamkanji{get;set;}
    //public String ContractorNamkatkana{get;set;}
    //public String ZipCodeActual{get;set;}
    public String Paymentmethodoflongterm{get;set;}
    public String Phone1Actual{get;set;}
    public String CommonComments{get;set;}
    public String SourceSystem{get;set;}
    public string Updatedate{get;set;}
    public RelatedDealerViewForInsurance(ApexPages.StandardController controller) 
    {
        Insurance=new Retail_Task__c ();
        displayInsurance=new Retail_Task__c ();
        alkID=ApexPages.currentPage().getParameters().get('id');
        if(alkID!=null)
        {
            Insurance= [select id,RecordType.Name,Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Common_Comments__c,Source_System__c,Balance_Update_Date__c,Related_Dealer__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
        }
        us1 = [select id,ContactId,TimeZoneSidKey, Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
        
        if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF') && (Insurance.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && Insurance!=null)
        {
            displayInsurance=[select Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Contractor_Name__c,Common_Comments__c,Contractor_Name_Native__c,Insurance_Company__c,Non_MB_Insurance__c,Insured_Name_Native__c,Condition_Change_Date__c,Contractor_ZipCode1__c,Vehicle_Registration_No__c,Source_System__c,Balance_Update_Date__c from Retail_Task__c where ID = :alkID and Recordtype.name='Insurance Contract'];
        } 
        
        
        if((us1.ContactId !=null) &&(us1.User_Type__c == 'Dealer') && (Insurance.Related_Dealer__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && Insurance!=null)
        { 
            if(alkID!=null)
            {
                Insurance= [select id,RecordType.Name,Contractor_Address1__c,Booking_Month__c,tolabel(Condition_Change__c),Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,tolabel(Payment_Method__c),Contractor_Phone1__c,Common_Comments__c,Source_System__c,Balance_Update_Date__c,Related_Dealer__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
                if(Insurance!=null && Insurance.recordtype.Name=='Insurance Contract' && us1.ContactId !=null)
                {
                    AddressActual=Insurance.Contractor_Address1__c;
                    BonusMonth=Insurance.Booking_Month__c;
                    ChangeofContractCondition=Insurance.Condition_Change__c;
                    Changeofpremium=Insurance.Premium_Change__c;
                    CompanyName=Insurance.Company_Name__c;
                    if(Insurance.Contractor_BirthDate__c != null)
                    {
                        ContractorBirthdate=Insurance.Contractor_BirthDate__c.format();
                    }
                    Netpremium=Insurance.Net_Premium__c;
                    Netpremium2nd=Insurance.Net_Premium2__c;
                    Netpremium3rd=Insurance.Net_Premium3__c;
                    OutletName=Insurance.Outlet_Name__c;
                    Paymentmethodoflongterm=Insurance.Payment_Method__c;
                    Phone1Actual=Insurance.Contractor_Phone1__c;
                    CommonComments=Insurance.Common_Comments__c;
                    SourceSystem=Insurance.Source_System__c;
                    if(Insurance.Balance_Update_Date__c != null)
                    {
                        Updatedate=Insurance.Balance_Update_Date__c.format('MM/dd/yyyy HH:mm:ss',us1.TimeZoneSidKey);
                    }
                }
            }
            system.debug('Testing');
            displayInsurance=[select Contractor_Address1__c,Booking_Month__c,Condition_Change__c,Premium_Change__c,Company_Name__c,Contractor_BirthDate__c,Net_Premium__c,Net_Premium2__c,Net_Premium3__c,Outlet_Name__c,Payment_Method__c,Contractor_Phone1__c,Contractor_Name__c,Common_Comments__c,Contractor_Name_Native__c,Insurance_Company__c,Non_MB_Insurance__c,Insured_Name_Native__c,Condition_Change_Date__c,Contractor_ZipCode1__c,Vehicle_Registration_No__c,Source_System__c,Balance_Update_Date__c from Retail_Task__c where ID = :alkID and Recordtype.name='Insurance Contract'];
            system.debug('Testing+displayInsurance'+displayInsurance);
            
        }
    }
}