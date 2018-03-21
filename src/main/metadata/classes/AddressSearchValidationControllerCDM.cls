/**
** Controller Class for Account Creation page AddressSearchValidationCDM.
** OverRides Standard Account Creation "New" Button For India Market.
** Creates new Account.
** Created By: Shashi Goswami
** Date: 12018/03/15
**/
public class AddressSearchValidationControllerCDM
{
    //variables used in the page.
    ApexPages.StandardController controller;
    
    public string selectedRecordType{get;set;}
    public Account objAccount{get;set;}
    public Account objPersonAccount{get;set;}
    public Contact objContact{get; set;}
    public boolean refreshPage {get; set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    public id recordTypeId;
    public Boolean show {get;set;}
    public Address__C AddressObj {get;set;}
    public boolean Readonly {get;set;}
    public Boolean Editmode {get;set;}
    public Boolean personrectype {get;set;}
    public Boolean companyrectype {get;set;}
    
    public String requestLabel{get;set;}
    public String LanguageSelected{get; set;}
    public List<SelectOption> lstProvince{get; set;}
    //public List<SelectOption> lstCountry{get; set;}        
    public List<SelectOption> lstDistrict{get; set;}
    Public Boolean Validation;
    
    public String country {get; set;}
    public String district {get;set;}
    public String subdistrict {get;set;}
    public String zip {get;set;}
    public String province {get;set;}
    public boolean IsForeignNational{get; set;}
    public String mbCountryCode{get;set;}
    public String mbphoneNumber{get;set;}
    public String wkAreaCode{get;set;}
    public String hmAreaCode{get;set;}
    public String mbAreaCode{get;set;}
    public String hmCountryCode{get;set;}
    public String hmphoneNumber{get;set;}
    public String wkCountryCode{get;set;}
    public String wkphoneNumber{get;set;}
    public String faxCountryCode{get;set;}
    public String faxphoneNumber{get;set;}
    public String faxAreaCode{get;set;} 
    Public User u{get;set;}
    
    public String market{get;set;}
    public boolean hAreaBoolean{get;set;}
    Public boolean wAreaBoolean{get;set;}
    Public boolean fAreaBoolean{get;set;}
    
    // Constructor
    public static String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
    public static String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
    
    public AddressSearchValidationControllerCDM(ApexPages.StandardController controller){
        objAccount= new Account();
        objPersonAccount= new Account();
        objContact=new contact();
        AddressObj = new Address__c();
        accountOwner=userinfo.getname();
        
        system.debug('>>>>>>@##Readonly'+Readonly);
        system.debug('<<<<<<<!@!#Editmode'+Editmode);
        
        Readonly=false;
        Editmode=true;
        companyrectype = false;
        personrectype = false;
        IsForeignNational=false;
        // refreshPage = false;        
        u = [SELECT Id,Market__c,ContactId  FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        objAccount.Market__c=market;        
        AddressObj.Market__c=market;        
        objPersonAccount.Market__c=market; 
        hAreaBoolean=false;
        wAreaBoolean=false;
        fAreaBoolean=false;  
        
        if(market==Label.IN)
        {
            mbCountryCode='+91';
            hmCountryCode='+91';
            wkCountryCode='+91';
            faxCountryCode='+91';
            AddressObj.Country__c='India';
            objAccount.Market__c=market;
            LoadProvince();
        }
        
    }
    
    public void LoadProvince()
    {  
        
        if(LanguageSelected=='' || LanguageSelected ==null )     
            LanguageSelected ='English';
        lstProvince=new List<SelectOption>();
        Set<string> setProvinces = new set<string>();
        lstProvince.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempProvince : [select id,Province__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Market__c=:market order by Province__c asc])
        {
            if(!setProvinces.contains(lsttempProvince.Province__c))
            {
                lstProvince.add(new SelectOption(lsttempProvince.Province__c,lsttempProvince.Province__c));
                setProvinces.add(lsttempProvince.Province__c);
            }
        }
        lstDistrict=new List<SelectOption>();
    }
    
    //Fills District based on Province selected
    public void LoadDistrict()
    { 
        if(LanguageSelected=='' || LanguageSelected ==null )        
            LanguageSelected ='English';
        lstDistrict=new List<SelectOption>();
        Set<string> setDistricts = new set<string>();
        lstDistrict.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempDistrict : [select id,District__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Market__c=:market and Province__c=:province order by District__c asc])
        {
            
            //Added null check for india market as city/district is not a picklist for India
            if (lsttempDistrict.District__c == null){
                continue;
            }
            
            if(!setDistricts.contains(lsttempDistrict.District__c))
            {
                lstDistrict.add(new SelectOption(lsttempDistrict.District__c,lsttempDistrict.District__c));
                setDistricts.add(lsttempDistrict.District__c);
            }
        }
    }
    
