public class SendAccountInfoToSPO {
    Public String AccId{get;set;}
    Public Account Acclist { get; set; }
    Public List<Account> Accupdate { get; set; }
    Public List<Account> listAcc { get; set; }
    Public Address__c Addlist{get;set;}
    Public String redirectUrl{get;set;}
    Public List<Address__c> AddRecords{get;set;}
    Public User  Usr{get;set;}
    Public string message{get;set;}
    public Boolean shouldRedirect {public get; private set;}
     
    public SendAccountInfoToSPO(ApexPages.StandardController controller) {
        Acclist =new Account();
        Addlist=new Address__c ();
        AddRecords=new List<Address__c>();
        shouldRedirect =false;
      AccId=ApexPages.currentPage().getParameters().get('id');
        Acclist=[select id,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c ,Name,Company_Name_Native_1__c,LastModifiedDate,
                Individual_Home_Phone__c,Mobile__c,Email3__c from account where Id=:AccId ];
                AddRecords=[select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId ];
                
                if(AddRecords!=null && AddRecords.Size()>0)
                {
                Addlist=[Select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId and Address_Type__c='Home'];
                }
    }
    
    Public void SendTOSpo()
    {
    Usr=new User(); 
    Accupdate=new List<Account>();
  
     User  CurrentUsr=[SELECT Market__c,contactid,Id FROM User WHERE Id = : UserInfo.getUserId()];
     if(CurrentUsr.contactid!=null)
     {
    Usr = [SELECT Market__c,contactid,Id FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
    
    }
      crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
  
    if (!Test.isRunningTest())
    {
    response= UtilWebservice.AccountIfnoSendSPO(AccId,Usr.contactid);
    }
    System.debug('response $%$%$%$%$%$$'+response);
    listAcc =[select id,Warranty_Apply_Status__c from Account where id=:AccId];
    System.debug('$%$%$%$%$%$$'+listAcc );
    If(response!=null)
   {
    if(listAcc!=null)
     {
    for(Account acc:listAcc)
    {
    
    if((Acc.Warranty_Apply_Status__c ==null) || (Acc.Warranty_Apply_Status__c=='none') )
    {
    acc.Warranty_Apply_Status__c='To be Sent';
    Accupdate.add(acc);
     System.debug('acc Accupdate'+Accupdate);
    }
    }
    }
    }
    update Accupdate; 
     System.debug('acc Accupdate'+Accupdate);
     
    }
    
    
    

}