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
    public List<SelectOption> lstDistrict{get; set;}
    public List<SelectOption> lstSubDistrict{get; set;}
    public List<SelectOption> lstZip{get; set;}
    public List<SelectOption> lstProvince{get; set;}
    public String district {get;set;}
    public String subdistrict {get;set;}
    public String zip {get;set;}
    public String province {get;set;}
    public String LanguageSelected{get; set;}
    public boolean IsForeignNational{get; set;}
    
    public AddressDisplayInlineEditController(ApexPages.StandardController stdController){
        this.stdController = stdController;     
        aid = ApexPages.currentPage().getParameters().get('id');
        Address_Validated_Flag = false;
        IsForeignNational=false;
        if(ApexPages.currentPage().getParameters().get('id')!=Null){            
            adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,Country__c,Sub_District__c,Language__c,Foreign_Nationals__c,
                    Address_Line_2__c ,Address_Line_1__c,District__c,HouseNumber__c,City__c, Block__c, TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,        
                    Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c =: aid Limit 10];        
           
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
    
    public void LoadProvince()
      {          
        lstProvince=new List<SelectOption>();
        Set<string> setProvinces = new set<string>();
        lstProvince.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempProvince : [select id,Province__c from RegionMasterInfo__c where Language__c=:LanguageSelected order by Province__c asc])
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
      
      public void LoadDistrict()
      {         
        lstDistrict=new List<SelectOption>();
        Set<string> setDistricts = new set<string>();
        lstDistrict.add(new SelectOption('--Select--','--Select--'));        
        for(RegionMasterInfo__c lsttempDistrict : [select id,District__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Province__c=:province order by District__c asc])
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
      
      public void LoadZip()
      {
        lstZip=new List<SelectOption>();
        Set<string> setZip = new set<string>();
        lstZip.add(new SelectOption('--Select--','--Select--'));
        for(RegionMasterInfo__c lsttempSubDistrict : [select id,ZipCode__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Province__c=:province and District__c=:district and Sub_DIstrict__c=:subdistrict order by ZipCode__c asc])
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
        if(AddressObj.Foreign_Nationals__c==true)
            IsForeignNational=true;
        else
            IsForeignNational=false;
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
        adds= [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,Sub_District__c,
               Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c=:acc.id Limit 10];
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
                        Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c,Sub_District__c,Language__c,Foreign_Nationals__c from Address__c where Id =: editaddressId Limit 10];
            // if for any reason we are missing the reference           
        }
        
        // find the address record within the collection
        If(editadds!=null)
        {                     
            addressobj.Address_Type__c = editadds.Address_Type__c;
            addresspicklist=editadds.Address_Type__c;
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
            
            addressobj.Foreign_Nationals__c=editadds.Foreign_Nationals__c;
            zip=editadds.ZipCode__c;
            province=editadds.Province__c;
            district=editadds.District__c;
            subdistrict=editadds.Sub_District__c;
            LanguageSelected=editadds.Language__c;
            ShowHideFields();
            LoadProvince();
            LoadDistrict();
            LoadSubDistrict();
            LoadZip();
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
            if(addresspicklist!=null)
                AddressObj.Address_Type__c = addresspicklist;
            if(provincepicklist!=null)
                AddressObj.Province__c = provincepicklist;
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
                    if(((market == 'KR') || (market == 'TH')) && addressobj.Province__c == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.')); 
                        Validation = true;
                    }
                    if((market == 'TH') &&addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5}$',addressobj.ZipCode__c))){       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP CODE should be minimum 5 digits and ONLY Numbers.'));
                        Validation = true;
                    }  
          if(Address_Validated_Flag == true && Validation == False)
          {
            refreshPage= true;
            addressObj.Id = null;
            //Thailand market not to have address valdation button
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
                    if((market == 'KR' || market == 'TH')  && addressobj.Province__c == null)
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
    
    
    /**    
        * @Description : creates and validate new address record  
        * @author      : Mohammed Touseef Ahmed
        * @Date        : 02/8/2017    
    **/ 
    
    public void SaveAddressTH()
    {
        try
        {
            Validation=false;
            if(province!='' && province!='--Select--')
                addressobj.Province__c=province;
            if(district!='' && district!='--Select--')
                addressobj.District__c=district;
            if(subdistrict!='' && subdistrict!='--Select--')
                addressobj.Sub_District__c=subdistrict;
            if(zip!='' && zip!='--Select--')
                addressobj.ZipCode__c=zip;
            if(addresspicklist!=null)
                addressobj.Address_Type__c = addresspicklist;   
            string accountid=ApexPages.currentPage().getParameters().get('id');
            List<address__c> objAddresses=[select id,preferred__c from address__c where Customer__c=:accountid and preferred__c=true];
             
            for(address__c add:objAddresses)
            {               
                if(add.id!=addressobj.id && addressobj.preferred__c==true) 
                {                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There must be only one Preferred address.')); 
                    Validation = true;  
                }               
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
            else
            {            
                if(addressobj.Address_Line_1__c.length()>100)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address Line 1 should be less than or equal to 100 characters.'));
                    Validation = true;                      
                }
            }
            if(addressobj.Province__c == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Province __c is Mandatory.'));  
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
            if(addressobj.Address_Line_2__c == null )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address_Line_2__c is Mandatory.')); 
                Validation = TRUE;                        
            }
            else
            {            
                if(addressobj.Address_Line_2__c.length()>100)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Address Line 2 should be less than or equal to 100 characters.'));
                    Validation = true;                      
                }
            }
            if(Validation == False){        
                refreshPage = true; 
                Account acc =[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];
                if (editaddressId ==null)
                {           
                    
                    addressobj.Customer__c = acc.id;  
                    addressobj.Language__c =LanguageSelected;
                    insert addressobj;
                }
                else
                {
                    addressobj.id = editaddressId;
                    addressobj.Customer__c = acc.id;
                    addressobj.Language__c =LanguageSelected;
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
                    
                     if(ValidStr.contains('Address_Line_1_Native__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_1_Native__c= response.Addresses[i].Address_Line_1_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_1_Native__c' + AddressObjtemp.Address_Line_1_Native__c);
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
                    
                     if(ValidStr.contains('Address_Line_2_Native__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_2_Native__c= response.Addresses[i].Address_Line_2_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Address_Line_2_Native__c' + AddressObjtemp.Address_Line_2_Native__c);
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
                    
                    if(ValidStr.contains('Block_Native__c') && Market == 'JP')
                    {
                      addressobj.Block_Native__c= response.Addresses[i].Block_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Block_Native__c' + addressobj.Block_Native__c);
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
                    
                    if(ValidStr.contains('City_Native__c') && Market == 'JP')
                    {
                      addressobj.City_Native__c= response.Addresses[i].City_Native;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        system.debug(' *$*$*$* Res AddressObjtemp.City_Native__c' + addressobj.City_Native__c);
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
                    
                       if(ValidStr.contains('District_Native__c') && Market == 'JP')
                    {
                      addressobj.District_Native__c= response.Addresses[i].District_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.District_Native__c' + addressobj.District_Native__c);
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
                    
                     if(ValidStr.contains('Province_Native__c') && Market == 'JP')
                    {
                      addressobj.Province_Native__c= response.Addresses[i].Province_Native;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province_Native__c' + addressobj.Province_Native__c);
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
** Modified by : Rakesh Babu
** Date : 2017-3-30
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