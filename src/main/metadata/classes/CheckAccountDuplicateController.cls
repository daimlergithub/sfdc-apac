/*
Created By          :    Kiran  
Created Date        :    23.02.2017
Company             :    NTT Data,Inc.
Usage               :    This functionaly will check the duplicate account records and disply the matched records
                        
                         Business Conditions :
                          * Need to click on Duplicate check button.
                   
JIRA NO             :    SFDCJP-1056,SFDCJP-995                                    
 
MODIFICATION DETAILS:
Modified by          : Venky
Modified Date        : 3/28/2017
JIRA TIcket Number : SFDCJP-2095,SFDCJP-995
Modification Details : Updated Class to Work Company account record type and if Account Id match from EP dont display records in confirmed match.
*/
public class CheckAccountDuplicateController{
public Account objAccountDeDup{get;set;}
public Account objPersonAccount{get;set;}
public Account objPersonAccount1{get;set;}
public String AddressDetails{get;set;}
public string recordType{get;set;}
public Boolean show {get;set;}
public Boolean CompanyAcc{get;set;}
public List<Account> cResult{get;set;}
public void onLineDeduplication(){  
        objPersonAccount1 = new Account();
        objPersonAccount= [select id,MD__c,Phone,Mobile2__c,Company_Name__c, Company_Name_Native_1__c , Foundation_date__c, Commercial_reg_no__c, Email__c,Email2__c,RecordTypeID,Email3__c,Salutation,Name,Work_Phone__c,Home_Phone_2__c,LastName,PersonEmail,Mobile__c,Loyalty_Card_No__c,LastName_Native_1__c,PersonBirthdate,FirstName_Native_1__c,FirstName,Individual_Home_Phone__c,PersonMobilePhone from Account WHERE Id =: apexpages.currentpage().getparameters().get('id')];
        objAccountDeDup= new Account();
        List<Account>   lstAcc = New List<Account>();    
        List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> listmess=new List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType>();
        
        if(objPersonAccount.Name !=null ) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            System.debug('@@@@@@@ response '+response );
           
            String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
           
            system.debug('recordType------------:'+recordType);
                         
                if(objPersonAccount.Recordtypeid == PersonAccountRecordTypeID){
                show = true;
                objPersonAccount1.Recordtypeid=PersonAccountRecordTypeID ;
                }else if(objPersonAccount.Recordtypeid == companyRecordTypeId ){
                CompanyAcc=true;
                    objPersonAccount1.Recordtypeid = companyRecordTypeId; 
                }
           
            if(objPersonAccount.MD__c == 'JP')
            {
                if(objPersonAccount.Email__c != null )
                {                      
                    objPersonAccount1.Email__c= objPersonAccount.Email__c;
                }
                
                if(objPersonAccount.MD__c != null && objPersonAccount.MD__c == 'JP')
                {                      
                    objPersonAccount1.MD__c = objPersonAccount.MD__c;
                }
                if(objPersonAccount.Recordtypeid == PersonAccountRecordTypeID){
                    objPersonAccount1.LastName = objPersonAccount.LastName;
                    if(objPersonAccount.FirstName != null){
                        objPersonAccount1.FirstName = objPersonAccount.FirstName;
                    }
                    
                }else if(objPersonAccount.Recordtypeid ==companyRecordTypeId){
                     objPersonAccount1.Name =  objPersonAccount.Name; 
                }
                if(objPersonAccount.LastName_Native_1__c !=  null){
                    objPersonAccount1.LastName_Native_1__c = objPersonAccount.LastName_Native_1__c;   
                }
                if(objPersonAccount.Id!=  null){
                    objPersonAccount1.Id= objPersonAccount.Id;   
                }
                
                if(objPersonAccount.Company_Name__c!=  null){
                    objPersonAccount1.Company_Name__c= objPersonAccount.Company_Name__c;   
                }
                if(objPersonAccount.Company_Name_Native_1__c !=  null){
                    objPersonAccount1.Company_Name_Native_1__c= objPersonAccount.Company_Name_Native_1__c;   
                }
                if(objPersonAccount.Foundation_date__c!=  null){
                    objPersonAccount1.Foundation_date__c= objPersonAccount.Foundation_date__c;   
                }
                if(objPersonAccount.Commercial_reg_no__c!=  null){
                    objPersonAccount1.Commercial_reg_no__c= objPersonAccount.Commercial_reg_no__c;   
                }
                
                if(objPersonAccount.LastName_Native_1__c !=  null){
                    objPersonAccount1.LastName_Native_1__c = objPersonAccount.LastName_Native_1__c;   
                }
                if(objPersonAccount.FirstName_Native_1__c !=  null){
                    objPersonAccount1.FirstName_Native_1__c = objPersonAccount.FirstName_Native_1__c;
                }
                if(objPersonAccount.Individual_Home_Phone__c !=  null){
                    objPersonAccount1.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c;
                }
                if(objPersonAccount.Home_Phone_2__c !=  null){
                    objPersonAccount1.Home_Phone_2__c = objPersonAccount.Home_Phone_2__c ;
                }
                if(objPersonAccount.Work_Phone__c !=  null){
                    objPersonAccount1.Work_Phone__c = objPersonAccount.Work_Phone__c;
                }
                if(objPersonAccount.Phone!=  null){
                    objPersonAccount1.Phone= objPersonAccount.Phone;
                }
                if(objPersonAccount.Mobile2__c !=  null){
                    objPersonAccount1.Mobile2__c = objPersonAccount.Mobile2__c;
                }
                if(objPersonAccount.Email2__c !=  null){
                    objPersonAccount1.Email2__c = objPersonAccount.Email2__c;
                }
                if(objPersonAccount.Email3__c !=  null){
                    objPersonAccount1.Email3__c = objPersonAccount.Email3__c;
                }
                
                if(objPersonAccount.Mobile__c!= null )
                {              
                    objPersonAccount1.Mobile__c= objPersonAccount.Mobile__c;
                }
                               
            }
            system.debug('objPersonAccount1%%%%%%%' + objPersonAccount1);
            response =  UtilWebservice.validateCustomerDetails(objPersonAccount1); 
            
            System.debug('@@@@@@@@@@ response '+response);
            //System.debug('@@@@@@@@@@ response '+response.CustomerIdentificationResponseMessage[0].Customer);
            if(response != null){
                system.debug('##############'+response );
                if(response.CustomerIdentificationResponseMessage!=null)
                {
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                    {
                        objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Name!=null)
                    {
                        objAccountDeDup.Name=response.CustomerIdentificationResponseMessage[0].Customer.Name;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Firstname !=null)
                    {
                        objAccountDeDup.Firstname=response.CustomerIdentificationResponseMessage[0].Customer.Firstname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.vin!=null)
                    {
                        objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.vin;
                    }
                    system.debug('&&& :'+response.CustomerIdentificationResponseMessage[0].Customer.Email_xc);
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Email_xc != null)
                    {   
                        objAccountDeDup.Email__c =response.CustomerIdentificationResponseMessage[0].Customer.Email_xc;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    {
                        objAccountDeDup.Mobile__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    }
                    // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    // {
                    //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    // }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   
                        AddressDetails =response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                   
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                    if(objPersonAccount.Id != objAccountDeDup.Id)
                    {
                     lstAcc = [Select Name,FirstName,LastName,Phone ,Email__c,Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c From Account where  LastName=:objAccountDeDup.LastName OR Name=:objAccountDeDup.Name];// and FirstName =: objPersonAccount.FirstName];
                    }              
                 }
                cResult = lstAcc;  
                System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                }
              //  show = true;
                if(response.CustomerIdentificationResponseMessage ==null)
                {
                 //   show = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                }
              
            }
            if(response == null)
            {
               //  show = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }   
    }
}