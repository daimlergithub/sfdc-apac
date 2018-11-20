/**
** Controller Class for Account Creation page AddressSearchValidation.
** OverRides Standard Account Creation "New" Button.
** Validates Address Details through webservice call to EP/Tolerant.
** Creates new Account with validated Address Record.
** Created By: Narasimha
** Date: 2016-1-20
** Modified By : Mohammed Touseef Ahmed
** Modified date :2017-03-12
** HN20171008- to set status for person account as Prospect 
 
History:
    Author                         Date                    Description
    Mohd Touseef(MT20170913)    2017/09/13            //MT20170913- Added market Descrminator MY
    Sanjay Nandi(SN20170907)    2017/09/09            //SN20170907- Pagination Logic
    Sanjay Nandi(SN20170912)    2017/09/12            //SN20170912- Area Code logic For MY
    Prabhata Rath(PR20170918)   2017/09/18            //PR20170918- CustomerSearch in CDM   
    Sanjay Nandi(SN20171028)    2017/10/28            //SN20171028- Added code to resolve issues related to search of CUstomer without address                                                                                                                                        
	Dheeraj/Vinod               2018/07/13            //changes related to switch to CDM page. Changes done in GOTOMARKETSPECIFIC method.																																	 
**/
public class AddressSearchValidationController
{
    //variables used in the page.
    ApexPages.StandardController controller;
    
