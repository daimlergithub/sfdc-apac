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
public class AddressSearchValidationController 
{
    //variables used in the page.
    ApexPages.StandardController controller;
    public string selectedRecordType{get;set;}
    public Account objAccount{get;set;}
    public Account objPersonAccount{get;set;}
    public boolean refreshPage {get; set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    public id recordTypeId;
    public Address__C AddressObj {get;set;}
    public boolean Address_Validated_Flag {get;set;}
    public String UserMarket{get;set;}
    
    
    // COnstructor 
    public AddressSearchValidationController(ApexPages.StandardController controller)
    {
        objAccount= new Account();
        objPersonAccount= new Account();
        AddressObj = new Address__c();
        accountOwner=userinfo.getname();
        Address_Validated_Flag = false;
        // refreshPage = false;
    }
    
    /**  Save Account based on two scenarios 
* 1. With Validated Address information record.
* 2.Without Address record.
**  Created By: Narasimha  
**  Date: 2016-1-19 
**/
    public pagereference saveAccount()
    {
        
        // Save record without Address record if no value is Entered in Address section
        if(AddressObj.Address_Type__c == null && AddressObj.Address_Line_1__c == null && AddressObj.Address_Line_2__c == null && 
           AddressObj.ZipCode__c == null && AddressObj.Block__c ==  null && AddressObj.City__c == null &&  AddressObj.District__c == null &&
           AddressObj.Province__c == null)
        {
            try
            {
                if( recordType == 'Company')
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
                        insert objAccount ;
                        PageReference pageRef = new PageReference('/'+objAccount.Id); 
                        return PageRef;
                    }
                    
                }
                
                if(recordType == 'Person Account')
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
        // Save record with Address record validating it through EP/Tolerant
        else
        {
            try{
                if( recordType == 'Company')
                {
                    
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                    objAccount.RecordTypeId = recordTypeId;
                    
                    if(Address_Validated_Flag == false)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                    }
                    if(AddressObj.Address_Type__c == null )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        
                    }
                    if (Address_Validated_Flag == true && AddressObj.Address_Type__c != null )
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
                if(recordType == 'Person Account')
                {
                    recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    objPersonAccount.RecordTypeId = recordTypeId;
                    
                    
                    if(Address_Validated_Flag == false)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                    }
                    if(AddressObj.Address_Type__c == null )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_type_Validation));
                        
                    }
                    
                    if (Address_Validated_Flag == true && AddressObj.Address_Type__c != null )
                    {
                        refreshPage = true;
                        insert objPersonAccount ;
                        AddressObj.Customer__c = objPersonAccount.id;
                        AddressObj.Address_Code__c = ValidateAddressCode(AddressObj);
                        insert AddressObj;
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
        
        selectedRecordType = recordType;
        system.debug('Selected type...' +selectedRecordType);
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
        
        if(AddressObj.Address_Line_2__c != null || AddressObj.Address_Line_1__c != null || AddressObj.Block__c != null || AddressObj.City__c != null ||
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
                
                
                if(response.Addresses[0].ValidFields != null &&  response.Addresses[0].ValidFields != '')
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
        
        if(AddressObj.ZipCode__c != null && (Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)))
        {
            crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
            response =  UtilWebservice.validateAddressByZipCode(AddressObj);
            if(response != null && response.ValidationStatus == 'OK')
            {
                Address_Validated_Flag = true;
                AddressObj.ZipCode__c =  response.Addresses[0].ZipCode;
                //AddressObj.Address_Code__c = response.Addresses[0].Address_Code;
                
                
                if(response.Addresses[0].ValidFields != null &&  response.Addresses[0].ValidFields != '' && response.Addresses[0].Valid)
                {
                    
                    String ValidStr = response.Addresses[0].ValidFields;
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
                
                else if(!response.Addresses[0].Valid)
                {
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues('JP');
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
     /**  User Market Validation.
When the user creates record , this method will help to get the current user market.
**  Created By: Sneha
**  Date: 2016-9-16
**/   
    public void ValidateCurrentuserMarket(){
        UserMarket = [select Id, Market__c from User where Id=:UserInfo.getUserId() limit 1].Market__c;
    
    }
}