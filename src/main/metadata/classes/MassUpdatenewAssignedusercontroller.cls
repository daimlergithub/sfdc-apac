public with sharing class MassUpdatenewAssignedusercontroller 
{

    public MassUpdatenewAssignedusercontroller(){
    accUsr= new Account();
    usr= new user();
    NewAsignUsr= new Account();
    } 

    public Account accUsr{get;set;}
    public Account NewAsignUsr{get;set;}
    public user usr{get;set;}
    public List<WrapperMassUpdate> accountList;
    public List<WrapperMassUpdate> LeadList;
    public List<WrapperMassUpdate> vehicleList;
    public List<WrapperMassUpdate> caseList;
    Public List<User> userlst;
    
    public List<WrapperMassUpdate> getLeads() {
        LeadList = new List<WrapperMassUpdate>();
        for(Lead__c ld :[SELECT ID,Name,ownerID  FROM Lead__c WHERE Ownerid=:accUsr.OwnerId LIMIT 10]){
        system.debug('Lead Records are:'+ld);
        LeadList.add(new WrapperMassUpdate(ld));        
        }
        return LeadList ;
    }
    
    public List<WrapperMassUpdate> getCases(){
        caseList = new List<WrapperMassUpdate>();
        for(Case cs : [select Id,CaseNumber, OwnerID from case WHERE OwnerId =: accUsr.OwnerId]){
            System.debug('Case Records'+ cs);
            caseList.add(new WrapperMassUpdate(cs));
        }
        return caseList;
    }

    public List<WrapperMassUpdate> getVehicles() {
     vehicleList = new List<WrapperMassUpdate>();
        for(Vehicle__c acc : [SELECT ID,Name,ownerID  FROM Vehicle__c WHERE Ownerid=:accUsr.OwnerId  Limit 10]){
            vehicleList .add(new WrapperMassUpdate(acc));
        }    
        return vehicleList ;
    }


    public List<WrapperMassUpdate> getAccounts() {
         accountList = new List<WrapperMassUpdate>();
        for(Account acc : [SELECT ID,Phone,ownerID FROM Account WHERE Ownerid=:accUsr.OwnerId  Limit 10]){
            accountList.add(new WrapperMassUpdate(acc));
        }    
        return accountList;
    }
    Public List<User> getUserDetails(){
        userlst = new List<user>();
        if(NewAsignUsr.Portal_Apply_User__c!=null){
            for(User usr: [SELECT iD,Firstname,lastName,Email,ProfileiD FROM User WHERE id=:NewAsignUsr.Portal_Apply_User__c]){
            userlst.add(usr);    
            }
        }
        system.debug('User details-->'+userlst);
        return userlst;
    }
    public void disPlayNewAssignUserInfo(){
    system.debug('Welcome to user:'+NewAsignUsr.Portal_Apply_User__c);
    if(NewAsignUsr.Portal_Apply_User__c!=null){
    usr=[SELECT iD,Firstname,lastName ,Email,ProfileiD,userName FROM User WHERE id=:NewAsignUsr.Portal_Apply_User__c];
    }
    }
    public void getFields() {
        getAccounts();
        getVehicles();
        getLeads();
        getUserDetails();
         
    }
    public class WrapperMassUpdate{
        public Account acc{get;set;}
        public Vehicle__c veh{get;set;}
        public Lead__c led{get;set;}
        public case cse{get;set;}
        public Boolean selected{get;set;}
        
        public WrapperMassUpdate(Account a){
        acc = a;
        //veh = (Vehicle__c)a;
       // led = (Lead__c)a;
        selected = False;
        }
         public WrapperMassUpdate(Vehicle__c vh){
        //acc = (Account)a;
        veh = vh;
       // led = (Lead__c)a;
        selected = False;
        }
         public WrapperMassUpdate(SObject a){
        //acc = (Account)a;
        //veh = (Vehicle__c)a;
        led = (Lead__c)a;
        selected = False;
        }
        public WrapperMassUpdate(case cs){
            cse =  cs;
            selected = false;  
        }
    }
    
    public void massUpdateNewAssign() {
    if(NewAsignUsr.Portal_Apply_User__c!=null){
    User usr = [SELECT iD,Firstname,lastName FROM User WHERE id=:NewAsignUsr.Portal_Apply_User__c];
    
    system.debug('user record: '+usr);
    system.debug('user record: '+usr.id);

         List<Account> SelectedAccount =new List<Account>();
         List<Vehicle__c> SelectedVehicle =new List<Vehicle__c>();
         List<Lead__c> SelectedLead =new List<Lead__c>();
         List<case> Selectedcase =new List<case>();
         
         for(WrapperMassUpdate accupdte: accountList){
             if(accupdte.selected==true){
                 SelectedAccount.add(accupdte.acc);
             }
         }
         
         List<Account>UpdateAcc = New List<Account>();
         for(Account acc:SelectedAccount){
             acc.ownerid=usr.id;
             UpdateAcc.add(acc);
         }
         if(!UpdateAcc.isempty()){
         update UpdateAcc;
         }
         List<Vehicle__c> UpdateVehicle = new List<Vehicle__c>();
         for(WrapperMassUpdate vechupdt: vehicleList ){
             if(vechupdt.selected==true){
                 SelectedVehicle.add(vechupdt.veh);             
             }
         }
         for(vehicle__c vh :SelectedVehicle ){
             vh.ownerid=usr.id;
             UpdateVehicle.add(vh);
         }
         List<Lead__c> Updatelead = new List<Lead__c>();
         for(WrapperMassUpdate leadupdte: LeadList ){
             if(leadupdte.selected==true){
                 SelectedLead.add(leadupdte.led);
             }
         }
         
         for(Lead__c lf: SelectedLead){
         lf.ownerid=usr.id;
         Updatelead.add(lf);
         }
         
         List<case> Updatecase = new List<case>();
         for(WrapperMassUpdate caseupdte: caseList){
             if(caseupdte.selected==true){
                 Selectedcase.add(caseupdte.cse);
             }
         }
         
         for(case cs: Selectedcase){
         cs.ownerid=usr.id;
         Updatecase.add(cs);
         }
         
         if(!Updatecase.isEmpty()){
             update Updatecase;
         }
         
         if(!UpdateVehicle.isEmpty()){
         update UpdateVehicle;
         }
         if(!Updatelead.isEmpty()){
         update Updatelead;
         }   
         }
    }
    
    

}