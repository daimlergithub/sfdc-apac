public with sharing class SendToMyMercController {
        
        list<Account> Accupdate; 
        public List<AccountWrapper> lstAccountWrapper{get;set;}
        public Vehicle__c vehicleRecord;
        public list<Vehicle_Relationship__c> Vehupdate;
        public list<Vehicle_Relationship__c> AccVehupdate;
        public boolean ApplyToMerc{get;set;}//VisibleInMerc
        public boolean VisibleInMerc{get;set;}
        public set<Id> accset;
        public set<Id> Vehset;
        public id vehpageid;
        public Id IndividualCustomerExternaLink;
        public Id AccCom;
        public Id Person;
        public Boolean result; 
        public string emai3;
        public String FinalEmail{get;set;}
        public ID VIDs;
        public Vehicle_Relationship__c lstVinfo{get;set;}
        public String emailRegEx = '[ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ－ー]+';
        public boolean displayPopup {get; set;} 
        
        public SendToMyMercController(ApexPages.StandardController controller) {
            vehpageid = ApexPages.currentPage().getParameters().get('id');
            vehicleRecord = (Vehicle__c)controller.getRecord();
            RecordType rec = [select id from RecordType where sObjecttype = 'Account_Link__c' AND Name = 'Individual Customer External Link' limit 1];
            IndividualCustomerExternaLink = rec.Id;
            RecordType recCom = [select id from RecordType where sObjecttype = 'Account' AND Name = 'Company' limit 1];
            AccCom = recCom.Id;
            RecordType recDelar = [select id from RecordType where sObjecttype = 'Account' AND id = '012280000000f14AAA' limit 1];
            Person = recDelar.Id;
            accountRelatedData();
        }
        
        private List<AccountWrapper> accountRelatedData(){ 
            lstAccountWrapper = new List<AccountWrapper>();
            Set<ID> setAccountID = new Set<ID>();
            Map<ID,String> mapAccount = new Map<Id,String>();
            Map<ID,string> accountLinkId = new Map<Id,string>();
            List<Vehicle_Relationship__c> lstVehicle_Relationship = [SELECT Id,Retail_Contact__r.toRole__c,Retail_Contact__r.system__c,Contact__r.Email__c,Retail_Contact__r.Portal_Email__c ,Retail_Contact__r.Primary__c,Retail_Contact__r.RecordtypeId,Car_Relation__c,Retail_Contact__r.Name,Contact__r.email2__c, Contact__r.Name,Contact__r.Opt_Out_Portal_Reason__c,Contact__r.Email3__c,Portal_Visiblity__c FROM Vehicle_Relationship__c where Vehicle_ID__c=:vehicleRecord.ID AND End_Date__c = null];
           
            for(Vehicle_Relationship__c vch:lstVehicle_Relationship){
                setAccountID.add(vch.Contact__c);
            }
            for(Account eachAccount:[SELECT Id,Name,(SELECT Id,name,toRole__c From Account_Links__r where RecordtypeId =: IndividualCustomerExternaLink AND System__c = 'My Mercedes' AND Primary__c = True) from Account where ID IN:setAccountID] ){
                for(Account_Link__c eachLink:eachAccount.Account_Links__r){
                    if( eachLink.toRole__c== eachAccount.Id )
                    accountLinkId.put(eachAccount.ID,eachLink.name);
                system.debug('!!!'+accountLinkId);
                }
                
            }
            boolean cb;
            
            for(Vehicle_Relationship__c eachVRelationships:lstVehicle_Relationship){
                
                if(String.isNotBlank(eachVRelationships.Retail_Contact__r.Name) &&eachVRelationships.Retail_Contact__r.system__c== 'My Mercedes' && eachVRelationships.Retail_Contact__r.Primary__c== true && eachVRelationships.Retail_Contact__r.toRole__c == eachVRelationships.Contact__c)
                 {
                    cb = true;
                }
            else
            {
                cb = false;
            }
            
               if(String.isNotBlank(eachVRelationships.Retail_Contact__r.Portal_Email__c))
                 {
                    emai3= eachVRelationships.Retail_Contact__r.Portal_Email__c;
                }
            else
            {
                emai3= eachVRelationships.Contact__r.Email3__c;
            }
            
            if(eachVRelationships.Retail_Contact__r.RecordtypeId == IndividualCustomerExternaLink && eachVRelationships.Retail_Contact__r.Primary__c == true && eachVRelationships.Retail_Contact__r.toRole__c == eachVRelationships.Contact__c && eachVRelationships.Retail_Contact__r.system__c == 'My Mercedes')
            {
                    
                    lstAccountWrapper.add(new AccountWrapper(eachVRelationships.ID,emai3,eachVRelationships.Contact__r.Email__c,eachVRelationships.Contact__r.Name,eachVRelationships.Retail_Contact__r.Name,eachVRelationships.Contact__r.email2__c,eachVRelationships.Car_Relation__c,eachVRelationships.Contact__r.Opt_Out_Portal_Reason__c,eachVRelationships.Contact__c,eachVRelationships.Id,cb,eachVRelationships.Portal_Visiblity__c));
                }
                else{
                    
                    lstAccountWrapper.add(new AccountWrapper(eachVRelationships.ID,emai3,eachVRelationships.Contact__r.Email__c,eachVRelationships.Contact__r.Name,accountLinkId.get(eachVRelationships.Contact__c),eachVRelationships.Contact__r.email2__c,eachVRelationships.Car_Relation__c,eachVRelationships.Contact__r.Opt_Out_Portal_Reason__c,eachVRelationships.Contact__c,eachVRelationships.Id,cb,eachVRelationships.Portal_Visiblity__c));
                }
            }
           
            return lstAccountWrapper;
        }
        public void closePopup()
        {  
            displayPopup = false;   
        }    
        public void showPopup()
        {      
            String VID = apexpages.currentpage().getParameters().get('recordID');  
           
            lstVinfo= [SELECT Id,Retail_Contact__r.toRole__c,Retail_Contact__r.system__c,Contact__r.Email__c,Retail_Contact__r.Portal_Email__c ,Retail_Contact__r.Primary__c,Retail_Contact__r.RecordtypeId,Car_Relation__c,Retail_Contact__r.Name,Contact__r.email2__c, Contact__r.Name,Contact__r.Opt_Out_Portal_Reason__c,Contact__r.Email3__c,Portal_Visiblity__c FROM Vehicle_Relationship__c where ID=:VID];
            
            if(String.isNotBlank(lstVinfo.Retail_Contact__r.Portal_Email__c)){
                FinalEmail = lstVinfo.Retail_Contact__r.Portal_Email__c;
                
            }
            else
            {
                FinalEmail = lstVinfo.Contact__r.Email3__c ;
                    
            
            }
            displayPopup = true; 
            
        } 
        
        public pagereference Submit(){
            map<id,string> reasonMap = new map<id,string>();//email3update
            map<id,string> email3update = new map<id,string>();
            map<id,boolean> visiblemap = new map<id,boolean>();
            accset = new set<Id>();
            Vehset = new set<id>();
            list<Vehicle_Relationship__c> vehfinal = new list<Vehicle_Relationship__c>();
            list<Vehicle_Relationship__c> AccVehfinal = new list<Vehicle_Relationship__c>();
            list<account> accfinal = new list<account>();
            PageReference pr = null;
            if(lstAccountWrapper != null && !lstAccountWrapper.isEmpty()){
               
                for(AccountWrapper obj: lstAccountWrapper){
                  
                    if(obj.isSelect){
                    if(obj.isMyMerc == false && String.isBlank(obj.OptOutReason))
                        {
                            
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter The Reason'));
                        }
                        //if(obj.vehicleRelationship != null)
                        //{
                            Vehset.add(obj.VehRelId);
                            
                            visiblemap.put(obj.AccountId,obj.isVisible);
                       // }
                        
                        accset.add(obj.AccountId);                       
                        reasonMap.put(obj.AccountId,obj.OptOutReason);
                        email3update.put(obj.AccountId,obj.PortalEmail);
                       
                    }
                                  
                
                }
                if(accset.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select Atleast One.'));
                }
                if(accset !=null && !accset.isEmpty() )// && Notregistered ==true 
                {
                     Accupdate = [select id,Portal_Apply_Status__c,Email2__c,PersonBirthdate,LastName_Native_1__c  from account where Id In: accset];
                     AccVehupdate = [select Portal_Apply_Status__c,Portal_Apply_User__c,Portal_Apply_Date__c from Vehicle_Relationship__c where Contact__c =: accset];
                }
                if(Vehset !=null && !Vehset.isEmpty()){
                    Vehupdate = [select id,Portal_Apply_User__c,Portal_Apply_Date__c,Contact__c,Portal_Visiblity__c from Vehicle_Relationship__c where Id In: Vehset];
                }
                
                if(Vehupdate != null && !Vehupdate.isEmpty() ){
                    for(Vehicle_Relationship__c veh:Vehupdate )
                    {
                        
                        veh.Portal_Apply_Date__c = system.Today();
                        veh.Portal_Apply_User__c = userinfo.getUserid();
                       
                        if(visiblemap.get(veh.Contact__c) == true)
                        veh.Portal_Visiblity__c = True;
                        vehfinal.add(veh);
                    }
                   
                if(vehfinal != null && !vehfinal.isEmpty()){
                    update vehfinal;
                   
                    pr = new PageReference('/'+vehpageid);
                                pr.setRedirect(true);
                  } 
                }
                
                  if(Accupdate != null && !Accupdate.isEmpty() )
                  {
                       
                        for(Account ac:Accupdate ){
                            
                            Pattern MyPattern = Pattern.compile(emailRegex);
                            if(!String.isBlank(ac.LastName_Native_1__c)){
                            Matcher MyMatcher = MyPattern.matcher(ac.LastName_Native_1__c);
                            result  = MyMatcher.matches();
                            }
                            if(ac.recordtypeid == AccCom){
                            if(!String.isBlank(ac.Email2__c)) // && ac.PersonBirthdate != null&& result == true
                            {  
                            
                                ac.Portal_Apply_Status__c = 'To be Sent';
                                ac.Opt_Out_Portal_Reason__c = reasonMap.get(ac.Id);
                                ac.Email3__c = email3update.get(ac.Id);
                                accfinal.add(ac);
                                
                            }
                            }
                            if(ac.recordtypeid == System.Label.PersonAccount_Record_Type_From_Account && ac.PersonBirthdate != null && result == true){
                            if(!String.isBlank(ac.Email2__c)) // && ac.PersonBirthdate != null&& result == true
                            {  
                            
                                ac.Portal_Apply_Status__c = 'To be Sent';
                                ac.Opt_Out_Portal_Reason__c = reasonMap.get(ac.Id);
                                ac.Email3__c = email3update.get(ac.Id);
                                accfinal.add(ac);
                                
                            }
                            }
                            
                        }
                    }   
                    
                        if(accfinal != null && !accfinal.isEmpty()){
                            update accfinal;
                            if(AccVehupdate != null && !AccVehupdate.isEmpty() )
                            {
                                for(Vehicle_Relationship__c ac:AccVehupdate ){
                                    ac.Portal_Apply_Date__c = system.Today();
                                    ac.Portal_Apply_Status__c = 'To be Sent';
                                    ac.Portal_Apply_User__c = userinfo.getUserid();
                                    AccVehfinal.add(ac);
                                }
                                if(AccVehfinal != null && !AccVehfinal.isEmpty() ){
                                    update AccVehfinal;
                                }
                                pr = new PageReference('/'+vehpageid);
                                pr.setRedirect(true);
                            }
                        }
                     else{
                            
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Mandate Fields In Accounts'));
                        }
        
            }
            return pr;
          }
          
          public pagereference cancel () 
          {
              pagereference pr = new pagereference ('/'+vehpageid);
              pr.setRedirect(true);
              return pr; 
          }
          
          public pagereference savepop()
          {
             
              Account acc = [SELECT id,Email__c,Email3__c,Email2__c from Account Where id=:lstVinfo.Contact__c];
             if(String.isNotBlank(lstVinfo.Retail_Contact__r.Portal_Email__c))
             {
                Account_Link__c aLink = [SELECT id,Portal_Email__c from Account_Link__c where ID=:lstVinfo.Retail_Contact__c];               
                aLink.Portal_Email__c = FinalEmail ;               
                Database.SaveResult results = Database.Update(aLink);
               
             }
            
              ACC.Email3__c  = FinalEmail ;
              
              ACC.Email2__c = lstVinfo.Contact__r.Email2__c;
              ACC.Email__c= lstVinfo.Contact__r.Email__c;
              Database.SaveResult results = Database.Update(ACC);
              displayPopup = false;  
              
               pagereference pr = new pagereference ('/apex/SendVehicleInfoMyMercedes?id='+vehpageid);
              pr.setRedirect(true);
              return pr;
              
          }
        
        public class AccountWrapper{
            public String accountData{get;set;}
            public String vehicleRelationship{get;set;}
            public String accountLink{get;set;}
            public String CarRelation{get;set;}//OptOutReason 
            public String OptOutReason{get;set;}
            public String PortalEmail {get;set;}
            public String personalEmail {get;set;}
            public boolean isSelect{get;set;}
            public boolean isMyMerc{get;set;}
            public boolean isVisible{get;set;}
            public Id AccountId;
            public ID VID{get;set;}
            public Id VehRelId;
            public AccountWrapper(Id VIDVar,String PortalEmailVar,String personalEmailVar,String accountDataVar,String vehicleRelationshipVar,String accountLinkVar,string carrel,string reson,Id accid,Id vehid,boolean isMyMercVar,boolean isMyMercVis){
                accountData = accountDataVar;
                vehicleRelationship = vehicleRelationshipVar;
                accountLink = accountLinkVar;
                CarRelation = carrel;
                OptOutReason = reson;
                AccountId = accid;
                VehRelId = vehid;
                isSelect = false;
                isMyMerc = isMyMercVar;
                personalEmail = personalEmailVar;
                isVisible = isMyMercVis;
                accountLink = accountLinkVar;
                PortalEmail = PortalEmailVar;
                VID = VIDVar;
            }
        }    
    }