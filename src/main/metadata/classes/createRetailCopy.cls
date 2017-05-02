public without sharing class createRetailCopy {

    public  Account account{get;set;}
    public  Account accList{get;set;}
    Public static String AccId{get;set;}
    public List<Address__c> ListAddress{set;get;}
    public List<Address__c> SelectedAdd{set;get;}
    public Id addId{get;set;} 
    public Id did{get;set;} 
    public  Boolean ShowHideError{set;get;}
    public List<Account_Link__c> Accountlinklist{get;set;}
    Public User  Usr{get;set;} 
    public List<Account> accc{set;get;}
    Public  Id DealeAccId{get;set;}
    public List<Contact> contactList{ get; set; }  
    public Account_Link__c newAlk;
    public List<Account_Link__c> InsertAlk; 
    public Account DealerID { get; set; }
    public User  CurrentUsr{set;get;}
    public List<Account> Dealeracc{set;get;}
    public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public String MarketDiscriminator;
    // Constructor
    public createRetailCopy(ApexPages.StandardController controller) {
     AccId=ApexPages.currentPage().getParameters().get('id');
     ListAddress=new List<Address__c>();
     SelectedAdd=new List<Address__c>();
     InsertAlk=new List<Account_Link__c> ();
     account=new Account();
     ShowHideError=false; 
     
     CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
     account = (Account)controller.getRecord();
     if(AccId!=null)
     {
      ListAddress= [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City__c,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where  Customer__c =:AccId];
     }
    
     system.debug('+++++++++++++'+account);
     system.debug('++++++++++++++'+AccId);
    MarketDiscriminator = 'JP';
    if(CurrentUsr.Market__c== 'KR'){
        MarketDiscriminator = CurrentUsr.Market__c; 
    }       

    } // Constructor  end
    
    
    //Method to selected Address  record Id
      public pageReference getSelectedAddress (){ 
    
           addId =ApexPages.currentPage().getParameters().get('idselected');  
           
           system.debug('+++++++++'+ addId );
         
    
      return null;
      
    }
    
  //Method to get selected dealer ID
      public void  getDealer(){
          Dealeracc=new List<Account>();
          AccId=ApexPages.currentPage().getParameters().get('id'); 
          // DealerID=ApexPages.currentPage().getParameters().get('DealerID');  
           accc=[Select id from account where id=:account.Main_Dealer__c and MD__c =: MarketDiscriminator];  
           System.debug('^&^&^&^&^&^&^&^ accc'+accc);
            System.debug('^&^&^&^&^&^&^&^ AccId '+AccId);
           System.debug('^&^&^ DealerID.Main_Dealer__c '+account.Main_Dealer__c);
      } //Method end
      
      
      // Method to Create retail copy
    Public void CreateRetailCopy()
    { 
     
    AccId=ApexPages.currentPage().getParameters().get('id');
    
   accList=[Select Id,Main_Dealer__c ,RecordtypeId from account where id=:AccId];
   accc=[Select id,Main_Dealer__c  from account where id=:account.Main_Dealer__c limit 1];
    system.debug('+++++++++'+ addId );
    System.debug('##################'+accc); 
    System.debug('#################'+ AccId);
    if(addId !=null)
    {
    SelectedAdd= [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where id =:addId Limit 1];
    }
    CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
 
 
  // For Dealer User Creating retail copy
    if(CurrentUsr.ContactId!=null)
    {
     Usr = [SELECT Market__c,contactid,IsPortalEnabled,Id,contact.AccountId FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
    
    
     if(Usr.ContactId!=null)
     {
     contactList=[Select id,AccountId from Contact where id=:usr.ContactId];
     
            If(contactList!=null)
              {
              for(Contact con:contactList)
              {
              DealeAccId=con.AccountId;
              }
              }
    if(accList.RecordtypeId == accPerson_RecordTypeId)
    {
    Accountlinklist = [select id, fromRole__c, toRole__c,Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c=:DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false];
    }
     if(accList.RecordtypeId == accCompany_RecordTypeId)
    {
    Accountlinklist = [select id, fromRole__c, toRole__c,Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c=:DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false];
    }
    
    
     if(Accountlinklist ==null ||  Accountlinklist.isempty())
    {
    
     if(accList.RecordtypeId == accPerson_RecordTypeId)
    {     
     
    newAlk=new Account_Link__c ();
    newAlk.toRole__c = AccId;
    newAlk.Retail_Address_Reference__c=addId;
    newAlk.fromRole__c=DealeAccId;
    newAlk.RecordTypeId=alkPerson_RecordTypeId;
    InsertAlk.add(newAlk);
     
    }
    if(accList.RecordtypeId == accCompany_RecordTypeId)
    {     
     
     
    newAlk=new Account_Link__c ();
    newAlk.toRole__c = AccId;
    newAlk.Retail_Address_Reference__c=addId;
    newAlk.fromRole__c=DealeAccId;
    newAlk.RecordTypeId=alkCompany_RecordTypeId;
    InsertAlk.add(newAlk);
    System.debug('newAlk newAlk%%%%%%%'+newAlk);
     
    }
    } else if(Accountlinklist !=null)
    {
    ShowHideError=true;  
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Retail copy is already present'));
    }
   
    
    }
    }
    
    
    // For MBJ User Creating retail copy
    if(CurrentUsr.ContactId==null)
    { 
    //For MBJ User if user not selected  Dealer Outlet display error message
            if(account.Main_Dealer__c  ==null && account.Main_Dealer__c ==null)
            {    
              ShowHideError=true;                  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Dealer'));
            }
            System.debug('CurrentUsr %%%%%%%'+CurrentUsr);
    if(accList.RecordtypeId == accPerson_RecordTypeId)
    {
    Accountlinklist = [select id, fromRole__c, toRole__c,Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c=:account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false];
    }
     if(accList.RecordtypeId == accCompany_RecordTypeId)
    {
    Accountlinklist = [select id, fromRole__c, toRole__c,Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c=:account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false];
    }
    
   System.debug('#$#$#$####$'+account.Main_Dealer__c);
   
         
    if(Accountlinklist ==null ||  Accountlinklist.isempty() && account.Main_Dealer__c  !=null)
    {
    
     if(accList.RecordtypeId == accPerson_RecordTypeId)
    {     
     
    newAlk=new Account_Link__c ();
    newAlk.toRole__c = AccId;
    newAlk.Retail_Address_Reference__c=addId;
    newAlk.fromRole__c=account.Main_Dealer__c;
    newAlk.RecordTypeId=alkPerson_RecordTypeId;
    InsertAlk.add(newAlk);
     
    }
    if(accList.RecordtypeId == accCompany_RecordTypeId)
    {     
     
     
    newAlk=new Account_Link__c ();
    newAlk.toRole__c = AccId;
    newAlk.Retail_Address_Reference__c=addId;
    newAlk.fromRole__c=account.Main_Dealer__c;
    newAlk.RecordTypeId=alkCompany_RecordTypeId;
    InsertAlk.add(newAlk);
    System.debug('newAlk newAlk%%%%%%%'+newAlk);
     
    }
    } else if(Accountlinklist !=null && account.Main_Dealer__c !=null )
    {
     ShowHideError=true;  
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Retail copy is already present'));
    }
    
    }  
    if(InsertAlk!=null && InsertAlk.size()>0)
    {
    insert InsertAlk;
    }
    
    }

}