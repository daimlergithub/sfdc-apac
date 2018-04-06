/**
** Controller Class for Account Creation page AddressSearchValidationCDM.
** OverRides Standard Account Creation "New" Button For India Market.
** Creates new Account.
** Created By: Shashi Goswami
** Date: 2018/03/15
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
    
    //This variable are used to hold all the account list and display list and boolean variable are used to hide and enable the buttons in the section        
    public List<account> DedupAccountList{get;set;}     
    public list<account> displayAccList{get;set;}       
    public integer startindex{get;set;}     
    public integer LastIndex{get;set;}      
    public boolean first{get;set;}      
    public boolean Last{get;set;}       
    public boolean next{get;set;}       
    public boolean previous{get;set;}       
    
    //Variable to hold JSON response from Informatica/CDM
    public JSON2ApexCustomerFromCDM custSearch{get;set;}
    //public List<JSON2ApexCustomerFromCDM> custSearch{get;set;}
    public Boolean showCDM {get;set;}
    public Boolean one {get;set;}
    public Boolean deduplicated {get;set;}
    
    //ID proof format
    public String panFormat = '^[A-Za-z]{5}[0-9]{4}[A-z]{1}$';
    public String aadharFormat = '^[1-9]{1}[0-9]{11}$';
    public String gstinFormat = '^[0-9]{2}[A-Za-z]{5}[0-9]{4}[A-Za-z]{1}[0-9]{1}[A-Za-z]{1}[0-9]{1}$'; 
    
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
        DedupAccountList= new List<account>();      
        displayAccList=new list<account>();     
        startIndex=0;               
        last=false;     
        previous=false;     
        first=false;        
        next=false;  
        showCDM=false;
        deduplicated = false;
    }
    
    public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
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
    
    /*
    Online Deduplication Code for India Market added by Shashi
    */
    public object onLineDeduplicationIN(){ 
        displayAccList.clear();     
        DedupAccountList.clear();
        Boolean errorFlag=false;
        Continuation con=null;
        
        //Phone format check-while online deduplication 
        Boolean homePhoneFormat= false;
        Boolean workPhoneFormat= false;
        Boolean mobilePhoneFormat= false;
        PhoneNumberFormatCheck formatcheck = new PhoneNumberFormatCheck();   
        objAccount.RecordTypeId = recordTypeId;   
        phoneFieldConcatIN();   
        homePhoneFormat = formatcheck.homePhoneFieldFormatIN(hmCountryCode,hmAreaCode,hmphoneNumber);
        workPhoneFormat = formatcheck.workPhoneFieldFormatIN(wkCountryCode,wkAreaCode,wkphoneNumber);
        mobilePhoneFormat = formatcheck.mobilePhoneFieldFormatIN(mbCountryCode,mbphoneNumber);
     	
        //Pan format check 
        if(objAccount.PAN__c != null && string.isnotblank(objAccount.PAN__c) && !Pattern.matches(panFormat,objAccount.PAN__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.PAN_Format));
        	errorFlag=true;
        }
        //Aadhar number format check
        if(objAccount.Aadhaar__c != null && string.isnotblank(objAccount.Aadhaar__c) && !Pattern.matches(aadharFormat,objAccount.Aadhaar__c )){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Aadhar_Format));
        	errorFlag=true;
        }
        //GSTIN format check
        if(objAccount.GSTN_Number__c != null && string.isnotblank(objAccount.GSTN_Number__c) && !Pattern.matches(gstinFormat,objAccount.GSTN_Number__c )){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.GSTIN_Format));
        	errorFlag=true;
        }
        
        if(Recordtype!=Label.PersonAccount && Recordtype!=Label.Company){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RecordTypeError));       
            errorFlag=true;
        }
        
        else if(Recordtype== Label.PersonAccount && (string.isblank(objAccount.firstName) || string.isblank(objAccount.Lastname) || 
                (string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber))))  {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountDedupValidation));       
            errorFlag=true;
        }
        
        else if(Recordtype==Label.Company && (string.isblank(objAccount.name) || 
                (string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber)))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CompanyAccountDedupValidation ));       
            errorFlag=true;
        }
        else if(!homePhoneFormat || !workPhoneFormat || !mobilePhoneFormat ){
            errorFlag=true;
        }
        
        if(!errorFlag){
                        
            last=false;     
            previous=false;     
            first=false;        
            next=false;     
            deduplicated = true; 
                
            phoneFieldConcatIN();
            String EndUrl=generateCDMEndPointURL();
            CustomLogUtil.CustomLoggingEntry('Search End Url' + endurl );
            System.debug('Search End Url debug:'+endurl);
            try{    
                if(label.New_Component=='true'){
                    con = new Continuation(120);     
                    con.continuationMethod='processResponse';
                    this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                    system.debug('request label: '+ this.requestLabel);
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
                }
            } catch (Exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
                 CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
            }                   
        }
        return con;
    }
	
    
     public String generateCDMEndPointURL(){
        String endUrl='';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                endUrl+=mapURLs.get(str).Informatica_URL__c+'?';
            }
        }
        
        if(recordType == 'Person Account')
        {
            endUrl+='inp_JSON_FirstName='+(string.isnotblank(objAccount.firstname)?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
            endUrl+='&inp_JSON_LastName='+(string.isnotblank(objAccount.LastName)?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
            endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
            endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c )?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
            endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
            endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
            endUrl+='&inp_JSON_PAN='+(string.isnotblank(objAccount.PAN__c)?EncodingUtil.URLENCODE(objAccount.PAN__c,'UTF-8'):''); 
            endUrl+='&inp_JSON_Aadhar='+(string.isnotblank(objAccount.Aadhaar__c)?EncodingUtil.URLENCODE(objAccount.Aadhaar__c,'UTF-8'):'');
        }
        else if(recordType == 'Company'){
            endUrl+='inp_JSON_CompanyName='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
            endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
            endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
            endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
            endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
            endUrl+='&inp_JSON_GSTIN='+(string.isnotblank(objAccount.GSTN_Number__c)?EncodingUtil.URLENCODE(objAccount.GSTN_Number__c,'UTF-8'):'');
            endUrl+='&inp_JSON_CIN='+(string.isnotblank(objAccount.CIN_Number__c)?EncodingUtil.URLENCODE(objAccount.CIN_Number__c,'UTF-8'):'');
        }
        return endUrl;
    } 
    

    public Object processResponse() {
            HttpResponse res = Continuation.getResponse(this.requestLabel);
            System.debug('res*** ' + res);
          // Set the result variable that is displayed on the Visualforce page
        try{
            this.requestLabel = res.getBody();
            CustomLogUtil.CustomLoggingEntry('Continuation Response Body' + res.getBody());
            if(res.getbody()=='{}'){
                showCDM=false;
                CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +res.getbody());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
            }
            else if(res.getStatusCode()==500)
            {
                showCDM=false;
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.The_request_could_not_reach_server));
            }
            else
            {
                custSearch=JSON2ApexCustomerFromCDM.parse(res.getbody());
                system.debug('custSearch:'+custSearch);
                list<string> set_accounts= new list<string>();
                For(JSON2ApexCustomerFromCDM.Out_JSON_UCID_List cust : custSearch.out_JSON_UCID_List){
                    system.debug('cust:'+cust);
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                    if(string.valueof(m.get(Label.AdminClientNum))!=null)
                        set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                }
                if(set_accounts.size()>0){
                    showCDM=true;
                    string querytxt='select id,firstname,UCID__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c from account where <Search> in (';
                    querytxt=querytxt.replace('<Search>',label.SearchKey); 
                    set<String> valueSet = new set<String>();
                    for(Integer i=0; i<set_accounts.size(); i++){
                        valueSet.add('\'' + String.escapeSingleQuotes(set_accounts[i]) + '\'');
                    }
                    if (valueSet.isEmpty()){
                        valueSet.add('\'\'');
                    }
                    querytxt=querytxt+ String.join(new list<String>(valueSet),',') + ') limit ' +label.limitsize;
                    for(account acc :database.query(querytxt)){
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company')
                        DedupAccountList.add(acc);
                    }
                    last=false;     
                    previous=false;     
                    first=false;        
                    next=false;
                    LastIndex=DedupAccountList.size();      
                    First();
                    If(displayAccList.size()==0)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                    else if(displayAccList.size()==1)
                        one = true;
                    else if(displayAccList.size()>1)
                        one = false;
                }
            }
        }
        catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
        }
        // Return null to re-render the original Visualforce page
        return null;
    }

    
    /*
    Method to help us move to next page and setting the boolean for the respective buttons   
    and are used to give paginated data after the search in CDM                                                          
    */      
    public void next(){     
        displayAccList.clear();     
        startIndex=startIndex+10;       
        for(integer i=startIndex;i<(LastIndex<(startIndex+10)?lastIndex:startIndex+10); i++){       
            displayAccList.add(DedupAccountList[i]);        
        }       
        if(LastIndex<(startIndex+10) ){     
            Last=true;      
            next=true;      
            first=false;        
            previous=false;     
        }       
        else{       
            Last=false;     
            next=false;     
            first=false;        
            previous=false;     
        }                   
    }     
    /*      
    Method: To show Previous page record       
    */      
    public void previous(){     
        displayAccList.clear();     
        startIndex=startIndex-10;       
        for(integer i=startIndex;i<startIndex; i++){        
            displayAccList.add(DedupAccountList[i]);        
        }       
        if(startIndex<10 ){     
            Last=false;     
            next=false;     
            first=true;     
            previous=true;      
        }           
        else{       
            Last=false;     
            next=false;     
            first=true;     
            previous=true;      
        }               
    }      
    /*      
    method to help us to go to last page        
    */      
    public void last(){     
        displayAccList.clear();     
        startIndex=(lastindex/10)*10;       
        for(integer i=startIndex;i<(LastIndex<(startIndex+10)?lastIndex:startIndex+10); i++){       
            displayAccList.add(DedupAccountList[i]);        
        }       
                
            Last=true;      
            next=true;      
            first=false;        
            previous=false;                       
    }       
    /*      
    Method :Helps us to go to the first page   
    */      
    public void First(){        
        displayAccList.clear();     
        startIndex=0;       
       for(integer i=startIndex;i<(LastIndex<=10?lastIndex:startIndex+10); i++){        
            displayAccList.add(DedupAccountList[i]);        
        }       
        if(LastIndex>10){       
            last=false;     
            next=false;     
            first=true;     
            previous=true;      
        }       
        else{       
        last=true;      
            next=true;      
            first=true;     
            previous=true;      
                
        }                          
    }
    
}