    public string selectedRecordType{get;set;}
    public Account objAccount{get;set;}
    public Account objPersonAccount{get;set;}
    public Contact objContact{get; set;}
    public boolean refreshPage {get; set;}
    public boolean CompanyConfirmedMatch{get; set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    public id recordTypeId;
    public Boolean show {get;set;}
    public Account objAccountDeDup{get;set;}
    public List<Account> cResult{get;set;} 
    public Address__C AddressObj {get;set;}
    public boolean Address_Validated_Flag {get;set;}   
    Public Boolean Validation;
    public Boolean AutoFill {get;set;}
    public Boolean DisplayAutoFill {get;set;}
    public boolean Readonly {get;set;}
    public Boolean Editmode {get;set;}
    public Boolean cancel1 {get;set;}
    public Boolean personrectype {get;set;}
    public Boolean companyrectype {get;set;}
    public String var {get;set;}
    public map<string,string> labelNvalue=new map<string,string>();
    // KOREA related parameters - Start
    public String market{get;set;}
    public String homePhoneAreaCodePart1{get;set;}   
    public String homePhoneAreaCodePart2{get;set;}
    public String homePhoneAreaCodePart3{get;set;}
    public String workPhoneAreaCodePart1{get;set;}   
    public String workPhoneAreaCodePart2{get;set;}
    public String workPhoneAreaCodePart3{get;set;}
     public String workPhone2AreaCodePart1{get;set;}   
    public String workPhone2AreaCodePart2{get;set;}
    public String workPhone2AreaCodePart3{get;set;}
    public String homePhone2AreaCode{get;set;}
    public String homePhone2AreaCodePart2{get;set;}
    public String homePhone2AreaCodePart3{get;set;}
    public String mobileAreaCode{get;set;}
    public String mobileAreaCodePart2{get;set;}
    public String mobileAreaCodePart3{get;set;}
    public String AddressDetails{get;set;}
    public String TouchPoint{get;set;} 
    public Map<String,String> phoneAreaCodeMapKR {get;set;}//= new Map<String,String>();
    public string selectedValue { get;set; }
    public List<SelectOption> statusOptions { get;set; }
    public String addresspicklist{get;set;}
    public String provincepicklist{get;set;}
 public Boolean sendAddress;
       public Map<Id, String> accIdToAddressMap{get;set;}
    // KOREA related parameters - End
    Public boolean mbkdatasource {get;set;}
    Public boolean datasource {get;set;}
    Public boolean MBKrefreshPage {get;set;}
    public boolean MBKNoMatch{get;set;}
    
    //Introduced for TH market
    public String requestLabel{get;set;}
    public String LanguageSelected{get; set;}
    public List<SelectOption> lstDistrict{get; set;}
    public List<SelectOption> lstSubDistrict{get; set;}
    public List<SelectOption> lstZip{get; set;}
    public List<SelectOption> lstProvince{get; set;}
     public List<SelectOption> lstCountry{get; set;}        
    //Malaysia Country Codes        
    public List<SelectOption> lstCountryCode{get; set;}     
    public List<SelectOption> lstMobileAreaCode{get; set;}      
    public List<SelectOption> lstPhoneAreaCode{get; set;}       
            
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
    public static boolean phValidate;
    Public User u{get;set;}
    public Boolean nonContinuationResponse=true;
      //sravanthi Gudibandi added  for switch
    public Map<String,KR_Switch__c> KRSwitchMap = new Map<String,KR_Switch__c>();
    public Boolean KRSwitchEnabledFlag {get; set;}
    public Boolean KRSwitchOnlinededupFlag {get; set;}
    public Boolean KRSwitchForAddressDoctor {get;set;}
    Public Boolean KRSwitchCustomerSearch {get;set;}
     // Sravani Koppaka added for username and password of webservice
     public Map<String,AddressDoctorWebservice__c> AddDocCred = new Map<String,AddressDoctorWebservice__c>();
     public String username {get; set;}
     public String pwd {get;set;}    
    //PR20170918- Variable to hold JSON response from Informatica/CDM
    public JSON2ApexCustomerCDM custSearch{get;set;}
    public Boolean showCDM {get;set;}
    public Boolean one {get;set;}
    //MDK
    private Boolean isAddressValidated = FALSE;
    public List<AddressDTO> validatedAddressList { get; set; }
    public Boolean isAddressDrValidated { get; set; }
    public Boolean KrSwicthInvoke=false;
     /*     
    SN20170907      
    This variable are used to hold all the account list and display list and boolean variable are used to hide and enable the buttons in the section        
    */      
    public List<account> DedupAccountList{get;set;}     
    public list<account> displayAccList{get;set;}       
    public integer startindex{get;set;}     
    public integer LastIndex{get;set;}      
    public boolean first{get;set;}      
    public boolean Last{get;set;}       
    public boolean next{get;set;}       
    public boolean previous{get;set;}       
    /* SN20170907- END of the Variable and list created as part of Pagination*/
    /*SN20171709 - Added rendered condition*/
    public boolean hAreaBoolean{get;set;}
    Public boolean wAreaBoolean{get;set;}
    Public boolean fAreaBoolean{get;set;}
    /*SN20171709 - end*/
        // Constructor
        public boolean firstsave{get;set;}      
        public boolean secondsave{get;set;}
        
        Public static String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        public static String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
    
		/* JP Track related changed */
        public Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        public AddressSearchValidationController(ApexPages.StandardController controller){
        sendAddress = false;
        KRSwitchMap = KR_Switch__c.getAll();  
        KRSwitchEnabledFlag = false;
        KRSwitchOnlinededupFlag= false;
        KRSwitchForAddressDoctor=false;
        KRSwitchCustomerSearch=false;
        if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Call Flow Switch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('Call Flow Switch').Enable_Flag__c;
        }
        if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AddressDoctor')){
           KRSwitchForAddressDoctor = KRSwitchMap.get('AddressDoctor').Enable_Flag__c;
        }
        // Added to fetch username and wpd of webservice
        AddDocCred=AddressDoctorWebservice__c.getAll();
        if(!AddDocCred.isEmpty() && AddDocCred.containsKey('AddressDcotorCred')){
            username=AddDocCred.get('AddressDcotorCred').Username__c;
            pwd=AddDocCred.get('AddressDcotorCred').Password__c;
        }
        // Added for Online Deduplication by Sravani Koppaka
        if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CustomerSearchRuleKR')){
            KRSwitchCustomerSearch = KRSwitchMap.get('CustomerSearchRuleKR').Enable_Flag__c;
        }
        AutoFill = false;
       
      
        isAddressDrValidated = FALSE;
        objAccount= new Account();
        objPersonAccount= new Account();
        objContact=new contact();
        AddressObj = new Address__c();
        accountOwner=userinfo.getname();
        Address_Validated_Flag = false;
        validatedAddressList = new List<AddressDTO>();
        system.debug('>>>>>>@##Readonly'+Readonly);
        system.debug('<<<<<<<!@!#Editmode'+Editmode);
        
        Readonly=false;
      Editmode=true;
       companyrectype = false;
      personrectype = false;
        //Introduced for TH market
        IsForeignNational=false;
        MBKNoMatch=false;
        MBKrefreshPage= false;   
        // refreshPage = false;        
        u = [SELECT Id,Market__c,ContactId  FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        objAccount.Market__c=market;        
        AddressObj.Market__c=market;        
        objPersonAccount.Market__c=market; 
        
        objPersonAccount.Allow_Data_Sharing2__c = 'No';
        if(market == Label.KR){
            mbkdatasource = true;
            datasource = false;
        }
        if(market != Label.KR){
        if(u.ContactId !=null)
        {
        TouchPoint='Dealer Outlet';
       // objPersonAccount.Data_Source__c='Dealer Outlet';
        }
            mbkdatasource = false;
            datasource = true;
        }
        
        //MT20170913-Fill in CountryCodes  and area code for phone    
        lstMobileAreaCode=new List<SelectOption>();     
        lstCountryCode=new List<SelectOption>();        
        lstPhoneAreaCode=new List<SelectOption>();      
        
            hAreaBoolean=false;
            wAreaBoolean=false;
            fAreaBoolean=false;  
         
        for(PhoneAreaCode__c pac : [select Country_Code__c,Mobile_Area_Code__c,Phone_Area_Code__c from PhoneAreaCode__c where Phone_Area_Code__c!='' order by Phone_Area_Code__c])      
        {       
             lstPhoneAreaCode.add(new SelectOption(pac.Phone_Area_Code__c,pac.Phone_Area_Code__c));     
        }       
             
                
        AggregateResult[] pac = [SELECT Country_Code__c FROM PhoneAreaCode__c GROUP BY Country_Code__c];        
         for(AggregateResult p : pac)       
        {       
            string code=string.valueof(p.get('Country_Code__c'));       
             lstCountryCode.add(new SelectOption(code,code));       
        }       
        //MT20170913- end
        
        //Introduced for TH market      
         if(market==Label.TH)
        {
            //firstsave = true;  
            
            
            secondsave = false;
            mbCountryCode='+66';
            hmCountryCode='+66';
            wkCountryCode='+66';
            faxCountryCode='+66';
        }
         //Introduced for KR market and added switch
         if(market==Label.KR)//Sravanthi Gudibandi
        {
         if(KRSwitchEnabledFlag){
            mbCountryCode='+82';
            hmCountryCode='+82';
            wkCountryCode='+82';
        }
            
            objAccount.Market__c=market;
            LoadProvince();
        }
      
         else if(market=='AU') //  Sada US-2/3 2018/March/22 R1  
        {
           //   firstsave = true;   //sada - disabling save button initially 
            secondsave = false;// need to change later

            objAccount.Market__c=market;
			LoadCountryCode();
        }   
      else if(market=='NZ') //  Sada US-2/3 2018/March/22 R1  
        {
             // firstsave = true;    //sada - disabling save button initially 
            secondsave = false;// need to change later
            objAccount.Market__c=market;
            LoadCountryCode();
        } 

        
        else
        {
            firstsave = false;  
          //  secondsave = true; 
        }
        //MT20170913
        if(market==Label.MY){        
            AddressObj.Country__c='Malaysia';
            objAccount.Market__c=market; 
            LoadProvince();     
            
        }        
        //SN20170907 -added Pagination Variable initialization      
        DedupAccountList= new List<account>();      
        displayAccList=new list<account>();     
        startIndex=0;               
        last=false;     
        previous=false;     
        first=false;        
        next=false;  
        
        //SN20170907
        showCDM=false;
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

    //Fills Province Picklist based on Language selected
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
        lstSubDistrict=new List<SelectOption>();
        lstZip=new List<SelectOption>();
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
            if(!setDistricts.contains(lsttempDistrict.District__c))
            {
                lstDistrict.add(new SelectOption(lsttempDistrict.District__c,lsttempDistrict.District__c));
                setDistricts.add(lsttempDistrict.District__c);
            }
        }
        lstSubDistrict=new List<SelectOption>();
        lstZip=new List<SelectOption>();
      }
      
     //Fills Country Code
      public void LoadCountryCode()
      {

        if( objAccount.Market__c=='AU') 
        {

            secondsave = false;// need to change later
            mbCountryCode='+61';
            hmCountryCode='+61';
            wkCountryCode='+61';
            faxCountryCode='+61';
            AddressObj.Country__c='Australia';
            AddressObj.market__c = objAccount.Market__c;
        }   
      else if(objAccount.Market__c=='NZ') 
        {

            secondsave = false;// need to change later
            mbCountryCode='+64';
            hmCountryCode='+64';
            wkCountryCode='+64';
            faxCountryCode='+64';
            AddressObj.Country__c='New Zealand';
            AddressObj.market__c = objAccount.Market__c;
        } 
        
      }
	  
	  
      //Fills Subdistrict picklist based on District Selection
      public void LoadSubDistrict()
      {
        lstSubDistrict=new List<SelectOption>();
        Set<string> setSubDistricts = new set<string>();
        lstSubDistrict.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempSubDistrict : [select id,Sub_DIstrict__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Province__c=:province and District__c=:district order by Sub_DIstrict__c asc])
        {
            if(!setSubDistricts.contains(lsttempSubDistrict.Sub_DIstrict__c))
            {
                lstSubDistrict.add(new SelectOption(lsttempSubDistrict.Sub_DIstrict__c,lsttempSubDistrict.Sub_DIstrict__c));
                setSubDistricts.add(lsttempSubDistrict.Sub_DIstrict__c);
            }
        }
        lstZip=new List<SelectOption>();
      }
      
      //Fills Zip picklist based on the Sub District selected
      public void LoadZip()
      {
        lstZip=new List<SelectOption>();
        Set<string> setZip = new set<string>();
        lstZip.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempSubDistrict : [select id,ZipCode__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Province__c=:province and District__c=:district and Sub_DIstrict__c=:subdistrict])
        {
            if(!setZip.contains(lsttempSubDistrict.ZipCode__c))
            {
                lstZip.add(new SelectOption(lsttempSubDistrict.ZipCode__c,lsttempSubDistrict.ZipCode__c));
                setZip.add(lsttempSubDistrict.ZipCode__c);
            }
        }
      }
      
       public void ShowHideFields()
      {
       if(market == System.Label.TH)
       {  
            if(AddressObj.Foreign_Nationals__c==true)
                IsForeignNational=true;
            else
                IsForeignNational=false;
        }
        else if(market == System.Label.MY)
        {
            if(AddressObj.Country__c!=Label.MYCountry){
                
                IsForeignNational=true;
                province='';
                district='';
                
            }
            else{
                IsForeignNational=false;
                //SN20171006- Added code to default value
                province='--Select--';
                district='--Select--';
            }
         }
       }
    //Introduced for TH market - End

    /**  Save Account based on two scenarios
* 1. With Validated Address information record.
* 2.Without Address record.
**  Created By: Narasimha 
**  Date: 2016-1-19
**/
    
    public pagereference saveAccount(){    
        
        if( market == System.Label.KR){
               
 KR_Switch__c KRSwitchMap = KR_Switch__c.getValues('CustomerSearchRuleKR');
         if(KRSwitchMap != null && KRSwitchMap.Enable_Flag__c == false){
            
            onLineDeduplication();
       
         }
       //onLineDeduplication();
       if(MBKrefreshPage==true&& MBKNoMatch==false){
       System.debug('------entering Save3'); return null;
       }
       }
        if(addresspicklist!=null)
        AddressObj.Address_Type__c = addresspicklist;
        //AddressObj.Province__c = provincepicklist;
        Validation = false;
        
        
           Schema.DescribeFieldResult fieldResult = Account.Data_Source__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
              if(UserInfo.getLocale()=='ja_JP')
            {
              labelNvalue.put(f.getLabel(),f.getValue());
            } else{
            labelNvalue.put(f.getValue(),f.getLabel());
            }
           }
           TouchPoint=labelNvalue.get(TouchPoint);
        // Save record without Address record if no value is Entered in Address section
        if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--') && AddressObj.Address_Line_1__c ==null && AddressObj.Address_Line_2__c == null &&
           AddressObj.ZipCode__c == null && AddressObj.Block__c ==  null && AddressObj.City__c == null &&  AddressObj.District__c == null &&
           AddressObj.Province__c == null)
        {   
            try
            {
                if(recordType == 'Company' &&  market != System.Label.KR)
                {
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
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
                        if(TouchPoint !=null)
                        {
                         objAccount.Data_Source__c=TouchPoint;
                        }
                        
                        insert objAccount ;
                        PageReference pageRef = new PageReference('/'+objAccount.Id);
                        return PageRef;
                    }                   
                }               
                if(recordType == 'Person Account' &&  market != System.Label.KR)
                {                   
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    if(objPersonAccount.Individual_Home_Phone__c == null && objPersonAccount.Mobile__c == null && objPersonAccount.Work_Phone__c == null &&
                       objPersonAccount.Mobile2__c == null && objPersonAccount.Home_Phone_2__c == null &&  objPersonAccount.Phone == null &&
                       objPersonAccount.Email__c == null && objPersonAccount.Email2__c == null)
                    {
                       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    }
                    else
                    {   
                        refreshPage = true;
                        if(TouchPoint !=null)
                        {
                        
                        objPersonAccount.Data_Source__c=TouchPoint;
                        } 
                        if(objPersonAccount.Acquisition_Objective_Method__c !=null && objPersonAccount.Allow_Data_Sharing2__c =='Yes')
                        {
                        objPersonAccount.Acquisition_Record_Date__c=System.today();
                        }
                        insert objPersonAccount ;
                        PageReference pageRef = new PageReference('/'+objPersonAccount.Id);
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
      
        if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == Null || AddressObj.Address_Type__c == '--None--') && AddressObj.Address_Line_1__c ==null && AddressObj.Address_Line_2__c == null && AddressObj.ZipCode__c == null){
            try{        
                
                if(recordType == System.Label.Company && market == System.Label.KR)
                {    
                    
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.Company).getRecordTypeId();
                    objAccount.RecordTypeId = recordTypeId;
                  //for Call  flow changes  country code added by Sravanthi Gudibandi.
                   system.debug('KRSwitchEnabledFlag:'+ KRSwitchEnabledFlag);
                  if(KRSwitchEnabledFlag){
                   if(hmCountryCode=='' && homePhoneAreaCodePart1== ' ' && homePhoneAreaCodePart2== '' && homePhoneAreaCodePart3== '')
                  {    
                                          
                       objAccount.Individual_Home_Phone__c = '';
                    }
                    
       else if((hmCountryCode!= ' ') &&(homePhoneAreaCodePart1 != ' ' ) && (homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 != ''))                    
            {       
                                       
                        objAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objAccount.Individual_Home_Phone__c = objAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }              
                    else
                    {
                       
                         objAccount.Individual_Home_Phone__c = '';
                    }
               
            }
     else{
                    if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                    {    
                                          
                        objAccount.Individual_Home_Phone__c = '';
                    }
                    else if((homePhoneAreaCodePart1 != ' ' || homePhoneAreaCodePart1 == ' ') && (homePhoneAreaCodePart2 == '' || homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 == '' || homePhoneAreaCodePart3 != ''))
                    {       
                                       
                        objAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objAccount.Individual_Home_Phone__c = objAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }                    
                    else
                    {
                       
                        objAccount.Individual_Home_Phone__c = '';
                    }
     }
     
               if(KRSwitchEnabledFlag){
                    if(wkCountryCode=='' && workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone__c = '';
                    }
                    else if((wkCountryCode != ' ') &&(workPhoneAreaCodePart1 != ' ') && (workPhoneAreaCodePart2 != '') && (workPhoneAreaCodePart3 != ''))
                    {                         
                        objAccount.Work_Phone__c =  wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                        if(objAccount.Work_Phone__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone__c = objAccount.Work_Phone__c.removeStart(' -');
                        }
                   }
                    else
                    {
                         objAccount.Work_Phone__c = ''; 
                    }
                    
                    }
                     else{
                       if(workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone__c = '';
                    }
                    else if((workPhoneAreaCodePart1 != ' ' || workPhoneAreaCodePart1 == ' ') && (workPhoneAreaCodePart2 != '' || workPhoneAreaCodePart2 == '') && (workPhoneAreaCodePart3 != '' || workPhoneAreaCodePart3 == ''))
                    {                         
                        objAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                        if(objAccount.Work_Phone__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone__c = objAccount.Work_Phone__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Work_Phone__c = '';
                    }
                     }
          //1606 changes added by Monalisa
          if(KRSwitchEnabledFlag){
          if(wkCountryCode=='' && workPhone2AreaCodePart1 == ' ' && workPhone2AreaCodePart2 == '' && workPhone2AreaCodePart3 == '')
                    {                      
                         objAccount.Work_Phone_2__c = '';
                    }
                    else if((wkCountryCode != ' ') &&(workPhone2AreaCodePart1 != ' ') && (workPhone2AreaCodePart2 != '') && (workPhone2AreaCodePart3 != ''))
                    {                         
                        objAccount.Work_Phone_2__c =wkCountryCode+'-'+workPhone2AreaCodePart1+'-'+workPhone2AreaCodePart2+'-'+workPhone2AreaCodePart3;
                        if(objAccount.Work_Phone_2__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone_2__c = objAccount.Work_Phone_2__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Work_Phone_2__c = '';
                    }
                    }
                    
                     else{
                       if(workPhone2AreaCodePart1 == ' ' && workPhone2AreaCodePart2 == '' && workPhone2AreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone_2__c = '';
                    }
                    else if((workPhone2AreaCodePart1 != ' ' || workPhone2AreaCodePart1 == ' ') && (workPhone2AreaCodePart2 != '' || workPhone2AreaCodePart2 == '') && (workPhone2AreaCodePart3 != '' || workPhone2AreaCodePart3 == ''))
                    {                         
                        objAccount.Work_Phone_2__c = workPhone2AreaCodePart1+'-'+workPhone2AreaCodePart2+'-'+workPhone2AreaCodePart3;
                        if(objAccount.Work_Phone_2__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone_2__c = objAccount.Work_Phone_2__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Work_Phone_2__c = '';
                    }
                     }
                      if(KRSwitchEnabledFlag){
                    if(mbCountryCode==''&& mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objAccount.Mobile__c = '';
                    }
                    else if((mbCountryCode != '') &&(mobileAreaCode != ' ') && (mobileAreaCodePart2 != '') && (mobileAreaCodePart3 !=''))
                    {              
                        objAccount.Mobile__c=mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objAccount.Mobile__c.startsWith(' -'))
                        {
                            objAccount.Mobile__c = objAccount.Mobile__c.removeStart(' -');
                        }
                        
                    }
                    else
                    {
                        objAccount.Mobile__c = '';
                    } 
                    }
                     else{
                      if(mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objAccount.Mobile__c = '';
                    }
                    else if((mobileAreaCode != ' ') && (mobileAreaCodePart2 != '' || mobileAreaCodePart2 == '') && (mobileAreaCodePart3 !='' || mobileAreaCodePart3 == ''))
                    {              
                        objAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objAccount.Mobile__c.startsWith(' -'))
                        {
                            objAccount.Mobile__c = objAccount.Mobile__c.removeStart(' -');
                        }
                        
                    }
                    else
                    {
                        objAccount.Mobile__c = '';
                    } 
                     }
                    if(objAccount.Individual_Home_Phone__c == '' && objAccount.Mobile__c == '' && objAccount.Work_Phone__c == '' && objAccount.Email__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    
                       if(objAccount.Vat_No__c == null && objAccount.Commercial_Reg_No__c == null)
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Commercial Registration Number / Vat Registration Number'));
                    }
                    //Added by Sravani Koppaka -- Start
                     if(KRSwitchEnabledFlag){
                    if(AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == Null || AddressObj.Address_Type__c == '--None--'){
                        system.debug('Entered to address type validation-->>>');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address Type is Mandatory')); 
                        
                    }
                    if(addressobj.Province__c == null || addressobj.Province__c == '' || addressobj.Province__c == '--None--'){
                        system.debug('Entered to address province validation-->>>');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prefecture is Mandatory.'));
                        
                    }
                    }
                    //Added by Sravani Koppaka -- end
                    else{
                        refreshPage = true;                      
                        insert objAccount ;
                        PageReference pageRef = new PageReference('/'+objAccount.Id);
                        return PageRef; 
                    } 
                }
               
                if(recordType == System.Label.PersonAccount && market == System.Label.KR){    
                    
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.PersonAccount).getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    //for Call  flow changes  country code added by Sravanthi Gudibandi.
      if(KRSwitchEnabledFlag){
     if(hmCountryCode=='' && homePhoneAreaCodePart1== ' ' && homePhoneAreaCodePart2== '' && homePhoneAreaCodePart3== '')
                  {    
                                          
                       objPersonAccount.Individual_Home_Phone__c = '';
                    }
                    
       else if((hmCountryCode!= ' ') &&(homePhoneAreaCodePart1 != ' ' ) && (homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 != ''))                    
            {       
                                       
                        objPersonAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objPersonAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objPersonAccount.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }              
                    else
                    {
                       
                         objPersonAccount.Individual_Home_Phone__c = '';
                    }
                    }
                    else{
                     if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                    {    
                                        
                        objPersonAccount.Individual_Home_Phone__c = '';
                    }
                    else if((homePhoneAreaCodePart1 != ' ' || homePhoneAreaCodePart1 == ' ') && (homePhoneAreaCodePart2 == '' || homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 == '' || homePhoneAreaCodePart3 != ''))
                    {             
                        objPersonAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objPersonAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objPersonAccount.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }                    
                    else
                    {
                        
                        objPersonAccount.Individual_Home_Phone__c = '';
                    }
                    }
                    if(KRSwitchEnabledFlag){
                    if(wkCountryCode=='' && workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objPersonAccount.Work_Phone__c = '';
                    }
                    else if((wkCountryCode != ' ') &&(workPhoneAreaCodePart1 != ' ') && (workPhoneAreaCodePart2 != '') && (workPhoneAreaCodePart3 != ''))
                    {                         
                        objPersonAccount.Work_Phone__c =wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                        if(objPersonAccount.Work_Phone__c.startsWith(' -'))
                        {
                           objPersonAccount.Work_Phone__c = objPersonAccount.Work_Phone__c.removeStart(' -');
                       }
                   }
                    else
                    {
                         objPersonAccount.Work_Phone__c = '';
                    }
                    }
                    else
                    {
                     if(workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objPersonAccount.Work_Phone__c = '';
                    }
                    else if((workPhoneAreaCodePart1 != ' ' || workPhoneAreaCodePart1 == ' ') && (workPhoneAreaCodePart2 != '' || workPhoneAreaCodePart2 == '') && (workPhoneAreaCodePart3 != '' || workPhoneAreaCodePart3 == ''))
                    {                         
                        objPersonAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                        if(objPersonAccount.Work_Phone__c.startsWith(' -'))
                        {
                            objPersonAccount.Work_Phone__c = objPersonAccount.Work_Phone__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objPersonAccount.Work_Phone__c = '';
                    }
                    }
                    if(KRSwitchEnabledFlag){
                    if(mbCountryCode=='' && mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objPersonAccount.Mobile__c = '';
                    }
                    else if((mbCountryCode != '') &&(mobileAreaCode != ' ') && (mobileAreaCodePart2 != '') && (mobileAreaCodePart3 !=''))
                    {              
                        objPersonAccount.Mobile__c=mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objPersonAccount.Mobile__c.startsWith(' -'))
                        {
                            objPersonAccount.Mobile__c = objPersonAccount.Mobile__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objPersonAccount.Mobile__c = '';
                    }
                    }
                     else
                    {
                       if(mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objPersonAccount.Mobile__c = '';
                    }
                    else if((mobileAreaCode != ' ') && (mobileAreaCodePart2 != '' || mobileAreaCodePart2 == '') && (mobileAreaCodePart3 !='' || mobileAreaCodePart3 == ''))
                    {              
                        objPersonAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objPersonAccount.Mobile__c.startsWith(' -'))
                        {
                            objPersonAccount.Mobile__c = objPersonAccount.Mobile__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objPersonAccount.Mobile__c = '';
                    }
                    }
                    if(objPersonAccount.Individual_Home_Phone__c == '' && objPersonAccount.Mobile__c == '' && objPersonAccount.Work_Phone__c == '' && objPersonAccount.Email__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    }
                    // Added by Sravani Koppaka -- Start
                     if(KRSwitchEnabledFlag){
                    if(AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == '--None--')
                    {   system.debug('--Entered to else if of address type person account');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address Type is Mandatory')); 
                        
                    }
                     if(addressobj.Province__c == null || addressobj.Province__c == '' || addressobj.Province__c == '--None--'){
                        system.debug('Entered to address province validation-->>>');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prefecture is Mandatory.'));
                        
                    }
                    }
                    // Added by Sravani Koppaka -- End
                    else
                    {
                    refreshPage = true;                      
                    insert objPersonAccount;
                    PageReference pageRef = new PageReference('/'+objPersonAccount.Id);
                    return PageRef;  
                    }
                }
            }
            catch(DMLException e){
                refreshPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));     
            }   
        }       
        // Save record with Address record validating it through EP/Tolerant
        else
        {
            try{
                if(recordType == System.Label.Company && market == System.Label.KR)
                {                   
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.Company).getRecordTypeId();
                   objAccount.RecordTypeId = recordTypeId;                   
                    if(!Address_Validated_Flag)
                    {
                        if(!KRSwitchForAddressDoctor){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = true;
                        }
                    }
                    if(AddressObj.Address_Type__c == null )
                    {   
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation)); 
                        Validation = true;
                    }
		     if(KRSwitchEnabledFlag){
		       if(AddressObj.Address_Type__c == null ||AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == '--None--' )
                    {   
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation)); 
                        Validation = true;
                    }
                   if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = true;                      
                    }
                    if(addressobj.ZipCode__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));
                        Validation = true;
                    }
                    if(addressobj.Province__c == null || addressobj.Province__c=='' || addressobj.Province__c=='--None--')
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prefecture is Mandatory.'));
                        Validation = true;
                    } 
                    } 
		    
                    /*if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = true;                      
                    }
                    if(addressobj.ZipCode__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));
                        Validation = true;
                    }
                    if(addressobj.Address_Line_1__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address_Line_1__c is Mandatory.')); 
                        Validation = true;                      
                    }
                    if(addressobj.Province__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.'));
                        Validation = true;                      
                    }*/
                       //for Call  flow changes  country code added by Sravanthi Gudibandi.
                       if(KRSwitchEnabledFlag){
         if(hmCountryCode=='' && homePhoneAreaCodePart1== ' ' && homePhoneAreaCodePart2== '' && homePhoneAreaCodePart3== '')

                    {    
                        system.debug('*$*$*$ Entered HOme Null scenario');                  
                         objAccount.Individual_Home_Phone__c = '';
                    }
                           else if((hmCountryCode!= ' ') &&(homePhoneAreaCodePart1 != ' ' ) && (homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 != ''))                    

                    {       
                                       
                        objAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objAccount.Individual_Home_Phone__c = objAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }                       
                    else
                    {
                        system.debug('*$*$*$ Entered BLANK scenario'); 
                        objAccount.Individual_Home_Phone__c = '';
                    }
                    }
                    else
                    {
                     if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                    {    
                        system.debug('*$*$*$ Entered HOme Null scenario');                  
                        objAccount.Individual_Home_Phone__c = '';
                    }
                    else if((homePhoneAreaCodePart1 != ' ' || homePhoneAreaCodePart1 == ' ') && (homePhoneAreaCodePart2 == '' || homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 == '' || homePhoneAreaCodePart3 != ''))
                    {       
                        system.debug('*$*$*$ Entered HOme either Null or not null scenario');               
                        objAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objAccount.Individual_Home_Phone__c = objAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }                    
                    else
                    {
                        system.debug('*$*$*$ Entered BLANK scenario'); 
                        objAccount.Individual_Home_Phone__c = '';
                    }
                    }
                    if(KRSwitchEnabledFlag){
                    if(wkCountryCode=='' && workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone__c = '';
                    }
                    else if((wkCountryCode != ' ') &&(workPhoneAreaCodePart1 != ' ') && (workPhoneAreaCodePart2 != '') && (workPhoneAreaCodePart3 != ''))
                    {                         
                        objAccount.Work_Phone__c = wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                       if(objAccount.Work_Phone__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone__c = objAccount.Work_Phone__c.removeStart(' -');
                        }
                   }
                    else
                    {
                        objAccount.Work_Phone__c = '';
                    }
                    }
                     else
                    {
                     if(workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone__c = '';
                    }
                    else if((workPhoneAreaCodePart1 != ' ' || workPhoneAreaCodePart1 == ' ') && (workPhoneAreaCodePart2 != '' || workPhoneAreaCodePart2 == '') && (workPhoneAreaCodePart3 != '' || workPhoneAreaCodePart3 == ''))
                    {                         
                        objAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                        if(objAccount.Work_Phone__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone__c = objAccount.Work_Phone__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Work_Phone__c = '';
                    }
                    }
                      if(KRSwitchEnabledFlag){
          if(wkCountryCode=='' &&workPhone2AreaCodePart1 == ' ' && workPhone2AreaCodePart2 == '' && workPhone2AreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone_2__c = '';
                    }
                    else if((wkCountryCode != ' ') &&(workPhone2AreaCodePart1 != ' ') && (workPhone2AreaCodePart2 != '') && (workPhone2AreaCodePart3 != ''))
                    {                         
                        objAccount.Work_Phone_2__c = wkCountryCode+'-'+workPhone2AreaCodePart1+'-'+workPhone2AreaCodePart2+'-'+workPhone2AreaCodePart3;
                        if(objAccount.Work_Phone_2__c.startsWith(' -'))
                        {
                           objAccount.Work_Phone_2__c = objAccount.Work_Phone_2__c.removeStart(' -');
                       }
                    }
                    else
                    {
                        objAccount.Work_Phone_2__c = '';
                    }
                    }
                     
                     else
                    {
                     if(workPhone2AreaCodePart1 == ' ' && workPhone2AreaCodePart2 == '' && workPhone2AreaCodePart3 == '')
                    {                      
                        objAccount.Work_Phone_2__c = '';
                    }
                    else if((workPhone2AreaCodePart1 != ' ' || workPhone2AreaCodePart1 == ' ') && (workPhone2AreaCodePart2 != '' || workPhone2AreaCodePart2 == '') && (workPhone2AreaCodePart3 != '' || workPhone2AreaCodePart3 == ''))
                    {                         
                        objAccount.Work_Phone_2__c = workPhone2AreaCodePart1+'-'+workPhone2AreaCodePart2+'-'+workPhone2AreaCodePart3;
                        if(objAccount.Work_Phone_2__c.startsWith(' -'))
                        {
                            objAccount.Work_Phone_2__c = objAccount.Work_Phone_2__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Work_Phone_2__c = '';
                    }
                    }
                    if(KRSwitchEnabledFlag){
                    if(mbCountryCode=='' &&mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objAccount.Mobile__c = '';
                    }
                    else if((mbCountryCode != '') &&(mobileAreaCode != ' ') && (mobileAreaCodePart2 != '') && (mobileAreaCodePart3 !=''))
                    {              
                        objAccount.Mobile__c= mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objAccount.Mobile__c.startsWith(' -'))
                        {
                            objAccount.Mobile__c = objAccount.Mobile__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Mobile__c = '';
                    } 
                    } 
                     else
                    {
                     if(mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                    {              
                        objAccount.Mobile__c = '';
                    }
                    else if((mobileAreaCode != ' ' || mobileAreaCode == ' ') && (mobileAreaCodePart2 != '' || mobileAreaCodePart2 == '') && (mobileAreaCodePart3 !='' || mobileAreaCodePart3 == ''))
                    {              
                        objAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                        if(objAccount.Mobile__c.startsWith(' -'))
                        {
                            objAccount.Mobile__c = objAccount.Mobile__c.removeStart(' -');
                        }
                    }
                    else
                    {
                        objAccount.Mobile__c = '';
                    }  
                    }
                    if(Validation == False){
                        refreshPage = true;
                        objAccount.id = null;
                        insert objAccount ;
                        AddressObj.Customer__c = objAccount.id;
                        AddressObj.Preferred__c = true;
                        if(AddressObj.Temp_ZipCode__c == null && AddressObj.Temp_Address__c == null)
                        {
                            if(!KRSwitchForAddressDoctor){
                        AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                              }
                        }

                        insert AddressObj;
                        PageReference pageRef = new PageReference('/'+objAccount.Id);
                        return PageRef;
                    }
                }         
                
                else if( recordType == 'Company' && market != System.Label.KR)
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
                        if(!KRSwitchForAddressDoctor){
                        AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                            }
                        insert AddressObj;
                        PageReference pageRef = new PageReference('/'+objAccount.Id); 
                        return PageRef;
                    }                  
                    
                }
                
                system.debug('recordType 6:'+ recordType);
                system.debug('recordType 7:'+ System.Label.PersonAccount);
                if(recordType == System.Label.PersonAccount && market == System.Label.KR)
                {   
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.PersonAccount).getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    system.debug('recordType 8:'+ objPersonAccount.Mobile__c);                    
                    system.debug('mobileAreaCode >>:'+mobileAreaCode);  
                    if(!Address_Validated_Flag)
                    {
                        if(!KRSwitchForAddressDoctor){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = TRUE;
                        }
                    }
                    if(AddressObj.Address_Type__c == null )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        Validation = TRUE;
                    } 
 if(KRSwitchEnabledFlag){
   if(AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == '--None--')
                    {
                        system.debug('--address type');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        Validation = TRUE;
                    } 
                     if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
                    {
                         system.debug('--address zip not null');    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = TRUE;
                    }
                    if(addressobj.ZipCode__c == null)
                    {
                         system.debug('--address zip null');    
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));
                        Validation = TRUE;
                    }
		     if(addressobj.Province__c == null || addressobj.Province__c == '' || addressobj.Province__c == '--None--')
                    {
                         system.debug('--address province');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prefecture is Mandatory.'));
                        Validation = TRUE;
                    }  
                    }
                    /* if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = TRUE;
                    }
                    if(addressobj.ZipCode__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));
                        Validation = TRUE;
                    }
                    if(addressobj.Address_Line_1__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address_Line_1__c is Mandatory.'));
                        Validation = TRUE;
                    }
                    if(addressobj.Province__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.'));
                        Validation = TRUE;
                    }  
                    */                 
                    if ((Address_Validated_Flag) && AddressObj.Address_Type__c != null )
                    {  
                                      //for Call  flow changes  country code added by Sravanthi Gudibandi.
       if(KRSwitchEnabledFlag){
      if(hmCountryCode=='' && homePhoneAreaCodePart1== ' ' && homePhoneAreaCodePart2== '' && homePhoneAreaCodePart3== '')
                        {    
                                          
                           objPersonAccount.Individual_Home_Phone__c = '';
                        }
       else if((hmCountryCode!= ' ') &&(homePhoneAreaCodePart1 != ' ' ) && (homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 != ''))                    
                    {       
                                       
                        objPersonAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        if(objPersonAccount.Individual_Home_Phone__c.startsWith(' -'))
                        {
                            objPersonAccount.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c.removeStart(' -');
                        }
                    }                     
                        else
                        {
                            
                             objPersonAccount.Individual_Home_Phone__c = '';
                        }
                        }
                        else
                        {
                         if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                        {    
                                          
                            objPersonAccount.Individual_Home_Phone__c = '';
                        }
                        else if((homePhoneAreaCodePart1 != ' ' || homePhoneAreaCodePart1 == ' ') && (homePhoneAreaCodePart2 == '' || homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 == '' || homePhoneAreaCodePart3 != ''))
                        {       
                                       
                            objPersonAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                            if(objPersonAccount.Individual_Home_Phone__c.startsWith(' -'))
                            {
                                objPersonAccount.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c.removeStart(' -');
                            }
                        }                    
                        else
                        {
                            
                            objPersonAccount.Individual_Home_Phone__c = '';
                        }
                            }
                          if(KRSwitchEnabledFlag){  
                        if(wkCountryCode=='' && workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                        {                      
                             objPersonAccount.Work_Phone__c = '';
                        }
                    else if((wkCountryCode != ' ') &&(workPhoneAreaCodePart1 != ' ') && (workPhoneAreaCodePart2 != '') && (workPhoneAreaCodePart3 != ''))
                       {                         
                            objPersonAccount.Work_Phone__c = wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                           if(objPersonAccount.Work_Phone__c.startsWith(' -'))
                           {
                               objPersonAccount.Work_Phone__c = objPersonAccount.Work_Phone__c.removeStart(' -');
                            }
                        }
                        else
                        {
                           objPersonAccount.Work_Phone__c = '';
                        }
                        }
                        else
                        {
                        if(workPhoneAreaCodePart1 == ' ' && workPhoneAreaCodePart2 == '' && workPhoneAreaCodePart3 == '')
                        {                      
                            objPersonAccount.Work_Phone__c = '';
                        }
                        else if((workPhoneAreaCodePart1 != ' ' || workPhoneAreaCodePart1 == ' ') && (workPhoneAreaCodePart2 != '' || workPhoneAreaCodePart2 == '') && (workPhoneAreaCodePart3 != '' || workPhoneAreaCodePart3 == ''))
                        {                         
                            objPersonAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                            if(objPersonAccount.Work_Phone__c.startsWith(' -'))
                            {
                                objPersonAccount.Work_Phone__c = objPersonAccount.Work_Phone__c.removeStart(' -');
                            }
                        }
                        else
                        {
                            objPersonAccount.Work_Phone__c = '';
                        }
                        }
                         if(KRSwitchEnabledFlag){  
                        if(mbCountryCode=='' && mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                        {              
                            objPersonAccount.Mobile__c = '';
                        }
                        else if((mbCountryCode!= ' ') &&(mobileAreaCode != ' ' ) && (mobileAreaCodePart2 != '') && (mobileAreaCodePart3 !=''))
                        {              
                            objPersonAccount.Mobile__c= mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                            if(objPersonAccount.Mobile__c.startsWith(' -'))
                           {
                                objPersonAccount.Mobile__c = objPersonAccount.Mobile__c.removeStart(' -');
                            }
                        }
                        else
                        {
                            objPersonAccount.Mobile__c = '';
                        }  
                        }
                         else
                        {
                         if(mobileAreaCode == ' ' && mobileAreaCodePart2 == '' && mobileAreaCodePart3 == '')
                        {              
                            objPersonAccount.Mobile__c = '';
                        }
                        else if((mobileAreaCode != ' ' || mobileAreaCode == ' ') && (mobileAreaCodePart2 != '' || mobileAreaCodePart2 == '') && (mobileAreaCodePart3 !='' || mobileAreaCodePart3 == ''))
                        {              
                            objPersonAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                            if(objPersonAccount.Mobile__c.startsWith(' -'))
                            {
                                objPersonAccount.Mobile__c = objPersonAccount.Mobile__c.removeStart(' -');
                            }
                        }
                        else
                        {
                            objPersonAccount.Mobile__c = '';
                        }  
                           }
                        if(!KRSwitchEnabledFlag){  
                        if(Validation == false){
                            refreshPage = true;
                            objPersonAccount.Id = null;
                            insert objPersonAccount ;
                            AddressObj.Customer__c = objPersonAccount.id;
                            AddressObj.Preferred__c = true;
                            if(AddressObj.Temp_ZipCode__c == null && AddressObj.Temp_Address__c == null)
                            {
                                if(!KRSwitchForAddressDoctor){
                            AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                                }
                            }
                            system.debug('Address Info for person-->>'+AddressObj);
                           insert AddressObj;
                            PageReference pageRef = new PageReference('/'+objPersonAccount.Id);           
                            return PageRef;
                        } 
                        }
                    }
                    if(KRSwitchEnabledFlag){  
                       if(Validation == false ){
                            system.debug('validation false inside-->'+Validation);
                            refreshPage = true;
                            objPersonAccount.Id = null;
                            insert objPersonAccount ;
                            AddressObj.Customer__c = objPersonAccount.id;
                            AddressObj.Preferred__c = true;
                            if(AddressObj.Temp_ZipCode__c == null && AddressObj.Temp_Address__c == null)
                            {
                                if(!KRSwitchForAddressDoctor){
                                    AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                                }
                            
                            }
                           insert AddressObj;
                            PageReference pageRef = new PageReference('/'+objPersonAccount.Id);           
                            return PageRef;
                        }
                    }
                }
                
                else if(recordType == 'Person Account' && market != System.Label.KR)
                {
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                   system.debug('Enter JP Loop 2 :');


                    /****************************************/
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

                    /*****************************************/  

                        system.debug('Enter JP Loop 5 :'); 
                       /* if(objPersonAccount.Individual_Home_Phone__c == null && objPersonAccount.Mobile__c == null && objPersonAccount.Work_Phone__c == null &&
                           objPersonAccount.Mobile2__c == null && objPersonAccount.Home_Phone_2__c == null &&  objPersonAccount.Phone == null &&
                           objPersonAccount.Email__c == null && objPersonAccount.Email2__c == null)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                            Validation = true;
                        }*/
                        
                        system.debug('refreshPage 1:'+refreshPage );
                        system.debug('Validation1:'+Validation );
                        if(Validation == false){
                             system.debug('refreshPage 2:'+refreshPage );
                      if(TouchPoint !=null)
                        {
                        objPersonAccount.Data_Source__c=TouchPoint;
                        } 
                        if(objPersonAccount.Acquisition_Objective_Method__c !=null && objPersonAccount.Allow_Data_Sharing2__c =='Yes')
                        {
                        objPersonAccount.Acquisition_Record_Date__c=System.today();
                        }
                        
                            upsert objPersonAccount ;
                            if(AddressObj !=null && (Address_Validated_Flag )){
                            
                                AddressObj.Customer__c = objPersonAccount.id;
                                if(!KRSwitchForAddressDoctor){
                                AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                                }
                                
                                insert AddressObj;
                            }
                        
                        PageReference pageRef = new PageReference('/'+objPersonAccount.Id);            
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
    
     
    
    // Cancel button
    public PageReference cancel(){
        PageReference pageRef; 
        pageRef = new PageReference('/001/o');
        return PageRef;
    }
    
    // Cancel button for jp readonly page
            public PageReference canceljp(){
        PageReference pageRef; 
              Readonly=false;
      Editmode=true;
      companyrectype = false;
      personrectype= false;
      AddressDetails = '';
      CompanyConfirmedMatch=false;
      show=false;
       System.debug('recordType*********'+recordType);
        System.debug('selectedRecordType *********'+selectedRecordType);
        pageRef = new PageReference('/apex/AddressSearchValidation');
        return PageRef;
       

    }
   
    // Assign selected Recordtype value based on select list
    public void selectedRecordTypeValue()
    {
        resetPhoneAreacodes();
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
    //SN20170907        
      displayAccList.clear(); 
      if(Market==Label.MY){
        objAccount= new account();
        objAccount.Market__c=Market;
      }  
    }
    
    public void AutoFillAddress(){
        AutoFill = true;
        DisplayAutoFill = true; 
        validateAddressByZipCode();
        
    }
    
    /**  Address Search based on Zip code.
Sends zip code to EP/Tolerant and fetches the matched address details and populates on Screen.
**  Created By: Narasimha 
**  Date: 2016-1-19
**/
    public void AddressSearchbyZipCode()
    {       
        if(AddressObj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)  ))
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
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_validation)); 
        }       
        if(AddressObj.Address_Line_2__c != null || AddressObj.Address_Line_1__c !=null || AddressObj.Block__c != null || AddressObj.City__c != null ||
           AddressObj.District__c != null || AddressObj.Province__c != null )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_fields_not_null));            
        }
        else if(AddressObj.ZipCode__c != null && (Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)))
        {           
            crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
            response =  UtilWebservice.validateAddressByZipCode(AddressObj,false);
           
            if(response != null && response.ValidationStatus == 'OK')
            {
                //AddressObj.Address_Code__c = response.Addresses[0].Address_Code;
                AddressObj.ZipCode__c =  response.Addresses[0].ZipCode;                
                if(response.Addresses[0].ValidFields != null && response.Addresses[0].ValidFields != '')
                {
                    String ValidStr = response.Addresses[0].ValidFields;
                    system.debug('valid string ------'+ ValidStr );                   
                    if(ValidStr.contains('Address_Line_1__c'))
                    {                       
                        AddressObj.Address_Line_1__c = response.Addresses[0].Address_Line_1;                       
                    }
                    if(ValidStr.contains('Address_Line_2__c'))
                    {                       
                        AddressObj.Address_Line_2__c = response.Addresses[0].Address_Line_2;
                    }
                    if(ValidStr.contains('Block__c'))
                    {                       
                        AddressObj.Block__c = response.Addresses[0].Block;
                    }
                    if(ValidStr.contains('City__c'))
                    {
                        AddressObj.City__c = response.Addresses[0].City;
                    }
                    if(ValidStr.contains('District__c'))
                    {
                        AddressObj.District__c = response.Addresses[0].District;                       
                    }
                    if(ValidStr.contains('Province__c'))
                    {
                        AddressObj.Province__c = response.Addresses[0].Province;                       
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
                      AddressObj.Address_Line_1_Native__c= response.Addresses[0].Province_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1_Native__c' + AddressObj.Address_Line_1_Native__c);
                    }
                     if(ValidStr.contains('Address_Line_2_Native__c') && Market == 'JP')
                    {
                      AddressObj.Address_Line_2_Native__c= response.Addresses[0].Address_Line_2_Native;
                       system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2_Native__c' + AddressObj.Address_Line_2_Native__c);
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));               
            }
        }       
    }
    /* *PR20180927- Switch Between EP and CDM For AddressDoctor by Sravani Koppaka* */
    public void validateAddressDoctorSwitch(){
        if(!KRSwitchForAddressDoctor){
			validateAddressByZipCode();
        }
        else if(KRSwitchForAddressDoctor) {
            validateAddressByAddressDoctor();
        }
    }
   
    /**  Address Validation based on Zip code.
After Address is searched using Address Search button and if user enters additional address information, It sends information to
EP/Tolerant for Validation.
**  Created By: Narasimha 
**  Date: 2016-1-19
**/
    public void validateAddressByZipCode()
    {   system.debug('recordType 9:'+ objPersonAccount.Mobile__c);
        system.debug('mobileAreaCode 1 :'+mobileAreaCode);   
        if(Market ==Label.KR){
            /* if(!isAddressValidated) {
                 
             } else {
                 if(Market ==Label.KR){*/
           /* if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
            {
                addressobj.Address_Code__c = '';
                addressobj.Address_Line_1__c = '';
                addressobj.Address_Line_2__c = '';
                addressobj.Block__c = '';
                addressobj.City__c = '';
                addressobj.District__c = '';
                addressobj.Province__c = '';
                addressobj.MD__c ='';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));  
            }
            if(addressobj.ZipCode__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));  
            }
            if(addressobj.Address_Line_1__c == null)
            {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address_Line_1__c is Mandatory.'));  
            }*/
            if(AddressObj.Province__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.'));  
            }
            //Commented the IF condition as address can be searched without postcode as well for MBK. As confirmed by Enriko, Falk and Andrew.
            //if(addressobj.ZipCode__c != null)
            //{
            //Changes as part of SFDCKR-683
            if(AddressObj.Province__c != null)
            {
                AddressObj.MD__c = Market;
                ValidateAddressSearchCallout(AddressObj);
            }
            //} 
			// }
			//}
		}
        if(Market !=Label.KR){
            System.debug('^^^^^^^^^^^^^^^^^^^^^^^'+addresspicklist);
            if(AddressObj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)  ))
            {
                AddressObj.Address_Code__c = '';
                AddressObj.Address_Line_1__c = '';
                AddressObj.Address_Line_2__c = '';
                AddressObj.Block__c = '';  // commented as a part of sfdcjp-3433
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
                System.debug('^^^^^^^^^^^^^^^^^^^^^^^'+addresspicklist);
                 System.debug('^^^^^^^^^^^^^^^^^^^^^^^'+String.isblank(AddressObj.Address_Type__c));
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
        //     }
        // } 
    }
    
    public void validateAddressByAddressDoctor() {        
        try{
        if(Market ==Label.KR) {
            validatedAddressList = new List<AddressDTO>();
            Integer interActModeErrors = 0; 
            Integer fastCompletinoModeErrors = 0;
            
          /*1.  In case user input only Province + Building name(this is Address Line2 field in SFDC), Sending request has parameter like below
                    <NS2:ProcessMode>FASTCOMPLETION</NS2:ProcessMode>
            
            2.  In case user input several field like Province, Locality, Street, Street No, BuildingName, Sending request has parameter like below
                    <NS2:ProcessMode>INTERACTIVE</NS2:ProcessMode>*/
            
            // If fast complettion mode is not possible the check fields for interactive mode fields.            
            
                                
            //Checking for interactive mode fields
            if(String.isBlank(AddressObj.Address_Line_1__c)) {
                interActModeErrors++;
            } 
            
            if(String.isBlank(AddressObj.City__c)) {
                interActModeErrors++;
            } 
            
            if(String.isBlank(AddressObj.Address_Line_2__c)) {
                if(interActModeErrors > 0) {
                    if(String.isBlank(AddressObj.City__c))
                        AddressObj.City__c.addError('City is required');
                    if(String.isBlank(AddressObj.Address_Line_1__c))
                        AddressObj.Address_Line_1__c.addError('Address Line 1 is required'); 
                }
                                
                fastCompletinoModeErrors++; 
            }
                
            if(interActModeErrors == 0 || fastCompletinoModeErrors == 0) {
                validator5AddressdoctorComWebservice5.AddressValidationSoap vWS = new validator5AddressdoctorComWebservice5.AddressValidationSoap();
                validator5AddressdoctorComWebservice5.Response xResp = new validator5AddressdoctorComWebservice5.Response();
                
                validator5AddressdoctorComWebservice5.Parameters par = new validator5AddressdoctorComWebservice5.Parameters();
                par.ValidationParameters = new validator5AddressdoctorComWebservice5.ValidationParameters();
                par.ValidationParameters.MatchingExtendedArchive = true;
                validator5AddressdoctorComWebservice5.ArrayOfString sCountry = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sLocality = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sPostalCode = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sProvince = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sStreet = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sBuilding = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.ArrayOfString sHouseNo = new validator5AddressdoctorComWebservice5.ArrayOfString();
                validator5AddressdoctorComWebservice5.Address Addr = new validator5AddressdoctorComWebservice5.Address();
                
                if(interActModeErrors == 0) {
                    par.ProcessMode = 'INTERACTIVE';
                    String town = (AddressObj.District__c != NULL) ? AddressObj.District__c : '';
                    String townNStreet = AddressObj.Address_Line_1__c + town;
                     
                    sHouseNo.string_x = new List<String>{townNStreet.substringBefore(' ')};  
                    Addr.HouseNumber = sHouseNo;
                    
                    sStreet.string_x = new List<String>{townNStreet.substringAfter(' ')};  
                    Addr.Street = sStreet;
                    
                    sLocality.string_x = new List<String>{AddressObj.City__c}; 
                    Addr.Locality = sLocality;
                    
                    sPostalCode.string_x = new List<String>{AddressObj.ZipCode__c}; 
                    Addr.PostalCode = sPostalCode;
                    
                    sProvince.string_x = new List<String>{AddressObj.Province__c};  
                    Addr.Province = sProvince;
                    
                    sCountry.string_x = new List<String>{'South Korea'};
                    Addr.Country = sCountry;
                    
                } else if(fastCompletinoModeErrors ==0 ) {
                    par.ProcessMode = 'FASTCOMPLETION';

                    sBuilding.string_x = new List<String>{AddressObj.Address_Line_2__c};    //'Seoul Square'
                    Addr.Building=sBuilding;
                    sCountry.string_x = new List<String>{'South Korea'};
                        Addr.Country = sCountry;
                } 
                                               
                validator5AddressdoctorComWebservice5.ArrayOfAddress lsAddr = new validator5AddressdoctorComWebservice5.ArrayOfAddress();
                validator5AddressdoctorComWebservice5.Address[] lsAddress = new List<validator5AddressdoctorComWebservice5.Address>();
                lsAddr.Address = lsAddress;
                lsAddr.Address.add(Addr);
                
                System.debug('Addres doctor request params parameter>>>>> '  + par);
                System.debug('Addres doctor request params : '  + JSON.serializePretty(par) + ' \nAddress Param : \n' + JSON.serialize(lsAddr));
                
               // xResp = vWS.Process('165888','Infa2018',par,lsAddr,null);
               // Fetching username and pwd from custom settings
                xResp = vWS.Process(username,pwd,par,lsAddr,null);
                
                system.debug(xResp);
                system.debug('statuscode - ' + xResp.StatusCode);
                system.debug('status message - ' + xResp.StatusMessage);
                validator5AddressdoctorComWebservice5.ArrayOfResult lsRes = new validator5AddressdoctorComWebservice5.ArrayOfResult();
                lsRes = xResp.Results;
                
                
                for(validator5AddressdoctorComWebservice5.Result result : lsRes.Result) {
                    
                    for(validator5AddressdoctorComWebservice5.ResultData resultData : result.ResultDataSet.ResultData) {
                        System.debug(' Fire Addres Doc : ' + interActModeErrors + '\n' + resultData);
                        if(resultData.Address!=null) {
                            Address_Validated_Flag = TRUE;

                            AddressDTO addressDTO = new AddressDTO();
                            addressDTO.Building = (resultData.Address.Building != null) ? resultData.Address.Building.string_x[0] : NULL;
                            addressDTO.Street = (resultData.Address.Street != null) ? resultData.Address.Street.string_x[0] : NULL;
                            addressDTO.HouseNumber = (resultData.Address.HouseNumber != null) ? resultData.Address.HouseNumber.string_x[0] : NULL;
                            addressDTO.Locality = (resultData.Address.Locality != null) ? resultData.Address.Locality.string_x[0] : NULL;
                            addressDTO.PostalCode = (resultData.Address.PostalCode != null) ? resultData.Address.PostalCode.string_x[0] : NULL;
                            addressDTO.Province = (resultData.Address.Province != null) ? resultData.Address.Province.string_x[0] : NULL;
                            addressDTO.Country = (resultData.Address.Country != null) ? resultData.Address.Country.string_x[0] : NULL;
                            addressDTO.DeliveryAddressLines = (resultData.Address.DeliveryAddressLines != null) ? resultData.Address.DeliveryAddressLines.string_x[0] : NULL;
                            addressDTO.CountrySpecificLocalityLine = (resultData.Address.CountrySpecificLocalityLine != null) ? resultData.Address.CountrySpecificLocalityLine.string_x[0] : NULL;
                            
                            addressDTO.AddressComplete = resultData.Address.AddressComplete;
                            validatedAddressList.add(addressDTO);
                        }   
                        
                    }
                } // for loop
                System.debug('validatedAddressList : ' + JSON.serialize(validatedAddressList));
                
                if(validatedAddressList == NULL || validatedAddressList.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Addresses Found'));
                }
            } // else
        }
        }
        catch(Exception e){
            
        }
    }
    
    //-- DMK (Address doctor) 
    public void populateValidatedAddress() {
        Integer rowNum = Integer.valueOf(Apexpages.currentPage().getParameters().get('rowNum'));
        System.debug('rowNum : ' + rowNum); 
        AddressObj.Address_Line_1__c=validatedAddressList.get(rowNum).AddressComplete;
        AddressObj.City__c=validatedAddressList.get(rowNum).Province;
        AddressObj.District__c=validatedAddressList.get(rowNum).Locality; //Town
        isAddressDrValidated = TRUE;
        validatedAddressList = new List<AddressDTO>();
        System.debug('updated Address : ' + AddressObj.Address_Line_1__c + ' isAddressDrValidated : ' + isAddressDrValidated);
    }
    
    public List<addressSelectionWrapper> mapAddressResponse{get; set;}
    
     public void ValidateAddressSearchCallout(Address__c AddressObj){ 
        mapAddressResponse = new List<addressSelectionWrapper>();     
        system.debug('recordType 10:'+ objPersonAccount.Mobile__c);  
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        response =  UtilWebservice.validateAddressByZipCode(AddressObj,Autofill);
        system.debug('response >> 1:'+response);
        //system.debug('response >> 2:'+response.Addresses.size());
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
                    else if(ValidStr.contains('Address_Line_1__c') && Market == Label.KR)
                    {
                        AddressObjtemp.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == Label.JP)
                    {
                      AddressObj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    else if(ValidStr.contains('Address_Line_2__c') && Market == Label.KR)
                    {
                        AddressObjtemp.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c') && Market == Label.JP)
                    {
                      AddressObj.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    else if(ValidStr.contains('Block__c') && Market == Label.KR)
                    {
                        AddressObjtemp.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    if(ValidStr.contains('City__c') && Market == Label.JP)
                    {
                      AddressObj.City__c = response.Addresses[i].City;
                       //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                    else if(ValidStr.contains('City__c') && Market == Label.KR)
                    {
                        AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                   if(ValidStr.contains('District__c') && Market == Label.JP)
                    {
                      AddressObj.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    else if(ValidStr.contains('District__c') && Market == Label.KR)
                    {
                        AddressObjtemp.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    if(ValidStr.contains('Province__c') && Market == Label.JP)
                    {
                      AddressObj.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                    else if(ValidStr.contains('Province__c') && Market == Label.KR)
                    {
                        AddressObjtemp.Province__c = response.Addresses[i].Province;
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
                    /*AddressObj.Address_Code__c = '';
                    AddressObj.Address_Line_1__c = '';
                    AddressObj.Address_Line_2__c = '';
                    AddressObj.Block__c = '';
                    AddressObj.City__c = '';
                    AddressObj.District__c = '';
                    AddressObj.Province__c = '';
                    AddressObj.ZipCode__C = '';  
                    AddressObj.Block_Native__c = '';      
                    AddressObj.City_Native__c = '';        
                    AddressObj.Province_Native__c ='';        
                    AddressObj.District_Native__c = '';        
                    AddressObj.Address_Line_1_Native__c = '';        
                    AddressObj.Address_Line_2_Native__c = '';*/
                    //mapAddressResponse.add(new addressSelectionWrapper(AddressObjtemp));                  
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
        system.debug('recordType 12:'+ objPersonAccount.Mobile__c);
        system.debug('mobileAreaCode 2 :'+mobileAreaCode);   
        system.debug('mapAddressResponse :'+mapAddressResponse.size());
        
    }
   
    
    /**  Address Code Validation.
If the user is Saving  same address which matches the fields returned by tolerant, update Address with proper Address code returned by Tolerant
**  Created By: Narasimha 
**  Date: 2016-2-8
**/
    public String ValidateAddressCode(Address__c Address)
    {
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        response =  UtilWebservice.validateAddressByZipCode(Address,false);       
        if(response != null && response.ValidationStatus == 'OK')
        {
            if(AddressObj.ZipCode__c == response.Addresses[0].ZipCode && AddressObj.Address_Line_1__c == response.Addresses[0].Address_Line_1 && AddressObj.Address_Line_2__c == response.Addresses[0].Address_Line_2 &&
               AddressObj.Block__c == response.Addresses[0].Block && AddressObj.City__c == response.Addresses[0].City && AddressObj.District__c == response.Addresses[0].District && AddressObj.Province__c == response.Addresses[0].Province )
            {
                return response.Addresses[0].Address_Code;
            }           
            else
            {
                return null;
            }
        }
        return null;
    }   
    //Get the   area code items from the custom settings to fill in the area dropdowns.
    //Both for Thailand & Korea     
    public List<SelectOption> getAreacodeItems() 
    {
        User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        AreaCodeTranslation__mdt  areacodeKR=new AreaCodeTranslation__mdt();
        AreaCodeTranslation__mdt  areacodeTH=new AreaCodeTranslation__mdt();
        List<SelectOption> options = new List<SelectOption>();
        if(u.Market__c==Label.KR)
        {
           areacodeKR = [SELECT Id,Phone_EN1__c,Phone_TR1__c,Phone_EN2__c,Phone_TR2__c,Phone_EN3__c,Phone_TR3__c ,Phone_EN4__c,Phone_TR4__c,Phone_EN5__c,Phone_TR5__c,Phone_EN6__c,Phone_TR6__c,Phone_EN7__c,Phone_TR7__c,
            Phone_EN8__c,Phone_TR8__c,Phone_EN9__c,Phone_TR9__c,Phone_EN10__c,Phone_TR10__c,Phone_EN11__c,Phone_TR11__c,Phone_EN12__c,Phone_TR12__c,Phone_EN13__c,Phone_TR13__c,Phone_EN14__c,Phone_TR14__c,
            Phone_EN15__c,Phone_TR15__c,Phone_EN16__c,Phone_TR16__c,Phone_EN17__c,Phone_TR17__c,Phone_EN18__c,Phone_EN19__c,Mobile_Code1__c,Mobile_Code2__c
            FROM AreaCodeTranslation__mdt WHERE MD__c  = 'KR' LIMIT 1];
               
            Map<String,String> phoneAreaCodeMapKR = new Map<String,String>();
            phoneAreaCodeMapKR.put(' ',System.label.None);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN1__c,areacodeKR.Phone_EN1__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN2__c,areacodeKR.Phone_EN2__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN3__c,areacodeKR.Phone_EN3__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN4__c,areacodeKR.Phone_EN4__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN5__c,areacodeKR.Phone_EN5__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN6__c,areacodeKR.Phone_EN6__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN7__c,areacodeKR.Phone_EN7__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN8__c,areacodeKR.Phone_EN8__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN9__c,areacodeKR.Phone_EN9__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN10__c,areacodeKR.Phone_EN10__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN11__c,areacodeKR.Phone_EN11__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN12__c,areacodeKR.Phone_EN12__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN13__c,areacodeKR.Phone_EN13__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN14__c,areacodeKR.Phone_EN14__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN15__c,areacodeKR.Phone_EN15__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN16__c,areacodeKR.Phone_EN16__c);
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN17__c,areacodeKR.Phone_EN17__c); 
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN18__c,areacodeKR.Phone_EN18__c); 
            phoneAreaCodeMapKR.put(areacodeKR.Phone_EN19__c,areacodeKR.Phone_EN19__c); 
            phoneAreaCodeMapKR.put(areacodeKR.Mobile_Code1__c,areacodeKR.Mobile_Code1__c); 
            phoneAreaCodeMapKR.put(areacodeKR.Mobile_Code2__c,areacodeKR.Mobile_Code2__c); 
                       
            options.add(new SelectOption(' ',System.label.None));
            options.add(new SelectOption( areacodeKR.Phone_EN1__c,areacodeKR.Phone_EN1__c+'      '+areacodeKR.Phone_TR1__c));
            options.add(new SelectOption( areacodeKR.Mobile_Code1__c,areacodeKR.Mobile_Code1__c));
            options.add(new SelectOption( areacodeKR.Mobile_Code2__c,areacodeKR.Mobile_Code2__c));
            options.add(new SelectOption( areacodeKR.Phone_EN9__c,areacodeKR.Phone_EN9__c+'        '+areacodeKR.Phone_TR9__c ));  
            options.add(new SelectOption( areacodeKR.Phone_EN4__c,areacodeKR.Phone_EN4__c+'       '+areacodeKR.Phone_TR4__c)); 
            options.add(new SelectOption( areacodeKR.Phone_EN10__c,areacodeKR.Phone_EN10__c+'       '+areacodeKR.Phone_TR10__c));
            options.add(new SelectOption( areacodeKR.Phone_EN12__c,areacodeKR.Phone_EN12__c+'       '+areacodeKR.Phone_TR12__c));
            options.add(new SelectOption( areacodeKR.Phone_EN6__c,areacodeKR.Phone_EN6__c+'       '+areacodeKR.Phone_TR6__c));
            options.add(new SelectOption( areacodeKR.Phone_EN11__c,areacodeKR.Phone_EN11__c+'       '+areacodeKR.Phone_TR11__c)); 
            options.add(new SelectOption( areacodeKR.Phone_EN8__c,areacodeKR.Phone_EN8__c+'       '+areacodeKR.Phone_TR8__c));  
            options.add(new SelectOption( areacodeKR.Phone_EN18__c,areacodeKR.Phone_EN18__c));              
            options.add(new SelectOption( areacodeKR.Phone_EN2__c,areacodeKR.Phone_EN2__c+'       '+areacodeKR.Phone_TR2__c));
            options.add(new SelectOption( areacodeKR.Phone_EN7__c, areacodeKR.Phone_EN7__c+'        '+areacodeKR.Phone_TR7__c));
            options.add(new SelectOption( areacodeKR.Phone_EN3__c,areacodeKR.Phone_EN3__c+'       '+areacodeKR.Phone_TR3__c));
            options.add(new SelectOption( areacodeKR.Phone_EN15__c,areacodeKR.Phone_EN15__c+'       '+areacodeKR.Phone_TR15__c));
            options.add(new SelectOption( areacodeKR.Phone_EN16__c,areacodeKR.Phone_EN16__c+'       '+areacodeKR.Phone_TR16__c));
            options.add(new SelectOption( areacodeKR.Phone_EN14__c,areacodeKR.Phone_EN14__c+'       '+areacodeKR.Phone_TR14__c));                
            options.add(new SelectOption( areacodeKR.Phone_EN5__c,areacodeKR.Phone_EN5__c+'       '+areacodeKR.Phone_TR5__c));
            options.add(new SelectOption( areacodeKR.Phone_EN13__c,areacodeKR.Phone_EN13__c+'       '+areacodeKR.Phone_TR13__c));
            options.add(new SelectOption( areacodeKR.Phone_EN17__c,areacodeKR.Phone_EN17__c+'       '+areacodeKR.Phone_TR17__c ));
            options.add(new SelectOption( areacodeKR.Phone_EN19__c,areacodeKR.Phone_EN19__c));                
            if(!(String.isBlank(homePhoneAreaCodePart1)) && !phoneAreaCodeMapKR.containsKey(homePhoneAreaCodePart1)){
                options.add(new SelectOption( homePhoneAreaCodePart1,homePhoneAreaCodePart1));
            }
            if(!(String.isBlank(workPhoneAreaCodePart1)) && !phoneAreaCodeMapKR.containsKey(workPhoneAreaCodePart1)){
                options.add(new SelectOption( workPhoneAreaCodePart1,workPhoneAreaCodePart1));
            }
      //Monalisa Code Started
            if(!(String.isBlank(workPhone2AreaCodePart1)) && !phoneAreaCodeMapKR.containsKey(workPhone2AreaCodePart1)){
                options.add(new SelectOption( workPhone2AreaCodePart1,workPhone2AreaCodePart1));
            }
            //Monalisa Code ended
        }        
        return options;
    }
        
    public void resetPhoneAreacodes(){
        homePhoneAreaCodePart1 = homePhoneAreaCodePart2 = homePhoneAreaCodePart3 = workPhoneAreaCodePart1 = workPhoneAreaCodePart2 = workPhoneAreaCodePart3 = homePhone2AreaCode = homePhone2AreaCodePart2 = homePhone2AreaCodePart3 = mobileAreaCode= mobileAreaCodePart2 = mobileAreaCodePart3 = '';
        User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        if(u.Market__c==Label.TH){
            System.debug('inside refresh');
            hmphoneNumber =mbphoneNumber=wkphoneNumber ='';
            
            //objAccount.LastName ='';
            //objAccount.FirstName='';
            objAccount.Individual_Home_Phone__c='';
            objAccount.Preferred_Phone__c='';
            objAccount.Email__c='';
            objAccount.PersonBirthdate=null;
            objAccount.Status__c='';
            objAccount.ID_Type__c='';
            objAccount.ID_Number__c='';
            objAccount.Data_Source__c='';
            objAccount.Salutation__c ='';
            //objAccount.Name='';
            objAccount.Company_Name__c='';
            objAccount.Company_Legal_Form__c = '--None--';
            objAccount.Commercial_Reg_No__c ='';
            faxphoneNumber = '';
            
            AddressObj.Address_Type__c ='';
            AddressObj.Address_Line_1__c='';
            AddressObj.Address_Line_2__c ='';
            AddressObj.Foreign_Nationals__c = false;
            LanguageSelected = '';
            LoadProvinceTHrecordtypselection();
        }
    }
    public void LoadProvinceTHrecordtypselection()
      {  
          
        if(LanguageSelected=='' || LanguageSelected ==null )     
        {    // LanguageSelected ='English';
            lstProvince=new List<SelectOption>();
            Set<string> setProvinces = new set<string>();
            //lstProvince.add(new SelectOption('--Select--','--Select--'));
            for(RegionMasterInfo__c lsttempProvince : [select id,Province__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Market__c=:market order by Province__c asc])
            {
                if(!setProvinces.contains(lsttempProvince.Province__c))
                {
                    lstProvince.add(new SelectOption(lsttempProvince.Province__c,lsttempProvince.Province__c));
                    lstProvince.add(new SelectOption('--Select--','--Select--'));
                    setProvinces.add(lsttempProvince.Province__c);
                }
            }
            lstDistrict=new List<SelectOption>();
            lstSubDistrict=new List<SelectOption>();
            lstZip=new List<SelectOption>();
        }
      }
    //Get the list of mobile code items for Thailand & Korea and fill the Mobile code picklist
    
    public List<SelectOption> getMobileAreacodeItems() 
    {
        User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        AreaCodeTranslation__mdt  mobileAreaCodeKR=new AreaCodeTranslation__mdt();
        AreaCodeTranslation__mdt  mobileAreaCodeTH=new AreaCodeTranslation__mdt();
         List<selectOption> options = new List<selectOption>();
        if(u.Market__c==Label.KR)
        {
          mobileAreaCodeKR = [SELECT Id,Mobile_Code1__c,Mobile_Code2__c,Mobile_Code3__c,Mobile_Code4__c,Mobile_Code5__c,Mobile_Code6__c,Mobile_Code7__c FROM AreaCodeTranslation__mdt WHERE MD__c  = 'KR' LIMIT 1]; 
            system.debug('mobileAreaCodeKR >>>>>>'+mobileAreaCodeKR);           
           options.add(new SelectOption(' ',System.label.None));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code1__c,mobileAreaCodeKR.Mobile_Code1__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code2__c,mobileAreaCodeKR.Mobile_Code2__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code3__c,mobileAreaCodeKR.Mobile_Code3__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code4__c,mobileAreaCodeKR.Mobile_Code4__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code5__c,mobileAreaCodeKR.Mobile_Code5__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code6__c,mobileAreaCodeKR.Mobile_Code6__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code7__c,mobileAreaCodeKR.Mobile_Code7__c)); 
        }
        
           return options;
    }
 
     
    public void onLineDeduplication(){ 
  //  Readonly= true;  
   //    Editmode=false; 
   system.debug('<>><<>><<>@@#Readonly'+Readonly);
   system.debug('!@@###!#Readonly'+Editmode);
       boolean personacc;
       boolean companyacc;
        String Doblebyte='[^ -~¡-ß]*';
        String KanaChar='[ァア・ィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー ]*';
        Boolean result;
        Boolean resultFname;
        Boolean resultKanaLname;
        Boolean resultKanaFname;
          Integer yr;       
        System.debug('&&&&&&&&&&&&&&&&&&&&&&'+objPersonAccount.PersonBirthdate);
        Integer bdayyear;
         
       
        System.debug('***************** objPersonAccount.Acquisition_Objective_Method__c'+objPersonAccount.Acquisition_Objective_Method__c);
        System.debug('***************** recordType'+recordType);
         System.debug('***************** recordType'+market);
         System.debug('***************** recordType'+System.Label.JP+market);
         System.debug('***************** recordType'+objPersonAccount.Allow_Data_Sharing2__c);
         System.debug('***************** recordType'+objPersonAccount.Data_Source__c);
         System.debug('***************** recordType'+TouchPoint);
        
        if(objPersonAccount.PersonBirthdate !=null)
        {
            Integer currentYear = System.Today().year();
            yr= objPersonAccount.PersonBirthdate.year();
            bdayyear=currentYear-yr;
             System.debug('^&^&^&^&^&^&^&^'+yr);
             System.debug('^&^&^&^&^&^&^&^'+bdayyear);
        }
        
        Pattern KanaPattern = Pattern.compile(KanaChar);
        if(objPersonAccount.LastName_Native_1__c !=null)
        {
             Matcher MyMatcher = KanaPattern.matcher(objPersonAccount.LastName_Native_1__c);
        resultKanaLname  = MyMatcher.matches();
        }
        System.debug('######################'+resultKanaLname);
        Pattern KanaPatternFname = Pattern.compile(KanaChar);
        if( objPersonAccount.FirstName_Native_1__c !=null)
        {
             Matcher MyMatcherfname = KanaPattern.matcher(objPersonAccount.FirstName_Native_1__c);
         resultKanaFname = MyMatcherfname.matches();
        }
        System.debug('######################'+resultKanaFname);
        Pattern MyPattern = Pattern.compile(Doblebyte);
        if(objPersonAccount.lastName !=null)
        {
             Matcher MyMatcher = MyPattern.matcher(objPersonAccount.lastName);
         result = MyMatcher.matches();
        }
       
        Pattern MyPatternFname = Pattern.compile(Doblebyte);
        if(objPersonAccount.FirstName !=null)
        {
        Matcher MyMatcherFname = MyPattern.matcher(objPersonAccount.FirstName);
         resultFname = MyMatcherFname.matches();
        }
       
        System.debug('@@@@*(*(*(*(*(*(*(*('+result);
         if(recordType == 'Person Account'  && Userinfo.getUserType() != 'PowerPartner' && market == System.Label.JP && (objPersonAccount.LastName == NULL||String.isBlank(objPersonAccount.LastName) || objPersonAccount.Data_source__C == NULL || String.isBlank(objPersonAccount.Data_source__C)))
        { 
    objPersonAccount.LastName.adderror(Label.LastName_and_TouchPoint_fileds_are_mandatory);
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.LastName_and_TouchPoint_fileds_are_mandatory));
        }
        else if(recordType == 'Person Account'  && Userinfo.getUserType() == 'PowerPartner' && market == System.Label.JP && (objPersonAccount.LastName == NULL||String.isBlank(objPersonAccount.LastName) ))
        { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.LastName_is_mandatory));
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Name == NULL||String.isBlank(objAccount.Name)))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Account_Name_is_mandatory));
        }
        else if((recordType == 'Person Account' ||   recordType == 'Company') && market == System.Label.JP && (objPersonAccount.Market__c !='JP' || objAccount.Market__c !='JP'))
        {
              if(objPersonAccount.Market__c !=null)
           {
            objPersonAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only); 
            }
              
              if(objAccount.Market__c !=null)
              {              
               objAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only);
              }
        }
        else if((recordType == 'Person Account'  ||   recordType == 'Company') && market == System.Label.JP && (objPersonAccount.Status__c  =='Customer'  || objAccount.Status__c  =='Customer'))
        { 
           objPersonAccount.Status__c.addError(Label.If_customer_has_no_vehicle_relationship_Status_must_not_be_Customer); 
             
        }
        else if(recordType == 'Person Account'  && market == System.Label.JP && (objPersonAccount.Acquisition_Objective_Method__c == null || String.isBlank(objPersonAccount.Acquisition_Objective_Method__c) ) && objPersonAccount.Allow_Data_Sharing2__c=='Yes'  && (objPersonAccount.Data_Source__c=='Dealer Outlet' || TouchPoint=='Dealer Outlet' || TouchPoint=='???'))
        { 
            objPersonAccount.Acquisition_Objective_Method__c.addError(Label.Please_select_Acquisition_Objective_Method);  
        }
         else if(recordType == 'Person Account'  && market == System.Label.JP && objPersonAccount.PersonBirthdate != NULL  && (objPersonAccount.PersonBirthdate  >=System.today() || bdayyear  >=151))
        { 
             objPersonAccount.PersonBirthdate.addError(Label.Birthdate_is_not_allowed_to_be_later_than_today_or_earlier_than_150_years);    
            
        }
         else if(recordType == 'Company' && market == System.Label.JP && objAccount.Name != NULL && objAccount.Name.length() >=40) 
        {
              objAccount.Name.addError(Label.Name_should_be_less_than_or_equal_to_40_letters);   
        }
         else if(recordType == 'Company' && market == System.Label.JP && objAccount.Company_Name__c != NULL && objAccount.Company_Name__c.length() >=41) 
        {
              objAccount.Company_Name__c.addError(Label.Company_Name_should_be_less_than_or_equal_to_40_letters);  
        }
         else if(recordType == 'Person Account'  && market == System.Label.JP  && objPersonAccount.Acquisition_Objective_Method__c=='Others'  && (objPersonAccount.Details_of_Acquisition__c== null   || String.isBlank(objPersonAccount.Details_of_Acquisition__c)) )
        { 
             objPersonAccount.Details_of_Acquisition__c.addError(Label.Please_enter_Value_for_Details_of_Acquisition);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.FirstName != NULL && resultFname==false))
        { 
            objPersonAccount.FirstName.addError(Label.First_Name_should_be_of_2_byte_characters);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.FirstName_Native_1__c != NULL && resultKanafname==false))
        { 
            objPersonAccount.FirstName_Native_1__c.addError(Label.First_Name_Native_should_be_KANA_Chaarcters);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && objPersonAccount.FirstName != NULL && objPersonAccount.FirstName.length() >=41)
        {
           objPersonAccount.FirstName.addError(Label.First_Name_should_be_less_than_or_equal_to_40_letters);
       
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Home_Phone_2__c != NULL && !objPersonAccount.Home_Phone_2__c.isNumeric()))
        { 
             objPersonAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_not_include_or);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && objPersonAccount.Home_Phone_2__c != NULL && objPersonAccount.Home_Phone_2__c.length() >=12)
        {
           objPersonAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_be_less_than_or_equal_to_11_digits);
       
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Home_Phone_2__c != NULL &&  !objPersonAccount.Home_Phone_2__c.startsWith('0')))
        { 
              objPersonAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_start_with_0);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Individual_Home_Phone__c != NULL && !objPersonAccount.Individual_Home_Phone__c.isNumeric()))
        { 
            objPersonAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_not_include_or);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && objPersonAccount.Individual_Home_Phone__c!= NULL && objPersonAccount.Individual_Home_Phone__c.length() >=12)
        {
            objPersonAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_be_less_than_or_equal_to_11_digits);
       
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Individual_Home_Phone__c != NULL &&  !objPersonAccount.Individual_Home_Phone__c.startsWith('0')))
        { 
            objPersonAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_start_with_0);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.LastName != NULL && result==false))
        { 
            objPersonAccount.LastName.addError(Label.Last_Name_should_be_of_2_byte_characters);
        }
        else if(recordType == 'Person Account'  &&  market == System.Label.JP && (objPersonAccount.lastName != NULL && objPersonAccount.lastName.length() >41 ))
        { 
             objPersonAccount.LastName.addError(Label.Last_Name_should_be_less_than_or_equal_to_40_letters);
        }
        
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.LastName_Native_1__c != NULL && resultKanaLname==false))
        { 
            objPersonAccount.LastName_Native_1__c.addError(Label.Last_Name_Native_should_be_KANA_Characters);
        }
        
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile__c != NULL && !objPersonAccount.Mobile__c.isNumeric()))
        { 
            objPersonAccount.Mobile__c.addError(Label.Mobile_should_not_include_or);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile__c != NULL && objPersonAccount.Mobile__c.length() >=12))
        { 
             objPersonAccount.Mobile__c.addError(Label.Mobile_should_be_less_than_or_equal_to_11_digits);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile__c != NULL &&  !objPersonAccount.Mobile__c.startsWith('0')))
        { 
            objPersonAccount.Mobile__c.addError(Label.Mobile_should_start_with_0);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile2__c != NULL && !objPersonAccount.Mobile2__c.isNumeric()))
        { 
            objPersonAccount.Mobile2__c.addError(Label.Mobile_2_should_not_include_or);
        }
        else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile2__c != NULL && objPersonAccount.Mobile2__c.length() >=12))
        { 
             objPersonAccount.Mobile2__c.addError(Label.Mobile_2_should_be_less_than_or_equal_to_11_digits);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Mobile2__c != NULL &&  !objPersonAccount.Mobile2__c.startsWith('0')))
        { 
             objPersonAccount.Mobile2__c.addError(Label.Mobile_2_should_start_with_0);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Phone != NULL && !objPersonAccount.Phone.isNumeric()))
        { 
            objPersonAccount.Phone.addError(Label.Phone_should_not_include_or);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.phone != NULL && objPersonAccount.phone.length() >=12))
        { 
            objPersonAccount.phone.addError(Label.Phone_should_be_less_than_or_equal_to_11_digits);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Phone != NULL &&  !objPersonAccount.Phone.startsWith('0')))
        { 
            objPersonAccount.Phone.addError(Label.Phone_should_start_with_0);
        }
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Work_Phone__c != NULL && !objPersonAccount.Work_Phone__c.isNumeric()))
        { 
            objPersonAccount.Work_Phone__c.addError(Label.Work_Phone_should_not_include_or);
        }
        
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Work_Phone__c != NULL && objPersonAccount.Work_Phone__c.length() >=12))
        { 
            objPersonAccount.Work_Phone__c.addError(Label.Work_Phone_should_be_less_than_or_equal_to_11_digits);
        }
         
        
         else if(recordType == 'Person Account' && market == System.Label.JP && (objPersonAccount.Work_Phone__c != NULL &&  !objPersonAccount.Work_Phone__c.startsWith('0')))
        { 
             objPersonAccount.Work_Phone__c.addError(Label.WorkPhone_should_start_with_0);
        }
                 else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL && !objAccount.Mobile__c.isNumeric()))
        { 
            objAccount.Mobile__c.addError(Label.Mobile_should_not_include_or);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL && objAccount.Mobile__c.length() >=12))
        { 
             objAccount.Mobile__c.addError(Label.Mobile_should_be_less_than_or_equal_to_11_digits);
        }
        else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile__c != NULL &&  !objAccount.Mobile__c.startsWith('0')))
        { 
            objAccount.Mobile__c.addError(Label.Mobile_should_start_with_0);
        }
        else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && !objAccount.Mobile2__c.isNumeric()))
        { 
            objAccount.Mobile2__c.addError(Label.Mobile_2_should_not_include_or);
        }
        else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL && objAccount.Mobile2__c.length() >=12))
        { 
             objAccount.Mobile2__c.addError(Label.Mobile_2_should_be_less_than_or_equal_to_11_digits);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Mobile2__c != NULL &&  !objAccount.Mobile2__c.startsWith('0')))
        { 
             objAccount.Mobile2__c.addError(Label.Mobile_2_should_start_with_0);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Phone != NULL && !objAccount.Phone.isNumeric()))
        { 
            objAccount.Phone.addError(Label.Phone_should_not_include_or);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.phone != NULL && objAccount.phone.length() >=12))
        { 
            objAccount.phone.addError(Label.Phone_should_be_less_than_or_equal_to_11_digits);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Phone != NULL &&  !objAccount.Phone.startsWith('0')))
        { 
            objAccount.Phone.addError(Label.Phone_should_start_with_0);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && !objAccount.Work_Phone__c.isNumeric()))
        { 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_not_include_or);
        }
        
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL && objAccount.Work_Phone__c.length() >=12))
        { 
            objAccount.Work_Phone__c.addError(Label.Work_Phone_should_be_less_than_or_equal_to_11_digits);
        }
       
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Work_Phone__c != NULL &&  !objAccount.Work_Phone__c.startsWith('0')))
        { 
             objAccount.Work_Phone__c.addError(Label.WorkPhone_should_start_with_0);
        }
                else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL && !objAccount.Home_Phone_2__c.isNumeric()))
        { 
             objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_not_include_or);
        }
         else if(recordType == 'Company' && market == System.Label.JP && objAccount.Home_Phone_2__c != NULL && objAccount.Home_Phone_2__c.length() >=12)
        {
           objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_be_less_than_or_equal_to_11_digits);
       
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Home_Phone_2__c != NULL &&  !objAccount.Home_Phone_2__c.startsWith('0')))
        { 
              objAccount.Home_Phone_2__c.addError(Label.Home_Phone_2_should_start_with_0);
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL && !objAccount.Individual_Home_Phone__c.isNumeric()))
        { 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_not_include_or);
        }
        else if(recordType == 'Company' && market == System.Label.JP && objAccount.Individual_Home_Phone__c!= NULL && objAccount.Individual_Home_Phone__c.length() >=12)
        {
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_be_less_than_or_equal_to_11_digits);
       
        }
         else if(recordType == 'Company' && market == System.Label.JP && (objAccount.Individual_Home_Phone__c != NULL &&  !objAccount.Individual_Home_Phone__c.startsWith('0')))
        { 
            objAccount.Individual_Home_Phone__c.addError(Label.Individual_Home_Phone_should_start_with_0);
        }
        
        else
        {
        objAccountDeDup= new Account();
        List<Account>   lstAcc = New List<Account>();
        System.debug('I am inside onLineDeduplication');  
        List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> listmess=new List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType>();
        String province1;
        Map<String, String> addtrmapUpdate1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues(Market);
        system.debug('addtrmapUpdate1 :'+addtrmapUpdate1);
        system.debug('addtrmapUpdate1 >> :'+objPersonAccount.LastName);
        system.debug('addtrmapUpdate1 << :'+objAccount.Name);      
         System.debug('@@@@@@@ objPersonAccount.Name    '+objAccount.Name);
        if(objPersonAccount.LastName !=null || objAccount.Name !=null) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            System.debug('@@@@@@@ response '+response );
           
            companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
           if(selectedRecordType =='Company')
           {
           companyacc  =true;
           personacc =false;
           
            if(recordType !=null && recordType=='Company' && selectedRecordType =='Company' && personacc ==false && companyacc ==true)
            {
                objAccount.Recordtypeid=companyRecordTypeId;
                objPersonAccount.Recordtypeid=null;
            }
           }
           
            if(selectedRecordType =='Person Account')
           {
           companyacc  =false;
           personacc =true;
            system.debug('recordType------------:'+recordType);
            if(recordType !=null && recordType== 'Person Account' && selectedRecordType =='Person Account' && personacc ==true && companyacc ==false)
            {             
                objPersonAccount.Recordtypeid=PersonAccountRecordTypeID ;
                objAccount.Recordtypeid=null;
            }
           }
           
           
           
            System.debug('@@@@@@@ recordType------------:'+recordType);
              System.debug('@@@@@@@ objAccount.Recordtypeid   '+objAccount.Recordtypeid);
                System.debug('@@@@@@@ objPersonAccount.Recordtypeid    '+objPersonAccount.Recordtypeid);
                  System.debug('recordType*********'+recordType);
        System.debug('selectedRecordType *********'+selectedRecordType);
            if(market == System.Label.KR)
            {
                  Editmode = false;
            Readonly = false;
                if(homePhoneAreaCodePart1!= '' && homePhoneAreaCodePart2 != '' && homePhoneAreaCodePart3 != '')
                {                      
                    objPersonAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                }
                else
                {
                    objPersonAccount.Individual_Home_Phone__c = '';
                }
                if(workPhoneAreaCodePart1!= '' && workPhoneAreaCodePart2 != '' && workPhoneAreaCodePart3 != '')
                {                         
                    objPersonAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                }
                else
                {
                    objPersonAccount.Work_Phone__c = '';
                }
                if(mobileAreaCode!= '' && mobileAreaCodePart2 != '' && mobileAreaCodePart3 != '')
                {              
                    objPersonAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                }
                else
                {
                    objPersonAccount.Mobile__c = '';
                }               
            }
            System.debug('@@@@@@@@@@ objPersonAccount'+objPersonAccount);
           Address__c NewAdd=new Address__c();
            //SN20171028- Online dedup fix
            newadd.market__c=market;
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && objPersonAccount.LastName!=null && objPersonAccount.Recordtypeid !=null)
            {
              AddressObj.Address_Type__c = addresspicklist;
                if(AddressObj.Market__c !='JP'   &&  market == System.Label.JP)
                {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You are allowed to create record for your home market only'));
                }
            response =  UtilWebservice.validateCustomerDetailsWithAddress(objPersonAccount,AddressObj); 
            }
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && objAccount.Name !=null && objAccount.Recordtypeid !=null)
            {
              AddressObj.Address_Type__c = addresspicklist;
            response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
            }
            if(AddressObj == NewAdd)
            {
            if(objPersonAccount.LastName !=null && objPersonAccount.Recordtypeid !=null)
            {
            response =  UtilWebservice.validateCustomerDetails(objPersonAccount); 
            }
             
             //@Venky:Added Below if condition Changes related to SFDCJP-995
             if(objAccount.Name !=null && objAccount.Recordtypeid !=null)
            {
             System.debug('objAccount &**&*&**&**&*&*'+objAccount );
            response =  UtilWebservice.validateCustomerDetails(objAccount); 
            }
            }
            System.debug('@@@@@@@@@@ response '+response);
           // System.debug('@@@@@@@@@@ response '+response.CustomerIdentificationResponseMessage);
            if(response != null){
                if(response.CustomerIdentificationResponseMessage!=null && objPersonAccount.LastName !=null && objPersonAccount.RecordtypeID !=null)
                {
                system.debug('@)((($(#><<>show'+show);
                show = true;
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                    {
                        objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Firstname !=null)
                    {
                        objAccountDeDup.Firstname=response.CustomerIdentificationResponseMessage[0].Customer.Firstname;
                    }
					/*if(response.CustomerIdentificationResponseMessage[0].Customer.UCID__c !=null)
                    {
                        objAccountDeDup.UCID__c=response.CustomerIdentificationResponseMessage[0].Customer.UCID__c;
                    }*/
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
                     if(response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc !=null)
                    {
                        objAccountDeDup.Allow_Data_Sharing2__c=response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc ;
                    }
                    // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    // {
                    //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    // }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   
                        string provincetmp;
                        String[] s;
                        String x,y,finalstring;
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc != null)
                        {
                            provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
                            provincetmp = provincetmp.toLowerCase();
                        }
                        
                        //provincetmp = provincetmp.subString(0,1).toUpperCase();
                        Integer     i=0;
                        List<String> newString =  new List<String>();
                        if(provincetmp != null && provincetmp != '')
                       {
                            s= provincetmp.split(' ');
                            for(String str  : s)
                            {
                                i=str.length();
                                //String x,y,finalstring;
                                x= str.substring(0,1).toUpperCase();
                                y= str.substring(1,i) ;
                                finalstring = x + y  ;
                                newString.add(finalstring);
                            }                        
                            provincetmp = String.valueOf(finalstring);
                            provincetmp  =provincetmp.replace(',','');
                          
                            
                           // province1 = addtrmapUpdate1.get(provincetmp);
                            if(addtrmapUpdate1.containsKey(provincetmp))
                            {
                                province1 = addtrmapUpdate1.get(provincetmp);
                                system.debug('province1 2:'+province1);
                            }
                        }
                        system.debug('province1 3:'+province1);
                        AddressDetails =province1+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        
                        /***                        
                        AddressDetails =response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        **/
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
           //     show = true;
                if(response.CustomerIdentificationResponseMessage ==null && market != System.Label.KR)
                {                                 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                                
                }
                else if(response.CustomerIdentificationResponseMessage ==null && market == System.Label.KR)
                {
                    MBKNoMatch=true; 
                }
                lstAcc = [Select Name,MD__c,DMS_Customer_ID__c,Company_Name__c,FirstName,LastName,Phone ,Email__c,
                         Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c,PersonHasOptedOutOfEmail,
                          PersonHasOptedOutOfFax,Primary_Phone_Display__c,Sales_Sanction__c,PersonDoNotCall,Postal_Opt_Out__c,
                          Visit_Opt_Out__c,fax,Industry,Commercial_Reg_No__c,Vat_No__c,Website,Personal_Agreement__c,Personal_Information_Third_Party_Release__c,
                          Personal_Abroad_Agreement__c,Agreement_to_commit_info_processing__c,Foundation_Date__c,Complaint_Amount__c,
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                 
                cResult = lstAcc;  
                System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                if(market == System.Label.KR && lstAcc != null && !lstAcc.isEmpty() )
                {
                    system.debug('Entered>>>>');
                    MBKrefreshPage= true;
                    AccountHelperKR.CreateRetailCopy(lstAcc, true, false);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.MBK_ONLINE_DEDUP_CHECKUP));
                }
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }
        if(objAccount.Name !=null && objAccount.Recordtypeid !=null) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            System.debug('@@@@@@@ response >>'+response );
           
            companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
           /* if(recordType !=null && recordType=='Company')
            {
                objAccount.Recordtypeid=companyRecordTypeId;
            }
            system.debug('recordType------------: >> '+recordType);
            if(recordType !=null && recordType== 'Person Account')
            {             
                objAccount.Recordtypeid=PersonAccountRecordTypeID ;
            }*/
             if(selectedRecordType =='Company')
           {
           companyacc  =true;
           personacc =false;
           
            if(recordType !=null && recordType=='Company' && selectedRecordType =='Company' && personacc ==false && companyacc ==true)
            {
                objAccount.Recordtypeid=companyRecordTypeId;
                objPersonAccount.Recordtypeid=null;
            }
           }
           
            if(selectedRecordType =='Person Account')
           {
           companyacc  =false;
           personacc =true;
            system.debug('recordType------------:'+recordType);
            if(recordType !=null && recordType== 'Person Account' && selectedRecordType =='Person Account' && personacc ==true && companyacc ==false)
            {             
                objPersonAccount.Recordtypeid=PersonAccountRecordTypeID ;
                objAccount.Recordtypeid=null;
            }
           }
            if(market == System.Label.KR)
            {
                if(homePhoneAreaCodePart1!= '' && homePhoneAreaCodePart2 != '' && homePhoneAreaCodePart3 != '')
                {                      
                    objAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                }
                else
                {
                    objAccount.Individual_Home_Phone__c = '';
                }
                if(workPhoneAreaCodePart1!= '' && workPhoneAreaCodePart2 != '' && workPhoneAreaCodePart3 != '')
                {                         
                    objAccount.Work_Phone__c = workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                }
                else
                {
                    objAccount.Work_Phone__c = '';
                }
                if(mobileAreaCode!= '' && mobileAreaCodePart2 != '' && mobileAreaCodePart3 != '')
                {              
                    objAccount.Mobile__c= mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                }
                else
                {
                    objAccount.Mobile__c = '';
                }               
            }
            System.debug('@@@@@@@@@@ objAccount : '+objAccount);
            System.debug('@@@@@@@@@@ AddressObj : '+AddressObj);
            Address__c NewAdd=new Address__c();
            //SN20171028- Online dedup fix
            newadd.market__c=market;                                    
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null)
            {   
                System.debug('@@@@@@@@@@ objAccount 2 :'+objAccount);
                response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
            }
            system.debug('AddressObj :'+AddressObj);
            system.debug('NewAdd :'+NewAdd);
            if(AddressObj == NewAdd)
            {
                System.debug('@@@@@@@@@@ objAccount 3 :'+objAccount);
                response =  UtilWebservice.validateCustomerDetails(objAccount); 
            }
            System.debug('@@@@@@@@@@ response 4 :'+response);
            //System.debug('@@@@@@@@@@ response '+response.CustomerIdentificationResponseMessage[0].Customer);
            if(response != null){
                if(response.CustomerIdentificationResponseMessage!=null)
                {
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                    {
                        objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
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
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc !=null)
                    {
                        objAccountDeDup.Allow_Data_Sharing2__c=response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc ;
                    }
                    // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    // {
                    //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    // }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   string provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
                        if(provincetmp !=null){
                        provincetmp = provincetmp.toLowerCase();
                        
                        //provincetmp = provincetmp.subString(0,1).toUpperCase();
                        Integer     i=0;
                        List<String> newString =  new List<String>();
                        String[] s= provincetmp.split(' ');
                        String x,y,finalstring;
                        for(String str  : s)
                        {
                            i=str.length();
                            //String x,y,finalstring;
                            x= str.substring(0,1).toUpperCase();
                            y= str.substring(1,i) ;
                            finalstring = x + y  ;
                            newString.add(finalstring);
                        }                        
                        provincetmp = String.valueOf(finalstring);
                        provincetmp  =provincetmp.replace(',','');
                      }
                        
                       // province1 = addtrmapUpdate1.get(provincetmp);
                        if(addtrmapUpdate1.containsKey(provincetmp)){
                            province1 = addtrmapUpdate1.get(provincetmp);
                            system.debug('province1 2:'+province1);
                        }
                       system.debug('province1 3:'+province1);
                        AddressDetails =province1+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        
                        /***                        
                        AddressDetails =response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        **/
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
                
                //@Venky:Added Below if condition Changes related to SFDCJP-995
                
                if(response.CustomerIdentificationResponseMessage!=null && objAccount.Name !=null && objAccount.RecordtypeID!=null)
                {  
                system.debug('!@##$%$###$$$%CompanyConfirmedMatch'+CompanyConfirmedMatch);                  
                CompanyConfirmedMatch=true;
                     
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    } 
                     if(response.CustomerIdentificationResponseMessage[0].Customer.Name!=null)
                    {
                        objAccountDeDup.Name=response.CustomerIdentificationResponseMessage[0].Customer.Name;
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
                    
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   string provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
                        if(provincetmp !=null){
                        provincetmp = provincetmp.toLowerCase();
                        
                        //provincetmp = provincetmp.subString(0,1).toUpperCase();
                        Integer     i=0;
                        List<String> newString =  new List<String>();
                        String[] s= provincetmp.split(' ');
                        String x,y,finalstring;
                        for(String str  : s)
                        {
                            i=str.length();
                            //String x,y,finalstring;
                            x= str.substring(0,1).toUpperCase();
                            y= str.substring(1,i) ;
                            finalstring = x + y  ;
                            newString.add(finalstring);
                        }                        
                        provincetmp = String.valueOf(finalstring);
                        provincetmp  =provincetmp.replace(',','');
                      }
                        
                       // province1 = addtrmapUpdate1.get(provincetmp);
                        if(addtrmapUpdate1.containsKey(provincetmp)){
                            province1 = addtrmapUpdate1.get(provincetmp);
                            system.debug('province1 2:'+province1);
                        }
                       system.debug('province1 3:'+province1);
                        
                        AddressDetails =province1+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
                
                
               if(response.CustomerIdentificationResponseMessage ==null && market != System.Label.KR){
                
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                }
                else if(response.CustomerIdentificationResponseMessage ==null && market == System.Label.KR)
                {
                    MBKNoMatch=true; 
                }
                lstAcc = [Select Name,MD__c,DMS_Customer_ID__c,Company_Name__c,FirstName,LastName,Phone ,Email__c,
                          Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c,PersonHasOptedOutOfEmail,
                          PersonHasOptedOutOfFax,Primary_Phone_Display__c,Sales_Sanction__c,PersonDoNotCall,Postal_Opt_Out__c,
                          Visit_Opt_Out__c,fax,Industry,Commercial_Reg_No__c,Vat_No__c,Website,Personal_Agreement__c,Personal_Information_Third_Party_Release__c,
                          Personal_Abroad_Agreement__c,Agreement_to_commit_info_processing__c,Foundation_Date__c,Complaint_Amount__c,
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,
                          Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                cResult = lstAcc;  
                System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                if(market == System.Label.KR && lstAcc != null && !lstAcc.isEmpty())
                {
                    system.debug('Entered>>>>');
                    MBKrefreshPage= true;
                    AccountHelperKR.CreateRetailCopy(lstAcc, true, false);
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.MBK_ONLINE_DEDUP_CHECKUP));
                }
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }    
        system.debug('>@#$@@#$$$%$%Readonly'+Readonly);
        system.debug('<<<<<<Editmode>>>>>>'+Editmode);
            Readonly= true;  
       Editmode=false;    
                      if(market == Label.JP){
    if(recordType == 'Person Account'){
    personrectype = true;

    }
   
    if(recordType == 'Company'){
   system.debug ('+++++++++companyrectype'+companyrectype );
    companyrectype = true;

    }
    
    }
       // firstsave = true;       
       // secondsave = false;         
    }
    }
    
