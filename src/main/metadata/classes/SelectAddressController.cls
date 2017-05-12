/**   
Purpose:    
created by: Siva 26/12/2016
*/

public with sharing class SelectAddressController {
    
    public List<Address__c> addressList {get; set;}
    private ApexPages.StandardController stdController;
    public String accountId;
    public String market{get;set;}
    public String selectedAddress {get; set;}
    public List<SelectOption> addressSelectOptionList {get; set;}
    
    public SelectAddressController(ApexPages.StandardController stdController) {
        this.stdController = stdController; 
        accountId = ApexPages.currentPage().getParameters().get('id');
        addressSelectOptionList = new List<SelectOption>();
        User u = [SELECT Id,Market__c,Profile.Name FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        addressList = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                    Address_Line_2__c ,Address_Line_1__c,District__c,HouseNumber__c,City__c, Block__c, TitleOfHonor__c,
                    Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,
                    Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,
                    Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c =: accountId ];                     
    
 addressSelectOptionList.add(new SelectOption('None', '--None--'));
    for(Address__c addressRec : addressList) {         
          String addressType = addressRec.Address_Type__c; 
         addressSelectOptionList.add(new SelectOption(addressRec.Id, addressType));     
    }    
    
    List<Account> accountList = [select Primary_Address_Reference__c from Account where Id =: accountId];
      if(accountList.size() > 0 && String.isNotBlank(accountList[0].Primary_Address_Reference__c)) {
         selectedAddress = accountList[0].Primary_Address_Reference__c;
     }
  }
    
    public PageReference updateAddress() {
        Account accRec = new Account(Id = accountId);  
        if(selectedAddress != 'None' )  
        accRec.Primary_Address_Reference__c = selectedAddress;  
        else
            accRec.Primary_Address_Reference__c = null;       
        update accRec;       
        return null;
    }
}