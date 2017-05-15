public without sharing class createRetailCopyKR {

    public  Account account{get;set;}
    public  Account accList{get;set;}
    public static String AccId{get;set;}
    public List<Address__c> ListAddress{set;get;}
    public List<Address__c> SelectedAdd{set;get;}
    public Id addId{get;set;} 
    public Id did{get;set;} 
    public  Boolean ShowHideError{set;get;}
    public List<Account_Link__c> Accountlinklist{get;set;}
    public User  Usr{get;set;} 
    public List<Account> accc{set;get;}
    public  Id DealeAccId{get;set;}
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
    public boolean showAddress{get;set;}
    public List<Address__c> addressCheck1 = new List<Address__c>();
    public List<Address__c> addressCheck2 = new List<Address__c>();
    public List<Address__c> displaAddress{set;get;}
    public createRetailCopyKR(ApexPages.StandardController controller) {
         AccId=ApexPages.currentPage().getParameters().get('id');
         ListAddress=new List<Address__c>();
         displaAddress=new List<Address__c>();
         SelectedAdd=new List<Address__c>();
         InsertAlk=new List<Account_Link__c> ();
         account=new Account();
         ShowHideError=false; 
         CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
         account = (Account)controller.getRecord();
         if(AccId!=null){
             ListAddress= [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City__c,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c, Preferred__c  FROM  Address__c where  Customer__c =:AccId];
         }
         
          for(Address__c add: ListAddress){
              if(add.Preferred__c == true){
                  addressCheck1.add(add);
              }else{
                  addressCheck2.add(add);
              }
          }
          
          if(ListAddress.size() == 1){
              showAddress = true;
              displaAddress.add(ListAddress[0]);
          }
          else if(addressCheck1.size()>1 || addressCheck2.size()>1){
              showAddress = false;
          }else if(addressCheck1.size() == 1 && addressCheck2.size() == 1){
              showAddress = true;
              displaAddress.add(ListAddress[0]);
          }
          
          MarketDiscriminator = 'JP';
          if(CurrentUsr.Market__c== 'KR'){
                MarketDiscriminator = CurrentUsr.Market__c; 
          }   
    }
    
    public void  getDealer(){
          Dealeracc=new List<Account>();
          AccId=ApexPages.currentPage().getParameters().get('id'); 
           accc=[Select id from account where id=:account.Main_Dealer__c and MD__c =: MarketDiscriminator];  
    } 
    
     Public void CreateRetailCopy(){
          AccId=ApexPages.currentPage().getParameters().get('id');
          accList=[Select Id,Main_Dealer__c ,RecordtypeId from account where id=:AccId];
          accc=[Select id,Main_Dealer__c  from account where id=:account.Main_Dealer__c limit 1];
          if(displaAddress[0].id != null){
                SelectedAdd= [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where id =:displaAddress[0].id Limit 1];
          }
                CurrentUsr=[SELECT Market__c,DMS_UserID__c,IsPortalEnabled ,contactid,Id FROM User WHERE Id = :UserInfo.getUserId()];
                
                 if (CurrentUsr.ContactId != null) {
     Usr = [SELECT Market__c, contactid, IsPortalEnabled, Id, contact.AccountId FROM User WHERE Id =: UserInfo.getUserId() and User.Profile.UserLicense.Name = 'Partner Community'];


     if (Usr.ContactId != null) {
         contactList = [Select id, AccountId from Contact where id =: usr.ContactId];

         If(contactList != null) {
             for (Contact con: contactList) {
                 DealeAccId = con.AccountId;
             }
         }
         if (accList.RecordtypeId == accPerson_RecordTypeId) {
             Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false];
         }
         if (accList.RecordtypeId == accCompany_RecordTypeId) {
             Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: DealeAccId and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false];
         }


         if (Accountlinklist == null || Accountlinklist.isempty()) {

             if (accList.RecordtypeId == accPerson_RecordTypeId) {

                 newAlk = new Account_Link__c();
                 newAlk.toRole__c = AccId;
                 newAlk.Retail_Address_Reference__c = displaAddress.size()>0 ? displaAddress[0].id:'';
                 newAlk.fromRole__c = DealeAccId;
                 newAlk.RecordTypeId = alkPerson_RecordTypeId;
                 newAlk.Retail_Address_Type__c = displaAddress.size()>0 ? displaAddress[0].Address_Type__c:'';
                 newAlk.Retail_ZipCode__c = displaAddress.size()>0 ? displaAddress[0].ZipCode__c:'';
                 newAlk.Retail_Province__c = displaAddress.size()>0 ? displaAddress[0].Province__c:'';
                 newAlk.Retail_City__c = displaAddress.size()>0 ? displaAddress[0].City__c:'';
                 newAlk.Retail_Distinct__c = displaAddress.size()>0 ? displaAddress[0].District__c:'';
                 newAlk.Retail_Address_Line_1__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_1__c:'';
                 newAlk.Retail_Address_Line_2__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_2__c:'';
                 InsertAlk.add(newAlk);

             }
             if (accList.RecordtypeId == accCompany_RecordTypeId) {


                 newAlk = new Account_Link__c();
                 newAlk.toRole__c = AccId;
                 newAlk.Retail_Address_Reference__c = displaAddress.size()>0 ? displaAddress[0].id:'';
                 newAlk.fromRole__c = DealeAccId;
                 newAlk.RecordTypeId = alkCompany_RecordTypeId;
                 newAlk.Retail_Address_Type__c = displaAddress.size()>0 ? displaAddress[0].Address_Type__c:'';
                 newAlk.Retail_ZipCode__c = displaAddress.size()>0 ? displaAddress[0].ZipCode__c:'';
                 newAlk.Retail_Province__c = displaAddress.size()>0 ? displaAddress[0].Province__c:'';
                 newAlk.Retail_City__c = displaAddress.size()>0 ? displaAddress[0].City__c:'';
                 newAlk.Retail_Distinct__c = displaAddress.size()>0 ? displaAddress[0].District__c:'';
                 newAlk.Retail_Address_Line_1__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_1__c:'';
                 newAlk.Retail_Address_Line_2__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_2__c:'';
                 InsertAlk.add(newAlk);

             }
         } else if (Accountlinklist != null) {
             ShowHideError = true;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.Retail_copy_is_already_present));
         }


     }
 }


             // For MBJ User Creating retail copy
             if (CurrentUsr.ContactId == null) {
                 //For MBJ User if user not selected  Dealer Outlet display error message
                 if (account.Main_Dealer__c == null && account.Main_Dealer__c == null) {
                     ShowHideError = true;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Dealer'));
                 }
                 System.debug('CurrentUsr %%%%%%%' + CurrentUsr);
                 if (accList.RecordtypeId == accPerson_RecordTypeId) {
                     Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkPerson_RecordTypeId AND Retail_Delete_Flag__c = false];
                 }
                 if (accList.RecordtypeId == accCompany_RecordTypeId) {
                     Accountlinklist = [select id, fromRole__c, toRole__c, Retail_Delete_Flag__c from Account_Link__c WHERE fromRole__c =: account.Main_Dealer__c and toRole__c =: AccId AND RecordTypeID =: alkCompany_RecordTypeId AND Retail_Delete_Flag__c = false];
                 }

                 System.debug('#$#$#$####$' + account.Main_Dealer__c);


                 if (Accountlinklist == null || Accountlinklist.isempty() && account.Main_Dealer__c != null) {

                     if (accList.RecordtypeId == accPerson_RecordTypeId) {

                         newAlk = new Account_Link__c();
                         newAlk.toRole__c = AccId;
                         newAlk.Retail_Address_Reference__c = displaAddress.size()>0 ? displaAddress[0].id:'';
                         newAlk.fromRole__c = account.Main_Dealer__c;
                         newAlk.RecordTypeId = alkPerson_RecordTypeId;
                         newAlk.Retail_Address_Type__c = displaAddress.size()>0 ? displaAddress[0].Address_Type__c:'';
                         newAlk.Retail_ZipCode__c = displaAddress.size()>0 ? displaAddress[0].ZipCode__c:'';
                         newAlk.Retail_Province__c = displaAddress.size()>0 ? displaAddress[0].Province__c:'';
                         newAlk.Retail_City__c = displaAddress.size()>0 ? displaAddress[0].City__c:'';
                         newAlk.Retail_Distinct__c = displaAddress.size()>0 ? displaAddress[0].District__c:'';
                         newAlk.Retail_Address_Line_1__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_1__c:'';
                         newAlk.Retail_Address_Line_2__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_2__c:'';
                         InsertAlk.add(newAlk);

                     }
                     if (accList.RecordtypeId == accCompany_RecordTypeId) {


                         newAlk = new Account_Link__c();
                         newAlk.toRole__c = AccId;
                         newAlk.Retail_Address_Reference__c = displaAddress.size()>0 ? displaAddress[0].id:'';
                         newAlk.fromRole__c = account.Main_Dealer__c;
                         newAlk.RecordTypeId = alkCompany_RecordTypeId;
                         newAlk.Retail_Address_Type__c = displaAddress.size()>0 ? displaAddress[0].Address_Type__c:'';
                         newAlk.Retail_ZipCode__c = displaAddress.size()>0 ? displaAddress[0].ZipCode__c:'';
                         newAlk.Retail_Province__c = displaAddress.size()>0 ? displaAddress[0].Province__c:'';
                         newAlk.Retail_City__c = displaAddress.size()>0 ? displaAddress[0].City__c:'';
                         newAlk.Retail_Distinct__c = displaAddress.size()>0 ? displaAddress[0].District__c:'';
                         newAlk.Retail_Address_Line_1__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_1__c:'';
                         newAlk.Retail_Address_Line_2__c = displaAddress.size()>0 ? displaAddress[0].Address_Line_2__c:'';
                         InsertAlk.add(newAlk);
                        
                     }
                 } else if (Accountlinklist != null && account.Main_Dealer__c != null) {
                     ShowHideError = true;
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.Retail_copy_is_already_present));
                 }

             }
             if (InsertAlk != null && InsertAlk.size() > 0) {
                 insert InsertAlk;
             }
     }
   
}