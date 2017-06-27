/***********************************************************************************
Created By          :    Venky 
Created Date        :    06.12.2016
Company             :    NTT Data,Inc.
Usage               :   The functionality of this Class sending Account Id and DealerId to EP database
                         Business Conditions : 
                         Sending Current AccountId and Dealer Id to EP.
                         in account If Warranty_Apply_Status__c is null update to "To be  sent" 
JIRA NO             :    SFDCJP-682,631
************************************************************************************/



public class SendAccountInfoToSPO {
    Public String AccId{get;set;}
    Public Account Acclist { get; set; }
    Public Map<Id,Account> Accupdate { get; set; }
    Public List<Account> listAcc { get; set; }
    Public Address__c Addlist{get;set;}
    Public String redirectUrl{get;set;}
    Public List<Address__c> AddRecords{get;set;}
    Public User  Usr{get;set;}
    Public String HomeAdd{get;set;}
    Public string message{get;set;}
    public Boolean shouldRedirect {public get; private set;}
    public  Boolean ShowHideError{set;get;} 
     //Constructor 
    public SendAccountInfoToSPO(ApexPages.StandardController controller) {
        Acclist =new Account();
        Addlist=new Address__c ();
        AddRecords=new List<Address__c>();
        shouldRedirect =false;
      AccId=ApexPages.currentPage().getParameters().get('id');
        Acclist=[select id,FirstName,LastName,FirstName_Native_1__c,LastName_Native_1__c ,Name,Company_Name_Native_1__c,LastModifiedDate,
                Individual_Home_Phone__c,Mobile__c,Email3__c from account where Id=:AccId ];
                AddRecords=[select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId ];
                for(Address__c ad:AddRecords)
                {
                if(ad.Address_Type__c=='Home')
                {
                HomeAdd=ad.Address_Type__c;
                }
                }
                System.debug('#$#$##$#$#$#'+HomeAdd);
                if(AddRecords!=null && AddRecords.Size()>0 && HomeAdd=='Home')
                {
                Addlist=[Select id,Address_Type__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,ZipCode__c from Address__c where Customer__c=:AccId and Address_Type__c='Home'];
                }
    } //Constructor End.
    
    
    // Method to Send AccountId and Dealer Id to EP
    Public void SendTOSpo()
    {
    Usr=new User(); 
    Accupdate=new Map<Id,Account>();
  
     User  CurrentUsr=[SELECT Market__c,contactid,Id FROM User WHERE Id = : UserInfo.getUserId()];
     if(CurrentUsr.contactid!=null)
     {
    Usr = [SELECT Market__c,contactid,Id,Contact.AccountId FROM User WHERE Id = : UserInfo.getUserId() and User.Profile.UserLicense.Name='Partner Community']; 
    
    }
      crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response=new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
  
    try
    {
    if (!Test.isRunningTest())
    {
      
    response= UtilWebservice.AccountIfnoSendSPO(AccId,usr.Contact.AccountId);
     ShowHideError=false; 
    }
    System.debug('response $%$%$%$%$%$$'+response);
    listAcc =[select id,Warranty_Apply_Status__c,Data_Source__c,Allow_Data_Sharing2__c from Account where id=:AccId];
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
	acc.Warranty_Apply_Date__c=System.today();
    Accupdate.put(acc.id,acc);
     System.debug('acc Accupdate'+Accupdate);
    }
    if(Acc.Allow_Data_Sharing2__c =='No' && Acc.Data_Source__c=='Dealer Outlet')
    {
    acc.Data_Source__c='Service Program';
    acc.Allow_Data_Sharing2__c='Yes';
    Accupdate.put(acc.id,acc);
    }
    }
    }
    }
	if(Accupdate !=null)
	{
    update Accupdate.values(); 
}	// Update account object Warranty_Apply_Status field
     System.debug('acc Accupdate'+Accupdate);
     
   
    }
     Catch(CalloutException e)
                   {
                    String erre=e.getmessage();
            String[] errMessage = erre.split('webservice.WebServiceFault');          
            String errMessaget = errMessage[0];
            String errMessageText = errMessage[1];
                   ShowHideError=True; 
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMessageText));     
                  
                  }          
    
     } //Method End
    

}// Class end