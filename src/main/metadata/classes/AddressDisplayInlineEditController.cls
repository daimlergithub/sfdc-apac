/**   
Purpose:  Innline controller To add, edit and delete related address to an account   
created by: Srinivas 11/3/2015
modified by: Sudhir Kumar Acharya 11/30/2015

*/
public class AddressDisplayInlineEditController { 
    public boolean openPanal{get;set;}
    public List<Address__c> adds {get; set;}
    public Address__c addressobj {get; set;}
    public Boolean ShowpageBlockFlag {get;set;}
    public Boolean refreshPage{get;set;}
    private ApexPages.StandardController stdController;   
    public string addressId {get;set;}
    public string editaddressId {get;set;}  
    public String aid;
    public boolean Address_Validated_Flag {get;set;}
    public String addresspicklist{get;set;}
    public String market{get;set;}
    public String provincepicklist{get;set;}
    Public Boolean Validation;
    Public Boolean profilename{get;set;}
    public Boolean Communityuser{get;set;}
    public AddressDisplayInlineEditController(ApexPages.StandardController stdController){
        this.stdController = stdController;     
        aid = ApexPages.currentPage().getParameters().get('id');
        Address_Validated_Flag = false;
        system.debug('######'+ aid); 
        if(ApexPages.currentPage().getParameters().get('id')!=Null){            
            adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                    Address_Line_2__c ,Address_Line_1__c,District__c,HouseNumber__c,City__c, Block__c, TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,        
                    Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c =: aid ];        
            system.debug('@Account Information :' +adds);
        }                     
        /*Intitializing address object*/
        addressobj = new Address__c();
        User u = [SELECT Id,Market__c,Profile.Name,contactId FROM User WHERE Id=:UserInfo.getUserId()] ;
        market = u.Market__c;
        openPanal = true;
        if(market == 'KR'){
            openPanal = true;
        }
        profilename = FALSE;
        
