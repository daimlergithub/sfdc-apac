public class AccountLinkController 
    {
      public Account_LInk__c acclnkdealer{get;set;}
      public Account acc{get;set;}
      public Account_LInk__c acclnkrellist{get;set;}
      public List<Account_LInk__c> listalk{get;set;}
      private ApexPages.StandardController stdController;   
       public String aid;
     public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
     public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
      public AccountLinkController (ApexPages.StandardController controller) 
      {
        this.stdController = stdController;
      acc=new Account();
        acclnkdealer=new Account_LInk__c();
        acclnkrellist=new Account_LInk__c();
        aid = ApexPages.currentPage().getParameters().get('id');
        system.debug('######'+ aid); 
        
        if(ApexPages.currentPage().getParameters().get('id')!=Null)
        {
         acc=[select id,recordtypeid from account where id=:aid];
         
         listalk=[Select Name,Retail_FirstName__c,Retail_LastName__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid ];
       if(listalk !=null && !listalk.isempty())
       {
       if(acc.recordtypeid ==accPerson_RecordTypeId)
       {
       acclnkdealer =[Select Name,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkPerson_RecordTypeId limit 1];
       
       }
       if(acc.recordtypeid ==accCompany_RecordTypeId)
       {
       acclnkdealer =[Select Name,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkCompany_RecordTypeId limit 1];
       
       }
       
       if(acc.recordtypeid ==accPerson_RecordTypeId)
       {
      acclnkrellist=[Select Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,toRole__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkPerson_RecordTypeId limit 1];
        
       }
       if(acc.recordtypeid ==accCompany_RecordTypeId)
       {
     acclnkrellist=[Select Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,toRole__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkCompany_RecordTypeId limit 1];
         
       }
          
        }
        }
          }
      
     
}