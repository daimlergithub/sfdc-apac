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
    public Boolean AutoFill {get;set;}
    public Boolean DisplayAutoFill {get;set;}
    public Boolean sendAddress;
    public map<string,string> labelNvalue=new map<string,string>(); 
    public String TouchPoint{get;set;} 
    public Map<Id, String> accIdToAddressMap{get;set;}
    public string selectedRecordType{get;set;}
    public Account objAccount{get;set;}
											 
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
    public List <SelectOption> lstDistrict {get;set;}
    public List < SelectOption > lstSubDistrict {get;set;}
    public List < SelectOption > lstCity {get;set;}
    public String requestLabel{get;set;}
    public String LanguageSelected{get; set;}
    public List<SelectOption> lstProvince{get; set;}
    //public List<SelectOption> lstCountry{get; set;}        
    public boolean Address_Validated_Flag {get;set;}
    Public Boolean Validation;
    public String addresspicklist {get;set;}
    public String country {get; set;}
    public String district {get;set;}
    public String city {get;set;}
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
    public boolean firstsave {get;set;}
    public boolean secondsave {get;set;}
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
    public set<string> codes = new set<string>();     
    
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
	public Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
    public Map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();												 
	public Boolean jpSwitchEnabledFlag ;
    public AddressSearchValidationControllerCDM(ApexPages.StandardController controller){
		AutoFill = false;				 
        objAccount= new Account();
										
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
        u = [SELECT Id,Market__c,ContactId,Contact.AccountId  FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        objAccount.Market__c=market;        
        AddressObj.Market__c=market;   
										   
        hAreaBoolean=false;
        wAreaBoolean=false;
        fAreaBoolean=false;  
        
		if(market == Label.JP){
            if(u.ContactId !=null){
                TouchPoint='Dealer Outlet';
            }
         }						
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
        //Added for Turkey Market
        if (market == Label.TR) {
            firstsave = false;
            secondsave = true;
            mbCountryCode = Label.TRPhoneCountryCode;
            hmCountryCode = Label.TRPhoneCountryCode;
            wkCountryCode = Label.TRPhoneCountryCode;
            faxCountryCode = Label.TRPhoneCountryCode;
            AddressObj.Country__c = Label.TRCountry;
            objAccount.Country__c = Label.TRCountry;
            objAccount.MD__C = market;
            objAccount.Status__c = Label.ProspectStatus;
           
            lstCity = new List < SelectOption > ();
            Set < string > setCities = new set < string > ();
            lstCity.add(new SelectOption('--Select--', '--Select--'));
            system.debug('-------------'+market+' Market------------------------');
            for (RegionMasterInfo__c lsttempProvince: [select id, City__c from RegionMasterInfo__c where Market__c =: market order by City__c asc]) {
                if (!setCities.contains(lsttempProvince.City__c)) {
                    lstCity.add(new SelectOption(lsttempProvince.City__c, lsttempProvince.City__c));
                    setCities.add(lsttempProvince.City__c);
                }
            }
            lstProvince = new List < SelectOption > ();
            lstDistrict = new List < SelectOption > ();
            district = '--Select--';
            province = '--Select--';
             for(PhoneAreaCode__c pc: [select id,name,Country_Code__c,Phone_Area_Code__c from PhoneAreaCode__c where Country_Code__c=:Label.TRPhoneCountryCode])
            {
                codes.add(pc.Phone_Area_Code__c);
            }
        } else {
            firstsave = false;
            secondsave = true;
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
		//SN20180723
		jpSwitchEnabledFlag = false;
		if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('CustomerSearchRuleIem')){
            jpSwitchEnabledFlag = jpSwitchMap.get('CustomerSearchRuleIem').Enable_Flag__c;
        }
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
        system.debug('-------------'+LanguageSelected+' language, '+market+' Market------------------------');
        if(market=='IN'){
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
        else if(market=='TR')//added for Turkey market
        {
            for (RegionMasterInfo__c lsttempProvince: [select id, Province__c from  RegionMasterInfo__c where Market__c =: market and city__c =: city order by Province__c asc]) 
            {
                if (!setProvinces.contains(lsttempProvince.Province__c)) 
                {
                    lstProvince.add(new SelectOption(lsttempProvince.Province__c,lsttempProvince.Province__c));
                    setProvinces.add(lsttempProvince.Province__c);
                }
            }
            district = '--Select--';
            
        }
    }
    
    //Fills District based on Province selected
    public void LoadDistrict()
    { 
        if(LanguageSelected=='' || LanguageSelected ==null )        
            LanguageSelected ='English';
        lstDistrict=new List<SelectOption>();
        Set<string> setDistricts = new set<string>();
        lstDistrict.add(new SelectOption('--Select--','--Select--'));
        if(market=='IN'){
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
        else if(market=='TR')//added for Turkey market
        {
            for (RegionMasterInfo__c lsttempDistrict: [select id, District__c from RegionMasterInfo__c where Market__c =: market and Province__c =: province and city__c =:city order by District__c asc]) 
            {   if (!setDistricts.contains(lsttempDistrict.District__c)) 
                { lstDistrict.add(new SelectOption(lsttempDistrict.District__c,lsttempDistrict.District__c));
                  setDistricts.add(lsttempDistrict.District__c);
                 }
            }
        }
        
    }
    
    public void ShowHideFields()
    {
        if(market == System.Label.IN ||market == System.Label.TR)
        {
            if(AddressObj.Foreign_Nationals__c == true ){
                
                IsForeignNational=true;
                if(market == System.Label.IN || AddressObj.Country__c == Label.TRCountry)
                    AddressObj.Country__c = '--None--';
                province='';
                district='';
                zip = '';
                city = '';

            }
            else if (market == System.Label.TR && AddressObj.Country__c != Label.TRCountry) {
                IsForeignNational = true;
                district = '';
                province = '';
                zip = '';
                city = '';
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
		if(market == Label.JP){
			if(u.ContactId !=null && selectedRecordType   =='Company')
			{
			TouchPoint=Label.Others_Data_Source; 								  
			} 
			if(u.ContactId !=null && selectedRecordType   =='Person Account')
			{
			  TouchPoint=Label.Dealer_Outlet; 																
			}  
		}
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
    
    //Social Id Validation for Turkey Market
     Public boolean validateSocialIdTR(String val) {
       Integer x1 = 0, x2 = 0, x3 = 0, x4 = 0, x5 = 0, x6 = 0, x7 = 0, x8 = 0, x9 = 0, x10 = 0, x11 = 0;
        String socId;
        if(val == 'SocId')
            socId = String.valueof(objAccount.Social_Id__c);
        else
            socId = String.valueof(objAccount.Vat_No__c);
        if (socId != null && socId != '' && string.valueof(socId).length() == 11 && string.valueof(socId).isNumeric()) {
            x1 = Integer.valueOf(socId.mid(0, 1));
            x2 = Integer.valueOf(socId.mid(1, 1));
            x3 = Integer.valueOf(socId.mid(2, 1));
            x4 = Integer.valueOf(socId.mid(3, 1));
            x5 = Integer.valueOf(socId.mid(4, 1));
            x6 = Integer.valueOf(socId.mid(5, 1));
            x7 = Integer.valueOf(socId.mid(6, 1));
            x8 = Integer.valueOf(socId.mid(7, 1));
            x9 = Integer.valueOf(socId.mid(8, 1));
            x10 = Integer.valueOf(socId.mid(9, 1));
            x11 = Integer.valueOf(socId.mid(10, 1));
            Integer temp1 = ((x1 + x3 + x5 + x7 + x9) * 7) - (x2 + x4 + x6 + x8);
            Integer temp2 = math.mod(temp1, 10);
            Integer temp3 = (x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10);
            Integer temp4 = math.mod(temp3, 10);
            if (x10 == temp2 && x11 == temp4) {
                return true;
            } else return false;
        } else
            return false;
       // return false;
    }
    //VAT No Validation for Turkey Market
    Public boolean validateVATNoTR() {
        Integer x1 = 0, x2 = 0, x3 = 0, x4 = 0, x5 = 0, x6 = 0, x7 = 0, x8 = 0, x9 = 0;
        Integer x11 = 0, x22 = 0, x33 = 0, x44 = 0, x55 = 0, x66 = 0, x77 = 0, x88 = 0, x99 = 0,V_Last_Digit = 0, toplam = 0;
        String socId = String.valueof(objAccount.Vat_No__c);
        system.debug(socId+'------>');
        if (objAccount.Vat_No__c != null && socId != '' && string.valueof(objAccount.Vat_No__c).length() == 10 && string.valueof(objAccount.Vat_No__c).isNumeric()) {
            x1 = Math.Mod((Integer.valueOf(socId.mid(0, 1))+9),10);
            x2 = Math.Mod((Integer.valueOf(socId.mid(1, 1))+8),10);
            x3 = Math.Mod((Integer.valueOf(socId.mid(2, 1))+7),10);
            x4 = Math.Mod((Integer.valueOf(socId.mid(3, 1))+6),10);
            x5 = Math.Mod((Integer.valueOf(socId.mid(4, 1))+5),10);
            x6 = Math.Mod((Integer.valueOf(socId.mid(5, 1))+4),10);
            x7 = Math.Mod((Integer.valueOf(socId.mid(6, 1))+3),10);
            x8 = Math.Mod((Integer.valueOf(socId.mid(7, 1))+2),10);
            x9 = Math.Mod((Integer.valueOf(socId.mid(8, 1))+1),10);
            V_Last_Digit = Integer.valueOf(socId.mid(9, 1));
            x11 = Math.Mod((x1*512),9);
            x22 = Math.Mod((x2*256),9);
            x33 = Math.Mod((x3*128),9);
            x44 = Math.Mod((x4*64),9);
            x55 = Math.Mod((x5*32),9);
            x66 = Math.Mod((x6*16),9);
            x77 = Math.Mod((x7*8),9);
            x88 = Math.Mod((x8*4),9);
            x99 = Math.Mod((x9*2),9);
            if(x1 != 0 &&  x11 == 0) x11 = 9;
            if(x2 != 0 &&  x22 == 0) x22 = 9;
            if(x3 != 0 &&  x33 == 0) x33 = 9;
            if(x4 != 0 &&  x44 == 0) x44 = 9;
            if(x5 != 0 &&  x55 == 0) x55 = 9;
            if(x6 != 0 &&  x66 == 0) x66 = 9;
            if(x7 != 0 &&  x77 == 0) x77 = 9;
            if(x8 != 0 &&  x88 == 0) x88 = 9;
            if(x9 != 0 &&  x99 == 0) x99 = 9;
            toplam = x11 + x22 + x33 + x44 + x55 + x66 + x77 + x88 + x99;
            
            if (Math.mod(toplam,10) == 0)  toplam = 0;
            else toplam = (10 - Math.mod(toplam,10));
            if(toplam == V_Last_Digit) return true;
            else return false;
        } else
            return false;
        //return false;
    }
 
    /**  Save Account based on two scenarios        
     * 1. With Validated Address information record.     
     * 2.Without Address record.     
     **  Created By: Hildaa    
     **  Date:
     **/
    public pagereference saveAccountTR() {
        if (addresspicklist != null)
            AddressObj.Address_Type__c = addresspicklist;
        Validation = false;
        //MT 39
        if ((objAccount.Name == null || objAccount.Data_Source__c == null || objAccount.Status__c == null || string.isblank(wkphoneNumber)) && Recordtype == Label.Company) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CompanyAccountSearchErrorMessage));
            validation = true;
        } else if ((objAccount.FirstName == null || objAccount.LastName == null || objAccount.Data_Source__c == null || objAccount.Personal_Agreement__c == null || objAccount.Status__c == null ) && Recordtype == Label.PersonAccount) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchErrorMessage));
            validation = true;
        } else if (!string.isblank(objAccount.Social_Id__c) && !validateSocialIdTR('SocId')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SocialIdError));
            validation = true;
        }
        else if (!string.isblank(objAccount.Vat_No__c) && (String.valueof(objAccount.Vat_No__c).length() == 11 && !validateSocialIdTR('VatNo'))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SocialIdError));
                    validation = true;
            }
            else if (!string.isblank(objAccount.Vat_No__c) && String.valueof(objAccount.Vat_No__c).length() != 11 && !validateVATNoTR() ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.VATNOError));
                    validation = true;
            }
        /* else if (string.isblank(objAccount.Email__c) && objAccount.Opt_In_Email__c && ((recordType != label.Company && objAccount.personal_agreement__c != 'Yes') || recordType == label.Company)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TREmail));
            validation = true;
        }*/
        //fix for MT-43
         /*else if (objAccount.Opt_In_SMS__c  && string.isblank(objAccount.Mobile__c)  && ((recordType != label.Company && objAccount.personal_agreement__c != 'Yes') || recordType == label.Company)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRSMS));
            validation = true;
        }
        else if (objAccount.Opt_In_Mobile__c && (string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber)) && ((recordType != label.Company && objAccount.personal_agreement__c != 'Yes') || recordType == label.Company)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRPhone));
            validation = true;
        }*/
       
        else if (!string.isblank(objAccount.Email__c) && !objAccount.Opt_In_Email__c && recordType != label.Company && objAccount.personal_agreement__c != 'Yes') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRSMS));
            validation = true;
        }
        
        else if ((!objAccount.Opt_In_Mobile__c && !objAccount.Opt_In_SMS__c) && ((objAccount.personal_agreement__c != 'Yes' && recordType != label.Company)) && (!string.isblank(hmphoneNumber)  || !string.isblank(mbphoneNumber)  || !string.isblank(wkphoneNumber)) ) {
            system.debug(hmphoneNumber + ',' + mbphoneNumber +','+ wkphoneNumber);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRPhone));
            validation = true;
        }
        else if (recordType != label.Company && (string.isblank(objAccount.Email__c) && string.isblank(mbphoneNumber))) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Email_Mobile_Mandatory));
            validation = true;
        }
        //system.debug(validateSocialIdTR() + ' final result');
        //added by Veena to check addresstype check when address line 1 and 2 are given by user  
            if((addressobj.Address_Line_1__c != null)&&(addressobj.Address_Line_2__c!=null)){
                if(addressobj.Address_Type__c==null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation)); 
                    Validation = true;
                }
            }
        // Save record without Address record if no value is Entered in Address section     
        if (city == null || city == '--Select--' || string.isblank(city)) {
     
            if (string.isnotblank(AddressObj.Address_Line_1__c) ||
                string.isnotblank(AddressObj.Address_Line_2__c) || string.isnotblank(AddressObj.Address_Line_3__c) ||
                string.isnotblank(district) ||
                string.isnotblank(Zip) ||
                string.isnotblank(province)){
                    
                    
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CityError));
                    Validation = true;
                } else {
                    if (SaveAccountDetailsTR()) {
                        PageReference pageRef = new PageReference('/' + objAccount.Id);
                        return PageRef;
                    }
                }
        }
        
        // Save record with Address details Validating the Address Details 
        boolean check = false;
        If(city != null || city != '--Select--' || !string.isblank(city)) {
          
            try {
                if (recordType == Label.Company)
                    recordTypeId = RecordTypeAccessService.getRecordTypeId('Account', Label.Company);
                else
                    recordTypeId = RecordTypeAccessService.getRecordTypeId('Account', Label.PersonAccount);


                objAccount.RecordTypeId = recordTypeId;
                ValidateAddressTR();

                if (Validation == False) {
                    refreshPage = true;
                    if (SaveAccountDetailsTR()) {
                        AddressObj.Customer__c = objAccount.id;
                        AddressObj.Preferred__c = true;
                        DMLManagerService.insertAsSystem(AddressObj);
                        //insert AddressObj;      
                        PageReference pageRef = new PageReference('/' + objAccount.Id);
                        return PageRef;
                    }
                }
            } catch (DMLException e) {

                refreshPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getDMlMessage(0));
            }
        }
        return null;
    }
    public void optInFields() {
        if(!objAccount.opt_in_mobile__c){
            if(!objAccount.opt_in_sms__c)
                objAccount.Mobile__c='';
            objAccount.Individual_Home_Phone__c='';
            objAccount.Work_Phone__c='';
        }
        if(!objAccount.opt_in_sms__c){
            if(!objAccount.opt_in_mobile__c){
                objAccount.Mobile__c='';
            }
        }
        if(!objAccount.opt_in_email__c){
            objAccount.Email__c='';
        }
            
    }
    public void phoneFieldConcatTR() {

        if (String.isBlank(hmphoneNumber)) objAccount.Individual_Home_Phone__c = '';
        else if (hmCountryCode != '' && hmphoneNumber != '' && hmCountryCode == label.TRPhoneCountryCode) objAccount.Individual_Home_Phone__c = hmCountryCode + hmphoneNumber;
        else objAccount.Individual_Home_Phone__c = hmCountryCode + hmphoneNumber;

        if (String.isBlank(wkphoneNumber)) objAccount.Work_Phone__c = '';
        else if (wkCountryCode != '' && wkphoneNumber != '' && wkCountryCode == label.TRPhoneCountryCode) objAccount.Work_Phone__c = wkCountryCode + wkphoneNumber;
        else objAccount.Work_Phone__c = wkCountryCode + wkphoneNumber;

        if ((String.isBlank(mbphoneNumber))) objAccount.Mobile__c = '';
        else if (mbCountryCode != '' && mbphoneNumber != '' && mbCountryCode == label.TRPhoneCountryCode) objAccount.Mobile__c = mbCountryCode + mbphoneNumber;
        else objAccount.Mobile__c = mbCountryCode + mbphoneNumber;

        /*if((String.isBlank(faxphoneNumber))) objAccount.fax='';       
        else if(faxCountryCode!='' && faxphoneNumber!='' && faxCountryCode==label.TRPhoneCountryCode) objAccount.fax=faxCountryCode+faxAreaCode+faxphoneNumber;        
        else objAccount.fax=faxCountryCode+faxphoneNumber;  */

    }
    //Saves the Account relaed details for Turkey Market      
    //Created By : Hildaa     
    //Date: 02/19/2018      

    public boolean SaveAccountDetailsTR() {

        try {
            if (recordType == label.Company)
                recordTypeId = RecordTypeAccessService.getRecordTypeId('Account', Label.Company);
            else
                recordTypeId = RecordTypeAccessService.getRecordTypeId('Account', Label.PersonAccount);

            //HN20171008- to set status for person account as Prospect 
            /*if(recordType == Label.PersonAccount){
                 objAccount.status__C = Label.ProspectStatus;
             }   //end code here modification by Honey   */

            objAccount.RecordTypeId = recordTypeId;
            phoneFieldConcatTR();
            //if(recordType != label.Company)
                //optInFields();
            /*if (objAccount.Individual_Home_Phone__c.trim() == '' && objAccount.Mobile__c.trim() == '' && objAccount.Work_Phone__c.trim() == '' && objAccount.Email__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
            } else*/ if ((objAccount.Individual_Home_Phone__c.trim() != '' && !objAccount.Individual_Home_Phone__c.startsWith('+')) ||
                (objAccount.Mobile__c.trim() != '' && !objAccount.Mobile__c.startsWith('+')) ||
                (objAccount.Work_Phone__c.trim() != '' && !objAccount.Work_Phone__c.startsWith('+')))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_invalid));

            else {
                refreshPage = true;
                DMLManagerService.insertAsSystem(objAccount);
                // insert objAccount ;     
                return true;
            }
        } catch (DMLException e) {

            refreshPage = false;
            if (e.getdmlMessage(0).contains('bad field')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove the firstname , lastname  for saving company account and account name for person account'));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
            }
            return false;
        }
        return false;
    }
    public void ValidateAddressTR() {
        try {
               //fix for MT - 36
             
            if(province != '--Select--')
                addressobj.Province__c = province;
            else
                addressobj.Province__c = '';
            if(district != '--Select--')
                addressobj.District__c = district;
            else
                addressobj.District__c = '';
            addressobj.ZipCode__c = zip;
            if(city != '--Select--')
                addressobj.City__c = city;
            else
                addressobj.City__c = '';
            
           /* if (AddressObj.Address_Type__c != null &&
                (AddressObj.Address_Line_1__c == null ||
                 AddressObj.Address_Line_2__c == null ||
                 province == null ||
                 district == null ||
                 zip == null || AddressObj.Country__c == null)
               ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'As you have filled in Address Type, Please enter the '));
                   Validation = TRUE;
                   Address_Validated_Flag = False;
                   
               } */
          
            //Fix for MT - 28
            if (!string.isblank(addressobj.ZipCode__c) && (!Pattern.matches('^[0-9]{5}$', addressobj.ZipCode__c)) && !IsForeignNational) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.TRZipCode));
                Validation = true;
            }
            //fix for MT-43 redeploy TRAddressMandatory
            if ((addressobj.Address_Line_2__c  != null || addressobj.Address_Line_1__c != null) && !(objAccount.Postal_Opt_In__c) && objAccount.Personal_Agreement__c !='Yes' && recordType != label.Company) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.TRAddressMandatory));
                Validation = true;
            }

            /*if (addressobj.ZipCode__c == null) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ZipCodeMandatory));
Validation = true;
}
if (addressobj.Address_Line_1__c == null) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline1Mandatory));
Validation = true;
}*/
              //fix for MT-28 
            if (String.isBlank(addressobj.Address_Line_1__c) && (!String.isBlank(addressobj.Address_Line_2__c) || (!String.isBlank(addressobj.Province__c) && addressobj.Province__c != '--Select--') || (!String.isblank(addressobj.District__c) && addressobj.District__c != '--Select--'))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline1Mandatory));
                Validation = true;
            }
            if ((!String.isBlank(addressobj.Address_Line_1__c) && addressobj.Address_Line_1__c != null && (!Pattern.matches('[A-Za-z0-9/., ]*', addressobj.Address_Line_1__c))) ||
                (!String.isBlank(addressobj.Address_Line_2__c) && addressobj.Address_Line_2__c != null && (!Pattern.matches('[A-Za-z0-9/., ]*', addressobj.Address_Line_2__c)))
               ) {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.AddressInvalid));
                   Validation = true;
               } else if (addressobj.Address_Line_1__c != null && addressobj.Address_Line_1__c.length() > 100) {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYAddressline1Length));
                   Validation = true;
               }
            else {
                if (addressobj.Address_Line_2__c != null && addressobj.Address_Line_2__c.length() > 100) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYAddresslinelen2Length));
                    Validation = true;
                }
            }
            //fix for MT-28
            if ((string.isBlank(addressobj.Province__c) || addressobj.Province__c == '--Select--') && !string.isBlank(addressobj.Address_Line_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.StateProvError));
                Validation = TRUE;
            }
            if ((string.isBlank(addressobj.District__c) || addressobj.District__c == '--Select--') && !string.isBlank(addressobj.Address_Line_1__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.DistrictError));
                Validation = TRUE;
            }
           /* if((string.isBlank(addressobj.Address_Type__c) || addressobj.Address_Type__c == '--None--') ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Address_type_Validation));
                Validation = TRUE;
            }*/
            
            /*if (addressobj.Province__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.StateProvError));
                Validation = TRUE;
            }
            if (addressobj.District__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.CityError));
                Validation = TRUE;
            }

            if (addressobj.Address_Line_2__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline2));
                Validation = TRUE;
            }else {*/ 

                
            //}
        } catch (exception e) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));

            CustomLogUtil.CustomLoggingEntry('error' + e);
        }
    }
     /*
     Online de duplication for TR Market  
    */
    public object onLineDeduplicationTR() {
        displayAccList.clear();
        DedupAccountList.clear();
        Boolean errorFlag = true;
        boolean mandatoryFlag = True;
        boolean recordCheck = true;
        Continuation con = null;
        system.debug('$$$$$ TR Market $$$$$');
         string mob = mbCountryCode+mbphoneNumber;
        string wrk = wkCountryCode+wkphoneNumber;
        string hme = hmCountryCode+hmphoneNumber;
        if (Recordtype != Label.PersonAccount && Recordtype != Label.Company) {
            recordCheck = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RecordTypeError));
        }

       //mt 39
        if (recordCheck && mandatoryFlag) {
            system.debug('inside online dedupe '+(string.isblank(objAccount.Email__c) && objAccount.Opt_In_Email__c && recordType != label.Company && objAccount.personal_agreement__c != 'Yes'));
            if ((objAccount.Name == null || String.isBlank(objAccount.Name) || objAccount.Data_Source__c == null || objAccount.Status__c == null || string.isblank(wkphoneNumber) ) && Recordtype == Label.Company) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CompanyAccountSearchErrorMessage));
                errorFlag = false;
            } else if ((objAccount.FirstName == null || objAccount.LastName == null || objAccount.Personal_Agreement__c == null || String.isBlank(objAccount.FirstName) || String.isBlank(objAccount.LastName) || objAccount.Data_Source__c == null || objAccount.Status__c == null) && Recordtype == Label.PersonAccount) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchErrorMessage));
                    errorFlag = false;
            } else if (!string.isblank(objAccount.Social_Id__c) && !validateSocialIdTR('SocId')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SocialIdError));
                    errorFlag = false;
            }
            else if (!string.isblank(objAccount.Vat_No__c) && (String.valueof(objAccount.Vat_No__c).length() == 11 && !validateSocialIdTR('VatNo'))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SocialIdError));
                    errorFlag = false;
            }
            else if (!string.isblank(objAccount.Vat_No__c) && String.valueof(objAccount.Vat_No__c).length() != 11 && !validateVATNoTR() ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.VATNOError));
                    errorFlag = false;
            }
           //fix  for MT - 23
            else if (!string.isblank(objAccount.Email__c) && !Pattern.Matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$',objAccount.Email__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.InvalidEmail));
                    errorFlag = false;  
            }
            else if ((!string.isblank(mbphoneNumber) && (!Pattern.Matches('^\\+[0-9]*$',mob) && mob.substring(0,3) != '+90')) || (!string.isblank(wkphoneNumber) && (!Pattern.Matches('^\\+[0-9]*$',wrk) && wrk.substring(0,3) != '+90')) || (!string.isblank(hmphoneNumber) && (!Pattern.Matches('^\\+[0-9]*$',hme) && hme.substring(0,3) != '+90'))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.NumericContact));
                    errorFlag = false;  
            }
            else if (!string.isblank(mbphoneNumber) && (!Pattern.Matches('^\\+905[0-9]{9}$',mob) && mob.substring(0,3) == '+90')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.InvalidMobile));
                    errorFlag = false;  
            }
            
           
            else if ((!string.isblank(wkphoneNumber) && (!Pattern.Matches('^\\+90[0-9]{10}$',wrk) && wrk.substring(0,3) == '+90' )) || (!string.isblank(hmphoneNumber) && (!Pattern.Matches('^\\+90[0-9]{10}$',hme) && hme.substring(0,3) == '+90') )){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.InvalidContact));
                    errorFlag = false;  
            }
            /*else if((string.isBlank(addressobj.Address_Type__c) || addressobj.Address_Type__c == '--None--') ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Address_type_Validation));
                errorFlag = false;  
            }*/
            else if(!string.isBlank(hmphoneNumber) && hmCountryCode == Label.TRPhoneCountryCode && !codes.contains(hmphoneNumber.substring(0,3))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Invalid_City_Code));
                errorFlag = false;  
            }
            else if(!string.isBlank(wkphoneNumber) && wkCountryCode == Label.TRPhoneCountryCode && !codes.contains(wkphoneNumber.substring(0,3))) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Invalid_City_Code));
                errorFlag = false;  
            }
            

            /*else if(Recordtype == Label.PersonAccount && !objAccount.opt_in_email__c && !objAccount.opt_in_mobile__c && !objAccount.opt_in_sms__c && !objAccount.Postal_Opt_In__c)
            {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid DoC before saving!'));
                    errorFlag = false;
            }
             else if (string.isblank(objAccount.Email__c) && objAccount.Opt_In_Email__c && (recordType != label.Company && objAccount.personal_agreement__c != 'Yes')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TREmail));
            errorFlag = false;
        }*/
        //Commented this as a fix for MT-43
      /*  else if (objAccount.Opt_In_SMS__c  && (string.isblank(mbphoneNumber) || string.isblank(wkphoneNumber)) && ((recordType != label.Company && objAccount.personal_agreement__c != 'Yes') || recordType == label.Company)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRSMS));
            errorFlag = false;
        }
        else if (objAccount.Opt_In_Mobile__c && (string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber)) && ((recordType != label.Company && objAccount.personal_agreement__c != 'Yes') || recordType == label.Company)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRPhone));
            errorFlag = false;
        }*/
        //changed labels Label.TRSMS & Label.TRPhone
            else if (!string.isblank(objAccount.Email__c) && !objAccount.Opt_In_Email__c && (recordType != label.Company && objAccount.personal_agreement__c != 'Yes') ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.TRSMS));
            errorFlag = false;
        }
        
        else if ((!objAccount.Opt_In_Mobile__c && !objAccount.Opt_In_SMS__c) && (objAccount.personal_agreement__c != 'Yes' && recordType != label.Company) &&(!string.isblank(hmphoneNumber)  || !string.isblank(mbphoneNumber) || !string.isblank(wkphoneNumber ))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.TRPhone ));
            errorFlag = false;
        }
        else if ( recordType != label.Company && (string.isblank(objAccount.Email__c) && string.isblank(mbphoneNumber) && string.isblank(objAccount.Social_Id__c))) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Email_Mobile_SocialId_Mandatory));
            errorFlag = false;
        }
        }
        if (errorFlag && mandatoryFlag && recordCheck) {
            firstsave = true;
            secondsave = false;
            last = false;
            previous = false;
            first = false;
            next = false;
            phoneFieldConcatTR();
            String EndUrl = generateCDMEndPointURL();
            system.debug(EndUrl +' ---->');
            CustomLogUtil.CustomLoggingEntry('Search End Url' + endurl);
            try {
                if (label.New_Component == 'true') {
                    con = new Continuation(120);
                    con.continuationMethod = 'processResponse';
                    this.requestLabel = CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl, con);
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.No_Match_Found));
                    errorFlag = false;
                }
            } catch (Exception e) {
                system.debug('error'+ ' ---> '+ e.getlinenumber() + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));
                errorFlag = false;
                
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber() + e.getMessage());

            }
        }
        return con;
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
			objAccount.Created_by_Dealership__c= u.Contact.AccountId;//07042018 : Namitha added as part of ph2.																								   
        }
        else 
            objAccount.Generated_by__c= 'MB';
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
        
        //First Name and Last Name format
        if((objAccount.FirstName != null && string.isnotblank(objAccount.FirstName ) && !Pattern.matches('^[a-z A-Z]*$',objAccount.FirstName)) ||
            (objAccount.LastName != null && string.isnotblank(objAccount.LastName ) && !Pattern.matches('^[a-z A-Z]*$',objAccount.LastName))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.First_And_Last_Name_Format));
            errorFlag=true;
        }                                
                                                                                                                                                 
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
            if(market == System.Label.IN){
                endUrl+='inp_JSON_FirstName='+(string.isnotblank(objAccount.firstname)?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
                endUrl+='&inp_JSON_LastName='+(string.isnotblank(objAccount.LastName)?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
                endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c )?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
                endUrl+='&inp_JSON_PAN='+(string.isnotblank(objAccount.PAN__c)?EncodingUtil.URLENCODE(objAccount.PAN__c,'UTF-8'):''); 
                endUrl+='&inp_JSON_Aadhar='+(string.isnotblank(objAccount.Aadhaar__c)?EncodingUtil.URLENCODE(objAccount.Aadhaar__c,'UTF-8'):'');
            }
            else if(market == System.Label.TR){
                endUrl += 'in_JSON_FirstName=' + ((string.isnotblank(objAccount.firstname)) ? EncodingUtil.URLENCODE(objAccount.FirstName, 'UTF-8') : '');
                endUrl += '&in_JSON_LastName=' + ((string.isnotblank(objAccount.LastName)) ? EncodingUtil.URLENCODE(objAccount.LastName, 'UTF-8') : '');
                endUrl += '&in_JSON_Mobile=' + ((string.isnotblank(objAccount.Mobile__c)) ? EncodingUtil.URLENCODE(objAccount.Mobile__c, 'UTF-8') : '');
                endUrl += '&in_JSON_Email=' + (string.isnotblank(objAccount.Email__c) ? objAccount.Email__c : '');
                endUrl += '&in_JSON_SocialID=' + (string.isnotblank(String.valueof(objAccount.Social_Id__c)) ?  EncodingUtil.URLENCODE(String.valueof(objAccount.Social_Id__c), 'UTF-8') : '');
            }
				 //Added for Japan for the formation of endURL
   else if(market == System.Label.JP && (!jpSwitchEnabledFlag)){
				endUrl += 'ip_JPFName=' + ((string.isnotblank(objAccount.firstname)) ? EncodingUtil.URLENCODE(objAccount.FirstName, 'UTF-8') : '');
				endUrl += '&ip_JPLName=' + ((string.isnotblank(objAccount.LastName)) ? EncodingUtil.URLENCODE(objAccount.LastName, 'UTF-8') : '');
				endUrl += '&ip_JPLNameNative=' + ((string.isnotblank(objAccount.LastName_Native_1__c)) ? EncodingUtil.URLENCODE(objAccount.LastName_Native_1__c, 'UTF-8') : '');
				endUrl += '&ip_JPFNameNative=' + ((string.isnotblank(objAccount.FirstName_Native_1__c)) ? EncodingUtil.URLENCODE(objAccount.FirstName_Native_1__c, 'UTF-8') : '');
				endUrl += '&ip_JPIndHomePhone=' + ((string.isnotblank(String.valueof(objAccount.Individual_Home_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Individual_Home_Phone__c), 'UTF-8') : '');
				endUrl += '&ip_JPMobile=' + ((string.isnotblank(String.valueof(objAccount.Mobile__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Mobile__c), 'UTF-8') : '');
				endUrl += '&ip_JPWorkPhone=' + ((string.isnotblank(String.valueof(objAccount.Work_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Work_Phone__c), 'UTF-8') : '');
				endUrl += '&ip_JPMobile2=' + ((string.isnotblank(String.valueof(objAccount.Mobile2__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Mobile2__c), 'UTF-8') : '');
				endUrl += '&ip_JPHomePhone2=' + ((string.isnotblank(String.valueof(objAccount.Home_Phone_2__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Home_Phone_2__c), 'UTF-8') : '');
				endUrl += '&ip_JPPhone=' + ((string.isnotblank(String.valueof(objAccount.Phone))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Phone), 'UTF-8') : '');
				endUrl += '&ip_JPEmail=' + ((string.isnotblank(objAccount.Email__c)) ? EncodingUtil.URLENCODE(objAccount.Email__c, 'UTF-8') : '');
				endUrl += '&ip_JPEmail2=' + ((string.isnotblank(objAccount.Email2__c)) ? EncodingUtil.URLENCODE(objAccount.Email2__c, 'UTF-8') : '');
				endUrl += '&ip_JPBdate=' + ((string.isnotblank(String.valueof(objAccount.PersonBirthdate))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.PersonBirthdate), 'UTF-8') : '');
				endUrl += '&ip_JPVIN=' + ((string.isnotblank(objAccount.VIN__c)) ? EncodingUtil.URLENCODE(objAccount.VIN__c, 'UTF-8') : '');
				endUrl += '&ip_JPMarket=' + ((string.isnotblank(objAccount.Market__c)) ? EncodingUtil.URLENCODE(objAccount.Market__c, 'UTF-8') : '');
				//Market__c is two times in the VF page so assuming that we will send only one.
				endUrl += '&ip_JPSendAddFlag=' + ((sendAddress != null) ? EncodingUtil.URLENCODE(String.valueOf(sendAddress), 'UTF-8') : '');
	   if(sendAddress){
			endUrl += '&ip_JPZipCode=' + ((string.isnotblank(AddressObj.ZipCode__c)) ? EncodingUtil.URLENCODE(AddressObj.ZipCode__c, 'UTF-8') : '');
			//endUrl += '&ip_JPProvince=' + ((string.isnotblank(AddressObj.Province__c)) ? EncodingUtil.URLENCODE(AddressObj.Province__c, 'UTF-8') : '');
			String tempProvinceTrans = doProvinceTranslation(AddressObj);
            endUrl += '&ip_JPProvince=' + ((string.isnotblank(tempProvinceTrans)) ? EncodingUtil.URLENCODE(tempProvinceTrans, 'UTF-8') : '');
			endUrl += '&ip_JPCity=' + ((string.isnotblank(AddressObj.City__c)) ? EncodingUtil.URLENCODE(AddressObj.City__c, 'UTF-8') : '');
			endUrl += '&ip_JPDistrict=' + ((string.isnotblank(AddressObj.District__c)) ? EncodingUtil.URLENCODE(AddressObj.District__c, 'UTF-8') : '');
			endUrl += '&ip_JPBlock=' + ((string.isnotblank(AddressObj.Block__c)) ? EncodingUtil.URLENCODE(AddressObj.Block__c, 'UTF-8') : '');
			endUrl += '&ip_JPAddLine1=' + ((string.isnotblank(AddressObj.Address_Line_1__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c, 'UTF-8') : '');
			endUrl += '&ip_JPAddLine2=' + ((string.isnotblank(AddressObj.Address_Line_2__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c, 'UTF-8') : '');
			endUrl += '&ip_JPProvinceNative=' + ((string.isnotblank(AddressObj.Province_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Province_Native__c, 'UTF-8') : '');
			endUrl += '&ip_JPCityNative=' + ((string.isnotblank(AddressObj.City_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.City_Native__c, 'UTF-8') : '');
			endUrl += '&ip_JPDistrictNative=' + ((string.isnotblank(AddressObj.District_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.District_Native__c, 'UTF-8') : '');
			endUrl += '&ip_JPBlockNative=' + ((string.isnotblank(AddressObj.Block_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Block_Native__c, 'UTF-8') : '');
			endUrl += '&ip_JPAddLine1Native=' + ((string.isnotblank(AddressObj.Address_Line_1_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1_Native__c, 'UTF-8') : '');
			//It needs to be confirm because we are already passing Market in objAccount
			endUrl += '&ip_JPAddMarket=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');
			endUrl += '&ip_JPAddLine2Native=' + ((string.isnotblank(AddressObj.Address_Line_2_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2_Native__c, 'UTF-8') : '');
		}
		}																			
        }
        else if(recordType == 'Company'){
             if(market == System.Label.IN){
                endUrl+='inp_JSON_CompanyName='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
                endUrl+='&inp_JSON_GSTIN='+(string.isnotblank(objAccount.GSTN_Number__c)?EncodingUtil.URLENCODE(objAccount.GSTN_Number__c,'UTF-8'):'');
                endUrl+='&inp_JSON_CIN='+(string.isnotblank(objAccount.CIN_Number__c)?EncodingUtil.URLENCODE(objAccount.CIN_Number__c,'UTF-8'):'');
             }
            else if(market == System.Label.TR){
                endUrl += 'in_JSON_CompanyName=' + (string.isnotblank(objAccount.Name) ? EncodingUtil.URLENCODE(objAccount.Name, 'UTF-8') : '');
                endUrl += '&in_JSON_WorkPhone=' + (string.isnotblank(objAccount.Work_Phone__c) ? EncodingUtil.URLENCODE(objAccount.Work_Phone__c, 'UTF-8') : '');
                endUrl += '&in_JSON_VATNo=' + (string.isnotblank(String.valueof(objAccount.Vat_No__c)) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Vat_No__c), 'UTF-8') : '');
                endUrl += '&in_JSON_City=' + (string.isnotblank(city) ? EncodingUtil.URLENCODE(city, 'UTF-8')  : '');
            }
			    else if(market == System.Label.JP && (!jpSwitchEnabledFlag)){
					endUrl += 'ip_JPCName=' + ((string.isnotblank(objAccount.Name)) ? EncodingUtil.URLENCODE(objAccount.Name, 'UTF-8') : '');
					endUrl += 'ip_JPCmpNameNative2=' + ((string.isnotblank(objAccount.Company_Name_Native_2__c)) ? EncodingUtil.URLENCODE(objAccount.Company_Name_Native_2__c, 'UTF-8') : '');
					endUrl += '&ip_JPIndHomePhone=' + ((string.isnotblank(String.valueof(objAccount.Individual_Home_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Individual_Home_Phone__c), 'UTF-8') : '');
					endUrl += '&ip_JPMobile=' + ((string.isnotblank(String.valueof(objAccount.Mobile__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Mobile__c), 'UTF-8') : '');
					endUrl += '&ip_JPWorkPhone=' + ((string.isnotblank(String.valueof(objAccount.Work_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Work_Phone__c), 'UTF-8') : '');
					endUrl += '&ip_JPMobile2=' + ((string.isnotblank(String.valueof(objAccount.Mobile2__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Mobile2__c), 'UTF-8') : '');
					endUrl += '&ip_JPHomePhone2=' + ((string.isnotblank(String.valueof(objAccount.Home_Phone_2__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Home_Phone_2__c), 'UTF-8') : '');
					endUrl += '&ip_JPPhone=' + ((string.isnotblank(String.valueof(objAccount.Phone))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Phone), 'UTF-8') : '');
					endUrl += '&ip_JPEmail=' + ((string.isnotblank(objAccount.Email__c)) ? EncodingUtil.URLENCODE(objAccount.Email__c, 'UTF-8') : '');
					endUrl += '&ip_JPEmail2=' + ((string.isnotblank(objAccount.Email2__c)) ? EncodingUtil.URLENCODE(objAccount.Email2__c, 'UTF-8') : '');
					endUrl += '&ip_JPVIN=' + ((string.isnotblank(objAccount.VIN__c)) ? EncodingUtil.URLENCODE(objAccount.VIN__c, 'UTF-8') : '');
					endUrl += '&ip_JPMarket=' + ((string.isnotblank(objAccount.Market__c)) ? EncodingUtil.URLENCODE(objAccount.Market__c, 'UTF-8') : '');
					endUrl += '&ip_JPSendAddFlag=' + ((sendAddress != null) ? EncodingUtil.URLENCODE(String.valueOf(sendAddress), 'UTF-8') : '');
				if(sendAddress){
						endUrl += '&ip_JPZipCode=' + ((string.isnotblank(AddressObj.ZipCode__c)) ? EncodingUtil.URLENCODE(AddressObj.ZipCode__c, 'UTF-8') : '');
						//endUrl += '&ip_JPProvince=' + ((string.isnotblank(AddressObj.Province__c)) ? EncodingUtil.URLENCODE(AddressObj.Province__c, 'UTF-8') : '');
						String tempProvinceTrans = doProvinceTranslation(AddressObj);
						endUrl += '&ip_JPProvince=' + ((string.isnotblank(tempProvinceTrans)) ? EncodingUtil.URLENCODE(tempProvinceTrans, 'UTF-8') : '');
						endUrl += '&ip_JPCity=' + ((string.isnotblank(AddressObj.City__c)) ? EncodingUtil.URLENCODE(AddressObj.City__c, 'UTF-8') : '');
						endUrl += '&ip_JPDistrict=' + ((string.isnotblank(AddressObj.District__c)) ? EncodingUtil.URLENCODE(AddressObj.District__c, 'UTF-8') : '');
						endUrl += '&ip_JPBlock=' + ((string.isnotblank(AddressObj.Block__c)) ? EncodingUtil.URLENCODE(AddressObj.Block__c, 'UTF-8') : '');
						endUrl += '&ip_JPAddLine1=' + ((string.isnotblank(AddressObj.Address_Line_1__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c, 'UTF-8') : '');
						endUrl += '&ip_JPAddLine2=' + ((string.isnotblank(AddressObj.Address_Line_2__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c, 'UTF-8') : '');
						endUrl += '&ip_JPProvinceNative=' + ((string.isnotblank(AddressObj.Province_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Province_Native__c, 'UTF-8') : '');
						endUrl += '&ip_JPCityNative=' + ((string.isnotblank(AddressObj.City_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.City_Native__c, 'UTF-8') : '');
						endUrl += '&ip_JPDistrictNative=' + ((string.isnotblank(AddressObj.District_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.District_Native__c, 'UTF-8') : '');
						endUrl += '&ip_JPBlockNative=' + ((string.isnotblank(AddressObj.Block_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Block_Native__c, 'UTF-8') : '');
						endUrl += '&JPAddLine1Native=' + ((string.isnotblank(AddressObj.Address_Line_1_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1_Native__c, 'UTF-8') : '');
						//It needs to be confirm because we are already passing Market in objAccount
						endUrl += '&ip_JPAddMarket=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');
						endUrl += '&ip_JPAddLine2Native=' + ((string.isnotblank(AddressObj.Address_Line_2_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2_Native__c, 'UTF-8') : '');
				}
			}																				
        }
		
		if(market==Label.JP && jpSwitchEnabledFlag){
			endUrl=generateCDMEndPointURLRules();
		}
		
        return endUrl;
    } 
   public String generateCDMEndPointURLRules(){
        String endUrl='';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                endUrl+=mapURLs.get(str).Informatica_URL__c+'?';
            }
					  
        }
        List<Configuration_Rule__c> DedupCriteria= new List<Configuration_Rule__c>();
        DedupCriteria=[select id,(select id,Destination__c,Source__c,Object_API__c,Order__c from Configuration_Rule_Items__r where active__c=true order by Order__c) from Configuration_Rule__c where active__c=true and Market__c=:Market and type__c='Deduplication' and Sub_Type__c=:recordType limit 1];         
        if(DedupCriteria.size()>0){
            for(Configuration_Rule__c c:DedupCriteria){
                if(c.Configuration_Rule_Items__r!=null && c.Configuration_Rule_Items__r.size()>0){
                    for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                        Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                        cri=c.Configuration_Rule_Items__r[i];
                        if(i!=0){
                            endUrl+='&';
                        }
                        if(cri.Object_API__c=='Account'){
                            endUrl+=cri.Destination__c+((string.isnotblank(string.valueof(objAccount.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(objAccount.get(cri.source__c)),'UTF-8'):'');
                        }
                        else if(cri.Object_API__c=='Address__c' && sendAddress){
                            if(cri.Destination__c=='ip_JPProvice'){
                                String tempProvinceTrans = doProvinceTranslation(AddressObj);
                                endUrl+=cri.Destination__c+((string.isnotblank(tempProvinceTrans))?EncodingUtil.URLENCODE(tempProvinceTrans,'UTF-8'):'');
                            }
                            else{
                                endUrl+=cri.Destination__c+((string.isnotblank(string.valueof(AddressObj.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(AddressObj.get(cri.source__c)),'UTF-8'):'');
                            }   
                        }
                        else if(cri.Object_API__c=='Default'){
                            endUrl+=cri.Destination__c+((string.isnotblank((cri.source__c)))?EncodingUtil.URLENCODE((cri.source__c),'UTF-8'):'');
                        }
                    }
                }
            }
        }
        return endUrl;
    } 

    public Object processResponse() {
            HttpResponse res = Continuation.getResponse(this.requestLabel);
            System.debug('res*** ' + res);
		  //Added for JP track.
			readonly= true;  
			editmode=false; 
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
					String addressFieldsQuery = ',Primary_Address_Reference__c, Primary_Address_Reference__r.Province__c, Primary_Address_Reference__r.City__c,Primary_Address_Reference__r.District__c,Primary_Address_Reference__r.Block__c,Primary_Address_Reference__r.Address_Line_1__c,Primary_Address_Reference__r.Address_Line_2__c,Primary_Address_Reference__r.Address_Code__c,Primary_Address_Reference__r.ZipCode__c,Primary_Address_Reference__r.Temp_ZipCode__c,Primary_Address_Reference__r.Temp_Address__c';  																																																																																																																										  
                    string querytxt='select id,firstname,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__celect id,firstname,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,Primary_Address_Display__c from account where <Search> in (';
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
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company'){
							if(market == System.Label.JP)
							{
							if(acc.Allow_data_sharing2__c != 'No' || objAccount.Allow_data_sharing2__c != 'No')
								DedupAccountList.add(acc);
							}
							else
							DedupAccountList.add(acc);
                       }
					 }
                    last=false;     
                    previous=false;     
                    first=false;        
                    next=false;
                    LastIndex=DedupAccountList.size();      
                    First();
					if(market==system.label.JP){
						constructAddressMap();							
                    If(displayAccList.size()==0)
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                    else if(displayAccList.size()==1)
                        one = true;
                    else if(displayAccList.size()>1)
                        one = false;
                }
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
        
        System.debug('Account to display------------------------------------->'+displayAccList);                        
    }        
	public Object OnlineDeduplicationJP(){
        displayAccList.clear();
        DedupAccountList.clear();
        String Doblebyte='[^ -~¡-ß]*';
        String KanaChar='[ァア・ィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー ]*';
        Boolean result;
        Boolean resultFname;
        Boolean resultKanaLname;
        Boolean resultKanaFname;
        Integer yr;       
        Integer bdayyear;
        Continuation con=null;
        
		if(Address_Validated_Flag == null){
            Address_Validated_Flag = false;
        }								   
        if(objAccount.PersonBirthdate !=null){
            Integer currentYear = System.Today().year();
            yr= objAccount.PersonBirthdate.year();
            bdayyear=currentYear-yr;
        }
        
        Pattern KanaPattern = Pattern.compile(KanaChar);
        if(objAccount.LastName_Native_1__c !=null){
            Matcher MyMatcher = KanaPattern.matcher(objAccount.LastName_Native_1__c);
            resultKanaLname  = MyMatcher.matches();
        }

        Pattern KanaPatternFname = Pattern.compile(KanaChar);
        if( objAccount.FirstName_Native_1__c !=null){
            Matcher MyMatcherfname = KanaPattern.matcher(objAccount.FirstName_Native_1__c);
            resultKanaFname = MyMatcherfname.matches();
        }

        Pattern MyPattern = Pattern.compile(Doblebyte);
        if(objAccount.lastName !=null){
            Matcher MyMatcher = MyPattern.matcher(objAccount.lastName);
            result = MyMatcher.matches();
        }

        Pattern MyPatternFname = Pattern.compile(Doblebyte);
        if(objAccount.FirstName !=null){
            Matcher MyMatcherFname = MyPattern.matcher(objAccount.FirstName);
            resultFname = MyMatcherFname.matches();
        }
        
        if(recordType == 'Person Account'  && Userinfo.getUserType() != 'PowerPartner' && market == System.Label.JP && (objAccount.LastName == NULL||String.isBlank(objAccount.LastName) || objAccount.Data_source__C == NULL || String.isBlank(objAccount.Data_source__C))){ 
            objAccount.LastName.adderror(Label.LastName_and_TouchPoint_fileds_are_mandatory);
               // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.LastName_and_TouchPoint_fileds_are_mandatory));
        }else if(recordType == 'Person Account'  && Userinfo.getUserType() == 'PowerPartner' && market == System.Label.JP && (objAccount.LastName == NULL||String.isBlank(objAccount.LastName) )){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.LastName_is_mandatory));
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Name == NULL||String.isBlank(objAccount.Name))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Account_Name_is_mandatory));
        }else if((recordType == 'Person Account' ||   recordType == 'Company') && market == System.Label.JP && (objAccount.Market__c !='JP' || objAccount.Market__c !='JP')){
            if(objAccount.Market__c !=null){
                objAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only); 
            }
            if(objAccount.Market__c !=null){              
                objAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only);
            }
        }else if((recordType == 'Person Account'  ||   recordType == 'Company') && market == System.Label.JP && (objAccount.Status__c  =='Customer'  || objAccount.Status__c  =='Customer')){ 
            objAccount.Status__c.addError(Label.If_customer_has_no_vehicle_relationship_Status_must_not_be_Customer); 
        }else if(recordType == 'Person Account'  && market == System.Label.JP && (objAccount.Acquisition_Objective_Method__c == null || String.isBlank(objAccount.Acquisition_Objective_Method__c) ) && objAccount.Allow_Data_Sharing2__c=='Yes'  && (objAccount.Data_Source__c=='Dealer Outlet' || TouchPoint=='Dealer Outlet' || TouchPoint=='販売店')){ 
            objAccount.Acquisition_Objective_Method__c.addError(Label.Please_select_Acquisition_Objective_Method);  
        }else if(recordType == 'Person Account'  && market == System.Label.JP && objAccount.PersonBirthdate != NULL  && (objAccount.PersonBirthdate  >=System.today() || bdayyear  >=151)){ 
            objAccount.PersonBirthdate.addError(Label.Birthdate_is_not_allowed_to_be_later_than_today_or_earlier_than_150_years);    
        }else if(recordType == 'Company' && market == System.Label.JP && objAccount.Name != NULL && objAccount.Name.length() >=40) {
            objAccount.Name.addError(Label.Name_should_be_less_than_or_equal_to_40_letters);   
        }else if(recordType == 'Company' && market == System.Label.JP && objAccount.Company_Name__c != NULL && objAccount.Company_Name__c.length() >=41) {
            objAccount.Company_Name__c.addError(Label.Company_Name_should_be_less_than_or_equal_to_40_letters);  
        }else if(recordType == 'Person Account'  && market == System.Label.JP  && objAccount.Acquisition_Objective_Method__c=='Others'  && (objAccount.Details_of_Acquisition__c== null   || String.isBlank(objAccount.Details_of_Acquisition__c)) ){ 
            objAccount.Details_of_Acquisition__c.addError(Label.Please_enter_Value_for_Details_of_Acquisition);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.FirstName != NULL && resultFname==false)){ 
            objAccount.FirstName.addError(Label.First_Name_should_be_of_2_byte_characters);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.FirstName_Native_1__c != NULL && resultKanafname==false)){ 
            objAccount.FirstName_Native_1__c.addError(Label.First_Name_Native_should_be_KANA_Chaarcters);
        }else if(recordType == 'Person Account' && market == System.Label.JP && objAccount.FirstName != NULL && objAccount.FirstName.length() >=41){
            objAccount.FirstName.addError(Label.First_Name_should_be_less_than_or_equal_to_40_letters);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL && !objAccount.Home_Phone_2__c.isNumeric())){ 
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && objAccount.Home_Phone_2__c != NULL && objAccount.Home_Phone_2__c.length() >=12){
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL &&  !objAccount.Home_Phone_2__c.startsWith('0'))){ 
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_start_with_0);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL && !objAccount.Individual_Home_Phone__c.isNumeric())){ 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && objAccount.Individual_Home_Phone__c!= NULL && objAccount.Individual_Home_Phone__c.length() >=12){
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL &&  !objAccount.Individual_Home_Phone__c.startsWith('0'))){ 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_start_with_0);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.LastName != NULL && result==false)){ 
            objAccount.LastName.addError(Label.Last_Name_should_be_of_2_byte_characters);
        }else if(recordType == 'Person Account'  &&  market == System.Label.JP && (objAccount.lastName != NULL && objAccount.lastName.length() >41 )){ 
            objAccount.LastName.addError(Label.Last_Name_should_be_less_than_or_equal_to_40_letters);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.LastName_Native_1__c != NULL && resultKanaLname==false)){ 
            objAccount.LastName_Native_1__c.addError(Label.Last_Name_Native_should_be_KANA_Characters);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile__c != NULL && !objAccount.Mobile__c.isNumeric())){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile__c != NULL && objAccount.Mobile__c.length() >=12)){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile__c != NULL &&  !objAccount.Mobile__c.startsWith('0'))){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_start_with_0);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && !objAccount.Mobile2__c.isNumeric())){ 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && objAccount.Mobile2__c.length() >=12)){ 
                 objAccount.Mobile2__c.addError(Label.Mobile_2_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Mobile2__c != NULL &&  !objAccount.Mobile2__c.startsWith('0'))){ 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_start_with_0);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Phone != NULL && !objAccount.Phone.isNumeric())){ 
            objAccount.Phone.addError(Label.Phone_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.phone != NULL && objAccount.phone.length() >=12)){ 
            objAccount.phone.addError(Label.Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Phone != NULL &&  !objAccount.Phone.startsWith('0'))){ 
            objAccount.Phone.addError(Label.Phone_should_start_with_0);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && !objAccount.Work_Phone__c.isNumeric())){ 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_not_include_or);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && objAccount.Work_Phone__c.length() >=12)){ 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Person Account' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL &&  !objAccount.Work_Phone__c.startsWith('0'))){ 
            objAccount.Work_Phone__c.addError(Label.WorkPhone_should_start_with_0);
        }
        
        
        /***************************** Company Record Type Validation check Starts Here ******************************************************/
        
        
        else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL && !objAccount.Mobile__c.isNumeric())){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL && objAccount.Mobile__c.length() >=12)){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL &&  !objAccount.Mobile__c.startsWith('0'))){ 
            objAccount.Mobile__c.addError(Label.Mobile_should_start_with_0);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && !objAccount.Mobile2__c.isNumeric())){ 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && objAccount.Mobile2__c.length() >=12)){ 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL &&  !objAccount.Mobile2__c.startsWith('0'))){ 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_start_with_0);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Phone != NULL && !objAccount.Phone.isNumeric())){ 
            objAccount.Phone.addError(Label.Phone_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.phone != NULL && objAccount.phone.length() >=12)){ 
            objAccount.phone.addError(Label.Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Phone != NULL &&  !objAccount.Phone.startsWith('0'))){ 
            objAccount.Phone.addError(Label.Phone_should_start_with_0);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && !objAccount.Work_Phone__c.isNumeric())){ 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && objAccount.Work_Phone__c.length() >=12)){ 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL &&  !objAccount.Work_Phone__c.startsWith('0'))){ 
            objAccount.Work_Phone__c.addError(Label.WorkPhone_should_start_with_0);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL && !objAccount.Home_Phone_2__c.isNumeric())){ 
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && objAccount.Home_Phone_2__c != NULL && objAccount.Home_Phone_2__c.length() >=12){
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL &&  !objAccount.Home_Phone_2__c.startsWith('0'))){ 
            objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_start_with_0);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL && !objAccount.Individual_Home_Phone__c.isNumeric())){ 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_not_include_or);
        }else if(recordType == 'Company' && market == System.Label.JP && objAccount.Individual_Home_Phone__c!= NULL && objAccount.Individual_Home_Phone__c.length() >=12){
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_be_less_than_or_equal_to_11_digits);
        }else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL &&  !objAccount.Individual_Home_Phone__c.startsWith('0'))){ 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_start_with_0);
        } 
            
        /***************************** Company Record Type Validation check ENDS Here ******************************************************/
        else{
            
            //processResponse();
            readonly= true;  
            editmode=false;
            if(objAccount.LastName !=null || objAccount.Name !=null){
                if(selectedRecordType =='Company'){
                    if(recordType !=null && recordType=='Company' && selectedRecordType =='Company'){
                        objAccount.Recordtypeid=companyRecordTypeId;
                    }
                }else if(selectedRecordType =='Person Account'){
                    if(recordType !=null && recordType== 'Person Account' && selectedRecordType =='Person Account'){             
                        objAccount.Recordtypeid=PersonAccountRecordTypeID ;
                    }
                }
                
                Address__c NewAdd=new Address__c();
                newadd.market__c = market;
                if(NewAdd != AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && objAccount.RecordTypeId !=null){
                    AddressObj.Address_Type__c = addresspicklist;
                    if(AddressObj.Market__c !='JP'   &&  market == System.Label.JP){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You are allowed to create record for your home market only'));
                    }
                    //response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
                    sendAddress = true;
                    try{    
                        if(label.New_Component=='true'){
                            String endUrl = generateCDMEndPointURL();
                            con = new Continuation(120);     
                            con.continuationMethod='processResponse';
                            this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                            system.debug('request label: '+ this.requestLabel);
                        }else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
                        }
                    }catch (Exception e){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
                         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
                    }
                }
                
                if(AddressObj == NewAdd){
                    //response =  UtilWebservice.validateCustomerDetails(objAccount);
                    sendAddress = false;
                    String endUrl = generateCDMEndPointURL();
                
                    try{    
                        if(label.New_Component=='true'){
                            con = new Continuation(120);     
                            con.continuationMethod='processResponse';
                            this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                            system.debug('request label: '+ this.requestLabel);
                        }else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
                        }
                    }catch (Exception e){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
                         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
                    }                   
                }

            }//end of last name check.      
            
        }
        
        return con;
    }//end of online deduplication method for JP track. 
    
    public PageReference reInitializeAccountAddressObject(){
		if(market==label.JP){
	    objAccount = new Account(Market__c='JP');
        AddressObj = new Address__c(Market__c='JP');
		if(string.isNOTBlank(recordType)){
			if(recordType=='Person Account') objAccount.Allow_Data_Sharing2__c = 'No';
			}
		}
        return null;
    } 
    
     //Fills Address Type picklist, Introduced for TH market - Start
    public List<SelectOption> getAddressOptions() {
        List<SelectOption> AddressOptions = new List<SelectOption>();
        if(market==Label.KR){  
           AddressOptions.add(new SelectOption('--None--','--None--'));         
           AddressOptions.add(new SelectOption('Home','Home'));
           AddressOptions.add(new SelectOption('Business','Business'));           
        }
        else{
            try{
                if(UserInfo.getLocale()=='ja_JP')
                  AddressOptions.add(new SelectOption('--None--',System.label.None));
                else
                  AddressOptions.add(new SelectOption('--None--','--None--'));  
                Schema.DescribeFieldResult countryFieldDescription = Address__c.Address_Type__c.getDescribe();
                for(Schema.Picklistentry picklistEntry : countryFieldDescription.getPicklistValues()){
                    //Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                    AddressOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                }
            }
            //AddressOptions.add(new SelectOption(addressobj.id,addressobj.Address_Type__c));
            catch(Exception e){}
        }
        return AddressOptions;
    }
    
    //this method is used to construct the address field map.
    public void constructAddressMap(){
        accIdToAddressMap = new Map<Id, String>();
        String concatenateAddressFields; //used to concatenate the address fields.
        
        //iterating the constructed list.
        for(Account acc : DedupAccountList){
            concatenateAddressFields = '';
            
            if(acc.Primary_Address_Display__c != null){
                concatenateAddressFields = acc.Primary_Address_Display__c;
                concatenateAddressFields = concatenateAddressFields.replaceAll('null', '');
                accIdToAddressMap.put(acc.Id, concatenateAddressFields);
            
            }
        }//end of iterating the account records.
        
        //checking the size to avoid unnessary query.
        if(DedupAccountList.size() != accIdToAddressMap.size()){
            for(Address__c add : [SELECT Id, Customer__c, Province__c, City__c, District__c, Block__c, Address_Line_1__c, Address_Line_2__c, 
                                        Address_Code__c, ZipCode__c, Temp_ZipCode__c, Temp_Address__c
                                FROM Address__c 
                                WHERE Customer__c IN : DedupAccountList
                                AND Customer__c NOT IN : accIdToAddressMap.keySet()
                                AND Address_Type__c = 'Home']){
                concatenateAddressFields = add.Province__c +' '+ 
                                        add.City__c +' '+ 
                                        add.District__c +' '+ 
                                        add.Block__c +' '+ 
                                        add.Address_Line_1__c +' '+ 
                                        add.Address_Line_2__c +' '+ 
                                        add.Address_Code__c +' '+ 
                                        add.ZipCode__c +' Unnormalized Post Code '+ 
                                        add.Temp_ZipCode__c +' Unnormalized Addres '+ 
                                        add.Temp_Address__c ;
                concatenateAddressFields = concatenateAddressFields.replaceAll('null', '');
                accIdToAddressMap.put(add.Customer__c, concatenateAddressFields);
            }//end of address iteration.
        }//end of checking the size.
        
        for(Account acc : DedupAccountList){
            if(accIdToAddressMap.isEmpty() || !accIdToAddressMap.containsKey(acc.Id)){
                accIdToAddressMap.put(acc.Id, '');
            }
        }
        System.debug('Account id to address field map values are ---------------------------------------->'+accIdToAddressMap);
    }//end of constructing address map method.
    
    public pagereference saveAccountJP(){
    
       if(addresspicklist!=null)
              AddressObj.Address_Type__c = addresspicklist;
              Validation = false;
              Schema.DescribeFieldResult fieldResult = Account.Data_Source__c.getDescribe();
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for( Schema.PicklistEntry f : ple)
              {
                  if(UserInfo.getLocale()=='ja_JP')
                       {
                           labelNvalue.put(f.getLabel(),f.getValue());
                       }
              }
              TouchPoint=labelNvalue.get(TouchPoint);
              // Save record without Address record if no value is Entered in Address section
              if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--') && AddressObj.Address_Line_1__c ==null && AddressObj.Address_Line_2__c == null &&
                           AddressObj.ZipCode__c == null && AddressObj.Block__c ==  null && AddressObj.City__c == null &&  AddressObj.District__c == null &&
                           AddressObj.Province__c == null)
						   {   
                                try {
                                     //For Company Account Record Type without Address
                                      if(recordType == 'Company' &&  market == System.Label.JP){
                                            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                                            objAccount.RecordTypeId = recordTypeId;
                                            if(objAccount.Individual_Home_Phone__c == null && objAccount.Mobile__c == null && objAccount.Work_Phone__c == null &&
                                               objAccount.Mobile2__c == null && objAccount.Home_Phone_2__c == null &&  objAccount.Phone == null &&
                                               objAccount.Email__c == null && objAccount.Email2__c == null){
													ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                                                }
                                                else
                                                {   
                                                  refreshPage = true;
                                                  if(TouchPoint !=null){
                                                      objAccount.Data_Source__c=TouchPoint;
                                                  }
                                                  insert objAccount ;
                                                  PageReference pageRef = new PageReference('/'+objAccount.Id);
                                                  return PageRef;
                                              }                   
                                        }         
                                       //For Person Account Record Type without Address                                                         
                                       if(recordType == 'Person Account' && market == System.Label.JP )
                                       {       
                                           recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                                           objAccount.RecordTypeId = recordTypeId;
                                           if(objAccount.Individual_Home_Phone__c == null && objAccount.Mobile__c == null && objAccount.Work_Phone__c == null &&
												objAccount.Mobile2__c == null && objAccount.Home_Phone_2__c == null &&  objAccount.Phone == null &&
                                                objAccount.Email__c == null && objAccount.Email2__c == null)
                                                {
													ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                                                }
                                                else
                                                {   
													refreshPage = true;
                                                    if(TouchPoint !=null){
                                                         objAccount.Data_Source__c=TouchPoint;
                                                     } 
                                                     if(objAccount.Acquisition_Objective_Method__c !=null && objAccount.Allow_Data_Sharing2__c =='Yes')
                                                     {
														objAccount.Acquisition_Record_Date__c=System.today();
                                                     }
                                                     insert objAccount ;
                                                     PageReference pageRef = new PageReference('/'+objAccount.Id);
                                                     return PageRef;
                                                 }                   
                                           }                        
                                      }           
                                      catch(DMLException e)
                                      {
                                            refreshPage = false;
                                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));     
                                                }
                                }
                                else
                                {              
            try{
                                                                //For Company Account Record Type with Address
                                                                if( recordType == 'Company' && market == System.Label.JP)
                {
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                    objAccount.RecordTypeId = recordTypeId;
                    if(!Address_Validated_Flag)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                    }
                    if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--'))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        Readonly=false;
                        Editmode=true;
                        return null;
                    }
                    if ((Address_Validated_Flag) && AddressObj.Address_Type__c != null )
                    {
                        refreshPage = true;
                        if(TouchPoint !=null)
                        {
                                                                                                                objAccount.Data_Source__c=TouchPoint;
                        }
                        insert objAccount ;
                        AddressObj.Customer__c = objAccount.id;
                        //AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                        insert AddressObj;
                        PageReference pageRef = new PageReference('/'+objAccount.Id); 
                        return PageRef;
                    }                     
                }
                system.debug('recordType 6:'+ recordType);
                system.debug('recordType 7:'+ System.Label.PersonAccount);
                                                                //For Person Account Record Type with address
                if(recordType == 'Person Account' && market == System.Label.JP)
                {
                                                          
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    objAccount.RecordTypeId = recordTypeId;
                                                                                system.debug('Enter JP Loop 2 :');
                    if(!Address_Validated_Flag)
                    {   system.debug('Enter JP Loop 3 :');                    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                    }
                    if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--'))
                    {   system.debug('Enter JP Loop 4 :'); 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                                                                                                return null;
                    }                    
                    if ((Address_Validated_Flag) && AddressObj.Address_Type__c != null )
                    {
                                                                                                system.debug('Enter JP Loop 5 :'); 
                        system.debug('refreshPage 1:'+refreshPage );
                        system.debug('Validation1:'+Validation );
                        if(Validation == false){
                            system.debug('refreshPage 2:'+refreshPage );
                            if(TouchPoint !=null)
                            {
                                            objAccount.Data_Source__c=TouchPoint;
                            } 
                            if(objAccount.Acquisition_Objective_Method__c !=null && objAccount.Allow_Data_Sharing2__c =='Yes')
                            {
                                            objAccount.Acquisition_Record_Date__c=System.today();
                            }
                            upsert objAccount ;
                            if(AddressObj !=null && (Address_Validated_Flag )){
                                AddressObj.Customer__c = objAccount.id;
                                //AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                                insert AddressObj;
                            }
                        PageReference pageRef = new PageReference('/'+objAccount.Id);            
                        return PageRef;
                        }
                    }
                }
            }
            catch(DMLException e)
            {
                refreshPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));     
            }
        }
        system.debug('+++++Readonly'+readonly);
        system.debug('++++++++++Editmode'+Editmode);
        Readonly= false;  
        Editmode=true; 
        return null;
    }

    public void AutoFillAddress(){
        AutoFill = true;
        DisplayAutoFill = true; 
        validateAddressByZipCode();
        
    }
    
    public void validateAddressByZipCode()
    { 
        if(Market ==Label.JP){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^'+addresspicklist);
            if(AddressObj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)  ))
            {
                AddressObj.Address_Code__c = '';
                AddressObj.Address_Line_1__c = '';
                AddressObj.Address_Line_2__c = '';
                AddressObj.Block__c = '';
                AddressObj.City__c = '';
                AddressObj.District__c = '';
                AddressObj.Province__c = ''; 
                AddressObj.MD__c ='';
                AddressObj.Block_Native__c = '';      
                AddressObj.City_Native__c = '';        
                AddressObj.Province_Native__c ='';        
                AddressObj.District_Native__c = '';        
                AddressObj.Address_Line_1_Native__c = '';        
                AddressObj.Address_Line_2_Native__c = '';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_validation));  
            }
            else if( (addresspicklist ==null || addresspicklist =='--None--')    && market == System.Label.JP )
            {
               AddressObj.Address_Type__c.addError(Label.Address_Type_is_required);
            }
            else if((AddressObj.market__c !='JP') && market == System.Label.JP )
            {
                AddressObj.market__c.addError(Label.You_are_allowed_to_create_Address_record_for_your_home_market_only); 
            }
            
            else if((AddressObj.Address_Line_1__c !=  Null || !String.isblank(AddressObj.Address_Line_1__c)) && market == System.Label.JP && AddressObj.Address_Line_1__c.length() >=51 )
            {
                AddressObj.Address_Line_1__c.addError(Label.Address_Line_1_should_be_less_than_or_equal_to_50_letters);
            }
           else if((AddressObj.Address_Line_2__c !=  Null || !String.isblank(AddressObj.Address_Line_2__c)) && market == System.Label.JP && AddressObj.Address_Line_2__c.length() >=51 )
            {
                AddressObj.Address_Line_2__c.addError(Label.Address_Line_2_should_be_less_than_or_equal_to_50_letters);
            }
           else  if((AddressObj.Block__c !=  Null || !String.isblank(AddressObj.Block__c)) && market == System.Label.JP && AddressObj.Block__c.length() >=13 )
            {
                AddressObj.Block__c.addError(Label.Block_should_be_less_than_or_equal_to_12_letters);
            }
            else  if((AddressObj.City__c !=  Null || !String.isblank(AddressObj.City__c)) && market == System.Label.JP && AddressObj.City__c.length() >=13 )
            {
                AddressObj.City__c.addError(Label.City_should_be_less_than_or_equal_to_12_letters);
            }
           else  if((AddressObj.District__c !=  Null || !String.isblank(AddressObj.District__c)) && market == System.Label.JP && AddressObj.District__c.length() >=19 )
            {
                AddressObj.District__c.addError(Label.City_should_be_less_than_or_equal_to_18_letters);
            }
            else  if((AddressObj.ZipCode__c !=  Null || !String.isblank(AddressObj.ZipCode__c)) && market == System.Label.JP && !AddressObj.ZipCode__c.isNumeric() )
            {
                AddressObj.ZipCode__c.addError('Zip Code should be numeric ');
            }
            else if((AddressObj.ZipCode__c !=  Null || !String.isblank(AddressObj.ZipCode__c)) && market == System.Label.JP && AddressObj.ZipCode__c.length() !=7 )
            {
                AddressObj.ZipCode__c.addError(Label.Zipcode_is_not_7_digits_long);
            }
            else if(AddressObj.ZipCode__c != null){
                AddressObj.MD__c = Market;
                ValidateAddressSearchCallout(AddressObj);
            } 
        }     
    }
    
    
    public List<addressSelectionWrapper> mapAddressResponse{get; set;}
    
    public void ValidateAddressSearchCallout(Address__c AddressObj){ 
        Boolean jpSwitchEnabledLandFlag = false;
        
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Landscape')){
            jpSwitchEnabledLandFlag = jpSwitchMap.get('Landscape').Enable_Flag__c;
        }
                                
        mapAddressResponse = new List<addressSelectionWrapper>();     
       
        //------------------------------------------------------------
                                if(market == System.Label.JP && jpSwitchEnabledLandFlag){
                                                HttpResponse httpResp = new HttpResponse();
                                                httpResp = getAddressResponse(AddressObj);
                                                ValidateAddressSearchCalloutJP(AddressObj,httpResp);
                                }
                                else{
                                                crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
                                                response =  UtilWebservice.validateAddressByZipCode(AddressObj,Autofill);
                                                if(response != null && response.AutoFillMode == true && AutoFill){
                                                                for(Integer i=0;i<response.Addresses.size();i++){                
                                                                                Address__c AddressObjtable = new Address__c(); 
                                                                                Address_Validated_Flag = true;
                                                                                if(response.Addresses[i].ZipCode != null && response.Addresses[i].ZipCode != ''){           
                                                                                                AddressObjtable.ZipCode__c =  response.Addresses[i].ZipCode;
                                                                                }else {
                                                                                                AddressObjtable.ZipCode__c = AddressObj.ZipCode__c;
                                                                                }
                                                                                if(response.Addresses[i].ValidFields != null && response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid){
                                                                                                String ValidStr = response.Addresses[i].ValidFields;
                                                                                                system.debug('ValidStr >> :'+ValidStr);
                                                                                                string province;   
                                                                                                Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                                                                                                UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtable.Province__c)){
                        province = addtrmapUpdate.get(AddressObjtable.Province__c);
                    }
                    if(ValidStr.contains('Address_Line_1__c') && Market == Label.JP)
                    {
                      AddressObjtable.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtable.Address_Line_1__c);
                    }
                    if(ValidStr.contains('Address_Line_2__c') && Market == Label.JP)
                    {
                      AddressObjtable.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtable.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c') && Market == Label.JP)
                    {
                      AddressObjtable.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtable.Block__c);
                    }
                    if(ValidStr.contains('City__c') && Market == Label.JP)
                    {
                         AddressObjtable.City__c = response.Addresses[i].City;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtable.City__c);
                    }
                    if(ValidStr.contains('District__c') && Market == Label.JP)
                    {
                        AddressObjtable.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtable.District__c);
                    }
                    if(ValidStr.contains('Province__c') && Market == Label.JP)
                    {
                         AddressObjtable.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtable.Province__c);
                    }
                             
                }
                mapAddressResponse.add(new addressSelectionWrapper(AddressObjtable));
            } 
            Autofill = false;  
        }
        else if(response != null && response.ValidationStatus == 'OK'){
            for(Integer i=0;i<response.Addresses.size();i++){                
                Address__c AddressObjtemp = new Address__c(); 
                Address_Validated_Flag = true;                
                AddressObjtemp.ZipCode__c =  response.Addresses[i].ZipCode;
                system.debug('>>>> :'+response.Addresses[i].Address_Line_1);              
                if(response.Addresses[i].ValidFields != null && response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid){
                    String ValidStr = response.Addresses[i].ValidFields;
                    system.debug('ValidStr >> :'+ValidStr);
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtemp.Province__c)){
                        province = addtrmapUpdate.get(AddressObjtemp.Province__c);
                    }                   
                    if(ValidStr.contains('Address_Line_1__c') && Market == Label.JP)
                    {
                      Addressobj.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == Label.JP)
                    {
                      AddressObj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                   
                    if(ValidStr.contains('Block__c') && Market == Label.JP)
                    {
                      AddressObj.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    
                    if(ValidStr.contains('City__c') && Market == Label.JP)
                    {
                      AddressObj.City__c = response.Addresses[i].City;
                       //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                    
                   if(ValidStr.contains('District__c') && Market == Label.JP)
                    {
                      AddressObj.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    
                   if(ValidStr.contains('Province__c') && Market == Label.JP)
                    {
                      AddressObj.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                    
                    if(ValidStr.contains('Block_Native__c') && Market == 'JP')
                    {
                      AddressObj.Block_Native__c= response.Addresses[0].Block_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Block_Native__c' + AddressObj.Block_Native__c);
                    }
                    if(ValidStr.contains('City_Native__c') && Market == 'JP')
                    {
                      AddressObj.City_Native__c= response.Addresses[0].City_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.City_Native__c' + AddressObj.City_Native__c);
                    }
                       if(ValidStr.contains('District_Native__c') && Market == 'JP')
                    {
                      AddressObj.District_Native__c= response.Addresses[0].District_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.District_Native__c' + AddressObj.District_Native__c);
                    } 
                    if(ValidStr.contains('Province_Native__c') && Market == 'JP')
                    {
                      AddressObj.Province_Native__c= response.Addresses[0].Province_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Province_Native__c' + AddressObj.Province_Native__c);
                    }
                     if(ValidStr.contains('Address_Line_1_Native__c') && Market == 'JP')
                    {
                      AddressObj.Address_Line_1_Native__c= response.Addresses[0].Address_Line_1_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1_Native__c' + AddressObj.Address_Line_1_Native__c);
                    }
                     if(ValidStr.contains('Address_Line_2_Native__c') && Market == 'JP')
                    {
                      AddressObj.Address_Line_2_Native__c= response.Addresses[0].Address_Line_2_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2_Native__c' + AddressObj.Address_Line_2_Native__c);
                    }
                      if(market != 'JP')
                    {
                   mapAddressResponse.add(new addressSelectionWrapper(AddressObjtemp));  
                   }
                }
                else if(!response.Addresses[i].Valid){
                
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObj.Province__c))
                    {
                        province = addtrmapUpdate.get(AddressObj.Province__c);
                    }
                    //AddressObj.Province__c =  province;
                    AddressObj.Temp_ZipCode__c = AddressObj.ZipCode__C;
                    AddressObj.Temp_Address__c = ((province != null) ? province : '' ) + ((AddressObj.City__c != null) ? AddressObj.City__c : '' ) +
                        ((AddressObj.District__c != null) ? AddressObj.District__c : '' ) + ((AddressObj.Block__c != null) ? AddressObj.Block__c  : '' ) +
                        ((AddressObj.Address_Line_1__c != null) ? AddressObj.Address_Line_1__c  : '' ) + ((AddressObj.Address_Line_2__c != null) ? AddressObj.Address_Line_2__c  : '' );
                                   
                }
            }           
        }
        if(response != null && response.ValidationStatus == 'ERROR')
        {
            AddressObj.Address_Code__c = '';
            AddressObj.Address_Line_1__c = '';
            AddressObj.Address_Line_2__c = '';
            AddressObj.Block__c = '';
            AddressObj.City__c = '';
            AddressObj.District__c = '';
            AddressObj.Province__c = '';
            AddressObj.Block_Native__c = '';      
            AddressObj.City_Native__c = '';        
            AddressObj.Province_Native__c ='';        
            AddressObj.District_Native__c = '';        
            AddressObj.Address_Line_1_Native__c = '';        
            AddressObj.Address_Line_2_Native__c = '';
            AddressObj.Temp_ZipCode__c = AddressObj.ZipCode__C;
            AddressObj.Temp_Address__c = ((AddressObj.Province__c != null) ? AddressObj.Province__c : '' ) + ((AddressObj.City__c != null) ? AddressObj.City__c : '' ) +
                    ((AddressObj.District__c != null) ? AddressObj.District__c : '' ) + ((AddressObj.Block__c != null) ? AddressObj.Block__c  : '' ) +
                    ((AddressObj.Address_Line_1__c != null) ? AddressObj.Address_Line_1__c  : '' ) + ((AddressObj.Address_Line_2__c != null) ? AddressObj.Address_Line_2__c  : '' );
            //mapAddressResponse.add(new addressSelectionWrapper(AddressObj));   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));
    
            }
                        
        }
                                
    }
    
     public HTTPResponse getAddressResponse(Address__C AddressObj){
        //metadata translation for Province should be checked.
        
        /*AddressRequest addReq = new AddressRequest(AddressObj);
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();          
        generator.writeBooleanField('AutoFillMode', AutoFill);   
        generator.writeFieldName('Address');
        generator.writeStartObject();
        generator.writeStringField('Address_Code', addReq.Address_Code==null?'':addReq.Address_Code);   
        generator.writeStringField('Address_Line_1', addReq.Address_Line_1==null?'':addReq.Address_Line_1);   
        generator.writeStringField('Address_Line_1_Native', addReq.Address_Line_1_Native==null?'':addReq.Address_Line_1_Native);   
        generator.writeStringField('Address_Line_2', addReq.Address_Line_2==null?'':addReq.Address_Line_2);   
        generator.writeStringField('Address_Line_2_Native', addReq.Address_Line_2_Native==null?'':addReq.Address_Line_2_Native);   
        generator.writeStringField('HouseNumber', addReq.HouseNumber==null?'':addReq.HouseNumber);   
        generator.writeStringField('Block', addReq.Block==null?'':addReq.Block);   
        generator.writeStringField('Block_Native', addReq.Block_Native==null?'':addReq.Block_Native);   
        generator.writeStringField('City', addReq.City==null?'':addReq.City);   
        generator.writeStringField('City_Native', addReq.City_Native==null?'':addReq.City_Native);   
        generator.writeStringField('District', addReq.District==null?'':addReq.District);   
        generator.writeStringField('District_Native', addReq.District_Native==null?'':addReq.District_Native);   
        generator.writeStringField('Province', addReq.Province==null?'':addReq.Province);   
        generator.writeStringField('Province_Native', addReq.Province_Native==null?'':addReq.Province_Native);   
        generator.writeStringField('ZipCode', addReq.ZipCode==null?'':addReq.ZipCode);   
        generator.writeStringField('MarketDiscriminator', addReq.MarketDiscriminator==null?'':addReq.MarketDiscriminator);     
        
        generator.writeEndObject();
        generator.writeEndObject();
        String requestBodyJSON = generator.getAsString();
        String jsonEndpoint = '';*/
		String endUrl = '';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c=='Landscape'){
                endUrl+=mapURLs.get(str).Informatica_URL__c+'?';
            }
        }
        List<Configuration_Rule__c> DedupCriteria= new List<Configuration_Rule__c>();
        DedupCriteria=[select id,(select id,Destination__c,Source__c,Object_API__c,Order__c from Configuration_Rule_Items__r where active__c=true order by Order__c) from Configuration_Rule__c where active__c=true and Market__c=:Market and type__c='Landscape' limit 1];         
        if(DedupCriteria.size()>0){
            for(Configuration_Rule__c c:DedupCriteria){
                if(c.Configuration_Rule_Items__r!=null && c.Configuration_Rule_Items__r.size()>0){
                    for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                        Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                        cri=c.Configuration_Rule_Items__r[i];
                        if(i!=0){
                            endUrl+='&';
                        }
                        if(cri.Object_API__c=='Address__c' && sendAddress){
                            if(cri.Destination__c=='ip_JPProvice'){
                                String tempProvinceTrans = doProvinceTranslation(AddressObj);
                                endUrl+=cri.Destination__c+((string.isnotblank(tempProvinceTrans))?EncodingUtil.URLENCODE(tempProvinceTrans,'UTF-8'):'');
                                
                            }
                            else{
                                endUrl+=cri.Destination__c+((string.isnotblank(string.valueof(AddressObj.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(AddressObj.get(cri.source__c)),'UTF-8'):'');
                            }   
                        }
                        else if(cri.Object_API__c=='Default'){
                            if(cri.Destination__c=='ip_JPAutofill'){
                                endUrl+=cri.Destination__c+(EncodingUtil.URLENCODE(String.valueOf(AutoFill),'UTF-8'));
                            }
                            else{
                                endUrl+=cri.Destination__c+((string.isnotblank((cri.source__c)))?EncodingUtil.URLENCODE((cri.source__c),'UTF-8'):'');
                            }
                        }
                    }
                }
            }
        }																			   
        
		/*     if(!mapURLs.isEmpty() && mapURLs.containsKey('JP-Address Handling')){
            jsonEndpoint = mapURLs.get('JP-Address Handling').Informatica_URL__c;
        }
		*/
        Map < string, string > headerCDM = new Map < string, string > ();
        headerCDM.put('Content-Type', 'application/json');                
		HTTPResponse response = CalloutHandlerService.sendCallout('GET', endUrl, 6000, headerCDM, null);
        //HTTPResponse response = CalloutHandlerService.sendCalloutForPost('P', jsonEndpoint, 6000, headerCDM, null,requestBodyJSON,System.Label.JP);
        return response;
       
    }
    
    
    
    //address request wrapper class.
    /*public class AddressRequest{
        public String Address_Code;
        public String Address_Line_1;
        public String Address_Line_1_Native;
        public String Address_Line_2;
        public String Address_Line_2_Native;
        public String HouseNumber;
        public String Block;
        public String Block_Native;
        public String City;
        public String City_Native;
        public String District;
        public String District_Native;
        public String Province;
        public String Province_Native;
        public String ZipCode;
        public String MarketDiscriminator;
                                    
        public AddressRequest(Address__c AddressObj){
            Address_Code = AddressObj.Address_Code__c; 
            Address_Line_1 = AddressObj.Address_Line_1__c;
            Address_Line_1_Native = AddressObj.Address_Line_1_Native__c;
            Address_Line_2 = AddressObj.Address_Line_2__c;
            Address_Line_2_Native = AddressObj.Address_Line_2_Native__c;
            HouseNumber = AddressObj.HouseNumber__c;
            Block = AddressObj.Block__c;
            Block_Native = AddressObj.Block_Native__c;
            City = AddressObj.City__c;
            City_Native = AddressObj.City_Native__c;
            District = AddressObj.District__c;
            District_Native = AddressObj.District_Native__c;
            Province = AddressObj.Province__c;
            Province_Native = AddressObj.Province_Native__c;
            ZipCode = AddressObj.ZipCode__c;
            MarketDiscriminator = AddressObj.MD__c;
        }
    }//end of address request wrapper class.
   */
    
    public void ValidateAddressSearchCalloutJP(Address__c AddressObj, HttpResponse httpResp){
            AddressResponseParser response = new AddressResponseParser();
            response = response.parse(httpResp.getBody());
            System.debug('Response after parsing ------------------------------>'+response);
            System.debug('Boolean values are ------------------------------>'+autofill);
            if(response != null && response.AutoFillMode == true && AutoFill){
                for(Integer i=0;i<response.Addresses.size();i++){                
                                Address__c AddressObjtable = new Address__c(); 
                                Address_Validated_Flag = true;
                                if(response.Addresses[i].ZipCode != null && response.Addresses[i].ZipCode != ''){           
                                                AddressObjtable.ZipCode__c =  response.Addresses[i].ZipCode;
                                }else {
                                                AddressObjtable.ZipCode__c = AddressObj.ZipCode__c;
                                }
                                if(response.Addresses[i].ValidFields != null && response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid){
                                                String ValidStr = response.Addresses[i].ValidFields;
                                                system.debug('ValidStr >> :'+ValidStr);
                                                string province;   
                                                Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                                                UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtable.Province__c)){
                            province = addtrmapUpdate.get(AddressObjtable.Province__c);
                    }
                    if(ValidStr.contains('Address_Line_1__c') && Market == Label.JP)
                    {
                                                                                                AddressObjtable.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtable.Address_Line_1__c);
                    }
                    if(ValidStr.contains('Address_Line_2__c') && Market == Label.JP)
                    {
                                                                                                AddressObjtable.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtable.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c') && Market == Label.JP)
                    {
                                                                                                AddressObjtable.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtable.Block__c);
                    }
                    if(ValidStr.contains('City__c') && Market == Label.JP)
                    {
                                                                                                AddressObjtable.City__c = response.Addresses[i].City;
                                                                                                //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtable.City__c);
                    }
                    if(ValidStr.contains('District__c') && Market == Label.JP)
                    {
                                                                                                AddressObjtable.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtable.District__c);
                    }
                    if(ValidStr.contains('Province__c') && Market == Label.JP)
                    {
                                                                            AddressObjtable.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtable.Province__c);
                    }         
                }
                System.debug('Address reponse field values are ------------------------------------------>'+addressObj);
                mapAddressResponse.add(new addressSelectionWrapper(AddressObjtable));
                
            } 
            Autofill = false;  
            System.debug('Address map values are ------------------------------------------>'+mapAddressResponse);
            System.debug('Display autofill mode ------------------------------------------>'+DisplayAutoFill );
        }
        else if(response != null && response.ValidationStatus == 'OK'){
            for(Integer i=0;i<response.Addresses.size();i++){                
                Address__c AddressObjtemp = new Address__c(); 
                Address_Validated_Flag = true;                
                AddressObjtemp.ZipCode__c =  response.Addresses[i].ZipCode;
                system.debug('>>>> :'+response.Addresses[i].Address_Line_1);              
                if(response.Addresses[i].ValidFields != null && response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid){
                    String ValidStr = response.Addresses[i].ValidFields;
                    system.debug('ValidStr >> :'+ValidStr);
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtemp.Province__c)){
                        province = addtrmapUpdate.get(AddressObjtemp.Province__c);
                    }                   
                    if(ValidStr.contains('Address_Line_1__c') && Market == Label.JP)
                    { 
                        Addressobj.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == Label.JP)
                    {
                         AddressObj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    
                    if(ValidStr.contains('Block__c') && Market == Label.JP)
                    {
                        AddressObj.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    
                    if(ValidStr.contains('City__c') && Market == Label.JP)
                    {
                          AddressObj.City__c = response.Addresses[i].City;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                    
                   if(ValidStr.contains('District__c') && Market == Label.JP)

                    {    AddressObj.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                   
                    if(ValidStr.contains('Province__c') && Market == Label.JP)
                    {
                       AddressObj.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                   
                    if(ValidStr.contains('Block_Native__c') && Market == 'JP')
                    {
                        AddressObj.Block_Native__c= response.Addresses[0].Block_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block_Native__c' + AddressObj.Block_Native__c);
                    }
                    if(ValidStr.contains('City_Native__c') && Market == 'JP')
                    {
                         AddressObj.City_Native__c= response.Addresses[0].City_Native;
                         system.debug(' *$*$*$* Res AddressObjtemp.City_Native__c' + AddressObj.City_Native__c);
                    }
                    if(ValidStr.contains('District_Native__c') && Market == 'JP')
                    {
                         AddressObj.District_Native__c= response.Addresses[0].District_Native;
                         system.debug(' *$*$*$* Res AddressObjtemp.District_Native__c' + AddressObj.District_Native__c);
                    } 
                    if(ValidStr.contains('Province_Native__c') && Market == 'JP')
                    {
                         AddressObj.Province_Native__c= response.Addresses[0].Province_Native;
                         system.debug(' *$*$*$* Res AddressObjtemp.Province_Native__c' + AddressObj.Province_Native__c);
                    }
                    if(ValidStr.contains('Address_Line_1_Native__c') && Market == 'JP')
                    {
                         AddressObj.Address_Line_1_Native__c= response.Addresses[0].Address_Line_1_Native;
                         system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1_Native__c' + AddressObj.Address_Line_1_Native__c);
                    }
                    if(ValidStr.contains('Address_Line_2_Native__c') && Market == 'JP')
                    {
                         AddressObj.Address_Line_2_Native__c= response.Addresses[0].Address_Line_2_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2_Native__c' + AddressObj.Address_Line_2_Native__c);
                    }
                    if(market != 'JP')
                    {
                            mapAddressResponse.add(new addressSelectionWrapper(AddressObjtemp));  
                    }
                }
                else if(!response.Addresses[i].Valid){																																	
                                                                                System.debug('^&^&^&^&^&^&^&^&^&^ valid venky'+response.Addresses[i].Valid);
                    string province;  
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObj.Province__c))
                    {
                        province = addtrmapUpdate.get(AddressObj.Province__c);
                    }
                    //AddressObj.Province__c =  province;
                    AddressObj.Temp_ZipCode__c = AddressObj.ZipCode__C;
                    AddressObj.Temp_Address__c = ((province != null) ? province : '' ) + ((AddressObj.City__c != null) ? AddressObj.City__c : '' ) +
                        ((AddressObj.District__c != null) ? AddressObj.District__c : '' ) + ((AddressObj.Block__c != null) ? AddressObj.Block__c  : '' ) +
                        ((AddressObj.Address_Line_1__c != null) ? AddressObj.Address_Line_1__c  : '' ) + ((AddressObj.Address_Line_2__c != null) ? AddressObj.Address_Line_2__c  : '' );
                                   
                }
            }           
        }
        if(response != null && response.ValidationStatus == 'ERROR')
        {
            AddressObj.Address_Code__c = '';
            AddressObj.Address_Line_1__c = '';
            AddressObj.Address_Line_2__c = '';
            AddressObj.Block__c = '';
            AddressObj.City__c = '';
            AddressObj.District__c = '';
            AddressObj.Province__c = '';
            AddressObj.Block_Native__c = '';      
            AddressObj.City_Native__c = '';        
            AddressObj.Province_Native__c ='';        
            AddressObj.District_Native__c = '';        
            AddressObj.Address_Line_1_Native__c = '';        
            AddressObj.Address_Line_2_Native__c = '';
            AddressObj.Temp_ZipCode__c = AddressObj.ZipCode__C;
            AddressObj.Temp_Address__c = ((AddressObj.Province__c != null) ? AddressObj.Province__c : '' ) + ((AddressObj.City__c != null) ? AddressObj.City__c : '' ) +
                    ((AddressObj.District__c != null) ? AddressObj.District__c : '' ) + ((AddressObj.Block__c != null) ? AddressObj.Block__c  : '' ) +
                    ((AddressObj.Address_Line_1__c != null) ? AddressObj.Address_Line_1__c  : '' ) + ((AddressObj.Address_Line_2__c != null) ? AddressObj.Address_Line_2__c  : '' );
            //mapAddressResponse.add(new addressSelectionWrapper(AddressObj));   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));
    
                                                
    }
 }	 
     //end of adderss response.           
       
    public class Addresses {
        public String Address_Code;
        public String Address_Line_1;
        public String Address_Line_1_Native;
        public String Address_Line_2;
        public String Address_Line_2_Native;
        public String HouseNumber;
        public String Block;
        public String Block_Native;
        public String City;
        public String City_Native;
        public String District;
        public String District_Native;
        public String Province;
        public String Province_Native;
        public String ZipCode;
        public String MarketDiscriminator;
        public String ValidFields;
        public Boolean Valid;
    }   
       
    public class AddressResponseParser {
        public String ValidationStatus;
        public Boolean AutoFillMode;
        public Addresses[] Addresses;
        public AddressResponseParser parse(String json) {
            return (AddressResponseParser) System.JSON.deserialize(json, AddressResponseParser.class);
        }
    }
    
    Public class addressSelectionWrapper{
        Public boolean isSelected{get;set;}       
        Public Address__c add{get;set;} 
        addressSelectionWrapper(Address__c add){
            this.add = add;
            }
   } 
    // Cancel button for jp readonly page
    public PageReference canceljp(){
        PageReference pageRef; 
        readonly=false;
        editmode=true;
        showCDM=false;
        
        pageRef = new PageReference('/apex/AddressSearchValidationCDM');
        return PageRef;
    }
                	   
	public void SelectedAddress(){
        for(addressSelectionWrapper cWrapper : mapAddressResponse){
           if(cWrapper.isSelected){
                AddressObj.Province__c = cWrapper.add.Province__c;
                AddressObj.City__c = cWrapper.add.City__c;
                AddressObj.District__c = cWrapper.add.District__c;
                AddressObj.Block__c= cWrapper.add.Block__c;
                AddressObj.ZipCode__c= cWrapper.add.ZipCode__c; 
                AddressObj.Address_Line_1__c= cWrapper.add.Address_Line_1__c;
                AddressObj.Address_Line_2__c= cWrapper.add.Address_Line_2__c;  
                AddressObj.Temp_ZipCode__c = '';
                AddressObj.Temp_Address__c = ''; 							  
        }                          
    }
	}//end of select address method.									
	public String doProvinceTranslation(Address__c AddressObj){
        String provinceStr = '';
        List<ProvinceTranslation__mdt> ProvinceCodeJP = [SELECT id,MD__c,Object__c,Picklist_Name__c,Province_EN1__c,Province_EN10__c,Province_EN11__c,Province_EN12__c,Province_EN13__c,  
                        Province_EN14__c,Province_EN15__c,Province_EN16__c,Province_EN17__c,Province_EN18__c,Province_EN19__c,Province_EN2__c,Province_EN20__c, 
                        Province_EN21__c,Province_EN22__c,Province_EN23__c,Province_EN24__c,Province_EN25__c,Province_EN26__c,Province_EN27__c,Province_EN28__c,    
                        Province_EN29__c,Province_EN3__c,Province_EN30__c,Province_EN31__c,Province_EN32__c,Province_EN33__c,Province_EN34__c,Province_EN35__c, 
                        Province_EN36__c,Province_EN37__c,Province_EN38__c,Province_EN39__c,Province_EN4__c,Province_EN40__c,Province_EN41__c,Province_EN42__c, 
                        Province_EN43__c,Province_EN44__c,Province_EN45__c,Province_EN46__c,Province_EN47__c,Province_EN5__c,Province_EN6__c,Province_EN7__c,   
                        Province_EN8__c,Province_EN9__c,Province_TR1__c,Province_TR10__c,Province_TR11__c,Province_TR12__c,Province_TR13__c,Province_TR14__c,   
                        Province_TR15__c,Province_TR16__c,Province_TR17__c,Province_TR18__c,Province_TR19__c,Province_TR2__c,Province_TR20__c,Province_TR21__c, 
                        Province_TR22__c,Province_TR23__c,Province_TR24__c,Province_TR25__c,Province_TR26__c,Province_TR27__c,Province_TR28__c,Province_TR29__c ,
                        Province_TR3__c,Province_TR30__c,Province_TR31__c,Province_TR32__c,Province_TR33__c,Province_TR34__c,Province_TR35__c,Province_TR36__c, 
                        Province_TR37__c,Province_TR38__c,Province_TR39__c,Province_TR4__c,Province_TR40__c,Province_TR41__c,Province_TR42__c,Province_TR43__c, 
                        Province_TR44__c,Province_TR45__c,Province_TR46__c,Province_TR47__c,Province_TR5__c,Province_TR6__c,Province_TR7__c,Province_TR8__c,Province_TR9__c 
                FROM ProvinceTranslation__mdt 
                WHERE MD__c=: AddressObj.MD__c LIMIT 1]; 
    
        for(ProvinceTranslation__mdt provinceCode : ProvinceCodeJP){
            if(AddressObj.Province__c == provinceCode.Province_EN1__c){
                provinceStr = provinceCode.Province_TR1__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN2__c){
                provinceStr = provinceCode.Province_TR2__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN3__c){
                provinceStr = provinceCode.Province_TR3__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN4__c){
                provinceStr = provinceCode.Province_TR4__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN5__c){
                provinceStr = provinceCode.Province_TR5__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN6__c){
                provinceStr = provinceCode.Province_TR6__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN7__c){
                provinceStr = provinceCode.Province_TR7__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN8__c){
                provinceStr = provinceCode.Province_TR8__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN9__c){
                provinceStr = provinceCode.Province_TR9__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN10__c){
                provinceStr = provinceCode.Province_TR10__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN11__c){
                provinceStr = provinceCode.Province_TR11__c;
            }            
            if(AddressObj.Province__c == provinceCode.Province_EN12__c){
                provinceStr = provinceCode.Province_TR12__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN13__c){
                provinceStr = provinceCode.Province_TR13__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN14__c){
                provinceStr = provinceCode.Province_TR14__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN15__c){
                provinceStr = provinceCode.Province_TR15__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN16__c){
                provinceStr = provinceCode.Province_TR16__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN17__c){
                provinceStr = provinceCode.Province_TR17__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN18__c){
                provinceStr = provinceCode.Province_TR18__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN19__c){
                provinceStr = provinceCode.Province_TR19__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN20__c){
                provinceStr = provinceCode.Province_TR20__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN21__c){
                provinceStr = provinceCode.Province_TR21__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN22__c){
                provinceStr = provinceCode.Province_TR22__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN23__c){
                provinceStr = provinceCode.Province_TR23__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN24__c){
                provinceStr = provinceCode.Province_TR24__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN25__c){
                provinceStr = provinceCode.Province_TR25__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN26__c){
                provinceStr = provinceCode.Province_TR26__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN27__c){
                provinceStr = provinceCode.Province_TR27__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN28__c){
                provinceStr = provinceCode.Province_TR28__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN29__c){
                provinceStr = provinceCode.Province_TR29__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN30__c){
                provinceStr = provinceCode.Province_TR30__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN31__c){
                provinceStr = provinceCode.Province_TR31__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN32__c){
                provinceStr = provinceCode.Province_TR32__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN33__c){
                provinceStr = provinceCode.Province_TR33__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN34__c){
                provinceStr = provinceCode.Province_TR34__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN35__c){
                provinceStr = provinceCode.Province_TR35__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN36__c){
                provinceStr = provinceCode.Province_TR36__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN37__c){
                provinceStr = provinceCode.Province_TR37__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN38__c){
                provinceStr = provinceCode.Province_TR38__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN39__c){
                provinceStr = provinceCode.Province_TR39__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN40__c){
                provinceStr = provinceCode.Province_TR40__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN41__c){
                provinceStr = provinceCode.Province_TR41__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN42__c){
                provinceStr = provinceCode.Province_TR42__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN43__c){
                provinceStr = provinceCode.Province_TR43__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN44__c){
                provinceStr = provinceCode.Province_TR44__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN45__c){
                provinceStr = provinceCode.Province_TR45__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN46__c){
                provinceStr = provinceCode.Province_TR46__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN47__c){
                provinceStr = provinceCode.Province_TR47__c;
            }           
        }
        return provinceStr;
        
    }		 

}