/* Online Deduplication for KR Market added by Sravani Koppaka/Sravanthi Gudibandi*/

public Object OnlineDeduplicationKR(){
         KRSwitchOnlinededupFlag=true;
        displayAccList.clear();
       DedupAccountList.clear();
       system.debug('Inside De Dup Korea Method '+objAccount);
        
        Integer yr;       
        Integer bdayyear;
        Continuation con=null;
        
        if(Address_Validated_Flag == null){
            Address_Validated_Flag = false;
        }                                  
        if(objPersonAccount.PersonBirthdate !=null){
            Integer currentYear = System.Today().year();
            yr= objPersonAccount.PersonBirthdate.year();
            bdayyear=currentYear-yr;
        }
        
       /*
        else if((recordType == 'Person Account' ||   recordType == 'Company') && market == System.Label.KR && (objPersonAccount.Market__c !='KR' || objAccount.Market__c !='KR')){
            if(objPersonAccount.Market__c !=null){
                objAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only); 
            }
            if(objAccount.Market__c !=null){              
                objAccount.Market__c.addError(Label.You_are_allowed_to_create_record_for_your_home_market_only);
            }
        }
    */
       /* else if((recordType == 'Person Account'  ||   recordType == 'Company') && market == System.Label.KR && (objAccount.Status__c  =='Customer'  || objAccount.Status__c  =='Customer')){ 
            objAccount.Status__c.addError(Label.If_customer_has_no_vehicle_relationship_Status_must_not_be_Customer); 
        }
        */
        /*else if(recordType == 'Person Account'  && market == System.Label.KR && objPersonAccount.PersonBirthdate != NULL  && (objPersonAccount.PersonBirthdate  >=System.today() || bdayyear  >=120 || bdayyear <=16)){ 
            objPersonAccount.PersonBirthdate.addError(Label.Birthdate_is_not_allowed_to_be_less_than_65_and_greater_than_120_Years);    
        }*/
        /*
        else if(recordType == 'Company' && market == System.Label.KR && objAccount.Name != NULL && objAccount.Name.length() <2) {
            objAccount.Name.addError(Label.Name_should_not_be_less_than_2_letters);   
        }
       
          else if(recordType == 'Person Account' && market == System.Label.KR && objPersonAccount.FirstName != NULL && objPersonAccount.FirstName.length() <2 && (Pattern.matches('^[0-9]{5}$',objPersonAccount.FirstName))) {
            objPersonAccount.Name.addError(Label.FirstName_should_not_be_less_than_2_letters);   
        }
        */
    /*    
    else if(recordType == 'Person Account' && market == System.Label.KR && objPersonAccount.FirstName != NULL && (Pattern.matches('^[0-9]{5}$',objPersonAccount.FirstName))){
            objPersonAccount.FirstName.addError(Label.First_Name_should_contain_only_alphabets);
        }
   *//*
        else if(recordType == 'Person Account' && market == System.Label.KR && objPersonAccount.LastName != NULL && objPersonAccount.LastName.length() <2 && (Pattern.matches('^[0-9]{5}$',objPersonAccount.lastName))) {
            objPersonAccount.Name.addError(Label.LastName_should_not_be_less_than_2_letters);   
        }
        */
       /* 
        else if(recordType == 'Person Account'  &&  market == System.Label.KR && (objPersonAccount.lastName != NULL && (Pattern.matches('^[0-9]{5}$',objPersonAccount.lastName)) )){ 
            objPersonAccount.LastName.addError(Label.Last_Name_should_contain_only_alphabets);
        }
      */  
        /*
        else if(recordType == 'Person Account'  &&  market == System.Label.KR && (objPersonAccount.Email__c != NULL && (!Pattern.matches('^[a-zA-Z0-9._+-]{2,64}+@[a-zA-Z]+\\.[a-zA-Z]{2,4}$',objPersonAccount.Email__c)) )){ 
            objPersonAccount.Email__c.addError(Label.Email_Criteria_is_invalid);
        }
        */
        if(recordType == 'Person Account' && market == System.Label.KR)
        {
        
            system.debug('Inside Parent If Block@@@ ');
        if(hmCountryCode!= ' ' && homePhoneAreaCodePart1 != ' '  && homePhoneAreaCodePart2 != '' && homePhoneAreaCodePart3 != '')                   
            {       
                                       
                        objPersonAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        
                    }              
                    else
                    {
                       
                         objPersonAccount.Individual_Home_Phone__c = '';
                    }
                    if(wkCountryCode!='' && workPhoneAreaCodePart1 != ' ' && workPhoneAreaCodePart2 != '' && workPhoneAreaCodePart3 != '')
                   {             
                        objPersonAccount.Work_Phone__c =  wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                       
                   }
                    else
                    {
                         objPersonAccount.Work_Phone__c = ''; 
                    }
                     if(mbCountryCode!=''&& mobileAreaCode != ' ' && mobileAreaCodePart2 != '' && mobileAreaCodePart3 != '')
                    {              
                              
                        objPersonAccount.Mobile__c=mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                       }
                    else
                    {
                        objPersonAccount.Mobile__c = '';
                    } 
                   
         }

        /***************************** Company Record Type Validation check Starts Here ******************************************************/
        /*
        else if(recordType == 'Company' && market == System.Label.KR && (objAccount.Email__c != NULL && (!Pattern.matches('^[a-zA-Z0-9._+-]{2,64}+@[a-zA-Z]+\\.[a-zA-Z]{2,4}$',objAccount.Email__c)))){ 
            objAccount.Email__c.addError(Label.Email_Criteria_is_invalid);
        }
      
        else if(recordType == 'Company' && market == System.Label.KR && (objAccount.Vat_No__c != NULL && (objAccount.Vat_No__c.length() >10 || objAccount.Vat_No__c.length() <10 ))){ 
            objAccount.Vat_No__c.addError(Label.VAT_No_length_should_be_10_only);
        }
        else if(recordType == 'Company' && market == System.Label.KR && (objAccount.Commercial_Reg_No__c != NULL && (objAccount.Commercial_Reg_No__c.length() >13 || objAccount.Commercial_Reg_No__c.length() <13 ))){ 
            objAccount.Commercial_Reg_No__c.addError(Label.Comercial_Reg_No_length_should_be_13_only);
        }
    */
        if(recordType == 'Company' && market == System.Label.KR)
        {
        if(hmCountryCode!= ' ' && homePhoneAreaCodePart1 != ' '  && homePhoneAreaCodePart2 != '' && homePhoneAreaCodePart3 != '')                   
            {       
                                       
                        objAccount.Individual_Home_Phone__c =hmCountryCode+'-'+homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                        
                    }              
                    else
                    {
                       
                         objAccount.Individual_Home_Phone__c = '';
                    }
                    if(wkCountryCode!='' && workPhoneAreaCodePart1 != ' ' && workPhoneAreaCodePart2 != '' && workPhoneAreaCodePart3 != '')
                   {             
                        objAccount.Work_Phone__c =  wkCountryCode+'-'+workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
                       
                   }
                    else
                    {
                         objAccount.Work_Phone__c = ''; 
                    }
                     if(mbCountryCode!=''&& mobileAreaCode != ' ' && mobileAreaCodePart2 != '' && mobileAreaCodePart3 != '')
                    {              
                              
                        objAccount.Mobile__c=mbCountryCode+'-'+mobileAreaCode+'-'+mobileAreaCodePart2+'-'+mobileAreaCodePart3;
                       }
                    else
                    {
                        objAccount.Mobile__c = '';
                    } 
                   if(wkCountryCode!='' && workPhone2AreaCodePart1 != ' ' && workPhone2AreaCodePart2 != '' && workPhone2AreaCodePart3 != '')
                    {                      
                                        
                        objAccount.Work_Phone_2__c =wkCountryCode+'-'+workPhone2AreaCodePart1+'-'+workPhone2AreaCodePart2+'-'+workPhone2AreaCodePart3;
                        
                    }
                    else
                    {
                        objAccount.Work_Phone_2__c = '';
                    }
                                 
                    }
        

            
        /***************************** Company Record Type Validation check ENDS Here ******************************************************/
        //else{
                system.debug('Inside Else Of Parent Block @@ ');
            //processResponse();
            //readonly= true;  
           // editmode=false;
           system.debug('Inside Else Value of objAccount Last Name@@@ '+objAccount.LastName);
            system.debug('Inside Else Value of objAccount Name@@@ '+objAccount.Name);
            system.debug('@@@ Debug 1@@@ '+selectedRecordType);
            if(objPersonAccount.LastName !=null || objAccount.Name !=null){
                system.debug('Inside If of Else Block@@@@ ');
                
                if(selectedRecordType =='Company'){
                    if(recordType !=null && recordType=='Company' && selectedRecordType =='Company'){
                        objAccount.Recordtypeid=companyRecordTypeId;
                    }
                }
                
                else if(selectedRecordType =='Person Account'){
                    if(recordType !=null && recordType== 'Person Account' && selectedRecordType =='Person Account'){  
                        system.debug('Inside Child If@@@ ');           
                        objPersonAccount.Recordtypeid=PersonAccountRecordTypeID ;
                    }
                }
                system.debug('Inside Outside If@@@ '+objAccount);
                system.debug('Inside Outside @@@ '+AddressObj);
                 
                Address__c NewAdd=new Address__c();
                system.debug('NewAdd:'+NewAdd);
                newadd.market__c = market;
                    if(NewAdd != AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && (objAccount.RecordTypeId !=null || objPersonAccount.RecordTypeId !=null)){
                        AddressObj.Address_Type__c = addresspicklist;
                        if(AddressObj.Market__c !='KR'   &&  market == System.Label.KR){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You are allowed to create record for your home market only'));
                        }
                        //response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
                        sendAddress = true;
                        
                        try{    
                            if(label.New_Component=='true'){
                                String endUrl = generateCDMEndPointURL();
                                  if(nonContinuationResponse && market == 'KR'){
                                        Map < string, string > headerCDM = new Map < string, string > ();
                                        headerCDM.put('Content-Type', 'application/json');
                                        system.debug('Inside Real Time @@@ ');
                                        HttpResponse res = CalloutHandlerService.sendCallout('GET', endUrl, 60000, headerCDM, null);
                                        system.debug('Inside Real Time @@@ '+res.getbody());
                                        system.debug('Inside Real Time @@@ '+res);
                                        //AddressSearchValidationControllerCDM cd = new AddressSearchValidationControllerCDM();
                                        processResponseForKR(res);
                                        }
                                        else{
                                            con = new Continuation(120);     
                                            con.continuationMethod='processResponse';
                                            this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                                            system.debug('request label: '+ this.requestLabel);
                                        }
                            }else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
                            }
                        }catch (Exception e){
                             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
                             CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
                        }
                    }
                system.debug('Hello test Iam here 1@@ '+AddressObj);
                system.debug('Hello test Iam here 2@@ '+NewAdd);
                if(AddressObj == NewAdd){
                     system.debug('Hello test Iam here @@ ');
                    //response =  UtilWebservice.validateCustomerDetails(objAccount);
                    sendAddress = false;
                    String endUrl = generateCDMEndPointURL();
                system.debug('Endurl:'+endurl);
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

            }     
          //end of last name check.   
        //}
        
        return con;
    }
  
    //End of online deduplication method for KR Market.
    
    /* *PR20170918- Switch Between EP and CDM* */
    public void onLineDedupSwitchTH(){
        CDM_EP_Switch__c switchEP = CDM_EP_Switch__c.getValues('Switch');
        if(switchEP != null && switchEP.EP__c == true)
            onLineDeduplicationTH();
        else if(switchEP != null && switchEP.CDM__c == true)
            onLineDeduplicationCDMTH();
    }
   //Introduced for TH Market
   //Updated for CR#89 - Phone Number Format
    public void onLineDeduplicationTH(){  
       objAccountDeDup= new Account();
        Map<String, String> addtrmapUpdate1 = UtilAddressTranslation.addtrmap;
        List<Account>   lstAcc = New List<Account>();
        List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> listmess=new List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType>();
        String province1;        
        if(objAccount.LastName !=null ) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
            if(recordType !=null && recordType=='Company')
            {
                objAccount.Recordtypeid=companyRecordTypeId;
            }            
            if(recordType !=null && recordType== 'Person Account')
            {             
                objAccount.Recordtypeid=PersonAccountRecordTypeID ;
            }
            if(market == System.Label.TH)
            {
                if(hmCountryCode!= '' && hmphoneNumber!='')
                {                      
                    objAccount.Individual_Home_Phone__c =hmCountryCode+ hmphoneNumber;
                }
                else
                {
                    objAccount.Individual_Home_Phone__c = '';
                }
                if(wkCountryCode!='' && wkphoneNumber!= '')
                {                         
                    objAccount.Work_Phone__c = wkCountryCode+ wkphoneNumber;
                }
                else
                {
                    objAccount.Work_Phone__c = '';
                }
                if(mbCountryCode!='' && mbphoneNumber!= '')
                {              
                    objAccount.Mobile__c=mbCountryCode+ mbphoneNumber;
                }
                else
                {
                    objAccount.Mobile__c = '';
                }   
                if(faxCountryCode!='' && faxphoneNumber!= '')
                {              
                    objAccount.fax=faxCountryCode+ faxphoneNumber;
                }
                else
                {
                    objAccount.fax = '';
                }    
                if(province!='' && province!='--Select--')
                    AddressObj.Province__c=province;
                if(district!='' && district!='--Select--')
                    AddressObj.District__c=district;
                if(subdistrict!='' && subdistrict!='--Select--')
                    AddressObj.Sub_District__c=subdistrict;
                if(zip!='' && zip!='--Select--')
                    AddressObj.ZipCode__c=zip;
            }
             system.debug('@@@'+objAccount);
             system.debug('@@@'+AddressObj);             
           Address__c NewAdd=new Address__c();
            //SN20171028- Online dedup fix
            newadd.market__c=market;                
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && objAccount.LastName!=null)
            {              
              system.debug('@@@In');
              response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
              system.debug('@@@In'+response);
            }
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null && objAccount.Name !=null)
            {              
               system.debug('@@@In');
              response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
              system.debug('@@@In'+response);
            }
            if(AddressObj.Address_Type__c==null)
            {
                system.debug('@@@In'+objAccount.LastName);
                if(objAccount.LastName !=null)
                {
                    system.debug('@@@In');
                    response =  UtilWebservice.validateCustomerDetails(objAccount); 
                    system.debug('@@@In'+response);
                }            
                 
                 if(objAccount.Name !=null)
                {                
                    response =  UtilWebservice.validateCustomerDetails(objAccount); 
                }
            }        
            if(response != null){
                if(response.CustomerIdentificationResponseMessage!=null && objAccount.LastName !=null)
                {
                system.debug('+++++++++>>>>>>show'+show);
                show = true;
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                    {
                        objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Firstname !=null)
                    {
                        objAccountDeDup.Firstname=response.CustomerIdentificationResponseMessage[0].Customer.Firstname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    }                     
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Email_xc != null)
                    {   
                        objAccountDeDup.Email__c =response.CustomerIdentificationResponseMessage[0].Customer.Email_xc;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    {
                        objAccountDeDup.Mobile__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    }
                    
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   
                        string provincetmp;
                        String[] s;
                        String x,y,finalstring;
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc != null)
                        {
                            provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
                            provincetmp = provincetmp.toLowerCase();
                        }
                        Integer     i=0;
                        List<String> newString =  new List<String>();
                        if(provincetmp != null && provincetmp != '')
                                   {
                          s= provincetmp.split(' ');
                          for(String str  : s)
                          {
                            i=str.length();                         
                            x= str.substring(0,1).toUpperCase();
                            y= str.substring(1,i) ;
                            finalstring = x + y  ;
                            newString.add(finalstring);
                          }                        
                          provincetmp = String.valueOf(finalstring);
                          provincetmp  =provincetmp.replace(',','');
                          if(addtrmapUpdate1.containsKey(provincetmp))
                          {
                            province1 = addtrmapUpdate1.get(provincetmp);
                            system.debug('province1 2:'+province1);
                          }
                        }                                   
                        AddressDetails =province1+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
                show = true;
                if(response.CustomerIdentificationResponseMessage ==null)
                {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                }
                lstAcc = [Select Name,MD__c,DMS_Customer_ID__c,Company_Name__c,FirstName,LastName,Phone ,Email__c,
                          Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c,PersonHasOptedOutOfEmail,
                          PersonHasOptedOutOfFax,Primary_Phone_Display__c,Sales_Sanction__c,PersonDoNotCall,Postal_Opt_Out__c,
                          Visit_Opt_Out__c,fax,Industry,Commercial_Reg_No__c,Vat_No__c,Website,Personal_Agreement__c,Personal_Information_Third_Party_Release__c,
                          Personal_Abroad_Agreement__c,Agreement_to_commit_info_processing__c,Foundation_Date__c,Complaint_Amount__c,
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,Preferred_Phone__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                 
                cResult = lstAcc;
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }
        if(objAccount.Name !=null) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
            if(recordType !=null && recordType=='Company')
            {
                objAccount.Recordtypeid=companyRecordTypeId;
            }
            if(recordType !=null && recordType== 'Person Account')
            {             
                objAccount.Recordtypeid=PersonAccountRecordTypeID ;
            }
            if(market == System.Label.TH)
            {
                if(hmCountryCode!= '' && hmphoneNumber!='')
                {                      
                    objAccount.Individual_Home_Phone__c =hmCountryCode+ hmphoneNumber;
                }
                else
                {
                    objAccount.Individual_Home_Phone__c = '';
                }
                if(wkCountryCode!='' && wkphoneNumber!= '')
                {                         
                    objAccount.Work_Phone__c = wkCountryCode+ wkphoneNumber;
                }
                else
                {
                    objAccount.Work_Phone__c = '';
                }
                if(mbCountryCode!='' && mbphoneNumber!= '')
                {              
                    objAccount.Mobile__c=mbCountryCode+ mbphoneNumber;
                }
                else
                {
                    objAccount.Mobile__c = '';
                }    
                 if(faxCountryCode!='' && faxphoneNumber!= '')
                {              
                    objAccount.fax=faxCountryCode+ faxphoneNumber;
                }
                else
                {
                    objAccount.fax = '';
                }    
                if(province!='' && province!='--Select--')
                    AddressObj.Province__c=province;
                if(district!='' && district!='--Select--')
                    AddressObj.District__c=district;
                if(subdistrict!='' && subdistrict!='--Select--')
                    AddressObj.Sub_District__c=subdistrict;
                if(zip!='' && zip!='--Select--')
                    AddressObj.ZipCode__c=zip;               
            }
            
            Address__c NewAdd=new Address__c();
            //SN20171028- Online dedup fix
            newadd.market__c=market;                                    
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null)
            { 
                response =  UtilWebservice.validateCustomerDetailsWithAddress(objAccount,AddressObj); 
            }
            system.debug('AddressObj :'+AddressObj);
            system.debug('NewAdd :'+NewAdd);
            if(AddressObj.Address_Type__c==null)
            {
                response =  UtilWebservice.validateCustomerDetails(objAccount); 
            }
            if(response != null){
                if(response.CustomerIdentificationResponseMessage!=null)
                {
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                    {
                        objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Firstname !=null)
                    {
                        objAccountDeDup.Firstname=response.CustomerIdentificationResponseMessage[0].Customer.Firstname;
                    }
                   if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Email_xc != null)
                    {   
                        objAccountDeDup.Email__c =response.CustomerIdentificationResponseMessage[0].Customer.Email_xc;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    {
                        objAccountDeDup.Mobile__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   string provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
                        provincetmp = provincetmp.toLowerCase();
                        
                        Integer     i=0;
                        List<String> newString =  new List<String>();
                        String[] s= provincetmp.split(' ');
                        String x,y,finalstring;
                        for(String str  : s)
                        {
                           i=str.length();
                            //String x,y,finalstring;
                            x= str.substring(0,1).toUpperCase();
                            y= str.substring(1,i) ;
                            finalstring = x + y  ;
                            newString.add(finalstring);
                        }                        
                        provincetmp = String.valueOf(finalstring);
                        provincetmp  =provincetmp.replace(',','');
                      
                        if(addtrmapUpdate1.containsKey(provincetmp)){
                            province1 = addtrmapUpdate1.get(provincetmp);
                            system.debug('province1 2:'+province1);
                        }
                        system.debug('province1 3:'+province1);
                        AddressDetails =province1+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
                
                if(response.CustomerIdentificationResponseMessage!=null && objAccount.Name !=null)
                {      
                system.debug('!@##$%>>>>>>$%CompanyConfirmedMatch'+CompanyConfirmedMatch);                
                CompanyConfirmedMatch=true;
                     
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                    {
                        objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                    } 
                     if(response.CustomerIdentificationResponseMessage[0].Customer.Name!=null)
                    {
                        objAccountDeDup.Name=response.CustomerIdentificationResponseMessage[0].Customer.Name;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.vin!=null)
                    {
                        objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.vin;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Email_xc != null)
                    {   
                        objAccountDeDup.Email__c =response.CustomerIdentificationResponseMessage[0].Customer.Email_xc;
                    }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    {
                        objAccountDeDup.Mobile__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    }
                    
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   
                        AddressDetails =response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                        AddressDetails = AddressDetails.replace('null',' ');
                   }
                }
                
                
                if(response.CustomerIdentificationResponseMessage ==null)
                {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                }
                
                lstAcc = [Select Name,MD__c,DMS_Customer_ID__c,Company_Name__c,FirstName,LastName,Phone ,Email__c,
                          Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c,PersonHasOptedOutOfEmail,
                          PersonHasOptedOutOfFax,Primary_Phone_Display__c,Sales_Sanction__c,PersonDoNotCall,Postal_Opt_Out__c,
                          Visit_Opt_Out__c,fax,Industry,Commercial_Reg_No__c,Vat_No__c,Website,Personal_Agreement__c,Personal_Information_Third_Party_Release__c,
                          Personal_Abroad_Agreement__c,Agreement_to_commit_info_processing__c,Foundation_Date__c,Complaint_Amount__c,
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,Preferred_Phone__c,
                          Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                cResult = lstAcc;                 
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }       
        firstsave = true;       
        secondsave = false;        
    }
    /* DH2017/09/27 Common method to Form Endpoint URL*/
    public String generateCDMEndPointURL(){
        String endUrl='';
        String Birthdate='';
        if(objAccount.PersonBirthdate!= null)
        {   
            Birthdate = String.valueOf(objAccount.PersonBirthdate);
        }
            map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
            For(string str: mapURLs.keyset()){
                if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                    endUrl+=mapURLs.get(str).Informatica_URL__c;
                }
            }
            if(recordType == 'Person Account')
            {
                endUrl+='ip_Firstname='+((string.isnotblank(objAccount.firstname))?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
                endUrl+='&ip_LastName='+((string.isnotblank(objAccount.LastName))?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+((string.isnotblank(objAccount.Mobile__c))?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&ip_HomeTelephone='+((string.isnotblank(objAccount.Individual_Home_Phone__c ))?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&ip_PersonalEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');

                  
                if(Market != 'AU' && Market != 'NZ') { // sada 2018/3/28 as part of US/2/3 and US229
                endUrl+='&ip_IDTYPE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Type__c,'UTF-8'):''); 
                endUrl+='&ip_IDVALUE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Number__c,'UTF-8'):'');

                }
                if(Market == 'TH')
                    endUrl+='&ip_BirthDate='+(string.isnotblank(Birthdate)?EncodingUtil.URLENCODE(Birthdate,'UTF-8'):'');
  //Added for KR market for the formation of endURL
                if(market == System.Label.KR && (!KRSwitchCustomerSearch)){
                        endUrl += 'ip_Firstname=' + ((string.isnotblank(objPersonAccount.firstname)) ? EncodingUtil.URLENCODE(objPersonAccount.FirstName, 'UTF-8') : '');
                        endUrl += '&ip_LastName=' + ((string.isnotblank(objPersonAccount.LastName)) ? EncodingUtil.URLENCODE(objPersonAccount.LastName, 'UTF-8') : '');
                        endUrl += '&ip_HomePhone=' + ((string.isnotblank(String.valueof(objPersonAccount.Individual_Home_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objPersonAccount.Individual_Home_Phone__c), 'UTF-8') : '');
                        endUrl += '&ip_Mobile=' + ((string.isnotblank(String.valueof(objPersonAccount.Mobile__c))) ? EncodingUtil.URLENCODE(String.valueof(objPersonAccount.Mobile__c), 'UTF-8') : '');
                        endUrl += '&ip_WorkPhone=' + ((string.isnotblank(String.valueof(objPersonAccount.Work_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objPersonAccount.Work_Phone__c), 'UTF-8') : '');
                        endUrl += '&ip_Email=' + ((string.isnotblank(objPersonAccount.Email__c)) ? EncodingUtil.URLENCODE(objPersonAccount.Email__c, 'UTF-8') : '');
                        endUrl += '&ip_Birthdate=' + ((string.isnotblank(String.valueof(objPersonAccount.PersonBirthdate))) ? EncodingUtil.URLENCODE(String.valueof(objPersonAccount.PersonBirthdate), 'UTF-8') : '');
                        endUrl += '&ip_VIN=' + ((string.isnotblank(objAccount.VIN__c)) ? EncodingUtil.URLENCODE(objAccount.VIN__c, 'UTF-8') : '');
                       // endUrl += '&ip_AccountMarket=' + ((string.isnotblank(objPersonAccount.Market__c)) ? EncodingUtil.URLENCODE(objPersonAccount.Market__c, 'UTF-8') : '');
                        endUrl += '&ip_Market=' + ((string.isnotblank(objPersonAccount.Market__c)) ? EncodingUtil.URLENCODE(objPersonAccount.Market__c, 'UTF-8') : '');

                        //Market__c is two times in the VF page so assuming that we will send only one.
                        endUrl += '&ip_SendAddFlag=' + ((sendAddress != null) ? EncodingUtil.URLENCODE(String.valueOf(sendAddress), 'UTF-8') : '');
                    if(sendAddress){
                        endUrl += '&ip_PostCode=' + ((string.isnotblank(AddressObj.ZipCode__c)) ? EncodingUtil.URLENCODE(AddressObj.ZipCode__c, 'UTF-8') : '');
                        //endUrl += '&ip_Prefecture=' + ((string.isnotblank(AddressObj.Province__c)) ? EncodingUtil.URLENCODE(AddressObj.Province__c, 'UTF-8') : '');
                        String tempProvinceTrans = doProvinceTranslation(AddressObj);
                        endUrl += '&ip_Prefecture=' + ((string.isnotblank(tempProvinceTrans)) ? EncodingUtil.URLENCODE(tempProvinceTrans, 'UTF-8') : '');
                        endUrl += '&ip_City=' + ((string.isnotblank(AddressObj.City__c)) ? EncodingUtil.URLENCODE(AddressObj.City__c, 'UTF-8') : '');
                        endUrl += '&ip_Town=' + ((string.isnotblank(AddressObj.District__c)) ? EncodingUtil.URLENCODE(AddressObj.District__c, 'UTF-8') : '');
                        endUrl += '&ip_AddressLine1=' + ((string.isnotblank(AddressObj.Address_Line_1__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c, 'UTF-8') : '');
                        endUrl += '&ip_AddressLine2=' + ((string.isnotblank(AddressObj.Address_Line_2__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c, 'UTF-8') : '');
                       //It needs to be confirm because we are already passing Market in objAccount
                        //endUrl += '&ip_AddressMarket=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');
                        endUrl += '&ip_Market=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');

                    }
                }
            }
            else if(recordType == 'Company'){
                 endUrl+='ip_Orgname='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                 endUrl+='&ip_MobileTelephone='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
				if(Market != 'AU' && Market != 'NZ')	
					endUrl+='&ip_HomeTelephone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                 endUrl+='&ip_BusinessEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');
                 endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                  if(Market == 'TH')
                 {
                     endUrl+='&ip_AddressUsageValue='+(string.isnotblank(AddressObj.Address_Type__c)?EncodingUtil.URLENCODE(AddressObj.Address_Type__c,'UTF-8'):'');
                     endUrl+='&ip_AddressLineOne='+(string.isnotblank(AddressObj.Address_Line_1__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c,'UTF-8'):'');
                     endUrl+='&ip_AddressLineTwo='+(string.isnotblank(AddressObj.Address_Line_2__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c,'UTF-8'):'');
                     endUrl+='&ip_ProvinceStateValue='+(string.isnotblank(Province)?EncodingUtil.URLENCODE(Province,'UTF-8'):'');
                     endUrl+='&ip_XDistrictValue='+(string.isnotblank(district)?EncodingUtil.URLENCODE(district,'UTF-8'):'');
                     endUrl+='&ip_XSubcityValue='+(string.isnotblank(SubDIstrict)?EncodingUtil.URLENCODE(SubDIstrict,'UTF-8'):'');
                     endUrl+='&ip_ZipPostalCode='+(string.isnotblank(zip)?EncodingUtil.URLENCODE(zip,'UTF-8'):'');
                     endUrl+='&ip_CommercialRegisterId='+(String.isnotblank(objAccount.Commercial_Reg_No__c)?EncodingUtil.URLENCODE(objAccount.Commercial_Reg_No__c,'UTF-8'):'');
                 }
 // Added for KRMarket by Sravani Koppaka
               if(market == System.Label.KR && (!KRSwitchCustomerSearch)){
                    endUrl += 'ip_AccountName=' + ((string.isnotblank(objAccount.Name)) ? EncodingUtil.URLENCODE(objAccount.Name, 'UTF-8') : '');
                    endUrl += '&ip_HomePhone=' + ((string.isnotblank(String.valueof(objAccount.Individual_Home_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Individual_Home_Phone__c), 'UTF-8') : '');
                    endUrl += '&ip_Mobile=' + ((string.isnotblank(String.valueof(objAccount.Mobile__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Mobile__c), 'UTF-8') : '');
                    endUrl += '&ip_WorkPhone=' + ((string.isnotblank(String.valueof(objAccount.Work_Phone__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Work_Phone__c), 'UTF-8') : '');
                    endUrl += '&ip_WorkPhone2=' + ((string.isnotblank(String.valueof(objAccount.Work_Phone_2__c))) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Work_Phone_2__c), 'UTF-8') : '');
                    endUrl += '&ip_Email=' + ((string.isnotblank(objAccount.Email__c)) ? EncodingUtil.URLENCODE(objAccount.Email__c, 'UTF-8') : '');
                    endUrl += '&ip_VAT=' + ((string.isnotblank(objAccount.Vat_No__c)) ? EncodingUtil.URLENCODE(objAccount.Vat_No__c, 'UTF-8') : '');
                    endUrl += '&ip_CommercialRegNo=' + ((string.isnotblank(objAccount.Commercial_Reg_No__c)) ? EncodingUtil.URLENCODE(objAccount.Commercial_Reg_No__c, 'UTF-8') : '');
                    endUrl += '&ip_Market=' + ((string.isnotblank(objAccount.Market__c)) ? EncodingUtil.URLENCODE(objAccount.Market__c, 'UTF-8') : '');
                    //endUrl += '&ip_AccountMarket=' + ((string.isnotblank(objAccount.Market__c)) ? EncodingUtil.URLENCODE(objAccount.Market__c, 'UTF-8') : '');

                    endUrl += '&ip_SendAddFlag=' + ((sendAddress != null) ? EncodingUtil.URLENCODE(String.valueOf(sendAddress), 'UTF-8') : '');
                    if(sendAddress){
                            endUrl += '&ip_PostCode=' + ((string.isnotblank(AddressObj.ZipCode__c)) ? EncodingUtil.URLENCODE(AddressObj.ZipCode__c, 'UTF-8') : '');
                            //endUrl += '&ip_Prefecture=' + ((string.isnotblank(AddressObj.Province__c)) ? EncodingUtil.URLENCODE(AddressObj.Province__c, 'UTF-8') : '');
                            String tempProvinceTrans = doProvinceTranslation(AddressObj);
                            endUrl += '&ip_Prefecture=' + ((string.isnotblank(tempProvinceTrans)) ? EncodingUtil.URLENCODE(tempProvinceTrans, 'UTF-8') : '');
                            endUrl += '&ip_City=' + ((string.isnotblank(AddressObj.City__c)) ? EncodingUtil.URLENCODE(AddressObj.City__c, 'UTF-8') : '');
                            endUrl += '&ip_Town=' + ((string.isnotblank(AddressObj.District__c)) ? EncodingUtil.URLENCODE(AddressObj.District__c, 'UTF-8') : '');
                            endUrl += '&ip_AddressLine1=' + ((string.isnotblank(AddressObj.Address_Line_1__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c, 'UTF-8') : '');
                            endUrl += '&ip_AddressLine2=' + ((string.isnotblank(AddressObj.Address_Line_2__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c, 'UTF-8') : '');
                           //It needs to be confirm because we are already passing Market in objAccount
                            endUrl += '&ip_Market=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');
                            //endUrl += '&ip_AddressMarket=' + ((string.isnotblank(AddressObj.Market__c)) ? EncodingUtil.URLENCODE(AddressObj.Market__c, 'UTF-8') : '');

                           // endUrl += '&ip_AddressLine2Native=' + ((string.isnotblank(AddressObj.Address_Line_2_Native__c)) ? EncodingUtil.URLENCODE(AddressObj.Address_Line_2_Native__c, 'UTF-8') : '');
                    }
                } 
            }
             if(Market == 'AU' || Market == 'NZ') // sada 2018/3/22 as part of US/2/3 and US229
                 {
                     endUrl+='&ip_AddressUsageValue='+(string.isnotblank(AddressObj.Address_Type__c)?EncodingUtil.URLENCODE(AddressObj.Address_Type__c,'UTF-8'):'');
                     endUrl+='&ip_AddressLineOne='+(string.isnotblank(AddressObj.Address_Line_1__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c,'UTF-8'):'');
                     endUrl+='&ip_AddressLineTwo='+(string.isnotblank(AddressObj.Address_Line_2__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c,'UTF-8'):'');
                     endUrl+='&ip_AddressLineThree='+(string.isnotblank(AddressObj.Address_Line_3__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_3__c,'UTF-8'):'');
                     endUrl+='&ip_StateCityValue='+(string.isnotblank(AddressObj.State_City__c)?EncodingUtil.URLENCODE(AddressObj.State_City__c,'UTF-8'):'');
                     endUrl+='&ip_SubUrbValue='+(string.isnotblank(AddressObj.Suburb__c)?EncodingUtil.URLENCODE(AddressObj.Suburb__c,'UTF-8'):'');
                     endUrl+='&ip_ZipPostalCode='+(string.isnotblank(zip)?EncodingUtil.URLENCODE(zip,'UTF-8'):'');
                     endUrl+='&ip_Country='+(String.isnotblank(AddressObj.Country__c)?EncodingUtil.URLENCODE(AddressObj.Country__c,'UTF-8'):'');
					 endUrl+='&ip_geographicalRegion='+(String.isnotblank(objAccount.Market__c)?EncodingUtil.URLENCODE(ObjAccount.Market__c,'UTF-8'):'');
                 }
//Added for KR market by Sravani Koppaka
            if(market==Label.KR && KRSwitchCustomerSearch){
                 endUrl=generateCDMEndPointURLRules();
            }   
        System.debug('Endurl*** ' + endUrl);
        return endUrl;
    }

// Added by Sravani Koppaka which is used in generateCDMEndpointURL method
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
  // End of doProvinceTranslation

    
   // Added by Sravani Koppaka which is used in generateCDMEndpointURL method
      public String generateCDMEndPointURLRules(){
        String endUrl='';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                endUrl+=mapURLs.get(str).Informatica_URL__c+'?';
            }
                      
        }
        system.debug('Online EndURL @@@ '+endUrl);
        List<Configuration_Rule__c> DedupCriteria= new List<Configuration_Rule__c>();
        system.debug('Market Values @@@ '+Market);
        system.debug('Sub Type Value@@@ '+recordType);
        DedupCriteria=[select id,(select id,Destination__c,Source__c,Object_API__c,Order__c from Configuration_Rule_Items__r where active__c=true order by Order__c) from Configuration_Rule__c where active__c=true and Market__c=:Market and type__c='Deduplication' and Sub_Type__c=:recordType limit 1];         
        system.debug('List Size for CRITEM @@@ '+DedupCriteria);
        if(DedupCriteria.size()>0){
            for(Configuration_Rule__c c:DedupCriteria){
                if(c.Configuration_Rule_Items__r!=null && c.Configuration_Rule_Items__r.size()>0){
                    system.debug('Inside If@@@');
                    for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                        Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                        cri=c.Configuration_Rule_Items__r[i];
                        if(i!=0){
                            endUrl+='&';
                        }
                        if(cri.Object_API__c=='Account'){
                            //endUrl+=cri.Destination__c+'='+((string.isnotblank(string.valueof(objAccount.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(objAccount.get(cri.source__c)),'UTF-8'):'');
                            if(recordType == 'Person Account'){
                                endUrl+=cri.Destination__c+'='+((string.isnotblank(string.valueof(objPersonAccount.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(objPersonAccount.get(cri.source__c)),'UTF-8'):'');
                            }
                            else if (recordType == 'Company'){
                                endUrl+=cri.Destination__c+'='+((string.isnotblank(string.valueof(objAccount.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(objAccount.get(cri.source__c)),'UTF-8'):'');
                        
                            }   
                        }
                        else if(cri.Object_API__c=='Address__c' && sendAddress){
                            if(cri.Destination__c=='ip_KRProvice'){
                                String tempProvinceTrans = doProvinceTranslation(AddressObj);
                                endUrl+=cri.Destination__c+'='+((string.isnotblank(tempProvinceTrans))?EncodingUtil.URLENCODE(tempProvinceTrans,'UTF-8'):'');
                            }
                            else{
                                endUrl+=cri.Destination__c+'='+((string.isnotblank(string.valueof(AddressObj.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(AddressObj.get(cri.source__c)),'UTF-8'):'');
                            }   
                        }
                        else if(cri.Object_API__c=='Default'){
                             if(cri.Destination__c == 'ip_SendAddFlag'){
                                endUrl+=cri.Destination__c+'='+((string.isnotblank((String.ValueOf(sendAddress))))?EncodingUtil.URLENCODE(String.ValueOf(sendAddress),'UTF-8'):'');
                            }else{  
                            endUrl+=cri.Destination__c+'='+((string.isnotblank((cri.source__c)))?EncodingUtil.URLENCODE((cri.source__c),'UTF-8'):'');
                        }
                    }
                if(endUrl.charAt(endURL.length()-1) == 38){
                            endURL = endUrl.removeEnd('&');                           
                }
                 } //end of child loop iteration.
                }                                   
            }
        }
         System.debug('End url inside the generate url method using Rule Item ------------------------------->'+endURL);                                                                                                               
        return endUrl;
    } 

 // End of generateCDMEndPointURLRules
     
    //  Sada US-2/3 2018/March/22 R1    
    public pagereference saveAccountANZ()       
    {       
        if(addresspicklist!=null)       
            AddressObj.Address_Type__c = addresspicklist;       
        Validation = false;     
        
        // Save record without Address record if no value is Entered in Address section  
     
        if(AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--' || AddressObj.Address_Type__c == '')      
        {       
            if ((string.isnotblank(AddressObj.Address_Line_1__c) ||     
                string.isnotblank(AddressObj.Address_Line_2__c) || 
                string.isnotblank(AddressObj.Address_Line_3__c) ||                      
                string.isnotblank(Zip)) && ( addressObj.Country__c=='Australia' || addressObj.Country__c=='New Zealand') ){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.AddressTypeValidationANZ));       
                    Validation = true; 
                }
            
            else{
                    system.debug('====>Address Not entered');
                if(SaveAccountDetailsANZ())      
                {       
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
                ValidateAddressANZ() ;     
                if(!Validation)     
                 {       
                refreshPage = true; 
                if(SaveAccountDetailsANZ() && phValidate)      
                {           
                    AddressObj.Customer__c = objAccount.id; 
                    AddressObj.Preferred__c=true; 
                    DMLManagerService.insertAsSystem(AddressObj);                              
                    //insert AddressObj;      
                    PageReference pageRef = new PageReference('/'+objAccount.Id);       
                    return PageRef;     
                }       
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
    
    //  Sada US-2/3 2018/March/22 R1  
     public boolean SaveAccountDetailsANZ()       
    {    
      try        
        {   
          
            if(recordType == label.Company)                     
                recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.Company);      
            else        
                recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);     
            
            
            if(recordType == Label.PersonAccount){
                objAccount.status__C = Label.ProspectStatus;
            } 
            
            objAccount.RecordTypeId = recordTypeId;  
            
            
            phValidate = true; 
          system.debug('====>Start');

  
        //Email validation 
     if(objAccount.Email__c != null && recordType == System.Label.PersonAccount )
     {
         
        string emailraw = objAccount.Email__c; 
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
        emailraw = emailraw.replace('@@', '@'); //replace @@ to single @
        emailraw = emailraw.replace('..', '.'); //replace .. to single .
        emailraw = emailraw.replace('.@', '@'); //replace .@ to single @
        emailraw = emailraw.replace('@.', '@'); //replace @. to single @
        emailraw = emailraw.removeStart('.');// remove �.� as the first character of an e-mail address.
        emailraw = emailraw.removeEnd('.');// remove �.� as the last character of an e-mail address.
        emailraw= emailraw.replaceAll( '\\s+', ''); // remove spaces
         
         if(!Pattern.matches(emailRegex,emailraw))
         {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,label.EmailValidationANZ));
                 phValidate = false;
         }
         else 
         {
        objAccount.Email__c = emailraw; 
         }
     }
             
                
        if(String.isBlank(hmphoneNumber))  objAccount.Individual_Home_Phone__c='';       
        else if(hmCountryCode!='' && hmphoneNumber!='' && (hmCountryCode==label.AUPhoneCountryCode || hmCountryCode==label.NZPhoneCountryCode ))  objAccount.Individual_Home_Phone__c=hmCountryCode+hmAreaCode+hmphoneNumber;                                     
        else objAccount.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;                                    
        
        if( String.isBlank(wkphoneNumber)) objAccount.Work_Phone__c='';     
        else if(wkCountryCode!='' && wkphoneNumber!='' && (wkCountryCode==label.AUPhoneCountryCode  || wkCountryCode==label.NZPhoneCountryCode  )) objAccount.Work_Phone__c=wkCountryCode+wkAreaCode+wkphoneNumber;                                         
        else objAccount.Work_Phone__c=wkCountryCode+wkphoneNumber;      
        
        if((String.isBlank(mbphoneNumber)) )  objAccount.Mobile__c='';         
        else if(mbCountryCode!='' && mbphoneNumber!='') objAccount.Mobile__c=mbCountryCode+mbphoneNumber;        
        else objAccount.Mobile__c='';          
        
        if((String.isBlank(faxphoneNumber))) objAccount.Phone='';       
        else if(faxCountryCode!='' && faxphoneNumber!='' && (faxCountryCode==label.AUPhoneCountryCode   || faxCountryCode==label.NZPhoneCountryCode )) objAccount.Phone=faxCountryCode+faxAreaCode+faxphoneNumber;        
        else objAccount.Phone=faxCountryCode+faxphoneNumber;      
        system.debug('====>End');          
        
            System.debug('=====>phValidate : ' + phValidate);

     if(objAccount.Name == '' && recordType == System.Label.Company)
            {        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Account_Name_is_mandatory));    
                phValidate = false;             
            }
      if(objAccount.LastName == '' && recordType == System.Label.PersonAccount)
            {        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Last_Name_is_mandatory));       
                 phValidate = false;
            }
      if(objAccount.FirstName == '' && recordType == System.Label.PersonAccount)
            {        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.First_Name_is_mandatory));       
                 phValidate = false;
            }
            
                       
            if(objAccount.Individual_Home_Phone__c == '' && objAccount.Mobile__c == '' &&  objAccount.Work_Phone__c  == '' && objAccount.Email__c == null )
            {        
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));       
            }
           else{  
                if(phValidate){
                    DMLManagerService.insertAsSystem(objAccount);  
                // insert objAccount ;
                       refreshPage = true;
                          return true; 

                }
                
            }           
        }       
        catch(DMLException e)       
        {       
            
            refreshPage = false;   
            if(e.getdmlMessage(0).contains('bad field') ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove the firstname , lastname  for saving company account and account name for person account'));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
            }
            else{               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0))); 
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
            }               
            return false;       
        }       
        return false;       
    }
    
      //  Sada US-2/3 2018/March/22 R1  
     public void ValidateAddressANZ()     
    {       
        try{  
           
                    
        if(zip!='')     
            addressobj.ZipCode__c=zip;  
            
            
       
         String ZipCheck = '^([0-9]{3,4})'; 
                 if(AddressObj.Address_Type__c != null )
                {
                    if(addressobj.ZipCode__c != null  && (!Pattern.matches(ZipCheck,addressobj.ZipCode__c)))      
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.PostalCodeValidationANZ));        
                         Validation = true;                             
                    }       
                                                
                    if(addressobj.ZipCode__c == null)       
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.PostalCodeMandatoryANZ));         
                        Validation = true;                              
                    }
                    
                    if(addressobj.Address_Line_1__c == null)        
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline1Mandatory));       
                        Validation = true;                              
                    }       
                    else        
                    {       
                        if(addressobj.Address_Line_1__c.length()>100)       
                        {       
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYAddressline1Length));        
                            Validation = true;                              
                        }       
                     } 
                    if(addressobj.State_City__c == null)      
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.StateMandatoryANZ));        
                        Validation = TRUE;      
                    }       
                      if(String.isNotBlank(addressobj.Address_Line_2__c) && addressobj.Address_Line_2__c.length()>100)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline2LengthANZ));
                        Validation = true;                      
                    }
                     if(String.isNotBlank(addressobj.Address_Line_3__c) && addressobj.Address_Line_3__c.length()>100)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline3LengthANZ));
                        Validation = true;                      
                    }
                     
            }           
        }       
            catch (exception e)     
            {       
                 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));   
                
                CustomLogUtil.CustomLoggingEntry('error' + e);               
            }       
    }       
          
     
    //  Sada US-2/3 2018/March/22 R1  
    public object onLineDeduplicationANZ(){ 
    displayAccList.clear();     
    DedupAccountList.clear();
    Boolean errorFlag=true;
    boolean mandatoryFlag=True;
    boolean recordCheck=true;
    Continuation con=null;                    
    if(Recordtype!=Label.PersonAccount && Recordtype!=Label.Company){
                recordCheck=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RecordTypeError));       
    }
    
    if(recordCheck && Recordtype== Label.PersonAccount?string.isblank(objAccount.firstName) || string.isblank(objAccount.Lastname):false){
        mandatoryFlag=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchErrorANZ));       
    }
    if(recordCheck && mandatoryFlag &&  Recordtype==Label.Company? string.isblank(objAccount.name):false){
        mandatoryFlag=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CompanyAccountSearchErrorANZ ));       
    }
    if(recordCheck && mandatoryFlag){
    
    if(Recordtype==Label.PersonAccount && string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber) && objAccount.Email__c == null && objAccount.ID_Number__c==null){        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchErrorANZ));       
                    errorFlag=false;
        } 

     
      if(Recordtype==Label.Company && string.isblank(objAccount.Email__c) && string.isblank(wkphoneNumber) && errorFlag && string.isblank(mbphoneNumber)  ){        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CompanyAccountSearchErrorANZ));       
                    errorFlag=false;
     }
    }
    if(errorFlag && mandatoryFlag && recordCheck){
    firstsave=true;     
    secondsave=false;       
                
    //SN20170907        
    last=false;     
    previous=false;     
    first=false;        
    next=false;     
    
        if(String.isBlank(hmphoneNumber))  objAccount.Individual_Home_Phone__c='';       
        else if(hmCountryCode!='' && hmphoneNumber!='' && (hmCountryCode==label.AUPhoneCountryCode || hmCountryCode==label.NZPhoneCountryCode ))  objAccount.Individual_Home_Phone__c=hmCountryCode+hmAreaCode+hmphoneNumber;                                     
        else objAccount.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;                                    
        
        if( String.isBlank(wkphoneNumber)) objAccount.Work_Phone__c='';     
        else if(wkCountryCode!='' && wkphoneNumber!='' && (wkCountryCode==label.AUPhoneCountryCode  || wkCountryCode==label.NZPhoneCountryCode  )) objAccount.Work_Phone__c=wkCountryCode+wkAreaCode+wkphoneNumber;                                         
        else objAccount.Work_Phone__c=wkCountryCode+wkphoneNumber;      
        
        if((String.isBlank(mbphoneNumber)) )  objAccount.Mobile__c='';         
        else if(mbCountryCode!='' && mbphoneNumber!='') objAccount.Mobile__c=mbCountryCode+mbphoneNumber;        
        else objAccount.Mobile__c='';          
        
        if((String.isBlank(faxphoneNumber))) objAccount.Phone='';       
        else if(faxCountryCode!='' && faxphoneNumber!='' && (faxCountryCode==label.AUPhoneCountryCode   || faxCountryCode==label.NZPhoneCountryCode )) objAccount.Phone=faxCountryCode+faxAreaCode+faxphoneNumber;        
        else objAccount.Phone=faxCountryCode+faxphoneNumber;   
        
            
            
    String EndUrl=generateCDMEndPointURL();
    CustomLogUtil.CustomLoggingEntry('Search End Url' + endurl );
    try{    
        if(label.New_Component=='true'){
            con = new Continuation(120);     
            con.continuationMethod='processResponse';
            this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
        }
        else

        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
            errorFlag=false;
        }
        } catch (Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
         errorFlag=false;
         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
        
    }                   
      }
      return con;
    }
    
    
    /* *PR20170918- CustomerSearch in CDM* */
    public Object onLineDeduplicationCDMTH() {

        Map  < String, String > addtrmapUpdate1 = UtilAddressTranslation.addtrmap;
        List < Account > lstAcc = New List < Account > ();
        DedupAccountList = new list < account > ();
        Continuation con = null;
        boolean saveommit = true;
        boolean mandatoryFlag = true;
        boolean recordCheck = true;
        boolean salestelb = true;

            companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();

            if (recordType != null && recordType == 'Company') {
                objAccount.Recordtypeid = companyRecordTypeId;
            }
            if (recordType != null && recordType == 'Person Account') {
                objAccount.Recordtypeid = PersonAccountRecordTypeID;
            }
            if (market == System.Label.TH) {
                //phone number format started
                if (Recordtype != Label.PersonAccount && Recordtype != Label.Company) {
                    recordCheck = false;
                    System.debug('##1');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RecordTypeError));
                    salestelb = false;
                }
                
                if (recordCheck && Recordtype == Label.PersonAccount ?  string.isblank(objAccount.Lastname) : false) {
                    mandatoryFlag = false;
                    System.debug('##2');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'For Customer Search Last Name and any of the contact information is required'));
                }
                if (recordCheck && mandatoryFlag && Recordtype == Label.Company ? string.isblank(objAccount.name) : false) {
                    mandatoryFlag = false;
                    System.debug('##3');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'For Customer Search Name and any of the contact information is required'));
                }
                if (recordCheck && mandatoryFlag) {
                    System.debug('##4');
                    if (Recordtype == Label.PersonAccount && string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber) && (objAccount.Email__c == null || objAccount.Email__c == '') ) {
                        System.debug('##5');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Atleast one contact Information'));
                        saveommit = false;
                    }

                    //SN20171120- the following is being removed objAccount.Email__c
                    if (Recordtype == Label.Company && string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber)) {
                        System.debug('##6');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Atleast one contact Information'));
                        saveommit = false;
                    }
                }
                if (!String.isBlank(hmphoneNumber)) {
                    string phnumber = validatephonenumber(hmphoneNumber);
                    if (!Pattern.matches('[0-9]{8}', phnumber)) {
                        saveommit = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid Home Phone Number  should be 11 digits including +66 or 8 digits without +66'));
                        return null;
                    } else {
                        objAccount.Individual_Home_Phone__c = hmCountryCode + phnumber;
                        
                    }
                } else {
                    objAccount.Individual_Home_Phone__c = '';
                    
                }

                if (!String.isBlank(wkphoneNumber)) {
                    string phnumber = validatephonenumber(wkphoneNumber);
                    if (!Pattern.matches('[0-9]{8}', phnumber)) {
                        saveommit = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'work Phone Number should be 11 digits including +66 or 8 digits without +66'));
                        return null;
                    } else {
                        objAccount.Work_Phone__c = wkCountryCode + phnumber;
                        
                    }
                } else {
                    objAccount.Work_Phone__c = '';
                    
                }
                if (!String.isBlank(mbphoneNumber)) {
                    string phnumber = validatephonenumber(mbphoneNumber);
                    if (!Pattern.matches('[0-9]{9}', phnumber)) {
                        saveommit = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'mobile Number  should be 12 digits including +66 or 9 digits without +66'));
                        return null;
                    } else {
                        objAccount.Mobile__c = mbCountryCode + phnumber;
                        
                    }
                } else {
                    objAccount.Mobile__c = '';
                    
                }
                if (!String.isBlank(faxphoneNumber)) {
                    string phnumber = validatephonenumber(faxphoneNumber);
                    if (!Pattern.matches('[0-9]{8}', phnumber)) {
                        saveommit = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'FAX Number  should be 11 digits including +66 or 8 digits without +66'));
                        return null;
                    } else {
                        objAccount.fax = faxCountryCode + phnumber;
                        
                    }
                } else {
                    objAccount.fax = '';
                    
                }
                if( salestelb && (objAccount.Primary_Phone__c == null ||  objAccount.Primary_Phone__c == ''))
                {
                    saveommit = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Sales tel'));
                    return null;
                }
                if((objAccount.Primary_Phone__c == 'Home Phone' && String.isBlank(hmphoneNumber)) || (objAccount.Primary_Phone__c == 'Work Phone' && String.isBlank(wkphoneNumber)) || (objAccount.Primary_Phone__c == 'Mobile' && String.isBlank(mbphoneNumber)))
                {
                    saveommit = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No value entered in Phone field for selected value in Sales Tel'));
                }
            }
            if(saveommit  && mandatoryFlag && recordCheck){
                firstsave = true;
                String endUrl = generateCDMEndPointURL();
                con = new Continuation(120);
                con.continuationMethod = 'processResponse';
                this.requestLabel = CalloutHandlerService.onLineDeduplicationCDMCallout(endUrl, con);
            }
        
        return con;
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
            custSearch=JSON2ApexCustomerCDM.parse(res.getbody());
            list<string> set_accounts= new list<string>();
            For(JSON2ApexCustomerCDM.cls_OP_UCID cust : custSearch.OP_UCID){
                Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                if(string.valueof(m.get(Label.AdminClientNum))!=null)
                    set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
            }
            if(set_accounts.size()>0){
                showCDM=true;
                String addressFieldsQuery = ',Primary_Address_Reference__c, Primary_Address_Reference__r.Province__c,Primary_Address_Reference__r.City__c,Primary_Address_Reference__r.District__c,Primary_Address_Reference__r.Address_Line_1__c,Primary_Address_Reference__r.Address_Line_2__c,Primary_Address_Reference__r.ZipCode__c,Primary_Address_Reference__r.Temp_ZipCode__c,Primary_Address_Reference__r.Temp_Address__c'; 
                string querytxt='select id,VIP__c,firstname,UCID__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,ID_Number__c,Primary_Address_Display__c,Lastmodifieddate  from account where <Search> in (';
                querytxt=querytxt.replace('<Search>',label.SearchKey); 
                set<String> valueSet = new set<String>();
                for(Integer i=0; i<set_accounts.size(); i++){
                    valueSet.add('\'' + String.escapeSingleQuotes(set_accounts[i]) + '\'');
                }
                if (valueSet.isEmpty()){
                    valueSet.add('\'\'');
                }
                querytxt=querytxt+ String.join(new list<String>(valueSet),',') + ') ORDER BY Lastmodifieddate DESC limit ' +label.limitsize;
                for(account acc :database.query(querytxt)){
                    //May 24, 2018 ANZ Market Hiding VIP customer for Retail Users
                    if((market == 'AU' || market == 'NZ') && Userinfo.getUserType() == 'PowerPartner')
                    {
                            if((acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company') && !acc.VIP__c ) //vip is null
                            DedupAccountList.add(acc);                  
                    }
                    else 
                    {
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company')
                        DedupAccountList.add(acc);
                    }
                }
                last=false;     
                previous=false;     
                first=false;        
                next=false;
                LastIndex=DedupAccountList.size();      
                First();
                 // Added by Sravanthi Gudibandi---start
                 if(market==system.label.KR){
            constructAddressMap();
                // Added by Sravanthi Gudibandi---end
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
    
    // Added by Sravanthi Gudibandi---start
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
            for(Address__c add : [SELECT Id, Customer__c, Province__c, City__c, District__c,  Address_Line_1__c, Address_Line_2__c, 
                                         ZipCode__c, Temp_ZipCode__c, Temp_Address__c
                                FROM Address__c 
                                WHERE Customer__c IN : DedupAccountList
                                AND Customer__c NOT IN : accIdToAddressMap.keySet()
                                AND Address_Type__c = 'Home' AND Address_Type__c = 'Business']){
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
     // Added by Sravanthi Gudibandi---end
    /*
     MT20170913
     Online de duplication for MY Market  

    */   
    public object onLineDeduplicationMY(){ 
    displayAccList.clear();     
    DedupAccountList.clear();
    Boolean errorFlag=true;
    boolean mandatoryFlag=True;
    boolean recordCheck=true;
    Continuation con=null;                    
    if(Recordtype!=Label.PersonAccount && Recordtype!=Label.Company){
                recordCheck=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.RecordTypeError));       
    }
    
    if(recordCheck && Recordtype== Label.PersonAccount?string.isblank(objAccount.firstName) || string.isblank(objAccount.Lastname):false){
        mandatoryFlag=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchError));       
    }
    if(recordCheck && mandatoryFlag &&  Recordtype==Label.Company? string.isblank(objAccount.name):false){
        mandatoryFlag=false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CompanyAccountSearchError ));       
    }
    if(recordCheck && mandatoryFlag){
    
    if(Recordtype==Label.PersonAccount && string.isblank(hmphoneNumber) && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber) && objAccount.Email__c == null && objAccount.ID_Number__c==null){        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.PersonAccountSearchError));       
                    errorFlag=false;
        } 

      //SN20171120- the following is being removed objAccount.Email__c
     if(Recordtype==Label.Company && string.isblank(hmphoneNumber) && errorFlag && string.isblank(mbphoneNumber) && string.isblank(wkphoneNumber) ){        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CompanyAccountSearchError));       
                    errorFlag=false;
     }
    }
    if(errorFlag && mandatoryFlag && recordCheck){
    firstsave=true;     
    secondsave=false;       
                
    //SN20170907        
    last=false;     
    previous=false;     
    first=false;        
    next=false;     
    //SN20170907 this list will share all the data      
            
    phoneFieldConcatMY();
    String EndUrl=generateCDMEndPointURL();
    CustomLogUtil.CustomLoggingEntry('Search End Url' + endurl );
    try{    
        if(label.New_Component=='true'){
            con = new Continuation(120);     
            con.continuationMethod='processResponse';
            this.requestLabel =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));      
            errorFlag=false;
        }
    } catch (Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
         errorFlag=false;
         CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
        
    }                   
      }
      return con;
    }
    
    Public class addressSelectionWrapper
    {
        Public boolean isSelected{get;set;}       
        Public Address__c add{get;set;} 
        addressSelectionWrapper(Address__c add){
            this.add = add;
            //isSelected = false;
        }         
    }
    public void SelectedAddress()
    {
        
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
    } 
