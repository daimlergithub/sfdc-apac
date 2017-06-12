/*
  Description : This Class will assigen the leads to Dealers
  DevItem : P3.
  Created By: Kiran
  Date: 2016-12-20
  
  ================
  Modification : SFDCJP-SFDCJP-1332.
  Modified my : Venky
  Date : 2017-01-31
  Description : Update query where condition included few profiles in query 
  =================
   ================
  Modification : SFDCJP-SFDCJP-1337.
  Modified my : Venky
  Date : 2017-02-01
  Description : On click of assign button current code is updating owner, Instead of user we have to update Assigned Service Advisor field .
  =================
  
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
        Lead__c leadslist = [select id, Name, Assigned_Dealer__c,Service_Advisor__c,Retail_Contact__r.Retail_Sales_Consultant__c,Retail_Contact__c,Contact__c, Assigned_Dealer__r.Dealer_Sales_Manager__c,RecordType.DeveloperName from Lead__c WHERE id = : leadid LIMIT 1];
        System.debug('Record Type Name>>>>>>' + leadslist.RecordType.DeveloperName);
       if(leadslist.RecordType.DeveloperName == 'Sales_Leads') {
      
        UserDealers  = [select Id, Name, Title, Dealer_Title__c, Dealer_Outlet_Name__c,IsActive, CompanyName, Email 
                                    ,contactId,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from User WHERE IsActive=true  AND Contact.AccountId=:leadslist.Assigned_Dealer__c AND (Profile.Name ='Japan Dealer Sales Manager' OR Profile.Name ='Japan Dealer Company Manager' OR Profile.Name ='Japan Dealer Sales Representative' OR Profile.Name ='Japan Dealer Service Manager' OR Profile.Name ='Japan Dealer Service Advisor' OR Profile.Name ='Campaign Japan Dealer Company Manager')];
                userid1 = leadslist.Retail_Contact__r.Retail_Sales_Consultant__c;
             /*try
        {
           Account_Link__c accLink = [select id, Name, Retail_Sales_Consultant__c,Sales_Representative__c,toRole__c,fromRole__c from Account_Link__c WHERE toRole__c =: leadslist.Contact__c  LIMIT 1];
            if (accLink != null && acclink.Retail_Sales_Consultant__c!= null){
                userid1 = acclink.Retail_Sales_Consultant__c;
            }
        }
        catch(Exception ex)
        {
            
        }*/
        }
        else if(leadslist.RecordType.DeveloperName == 'Aftersales_Leads'){
            UserDealers  = [select Id, Name, Title, Dealer_Title__c, Dealer_Outlet_Name__c,IsActive, CompanyName, Email 
                                    ,contactId,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from User WHERE IsActive=true  AND Contact.AccountId=:leadslist.Assigned_Dealer__c AND (Profile.Name ='Japan Dealer Sales Manager' OR Profile.Name ='Japan Dealer Company Manager' OR Profile.Name ='Japan Dealer Sales Representative' OR Profile.Name ='Japan Dealer Service Manager' OR Profile.Name ='Japan Dealer Service Advisor' OR Profile.Name ='Campaign Japan Dealer Company Manager')];
            try{
                Account_Link__c accLink1 = [select id, Name, Sales_Representative__c,Service_Advisor__c,Retail_Sales_Consultant__c,toRole__c,fromRole__c,RecordType.DeveloperName from Account_Link__c WHERE toRole__c =: leadslist.Contact__c AND Recordtype.DeveloperName = 'Vehicle_External_Link' LIMIT 1];
                if(accLink1 != null && acclink1.Service_Advisor__c != null ){
                    userid1 = acclink1.Service_Advisor__c;
                }
            }catch(Exception Ex){
            
            }
            /*if (leadslist.Service_Advisor__c != null ){
                userid1 = leadslist.Service_Advisor__c ;
            }*/
        
        }
        if(UserDealers.isEmpty()){
            isAvailable = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.No_Users_are_available_to_assign));
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
        update  new Lead__c(id=leadid, Service_Advisor__c=userid1 );    
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