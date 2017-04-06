public without sharing class MassUpdatenewAssignedusercontroller 
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
        System.debug('&&*&*&&*&*&*& accUsr.OwnerId'+accUsr.OwnerId);
        if(accUsr.OwnerId !=null)
        {
        for(Lead__c ld :[SELECT ID,Name,ownerID,Service_Advisor__c  FROM Lead__c WHERE Service_Advisor__c=:accUsr.OwnerId]){
        system.debug('Lead Records are:'+ld);
        LeadList.add(new WrapperMassUpdate(ld));        
        }
        }
        return LeadList ;
    }
    
    public List<WrapperMassUpdate> getCases(){
    System.debug('&&*&*&&*&*&*& accUsr.OwnerId'+accUsr.OwnerId);
        caseList = new List<WrapperMassUpdate>();
        if(accUsr.OwnerId !=null)
        {
        for(Case cs : [select Id,CaseNumber,Case_Dealer_User__c, OwnerID from case WHERE Case_Dealer_User__c=: accUsr.OwnerId]){
            System.debug('Case Records'+ cs);
            caseList.add(new WrapperMassUpdate(cs));
        }
        }
        return caseList;
    }

    public List<WrapperMassUpdate> getVehicles() {
     vehicleList = new List<WrapperMassUpdate>();
     if(accUsr.OwnerId !=null)
        {
        for(Account_Link__c acc : [SELECT ID,Name,torole__c,Service_Advisor__c,VIN__c,ownerID  FROM Account_Link__c WHERE Service_Advisor__c=:accUsr.OwnerId ]){
            vehicleList .add(new WrapperMassUpdate(acc));
        }    
        }
        return vehicleList ;
    }


    public List<WrapperMassUpdate> getAccounts() {
         accountList = new List<WrapperMassUpdate>();
         if(accUsr.OwnerId !=null)
        {
        for(Account_Link__c acc : [SELECT ID,Name,OwnerId ,Retail_Sales_Consultant__c,toRole__c FROM Account_Link__c WHERE Retail_Sales_Consultant__c=:accUsr.OwnerId  ]){
            accountList.add(new WrapperMassUpdate(acc));
        }    
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
        public Account_Link__c acc{get;set;}
        public Account_Link__c veh{get;set;}
        public Lead__c led{get;set;}
        public case cse{get;set;}
        public Boolean selected{get;set;}
        
        public WrapperMassUpdate(Account_Link__c a){
        acc = a;
        //veh = (Vehicle__c)a;
       // led = (Lead__c)a;
        selected = False;
        }
         public WrapperMassUpdate(SObject vh){
        //acc = (Account)a;
        veh = (Account_Link__c)vh;
       // led = (Lead__c)a;
        selected = False;
        }
         public WrapperMassUpdate(Lead__c a){
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

         List<Account_Link__c> SelectedAccount =new List<Account_Link__c>();
         List<Account_Link__c> SelectedVehicle =new List<Account_Link__c>();
         List<Lead__c> SelectedLead =new List<Lead__c>();
         List<case> Selectedcase =new List<case>();
         
         for(WrapperMassUpdate accupdte: accountList){
             if(accupdte.selected==true){
                 SelectedAccount.add(accupdte.acc);
             }
         }
         
         List<Account_Link__c> UpdateAcc = New List<Account_Link__c>();
         for(Account_Link__c acc:SelectedAccount)
         {
             acc.Retail_Sales_Consultant__c=usr.id;
             UpdateAcc.add(acc);
         }
         if(!UpdateAcc.isempty()){
         update UpdateAcc;
         }
         List<Account_Link__c> UpdateVehicle = new List<Account_Link__c>();
         for(WrapperMassUpdate vechupdt: vehicleList ){
             if(vechupdt.selected==true){
                 SelectedVehicle.add(vechupdt.veh);             
             }
         }
         for(Account_Link__c vh :SelectedVehicle ){
             vh.Service_Advisor__c=usr.id;
             UpdateVehicle.add(vh);
         }
         List<Lead__c> Updatelead = new List<Lead__c>();
         for(WrapperMassUpdate leadupdte: LeadList ){
             if(leadupdte.selected==true){
                 SelectedLead.add(leadupdte.led);
             }
         }
         
         for(Lead__c lf: SelectedLead){
         lf.Service_Advisor__c=usr.id;
         Updatelead.add(lf);
         }
         
         List<case> Updatecase = new List<case>();
         for(WrapperMassUpdate caseupdte: caseList){
             if(caseupdte.selected==true){
                 Selectedcase.add(caseupdte.cse);
             }
         }
         
         for(case cs: Selectedcase){
         cs.Case_Dealer_User__c=usr.id;
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