//This will validate the Thailand phone number format
    public String validatephonenumber(String phnumber){
        integer i;
                string phon='';
                for(i=0;i<phnumber.length();i++){
                        if(phnumber.substring(i,i+1)=='0'){
                            continue;
                         }else
                         {
                           phon=phnumber.substring(i);
                           
                           break;
                         }
                    }
                    
        return phon;
        
    }

/**  Save Account based on two scenarios
* 1. With Validated Address information record.
* 2.Without Address record.
**  Created By: Mohammed Touseef Ahmed 
**  Date: 2017-2-08
** Updated for CR#89 - PhoneNumberFormat
**/
public pagereference saveAccountTH()
    { 
        //adde by dhanamjaya as per SFDCTH-300
        if(market == System.Label.TH & objAccount.ID_Type__c=='National ID'){
            if(objAccount.ID_Type__c=='National ID'&String.isBlank(objAccount.ID_Number__c)){
                objAccount.ID_Number__c.addError('If ID Type is National ID, ID Number must not be empty, and 13 characters, containing only number');
                return null;
        }
        else{
            Pattern p = Pattern.compile('[1-8]{1}[0-9]{12}'); // CISM - 0044905952
            Matcher m = p.matcher(objAccount.ID_Number__c);
            if(!m.matches()){
                objAccount.ID_Number__c.addError('If ID Type is National ID, ID Number must not be empty and should be of 13 characters containing only digits, and must not start with either 0 or 9'); // CISM - 0044905952
                return null;
            }
            else
			{
                integer sum=0;
                Integer Remainder;
                for(integer i=0;i<objAccount.ID_Number__c.length()-1;i++){
                    sum=sum+(integer.valueOf(objAccount.ID_Number__c.substring(i, i+1)))*(13-i);
                }
                remainder=math.mod(11-(math.mod(sum,11)),10);
                /*if(remainder==11){
                            if (integer.valueOf(objAccount.ID_Number__c.substring(12, 13))!=1) {
                            objAccount.ID_Number__c.addError('ID Number: Invalid National id');
                                return null;	
                        }
                        }
                else */
				if(remainder!=integer.valueOf(objAccount.ID_Number__c.substring(12,13))){
					objAccount.ID_Number__c.addError('Invalid National id');
					return null;
                }
			}
        
    }
   }
        
        //End of SFDCTH-300
        if(addresspicklist!=null)
            AddressObj.Address_Type__c = addresspicklist;        
         Validation = false;
         
        // Save record without Address record if no value is Entered in Address section
        if(AddressObj.Address_Type__c == null) 
        {
            if(SaveAccountDetailsTh())
            {
                PageReference pageRef = new PageReference('/'+objAccount.Id);
                return PageRef;           
            }
        } 
        // Save record with Address details Validating the Address Details
        If(AddressObj.Address_Type__c != null)
        {
            try
            {
                    if(recordType == 'Company')               
                        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                    else
                        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    
                    objAccount.RecordTypeId = recordTypeId;  
                    ValidateAddress();
                    
                    if(Validation == False)
                    {
                        system.debug('enter 1 :');
                        refreshPage = true;                        
                           
                        if(SaveAccountDetailsTh())
                        {   
                            AddressObj.Customer__c = objAccount.id;
                            AddressObj.Preferred__c=true;
                            AddressObj.Language__c =LanguageSelected;
                            insert AddressObj;
                            Account acc=new Account(Id=objAccount.Id);
                            acc.Primary_Address_Reference__c=AddressObj.Id;
                            DMLManagerService.updateAsSystem(acc);
                            
                            PageReference pageRef = new PageReference('/'+objAccount.Id);
                            return PageRef;
                        }
                    } 
            }
            catch(DMLException e)
            {
                system.debug('exception@@@'+e);
                refreshPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));     
            }        
        }
        return null;
    }
    
    
    /**  Save Account based on two scenarios        
* 1. With Validated Address information record.     
* 2.Without Address record.     
**  Created By: Mohammed Touseef Ahmed      
**  Date: 2017-9-13    MT20170913 
**/     
 public pagereference saveAccountMY()       
    {       
        if(addresspicklist!=null)       
            AddressObj.Address_Type__c = addresspicklist;       
        Validation = false;     
           
        // Save record without Address record if no value is Entered in Address section     
        if(AddressObj.Address_Type__c == null )      
        {       
            if (string.isnotblank(AddressObj.Address_Line_1__c) ||      
                string.isnotblank(AddressObj.Address_Line_2__c) ||   string.isnotblank(AddressObj.Address_Line_3__c)||                       
               string.isnotblank(Zip)||                     
                ((string.isnotblank(province) && addressObj.Country__c!='Malaysia') ||
                 (province!='--Select--' && addressObj.Country__c=='Malaysia')   )){
                
                
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select address type'));       
                Validation = true; 
            }
            
            else{
               if(SaveAccountDetailsMY())      
                {       
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
                    ValidateAddressMY();        
                            
                    if(Validation == False)     
                    {       
                        refreshPage = true; 
                        if(SaveAccountDetailsMY())      
                        {           
                            AddressObj.Customer__c = objAccount.id; 
                            AddressObj.Preferred__c=true; 
                            TriggerRecursiveCheck.AccountLinkAddressCheck();
                            DMLManagerService.insertAsSystem(AddressObj);                              
                            //insert AddressObj; 
                            //Account acc=new Account(Id=objAccount.Id);
                           // acc.Primary_Address_Reference__c=AddressObj.Id;
                           // DMLManagerService.updateAsSystem(acc);              
                            PageReference pageRef = new PageReference('/'+objAccount.Id);       
                            return PageRef;     
                        }       
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
    
   
    
//Saves the Account relaed details for Thailand Market
//Created By : Mohammed Touseef AHmed
//Date: 03/02/2017 
//Updated for CR#89 - Phone Number Format
//Date: 2017-05-24   
    public boolean SaveAccountDetailsTh()
    {
              
         try
            {                    
                    if(recordType == 'Company') {              
                        recordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');}
                    else if (recordType == 'Person Account'){
                        recordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');}
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select valid record type'));
                        return false;
                    }
                    objAccount.RecordTypeId = recordTypeId; 
                                         
                      if
                      (
                          (String.isBlank(hmphoneNumber)) &&
                          (String.isBlank(hmCountryCode))
                      ) 
                      
                      {              
                               objAccount.Individual_Home_Phone__c='';
                      }
                       else if(hmphoneNumber!='' && hmCountryCode!='')
                      {     
                        if(hmphoneNumber.startsWith('0'))
                            hmphoneNumber=hmphoneNumber.removeStart('0');
                               objAccount.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;
                      }
                          
                      else
                      {             
                             objAccount.Individual_Home_Phone__c='';
                      }               
                      
                       if
                      (
                          (String.isBlank(wkphoneNumber)) &&
                          (String.isBlank(wkCountryCode))
                     )
                      
                      {              
                               objAccount.Work_Phone__c='';
                      }
                      else if(wkCountryCode!='' && wkphoneNumber!='')
                      {     
                        if(wkphoneNumber.startsWith('0'))
                            wkphoneNumber=wkphoneNumber.removeStart('0');
                              objAccount.Work_Phone__c=wkCountryCode+wkphoneNumber;                            
                      }        
                      else
                      {             
                             objAccount.Work_Phone__c='';
                      } 
                    
                     if
                      (
                          (String.isBlank(mbphoneNumber)) &&
                          (String.isBlank(mbCountryCode))
                      )
                      
                      {              
                               objAccount.Mobile__c='';
                      }
                      else if(mbCountryCode!='' && mbphoneNumber!='')
                      {     
                        if(mbphoneNumber.startsWith('0'))
                            mbphoneNumber=mbphoneNumber.removeStart('0');
                               objAccount.Mobile__c=mbCountryCode+mbphoneNumber;
                      }        
                      else
                      {             
                             objAccount.Mobile__c='';
                      } 
                      if
                      (
                          (String.isBlank(faxphoneNumber)) &&
                          (String.isBlank(faxCountryCode))
                      )
                      
                      {              
                               objAccount.fax='';
                      }
                      else if(faxCountryCode!='' && faxphoneNumber!='' && faxphoneNumber!=null)
                      {     
                        if(faxphoneNumber.startsWith('0'))
                            faxphoneNumber=faxphoneNumber.removeStart('0');
                               objAccount.fax=faxCountryCode+faxphoneNumber;
                      }        
                      else
                      {             
                             objAccount.fax='';
                      }
                      if(objAccount.Email__c!=null && recordType == 'Person Account')
                          objAccount.PersonEmail=objAccount.Email__c;
                          
                  //System.debug('****Type'+AddressObj.Address_Type__c+'Address_Line_1__c'+AddressObj.Address_Line_1__c+'Address_Line_2__c'+AddressObj.Address_Line_2__c+'province'+province+'district'+district+'subdistrict'+subdistrict+'zip'+zip);
                    if(objAccount.Individual_Home_Phone__c.trim() == '' && objAccount.Mobile__c.trim() == '' && objAccount.Work_Phone__c.trim() == '' && objAccount.Email__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    }
                    
                    //PR20170926-(Start) Address Type Null check if other Address fields are populated
                    
                    else if(AddressObj.Address_Type__c == null && (AddressObj.Address_Line_1__c!=null ||
                        AddressObj.Address_Line_2__c!=null ||           
                        province!=null ||
                        district!=null ||
                        subdistrict!=null ||
                        zip!=null))
                    
                    {
                        System.debug('Inside else If****Type'+AddressObj.Address_Type__c+'Address_Line_1__c'+AddressObj.Address_Line_1__c+'Address_Line_2__c'+AddressObj.Address_Line_2__c+'province'+province+'district'+district+'subdistrict'+subdistrict+'zip'+zip);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address Type is mandatory in order to insert an address'));
                    }
                    //PR20170926-(End) Address Type Null check if other Address fields are populated
                    else if(objAccount.Primary_Phone__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales TEL is mandatory'));
                    }
                    else
                    {
                        refreshPage = true;
                        upsert objAccount ;
                        return true;
                    }                   
                              
            }           
            catch(DMLException e)
            {
                system.debug('exception@@@'+e);
                refreshPage = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));    
                return false;
            }
            return false;
    }    
    
    public void phoneFieldConcatMY(){
        
         if(String.isBlank(hmphoneNumber))  objAccount.Individual_Home_Phone__c='';       
         else if(hmCountryCode!='' && hmphoneNumber!='' && hmCountryCode==label.MYPhoneCountryCode)  objAccount.Individual_Home_Phone__c=hmCountryCode+hmAreaCode+hmphoneNumber;                                     
         else objAccount.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;                                    
         
         if( String.isBlank(wkphoneNumber)) objAccount.Work_Phone__c='';     
         else if(wkCountryCode!='' && wkphoneNumber!='' && wkCountryCode==label.MYPhoneCountryCode) objAccount.Work_Phone__c=wkCountryCode+wkAreaCode+wkphoneNumber;                                         
         else objAccount.Work_Phone__c=wkCountryCode+wkphoneNumber;      
          
         if((String.isBlank(mbphoneNumber)) )  objAccount.Mobile__c='';         
         else if(mbCountryCode!='' && mbphoneNumber!='') objAccount.Mobile__c=mbCountryCode+mbphoneNumber;        
         else objAccount.Mobile__c='';          
         
         if((String.isBlank(faxphoneNumber))) objAccount.fax='';       
         else if(faxCountryCode!='' && faxphoneNumber!='' && faxCountryCode==label.MYPhoneCountryCode) objAccount.fax=faxCountryCode+faxAreaCode+faxphoneNumber;        
         else objAccount.fax=faxCountryCode+faxphoneNumber;      
         
    }
    
   
    
//Saves the Account relaed details for Malaysia Market      
//Created By : Mohammed Touseef AHmed       
//Date: 03/09/2017      MT20170903
        
    public boolean SaveAccountDetailsMY()       
    {       
                    
         try        
            {                           
                    if(recordType == label.Company)                     
                        recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.Company);      
                    else        
                        recordTypeId = RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);     
                       
                       //HN20171008- to set status for person account as Prospect 
                       if(recordType == Label.PersonAccount){
                            objAccount.status__C = Label.ProspectStatus;
                        }   //end code here modification by Honey     
                            
                    objAccount.RecordTypeId = recordTypeId;         
                    phoneFieldConcatMY();                           
                        
                  if(objAccount.Individual_Home_Phone__c.trim() == '' && objAccount.Mobile__c.trim() == '' && objAccount.Work_Phone__c.trim() == '' && objAccount.Email__c == null){        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));       
                    }                           
                    else        
                    {       
                        refreshPage = true;   
                        DMLManagerService.insertAsSystem(objAccount );  
                       // insert objAccount ;     
                        return true;        
                    }           
            }       
            catch(DMLException e)       
            {       
                  
                refreshPage = false;   
                if(e.getdmlMessage(0).contains('bad field') ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please remove the firstname , lastname  for saving company account and account name for person account'));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
               }
                else{               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0))); 
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
                }               
                return false;       
            }       
            return false;       
    }


    //check if For Thailand market Address Type is Selected then all other fields on address are mandatory.
    
    public void ValidateAddress()
    {
        try{
        
        if(province!='' && province!='--Select--')
            addressobj.Province__c=province;
        if(district!='' && district!='--Select--')
            addressobj.District__c=district;
        if(subdistrict!='' && subdistrict!='--Select--')
            addressobj.Sub_District__c=subdistrict;
        if(zip!='' && zip!='--Select--')
            addressobj.ZipCode__c=zip;            
     
        if(AddressObj.Address_Type__c != null && 
            (AddressObj.Address_Line_1__c==null ||
            province==null ||
            district==null ||
            subdistrict==null ||
            zip==null || zip=='--Select--')
            )
            {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All Fields in the address are mandatory'));
                Validation = TRUE;
                Address_Validated_Flag=False;
            
            }            
				if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.')); 
					Validation = true;                     
				}					 
				if(addressobj.ZipCode__c == null)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.')); 
					Validation = true;                      
				}
				if(addressobj.Address_Line_1__c == null)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address_Line_1__c is Mandatory.'));
					Validation = true;                      
				}
				if(addressobj.Province__c == null)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.')); 
					Validation = TRUE; 
				}
				 
				if(addressobj.District__c == null )
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'District__c is Mandatory.')); 
					Validation = TRUE;                        
				}
			   
				if(addressobj.Sub_District__c == null)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sub_District__c is Mandatory.')); 
					Validation = TRUE;                        
				}        
            }
            catch (exception e)
            {    
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));    
            }
    }
