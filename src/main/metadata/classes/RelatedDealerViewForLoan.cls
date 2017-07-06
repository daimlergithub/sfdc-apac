/***********************************************************************************
Modified  By          :    Venky    
Modified   Date        :    13.03.2017
Company             :    NTT Data,Inc.
JIRA Number      :    SFDCJP-1899
Usage               :    Class is used to displaying Retail task fields matching with User GC code and Dealer Gc code for Dealer Users.

************************************************************************************/

public class RelatedDealerViewForLoan
{
    public Retail_Task__c Loan{get;set;}
    public Retail_Task__c displayLoan{get;set;}
    public Retail_Task__c DealerLoan{get;set;}
    public User us1{get;set;}
    public String alkID{get;set;}
    public String CreditLoanCompanyName{get;set;}
    public String SalesPerson{get;set;}
    public String SalesType{get;set;}
    public String CampaignDescription{get;set;}
    public string PaymentStartDate{get;set;}
    public string PaymentEndDate{get;set;}
    public Decimal NumberofPayments{get;set;}
    public Decimal LoanPrincipal{get;set;}
    public Decimal BalloonRVAmount{get;set;}
    public Decimal FirstInstallmentAmount{get;set;}
    public Decimal Monthlypaymentamount {get;set;}
    public String BonusMonth1{get;set;}
    public Decimal BonusAmount1{get;set;}
    public String BonusMonth2{get;set;}
    public Decimal BonusAmount2{get;set;}
    public Decimal TotalInterestAmount{get;set;}
    public Decimal TotalPaymentAmount{get;set;}
    public Decimal CustomerInterestRate{get;set;}
    public Decimal CurrentMileage{get;set;}
    public Decimal FineRate{get;set;}
    public Decimal IndemnityAmount{get;set;}
    public Decimal OutstandingBalance{get;set;}
    public string Updatedate{get;set;}
    public String ContractorNamekanji{get;set;}
    public String ContractorNamekatakana{get;set;}
    public String ContractorCompanyNameKanji{get;set;}
    public String ContractorCompanyNameKana{get;set;}
    public string ContractorBirthdate{get;set;}
    public String ContractorGender {get;set;}
    public string EstablishedDate{get;set;}
    public Decimal NumberOfEmployees{get;set;}
    public String Guarantor1ZipCodeactual{get;set;}
    public string zipcodeactual{get;set;}   
    
