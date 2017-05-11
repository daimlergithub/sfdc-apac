/************************************************************
LastModifiedDate : May 10, 2017
LastModifiedBy   : Lokesh M
Related JIRA     : SFDCJP-2100,SFDCJP-2000
************************************************************/

public with sharing class CustomerMymercInterfaceController {
    
    public list<Account_Link__c> acclist{get;set;}    
    public Id Accid;
    public id IndividualCustomerExternaLink;
    public id ContactSector;
    public list<Account_Link__c> accl{get;set;}
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
    public String aclId;
    public String emailRegEx = '[ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー]+';
    public Account_Link__c aLink{get;set;}
    public User usr = new user();
    
    public CustomerMymercInterfaceController(ApexPages.StandardController controller) {
        usr = [Select Id,name,contact.AccountId from User WHERE ID =: UserInfo.getUserId() ];
        MyMercVar = false;
        MyMercEmailVar = true;
        RegOutlet  = 'No';
        ContactSectorvar = true;
        RecordType rec = [select id from RecordType where sObjecttype = 'Account_Link__c' AND Name = 'ContactSector' limit 1];
        ContactSector = rec.Id;
        aclsize = new list<Account_Link__c>();
        Accid = apexpages.currentpage().getparameters().get('id');
        aclsize  = [select id, toRole__c  from Account_Link__c where toRole__c =: Accid ];
        if(aclsize.size() >0)
            accl = [select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Link__c where toRole__c =: Accid ];
        accont = [select id,Data_Source__C, Allow_Data_Sharing2__c,Gender__c,Main_Dealer__c,RecordtypeId,email3__c,Portal_Apply_Date__c,Portal_Apply_Status__c,Portal_Apply_User__c,LastName_Native_1__c,PersonBirthdate,Email2__c,email__c,(select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Links__r) from account where id =: Accid limit 1];
        if(accl != null && !accl.isEmpty())
        {
            for(Account_Link__c acc: accl){
                if(acc.System__c == 'My Mercedes'){
                    myMercId = acc.name;
                    MyMercVar = true;
                    MyMercEmailVar = false;
                    ContactSectorvar = false;
                    aclId = acc.Id;
                    if(string.IsnotBlank(acc.Portal_Email__c)){
                        MyMercEmail = acc.Portal_Email__c;        
                    }
                }
            }
        }
        for(Account_Link__c acclink: accont.Account_Links__r){
            if(acclink.fromRole__c !=null && acclink.toRole__c !=null && acclink.RecordtypeId == ContactSector){
                RegOutlet = 'Yes';
                ContactSectorvar = true;
            }
        } 
   }

     public pagereference createContractSector()
     {
         //user usr =[select id,profileId,contactId,Contact.AccountId from user where id =: userinfo.getUserId()];
         Profile po = [SELECT Id,UserLicense.Name FROM Profile where id =: usr.profileId];         
         if(po.UserLicense.Name == 'Partner Community') {
         Contact con  = [select id,AccountId from Contact where Id =: usr.contactId ];
         Account_Link__c acc = new Account_Link__c ();
         acc.RecordtypeId = ContactSector;
         acc.Status__c = 'My Shops';
         acc.toRole__c = Accid; //con.AccountId;
         acc.name= '販売店関係情報';
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
         acc.name= '販売店関係情報';
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
        aLink = [select id,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_Email__c,toRole__r.Email3__c,toRole__r.Email2__c,toRole__r.Email__c from Account_Link__c where ID=:aID limit 1];
        displayPopup = true;   
     } 
        
    public pagereference savepop()
    {
        if( MyMercEmail == NULL || string.isBlank(MyMercEmail)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'please input "My Mercedes Email Id"'));
            return null;
        } 
        else{ 
            Account_Link__c aLink = [SELECT id,Portal_Email__c,toRole__c from Account_Link__c where ID=:aclId limit 1];
            aLink.Portal_Email__c = MyMercEmail;
            Database.SaveResult results = Database.Update(aLink);
            accont.Email3__c  = MyMercEmail;
            Database.SaveResult accResults = Database.Update(accont);
            pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
            pr.setRedirect(true);
            return pr;
        }
    }
 
    public PageReference mymercnew(){
    try{
        Pattern MyPattern = Pattern.compile(emailRegex);
        if(!String.isBlank(accont.LastName_Native_1__c)){
        Matcher MyMatcher = MyPattern.matcher(accont.LastName_Native_1__c);
        result  = MyMatcher.matches();
        }
        
        if( MyMercEmail == NULL || string.isBlank(MyMercEmail)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'please input "My Mercedes Email Id"'));
            return null;
        }
        else if(!string.isBlank(MyMercEmail)){// && (!MyMercEmail.endsWith('.com') || !MyMercEmail.contains('@') || MyMercEmail.);
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!{}+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
            Pattern MyPatternn = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPatternn.matcher(MyMercEmail);
        
            if (!MyMatcher.matches()){ 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'please enter valid Email'));
                return null;    
            }
        }
        else{ 
            accont.Email3__c  = MyMercEmail;
        }
        if(accont.recordtypeid == System.Label.PersonAccount_Record_Type_From_Account ) {
              if(accont.PersonBirthdate != NUll && accont.LastName_Native_1__c != NULL && accont.Gender__c!= NULL){
              
                 accont.Portal_Apply_Date__c = system.today();
                 accont.Portal_Apply_Status__c = 'To be Sent';
                 accont.Portal_Apply_User__c = userinfo.getUserid();
                 if(accont.Allow_Data_Sharing2__c == 'No' && accont.Data_Source__C == 'Dealer Outlet'){
                     accont.Allow_Data_Sharing2__c= 'Yes';
                     accont.Data_Source__C = 'My Mercedes';
                 }
                 system.debug('accountMainDealer'+accont.main_dealer__C);
                 if(accont.Main_Dealer__c == NULL ){
                     system.debug('usrcontactaccountid'+usr.contact.AccountId);    
                     accont.Main_Dealer__c = usr.contact.AccountId;
                 }
                 
                 update accont;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Records Updated'));
             }
            else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Mandatory fields on Account - Birthdate, LastNameNative, Gender'));
                 return null; 
            }
        }
       }
       catch(exception e){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
       }
       
        /* else
         {
             accont.Portal_Apply_Date__c = system.today();
             accont.Portal_Apply_Status__c = 'To be Sent';
             accont.Portal_Apply_User__c = userinfo.getUserid();
             update accont;
         }*/
         pagereference pr = new pagereference ('/'+Accid);
         pr.setRedirect(true);
         return pr;
         
     }
     
    public pagereference saveAndReturn(){
        pagereference pr = new pagereference ('/'+Account.id);
        pr.setRedirect(true);
        return pr;
    }
}