    public void ShowHideFields()
    {
        if(market == System.Label.IN)
        {
            if(AddressObj.Foreign_Nationals__c == true ){
                
                IsForeignNational=true;
                AddressObj.Country__c = '--None--';
                province='';
                district='';
                
            }
            else{
                IsForeignNational=false;
            }
        }
    }
    
    // Cancel button
    public PageReference cancel(){
        PageReference pageRef; 
        pageRef = new PageReference('/001/o');
        return PageRef;
    }
    
    // Assign selected Recordtype value based on select list
    public void selectedRecordTypeValue()
    {
        selectedRecordType = recordType;       
        System.debug('recordType*********'+recordType);
        System.debug('selectedRecordType *********'+selectedRecordType);
        // Added by Venky changes related to SFDCJP-2505
        u = [SELECT Id,Market__c,ContactId  FROM User WHERE Id=:UserInfo.getUserId()] ;
        
        market = u.Market__c;
    }
    
    public Boolean checkForeignNational(){
        if(RecordType == 'Person Account'){
            system.debug('Enetered checkforeign 1');
            if(AddressObj.Country__c != 'India' && AddressObj.Country__c != '--None--' && AddressObj.Foreign_Nationals__c == false){
                system.debug('Enetered checkforeign if');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Foreign_National_Should_Be_True));     
                return false;
            }
            else if(AddressObj.Country__c == 'India' && AddressObj.Foreign_Nationals__c == true){
                system.debug('Enetered checkforeign else');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Foreign_National_Should_Be_False));     
                return false;
            }
        }
        else if(RecordType == 'Company'){
            system.debug('Enetered checkforeign 2');
            if(AddressObj.Country__c != 'India' && AddressObj.Country__c != '--None--'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Company_Record_Country));     
                return false;
            }
        }
        return true;
    }
    //Adding for India (By Shashi)
    
    public pagereference saveAccountIN()       
    {   
        
        if(AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--')      
        {       
            
            if ((string.isnotblank(AddressObj.Address_Line_1__c) ||     
                 string.isnotblank(AddressObj.Address_Line_2__c) || 
                 string.isnotblank(AddressObj.Address_Line_3__c) ||
                 (string.isnotblank(province) && province!= '--Select--') || 
                 string.isnotblank(district) ||  
                 string.isnotblank(Zip)) && string.isnotblank(addressObj.Country__c) && addressObj.Country__c !='--Select--' ){
                     system.debug('Enetered type null');
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AddressTypeValidationIN));       
                     Validation = true; 
                 }
            
            else{
                system.debug('Enetered type not null');
                if(SaveAccountDetailsIN() && checkForeignNational())      
                {   
                    system.debug('Enetered type not null if');
                    PageReference pageRef = new PageReference('/'+objAccount.Id);       
                    return PageRef;                 
                }       
            }
        }
        
        // Save record with Address details Validating the Address Details 
        boolean check=false;
        If(AddressObj.Address_Type__c != null)      
        {       
            /* if(AddressObj.RecordType.DeveloperName == 'Person Account'){
if(AddressObj.Country__c != 'India' && AddressObj.Country__c != '--None--' && AddressObj.Foreign_Nationals__c == false){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Foreign_National_Should_Be_True));     
}
else if(AddressObj.Country__c == 'India' && AddressObj.Foreign_Nationals__c == true){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Foreign_National_Should_Be_False));     
}
}
else if(AddressObj.RecordType.DeveloperName  == 'Company'){
if(AddressObj.Country__c != 'India' && AddressObj.Country__c != '--None--'){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Company_Record_Country));     
}
}*/
            try     
            {       
                if(recordType == Label.Company)                     
                    recordTypeId =RecordTypeAccessService.getRecordTypeId('Account',Label.Company);      
                else        
                    recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount); 
                
                
                objAccount.RecordTypeId = recordTypeId;         
                
                //Add province
                if(province!='' && province!='--Select--')      
                    addressobj.Province__c=province;        
                if(province!='' && province!='--Select--')      
                    addressobj.Province__c=province;        
                if(district!='' && district!='--Select--')      
                    addressobj.District__c=district;                
                if(zip!='')     
                    addressobj.ZipCode__c=zip; 
                
                
                refreshPage = true;     
                if(SaveAccountDetailsIN() && checkForeignNational())      
                {           
                    AddressObj.Customer__c = objAccount.id; 
                    AddressObj.Preferred__c=true; 
                    DMLManagerService.insertAsSystem(AddressObj);                              
                    //insert AddressObj;      
                    PageReference pageRef = new PageReference('/'+objAccount.Id);       
                    return PageRef;     
                }              
            }       
            catch(DMLException e)       
            {       
                
                refreshPage = false;        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));       
                CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getDMlMessage(0));              
            }               
        } 
        return null;       
    }
    
    
    //Added for India (By Shashi)
    public void phoneFieldConcatIN(){
        
        if(String.isBlank(hmphoneNumber))  objAccount.Individual_Home_Phone__c='';       
        else if(hmCountryCode!='' && hmphoneNumber!='' && (hmCountryCode==label.INPhoneCountryCode || hmCountryCode==label.MYPhoneCountryCode))  objAccount.Individual_Home_Phone__c=hmCountryCode+hmAreaCode+hmphoneNumber;                                     
        else objAccount.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;                                    
        
        if( String.isBlank(wkphoneNumber)) objAccount.Work_Phone__c='';     
        else if(wkCountryCode!='' && wkphoneNumber!='' && (wkCountryCode==label.INPhoneCountryCode || wkCountryCode==label.MYPhoneCountryCode)) objAccount.Work_Phone__c=wkCountryCode+wkAreaCode+wkphoneNumber;                                         
        else objAccount.Work_Phone__c=wkCountryCode+wkphoneNumber;      
        
        if((String.isBlank(mbphoneNumber)) )  objAccount.Mobile__c='';         
        else if(mbCountryCode!='' && mbphoneNumber!='') objAccount.Mobile__c=mbCountryCode+mbphoneNumber;        
        else objAccount.Mobile__c='';          
        
        if((String.isBlank(faxphoneNumber))) objAccount.fax='';       
        else if(faxCountryCode!='' && faxphoneNumber!='' && (faxCountryCode==label.INPhoneCountryCode || faxCountryCode==label.MYPhoneCountryCode)) objAccount.fax=faxCountryCode+faxAreaCode+faxphoneNumber;        
        else objAccount.fax=faxCountryCode+faxphoneNumber;      
        
    }
    
    //Added for India (By Shashi)
    public void updateGeneratedBy(){
        if(Userinfo.getUserType() == 'PowerPartner'){
            objAccount.Generated_by__c= 'Dealer';
        }
        else 
            objAccount.Generated_by__c= 'MBIL';
    }
    
    // Adding for India by Shashi 
    public boolean SaveAccountDetailsIN()       
    {       
     Boolean homePhoneFormat= false;
     Boolean workPhoneFormat= false;
     Boolean mobilePhoneFormat= false;
     Boolean faxFormat= false;
     PhoneNumberFormatCheck formatcheck = new PhoneNumberFormatCheck();   
     if(recordType == label.Company)                     
         recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.Company);      
     else        
         recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);     
     
     objAccount.RecordTypeId = recordTypeId;   
     phoneFieldConcatIN();   
     if(recordType == Label.PersonAccount){
         objAccount.status__C = Label.ProspectStatus;
         faxFormat = true;
     }
     else if(recordType == Label.Company)
     {
         faxFormat = formatcheck.faxFieldFormatIN(faxCountryCode,faxAreaCode,faxphoneNumber);
     }   //end code here modification by Honey     
     homePhoneFormat = formatcheck.homePhoneFieldFormatIN(hmCountryCode,hmAreaCode,hmphoneNumber);
     workPhoneFormat = formatcheck.workPhoneFieldFormatIN(wkCountryCode,wkAreaCode,wkphoneNumber);
     mobilePhoneFormat = formatcheck.mobilePhoneFieldFormatIN(mbCountryCode,mbphoneNumber);
     
     updateGeneratedBy();
     try        
     {    
         if(homePhoneFormat && workPhoneFormat && mobilePhoneFormat && faxFormat){  
             DMLManagerService.upsertAsSystem(objAccount);  
             refreshPage = true;
             return true; 
         }
         else 
             return false;
     }       
     catch(DMLException e)       
     {       
         
         refreshPage = false;   
         if(e.getdmlMessage(0).contains('bad field') ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Remove_FirstName_LastName_for_company));
             CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
         }
         else{               
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0))); 
             CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
         }               
         return false;       
     }       
     //return false;       
    }
    
    //Added for India
    public void checkcountrycodeindia(){
        wAreaBoolean=false;
        fAreaBoolean=false;
        hAreaBoolean=false;
        
        if(String.isNOTBlank(faxCountryCode) ? faxCountryCode!=label.INPhoneCountryCode?true:false:false) fAreaBoolean=true;
        if(String.isNOTBlank(hmCountryCode) ? hmCountryCode!=label.INPhoneCountryCode?true:false:false) hAreaBoolean=true;
        if(String.isNOTBlank(wkCountryCode) ? wkCountryCode!=label.INPhoneCountryCode?true:false :false) wAreaBoolean=true;
        
    }
    
}