    public String AddresskanjiActual{get;set;}
    public String AddresskanaActual{get;set;}
    public String Guarantor1Phone1actual{get;set;}
    public String Guarantor1Phone2actual{get;set;}
    public string phoneactual{get;set;}
    public string phone2actual{get;set;}
    public String ContractorEmail {get;set;}
    public String MaritalStatus{get;set;}
    public Decimal FamilyMembersChildren{get;set;}
    public Decimal FamilyMembersOthers{get;set;}
    public Decimal FamilyMembersTotal{get;set;}
    public String OccupationType{get;set;}
    public String IndustryType{get;set;}
    public Decimal AnnualIncome10K{get;set;}
    public String Guarantor1NameKanji{get;set;}
    public String Guarantor1NameKana{get;set;}
    public String Guarantor1CompanyNameKanji{get;set;}
    public String Guarantor1CompanyNameKana{get;set;}
    public string G1birthdate{get;set;}
    public String G1gender{get;set;}
    public string G1zipcode{get;set;}
    public string G1add{get;set;}
    public string G1addn{get;set;}
    public string G1phone1{get;set;}
    public string G1phone2{get;set;}
    public string G1fax{get;set;}
    public String FaxNumberActual{get;set;}
    public String Guarantor2NameKanji{get;set;}
    public String Guarantor2NameKana{get;set;}
    public String Guarantor2CompanyNameKanji{get;set;}
    public String Guarantor2CompanyNameKana{get;set;}
    public string G2birthdate{get;set;}
    public string G2gender{get;set;}
    public string G2zipcode{get;set;}
    public string G2add{get;set;}
    public string G2addn{get;set;}
    public string G2phone1{get;set;}
    public string G2phone2{get;set;}
    public string G2fax{get;set;}
    public String Guarantor3NameKanji{get;set;}
    public String Guarantor3NameKana {get;set;}
    public String Guarantor3CompanyNameKanji{get;set;}
    public string G3birthdate{get;set;}
    public string G3gender{get;set;}
    public string G3zipcode{get;set;}
    public string G3add{get;set;}
    public string G3addn{get;set;}
    public string G3phone1{get;set;}
    public string G3phone2{get;set;}
    public string G3fax{get;set;}
    public String Accountholdernamekanji{get;set;}
    public String Accountholdernamekana{get;set;}
    public String CommonComments{get;set;}
    public String Guarantor3CompanyNameKana{get;set;}
    public RelatedDealerViewForLoan(ApexPages.StandardController controller) {
        Loan=new Retail_Task__c ();
        displayLoan=new Retail_Task__c ();
        DealerLoan=new Retail_Task__c ();
        alkID=ApexPages.currentPage().getParameters().get('id');
        if(alkID!=null)
        {
            Loan= [select id,Bank_Account_Name_Native__c,Supporting_Dealer__c,Bank_Account_Name__c,Contractor_ZipCode1__c,RecordType.Name,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c,Actual_Maturity_Date__c,Contractor_Fax1__c,Contractor_Name__c,Contractor_Name_Native__c,Loan_Remaining_Balance_With_Baloon__c,Latest_Sales_Person__c,Actual_Outstanding_Bal_To_Shinpan_Dealer__c,Contractor_Address1_Native__c,Contractor_Address1__c,Annual_Income__c,Loan_Remaining_Bal_Baloon_Dealer__c,Balloon_RV_Amount__c,Bonus_Amount1__c,Bonus_Amount2__c,Bonus_Month1__c,Bonus_Month2__c,Campaign_Description__c,Contractor_BirthDate__c,Contractor_Company_Name_Native__c,Contractor_Company_Name__c,Contractor_Mail__c,Contractor_Gender__c,Credit_Loan_Company_Name__c,Service_Mileage__c,Interest_Rate__c,Contractor_Company_Established_Date__c,Family_Members_Children__c,Family_Members_Others__c,Family_Members_Total__c,Fine_Rate__c,First_Installment_Amount__c,Guarantor1_Fax__c,Guarantor1_Phone__c,Guarantor1_MobilePhone__c,Guarantor1_Address_Native__c,Guarantor1_Address__c,Guarantor1_BirthDate__c,Guarantor1_Company_Name_Native__c,Guarantor1_Company_Name__c,Guarantor1_Gender__c,Guarantor1_Name_Native__c,Guarantor1_Name__c,Guarantor1_ZipCode__c,Guarantor2_Fax__c,Guarantor2_Phone__c,Guarantor2_MobilePhone__c,Guarantor2_Address_Native__c,Guarantor2_Address__c,Guarantor2_BirthDate__c,Guarantor2_Company_Name_Native__c,Guarantor2_Company_Name__c,Guarantor2_Gender__c,Guarantor2_Name_Native__c,Guarantor2_Name__c,Guarantor2_ZipCode__c,Guarantor3_Fax__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor3_Address_Native__c,Guarantor3_Address__c,Guarantor3_BirthDate__c,Guarantor3_Company_Name_Native__c,Guarantor3_Company_Name__c,Guarantor3_Gender__c,Guarantor3_Name_Native__c,Guarantor3_Name__c,Guarantor3_ZipCode__c,Indemnity_Amount__c,Industry_Code__c,Activation_Dealer_Code__c,Loan_Principal__c,Contractor_Marital_Status__c,Monthly_Repayment__c,Number_of_Employees__c,Payments__c,Occupation_Type__c,Payment_End_Date__c,Payment_Start_Date__c,Contractor_Phone1__c,Contractor_MobilePhone1__c,Sales_Type__c,Split_Payment_Comission_Fee__c,Total_Split_Payment__c,Suspend_Payment__c,Balance_Update_Date__c,Parent_Flag__c,Parent_Number__c,Source_System__c,Status__c,Common_Comments__c,Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID];
            system.debug('###'+Loan);
        }
        us1 = [select id,ContactId, Dealer_GC_Code__c,User_Type__c,TimeZoneSidKey from User WHERE Id =:UserInfo.getUserId()];
        
        if((us1.User_Type__c=='MBJ'||us1.User_Type__c == 'MBF' && (Loan.Account__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) && Loan!=null))
        {
            system.debug('I am here');
            displayLoan=[select Bank_Account_Name_Native__c,Supporting_Dealer__c,Supporting_Dealer__r.Dealer_GC_Code__c,RecordType.name,Contractor_ZipCode1__c,Bank_Account_Name__c,Actual_Maturity_Date__c,Contractor_Fax1__c,Contractor_Name__c,Contractor_Name_Native__c,Loan_Remaining_Balance_With_Baloon__c,Latest_Sales_Person__c,Actual_Outstanding_Bal_To_Shinpan_Dealer__c,Contractor_Address1_Native__c,Contractor_Address1__c,Annual_Income__c,Loan_Remaining_Bal_Baloon_Dealer__c,Balloon_RV_Amount__c,Bonus_Amount1__c,Bonus_Amount2__c,Bonus_Month1__c,Bonus_Month2__c,Campaign_Description__c,Contractor_BirthDate__c,Contractor_Company_Name_Native__c,Contractor_Company_Name__c,Contractor_Mail__c,Contractor_Gender__c,Credit_Loan_Company_Name__c,Service_Mileage__c,Interest_Rate__c,Contractor_Company_Established_Date__c,Family_Members_Children__c,Family_Members_Others__c,Family_Members_Total__c,Fine_Rate__c,First_Installment_Amount__c,Guarantor1_Fax__c,Guarantor1_Phone__c,Guarantor1_MobilePhone__c,Guarantor1_Address_Native__c,Guarantor1_Address__c,Guarantor1_BirthDate__c,Guarantor1_Company_Name_Native__c,Guarantor1_Company_Name__c,Guarantor1_Gender__c,Guarantor1_Name_Native__c,Guarantor1_Name__c,Guarantor1_ZipCode__c,Guarantor2_Fax__c,Guarantor2_Phone__c,Guarantor2_MobilePhone__c,Guarantor2_Address_Native__c,Guarantor2_Address__c,Guarantor2_BirthDate__c,Guarantor2_Company_Name_Native__c,Guarantor2_Company_Name__c,Guarantor2_Gender__c,Guarantor2_Name_Native__c,Guarantor2_Name__c,Guarantor2_ZipCode__c,Guarantor3_Fax__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor3_Address_Native__c,Guarantor3_Address__c,Guarantor3_BirthDate__c,Guarantor3_Company_Name_Native__c,Guarantor3_Company_Name__c,Guarantor3_Gender__c,Guarantor3_Name_Native__c,Guarantor3_Name__c,Guarantor3_ZipCode__c,Indemnity_Amount__c,Industry_Code__c,Activation_Dealer_Code__c,Loan_Principal__c,Contractor_Marital_Status__c,Monthly_Repayment__c,Number_of_Employees__c,Payments__c,Occupation_Type__c,Payment_End_Date__c,Payment_Start_Date__c,Contractor_Phone1__c,Contractor_MobilePhone1__c,Sales_Type__c,Split_Payment_Comission_Fee__c,Total_Split_Payment__c,Suspend_Payment__c,Balance_Update_Date__c,Parent_Flag__c,Parent_Number__c,Source_System__c,Status__c,Common_Comments__c from Retail_Task__c where ID = :alkID and  Recordtype.name='Loan Contract'];
            system.debug('####'+displayLoan);
        }  
        
        if((us1.ContactId !=null) &&(us1.User_Type__c == 'Dealer') && ((loan.Related_Dealer__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c) || (loan.Supporting_Dealer__r.Dealer_GC_Code__c == us1.Dealer_GC_Code__c)))
        { 
            if(alkID!=null)
            {
                DealerLoan = [select id,Bank_Account_Name_Native__c,Supporting_Dealer__c,Supporting_Dealer__r.Dealer_GC_Code__c,tolabel(RecordType.Name),Contractor_ZipCode1__c,Bank_Account_Name__c,Actual_Maturity_Date__c,Contractor_Fax1__c,Contractor_Name__c,Contractor_Name_Native__c,Loan_Remaining_Balance_With_Baloon__c,Latest_Sales_Person__c,Actual_Outstanding_Bal_To_Shinpan_Dealer__c,Contractor_Address1_Native__c,Contractor_Address1__c,Annual_Income__c,Loan_Remaining_Bal_Baloon_Dealer__c,Balloon_RV_Amount__c,Bonus_Amount1__c,Bonus_Amount2__c,Bonus_Month1__c,Bonus_Month2__c,Campaign_Description__c,Contractor_BirthDate__c,Contractor_Company_Name_Native__c,Contractor_Company_Name__c,Contractor_Mail__c,Contractor_Gender__c,Credit_Loan_Company_Name__c,Service_Mileage__c,Interest_Rate__c,Contractor_Company_Established_Date__c,Family_Members_Children__c,Family_Members_Others__c,Family_Members_Total__c,Fine_Rate__c,First_Installment_Amount__c,Guarantor1_Fax__c,Guarantor1_Phone__c,Guarantor1_MobilePhone__c,Guarantor1_Address_Native__c,Guarantor1_Address__c,Guarantor1_BirthDate__c,Guarantor1_Company_Name_Native__c,Guarantor1_Company_Name__c,tolabel(Guarantor1_Gender__c),Guarantor1_Name_Native__c,Guarantor1_Name__c,Guarantor1_ZipCode__c,Guarantor2_Fax__c,Guarantor2_Phone__c,Guarantor2_MobilePhone__c,Guarantor2_Address_Native__c,Guarantor2_Address__c,Guarantor2_BirthDate__c,Guarantor2_Company_Name_Native__c,Guarantor2_Company_Name__c,Guarantor2_Gender__c,Guarantor2_Name_Native__c,Guarantor2_Name__c,Guarantor2_ZipCode__c,Guarantor3_Fax__c,Guarantor3_Phone__c,Guarantor3_MobilePhone__c,Guarantor3_Address_Native__c,Guarantor3_Address__c,Guarantor3_BirthDate__c,Guarantor3_Company_Name_Native__c,Guarantor3_Company_Name__c,Guarantor3_Gender__c,Guarantor3_Name_Native__c,Guarantor3_Name__c,Guarantor3_ZipCode__c,Indemnity_Amount__c,tolabel(Industry_Code__c),Activation_Dealer_Code__c,Loan_Principal__c,Contractor_Marital_Status__c,Monthly_Repayment__c,Number_of_Employees__c,Payments__c,Occupation_Type__c,Payment_End_Date__c,Payment_Start_Date__c,Contractor_Phone1__c,Contractor_MobilePhone1__c,toLabel(Sales_Type__c),Split_Payment_Comission_Fee__c,Total_Split_Payment__c,Suspend_Payment__c,Balance_Update_Date__c,Parent_Flag__c,Parent_Number__c,Source_System__c,Status__c,Common_Comments__c,Account__r.Dealer_GC_Code__c from Retail_Task__c WHERE ID = :alkID and  Recordtype.name='Loan Contract'];
                system.debug('DealerLoan>><><><>' + DealerLoan);
                system.debug('DealerLoan Sales Type>><><><>' + DealerLoan.Sales_Type__c);
                if(DealerLoan !=null && DealerLoan.recordtype.Name=='Loan Contract' && us1.ContactId !=null)
                {
                    CreditLoanCompanyName=DealerLoan.Credit_Loan_Company_Name__c;
                    SalesPerson=DealerLoan.Latest_Sales_Person__c;
                    SalesType=DealerLoan.Sales_Type__c;
                    CampaignDescription=DealerLoan.Campaign_Description__c;
                    if(DealerLoan.Payment_Start_Date__c != null)
                    {
                        PaymentStartDate=DealerLoan.Payment_Start_Date__c.format();
                    }
                    if(DealerLoan.Payment_End_Date__c != null)
                    {
                        PaymentEndDate= DealerLoan.Payment_End_Date__c.format();
                    }
                    NumberofPayments=DealerLoan.Payments__c;
                    LoanPrincipal=DealerLoan.Loan_Principal__c;
                    BalloonRVAmount=DealerLoan.Balloon_RV_Amount__c;
                    FirstInstallmentAmount=DealerLoan.First_Installment_Amount__c;
                    Monthlypaymentamount=DealerLoan.Monthly_Repayment__c;
                    BonusMonth1=DealerLoan.Bonus_Month1__c;
                    BonusAmount1=DealerLoan.Bonus_Amount1__c;
                    BonusMonth2=DealerLoan.Bonus_Month2__c;
                    BonusAmount2=DealerLoan.Bonus_Amount2__c;
                    TotalInterestAmount=DealerLoan.Split_Payment_Comission_Fee__c;
                    TotalPaymentAmount=DealerLoan.Total_Split_Payment__c;
                    CustomerInterestRate=DealerLoan.Interest_Rate__c;
                    CurrentMileage=DealerLoan.Service_Mileage__c;
                    FineRate=DealerLoan.Fine_Rate__c;
                    IndemnityAmount=DealerLoan.Indemnity_Amount__c;
                    OutstandingBalance=DealerLoan.Loan_Remaining_Balance_With_Baloon__c;
                    if(DealerLoan.Balance_Update_Date__c != null)
                    {
                        Updatedate=DealerLoan.Balance_Update_Date__c.format('MM/dd/yyyy HH:mm:ss',us1.TimeZoneSidKey);
                    }
                    ContractorNamekanji=DealerLoan.Contractor_Name__c;
                    ContractorNamekatakana=DealerLoan.Contractor_Name_Native__c;
                    ContractorCompanyNameKanji=DealerLoan.Contractor_Company_Name__c;
                    ContractorCompanyNameKana=DealerLoan.Contractor_Company_Name_Native__c;
                    if(DealerLoan.Contractor_BirthDate__c != null)
                    {
                        ContractorBirthdate=DealerLoan.Contractor_BirthDate__c.format();
                    }
                    ContractorGender =DealerLoan.Contractor_Gender__c;
                    if(DealerLoan.Contractor_Company_Established_Date__c != null)
                    {
                        EstablishedDate=DealerLoan.Contractor_Company_Established_Date__c.format();
                    }
                    NumberOfEmployees=DealerLoan.Number_Of_Employees__c;
                    Guarantor1ZipCodeactual=DealerLoan.Guarantor1_ZipCode__c;
                    AddresskanjiActual=DealerLoan.Contractor_Address1__c;
                    AddresskanaActual=DealerLoan.Contractor_Address1_Native__c;
                    Guarantor1Phone1actual=DealerLoan.Guarantor1_Phone__c;
                    Guarantor1Phone2actual=DealerLoan.Guarantor1_MobilePhone__c;
                    ContractorEmail =DealerLoan.Contractor_Mail__c;
                    MaritalStatus=DealerLoan.Contractor_Marital_Status__c;
                    FamilyMembersChildren=DealerLoan.Family_Members_Children__c;
                    FamilyMembersOthers=DealerLoan.Family_Members_Others__c;
                    FamilyMembersTotal=DealerLoan.Family_Members_Total__c;
                    OccupationType=DealerLoan.Occupation_Type__c;
                    IndustryType=DealerLoan.Industry_Code__c;
                    AnnualIncome10K=DealerLoan.Annual_Income__c;
                    Guarantor1NameKanji=DealerLoan.Guarantor1_Name__c;
                    Guarantor1NameKana=DealerLoan.Guarantor1_Name_Native__c;
                    Guarantor1CompanyNameKanji=DealerLoan.Guarantor1_Company_Name__c;
                    Guarantor1CompanyNameKana=DealerLoan.Guarantor1_Company_Name_Native__c;
                    FaxNumberActual=DealerLoan.Contractor_Fax1__c;
                    Guarantor2NameKanji=DealerLoan.Guarantor2_Name__c;
                    Guarantor2NameKana=DealerLoan.Guarantor2_Name_Native__c;
                    Guarantor2CompanyNameKanji=DealerLoan.Guarantor2_Company_Name__c;
                    Guarantor2CompanyNameKana=DealerLoan.Guarantor2_Company_Name_Native__c;
                    Guarantor3NameKanji=DealerLoan.Guarantor3_Name__c;
                    Guarantor3NameKana =DealerLoan.Guarantor3_Name_Native__c;
                    Guarantor3CompanyNameKanji=DealerLoan.Guarantor3_Company_Name__c;
                    Guarantor3CompanyNameKana=DealerLoan.Guarantor3_Company_Name_Native__c;
                    Accountholdernamekanji=DealerLoan.Bank_Account_Name__c;
                    Accountholdernamekana=DealerLoan.Bank_Account_Name_Native__c;
                    CommonComments=DealerLoan.Common_Comments__c;
                    zipcodeactual=DealerLoan.Contractor_ZipCode1__c;
                    phoneactual=DealerLoan.Contractor_Phone1__c;   
                    phone2actual=DealerLoan.Contractor_MobilePhone1__c;
                    if(DealerLoan.Guarantor1_BirthDate__c != null)
                    {
                        G1birthdate=DealerLoan.Guarantor1_BirthDate__c.format();
                    }
                    if(DealerLoan.Guarantor2_BirthDate__c != null)
                    {
                        G2birthdate=DealerLoan.Guarantor2_BirthDate__c.format();
                    }
                    if(DealerLoan.Guarantor2_BirthDate__c != null)
                    {
                        G3birthdate=DealerLoan.Guarantor3_BirthDate__c.format();
                    }
                    G1gender=DealerLoan.Guarantor1_Gender__c;
                    G2gender=DealerLoan.Guarantor2_Gender__c;
                    G3gender=DealerLoan.Guarantor3_Gender__c;
                    G1zipcode=DealerLoan.Guarantor1_ZipCode__c;
                    G1addn=DealerLoan.Guarantor1_Address_Native__c;
                    G1add=DealerLoan.Guarantor1_Address__c;
                    G1phone1=DealerLoan.Guarantor1_Phone__c;
                    G1phone2=DealerLoan.Guarantor1_MobilePhone__c;
                    G1fax=DealerLoan.Guarantor1_Fax__c;
                    G2zipcode=DealerLoan.Guarantor2_ZipCode__c;
                    G2addn=DealerLoan.Guarantor2_Address_Native__c;
                    G2add=DealerLoan.Guarantor2_Address__c;
                    G2phone1=DealerLoan.Guarantor2_Phone__c;
                    G2phone2=DealerLoan.Guarantor2_MobilePhone__c;
                    G2fax=DealerLoan.Guarantor2_Fax__c;
                    G3zipcode=DealerLoan.Guarantor3_ZipCode__c;
                    G3addn=DealerLoan.Guarantor3_Address_Native__c;
                    G3add=DealerLoan.Guarantor3_Address__c;
                    G3phone1=DealerLoan.Guarantor3_Phone__c;
                    G3phone2=DealerLoan.Guarantor3_MobilePhone__c;
                    G3fax=DealerLoan.Guarantor3_Fax__c;
                    
                }
            }
        }  
    }
    
}