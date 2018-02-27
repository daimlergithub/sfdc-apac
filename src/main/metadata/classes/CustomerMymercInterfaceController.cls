/************************************************************
LastModifiedDate : May 10, 2017
LastModifiedBy   : Lokesh M
Related JIRA     : SFDCJP-2100,SFDCJP-2000
************************************************************/

public with sharing class CustomerMymercInterfaceController {
    
    //public list<Account_Link__c> acclist{get;set;}    
    public Id Accid{get;set;}
    public id IndividualCustomerExternaLink;
    public id ContactSector;
    public list<Account_Link__c> accl{get;set;}
   // public Account_Link__c AclinkPop{get;set;}
    public list<Account_Link__c> aclsize;
    public Static account accont{get;set;}
    public boolean result;
    public boolean displayPopup{get;set;}
    public boolean cancelpop{get;set;}
   // public boolean oldpopup{get;set;}
    public boolean Newpopup{get;set;}
    public string myMercId{get;set;}
    public string MyMercEmail{get;set;}
    public string RegOutlet{get;set;}
    public string loginmobile{get;set;}
    public boolean MyMercVar{get;set;}
    public boolean MyMercEmailVar{get;set;}
    public boolean ContactSectorvar{get;set;}
    public boolean loginmobileButton{get;set;}
   // public string returnvalue{get;set;}
   // public String FinalEmail{get;set;}
    public String AcId;
    public String aclId;
    public String emailRegEx = '[ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー]+';
    public Account_Link__c aLink{get;set;}
    public User usr = new user();
     public static Id AccountLink_IndividualCustomerRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public CustomerMymercInterfaceController(ApexPages.StandardController controller) {
        usr = [Select Id,name,contact.AccountId,User_Type__c,ProfileId from User WHERE ID =: UserInfo.getUserId() ];//Changes by Lokesh
        MyMercVar = false;
        MyMercEmailVar = false;
        RegOutlet  = 'No';
        ContactSectorvar = true;
         MyMercEmailVar = true;
        loginmobileButton=true;
        Newpopup=false;
        cancelpop =true;
        RecordType rec = [select id from RecordType where sObjecttype = 'Account_Link__c' AND Name = 'ContactSector' limit 1];
        ContactSector = rec.Id;
        aclsize = new list<Account_Link__c>();
        Accid = apexpages.currentpage().getparameters().get('id');
        aclsize  = [select id, toRole__c  from Account_Link__c where toRole__c =: Accid ];
        if(aclsize.size() >0)
            accl = [select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,CIAM_Mobile__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Link__c where toRole__c =: Accid ];
           //  accl = [select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Link__c where Primary__c =: True ];
        accont = [select id,Data_Source__C, Mobile_3__c ,Allow_Data_Sharing2__c,Gender__c,Main_Dealer__c,RecordtypeId,email3__c,Portal_Apply_Date__c,Portal_Apply_Status__c,Portal_Apply_User__c,LastName_Native_1__c,PersonBirthdate,Email2__c,email__c,(select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Links__r) from account where id =: Accid limit 1];
        if(accl != null && !accl.isEmpty())
        {
            for(Account_Link__c acc: accl){
                if(acc.System__c == 'My Mercedes' && acc.Primary__c ==True){
                    myMercId = acc.name;
                    MyMercVar = true;
                    //MyMercEmailVar = true;
                    if(string.IsnotBlank(acc.name)){
                    MyMercEmailVar = false;
                    }else{
                    MyMercEmailVar = true;

                    }                                         
                    ContactSectorvar = false;
                    aclId = acc.Id;
                    if(string.IsnotBlank(acc.Portal_Email__c)){
                        MyMercEmail = acc.Portal_Email__c; 
                        
                        MyMercEmailVar = true;
                        
                    }
                     if(string.IsnotBlank(acc.CIAM_Mobile__c)){
                        loginmobile = acc.CIAM_Mobile__c; 
                                                        
                    }
                     System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+loginmobileButton);
                      System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+acc.fromRole__c);
                       System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+acc.toRole__c);
                        System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+acc.System__c);
                         System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+acc.Primary__c);
                          System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+loginmobileButton);
                          
                    
                     if( acc.toRole__c !=null && acc.RecordtypeId == AccountLink_IndividualCustomerRecordTypeId && acc.System__c == 'My Mercedes' && acc.Primary__c ==true && usr.User_Type__c !='Dealer')
            {
            System.debug('^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&'+loginmobileButton);
            loginmobileButton=false;
            }
            else
            {
             loginmobileButton=true;
            }
                }
            }
        }
        for(Account_Link__c acclink: accont.Account_Links__r){
            if(acclink.fromRole__c !=null && acclink.toRole__c !=null && acclink.RecordtypeId == ContactSector){
                RegOutlet = 'Yes';
                ContactSectorvar = true;
            }
          /*  if(acclink.fromRole__c !=null && acclink.toRole__c !=null && acclink.RecordtypeId == AccountLink_IndividualCustomerRecordTypeId && acclink.System__c == 'My Mercedes' && acclink.Primary__c ==true)
            {
            loginmobileButton=true;
            }*/
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
        aLink = [select id,fromRole__r.Email2__c,fromRole__r.Email__c,CIAM_Mobile__c,Portal_Email__c,toRole__r.Email3__c,toRole__r.Email2__c,toRole__r.Email__c from Account_Link__c where ID=:aID limit 1];
        displayPopup = true;   
     } 
        
    public pagereference savepop()
    {
        if( (MyMercEmail == NULL || string.isBlank(MyMercEmail) )  && (loginmobile == NULL  || string.isBlank(loginmobile)) ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Please_Input_MyMercedes_Email_Id_or_Login_Mobile));
            return null;
        } 
        else{ 
            Account_Link__c aLink = [SELECT id,Portal_Email__c,CIAM_Mobile__c,toRole__c from Account_Link__c where ID=:aclId limit 1];
            aLink.Portal_Email__c = MyMercEmail;

            Database.SaveResult results = Database.Update(aLink);
            accont.Email3__c  = MyMercEmail;
            accont.Mobile_3__c = loginmobile;
            Database.SaveResult accResults = Database.Update(accont);
            pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
            pr.setRedirect(true);
            return pr;
        }
    }
    
     public PageReference MercedesmeDeletion(){
        
         accont = [select id,Data_Source__C,Customer_LastUpdatedDate__c, Allow_Data_Sharing2__c,Gender__c,Main_Dealer__c,RecordtypeId,email3__c,Portal_Apply_Date__c,Portal_Apply_Status__c,Portal_Apply_User__c,LastName_Native_1__c,PersonBirthdate,Email2__c,email__c,(select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Links__r) from account where id =: Accid limit 1];
            accont.Customer_LastUpdatedDate__c= System.now();
            accont.Portal_Apply_Status__c ='To be Deleted';
            Database.SaveResult accResults = Database.Update(accont);
            pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
            pr.setRedirect(true);
            return pr;
         } 
 
  public pagereference Cancel(){
        pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference mymercnew(){
    try{
         Accid = apexpages.currentpage().getparameters().get('id');
         accont = [select id,Data_Source__C, Allow_Data_Sharing2__c,Gender__c,Main_Dealer__c,RecordtypeId,email3__c,Portal_Apply_Date__c,Portal_Apply_Status__c,Portal_Apply_User__c,LastName_Native_1__c,PersonBirthdate,Email2__c,email__c,(select id,name,fromRole__r.Name,fromRole__r.Email2__c,fromRole__r.Email__c,Portal_ID__c,System__c,RecordtypeId,Primary__c,Portal_Email__c,toRole__c from Account_Links__r) from account where id =: Accid limit 1];
         system.debug('+++++++++++++++++++++'+accont );
         String emailRegex = '^[a-zA-Z0-9._|\\\\#~`=?$^!{}+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,4}$'; 
        Pattern MyPattern = Pattern.compile(emailRegex);
        system.debug('++++++++++++'+accont.LastName_Native_1__c);
        if(!String.isBlank(accont.LastName_Native_1__c)){
        Matcher MyMatcher = MyPattern.matcher(accont.LastName_Native_1__c);
        result  = MyMatcher.matches();
        } 
        system.debug('cancelpop---'+cancelpop);
      //  system.debug()
        //if(!string.isBlank(loginmobile) && loginmobile!=null &&(( !string.ValueOf(loginmobile).startsWith('010')) || ( !loginmobile.startsWith('020')) || ( !loginmobile.startsWith('030')) || ( !loginmobile.startsWith('040')) || ( !loginmobile.startsWith('050')) || ( !loginmobile.startsWith('060'))  || ( !loginmobile.startsWith('070'))  || ( !loginmobile.startsWith('080')) ) )
    // if(!string.isBlank(loginmobile) && loginmobile!=null &&(( !string.ValueOf(loginmobile).startsWith('010')) || ( !string.ValueOf(loginmobile).startsWith('020')) || ( !string.ValueOf(loginmobile).startsWith('030')) || ( !string.ValueOf(loginmobile).startsWith('040')) || ( !string.ValueOf(loginmobile).startsWith('050')) || ( !string.ValueOf(loginmobile).startsWith('060'))  || ( !string.ValueOf(loginmobile).startsWith('070'))  || ( !string.ValueOf(loginmobile).startsWith('080')) ) )
      //!objPersonAccount.Home_Phone_2__c.startsWith('0')
      if(loginmobile !=null || loginmobile !='')
      {
      Newpopup=true;
      }
      if(!string.isBlank(loginmobile) && loginmobile!=null && ( !loginmobile.startsWith('010') && !loginmobile.startsWith('020') &&  !loginmobile.startsWith('030')  &&  !loginmobile.startsWith('040')  &&  !loginmobile.startsWith('050')  && !loginmobile.startsWith('060')  && !loginmobile.startsWith('070')  &&  !loginmobile.startsWith('080') &&  !loginmobile.startsWith('090')))
        {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Please_Input_Proper_Number));
            return null;
        }
        
        if( (MyMercEmail == NULL || string.isBlank(MyMercEmail))  && (loginmobile == NULL  || string.isBlank(loginmobile))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Please_Input_MyMercedes_Email_Id_or_Login_Mobile));
            return null;
        }
        else if(!string.isBlank(MyMercEmail) ){// && (!MyMercEmail.endsWith('.com') || !MyMercEmail.contains('@'));
            //String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!{}+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
            
            String CharSplit = MyMercEmail.substringBefore('@');
            System.debug('+++++Split+++++++++++'+CharSplit );
            
            Integer result = CharSplit.length();
            System.debug('+++++++result +++++++++++'+result);
            
            Boolean dotCheck = CharSplit.startsWith('.'); 
            System.debug('+++++++dotCheck+++++++++++'+dotCheck);   
            
                     
            if(result > 64 || dotCheck == true || MyMercEmail.contains('.@')  || MyMercEmail.contains('@.') || MyMercEmail.contains('..')  || MyMercEmail.length() >80){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.please_enter_valid_Email));
                return null;
            
            }
            Pattern MyPatternn = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPatternn.matcher(MyMercEmail);
            
           
            if (!MyMatcher.matches() ){ 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.please_enter_valid_Email));
                return null;    
            } else{ 
            accont.Email3__c  = MyMercEmail;
           
        }
        }
        if(!string.isBlank(loginmobile))
        {
         accont.Mobile_3__c = loginmobile;
        }
        
        if(accont.recordtypeid == System.Label.PersonAccount_Record_Type_From_Account ) {
              
              
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
                 
                 if(cancelpop == true && accont !=null)
                 {
                  update accont;
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Records_Updated));
                 }
             
            
        }
       }
       catch(exception e){
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
       }
       
        
           /* else {
             accont.Portal_Apply_Date__c = system.today();
             accont.Portal_Apply_Status__c = 'To be Sent';
             accont.Portal_Apply_User__c = userinfo.getUserid();
             update accont;
         } */
                     
         System.debug('^&^&^&^&^&^&^&^&^&^'+cancelpop);
         if(cancelpop == true)
         {
         pagereference pr = new pagereference ('/'+Accid);
         pr.setRedirect(true);
         return pr;
         }
         if(cancelpop == false)
         {
          System.debug('^&^&^&^&^&^&^&^&^&^'+cancelpop);
        pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
         pr.setRedirect(true);
         return pr;
         }
         else 
         {
          System.debug('^&^&^&^&^&^&^&^&^&^'+cancelpop);
         pagereference pr = new pagereference ('/apex/CustomerMymercInterface?id='+Accid);
         pr.setRedirect(true);
         return pr;
         }
         
         
         
       }
     
    public pagereference saveAndReturn(){
        pagereference pr = new pagereference ('/'+Account.id);
        pr.setRedirect(true);
        return pr;
    }
    
}