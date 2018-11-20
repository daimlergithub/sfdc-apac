/**
** Class: AddToDealershipCommon
** Description: Controller to handle add to dealership functionality common to few markets
** Created By: Prem Kumar
** Date: 27/08/2018
**/
public without sharing class AddToDealershipCommon {
    public String vin{get; set;}
    public String regNumber{get;set;}
    public Boolean showVrel{get;set;}
    public List<vehicleRelWrapper> vehRelWrapList{get;set;}
    public List<Vehicle_Relationship__c> selectedVehRelList{get;set;}
    public Set<Id> accSet{get;set;}
    public List<Account> accList{get;set;}
    public List<Account_Link__c> retailCopyList{get;set;}
    public Id selectedRec{get;set;}
    //popup variable
    public boolean displayPopUp {get; set;}
    public String message{get;set;}
    public String dealerNdCode = '';
    public String market = '';
    //Constructor
    public AddToDealershipCommon(){
        showVrel = false;
        vehRelWrapList = new List<vehicleRelWrapper>();
        selectedVehRelList = new List<Vehicle_Relationship__c>();
        accSet = new Set<Id>();
        displayPopUp = false;
        User usr = [select id,contactid,Contact.Account.Dealer_ND_Code__c,Market__c from User where id = :UserInfo.getUserId()];
        if (usr != null && usr.Contactid != null && usr.Contact.Account.Dealer_ND_Code__c != null && usr.Contact.Account.Dealer_ND_Code__c != ''){
            dealerNdCode = usr.Contact.Account.Dealer_ND_Code__c;
            market = usr.Market__c;
        }
    }
    
    //Method to search vehicle Relationships on the basis of VIN & Registartion no.
    public void search(){
        vehRelWrapList.clear();
        if(String.isNotBlank(vin) && String.isNotBlank(regNumber)){
            showVrel = true;
            for(Vehicle_Relationship__c vehRel : [Select Id, Name, UsVIN__c, Contact__c, Registration_Number__c, Brand__c, Car_Model__c From Vehicle_Relationship__c Where Vehicle_ID__r.UsVIN__c =: vin AND Registration_Number__c =: regNumber and Market__c = :market]){
                vehRelWrapList.add(new vehicleRelWrapper(vehRel));
            }
        }
        else{
            showVrel = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, System.label.VIN_Reg_Number_Error));
        }
    }
    
    //Method to create retail copy and redirect to account detail page
    public void showPopup(){
        selectedVehRelList.clear();
        if(!vehRelWrapList.isEmpty() && vehRelWrapList != null){
            for(vehicleRelWrapper vehRelWrp : vehRelWrapList){
                if(vehRelWrp.selected)
                    selectedVehRelList.add(vehRelWrp.vhRel);
            }
        }
        accSet.clear();
        if(!selectedVehRelList.isEmpty() && selectedVehRelList != null){
            for(Vehicle_Relationship__c vRel : selectedVehRelList){
                if(vRel.Contact__c != null)
                    accSet.add(vRel.Contact__c);
            }
        }
        accList = new List<Account>([Select Id, MD__c,market__c, LastModifiedDate,Social_ID__c, Foundation_Date__c, ID_Type__c,
                                     ID_Number__c,Country__c,createdDate,Special_Care__c, Primary_Phone__c, email__c, 
                                     Salutation__c, Mobile__c,Postal_Opt_In__c, LastName_Native_1__c, FirstName_Native_1__c,
                                     SMSOptOut__pc, Special_Needs_Class__c, Preferred_Language__c, Allow_Data_Sharing2__c, 
                                     Main_Dealer__c, RecordtypeId, UCID__c, DMS_Customer_ID__c, Name, LastName, FirstName, 
                                     Complaint_Amount__c, Sales_Sanction__c, Allow_Data_Sharing__c, PersonMobilePhone, 
                                     Individual_Home_Phone__c, Work_Phone__c, PersonEmail, Fax, Preferred_Contact_Method__c, 
                                     PersonHasOptedOutOfEmail, PersonHasOptedOutOfFax, Primary_Phone_Display__c,Opt_In_Email__c, 
                                     PersonDoNotCall, Postal_Opt_Out__c, Visit_Opt_Out__c, PersonBirthdate, Occupation__c, Job__c,
                                     Gender__c, industry, Website, Company_Name_Native_1__c, Commercial_Reg_No__c, Personal_Agreement__c, 
                                     Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c, 
                                     Vat_No__c,Opt_In_SMS__c,Updated_Consent_User__c, First_Consent_User__c,First_Consent_Date__c,
                                     Updated_Consent_Date__c,Company_Name__c,Race__c,Title__c, Retail_Work_Phone__c, Special_Mark_on_Account__c, 
                                     Opt_In_Mail__c, Opt_In_Phone__c,Opt_In_SMS3__c From Account Where Id in: accSet]);
        if(!accList.isEmpty() && accList != null){
            List<Id> accLinkRecordTypeIdSet = new List<Id>();
            accLinkRecordTypeIdSet.add(UtilRecordType.getRecordTypeIdByName('Account_Link__c', 'Retail Company'));
            accLinkRecordTypeIdSet.add(UtilRecordType.getRecordTypeIdByName('Account_Link__c', 'Retail Person'));
            retailCopyList = [Select Id, toRole__c, name, recordtypeId From Account_Link__c Where recordtypeId IN: accLinkRecordTypeIdSet And toRole__c IN: accList and fromRole__r.Dealer_ND_Code__c = :dealerNdCode];
            if(!retailCopyList.isEmpty() && retailCopyList != null)
                message = System.label.AddToDealership_RetailCopyExists;
            else
                message = System.Label.AddToDealership_Proceed;
            displayPopup = true;
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info, 'Select a vehicle. If vehicle is already selected, then it is not associated with any customer account'));
    }
    
    //popup methods
    public void closePopup(){        
        displayPopup = false;    
    }     
    public Pagereference createRetailCopyAndRedirect(){
        if(retailCopyList.isEmpty()){
            ApexPages.StandardController std = new ApexPages.StandardController(accList[0]);
            createRetailCopy ctrlClass = new createRetailCopy(std);
            ApexPages.currentPage().getParameters().put('Id', accList[0].id);
            ctrlClass.CreateRetailCopy();
        }
        Pagereference pgRef = new ApexPages.StandardController(accList[0]).view();
        return pgRef;
    }
    
    //Method to disable the checkbox if that one is selected and uncheck other
    public void disableCheckbox(){
        for(vehicleRelWrapper vrl : vehRelWrapList){
            if(vrl.vhRel.Id == selectedRec && vrl.selected){
            }
            else
                vrl.selected = false;
        }
    }
    
    //Wrapper class to display checkbox against vehicle records
    public class vehicleRelWrapper{
        public Vehicle_Relationship__c vhRel{get;set;}
        public boolean selected{get;set;}
        public vehicleRelWrapper(Vehicle_Relationship__c vr){
            vhRel = vr;
            selected = false;
        }
    }    
}