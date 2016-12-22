/*
  Description : This Class will assigen the leads to Dealers
  DevItem : P3.
  Created By: Kiran
  Date: 2016-12-20
*/  
public class LeadDealerAssignmentProcess{

    public LeadDealerAssignmentProcess(ApexPages.StandardController controller) {
        
    }

    public boolean isAvailable {get;set;}
    public String userid1 { get;set; }
    Public string leadid= ApexPages.CurrentPage().getParameters().get('id');
    public Lead__c led {get;set;}
    List<User> UserDealers = new List<User>();
    public list<Wrapperuser> getDealerAssignment(){
        isAvailable = true;
       List<Wrapperuser> listwrapperuser= new list<Wrapperuser>();
        Lead__c leadslist = [select id, Name, Assigned_Dealer__c,Service_Advisor__c, Assigned_Dealer__r.Dealer_Sales_Manager__c,RecordType.DeveloperName from Lead__c WHERE id = : leadid LIMIT 1];
        System.debug('Record Type Name>>>>>>' + leadslist.RecordType.DeveloperName);
       if(leadslist.RecordType.DeveloperName == 'Sales_Leads') {
      
        UserDealers  = [select Id, Name, Title, Dealer_Title__c, Dealer_Outlet_Name__c,IsActive, CompanyName, Email 
                                    ,contactId,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from User WHERE IsActive=true  AND Contact.AccountId=:leadslist.Assigned_Dealer__c AND Profile.Name ='Japan Dealer Sales Representative'];
              try
        {
           Account_Link__c accLink = [select id, Name, Sales_Representative__c,toRole__c from Account_Link__c WHERE toRole__c =: leadslist.Assigned_Dealer__c  LIMIT 1];
            if (acclink!=null && acclink.Sales_Representative__c!= null){
                userid1 = acclink.Sales_Representative__c;
            }
        }
        catch(Exception ex)
        {
            
        }
        }
        else if(leadslist.RecordType.DeveloperName == 'Aftersales_Leads'){
            UserDealers  = [select Id, Name, Title, Dealer_Title__c, Dealer_Outlet_Name__c,IsActive, CompanyName, Email 
                                    ,contactId,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from User WHERE IsActive=true  AND Contact.AccountId=:leadslist.Assigned_Dealer__c AND Profile.Name ='Japan Dealer Service Advisor'];
            if (leadslist.Service_Advisor__c != null ){
                userid1 = leadslist.Service_Advisor__c ;
            }
        
        }
        if(UserDealers.isEmpty()){
            isAvailable = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Users are availble to assign'));
        }
        System.debug('>>>>>>> Count ++++' + UserDealers.size());
        System.debug('Userid>>>>>>> ' + userid1);
        boolean set1=false;
        for(Integer i=0; i<UserDealers.size(); i++){
        Wrapperuser wuser= new Wrapperuser ();
           
                wuser.usr=UserDealers[i];
                wuser.isSelected = false; 
            if(i== UserDealers.size()-1 && userid1 == null ){
               userid1= UserDealers[i].id;
            }
             System.debug('User is Selected>>>>>' + wuser.isSelected);
     listwrapperuser.add(wuser);
  }
        return listwrapperuser;
        
        
    }
    /*
    public pageReference doCancel(){
        return null;        
    }
    */
    /* 
    @RemoteAction 
    public Static User changeIdvalue(String struserId)
    {
     
     
       System.debug('Id from remote action-->'+struserId);
       
       // return userStr ;
       return null ;
        
    }
  */
    public  Pagereference AssignLeadtoDealer()
    {
        update  new Lead__c(id=leadid, ownerid=userid1 );    
        return null;        
    }
    
    public class Wrapperuser{
    
    public boolean isSelected {get;set;}
    public user usr {get;set;}
    
    public Wrapperuser()
    {
        isSelected = false;
        usr=new user();
    }
    }
    
}