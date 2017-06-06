public  class AccountLinkController
    {
      public Account_LInk__c acclnkdealer{get;set;}
      public Account acc{get;set;}
       public Account Dealeracc{get;set;}
      public Account_LInk__c acclnkrellist{get;set;}
      public List<Account_LInk__c> listalk{get;set;}
       public List<Account_LInk__c> listdupalk{get;set;}
       public String redirectUrl {public get; private set;}
      public Boolean shouldRedirect {public get; private set;}
      //public Account ab{get;set;}
      private ApexPages.StandardController stdController;   
       public static String aid;
       public Id sid;
        public String CommGcCode;
       public User  us;
     public static Id alkPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id alkCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
     public static Id con2con_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
     public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static Id accPersonAccountSoftDeleted_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Soft Deleted').getRecordTypeId();
    public boolean companyRT {get;set;}
    public boolean personaccRT {get;set;}
      public AccountLinkController (ApexPages.StandardController controller){
        this.stdController = stdController;
        shouldRedirect = false;
        acc=new Account();
        us=new User();
        Dealeracc=new Account();
        acclnkdealer=new Account_LInk__c();
        acclnkrellist=new Account_LInk__c();
        listdupalk=new List<Account_LInk__c> ();
        aid = ApexPages.currentPage().getParameters().get('id');
         us=[Select id,ContactId,contact.AccountId,Dealer_GC_Code__c  from User where id=:userInfo.getuserId()];
         CommGcCode=us.Dealer_GC_Code__c;
        system.debug('######'+ CommGcCode); 
        
        if(ApexPages.currentPage().getParameters().get('id')!=Null){
            acc=[select id,recordtypeid from account where id=:aid];
            if(us.contact.AccountId !=null)
            {
            Dealeracc=[select id,recordtypeid,Dealer_GC_Code__c from account where id=:us.contact.AccountId];
            }
            listalk=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,Retail_Comments__c,Retail_Sales_Consultant__c,Selling_Dealer__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid];
           System.debug('&*&*&&*&&VENky'+listalk.size());
            if(listalk !=null && !listalk.isempty()){
                if(us.contact.AccountId !=null){
                if(acc.recordtypeid ==accPerson_RecordTypeId){
                    try{
                     
                //     listdupalk=[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkPerson_RecordTypeId  and ((toRole__c=:aid and fromRole__c=:Dealeracc.id) )];
                          
                      
                acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkPerson_RecordTypeId  and fromRole__c=:Dealeracc.id and toRole__c=:aid limit 1];
            
                 System.debug('&&& venky acclnkdealer %%%'+acclnkdealer);
                   
             //   acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkPerson_RecordTypeId  and fromRole__r.Dealer_GC_Code__c =:CommGcCode limit 1];
                  
                  System.debug('&&& venky %%%'+acclnkdealer);
                    System.debug('&*&*listdupalk&*&&VENky'+listdupalk.size()+listdupalk);
                    
                    
                    
                    }
                    catch(Exception e){
                    if(e.getmessage() !=null)
                    {
                     acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkPerson_RecordTypeId  and fromRole__r.Dealer_GC_Code__c =:CommGcCode and toRole__c=:aid limit 1];
                 }
                 
                    }
                    sid = acclnkdealer.id;         
                }
                if(acc.recordtypeid ==accCompany_RecordTypeId){
                    try{
                      //  acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkCompany_RecordTypeId and ((toRole__c=:aid and fromRole__c=:Dealeracc.id)  OR (fromRole__r.Dealer_GC_Code__c =:CommGcCode and toRole__c=:aid)) limit 1];
                     acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkCompany_RecordTypeId  and fromRole__c=:Dealeracc.id and toRole__c=:aid limit 1];
            
                 System.debug('&&& venky acclnkdealer %%%'+acclnkdealer);
                    }
                    catch(Exception e)
                    {
                     if(e.getmessage() !=null)
                    {
                     acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Selling_Dealer__r.Name,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkCompany_RecordTypeId  and fromRole__r.Dealer_GC_Code__c =:CommGcCode and toRole__c=:aid limit 1];
                 }
                    
                    }
                    sid = acclnkdealer.id;
                }
       }
                if(acc.recordtypeid ==accPerson_RecordTypeId || acc.recordtypeid ==accPersonAccountSoftDeleted_RecordTypeId){
                    try{
                        acclnkrellist=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,Retail_Sales_Consultant__c,Selling_Dealer__c,toRole__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkPerson_RecordTypeId and Retail_Delete_Flag__c=false limit 1];
                    }
                    catch(Exception e){}
                }
                if(acc.recordtypeid ==accCompany_RecordTypeId){
                    try{
                        acclnkrellist=[Select id,Name,Retail_FirstName__c,Retail_LastName__c,fromRole__c,toRole__c,Retail_Sales_Consultant__c,Selling_Dealer__c,Retail_Comments__c,Retail_OptOutContact_Reason__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where toRole__c=:aid and recordtypeID=:alkCompany_RecordTypeId and Retail_Delete_Flag__c=false limit 1];
                    }
                    catch(Exception e){}
                }
            }
            system.debug('$$$$$$$$$ CommGcCode '+CommGcCode);
            if(listalk.size()==0)
            {
                 if(acc.recordtypeid ==accPerson_RecordTypeId){
                    acclnkdealer =[Select id,Name,Retail_Comments__c,Retail_OptOutContact_Reason__c,Retail_Sales_Consultant__c,Selling_Dealer__c, Retail_Email_OptOut__c,Retail_Fax_OptOut__c,Retail_Phone_OptOut__c,Retail_Postal_OptOut__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Sanction__c,Retail_Sales_Sanction_Comment__c,Retail_Sales_Consultant__r.Name,Retail_Visit_OptOut__c,toRole__r.Name,fromRole__r.Name from Account_Link__c  where recordtypeID=:alkPerson_RecordTypeId  and fromRole__r.Dealer_GC_Code__c =:CommGcCode limit 1];
                    
                    }
            }
            personaccRT = false;
            if(acc.RecordTypeid==accPerson_RecordTypeId || acc.RecordTypeid==accCompany_RecordTypeId){
               personaccRT=true;
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