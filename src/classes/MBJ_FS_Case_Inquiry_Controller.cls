public class MBJ_FS_Case_Inquiry_Controller{
    
    private final Case inquiryCase;
    Public Retail_Task__c rtlTask;
    Public Retail_Task__c retailTask;
    Public String RecordTypeid;
    Public String accountId;
    Public ID caseID;
    Public ID retailTaskID;
    Public id accid;
    Public ID caseOwnerID;
      
    public MBJ_FS_Case_Inquiry_Controller(ApexPages.StandardController stdController) {
        this.inquiryCase = (Case)stdController.getrecord();
        caseID = ApexPages.currentPage().getParameters().get('id');
        
        
        
        /*
        Field value are set while creating a case record
        */
        if(caseID == null){
            RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
            inquiryCase.Recordtypeid = RecordTypeid;
            
            accountId = ApexPages.currentPage().getParameters().get('accountId');
            if(accountId != null)
                inquiryCase.Case_Complainant__c = accountId;
                inquiryCase.accountid=accountId;
                
            caseOwnerID = ApexPages.currentPage().getParameters().get('ownerid');
            inquiryCase.ownerid = caseOwnerID;
            
            retailTaskID = ApexPages.currentPage().getParameters().get('retailTaskID');
            if(retailTaskID != null){
                inquiryCase.Retail_Task__c = retailTaskID;
                rtlTask = [Select id,ContractNumber__c,Related_Dealer__c from Retail_Task__c where id =:retailTaskID];
            }
            if(rtlTask!= null && rtlTask.ContractNumber__c != null)
                inquiryCase.Contract_Number__c = rtlTask.ContractNumber__c;     
        }
    }
    
    /*
    To retrive respective Contract Number for the selected Retail task record
    */
    public PageReference populateContractNumber(){
        if(inquiryCase.Retail_Task__c != null){
            retailTask = [Select id,ContractNumber__c from Retail_Task__c where id =:inquiryCase.Retail_Task__c];
            if(retailTask != null && retailTask.ContractNumber__c != null)
                inquiryCase.Contract_Number__c = retailTask.ContractNumber__c;
            else
                inquiryCase.Contract_Number__c = '';
        }
        else
            inquiryCase.Contract_Number__c = '';
        
        return null;
    }
    
    /*
    Used in MBJ_FS_Case_Request_Page,MBJ_FS_Case_Quotation_Page
    */
    public PageReference nullifyReqCompPersonPhone(){
        inquiryCase.Requester_Initial_Dealer__c = null;
        inquiryCase.Requestor_Supporting_Dealer__c = null;
        if(inquiryCase.Retail_Task__c != null){
            retailTask = [Select id,Related_Dealer__c,Supporting_Dealer__c from Retail_Task__c where id =:inquiryCase.Retail_Task__c];
            if(inquiryCase.Requestor__c == 'Initial Dealer' || inquiryCase.Requestor__c == 'Other Dealer'){    
                if(retailTask != null && retailTask.Related_Dealer__c != null)
                    inquiryCase.Requester_Initial_Dealer__c = retailTask.Related_Dealer__c;
            }
            if(inquiryCase.Requestor__c == 'Supporting dealer'){    
                if(retailTask != null && retailTask.Supporting_Dealer__c != null)
                    inquiryCase.Requestor_Supporting_Dealer__c = retailTask.Supporting_Dealer__c;
            }
        }
       /* else
            inquiryCase.Requester_Initial_Dealer__c = null;
        */    
        inquiryCase.Requestor_Company_Person_Phone__c = '';
        inquiryCase.Receiver_Same_as_Requestor__c = false;
        inquiryCase.Payer_Same_as_Requestor__c = false;
        ReceiverSameAsRequestor();
        PayerSameAsRequestor();
        return null;
    }
    
    /*
    Used in MBJ_FS_Case_Quotation_Page
    */    
    public PageReference CallReceiverAndPayer(){
        ReceiverSameAsRequestor();
        PayerSameAsRequestor();
        return null;
    }
    
    /*
    Used in MBJ_FS_Case_Request_Page,MBJ_FS_Case_Quotation_Page
    */
    public PageReference ReceiverSameAsRequestor(){
        if(inquiryCase.Receiver_Same_as_Requestor__c){
            inquiryCase.Receiver1_For_quotation__c = inquiryCase.Requestor__c;
            inquiryCase.Receiver_Company_Person_Phone__c = inquiryCase.Requestor_Company_Person_Phone__c;
            inquiryCase.Receiver_Initial_Dealer__c = inquiryCase.Requester_Initial_Dealer__c;
            inquiryCase.Receiver_Supporting_Dealer__c = inquiryCase.Requestor_Supporting_Dealer__c;
        }
        else if(!inquiryCase.Receiver_Same_as_Requestor__c){
            inquiryCase.Receiver1_For_quotation__c = '';
            inquiryCase.Receiver_Company_Person_Phone__c = '';
            inquiryCase.Receiver_Initial_Dealer__c = null;
            inquiryCase.Receiver_Supporting_Dealer__c = null;
        }
        return null;
    }
    
    /*
    Used in MBJ_FS_Case_Quotation_Page
    */
    public PageReference PayerSameAsRequestor(){
        if(inquiryCase.Payer_Same_as_Requestor__c){
            inquiryCase.Payer__c = inquiryCase.Requestor__c;
            inquiryCase.Payer_Company_Person_Phone__c = inquiryCase.Requestor_Company_Person_Phone__c;
            inquiryCase.Payer_Initial_Dealer__c = inquiryCase.Requester_Initial_Dealer__c;
            inquiryCase.Payer_Supporting_Dealer__c = inquiryCase.Requestor_Supporting_Dealer__c;
        }
        else if(!inquiryCase.Payer_Same_as_Requestor__c){
            inquiryCase.Payer__c = '';
            inquiryCase.Payer_Company_Person_Phone__c = '';
            inquiryCase.Payer_Initial_Dealer__c = null;
            inquiryCase.Payer_Supporting_Dealer__c = null;
        }
        return null;
    }
    
    /*
    Used for nullifying the field values in MBJ_FS_Case_Request_Page
    */
    public PageReference nullifyRequestPageSection(){
        inquiryCase.Narrative_of_Type__c = null;
        inquiryCase.Name__c = '';
        inquiryCase.Company_Name__c = '';
        inquiryCase.Registered_Address__c = '';
        inquiryCase.Registered_Phone_Number__c = '';
        inquiryCase.Mailing_Address__c = '';
        inquiryCase.Mailing_Phone_Number__c = '';
        inquiryCase.Present_Address__c = '';
        inquiryCase.Present_Phone_Number__c = '';
        inquiryCase.New_Bank_Name__c = '';
        inquiryCase.Bank_Account_of_Change_Date__c = null;
        inquiryCase.Existing_Account_Availability_Date__c = null;
        inquiryCase.Vehicle_Inspection_Certificate_Change__c = null;
        inquiryCase.Certificate_of_Outstanding_Balance__c = null;
        inquiryCase.Account_Closing_Month__c = '';
        inquiryCase.Required_Period__c = '';
        inquiryCase.DeadLine__c = null;
        inquiryCase.Reason__c = '';
        return null;
    }
    
    /*
    Used for nullifying the field values in MBJ_FS_Case_ContractClosing_Page
    */
    public PageReference nullifyContractClosingPageSection(){
        inquiryCase.Confirmation_person__c = '';
        inquiryCase.Confirmed_with_Person_name__c = '';
        inquiryCase.Quotation_Case_Number__c = null;
        inquiryCase.Payer_input_check__c = false;
        inquiryCase.Address_for_Transfer_Certificate__c = false;
        inquiryCase.Date_of_application_input__c = false;
        inquiryCase.ET_calculation_sheet_availability_check__c = '';
        inquiryCase.Regarding_Vehicle_transfer_doc__c = false;
        inquiryCase.Govt_Subsidy_reimburse__c = '';
        inquiryCase.Regarding_ET_for_insurance__c = '';
        inquiryCase.Regarding_Payment_due_date__c = false;
        inquiryCase.Final_monthly_payment_date_check__c = false;
        inquiryCase.Date_Received__c = null;
        inquiryCase.Enclosure_of_new_contract__c = false;
        inquiryCase.Buyer__c = '';
        inquiryCase.Quotation_number__c = '';
        inquiryCase.CA_application_submitted__c =
        inquiryCase.CA_Requested__c = false;
        inquiryCase.CA_Number__c = '';
        inquiryCase.CA_Result__c = '';
        inquiryCase.CA_result_shared__c = false;
        inquiryCase.Contract_document_requested_date__c = false;
        inquiryCase.Final_app_payment_confirmation__c = null;
        inquiryCase.Final_app_billing_date_of_penalty_charge__c = null;
        inquiryCase.Final_app_due_date_of_penalty_charge__c = null;
        inquiryCase.Invoice_amount_of_adjustment_charge__c = '';
        inquiryCase.Due_date_of_adjustment_charge__c = null;
        inquiryCase.Final_app_Planned_repossession_date__c = null;
        inquiryCase.Pre_app_requested_date_to_JAAI__c = null;
        inquiryCase.Final_app_date__c = null;
        inquiryCase.Final_app_result_Invoice_amount_Penalty__c = null;
        inquiryCase.Pre_app_result_shared__c = null;
        inquiryCase.Place_of_vehicle_repossession__c = '';
        inquiryCase.Vehicle_repossession_date__c = null;
        return null;
    }
    
    /*
    Used for nullifying the field values in MBJ_FS_Case_Quotation_Page
    */
    public PageReference nullifyCaseQuotationPageSection(){
        inquiryCase.Retail_Non_Retail_car__c = '';
        inquiryCase.ET_Type_for_Close_Mileage__c = '';
        inquiryCase.Voluntary_insurance_check__c = '';
        inquiryCase.X3_months_usage__c = '';
        inquiryCase.Area_manager_approval__c = false;
        inquiryCase.Regarding_ET_for_insurance__c = '';
        inquiryCase.Buyer__c = '';
        inquiryCase.Replacement__c = '';
        inquiryCase.Mileage__c = null;
        inquiryCase.Final_monthly_payment_date1__c = null;
        inquiryCase.Reduction_of_fee_for_date1__c = null;
        inquiryCase.Final_monthly_payment_date2__c = null;
        inquiryCase.Reduction_of_fee_for_date2__c =null;
        inquiryCase.Govt_Subsidy_reimburse__c = '';
        inquiryCase.Accident_repair_history__c = false;
        inquiryCase.Re_lease_voluntary_insurance_check__c = '';
        inquiryCase.Re_lease_term__c = null;
        inquiryCase.Regarding_Vehicle_transfer_doc__c = false;
        inquiryCase.Down_payment__c = false;
        inquiryCase.Bonus_payment_amount__c = null;
        inquiryCase.Bonus_payment_month_1_month_2__c = null;
        inquiryCase.Payment_term__c = null;
        inquiryCase.First_payment__c = null;
        inquiryCase.Pre_app_Location__c = '';
        inquiryCase.Pre_app_1st_requested_date__c = null;
        inquiryCase.Pre_app_2nd_requested_date__c = null;
        inquiryCase.Pre_app_requested_date_to_JAAI__c = null;
        inquiryCase.Pre_app_result_shared__c = null;
        return null;
    }
    
}