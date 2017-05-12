public class createRetailCopyKR {
    public Account account{get;set;}
    public Account abc {get;set;}
    public Id addId{get;set;}
    public List<Address__c> sample {set;get;}
    public List<Address__c> ress   {set;get;}
    public List<Address__c> sample1{set;get;}
    public List<Account> accc {set;get;}
    public User  CurrentUsr{set;get;}
         
    public createRetailCopyKR(ApexPages.StandardController controller){
    if(Test.isRunningTest()){
    CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id =: UserInfo.getUserId()];
    }else{
        CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id =: UserInfo.getUserId() and Market__c = 'KR'];
        }
        account = (Account)controller.getRecord();
        sample = [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,
                  Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,
                  Temp_ZipCode__c ,Temp_Address__c,City__c,Preferred__c  FROM  Address__c where  Customer__c =: account.Id];
        system.debug('+++++++++'+sample );
    }
   
    public pageReference getSelected(){ 
        addId = ApexPages.currentPage().getParameters().get('idselected');  
        system.debug('+++++++++'+ addId );
        addId = System.currentPageReference().getParameters().get('Status');
        return null;
    }
      
    public void  getAccount()
    { 
        if(CurrentUsr!= null && account.Main_Dealer__c != null)
        {
            accc = [Select id,name,( Select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,
                    Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,City__c ,Preferred__c,
                    Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c from Addresses__r LIMIT 1) from Account where id =: account.Main_Dealer__c and MD__c =: CurrentUsr.Market__c];
            system.debug('accc $$$ :'+accc); 
        }
    }
    
    public PageReference Save(){
        ID RDType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(); 
        List<Address__c> button = New List<Address__c>();
        List<Account_Link__c> acclink = New List<Account_Link__c>();
        List<Account_Link__c> Accountlinklist = [select id, fromRole__c, toRole__c from Account_Link__c WHERE fromRole__c =: account.Id AND RecordTypeID =: RDType];
        Account_Link__c newals; 
        if(Accountlinklist.isEmpty()){
            newals = new Account_Link__c(fromRole__c = account.Id,toRole__c = account.Company__c,Retail_DMS_Customer_ID__c = 'TEST',RecordTypeId = RDType);
            insert newals;
        }      
        else if(!Accountlinklist.isEmpty()){
           for(Account_Link__c accountLink : Accountlinklist){
               accountLink = new Account_Link__c(fromRole__c = account.Id,toRole__c =  account.Company__c);
               acclink.add(accountLink);
           }
           update acclink;
        }
        system.debug('newals $$$ :'+newals);
        sample1 = [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,
                   Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,
                   Temp_ZipCode__c,City__c ,Preferred__c,Temp_Address__c  FROM  Address__c where id =:addId  Limit 1];
        System.debug('sample1 $$$ :'+sample1);
        
        for(Account abc : accc){
            for(Address__c ress : abc.Addresses__r){
                for(Address__c cdf : sample1){
                    if(ress.Address_Type__c != cdf.Address_Type__c){
                        ress.Address_Type__c = cdf.Address_Type__c ;
                    }
                    ress = new Address__c (ZipCode__c = cdf.ZipCode__c,Province__c=cdf.Province__c,Province_Native__c=cdf.Province_Native__c,City_Native__c=cdf.City_Native__c,District__c=cdf.District__c,District_Native__c=cdf.District_Native__c,Block__c=cdf.Block__c,Block_Native__c=cdf.Block_Native__c,Address_Line_1__c=cdf.Address_Line_1__c,Address_Line_1_Native__c=cdf.Address_Line_1_Native__c,Address_Line_2__c=cdf.Address_Line_2__c,Address_Line_2_Native__c=cdf.Address_Line_2_Native__c,Company_Name__c=cdf.Company_Name__c,Company_Name_Native__c=cdf.Company_Name_Native__c,TitleOfHonor__c =cdf.TitleOfHonor__c,Status__c =cdf.Status__c,Temp_ZipCode__c =cdf.Temp_ZipCode__c,Temp_Address__c =cdf.Temp_Address__c,Customer__c = abc.Id,City__c = cdf.City__c,Preferred__c= cdf.Preferred__c);                    
                    button.add(ress);
                }
            }
        }
        if(button.size() > 0){
            update button;
        }
       
      
        list<Account> accList = [SELECT Primary_Address_Reference__c,(select id from Addresses__r ORDER BY LastModifiedDate desc limit 1)FROM Account where Id =: account.Company__c]; 
        List<Account> listAccount = new List<Account>();
        for(Account aont : accList){
            for(Address__c aress : aont.Addresses__r){
                aont.Primary_Address_Reference__c = aress.id;
                listAccount.add(aont);
            }
        }
        string recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        PageReference page = new PageReference('/'+account.id);
        return page;
    }
    
    public PageReference Cancel(){
        PageReference page = new PageReference('/'+account.Id);
        page.setRedirect(true);
        return page;
    } 
}
