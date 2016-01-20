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
    public string strHeaderTitle{get;set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    public id recordTypeId;
    public Address__C AddressObj {get;set;}
    public boolean Address_Validated_Flag {get;set;}
    
    // COnstructor 
    public AddressSearchValidationController(ApexPages.StandardController controller)
    {
        objAccount= new Account();
        objPersonAccount= new Account();
        AddressObj = new Address__c();
        accountOwner=userinfo.getname();
        Address_Validated_Flag = false;
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
                        insert objPersonAccount ;
                        PageReference pageRef = new PageReference('/'+objPersonAccount.Id); 
                        return PageRef;
                    }
                    
                }
                
                
                
            }
            catch(DMLException e)
            {
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
                        insert objAccount ;
                        AddressObj.Customer__c = objAccount.id;
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
                        insert objPersonAccount ;
                        AddressObj.Customer__c = objPersonAccount.id;
                        
                        insert AddressObj;
                        PageReference pageRef = new PageReference('/'+objPersonAccount.Id);            
                        return PageRef;
                    }
                    
                    
                    
                    
                    
                }
            }
            catch(DMLException e){
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
        if(AddressObj.ZipCode__c != null && (Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)))
        {
            system.debug('!!!!!!!' +'entering block after data correction');
            crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
            response =  UtilWebservice.validateAddressByZipCode(AddressObj);
            if(response != null && response.ValidationStatus == 'OK')
            {
                
                AddressObj.Address_Code__c = response.Addresses[0].Address_Code;
                AddressObj.Address_Line_1__c = response.Addresses[0].Address_Line_1;
                AddressObj.Address_Line_2__c = response.Addresses[0].Address_Line_2;
                AddressObj.Block__c = response.Addresses[0].Block;
                AddressObj.City__c = response.Addresses[0].City;
                AddressObj.District__c = response.Addresses[0].District;
                AddressObj.Province__c = response.Addresses[0].Province;
                AddressObj.ZipCode__c =  response.Addresses[0].ZipCode;
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
                AddressObj.Address_Code__c = response.Addresses[0].Address_Code;
                AddressObj.Address_Line_1__c = response.Addresses[0].Address_Line_1;
                AddressObj.Address_Line_2__c = response.Addresses[0].Address_Line_2;
                AddressObj.Block__c = response.Addresses[0].Block;
                AddressObj.City__c = response.Addresses[0].City;
                AddressObj.District__c = response.Addresses[0].District;
                AddressObj.Province__c = response.Addresses[0].Province;
                AddressObj.ZipCode__c =  response.Addresses[0].ZipCode;
                
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
    
    
}