        if(u.Profile.Name.contains('Dealer')){
            profilename = TRUE;
        }
        Communityuser = false;
        if(u.contactId != Null){
            Communityuser = true;
        }
    } 
    public List<SelectOption> getAddressOptions() {
        List<SelectOption> AddressOptions = new List<SelectOption>();
        if(market=='KR'){           
           AddressOptions.add(new SelectOption('Home','Home'));
           AddressOptions.add(new SelectOption('Business','Business'));           
        }
        else{
            try{
                Schema.DescribeFieldResult countryFieldDescription = Address__c.Address_Type__c.getDescribe();
                for(Schema.Picklistentry picklistEntry : countryFieldDescription.getPicklistValues()){
                    AddressOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                }
            }
            catch(Exception e){}
        }
        return AddressOptions;      
    }
    /**    
        * @Description : Cancel functionality 
        * @author      : Srinivas
        * @Date        : 11/3/2015
        * @return      : null
    **/  
    public void cancelEdit() {              
        ShowpageBlockFlag = null;
        if(addressobj!=Null){
            addressobj.clear();
            editaddressId=Null;
        }             
    }
    
    
    /**    
        * @Description : to load updated data after deletion of address
        * @author      : Srinivas
        * @Date        : 11/3/2015     
    **/  
    @TestVisible private void loadData() {
        system.debug('@Loading Addresses...' +aid);
        adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,
                Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,       
                Address_Line_2_Native__c  from Address__c where Customer__c =: aid];
    }
    
    /**    
        * @Description : deletes the address record 
        * @author      : Srinivas
        * @Date        : 11/3/2015
    **/  
    
    public void delAccountAddress(){        
        system.debug('@addressId :' +addressId);        
        // if for any reason we are missing the reference 
        if (addressId == null) {
            return;
        }        
        // find the address record within the collection
        Address__c tobeDeleted = null;
        for(Address__c a : adds)
            if (a.Id == addressId){
                tobeDeleted = a;
                break;
            }      
            //if address record found delete it
            if(tobeDeleted != null) {
                system.debug('@Delete DML' +tobeDeleted.id);
                try{
                    Delete tobeDeleted;
                }catch (DmlException e) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));
                }
            }
        //refresh the data
        loadData();
    }
    
    public void addEditOptions(){    
        Account acc=[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];
        adds= [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,
               Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c=:acc.id];
        if(adds.size()>=5){
            ShowpageBlockFlag=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,system.label.Account_cannot_have_more_than_5_Address));
        }
        else 
            ShowpageBlockFlag = true;
    }
    
    
    /**    
        * @Description : Edit the address record  
        * @author      : Sudhir
        * @Date        : 11/12/2015    
    **/  
    public void EditOptions(){
        Address__c editadds;
        if (editaddressId != null){
            editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,
                        Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Id =: editaddressId];
            // if for any reason we are missing the reference           
        }
        
        // find the address record within the collection
        If(editadds!=null)
        {                     
            addressobj.Address_Type__c = editadds.Address_Type__c;
            addressobj.ZipCode__c = editadds.ZipCode__c;
            addressobj.Province__c = editadds.Province__c;
            addressobj.City__c = editadds.City__c;
            addressobj.District__c =editadds.District__c;
            addressobj.Block__c =editadds.Block__c;
            addressobj.Address_Line_1__c =editadds.Address_Line_1__c;
            addressobj.Address_Line_2__c =editadds.Address_Line_2__c;
            addressobj.Company_Name__c =editadds.Company_Name__c;
            addressobj.Company_Name_Native__c = editadds.Company_Name_Native__c;
            addressobj.TitleOfHonor__c =editadds.TitleOfHonor__c;
            addressobj.Status__c =editadds.Status__c;
            addressobj.Preferred__c = editadds.Preferred__c;
            addressobj.Temp_ZipCode__c = editadds.Temp_ZipCode__c ;
            addressobj.Temp_Address__c = editadds.Temp_Address__c ;
            addressobj.Block_Native__c = editadds.Block_Native__c;      
            addressobj.City_Native__c = editadds.City_Native__c;        
            addressobj.Province_Native__c = editadds.Province_Native__c;        
            addressobj.District_Native__c = editadds.District_Native__c;        
            addressobj.Address_Line_1_Native__c = editadds.Address_Line_1_Native__c;        
            addressobj.Address_Line_2_Native__c = editadds.Address_Line_2_Native__c;
        }      
        ShowpageBlockFlag = true;        
    }
    /**    
        * @Description : creates new address record  
        * @author      : Srinivas
        * @Date        : 11/3/2015    
    **/  
    
    public void saveAddress(){
        Validation = false;
        if(addressobj != null ){
            Account acc =[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];            
            //AddressObj.Address_Type__c = addresspicklist;
            if(editaddressId ==null){
                addressobj.Customer__c = acc.id;            
                try{  
                    if(Address_Validated_Flag == false)
          {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = true;
                    }
                    if((market != 'KR') && addressobj.ZipCode__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.'));
                        Validation = true;
                    }
                    if((market == 'KR') && addressobj.Province__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.')); 
                        Validation = true;
                    }
                    /*if((market == 'KR') &&addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c))){       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = true;
                    }*/  
          if(Address_Validated_Flag == true && Validation == False)
          {
            refreshPage= true;
            addressObj.Id = null;
            addressObj.Address_Code__c = ValidateAddressCode(addressObj);
            insert addressobj;
          }
                }
                catch (DmlException e){
                    refreshPage = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));                                          
                }
            }
            else if(editaddressId !=null){
                addressobj.id = editaddressId;             
                try {  
                    if(Address_Validated_Flag == false)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_validation));
                        Validation = true;
                    }
                    /*if((market == 'KR') && (addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c)))){       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));   
                        Validation = true;
                    }*/
                    if((market != 'KR') && addressobj.ZipCode__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIPCODE is mandatory.')); 
                        Validation = true;
                    }
                    if((market == 'KR') && addressobj.Province__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.')); 
                        Validation = true;
                    }                    
                    else 
                    {   if(Validation == False){
                            refreshPage= true;
                            addressObj.Address_Code__c = ValidateAddressCode(addressObj);
                            update addressobj;
                        }
                    }
                }
                catch (DmlException e) 
                {
                    refreshPage = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));                    
                    system.debug(e.getDMLMessage(0)+'   Error Meassage   '+refreshPage);
                }
            }    
        }  
    }
    
    /**  Address Search based on Zip code.
        Sends zip code to EP/Tolerant and fetches the matched address details and populates on Screen. 
        **  Created By: Sudhir  
        **  Date: 2016-1-19
        **/
    public void AddressSearch()
    {
        if(addressobj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',addressobj.ZipCode__c)  ))
        {            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_validation));  
        }
        
        if(AddressObj.Address_Line_2__c != null ||  AddressObj.Address_Line_2_Native__c != null || AddressObj.Address_Line_1__c != null || AddressObj.Address_Line_1_Native__c != null || AddressObj.Block__c != null || AddressObj.Block_Native__c != null ||  AddressObj.City__c != null || AddressObj.City_Native__c != null ||
           AddressObj.District__c != null || AddressObj.District_Native__c != null || AddressObj.Province__c != null || AddressObj.Province_Native__c != null )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Address_fields_not_null)); 
            
        }
        
        else if(AddressObj.ZipCode__c != null && (Pattern.matches('^[0-9]{7}$',AddressObj.ZipCode__c)))
        {
            crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
            response =  UtilWebservice.validateAddressByZipCode(addressobj);
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
                        system.debug(' *$*$*$* 123  AddressObj.Address_Line_1__c   ' + AddressObj.Address_Line_1__c);
                    }
                    if(ValidStr.contains('Address_Line_2__c'))
                    {
                        AddressObj.Address_Line_2__c = response.Addresses[0].Address_Line_2;
                        system.debug(' *$*$*$* 123 AddressObj.Address_Line_2__c   ' + AddressObj.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c'))
                    {
                        AddressObj.Block__c = response.Addresses[0].Block;
                        system.debug(' *$*$*$* 123 AddressObj.Block__c   ' + AddressObj.Block__c);
                    }
                    if(ValidStr.contains('City__c'))
                    {
                        AddressObj.City__c = response.Addresses[0].City;
                        system.debug(' *$*$*$* 123 AddressObj.City__c   ' + AddressObj.City__c);
                    }
                    if(ValidStr.contains('District__c'))
                    {
                        AddressObj.District__c = response.Addresses[0].District;
                        system.debug(' *$*$*$* 123 AddressObj.District__c   ' + AddressObj.District__c);
                    }
                    if(ValidStr.contains('Province__c'))
                    {
                        AddressObj.Province__c = response.Addresses[0].Province;
                        system.debug(' *$*$*$* 123 AddressObj.Province__c   ' + AddressObj.Province__c);
                    }
                    
                }
            }
            if(response != null && response.ValidationStatus == 'ERROR')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));
                
            }            
        } 
    } 
    /**  Address Validation based on Zip code.
        After Address is searched using Address Search button and if user enters additional address information, It sends information to 
        EP/Tolerant for Validation.
        **  Created By: Sudhir  
        **  Date: 2016-1-19
    **/
    public void ValidateAddressSearch(){
        system.debug('addresspicklist 4 :'+addresspicklist);
        system.debug('Market 1 :'+Market);
        if(Market =='KR'){         
           /* if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c))){               
                addressobj.Address_Code__c = '';
                addressobj.Address_Line_1__c = '';
                addressobj.Address_Line_2__c = '';
                addressobj.Block__c = '';
                addressobj.City__c = '';
                addressobj.District__c = '';
                addressobj.Province__c = '';
                addressobj.MD__c = ''; 
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
            if(addressobj.Province__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.'));  
            }
             //Commented the IF condition as address can be searched without postcode as well for MBK. As confirmed by Enriko, Falk and Andrew.
            //if(addressobj.ZipCode__c != null)
            //{
      //Changes as part of SFDCKR-683
      if(addressobj.Province__c != null)
      {
                addressobj.MD__c = Market;
                ValidateAddressSearchCallout(addressobj);
      }
            //}           
        }
        if(Market !='KR' && Market !='' ){
            if(addressobj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',addressobj.ZipCode__c))){
                addressobj.Address_Code__c = '';
                addressobj.Address_Line_1__c = '';
                addressobj.Address_Line_2__c = '';
                addressobj.Block__c = '';
                addressobj.City__c = '';
                addressobj.District__c = '';
                addressobj.Province__c = '';  
                addressobj.Block_Native__c = '';
                addressobj.City_Native__c = '';
                addressobj.Province_Native__c = '';     
                addressobj.District_Native__c = '';     
                addressobj.Address_Line_1_Native__c = '';       
                addressobj.Address_Line_2_Native__c = '';
                addressobj.MD__c = '';              
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_validation));                              
            }
            if(addressobj.ZipCode__c != null){
                addressobj.MD__c = Market;
                ValidateAddressSearchCallout(addressobj);
            }  
        }
    }
    public List<addressSelectionWrapper> mapAddressResponse{get; set;}
    public void ValidateAddressSearchCallout(Address__c addressobj){       
        mapAddressResponse = new List<addressSelectionWrapper>();      
        //Address__c AddressObjtemp1 = new Address__c();       
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        response =  UtilWebservice.validateAddressByZipCode(addressobj);
        system.debug('*$*$*$*$ response   ' + response);
        
        if(response != null && response.ValidationStatus == 'OK'){
             for(Integer i=0;i<response.Addresses.size();i++){                
                Address__c AddressObjtemp = new Address__c(); 
                Address_Validated_Flag = true;
                AddressObjtemp.ZipCode__c =  response.Addresses[i].ZipCode;           
                if(response.Addresses[i].ValidFields != null &&  response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid ){
                    String ValidStr = response.Addresses[i].ValidFields;
                    system.debug('valid string ------'+ ValidStr );
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtemp.Province__c)){
                        province = addtrmapUpdate.get(AddressObjtemp.Province__c);
                    }
                    if(ValidStr.contains('Address_Line_1__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    else if(ValidStr.contains('Address_Line_1__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1__c   ' + AddressObjtemp.Address_Line_1__c);
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    else if(ValidStr.contains('Address_Line_2__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2__c   ' + AddressObjtemp.Address_Line_2__c);
                    }
                    if(ValidStr.contains('Block__c') && Market == 'JP')
                    {
                      addressobj.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    else if(ValidStr.contains('Block__c') && Market == 'KR')
                    {
                        AddressObjtemp.Block__c = response.Addresses[i].Block;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block__c   ' + AddressObjtemp.Block__c);
                    }
                    if(ValidStr.contains('City__c') && Market == 'JP')
                    {
                      addressobj.City__c = response.Addresses[i].City;
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
                      addressobj.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    else if(ValidStr.contains('District__c') && Market == 'KR')
                    {
                        AddressObjtemp.District__c = response.Addresses[i].District;
                        system.debug(' *$*$*$* Res AddressObjtemp.District__c   ' + AddressObjtemp.District__c);
                    }
                    if(ValidStr.contains('Province__c') && Market == 'JP')
                    {
                      addressobj.Province__c = response.Addresses[i].Province;
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
                    system.debug(Market + '   *$*$*$*  addtrmapUpdate ' + addtrmapUpdate);
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(addressobj.Province__c)){
                        province = addtrmapUpdate.get(addressobj.Province__c);
                    }
                    addressobj.Province__c =  province;
                    addressobj.Temp_ZipCode__c = addressobj.ZipCode__C;
                    addressobj.Temp_Address__c = ((addressobj.Province__c != null) ? addressobj.Province__c : '' ) + ((addressobj.City__c != null) ? addressobj.City__c : '' ) +
                        ((addressobj.District__c != null) ? addressobj.District__c : '' ) + ((addressobj.Block__c != null) ? addressobj.Block__c  : '' ) +
                        ((addressobj.Address_Line_1__c != null) ? addressobj.Address_Line_1__c  : '' ) + ((addressobj.Address_Line_2__c != null) ? addressobj.Address_Line_2__c  : '' );
                    addressobj.Address_Code__c = '';
                    addressobj.Address_Line_1__c = '';
                    addressobj.Address_Line_2__c = '';
                    addressobj.Block__c = '';
                    addressobj.City__c = '';
                    addressobj.District__c = '';
                    addressobj.Province__c = '';
                    //mapAddressResponse.add(new addressSelectionWrapper(addressobj)); 
                }
            }
        }
        if(response != null && response.ValidationStatus == 'ERROR'){
            addressobj.Address_Code__c = '';
            addressobj.Address_Line_1__c = '';
            addressobj.Address_Line_2__c = '';
            addressobj.Block__c = '';
            addressobj.City__c = '';
            addressobj.District__c = '';
            addressobj.Province__c = '';
            addressobj.Temp_ZipCode__c = addressobj.ZipCode__C;
            addressobj.Temp_Address__c = ((addressobj.Province__c != null) ? addressobj.Province__c : '' ) + ((addressobj.City__c != null) ? addressobj.City__c : '' ) +
                    ((addressobj.District__c != null) ? addressobj.District__c : '' ) + ((addressobj.Block__c != null) ? addressobj.Block__c  : '' ) +
                    ((addressobj.Address_Line_1__c != null) ? addressobj.Address_Line_1__c  : '' ) + ((addressobj.Address_Line_2__c != null) ? addressobj.Address_Line_2__c  : '' );
            //mapAddressResponse.add(new addressSelectionWrapper(addressobj));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Zipcode_not_found));
        }                
    }
    
    
    
    /**  Address Code Validation.
If the user is Saving  same address which matches the fields returned by tolerant, update Address with proper Address code returned by Tolerant
**  Created By: Narasimha  
**  Date: 2016-2-8
** Modified By: Rakesh Babu
** Date 2017-3-30
**/
    public String ValidateAddressCode(Address__c Address)
    {
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        response =  UtilWebservice.validateAddressByZipCode(Address);
        if(response != null && response.ValidationStatus == 'OK')
        {  
            if(AddressObj.ZipCode__c == response.Addresses[0].ZipCode  && 
               AddressObj.City__c == response.Addresses[0].City && AddressObj.District__c == response.Addresses[0].District && AddressObj.Province__c == response.Addresses[0].Province )
            {   
                if(((AddressObj.Block__c == response.Addresses[0].Block) || (response.Addresses[0].Block == '' && AddressObj.Block__c == null))){
                        if(((AddressObj.Address_Line_1__c == response.Addresses[0].Address_Line_1) || (response.Addresses[0].Address_Line_1 == '' &&AddressObj.Address_Line_1__c == null))){
                            if(((AddressObj.Address_Line_2__c == response.Addresses[0].Address_Line_2) || (response.Addresses[0].Address_Line_2 == '' &&AddressObj.Address_Line_2__c == null))){
                                return response.Addresses[0].Address_Code;
                            }
                    }
                }
            }
            
            else 
            {   
                return null;
            }
        }
        return null;
    }
    Public class addressSelectionWrapper{
        Public boolean isSelected{get;set;}
       
        Public Address__c add{get;set;} 
        public addressSelectionWrapper(Address__c add){
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