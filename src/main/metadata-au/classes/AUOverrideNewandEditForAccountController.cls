public with sharing class AUOverrideNewandEditForAccountController
{
    //variables used in the page.
    ApexPages.StandardController controller;
    public boolean isPerson{get;set;}
    public boolean isCompany{get;set;}
    //Company account variable decleration
    public Account objAccount{get;set;}
    //Person account variable decleration
    public Account objPersonAccount{get;set;}
    public Contact objContact{get;set;}
    public string strHeaderTitle{get;set;}
    public string accountOwner{get;set;}
    public string recordType{get;set;}
    private string recordTypeId;
    
    public AUOverrideNewandEditForAccountController(ApexPages.StandardController controller)
    {
      objAccount= new Account();
      objPersonAccount= new Account();
      objContact= new Contact();
      if(ApexPages.currentPage().getParameters().get('Type')!=null && ApexPages.currentPage().getParameters().get('Type')=='person')
      {
        isPerson=true;
        isCompany=false;
        strHeaderTitle='Person Account Edit';
        recordType='Person Account';
        recordTypeId=objPersonAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        if(ApexPages.currentPage().getParameters().get('recordId')!=null)
        {
          objPersonAccount=getPersonAccountDeatails(ApexPages.currentPage().getParameters().get('recordId'));
          if(objPersonAccount!=null)
          {
            recordTypeId=objPersonAccount.RecordTypeId;
            objContact.Salutation=objPersonAccount.Salutation;
            objContact.FirstName=objPersonAccount.FirstName;
            objContact.LastName=objPersonAccount.LastName;
          }
        }
      }
      if(ApexPages.currentPage().getParameters().get('Type')!=null && ApexPages.currentPage().getParameters().get('Type')=='company')
      {
        isPerson=false;
        isCompany=true;
        strHeaderTitle='Business Account Edit';
        recordType='Company';
        recordTypeId=objAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        if(ApexPages.currentPage().getParameters().get('recordId')!=null)
        {
          objAccount=getAccountDeatails(ApexPages.currentPage().getParameters().get('recordId'));
          if(objAccount!=null)
          {
            recordTypeId=objAccount.RecordTypeId;
          }
        }
      }
      
      accountOwner=userinfo.getname();
    }
    
    public pagereference saveAccount()
    {
      try{
        if(isCompany){
            upsert objAccount;  
          PageReference pageRef = new PageReference('/'+objAccount.Id);
            return PageRef;
        }
        if(isPerson){
          objPersonAccount.Salutation=objContact.Salutation;
          objPersonAccount.FirstName=objContact.FirstName;
          objPersonAccount.LastName=objContact.LastName;
          upsert objPersonAccount;
          PageReference pageRef = new PageReference('/'+objPersonAccount.Id);
            return PageRef;
        }
      }
      catch(DMLException e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));
      }
      return null;
    }
    
    public PageReference saveNew() 
    {
      try {
        if(isCompany){ 
           upsert objAccount;
           //PageReference pr = new PageReference('/apex/AUOverrideNewandEditForAccount?ent=Account&nooverride=1&RecordType='+recordTypeId+'&retURL=%2F001%2Fo&Type=company');
           PageReference pr = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&retURL=%2F'+objAccount.Id+'&save_new_url=%2F001%2Fe%3F%26RecordType%'+recordTypeId+'26retURL%3D%252F'+objAccount.Id);
           pr.setRedirect(true);  
              return pr;
        }
        if(isPerson){
          objPersonAccount.Salutation=objContact.Salutation;
          objPersonAccount.FirstName=objContact.FirstName;
          objPersonAccount.LastName=objContact.LastName;
          upsert objPersonAccount;
          //PageReference pr = new PageReference('/apex/AUOverrideNewandEditForAccount?ent=Account&nooverride=1&RecordType='+recordTypeId+'&retURL=%2F001%2Fo&Type=person');
          PageReference pr = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&retURL=%2F'+objPersonAccount.Id+'&save_new_url=%2F001%2Fe%3F%26RecordType%'+recordTypeId+'26retURL%3D%252F'+objPersonAccount.Id);
           pr.setRedirect(true);  
              return pr;
        }
      } catch(DMLException e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getdmlMessage(0)));
      }   
      return null;
  }
  
  public PageReference cancel()
  {
    PageReference pageRef;
    if(ApexPages.currentPage().getParameters().get('recordId')!=null)
        pageRef = new PageReference('/'+ApexPages.currentPage().getParameters().get('recordId'));
    else    
      pageRef = new PageReference('/001/o');
        return PageRef;
  }
  
  @TestVisible private Account getAccountDeatails(id recordId)
  {
    Account objAcc=[Select id,Recordtypeid,Name,City__c,isPersonAccount,Website,Fax,Fleet__c,Description,Dealer_ABN__c,AccountNumber,
            ParentId,Company_Name__c,Fleet_Category__c,Add_User__c,Add_Date__c,Work_Phone__c,Individual_Home_Phone__c,Opt_In_Work_Phone__c,Opt_In_Home_Phone__c,
            FS_Opt_In_Work_Phone__c,FS_Opt_In_Home_Phone__c,Mobile__c,Opt_In_SMS__c,FS_Opt_In_SMS__c,Email__c,FS_Opt_In_Email__c,Opt_In_Email__c
            from Account where id=:recordId];
    return   objAcc;
  }
  
  @TestVisible private Account getPersonAccountDeatails(id recordId)
  {
    Account objAcc=[Select id,Fax,Recordtypeid,Salutation,isPersonAccount,FirstName,Deceased__c,LastName,Gender__c,Suffix__c,Marital_Status__c,Company__c,PersonBirthdate,Education__c,
            Industry,Age_Range__c,Occupation__c,Partner_Title__c,Corporate_Program__c,Partner_First_Name__c,Partner_Surname__c,Partner_DOB__c,
            Work_Phone__c,Individual_Home_Phone__c,Opt_In_Work_Phone__c,Opt_In_Home_Phone__c,FS_Opt_In_Work_Phone__c,FS_Opt_In_Home_Phone__c,
            Mobile__c,Opt_In_SMS__c,FS_Opt_In_SMS__c,Email__c,FS_Opt_In_Email__c,Opt_In_Email__c,PreferredName__c,Preferred_Partner_Name__c
            from Account where id=:recordId];
    return   objAcc;        
  }  
}