/*      
//This below checks if For Malaysia market Address Type is Selected then all other fields on address are mandatory.     
//Created By : Mohammed Touseef Ahmed   MT20170913    
//Date: 07/09/2017      
*/          
            
            
    public void ValidateAddressMY()     
    {       
        try{        
         
        if(province!='' && province!='--Select--')      
            addressobj.Province__c=province;        
        if(district!='' && district!='--Select--')      
            addressobj.District__c=district;                
        if(zip!='')     
            addressobj.ZipCode__c=zip;                  
            
         if(AddressObj.Address_Type__c != null &&       
            (AddressObj.Address_Line_1__c==null ||      
            AddressObj.Address_Line_2__c==null ||                       
            province==null ||       
            district==null ||                   
            zip==null || AddressObj.Country__c==null)       
            )       
            {                       
                Validation = TRUE;      
                Address_Validated_Flag=False;       
                    
            }       
                    
                            
                    if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5,6}$',addressobj.ZipCode__c)))      
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYZipCode));        
                         Validation = true;                             
                    }       
                                                
                    if(addressobj.ZipCode__c == null)       
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ZipCodeMandatory));         
                        Validation = true;                              
                    }       
                    if(addressobj.Address_Line_1__c == null)        
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Addressline1Mandatory));       
                        Validation = true;                              
                    }       
                    else        
                    {       
                        if(addressobj.Address_Line_1__c.length()>100)       
                        {       
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYAddressline1Length));        
                            Validation = true;                              
                        }       
                     }      
                                                                                            
                    if(addressobj.Province__c == null)      
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.StateProvError));        
                        Validation = TRUE;      
                    }       
                    if(addressobj.District__c == null )
                    {                       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.CityError));                        
                        Validation = TRUE;                                              
                    }        
                           
                    if(addressobj.Address_Line_2__c == null )       
                    {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.Addressline2));       
                        Validation = TRUE;                              
                    }       
                    else        
                    {                           
                            
                        if(addressobj.Address_Line_2__c.length()>100)       
                        {       
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.MYAddresslinelen2Length));        
                            Validation = true;                              
                        }       
                    }        
            }       
            catch (exception e)     
            {       
                 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));   
                
                CustomLogUtil.CustomLoggingEntry('error' + e);               
            }       
    }       
            
            
            
