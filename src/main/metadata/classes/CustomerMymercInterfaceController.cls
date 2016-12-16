public with sharing class CustomerMymercInterfaceController {
    
    public list<Account_Link__c> acclist{get;set;}    
    public Id Accid;
    public id IndividualCustomerExternaLink;
    public id ContactSector;
    public Account_Link__c accl{get;set;}
    public Account_Link__c AclinkPop{get;set;}
    public list<Account_Link__c> aclsize;
    public account accont{get;set;}
    public boolean result;
    public boolean displayPopup{get;set;}
    public string myMercId{get;set;}
    public string MyMercEmail{get;set;}
    public string RegOutlet{get;set;}
    public boolean MyMercVar{get;set;}
    public boolean MyMercEmailVar{get;set;}
    public boolean ContactSectorvar{get;set;}
    public string returnvalue{get;set;}
    public String FinalEmail{get;set;}
    public String AcId;
    public String emailRegEx = '[ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー]+';
    public Account_Link__c aLink{get;set;}
    
    public CustomerMymercInterfaceController(ApexPages.StandardController controller) {
        
        MyMercVar = false;
        MyMercEmailVar = true;
        RegOutlet  = 'No';
        ContactSectorvar = false;
        RecordType rec = [select id from RecordType where sObjecttype = 'Account_Link__c' AND Name = 'ContactSector' limit 1];
        ContactSector = rec.Id;
        aclsize = new list<Account_Link__c>();
        Accid = apexpages.currentpage().getparameters().get('id');
        aclsize  = [select id, toRole__c  from Account_Link__c where toRole__c =: Accid ];
        if(aclsize.size() >0)
            accl = [select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Link__c where toRole__c =: Accid limit 1];
            accont = [select id,email3__c,Portal_Apply_Date__c,Portal_Apply_Status__c,Portal_Apply_User__c,LastName_Native_1__c,PersonBirthdate,Email2__c,email__c,(select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Links__r) from account where id =: Accid limit 1];
            if(accl != null && accl.System__c == 'My Mercedes')
            {
                myMercId = accl.name;
                MyMercVar = true;
                MyMercEmailVar = false;
            }
            for(Account_Link__c acclink: accont.Account_Links__r){
            if(acclink.fromRole__c !=null && acclink.toRole__c !=null && acclink.RecordtypeId == ContactSector){
                RegOutlet = 'Yes';
                ContactSectorvar = true;
            }
            }
      
            if(string.IsnotBlank(accl.Portal_Email__c)){
                MyMercEmail = accl.Portal_Email__c;        }
            else{
                MyMercEmail = accont.email3__c;
            }
       }
 
     public pagereference createContractSector()
     {
         user usr =[select id,profileId,contactId,Contact.AccountId from user where id =: userinfo.getUserId()];
         Profile po = [SELECT Id,UserLicense.Name FROM Profile where id =: usr.profileId];         
         if(po.UserLicense.Name == 'Partner Community') {
         Contact con  = [select id,AccountId from Contact where Id =: usr.contactId ];
         Account_Link__c acc = new Account_Link__c ();
         acc.RecordtypeId = ContactSector;
         acc.Status__c = 'My Shops';
         acc.toRole__c = Accid; //con.AccountId;
         acc.name= 'Test Rec';
         acc.fromRole__c = usr.contact.accountId;
         if(acc != null)
         insert acc;
       pagereference pr = new pagereference ('/'+Accid);
       pr.setRedirect(true);
       return pr;
         }
         else
         {
             Account_Link__c acc = new Account_Link__c ();
         acc.RecordtypeId = ContactSector;
         acc.Status__c = 'My Shops';
         acc.toRole__c = Accid;
         acc.name= 'Test Rec';
         if(acc != null)
         insert acc;
       pagereference pr = new pagereference ('/'+Accid);
       pr.setRedirect(true);
       return pr;
             
         }
     }
 
     public void closePopup()
     {       
         displayPopup = false;   
     }    
     public void showPopup()
     {       
        String aID= apexpages.currentpage().getParameters().get('recordID');  
        aLink = [select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c,toRole__r.Email3__c,toRole__r.Email2__c,toRole__r.Email__c from Account_Link__c where ID=:aID limit 1];
        
        if(String.isNotBlank(aLink.Portal_Email__c)){
            FinalEmail = aLink.Portal_Email__c;
        }
        else{
             FinalEmail = aLink.toRole__r.Email3__c ;
        }
        displayPopup = true;   
     } 
        
     public pagereference savepop()
     {
        Account eachAccount = [Select ID,Email__c,Email2__c,Email3__c From Account where ID=:aLink.toRole__c];       
       
         if(String.isNotBlank(aLink.Portal_Email__c))
         {
             Account_Link__c aLink = [SELECT id,Portal_Email__c from Account_Link__c where ID=:aLink.ID];
             aLink.Portal_Email__c = FinalEmail ;
             Database.SaveResult results = Database.Update(aLink);
         }
        
        eachAccount.Email3__c  = FinalEmail ;
        eachAccount.Email2__c = aLink.toRole__r.Email2__c;
        eachAccount.Email__c= aLink.toRole__r.Email__c;
        Database.SaveResult results = Database.Update(eachAccount);
        displayPopup = false;  
              
          pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+aLink.toRole__c);
          pr.setRedirect(true);
          return pr;
            
      }
 
 
     public void mymercnew(){
         Pattern MyPattern = Pattern.compile(emailRegex);
         if(!String.isBlank(accont.LastName_Native_1__c)){
            Matcher MyMatcher = MyPattern.matcher(accont.LastName_Native_1__c);
            result  = MyMatcher.matches();
         }
        if(accont.recordtypeid == System.Label.PersonAccount_Record_Type_From_Account ) {                   
             if(accont.PersonBirthdate != null&& result ==true && !String.isBlank(accont.Email2__c)){
                 accont.Portal_Apply_Date__c = system.today();
                 accont.Portal_Apply_Status__c = 'To be Sent';
                 accont.Portal_Apply_User__c = userinfo.getUserid();
                 update accont;
             }

            else
            {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Mandate Fields In Accounts'));
            }
        }
 
     else
     {
         accont.Portal_Apply_Date__c = system.today();
         accont.Portal_Apply_Status__c = 'To be Sent';
         accont.Portal_Apply_User__c = userinfo.getUserid();
         update accont;
     }
 
 }
 
         
              public pagereference saveAndReturn()
     {
 
              
          pagereference pr = new pagereference ('/'+Account.id);
          pr.setRedirect(true);
          return pr;
            
      }
 
}