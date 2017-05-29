/**********************************************************************************
    JIRA NO: SFDC-1416, SFDCJP-2101, SFDCJP-2519
    Last Modified By : Lokesh M
    Last modified date : 23-May-2017
**********************************************************************************/

public with sharing class SendToMyMercController {
    
    list<Account> Accupdate; 
    public List<AccountWrapper> lstAccountWrapper{get;set;}
    public Vehicle__c vehicleRecord;
    public list<Vehicle_Relationship__c> Vehupdate;
    public list<Vehicle_Relationship__c> AccVehupdate;
    public boolean VisibleInMerc{get;set;}
    public set<Id> accset;
    public set<Id> Vehset;
    public id vehpageid;
    public Id IndividualCustomerExternaLink;
    public Id AccCom;
    public Id Person;
    public Id vehRelType;
    public Boolean result; 
    public string emai3;
    public String FinalEmail{get;set;}
    public ID VIDs;
    public Vehicle_Relationship__c lstVinfo{get;set;}
    public boolean displayPopup {get; set;} 
    public static User usr = new user();
    
    public SendToMyMercController(ApexPages.StandardController controller) {
        vehpageid = ApexPages.currentPage().getParameters().get('id');
        vehicleRecord = (Vehicle__c)controller.getRecord();
        RecordType rec = [select id from RecordType where sObjecttype = 'Account_Link__c' AND Name = 'Individual Customer External Link' limit 1];
        IndividualCustomerExternaLink = rec.Id;
        RecordType recPerson = [select id from RecordType where sObjecttype = 'Account' AND Name = 'Person Account' limit 1];
        Person = recPerson.Id;
        RecordType vehRelRecType = [select id,name from RecordType where sObjecttype = 'vehicle_relationship__c' AND Name = 'Vehicle Relationship'];
        vehRelType = vehRelRecType.Id;
        accountRelatedData();
    }
    
    private List<AccountWrapper> accountRelatedData(){ 
        lstAccountWrapper = new List<AccountWrapper>();
        Set<ID> setAccountID = new Set<ID>();
        Map<ID,String> mapAccount = new Map<Id,String>();
        Map<ID,string> accountLinkId = new Map<Id,string>();
        List<Vehicle_Relationship__c> lstVehicle_Relationship = [SELECT Id,Contact__c,Retail_Contact__r.toRole__c,Retail_Contact__r.system__c,Contact__r.Email__c,Retail_Contact__r.Portal_Email__c ,Retail_Contact__r.Primary__c,Retail_Contact__r.RecordtypeId,Car_Relation__c,Retail_Contact__r.Name,Contact__r.email2__c, Contact__r.Name,Contact__r.Opt_Out_Portal_Reason__c,Contact__r.Email3__c,Portal_Visiblity__c FROM Vehicle_Relationship__c where Vehicle_ID__c=:vehicleRecord.ID AND End_Date__c = null AND RecordtypeId =: vehRelType];
        System.debug('========vR'+lstVehicle_Relationship);
        for(Vehicle_Relationship__c vch:lstVehicle_Relationship){
            setAccountID.add(vch.Contact__c);
        }
        for(Account eachAccount:[SELECT Id,Name,(SELECT Id,name,toRole__c From Account_Links__r where RecordtypeId =: IndividualCustomerExternaLink AND System__c = 'My Mercedes' AND Primary__c = True) from Account where ID IN:setAccountID] ){
            for(Account_Link__c eachLink : eachAccount.Account_Links__r){
                if( eachLink.toRole__c== eachAccount.Id )
                    accountLinkId.put(eachAccount.ID,eachLink.name);
                system.debug('!!!'+accountLinkId);
            }
            
        }
        Map<id,string> accountCarmap = new Map<id,string>();
        Set<id> uniqueids = new Set<id>();
        for(Vehicle_Relationship__c eachVRelationships:lstVehicle_Relationship){
            if(accountCarmap.containskey(eachVRelationships.contact__c))
                accountCarmap.put(eachVRelationships.contact__c,accountCarmap.get(eachVRelationships.contact__c)+'/'+eachVRelationships.Car_Relation__c);
            else
                accountCarmap.put(eachVRelationships.contact__c,eachVRelationships.Car_Relation__c);
        }
        
        for(Vehicle_Relationship__c eachVRelationships:lstVehicle_Relationship){
            if(String.isNotBlank(eachVRelationships.Retail_Contact__r.Portal_Email__c) && eachVRelationships.Retail_Contact__r.system__c== 'My Mercedes')
            {
                emai3= eachVRelationships.Retail_Contact__r.Portal_Email__c;
            }
            else
            {
                emai3= eachVRelationships.Contact__r.Email3__c;
            }
            if(eachVRelationships.Retail_Contact__r.RecordtypeId == IndividualCustomerExternaLink && eachVRelationships.Retail_Contact__r.Primary__c == true && eachVRelationships.Retail_Contact__r.toRole__c == eachVRelationships.Contact__c && eachVRelationships.Retail_Contact__r.system__c == 'My Mercedes')
            {
                if(!uniqueids.contains(eachVRelationships.Contact__c)) {
                    lstAccountWrapper.add(new AccountWrapper(eachVRelationships.ID,emai3,eachVRelationships.Contact__r.Email__c,eachVRelationships.Contact__r.Name,eachVRelationships.Retail_Contact__r.Name,eachVRelationships.Contact__r.email2__c,accountCarmap.get(eachVRelationships.Contact__c),eachVRelationships.Contact__r.Opt_Out_Portal_Reason__c,eachVRelationships.Contact__c,eachVRelationships.Id,eachVRelationships.Portal_Visiblity__c));
                    uniqueids.add(eachVRelationships.Contact__c);
                }
            }
            else{
                if(!uniqueids.contains(eachVRelationships.Contact__c)) {
                    lstAccountWrapper.add(new AccountWrapper(eachVRelationships.ID,emai3,eachVRelationships.Contact__r.Email__c,eachVRelationships.Contact__r.Name,accountLinkId.get(eachVRelationships.Contact__c),eachVRelationships.Contact__r.email2__c,accountCarmap.get(eachVRelationships.Contact__c),eachVRelationships.Contact__r.Opt_Out_Portal_Reason__c,eachVRelationships.Contact__c,eachVRelationships.Id,eachVRelationships.Portal_Visiblity__c));
                    uniqueids.add(eachVRelationships.Contact__c);
                }
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
        lstVinfo= [SELECT Id,Retail_Contact__r.toRole__c,Retail_Contact__r.system__c,Contact__r.Email__c,Retail_Contact__r.Portal_Email__c ,Retail_Contact__r.Primary__c,Retail_Contact__r.RecordtypeId,Car_Relation__c,Retail_Contact__r.Name,Contact__r.email2__c, Contact__r.Name,Contact__r.Opt_Out_Portal_Reason__c,Contact__r.Email3__c,Portal_Visiblity__c FROM Vehicle_Relationship__c where ID=:VID AND recordtypeId =: vehRelType];
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
        map<id,string> email3update = new map<id,string>();
        map<id,boolean> visiblemap = new map<id,boolean>();
        Map<Id,Account> myMercAcc = new Map<Id,Account>();
        Map<Id,Account> nonMyMercAcc = new Map<Id,Account>();
        Map<Id,Account_Link__c> idAccLinkMap = new Map<Id,Account_Link__c>();
        accset = new set<Id>();
        Vehset = new set<id>();
        list<Vehicle_Relationship__c> vehfinal = new list<Vehicle_Relationship__c>();
        list<Vehicle_Relationship__c> AccVehfinal = new list<Vehicle_Relationship__c>();
        Map<Id,String> accIdReasonMap = new Map<Id,String>();
        Map<Id,Account> accfinal = new Map<Id,Account>();
        List<Account_Link__c> accLinkFinal = new List<Account_Link__c>();
        PageReference pr = null;
        Boolean reason = false;
        Boolean reasonNonMerc = false;
        Boolean emptyMail = false;
        Boolean personBirthDate = false;
        Set<Id> accountMainDealer = new Set<Id>();//To update the Main_dealer__C on account if my merc id is blank for Dealers
        
        if(lstAccountWrapper != null && !lstAccountWrapper.isEmpty()){
            for(AccountWrapper obj: lstAccountWrapper){
                if(obj.isSelect == false && String.isBlank(obj.OptOutReason) && String.isBlank(obj.vehicleRelationship)){
                    reason = true;
                }
                else if(Obj.isSelect == false && !String.isBlank(obj.OptOutReason) && String.isBlank(obj.vehicleRelationship)){
                    System.debug('nonselectaccountreason'+obj.accountid+'reason'+obj.optoutreason);
                    accIdReasonMap.put(obj.AccountId,obj.OptOutReason);     
                }
                if(obj.isSelect == true && String.isBlank(Obj.PortalEmail)){
                    emptyMail = true;
                }
                else if(obj.isSelect == true && !String.isBlank(Obj.PortalEmail)){
                   if(String.isBlank(obj.vehicleRelationship) && userinfo.getUserType()=='PowerPartner'){
                       accountMainDealer.add(obj.AccountId);
                       system.debug('acctmaindealer'+accountmaindealer);
                   }
                    Vehset.add(obj.VehRelId);
                    visiblemap.put(obj.AccountId,obj.isVisible);
                    accset.add(obj.AccountId);                       
                    email3update.put(obj.AccountId,obj.PortalEmail);
                }
            }  
        }
        if(Reason == false && emptyMail == false){
            System.debug('accIdReasonMap'+accIdReasonMap);
            if(accIdReasonMap != NULL && !accIdReasonMap.isEmpty()){
                for(Account eachAccount : [SELECT Id,Portal_Apply_Status__c,Portal_Apply_Date__c ,Portal_Apply_User__c ,Opt_Out_Portal_Reason__c from Account where ID IN: accIdReasonMap.keySet()] ){
                    System.debug('========'+ accIdReasonMap.get(eachAccount.Id));
                    system.Debug('=='+eachAccount.Id);
                    eachAccount.Opt_Out_Portal_Reason__c = accIdReasonMap.get(eachAccount.Id);
                    eachAccount.Portal_Apply_Status__c= 'Reject';
                    eachAccount.Portal_Apply_Date__c = System.today();
                    eachAccount.Portal_Apply_User__c = userinfo.getUserId();
                    accFinal.put(eachAccount.Id,eachAccount);      
                }
                for(Vehicle_RelationShip__c eachVr : [select Portal_Apply_Status__c,Portal_Apply_User__c,Contact__c,Portal_Apply_Date__c from Vehicle_Relationship__c where Contact__c =: accIdReasonMap.keySet() AND Vehicle_Id__c =:vehpageid AND RecordtypeId =: vehRelType]){
                    eachVr.Portal_Apply_Date__c = system.Today();
                    eachVr.Portal_Apply_Status__c = 'Reject';
                    eachVr.Portal_Apply_User__c = userinfo.getUserid();
                    AccVehfinal.add(eachVr);    
                }   
            }
            if(accset !=null && !accset.isEmpty() ){
                for(Account eachAcc : [select id,Allow_Data_Sharing2__c,Data_Source__C,Portal_Apply_Status__c,Main_Dealer__c,recordtypeid,Email3__c,PersonBirthdate,Gender__c ,LastName_Native_1__c,(SELECT Id,name,toRole__c,Portal_Email__c,System__c,RecordtypeId,Primary__c From Account_Links__r),Portal_Apply_Date__c,Portal_Apply_User__c  from account where Id In: accset]){
                    for(Account_link__c accLink : eachAcc.Account_Links__r){
                        if(accLink.RecordTypeId == IndividualCustomerExternaLink && accLink.System__c == 'My Mercedes' && accLink.toRole__c == eachAcc.Id && accLink.Primary__c == True){
                            myMercAcc.put(eachAcc.Id,eachAcc);
                            idAccLinkMap.put(eachAcc.Id,accLink);
                        }
                    }
                    if(!myMercAcc.containsKey(eachAcc.Id)){
                        nonMyMercAcc.put(eachAcc.Id,eachAcc);        
                    }
                    System.debug('SelectedAccountBirthdAte'+eachAcc.PersonBirthdate);
                    System.debug('===='+eachAcc.LastName_Native_1__c);
                    System.debug('===='+eachAcc.RecordTypeId);
                    if(eachAcc.PersonBirthdate == null || String.isBlank(eachAcc.LastName_Native_1__c) || eachAcc.Gender__c == NULL){
                        personBirthdate = true;    
                    }
                    System.debug('===='+personBirthdate);
                }
                
                if(personBirthdate == false){
                    usr = [Select Id,name,contact.AccountId from User WHERE ID = :UserInfo.getUserId() ];
                    for(Account acc : myMercAcc.values()){
                        acc.Email3__c = email3update.get(acc.Id);
                        idAccLinkMap.get(acc.Id).Portal_Email__C = email3update.get(acc.Id);
                        accfinal.put(acc.Id, acc);
                        accLinkFinal.add(idAccLinkMap.get(acc.Id));
                    }
                    System.debug('nonMyMercAcc'+nonMyMercacc.size());
                    for(Account acct : nonMyMercAcc.values()){ 
                        System.debug('accountMainDealer.contains'+accountMainDealer.contains(acct.Id));
                        if(accountMainDealer.contains(acct.Id)){
                            System.debug('usr.contact.AccountId'+usr.contact.AccountId);
                            if(acct.Main_Dealer__c == NULL )
                            acct.Main_Dealer__c = usr.contact.AccountId;
                        }
                        if(acct.Allow_Data_Sharing2__c == 'No' && acct.Data_Source__C == 'Dealer Outlet'){
                             acct.Allow_Data_Sharing2__c= 'Yes';
                             acct.Data_Source__C = 'My Mercedes';
                        }
                        acct.Portal_Apply_Status__c = 'To be Sent';
                        acct.Portal_Apply_Date__c = System.today();
                        acct.Portal_Apply_User__c = userinfo.getUserId();
                        acct.Email3__c = email3update.get(acct.Id);
                        accfinal.put(acct.Id,acct);
                    }
                    AccVehupdate = [select Portal_Apply_Status__c,Portal_Apply_User__c,Contact__c,Portal_Apply_Date__c from Vehicle_Relationship__c where Contact__c =: accset AND End_Date__c = Null AND RecordtypeId =: vehRelType];
                    if(AccVehupdate != null && !AccVehupdate.isEmpty() )
                    {
                        for(Vehicle_Relationship__c ac:AccVehupdate ){
                            ac.Portal_Apply_Date__c = system.Today();
                            ac.Portal_Apply_Status__c = 'To be Sent';
                            ac.Portal_Apply_User__c = userinfo.getUserid();
                            /**commenting as per sfdcjp-2519
                            if(visiblemap.get(ac.Contact__c) == true)
                                ac.Portal_Visiblity__c = True;
                            **/
                            AccVehfinal.add(ac);
                        }
                    }
                }
                
            }
            if(personBirthdate){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Mandatory fields on Account - Birthdate,LastNameNative,Gender'));    
            }        
            else if(accfinal != null && !accfinal.isEmpty()){
                update accfinal.values();
                if(accLinkFinal != NULL && !accLinkFinal.isEmpty()){
                    update accLinkFinal;
                }
                if(AccVehfinal != null && !AccVehfinal.isEmpty() ){
                    update AccVehfinal;
                }
                 pr = new PageReference('/'+vehpageid);
                 pr.setRedirect(true);
            }
        }
        else if(emptyMail){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter My Merc Email Id for selected Account'));
        }
        else if(reason){
            ApexPages.addmessage(new apexpages.message(Apexpages.severity.warning,'Please enter Reason for Non-selected Non-Mymercedes acccount'));
        }
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
        public boolean isVisible{get;set;}
        public Id AccountId {set;get;}
        public ID VID{get;set;}
        public Id VehRelId;
        public AccountWrapper(Id VIDVar,String PortalEmailVar,String personalEmailVar,String accountDataVar,String vehicleRelationshipVar,String accountLinkVar,string carrel,string reson,Id accid,Id vehid,boolean isMyMercVis){
            accountData = accountDataVar;
            vehicleRelationship = vehicleRelationshipVar;
            accountLink = accountLinkVar;
            CarRelation = carrel;
            OptOutReason = reson;
            AccountId = accid;
            VehRelId = vehid;
            isSelect = false;
            personalEmail = personalEmailVar;
            isVisible = isMyMercVis;
            accountLink = accountLinkVar;
            PortalEmail = PortalEmailVar;
            VID = VIDVar;  
        }
    }    
}