/*      
      
    SN20170907      
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
    SN20170907      
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
    SN20170907      
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
    SN20170907      
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
    /*SN20170912 
    Description: This code is added for rerendering the areacode
    */                                              
    public void checkcountrycode(){
            wAreaBoolean=false;
            fAreaBoolean=false;
            hAreaBoolean=false;
           
            if(String.isNOTBlank(faxCountryCode) ? faxCountryCode!=label.MYPhoneCountryCode?true:false:false) fAreaBoolean=true;
            if(String.isNOTBlank(hmCountryCode) ? hmCountryCode!=label.MYPhoneCountryCode?true:false:false) hAreaBoolean=true;
             if(String.isNOTBlank(wkCountryCode) ? wkCountryCode!=label.MYPhoneCountryCode?true:false :false) wAreaBoolean=true;
           
    }
    
       //for Call  flow changes  country code added by Sravanthi Gudibandi.

    public void checkcountrycodekorea(){
     if(KRSwitchEnabledFlag){ 
        wAreaBoolean=false;
        hAreaBoolean=false;
        
       
        if(String.isNOTBlank(hmCountryCode) ? hmCountryCode!=label.KRPhoneCountryCode?true:false:false) hAreaBoolean=true;
        if(String.isNOTBlank(wkCountryCode) ? wkCountryCode!=label.KRPhoneCountryCode?true:false :false) wAreaBoolean=true;
        
    }
}
     //  Sada US-2/3 2018/March/22 R1    
        public void checkcountrycodeANZ(){
        wAreaBoolean=false;
        fAreaBoolean=false;
        hAreaBoolean=false;
        
        if(String.isNOTBlank(faxCountryCode) ? faxCountryCode!=label.AUPhoneCountryCode?true:faxCountryCode!=label.NZPhoneCountryCode?true:false:false) fAreaBoolean=true;
        if(String.isNOTBlank(hmCountryCode) ? hmCountryCode!=label.AUPhoneCountryCode?true:faxCountryCode!=label.NZPhoneCountryCode?true:false:false) hAreaBoolean=true;
        if(String.isNOTBlank(wkCountryCode) ? wkCountryCode!=label.AUPhoneCountryCode?true:faxCountryCode!=label.NZPhoneCountryCode?true:false :false) wAreaBoolean=true;


    }

