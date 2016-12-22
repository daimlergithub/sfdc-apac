public class AccountLinkController 
    {
      public Account_LInk__c acclnkdealer{get;set;}
      public Account_LInk__c acclnkrellist{get;set;}
     
      private ApexPages.StandardController stdController;   
       public String aid;
    
      public AccountLinkController (ApexPages.StandardController controller) 
      {
        this.stdController = stdController;
      
        acclnkdealer=new Account_LInk__c();
        acclnkrellist=new Account_LInk__c();
        aid = ApexPages.currentPage().getParameters().get('id');
        system.debug('######'+ aid); 
        if(ApexPages.currentPage().getParameters().get('id')!=Null)
        {
                   
       acclnkdealer =[Select Name,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c from Account_Link__c  where toRole__c=:aid and (Recordtype.name='Retail Company' or Recordtype.name='Retail Person' )limit 1];
       
       acclnkrellist= [Select Name,fromRole__c,toRole__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c from Account_Link__c  where toRole__c=:aid and Recordtype.name=:'Retail Company' limit 1];
        }
          }
      
     
}