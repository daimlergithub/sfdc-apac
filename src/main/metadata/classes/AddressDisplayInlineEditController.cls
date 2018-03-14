public class AddressDisplayInlineEditController { 
    public boolean openPanal{get;set;}
    public List<Address__c> adds {get; set;}
    public Address__c addressobj {get; set;}
    public Boolean ShowpageBlockFlag {get;set;}
    public Boolean refreshPage{get;set;}
    private ApexPages.StandardController stdController;  
    public RegionMasterInfo__c region {get;set;}    
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
  public Boolean AutoFill {get;set;}
    public Boolean DisplayAutoFill {get;set;}
    public User u = [SELECT Id,Market__c,Profile.Name,contactId FROM User WHERE Id=:UserInfo.getUserId()] ;
    public AddressDisplayInlineEditController(ApexPages.StandardController stdController){
        this.stdController = stdController;  
    AutoFill = false;     
        aid = ApexPages.currentPage().getParameters().get('id');
        Address_Validated_Flag = false;
        IsForeignNational=false;
        if(ApexPages.currentPage().getParameters().get('id')!=Null){   
        //SN20170911 -- Added address Line 3 in the query           
            adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,Country__c,Sub_District__c,Language__c,Foreign_Nationals__c,
                    Address_Line_2__c , Address_Line_3__c ,Address_Line_1__c,District__c,HouseNumber__c,City__c, Block__c, TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,        
                    Address_Line_1_Native__c,Address_Line_2_Native__c from Address__c where Customer__c =: aid Limit 10];        
           
        }                     
        /*Intitializing address object*/
        addressobj = new Address__c();
        
        market = u.Market__c;
        AddressObj.Market__c=market; 
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
         if(LanguageSelected=='' || LanguageSelected ==null )       
              LanguageSelected ='English';     
        lstProvince=new List<SelectOption>();
        Set<string> setProvinces = new set<string>();
        lstProvince.add(new SelectOption(System.Label.SelectPicklist,System.Label.SelectPicklist));
        for(RegionMasterInfo__c lsttempProvince : [select id,Province__c from RegionMasterInfo__c where Language__c=:LanguageSelected  and Market__c=:market order by Province__c asc])
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
         if(LanguageSelected=='' || LanguageSelected ==null )       
              LanguageSelected ='English';   
        lstDistrict=new List<SelectOption>();
        Set<string> setDistricts = new set<string>();
        lstDistrict.add(new SelectOption(System.Label.SelectPicklist,System.Label.SelectPicklist));        
        for(RegionMasterInfo__c lsttempDistrict : [select id,District__c from RegionMasterInfo__c where Language__c=:LanguageSelected and Province__c=:province  and Market__c=:market order by District__c asc])
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
        lstSubDistrict=new List<SelectOption>();
        lstZip=new List<SelectOption>();
      }
      
      public void LoadSubDistrict()
      {
        lstSubDistrict=new List<SelectOption>();
        Set<string> setSubDistricts = new set<string>();
        lstSubDistrict.add(new SelectOption(System.Label.SelectPicklist,System.Label.SelectPicklist));
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
        lstZip.add(new SelectOption(System.Label.SelectPicklist,System.Label.SelectPicklist));
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
                province=System.Label.SelectPicklist;
                district=System.Label.SelectPicklist;

            }
        }
        else if(market == System.Label.IN)
        {
            //03142018 Namitha : Added for Foreign national checkbox functionality for India market.
            if(AddressObj.Country__c != 'India'){
                IsForeignNational=true;
                province='';
                district='';
                }
            else
                IsForeignNational=false;
        }
      }
      
    public void updateHidefields(){
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
              
            }
            else{
                IsForeignNational=false;
               
            }
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
            //SN20170911 -- Added address Line 3 in the query 
        adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,
                Address_Line_2__c ,Address_Line_3__c,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,       
                Address_Line_2_Native__c,Foreign_Nationals__c,Language__c,Country__c,Sub_District__c  from Address__c where Customer__c =: aid];
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
    //SN20170911 -- Added address Line 3 in the query 
        Account acc=[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];
        adds= [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,Sub_District__c,
               Address_Line_2__c ,Address_Line_3__c,Address_Line_1__c,District__c,City__c,Language__c,Country__c, Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c,Foreign_Nationals__c from Address__c where Customer__c=:acc.id Limit 10];
        if(adds.size()>=5){
            ShowpageBlockFlag=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,system.label.Account_cannot_have_more_than_5_Address));
        }
        else 
            ShowpageBlockFlag = true;
            if(Market==label.MY)
            {
                addressobj.Country__c=Label.MYCountry;
                LoadProvince();
            }
            // 03052018 Namitha addedd IN condition to predefault country to India
            if(Market==label.IN)
            {
                addressobj.Country__c='India';
                LoadProvince();
                LoadDistrict();
            }
            
            
    }
    
    
    /**    
        * @Description : Edit the address record  
        * @author      : Sudhir
        * @Date        : 11/12/2015    
    **/  
    public void EditOptions(){
        Address__c editadds;
        //SN20170911 -- Added address Line 3 in the query 
        if (editaddressId != null){
            editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,HouseNumber__c,
                        Address_Line_2__c,Market__c ,Address_Line_3__c,Address_Line_1__c,District__c,City__c, Country__c,Block__c,TitleOfHonor__c,Company_Name_Native__c,Temp_ZipCode__c,Temp_Address__c,LastModifiedDate,Block_Native__c,City_Native__c,Province_Native__c,District_Native__c,Address_Line_1_Native__c,Address_Line_2_Native__c,Sub_District__c,Language__c,Foreign_Nationals__c from Address__c where Id =: editaddressId Limit 10];
            // if for any reason we are missing the reference           
        }
        
        // find the address record within the collection
        If(editadds!=null)
        {                     
            addressobj.id=editadds.id;
      addressobj.Market__c=editadds.Market__c;
            addressobj.Address_Type__c = editadds.Address_Type__c;
            addresspicklist=editadds.Address_Type__c;
            
            addressobj.ZipCode__c = editadds.ZipCode__c;
            addressobj.Province__c = editadds.Province__c;
            provincepicklist = editadds.Province__c;
            addressobj.City__c = editadds.City__c;
            addressobj.District__c =editadds.District__c;
            addressobj.Block__c =editadds.Block__c;
            addressobj.Address_Line_1__c =editadds.Address_Line_1__c;
            addressobj.Address_Line_2__c =editadds.Address_Line_2__c;
            //SN20170911 -- Added address Line 3 in the query 
            addressobj.Address_Line_3__c =editadds.Address_Line_3__c;
            addressobj.Company_Name__c =editadds.Company_Name__c;
            addressobj.Company_Name_Native__c = editadds.Company_Name_Native__c;
            addressobj.TitleOfHonor__c =editadds.TitleOfHonor__c;
            addressobj.Status__c =editadds.Status__c;
            addressobj.Preferred__c = editadds.Preferred__c;
            addressobj.Temp_ZipCode__c = editadds.Temp_ZipCode__c ;
            addressobj.Temp_Address__c = editadds.Temp_Address__c ;
            addressobj.Block_Native__c = editadds.Block_Native__c;
            // Added by Rakesh CISM # 0039983804 
            if(u.profile.name != 'Japan Marketing'){
                addressobj.City_Native__c = editadds.City_Native__c;
            }
            // end        
            addressobj.Province_Native__c = editadds.Province_Native__c;        
            addressobj.District_Native__c = editadds.District_Native__c;        
            addressobj.Address_Line_1_Native__c = editadds.Address_Line_1_Native__c;        
            addressobj.Address_Line_2_Native__c = editadds.Address_Line_2_Native__c;
            addressobj.Country__c=editadds.Country__c;
            addressobj.Foreign_Nationals__c=editadds.Foreign_Nationals__c;
            zip=editadds.ZipCode__c;
            province=editadds.Province__c;
            district=editadds.District__c;
            subdistrict=editadds.Sub_District__c;
             LanguageSelected=editadds.Language__c;
            
            LoadProvince();
            LoadDistrict();
          
            if(market=='TH' || Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric))
             { 
                 if(LanguageSelected=='' || LanguageSelected==null)
                {
                   
                    if(market=='TH')
                       region=  [select id,Province__c,Language__c from RegionMasterInfo__c where Province__c=:province Limit 1];
                    else  if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric))
                       region=  [select id,Province__c,Language__c from RegionMasterInfo__c where Province__c=:province Limit 1];
                    else
                        LanguageSelected='English';
                       
                   if(region!=null)
                   {
                       if(region.Language__c!='' || region.Language__c!=null)
                           LanguageSelected=region.Language__c;
                   }
                }
                // ShowHideFields();
                updateHidefields();
                LoadProvince();
                LoadDistrict();
                if(market=='TH')                         
                    {                        
                    LoadSubDistrict();      
                    LoadZip();      
                    }
            }
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
                AddressObj.Province__c = addressObj.Province__c;
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
            DMLManagerService.insertAsSystem(addressobj); 
            
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
                            DMLManagerService.updateAsSystem(addressobj);
                            
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
            if(province!='' && province!=System.Label.SelectPicklist)
                addressobj.Province__c=province;
            if(district!='' && district!=System.Label.SelectPicklist)
                addressobj.District__c=district;
            if(subdistrict!='' && subdistrict!=System.Label.SelectPicklist)
                addressobj.Sub_District__c=subdistrict;
            if(zip!='' && zip!=System.Label.SelectPicklist)
                addressobj.ZipCode__c=zip;
            if(addresspicklist!=null)
                addressobj.Address_Type__c = addresspicklist;   
            string accountid=ApexPages.currentPage().getParameters().get('id');
            List<address__c> objAddresses=[select id,preferred__c from address__c where Customer__c=:accountid and preferred__c=true LIMIT 100];
            
      //commented by Tej on 12-6-2017 to implement new preferred logic
            /*for(address__c add:objAddresses)
            {               
                if(add.id!=addressobj.id && addressobj.preferred__c==true) 
                {                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There must be only one Preferred address.')); 
                    Validation = true;  
                }               
            }*/
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
                List<Address__c> addressLst=new List<Address__c>();
                Account acc =[select id,name,Primary_Address_Reference__c from Account where id=:ApexPages.currentPage().getParameters().get('id')];
                Account acc1 =new Account(Id=acc.Id);
                if (editaddressId ==null)
                {           
                    
                    addressobj.Customer__c = acc.id;  
                    addressobj.Language__c =LanguageSelected;
                    
                    DMLManagerService.insertAsSystem(addressobj);
                    
                }
                else
                {
                    addressobj.id = editaddressId;
                    addressobj.Customer__c = acc.id;
                    addressobj.Language__c =LanguageSelected;
                    DMLManagerService.updateAsSystem(addressobj);
                   
                }
                //if one of the preferred check box is checked, then uncheck other preferred check box
                if(adds!=null && adds.size()>0)
                {
                    if(addressobj.Preferred__c)
                    {
                        for(Address__c addressObj1:adds)
                        {
                            if(addressObj1.Id!=addressobj.Id)
                            {
                                addressObj1.Preferred__c=false;
                              addressLst.add(addressObj1);
                            }
                            
                        }
                        
                    }
                    if(addressLst!=null && addressLst.size()>0)
                       DMLManagerService.updateAsSystem(addressLst);
                }
                //update sales address field in account if preferred checkbox is checked
                if(addressobj.Preferred__c)
                {
                    acc1.Primary_Address_Reference__c=addressobj.Id;
                    DMLManagerService.updateAsSystem(acc1);
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
    
     /**            
        * @Description : creates and validate new address record        
        * @author      : Mohammed Touseef Ahmed     MT20170913
        * @Date        : 02/9/2017       
            
    **/         
            
    public void SaveAddressMY()     
    {       
        try     
        {       
            Validation=false;   
      boolean countPre=false;
      if(province!='' && province!=System.Label.SelectPicklist)      
                addressobj.Province__c=province;        
            if(district!='' && district!=System.Label.SelectPicklist)      
                addressobj.District__c=district;        
            if(zip!=null || zip!='')        
                addressobj.ZipCode__c=zip;      
            if(addresspicklist!=null)       
                addressobj.Address_Type__c = addresspicklist;           
            string accountid=ApexPages.currentPage().getParameters().get('id');     
            List<address__c> objAddresses=[select id,preferred__c,Address_Type__c from address__c where Customer__c=:accountid LIMIT 100];        
             
      if(addressobj.preferred__c == true) countPre=true;
        
            for(address__c add:objAddresses)        
            {                       
                if(add.id!=addressobj.id && add.preferred__c==true && countPre==true)      
                {                       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.OnePreferredError));         
                    Validation = true;          
                }  
                
                if(add.id!=addressobj.id && addressobj.Address_Type__c==add.Address_Type__c)      
                {                       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.AddressTypeError));         
                    Validation = true;          
                }                       
            } 
      
            if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{5,6}$',addressobj.ZipCode__c)))      
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MYZipCode));        
                 Validation = true;                             
            }       
            if(addressobj.Address_Line_1__c == null)        
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Addressline1Mandatory));       
                Validation = true;                              
            }       
            else        
            {                   
                if(addressobj.Address_Line_1__c.length()>100)       
                {       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MYAddressline1Length));        
                    Validation = true;                              
                }       
            }       
            if(addressobj.Province__c == null)      
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.StateProvError));        
            }       
            if(addressobj.District__c == null )     
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CityError));         
                Validation = TRUE;                              
            }       
                    
            if(addressobj.Address_Line_2__c == null )       
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Addressline2));       
                Validation = TRUE;                              
            }       
            else        
            {                   
                if(addressobj.Address_Line_2__c.length()>100)       
                {       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.MYAddresslinelen2Length));        
                    Validation = true;                              
                }       
            }       
                    
                  
            if(Validation == False){                
                refreshPage = true;         
                Account acc =[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];     
                if (editaddressId ==null)       
                {                   
                            
                    addressobj.Customer__c = acc.id;   
                    DMLManagerService.insertAsSystem(addressobj);     
                         
                }       
                else        
                {       
                    addressobj.id = editaddressId;      
                    addressobj.Customer__c = acc.id; 
                    DMLManagerService.updateAsSystem(addressobj);       
                     
                }       
            }       
        }       
        catch (Exception e)      
        {       
            refreshPage = false;        
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));                           
            CustomLogUtil.CustomLoggingEntry(' AccountHelper th Exception Occurred '+e+'-'+e.getlinenumber());       
        }
        
    }   
    /**  * @Description : creates and validate new address record  for India Market      
        * @author      : namitha
        * @Date        : 03/01/2018    
        
        **/
    
    public void SaveAddressIN()     
    {       
        try     
        {       
            Validation=false;   
      boolean countPre=false;
      if(province!='' && province!=System.Label.SelectPicklist)      
                addressobj.Province__c=province;        
            if(district!='' && district!=System.Label.SelectPicklist)      
                addressobj.District__c=district;        
            if(zip!=null || zip!='')        
                addressobj.ZipCode__c=zip;      
            if(addresspicklist!=null)       
                addressobj.Address_Type__c = addresspicklist;           
            string accountid=ApexPages.currentPage().getParameters().get('id');     
            List<address__c> objAddresses=[select id,preferred__c,Address_Type__c from address__c where Customer__c=:accountid LIMIT 100];        
             
      if(addressobj.preferred__c == true) countPre=true;
        
            for(address__c add:objAddresses)        
            {                       
                if(add.id!=addressobj.id && add.preferred__c==true && countPre==true)      
                {                       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.OnePreferredError));         
                    Validation = true;          
                }  
                
                if(add.id!=addressobj.id && addressobj.Address_Type__c==add.Address_Type__c)      
                {                       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.AddressTypeError));         
                    Validation = true;          
                }                       
            } 
            
            if(addressobj.ZipCode__c != null  && (!Pattern.matches('^[0-9]{6}$',addressobj.ZipCode__c)))      
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Postal_Code_validation));        
                 Validation = true;                             
            }       
            if(addressobj.Address_Line_1__c == null)        
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Address_Line_1_validation));       
                Validation = true;                              
            }       
            else        
            {                   
                if(addressobj.Address_Line_1__c.length()>100)       
                {       
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Address_Line_1_Length_validation));        
                    Validation = true;                              
                }       
            }       
            if(addressobj.Province__c == null)      
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_State_validation));        
            }       
            if(addressobj.District__c == null )     
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_City_Vaidation));         
                Validation = TRUE;                              
            }       
                    
                            
            if(addressobj.Address_Line_2__c != null && addressobj.Address_Line_2__c.length()>100)       
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Address_Line_2_Length_validation));        
                Validation = true;                              
            }   
            
            if(addressobj.Address_Line_3__c != null && addressobj.Address_Line_3__c.length()>100)       
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Address_Line_3_Length));        
                Validation = true;                              

            }     
            
            if(addressobj.Foreign_Nationals__c == true && addressobj.Country__c == 'India')       
            {       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.IN_Foreign_Nationals));        
                Validation = true;                              
            } 
               
            if(Validation == False){                
                refreshPage = true;         
                Account acc =[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];     
                if (editaddressId ==null)       
                {                   
                            
                    addressobj.Customer__c = acc.id;   
                    DMLManagerService.insertAsSystem(addressobj);     
                         
                }       
                else        
                {       
                    addressobj.id = editaddressId;      
                    addressobj.Customer__c = acc.id; 
                    DMLManagerService.updateAsSystem(addressobj);       
                     
                }       
            }       
        }       
        catch (Exception e)      
        {       
            refreshPage = false;        
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));                           
            CustomLogUtil.CustomLoggingEntry(' AccountHelper th Exception Occurred '+e+'-'+e.getlinenumber());       
        }
        
    }
    
    //end of SaveAddressIN

    /**  Address Search based on Zip code.
        Sends zip code to EP/Tolerant and fetches the matched address details and populates on Screen. 
        **  Created By: Sudhir  
        **  Date: 2016-1-19
        **/
    public void AddressSearch()
    {
        if(addressobj.ZipCode__c == null  || (!Pattern.matches('^[0-9]{7}$',addressobj.ZipCode__c)))
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
            response =  UtilWebservice.validateAddressByZipCode(addressobj,false);
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
  
  public void AutoFillAddress(){
        AutoFill = true;
        
        DisplayAutoFill = true;
        ValidateAddressSearch();
        
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
        response =  UtilWebservice.validateAddressByZipCode(addressobj,Autofill);
         if(response != null && response.Addresses!=null && response.AutoFillMode!=null && response.AutoFillMode && AutoFill){
             for(Integer i=0;i<response.Addresses.size() && response.Addresses[i]!=null;i++){                
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
                if(response.Addresses[i].ValidFields != null &&  response.Addresses[i].ValidFields != '' && response.Addresses[i].Valid ){
                    String ValidStr = response.Addresses[i].ValidFields;
                    
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(AddressObjtemp.Province__c)){
                        province = addtrmapUpdate.get(AddressObjtemp.Province__c);
                    }
                    if(ValidStr.contains('Address_Line_1__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                       
                    }
                    else if(ValidStr.contains('Address_Line_1__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_1__c = response.Addresses[i].Address_Line_1;
                        
                    }
                    
                     if(ValidStr.contains('Address_Line_1_Native__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_1_Native__c= response.Addresses[i].Address_Line_1_Native;
                        
                    }
                    
                    if(ValidStr.contains('Address_Line_2__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        
                    }
                    else if(ValidStr.contains('Address_Line_2__c') && Market == 'KR')
                    {
                        AddressObjtemp.Address_Line_2__c = response.Addresses[i].Address_Line_2;
                        
                    }
                    
                     if(ValidStr.contains('Address_Line_2_Native__c') && Market == 'JP')
                    {
                      addressobj.Address_Line_2_Native__c= response.Addresses[i].Address_Line_2_Native;
                        
                    }
                    
                    if(ValidStr.contains('Block__c') && Market == 'JP')
                    {
                      addressobj.Block__c = response.Addresses[i].Block;
                        
                    }
                    else if(ValidStr.contains('Block__c') && Market == 'KR')
                    {
                        AddressObjtemp.Block__c = response.Addresses[i].Block;
                        
                    }
                    
                    if(ValidStr.contains('Block_Native__c') && Market == 'JP')
                    {
                      addressobj.Block_Native__c= response.Addresses[i].Block_Native;
                        
                    }
                    
                    
                    if(ValidStr.contains('City__c') && Market == 'JP')
                    {
                      addressobj.City__c = response.Addresses[i].City;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        
                    }
                    else if(ValidStr.contains('City__c') && Market == 'KR')
                    {
                        AddressObjtemp.City__c = response.Addresses[i].City;
                        
                    }
                    
                    if(ValidStr.contains('City_Native__c') && Market == 'JP')
                    {
                      addressobj.City_Native__c= response.Addresses[i].City_Native;
                        //AddressObjtemp.City__c = response.Addresses[i].City;
                        
                    }
                    
                    
                    if(ValidStr.contains('District__c') && Market == 'JP')
                    {
                      addressobj.District__c = response.Addresses[i].District;
                        
                    }
                    else if(ValidStr.contains('District__c') && Market == 'KR')
                    {
                        AddressObjtemp.District__c = response.Addresses[i].District;
                        
                    }
                    
                       if(ValidStr.contains('District_Native__c') && Market == 'JP')
                    {
                      addressobj.District_Native__c= response.Addresses[i].District_Native;
                        
                    }
                    
                    
                    if(ValidStr.contains('Province__c') && Market == 'JP')
                    {
                      addressobj.Province__c = response.Addresses[i].Province;
                        
                    }
                    else if(ValidStr.contains('Province__c') && Market == 'KR')
                    {
                        AddressObjtemp.Province__c = response.Addresses[i].Province;
                        system.debug(' *$*$*$* Res AddressObjtemp.Province__c   ' + AddressObjtemp.Province__c);
                    }
                    
                     if(ValidStr.contains('Province_Native__c') && Market == 'JP')
                    {
                      addressobj.Province_Native__c= response.Addresses[i].Province_Native;
                        
                    }
                    
                    if(market != 'JP')
                    {
                    
                    mapAddressResponse.add(new addressSelectionWrapper(AddressObjtemp)); 
                    }
                }
                else if(!response.Addresses[i].Valid){
                    string province;   
                    Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
                    system.debug(Market + '   *$*$*$*  addtrmapUpdate ' + addtrmapUpdate);
                    UtilAddressTranslation.gettranslatedvalues(Market);
                    if(addtrmapUpdate.containsKey(addressobj.Province__c)){
                        province = addtrmapUpdate.get(addressobj.Province__c);
                    }
                    //addressobj.Province__c =  province;
                    addressobj.Temp_ZipCode__c = addressobj.ZipCode__C;
                    addressobj.Temp_Address__c = ((province != null) ? province : '' ) + ((addressobj.City__c != null) ? addressobj.City__c : '' ) +
                        ((addressobj.District__c != null) ? addressobj.District__c : '' ) + ((addressobj.Block__c != null) ? addressobj.Block__c  : '' ) +
                        ((addressobj.Address_Line_1__c != null) ? addressobj.Address_Line_1__c  : '' ) + ((addressobj.Address_Line_2__c != null) ? addressobj.Address_Line_2__c  : '' );
                    /*addressobj.Address_Code__c = '';
                    addressobj.Address_Line_1__c = '';
                    addressobj.Address_Line_2__c = '';
                    addressobj.Block__c = '';
                    addressobj.City__c = '';
                    addressobj.District__c = '';
                    addressobj.Province__c = '';*/
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
        response =  UtilWebservice.validateAddressByZipCode(Address,false);
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
        AddressObj.Block__c= cWrapper.add.Block__c;
                AddressObj.ZipCode__c= cWrapper.add.ZipCode__c; 
                AddressObj.Address_Line_1__c= cWrapper.add.Address_Line_1__c;  
                AddressObj.Address_Line_2__c= cWrapper.add.Address_Line_2__c;  
                AddressObj.Temp_ZipCode__c = '';
                AddressObj.Temp_Address__c = '';            
            }
        }           
    }    
}