//Added for India Redirect
//Added for JP CDM Also				   
public PageReference goToMarketSpecificPage() {
		Boolean jpSwitchEnabledFlag = false;
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Customer Deduplication')){
            jpSwitchEnabledFlag = jpSwitchMap.get('Customer Deduplication').Enable_Flag__c;
        }
        String vfpage = '';
        CreateAccountVFSetting__mdt pageSetting;
        String market = [select market__c from User where id =:UserInfo.getUserId()].market__c;
        if (market != null && market != '' && market == Label.IN){
            List<CreateAccountVFSetting__mdt> lstpageSetting = [select VFPageName__c from CreateAccountVFSetting__mdt where market__c = :Label.IN limit 1];
            if (lstpageSetting.size() > 0){
                pageSetting = lstpageSetting[0];
            }
            if (pageSetting != null){
                vfpage = pageSetting.VFPageName__c;
            }
        }
        else if(market != null && market != '' && market == Label.TR){
            List<CreateAccountVFSetting__mdt> lstpageSetting = [select VFPageName__c from CreateAccountVFSetting__mdt where market__c = :Label.TR limit 1];
            if (lstpageSetting.size() > 0){
                pageSetting = lstpageSetting[0];
            }
            if (pageSetting != null){
                vfpage = pageSetting.VFPageName__c;
            }
        }
		else if(market != null && market != '' && market == Label.JP && jpSwitchEnabledFlag){
            List<CreateAccountVFSetting__mdt> lstpageSetting = [select VFPageName__c from CreateAccountVFSetting__mdt where market__c = :Label.JP limit 1];
            if (lstpageSetting.size() > 0){
                pageSetting = lstpageSetting[0];
            }
            if (pageSetting != null){
                vfpage = pageSetting.VFPageName__c;
            }
        }
        if (vfpage != null && vfpage != ''){
             PageReference accPage = new PageReference('/apex/'+ vfpage);
             accPage.setRedirect(true);
             return accPage;
        }
        return null;
    }
    //Added By Rahul Mehta as part of handling the response received from CDM 
      public Object processResponseForKR(HttpResponse res) {
            //HttpResponse res = Continuation.getResponse(this.requestLabel);
            System.debug('res*** ' + res.getBody());
            //res.setBody('{"OP_UCID":[{"IdentificationTypeValue":"UCID","IdentificationNum":"300001269145F53B20B","AdminClientNum":"0010k00000ii7W2AAI"}]}');
              
          //Added for JP track.
            //readonly= true;  
            //editmode=false; 
          // Set the result variable that is displayed on the Visualforce page
        try{
            //this.requestLabel = res.getBody();
            //CustomLogUtil.CustomLoggingEntry('Continuation Response Body' + res.getBody());
            System.debug('res*** ' + res.getBody());
            if(res.getbody()=='{}'){
                system.debug('Inside If Of Respone');
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
                //custSearch=JSON2ApexCustomerFromCDM.parse(res.getbody());
                //system.debug('custSearch:'+custSearch);
                
                JSON2ApexCustomerCDM  custSearchJP = JSON2ApexCustomerCDM.parse(res.getBody());
                system.debug('custSearch:'+custSearchJP);
                list<string> set_accounts= new list<string>();
                //For(JSON2ApexCustomerFromCDM.Out_JSON_UCID_List cust : custSearch.out_JSON_UCID_List){
                For(JSON2ApexCustomerCDM.cls_OP_UCID  cust : custSearchJP.OP_UCID){
                    system.debug('cust:'+cust);
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                    if(string.valueof(m.get(Label.AdminClientNum))!=null)
                        set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                }
                if(set_accounts.size()>0){
                    showCDM=true;
                    String addressFieldsQuery = ',Primary_Address_Reference__c, Primary_Address_Reference__r.Province__c, Primary_Address_Reference__r.City__c,Primary_Address_Reference__r.District__c,Primary_Address_Reference__r.Block__c,Primary_Address_Reference__r.Address_Line_1__c,Primary_Address_Reference__r.Address_Line_2__c,Primary_Address_Reference__r.Address_Code__c,Primary_Address_Reference__r.ZipCode__c,Primary_Address_Reference__r.Temp_ZipCode__c,Primary_Address_Reference__r.Temp_Address__c';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                    //string querytxt='select id,firstname,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__celect id,firstname,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,Primary_Address_Display__c from account where <Search> in (';
                    string querytxt='select id,firstname,isPersonAccount,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,Primary_Address_Display__c from account where <Search> in (';
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
                            if(market == System.Label.KR)
                            {
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
                    if(market==system.label.KR){
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

}
