/**
** Controller Class for Account Creation page AddressSearchValidation.
** OverRides Standard Account Creation "New" Button.
** Validates Address Details through webservice call to EP/Tolerant.
** Creates new Account with validated Address Record.
** Created By: Narasimha
** Date: 2016-1-20
** Modified By :
** Modified date :
**/
public class AddressSearchValidationController{
    //variables used in the page.
    ApexPages.StandardController controller;
    public string selectedRecordType{get;set;}
    public Account objAccount{get;set;}
    public Account objPersonAccount{get;set;}
    public boolean refreshPage {get; set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    public id recordTypeId;
    public Boolean show {get;set;}
    public Account objAccountDeDup{get;set;}
    public List<Account> cResult{get;set;} 
    public Address__C AddressObj {get;set;}
    public boolean Address_Validated_Flag {get;set;}   
    Public Boolean Validation;
    
    // KOREA related parameters - Start
    public String market{get;set;}
    public String homePhoneAreaCodePart1{get;set;}   
    public String homePhoneAreaCodePart2{get;set;}
    public String homePhoneAreaCodePart3{get;set;}
    public String workPhoneAreaCodePart1{get;set;}   
    public String workPhoneAreaCodePart2{get;set;}
    public String workPhoneAreaCodePart3{get;set;}
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
    // KOREA related parameters - End
    Public boolean mbkdatasource {get;set;}
    Public boolean datasource {get;set;}
    
    // COnstructor
        public boolean firstsave{get;set;}      
        public boolean secondsave{get;set;}
    
        public AddressSearchValidationController(ApexPages.StandardController controller){
        objAccount= new Account();
        objPersonAccount= new Account();
        AddressObj = new Address__c();
        accountOwner=userinfo.getname();
        Address_Validated_Flag = false;
        
        
        // refreshPage = false;        
        User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        if(market == 'KR'){
            mbkdatasource = true;
            datasource = false;
        }
        if(market != 'KR'){
            mbkdatasource = false;
            datasource = true;
        } 
        firstsave = false;                    
        secondsave = true;   
          
    }
    public List<SelectOption> getAddressOptions() {
        List<SelectOption> AddressOptions = new List<SelectOption>();
        if(market=='KR'){  
           AddressOptions.add(new SelectOption('--None--','--None--'));         
           AddressOptions.add(new SelectOption('Home','Home'));
           AddressOptions.add(new SelectOption('Business','Business'));           
        }
        else{
            try{
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
      
    /**  Save Account based on two scenarios
* 1. With Validated Address information record.
* 2.Without Address record.
**  Created By: Narasimha 
**  Date: 2016-1-19
**/
    
    public pagereference saveAccount(){    
        system.debug('enter 1 :');
        AddressObj.Address_Type__c = addresspicklist;
        //AddressObj.Province__c = provincepicklist;
        Validation = false;
        // Save record without Address record if no value is Entered in Address section
        if((AddressObj.Address_Type__c == '' || AddressObj.Address_Type__c == null || AddressObj.Address_Type__c == '--None--') && AddressObj.Address_Line_1__c ==null && AddressObj.Address_Line_2__c == null &&
           AddressObj.ZipCode__c == null && AddressObj.Block__c ==  null && AddressObj.City__c == null &&  AddressObj.District__c == null &&
           AddressObj.Province__c == null)
        {   system.debug('enter 2 :');
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
                    {   system.debug('JP Company loop 1 :');
                        refreshPage = true;
                        insert objAccount ;
                        PageReference pageRef = new PageReference('/'+objAccount.Id);
                        return PageRef;
                    }                   
                }               
                if(recordType == 'Person Account' )
                {                   
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    if(objPersonAccount.Individual_Home_Phone__c == null && objPersonAccount.Mobile__c == null && objPersonAccount.Work_Phone__c == null &&
                       objPersonAccount.Mobile2__c == null && objPersonAccount.Home_Phone_2__c == null &&  objPersonAccount.Phone == null &&
                       objPersonAccount.Email__c == null && objPersonAccount.Email2__c == null)
                    {
                        system.debug('Enter JP Loop : ');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    }
                    else
                    {   system.debug('JP Company loop 2 :');
                        refreshPage = true;
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
                system.debug('recordType 1:'+recordType);
                if(recordType == System.Label.Company && market == System.Label.KR)
                {    
                    system.debug('recordType 2:'+recordType);
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.Company).getRecordTypeId();
                    objAccount.RecordTypeId = recordTypeId;
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
                    } system.debug(objAccount.Individual_Home_Phone__c + '   *$*$*$ objAccount.Individual_Home_Phone__c   ' + objAccount.Mobile__c + '   *$*$*$*  objAccount.Work_Phone__c   ' + objAccount.Work_Phone__c + '   *$*$*$* objAccount.Email__c   ' + objAccount.Email__c);                   
                    if(objAccount.Individual_Home_Phone__c == '' && objAccount.Mobile__c == '' && objAccount.Work_Phone__c == '' && objAccount.Email__c == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    
                       if(objAccount.Vat_No__c == null && objAccount.Commercial_Reg_No__c == null)
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Business registration number / Vat registration '));
                    }
                    else{
                        refreshPage = true;                      
                        insert objAccount ;
                        PageReference pageRef = new PageReference('/'+objAccount.Id);
                        return PageRef; 
                    } 
                }
                system.debug('recordType 3:'+recordType);
                if(recordType == System.Label.PersonAccount && market == System.Label.KR){    
                    system.debug('recordType 4:'+recordType);   
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.PersonAccount).getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                    {    
                        system.debug('*$*$*$ Entered HOme Null scenario');                  
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
                        system.debug('*$*$*$ Entered BLANK scenario'); 
                        objPersonAccount.Individual_Home_Phone__c = '';
                    }
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
                    if(objPersonAccount.Individual_Home_Phone__c == '' && objPersonAccount.Mobile__c == '' && objPersonAccount.Work_Phone__c == '' && objPersonAccount.Email__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
                    }
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
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = true;
                    }
                    if(AddressObj.Address_Type__c == null )
                    {   
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation)); 
                        Validation = true;
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
                    if(Validation == False){
                        refreshPage = true;
                        objAccount.id = null;
                        insert objAccount ;
                        AddressObj.Customer__c = objAccount.id;
                        if(AddressObj.Temp_ZipCode__c == null && AddressObj.Temp_Address__c == null)
                        {
                        AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
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
                    if(AddressObj.Address_Type__c == null )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        
                    }
                    if ((Address_Validated_Flag) && AddressObj.Address_Type__c != null )
                    {
                        refreshPage = true;
                        insert objAccount ;
                        AddressObj.Customer__c = objAccount.id;
                        AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
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
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = TRUE;
                    }
                    if(AddressObj.Address_Type__c == null )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        Validation = TRUE;
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
                        if(homePhoneAreaCodePart1 == ' ' && homePhoneAreaCodePart2 == '' && homePhoneAreaCodePart3 == '')
                        {    
                            system.debug('*$*$*$ Entered HOme Null scenario');                  
                            objPersonAccount.Individual_Home_Phone__c = '';
                        }
                        else if((homePhoneAreaCodePart1 != ' ' || homePhoneAreaCodePart1 == ' ') && (homePhoneAreaCodePart2 == '' || homePhoneAreaCodePart2 != '') && (homePhoneAreaCodePart3 == '' || homePhoneAreaCodePart3 != ''))
                        {       
                            system.debug('*$*$*$ Entered HOme either Null or not null scenario');               
                            objPersonAccount.Individual_Home_Phone__c = homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
                            if(objPersonAccount.Individual_Home_Phone__c.startsWith(' -'))
                            {
                                objPersonAccount.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c.removeStart(' -');
                            }
                        }                    
                        else
                        {
                            system.debug('*$*$*$ Entered BLANK scenario'); 
                            objPersonAccount.Individual_Home_Phone__c = '';
                        }
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
                        
                        if(Validation == false){
                            refreshPage = true;
                            objPersonAccount.Id = null;
                            insert objPersonAccount ;
                            AddressObj.Customer__c = objPersonAccount.id;
                            if(AddressObj.Temp_ZipCode__c == null && AddressObj.Temp_Address__c == null)
                            {
                            AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
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
                    if(AddressObj.Address_Type__c == null )
                    {   system.debug('Enter JP Loop 4 :'); 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        
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
                            upsert objPersonAccount ;
                            if(AddressObj !=null && (Address_Validated_Flag )){
                                AddressObj.Customer__c = objPersonAccount.id;
                                AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
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
        return null;
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
        resetPhoneAreacodes();
        selectedRecordType = recordType;        
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
            response =  UtilWebservice.validateAddressByZipCode(AddressObj);
           
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));               
            }
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
        if(Market =='KR'){
            /*if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))
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
        }
        if(Market !='KR'){
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
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_validation));  
            }
            if(AddressObj.ZipCode__c != null){
                AddressObj.MD__c = Market;
                ValidateAddressSearchCallout(AddressObj);
            } 
        }     
    }
    
    public List<addressSelectionWrapper> mapAddressResponse{get; set;}
    
    public void ValidateAddressSearchCallout(Address__c AddressObj){ 
        mapAddressResponse = new List<addressSelectionWrapper>();     
        system.debug('recordType 10:'+ objPersonAccount.Mobile__c);  
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        response =  UtilWebservice.validateAddressByZipCode(AddressObj);
        //system.debug('response >> 1:'+response);
        //system.debug('response >> 2:'+response.Addresses.size());
        if(response != null && response.ValidationStatus == 'OK'){
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
                    if(ValidStr.contains('Address_Line_1__c') && Market == 'JP')
                    {
                      Addressobj.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    else if(ValidStr.contains('Address_Line_1__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == 'JP')
                    {
                      AddressObj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    else if(ValidStr.contains('Address_Line_2__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c') && Market == 'JP')
                    {
                      AddressObj.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    else if(ValidStr.contains('Block__c') && Market == 'KR')
                    {
                        AddressObjtemp.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    if(ValidStr.contains('City__c') && Market == 'JP')
                    {
                      AddressObj.City__c = response.Addresses[i].City;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                    else if(ValidStr.contains('City__c') && Market == 'KR')
                    {
                        AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City__c   ' + AddressObjtemp.City__c);
                    }
                    if(ValidStr.contains('District__c') && Market == 'JP')
                    {
                      AddressObj.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    else if(ValidStr.contains('District__c') && Market == 'KR')
                    {
                        AddressObjtemp.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    if(ValidStr.contains('Province__c') && Market == 'JP')
                    {
                      AddressObj.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                    else if(ValidStr.contains('Province__c') && Market == 'KR')
                    {
                        AddressObjtemp.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                   mapAddressResponse.add(new addressSelectionWrapper(AddressObjtemp));  
                }
                else if(!response.Addresses[i].Valid){
                    string province;  
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObj.Province__c))
                    {
                        province = addtrmapUpdate.get(AddressObj.Province__c);
                    }
                    AddressObj.Province__c =  province;
                    AddressObj.Temp_ZipCode__c = AddressObj.ZipCode__C;
                    AddressObj.Temp_Address__c = ((AddressObj.Province__c != null) ? AddressObj.Province__c : '' ) + ((AddressObj.City__c != null) ? AddressObj.City__c : '' ) +
                        ((AddressObj.District__c != null) ? AddressObj.District__c : '' ) + ((AddressObj.Block__c != null) ? AddressObj.Block__c  : '' ) +
                        ((AddressObj.Address_Line_1__c != null) ? AddressObj.Address_Line_1__c  : '' ) + ((AddressObj.Address_Line_2__c != null) ? AddressObj.Address_Line_2__c  : '' );
                    AddressObj.Address_Code__c = '';
                    AddressObj.Address_Line_1__c = '';
                    AddressObj.Address_Line_2__c = '';
                    AddressObj.Block__c = '';
                    AddressObj.City__c = '';
                    AddressObj.District__c = '';
                    AddressObj.Province__c = '';
                    AddressObj.ZipCode__C = '';  
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
        response =  UtilWebservice.validateAddressByZipCode(Address);       
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
        
    public List<SelectOption> getAreacodeItems() {
         AreaCodeTranslation__mdt  areacodeKR = [SELECT Id,Phone_EN1__c,Phone_TR1__c,Phone_EN2__c,Phone_TR2__c,Phone_EN3__c,Phone_TR3__c ,Phone_EN4__c,Phone_TR4__c,Phone_EN5__c,Phone_TR5__c,Phone_EN6__c,Phone_TR6__c,Phone_EN7__c,Phone_TR7__c,
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
                   
        List<SelectOption> options = new List<SelectOption>();
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
        return options;
    }
        
    public void resetPhoneAreacodes(){
        homePhoneAreaCodePart1 = homePhoneAreaCodePart2 = homePhoneAreaCodePart3 = workPhoneAreaCodePart1 = workPhoneAreaCodePart2 = workPhoneAreaCodePart3 = homePhone2AreaCode = homePhone2AreaCodePart2 = homePhone2AreaCodePart3 = mobileAreaCode= mobileAreaCodePart2 = mobileAreaCodePart3 = '';
    }     
    
    public List<SelectOption> getMobileAreacodeItems() {
        AreaCodeTranslation__mdt  mobileAreaCodeKR = [SELECT Id,Mobile_Code1__c,Mobile_Code2__c,Mobile_Code3__c,Mobile_Code4__c,Mobile_Code5__c,Mobile_Code6__c,Mobile_Code7__c FROM AreaCodeTranslation__mdt WHERE MD__c  = 'KR' LIMIT 1]; 
        system.debug('mobileAreaCodeKR >>>>>>'+mobileAreaCodeKR);
        List<selectOption> options = new List<selectOption>();
           options.add(new SelectOption(' ',System.label.None));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code1__c,mobileAreaCodeKR.Mobile_Code1__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code2__c,mobileAreaCodeKR.Mobile_Code2__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code3__c,mobileAreaCodeKR.Mobile_Code3__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code4__c,mobileAreaCodeKR.Mobile_Code4__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code5__c,mobileAreaCodeKR.Mobile_Code5__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code6__c,mobileAreaCodeKR.Mobile_Code6__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code7__c,mobileAreaCodeKR.Mobile_Code7__c));           
           return options;
    }
     
    public void onLineDeduplication(){  
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
        if(objPersonAccount.LastName !=null) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            System.debug('@@@@@@@ response '+response );
           
            String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
            if(recordType !=null && recordType=='Company')
            {
                objPersonAccount.Recordtypeid=companyRecordTypeId;
            }
            system.debug('recordType------------:'+recordType);
            if(recordType !=null && recordType== 'Person Account')
            {             
                objPersonAccount.Recordtypeid=PersonAccountRecordTypeID ;
            }
            if(market == System.Label.KR)
            {
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
            if(NewAdd !=AddressObj && AddressObj!=null && AddressObj.ZipCode__c!=null)
            {
            response =  UtilWebservice.validateCustomerDetailsWithAddress(objPersonAccount,AddressObj); 
            }
            if(AddressObj == NewAdd)
            {
            response =  UtilWebservice.validateCustomerDetails(objPersonAccount); 
            }
            System.debug('@@@@@@@@@@ response '+response);
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
                    // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    // {
                    //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    // }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   string provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
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
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                 
                cResult = lstAcc;  
                System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                if(market == System.Label.KR && lstAcc != null && !lstAcc.isEmpty() && Userinfo.getUserType() == 'PowerPartner')
                {
                    system.debug('Entered>>>>');
                    AccountHelperKR.CreateRetailCopy(lstAcc, true, false);
                }
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }
        if(objAccount.Name !=null) 
        {
            crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
            System.debug('@@@@@@@ response >>'+response );
           
            String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
            String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
            if(recordType !=null && recordType=='Company')
            {
                objAccount.Recordtypeid=companyRecordTypeId;
            }
            system.debug('recordType------------: >> '+recordType);
            if(recordType !=null && recordType== 'Person Account')
            {             
                objAccount.Recordtypeid=PersonAccountRecordTypeID ;
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
                    // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                    // {
                    //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                    // }
                    if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                    {   string provincetmp = response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc;
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
                          UCID__c,Allow_Data_Sharing__c,PersonMobilePhone,Individual_Home_Phone__c,Work_Phone__c,PersonEmail,Preferred_Contact_Method__c,
                          PersonBirthdate,MBK_Occupation__c,Job__c,Special_Care__c,Special_Needs_Class__c,Mobile__c,
                          Preferred_Language__c,Gender__c,Company_Name_Native_1__c,OwnerId
                          From Account where  Id=:objAccountDeDup.Id];// and FirstName =: objPersonAccount.FirstName];
                 
                cResult = lstAcc;  
                System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                if(market == System.Label.KR && lstAcc != null && !lstAcc.isEmpty() && Userinfo.getUserType() == 'PowerPartner')
                {
                    system.debug('Entered>>>>');
                    AccountHelperKR.CreateRetailCopy(lstAcc, true, false);
                }
            }
            if(response == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
            }
        }       
        firstsave = true;       
        secondsave = false;         
    }
    Public class addressSelectionWrapper{
        Public boolean isSelected{get;set;}       
        Public Address__c add{get;set;} 
        addressSelectionWrapper(Address__c add){
            this.add = add;
            //isSelected = false;
        }         
    }
    public void SelectedAddress(){
        
        for(addressSelectionWrapper cWrapper : mapAddressResponse){
           
            if(cWrapper.isSelected){
                AddressObj.Province__c = cWrapper.add.Province__c;
                AddressObj.City__c = cWrapper.add.City__c;
                AddressObj.District__c = cWrapper.add.District__c;
                AddressObj.ZipCode__c= cWrapper.add.ZipCode__c; 
                AddressObj.Address_Line_1__c= cWrapper.add.Address_Line_1__c;
                AddressObj.Address_Line_2__c= cWrapper.add.Address_Line_2__c;  
                AddressObj.Temp_ZipCode__c = '';
                AddressObj.Temp_Address__c = '';             
            }
        }           
    }    
}