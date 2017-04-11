public  class AccountLinkController
    {
      public Account_LInk__c acclnkdealer{get;set;}
      public Account acc{get;set;}
      public Account_LInk__c acclnkrellist{get;set;}
      public List<Account_LInk__c> listalk{get;set;}
       public String redirectUrl {public get; private set;}
      public Boolean shouldRedirect {public get; private set;}
      //public Account ab{get;set;}
      private ApexPages.StandardController stdController;   
       public static String aid;
       public Id sid;
     public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
     public static Id con2con_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
     public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id accPersonAccountSoftDeleted_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Soft Deleted').getRecordTypeId();
    public boolean companyRT {get;set;}
      public AccountLinkController (ApexPages.StandardController controller){
        this.stdController = stdController;
        shouldRedirect = false;
        acc=new Account();
        acclnkdealer=new Account_LInk__c();
        acclnkrellist=new Account_LInk__c();
        aid = ApexPages.currentPage().getParameters().get('id');
        system.debug('######'+ aid); 
        
        if(ApexPages.currentPage().getParameters().get('id')!=Null){
            acc=[select id,recordtypeid from account where id=:aid];
            listalk=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,Retail_Comments__c,Selling_Dealer__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid ];
            if(listalk !=null && !listalk.isempty()){
                if(acc.recordtypeid ==accPerson_RecordTypeId){
                    try{
                        acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkPerson_RecordTypeId limit 1];
                    }
                    catch(Exception e){}
                    sid = acclnkdealer.id;         
                }
                if(acc.recordtypeid ==accCompany_RecordTypeId){
                    try{
                        acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkCompany_RecordTypeId limit 1];
                    }
                    catch(Exception e){}
                    sid = acclnkdealer.id;
                }
       
                if(acc.recordtypeid ==accPerson_RecordTypeId || acc.recordtypeid ==accPersonAccountSoftDeleted_RecordTypeId){
                    try{
                        acclnkrellist=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,Selling_Dealer__c,toRole__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkPerson_RecordTypeId limit 1];
                    }
                    catch(Exception e){}
                }
                if(acc.recordtypeid ==accCompany_RecordTypeId){
                    try{
                        acclnkrellist=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,toRole__c,Selling_Dealer__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkCompany_RecordTypeId limit 1];
                    }
                    catch(Exception e){}
                }
            }
            companyRT = false;
            if(acc.RecordTypeid==accCompany_RecordTypeId){
               companyRT=true;
            }
        }
        
        
    }
          /*
           public pageReference ab()
 
            {
          String url = null;
        
          //url = '/MBJapan/acclnkdealer[0].id/e?ret';
              system.debug('+++++++++++++'+sid);
       //   pageReference pg = new pageReference('/MBJapan/'+acclnkdealer.id+'/e?retURL='+'/MBJapan/'+acclnkdealer.id );
       
         pageReference pg = new pageReference('/Asia/'+acclnkdealer.id+'/e?retURL='+'/Asia/'+acclnkdealer.id );
           
          //p = new PageRefreance(' url');
          pg.setRedirect(true);
           return pg;
                 }*/
                 
          public PageReference DeleteRetailCopy(){
                                        system.debug('#######'+aid);
                                        system.debug('#######'+acclnkdealer.id);
                                delete [select id from Account_link__c WHERE id = : acclnkdealer.id];
                                PageReference redirectUrl= new PageReference('{!URLFOR($Site.Prefix)}/'+aid + '_parent');
                                shouldRedirect = true;
                                redirectUrl.setRedirect(true);
                                return null;
                               
                                               
            }       
                 
                 
          
}